# エラー処理

ほとんどのプログラミング言語と同様に、Rustはプログラマーに特定の方法でエラーを処理させるよう促します。
一般に、エラー処理は、例外と戻り値の2つの大きなカテゴリに分かれています。
錆は戻り値を選択します。

このセクションでは、Rustのエラー処理方法の包括的な扱いを提供するつもりです。
それ以上に、私たちは一度に1つずつエラー処理を導入しようとします。そうすれば、すべてのものがどのように適合しているかについての実用的な知識を得ることができます。

naïvelyを実行すると、Rustのエラー処理が冗長で迷惑になる可能性があります。
このセクションでは、これらの障害ブロックを調べ、標準ライブラリを使用してエラー処理を簡潔かつ人間工学的にする方法を示します。

# 目次

このセクションは非常に長く、ほとんどの場合、最初に和の型と結合子で開始し、Rustがエラー処理を段階的に行う方法を動機付けようとしているからです。
したがって、他の表現型システムでの経験を持つプログラマは、飛び回りたいかもしれません。

* [基礎](#the-basics)
    * [アンラッピングの説明](#unwrapping-explained)
    * [`Option`種類](#the-option-type)
        * [`Option<T>`値の作成](#composing-optiont-values)
    * [`Result`型](#the-result-type)
        * [整数の解析](#parsing-integers)
        * [`Result`型別名イディオム](#the-result-type-alias-idiom)
    * [簡単な間奏：アンラップは悪くない](#a-brief-interlude-unwrapping-isnt-evil)
* [複数のエラータイプの操作](#working-with-multiple-error-types)
    * [`Option`と`Result`](#composing-option-and-result)
    * [コンビネータの限界](#the-limits-of-combinators)
    * [早期返品](#early-returns)
    * [`try!`マクロ](#the-try-macro)
    * [独自のエラータイプを定義する](#defining-your-own-error-type)
* [エラー処理に使用される標準ライブラリ特性](#standard-library-traits-used-for-error-handling)
    * [`Error`特性](#the-error-trait)
    * [`From`特性](#the-from-trait)
    * [本当の`try!`マクロ](#the-real-try-macro)
    * [カスタムエラータイプの作成](#composing-custom-error-types)
    * [図書館の作家のためのアドバイス](#advice-for-library-writers)
* [ケーススタディ：人口データを読み込むプログラム](#case-study-a-program-to-read-population-data)
    * [初期設定](#initial-setup)
    * [引数の解析](#argument-parsing)
    * [論理を書く](#writing-the-logic)
    * [`Box<Error>`エラー処理`Box<Error>`](#error-handling-with-boxerror)
    * [スタンダードから読む](#reading-from-stdin)
    * [カスタムタイプによるエラー処理](#error-handling-with-a-custom-type)
    * [機能の追加](#adding-functionality)
* [短編小説](#the-short-story)

# 基礎

エラー処理は、*ケース分析*を使用して計算が成功したかどうかを判断すると考えることができます。
ご存じのように、人間工学的なエラー処理の鍵は、プログラマがコードを構成可能に保ちながら明示的なケース分析を減らすことです。

コードを構成可能にすることは重要です。なぜなら、そのような要件がなければ、予期せぬことが起こるたびに[`panic`](../../std/macro.panic.html)です。
（`panic`により現在のタスクが巻き戻され、ほとんどの場合、プログラム全体が異常終了します）。次に例を示します。

```rust,should_panic
#// Guess a number between 1 and 10.
#// If it matches the number we had in mind, return `true`. Else, return `false`.
//  1と10の間の数字を推測し`true`。私たちが気にしていた数字と一致する場合は`true`返し`true`。それ以外の場合は`false`返し`false`。
fn guess(n: i32) -> bool {
    if n < 1 || n > 10 {
        panic!("Invalid number: {}", n);
    }
    n == 5
}

fn main() {
    guess(11);
}
```

このコードを実行しようとすると、プログラムは次のようなメッセージでクラッシュします。

```text
thread 'main' panicked at 'Invalid number: 11', src/bin/panic-simple.rs:5
```

ここにもう少し人工的ではない別の例があります。
引数として整数を受け取り、倍精度化して出力するプログラム。

<span id="code-unwrap-double"></span>
```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
#//    let arg: String = argv.nth(1).unwrap(); // error 1
    let arg: String = argv.nth(1).unwrap(); // エラー1
#//    let n: i32 = arg.parse().unwrap(); // error 2
    let n: i32 = arg.parse().unwrap(); // エラー2
    println!("{}", 2 * n);
}
```

このプログラムにゼロ引数（エラー1）を渡すか、最初の引数が整数でない場合（エラー2）、プログラムは最初の例のようにパニックになります。

このエラー処理のスタイルは、中国の店を走っているブルと同様に考えることができます。
牛はどこに行きたいのか分かりますが、その過程ですべてを踏みにじります。

## アンラッピングの説明

前の例では、プログラムが2つのエラー条件のいずれかに達した場合にパニックになると主張しましたが、プログラムには最初の例のように明示的な`panic`コールは含まれていません。
これは、パニックが`unwrap`の呼び出しに埋め込まれているためです。

Rustの中の何かを "unwrap"するのは、"計算の結果を教えてください。エラーがあった場合は、パニックを起こしてプログラムを止めてください"ということです。それを行うには、まず`Option`と`Result`型を調べる必要があります。
これらの両方の型には、`unwrap`というメソッドが定義されています。

### `Option`種類

`Option`タイプは[標準ライブラリで定義されています][5]：

```rust
enum Option<T> {
    None,
    Some(T),
}
```

`Option`型は、Rustの型システムを使用して*不在*の*可能性*を表現する方法です。
型システムへの不在の可能性をコード化することは、コンパイラがプログラマにその不在を処理させるため、重要な概念です。
文字列内の文字を検索しようとする例を見てみましょう：

<span id="code-option-ex-string-find"></span>
```rust
#// Searches `haystack` for the Unicode character `needle`. If one is found, the
#// byte offset of the character is returned. Otherwise, `None` is returned.
//  `haystack`でUnicode文字の`needle`検索します。見つかった場合、文字のバイトオフセットが返されます。それ以外の場合は、`None`が返されます。
fn find(haystack: &str, needle: char) -> Option<usize> {
    for (offset, c) in haystack.char_indices() {
        if c == needle {
            return Some(offset);
        }
    }
    None
}
```

この関数が一致する文字を見つけると、`offset`返すだけではないことに注意してください。
代わりに、`Some(offset)`返します。
`Some`は、`Option`タイプのバリアントまたは*値コンストラクタ*です。
これは、`fn<T>(value: T) -> Option<T>`型の関数と考えることができます。
これに対応して、`None`も引数を持たないことを除いて、値のコンストラクタです。
`None`は`fn<T>() -> Option<T>`型の関数と考えることができます。

これは何のためにも大きな騒ぎのように思えるかもしれませんが、これは物語の半分に過ぎません。
残りの半分は、私たちが書いた`find`関数を*使っ*てい`find`。
ファイル名の拡張子を見つけるためにそれを使ってみましょう。

```rust
# fn find(haystack: &str, needle: char) -> Option<usize> { haystack.find(needle) }
fn main() {
    let file_name = "foobar.rs";
    match find(file_name, '.') {
        None => println!("No file extension found."),
        Some(i) => println!("File extension: {}", &file_name[i+1..]),
    }
}
```

このコードは、[パターンマッチング][1]を使用して、`find`関数によって返された`Option<usize>`に対して*ケース分析*を行います。
実際、ケース分析は、`Option<T>`内に格納された値を取得する唯一の方法です。
これは、プログラマとして、`Option<T>` `Some(t)`が`Some(t)`ではなく`None` `Some(t)` `None`の場合に対処する必要があることを意味します。

しかし、私たちが[previously](#code-unwrap-double)に使った`unwrap`はどうですか？
そこに事例分析はなかった！
代わりに、ケース分析を`unwrap`メソッドの中に入れました。
あなたが望むならそれを自分で定義することができます：

<span id="code-option-def-unwrap"></span>
```rust
enum Option<T> {
    None,
    Some(T),
}

impl<T> Option<T> {
    fn unwrap(self) -> T {
        match self {
            Option::Some(val) => val,
            Option::None =>
              panic!("called `Option::unwrap()` on a `None` value"),
        }
    }
}
```

`unwrap`メソッド*は、ケース分析を抽象化します*。
これはまさに人間工学に基づいた`unwrap`を使用することです。
残念なことに、その`panic!`は、`unwrap`が構成可能でないことを意味します。それは中国の店の雄牛です。

### `Option<T>`値の作成

[前](#code-option-ex-string-find)の[例では](#code-option-ex-string-find)、 `find`を使用してファイル名の拡張子を検出する方法を見てきました。
もちろん、すべてのファイル名にaが付いているわけではありません`.`
そのため、ファイル名には拡張子がない可能性があります。
この*不在の可能性は、* `Option<T>`を使用して型にコード化されます。
言い換えると、コンパイラは、拡張が存在しない可能性に対処するように強制します。
私たちの場合は、そのようなメッセージだけを出力します。

ファイル名の拡張子を取得するのはかなり一般的な操作なので、それを関数に入れるのは理にかなっています：

```rust
# fn find(haystack: &str, needle: char) -> Option<usize> { haystack.find(needle) }
#// Returns the extension of the given file name, where the extension is defined
#// as all characters following the first `.`.
#// If `file_name` has no `.`, then `None` is returned.
// 指定されたファイル名の拡張子を返します。拡張子は、最初の拡張子に続くすべての文字として定義されます`.`。 `file_name`にnoが`file_name`ている場合`.`、 `None`が返されます。
fn extension_explicit(file_name: &str) -> Option<&str> {
    match find(file_name, '.') {
        None => None,
        Some(i) => Some(&file_name[i+1..]),
    }
}
```

（Pro-tip：このコードは使用しないでください。代わりに標準ライブラリの[`extension`](../../std/path/struct.Path.html#method.extension)メソッドを使用してください）。

コードは単純なままですが、気付くべき重要なことは、`find`のタイプが`find`私たちに不在の可能性を考慮させることです。
これは、ファイル名に拡張子が付いていない場合をコンパイラーが誤って忘れてしまうことを意味しないため、良いことです。
一方、毎回`extension_explicit`行ったような明示的なケース分析を行うと、少し面倒なことが起こります。

実際には、中ケース解析`extension_explicit`非常に一般的なパターンに従う：の内部値へのファンクションを*マップ* `Option<T>`オプションがない場合を除き、`None`、その場合には、返さない`None`。

Rustはパラメトリック多形性を持つため、このパターンを抽象化するコンビネータを定義するのは非常に簡単です：

<span id="code-option-map"></span>
```rust
fn map<F, T, A>(option: Option<T>, f: F) -> Option<A> where F: FnOnce(T) -> A {
    match option {
        None => None,
        Some(value) => Some(f(value)),
    }
}
```

実際、`map`は標準ライブラリの`Option<T>` [メソッドとして定義されてい][2]ます。
メソッドとして、それはわずかに異なるシグネチャを持ちます：メソッドは、`self`、 `&self`、または`&mut self`を最初の引数として取ります。

新しいコンビネータを使用して、`extension_explicit`メソッドを書き直して、ケース分析を取り除くことができます：

```rust
# fn find(haystack: &str, needle: char) -> Option<usize> { haystack.find(needle) }
#// Returns the extension of the given file name, where the extension is defined
#// as all characters following the first `.`.
#// If `file_name` has no `.`, then `None` is returned.
// 指定されたファイル名の拡張子を返します。拡張子は、最初の拡張子に続くすべての文字として定義されます`.`。 `file_name`にnoが`file_name`ている場合`.`、 `None`が返されます。
fn extension(file_name: &str) -> Option<&str> {
    find(file_name, '.').map(|i| &file_name[i+1..])
}
```

私たちがよく見かけるもう一つのパターンは、`Option`値が`None`場合にデフォルト値を代入することです。
たとえば、ファイルが存在しない場合でもファイルの拡張子が`rs`であるとプログラムが想定しているとします。
ご想像のように、これについてのケース分析は、ファイル拡張子に固有のものではなく、`Option<T>`動作します：

```rust
fn unwrap_or<T>(option: Option<T>, default: T) -> T {
    match option {
        None => default,
        Some(value) => value,
    }
}
```

上記の`map`と同様に、標準ライブラリの実装は空き関数ではなくメソッドです。

ここでのトリックは、デフォルト値が`Option<T>`内にある可能性のある値と同じ型でなければならないということです。
私たちの場合、それを使うのは簡単ではありません。

```rust
# fn find(haystack: &str, needle: char) -> Option<usize> {
#     for (offset, c) in haystack.char_indices() {
#         if c == needle {
#             return Some(offset);
#         }
#     }
#     None
# }
#
# fn extension(file_name: &str) -> Option<&str> {
#     find(file_name, '.').map(|i| &file_name[i+1..])
# }
fn main() {
    assert_eq!(extension("foobar.csv").unwrap_or("rs"), "csv");
    assert_eq!(extension("foobar").unwrap_or("rs"), "rs");
}
```

（`unwrap_or`は標準ライブラリの`Option<T>` [メソッドとして定義されているので、][3]上で[定義した][3]自立関数の代わりにここで使用します）もっと一般的な[`unwrap_or_else`][4]メソッドをチェックしてください。

特別な注意を払う価値のあるコンビネータがもう1人あります： `and_then`。
これは*、不在*の*可能性*を認める明確な計算を容易に構成する。
たとえば、このセクションのコードの大部分は、ファイル名を指定して拡張子を見つけることです。
これを行うには、まずファイル*パス*から抽出されるファイル名が必要です。
ほとんどのファイルパスはファイル名を持っていますが、*すべて*のファイルパスではありません。
たとえば、`.`
、`..`または`/`。

したがって、私たちは、ファイル*パスを*与えられた拡張子を見つけるという課題に取り組んでいます。
明示的なケース分析から始めましょう：

```rust
# fn extension(file_name: &str) -> Option<&str> { None }
fn file_path_ext_explicit(file_path: &str) -> Option<&str> {
    match file_name(file_path) {
        None => None,
        Some(name) => match extension(name) {
            None => None,
            Some(ext) => Some(ext),
        }
    }
}

fn file_name(file_path: &str) -> Option<&str> {
#  // Implementation elided.
  // 実装は省略されました。
  unimplemented!()
}
```

あなたは事例分析を減らすために`map`コンビネータを使うことができると思うかもしれませんが、そのタイプはあまり適切ではありません...

```rust,ignore
fn file_path_ext(file_path: &str) -> Option<&str> {
#//    file_name(file_path).map(|x| extension(x)) // This causes a compilation error.
    file_name(file_path).map(|x| extension(x)) // これにより、コンパイルエラーが発生します。
}
```

`map`関数は、`extension`関数によって返された値を`Option<_>`中にラップします。`extension`関数自身が`Option<&str>`返すので、式`file_name(file_path).map(|x| extension(x))`実際に`Option<Option<&str>>`

しかし、`file_path_ext`は`Option<&str>`（ `Option<Option<&str>>`ではなく）を返すので、コンパイルエラーが発生します。

入力としてマップで撮影された関数の結果は*、常に*され[てリラップ`Some`](#code-option-map)。
代わりに、`map`ようなものが必要ですが、呼び出し元が`Option<_>`を別の`Option<_>`ラップすることなく直接返すことができます。

一般的な実装は`map`よりも簡単です：

```rust
fn and_then<F, T, A>(option: Option<T>, f: F) -> Option<A>
        where F: FnOnce(T) -> Option<A> {
    match option {
        None => None,
        Some(value) => f(value),
    }
}
```

これで、明示的なケース分析なしで`file_path_ext`関数を書き直すことができます。

```rust
# fn extension(file_name: &str) -> Option<&str> { None }
# fn file_name(file_path: &str) -> Option<&str> { None }
fn file_path_ext(file_path: &str) -> Option<&str> {
    file_name(file_path).and_then(extension)
}
```

サイドノート： `and_then`本質的に`map`ように動作し`map`が、`Option<Option<_>>`ではなく`Option<_>`返します。これは他の言語では`flatmap`として知られています。

`Option`型には[、標準ライブラリで定義され][5]ている他の多くのコンビネータ[があります][5]。
このリストを読み飛ばして、利用可能なものを熟知することは良い考えです。彼らはあなたのケース分析を減らすことができます。
これらのコンビネータに慣れ親しむことで、`Result`ために定義されている（同様のセマンティクスで）ため、配当を支払うことになります。

コンビネータは、明示的なケース分析を減らすため、人間工学に基づいた`Option`ようなタイプを使用します。
彼らは発信者が自らの方法で不在の可能性を扱うことができるので、構成も可能です。
`unwrap`ようなメソッドは、`Option<T>`が`None`場合にパニックになるので選択肢を削除します。

## `Result`型

`Result`型も[標準ライブラリで定義されています][6]：

<span id="code-result-def"></span>
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`Result`型は、より豊富なバージョンの`Option`です。
`Option`ような*不在*の可能性を表現する代わりに、`Result`は*エラー*の可能性を表し*ます*。
通常、この*エラー*は、何らかの計算の実行が失敗した理由を説明するために使用されます。
これは厳密により一般的な`Option`です。
以下の型のエイリアスを考えてみましょう。これは、実際の`Option<T>`と意味的に等価です。

```rust
type Option<T> = Result<T, ()>;
```

これは`Result`第2の型パラメータを常にbe `()`（「単位」または「空タプル」と発音する`()`修正します。
ちょうど1つの値が`()`型に存在します：（`()`。
（はい、タイプと値レベルの用語は同じ表記です！）

`Result`型は、計算において2つの可能な結果のうちの1つを表す方法です。
慣例により、一方の結果は期待されるか、「 `Ok` 」を意味し、他方の結果は予期しないまたは「 `Err` 」を意味する。

`Option`と同様に、`Result`型には標準ライブラリに[定義さ][7]れている[`unwrap`メソッド][7]もあります。
それを定義しよう：

```rust
# enum Result<T, E> { Ok(T), Err(E) }
impl<T, E: ::std::fmt::Debug> Result<T, E> {
    fn unwrap(self) -> T {
        match self {
            Result::Ok(val) => val,
            Result::Err(err) =>
              panic!("called `Result::unwrap()` on an `Err` value: {:?}", err),
        }
    }
}
```

これは[、`Option::unwrap`定義](#code-option-def-unwrap)と事実上同じですが、`panic!`メッセージにエラー値が含まれている点が異なります。
これによりデバッグが容易になりますが、`E`タイプパラメータ（エラータイプを表す）に[`Debug`][8]制約を追加する必要があります。
大多数の型は`Debug`制約を満たす必要があるため、実際にはうまくいく傾向があります。
（型の`Debug`は、その型の値の人間が判読可能な記述を出力する合理的な方法があることを単に意味します）。

さて、例に移りましょう。

### 整数の解析

Rust標準ライブラリは、文字列を整数に変換するのを簡単にします。
実際にはとても簡単なので、次のようなものを書くのはとても魅力的です。

```rust
fn double_number(number_str: &str) -> i32 {
    2 * number_str.parse::<i32>().unwrap()
}

fn main() {
    let n: i32 = double_number("10");
    assert_eq!(n, 20);
}
```

この時点で、あなたは`unwrap`を呼び出すのに懐疑的でなければなりません。
たとえば、文字列が数値として解析されない場合、パニックが発生します。

```text
thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: ParseIntError { kind: InvalidDigit }', /home/rustbuild/src/rust-buildbot/slave/beta-dist-rustc-linux/build/src/libcore/result.rs:729
```

これはむしろ見苦しいものです。もしこれがあなたが使っている図書館の中で起こったのであれば、あなたはわずらわしいかもしれません。
代わりに、私たちは関数のエラーを処理して、呼び出し元に何をすべきかを決定させるべきです。
これは、`double_number`の戻り値の型を変更することを意味します。
しかし何に？
つまり、標準ライブラリの[`parse` method][9]シグネチャを調べる必要があります。

```rust,ignore
impl str {
    fn parse<F: FromStr>(&self) -> Result<F, F::Err>;
}
```

うーん。
だから少なくとも`Result`を使う必要があることは分かっている。
確かに、これは`Option`を返す可能性があります。
結局のところ、文字列は数値として解析するか、そうではないのですか？
これは確かに合理的な方法ですが、インプリメンテーションは文字列が整数として解析されなかった*理由を*内部的に区別します。
（それは大きすぎるか小さすぎる、空の文字列、無効な数字、だかどうか。）ので、使用して`Result`我々は単によりも多くの情報を提供したいので、理にかなっている「が存在しないことを。」我々は、構文解析が失敗した*理由を*言いたいです。
`Option`と`Result`間の選択に直面したとき、この推論の行をエミュレートしようとする必要があります。
詳細なエラー情報を提供できる場合は、おそらく必要です。
（後で詳しく説明します）

はい、戻り値の型はどうやって書くのですか？
上で定義した`parse`メソッドは、標準ライブラリで定義されているすべての異なる数値型に対して汎用です。
私たちは機能を一般的にすることもできますが、おそらくそうすべきです。
私たちは`i32`だけを気にするので[、`FromStr`実装](../../std/primitive.i32.html)を[見つける](../../std/primitive.i32.html)必要があり[ます](../../std/primitive.i32.html)（あなたのブラウザーで "FromStr"の`CTRL-F`を実行）し、[関連するタイプ][10] `Err`を[調べる](../../std/primitive.i32.html)必要があります。
私たちは具体的なエラータイプを見つけるためにこれを行いました。
この場合、[`std::num::ParseIntError`](../../std/num/struct.ParseIntError.html)です。
最後に、関数を書き直すことができます：

```rust
use std::num::ParseIntError;

fn double_number(number_str: &str) -> Result<i32, ParseIntError> {
    match number_str.parse::<i32>() {
        Ok(n) => Ok(2 * n),
        Err(err) => Err(err),
    }
}

fn main() {
    match double_number("10") {
        Ok(n) => assert_eq!(n, 20),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

これはやや良いですが、今はもっとコードを書いています！
事例分析がもう一度私たちに咬まれた。

救助者とのコンビニエーター！
`Option`と同様に、`Result`はメソッドとして定義された多数のコンビネータがあります。
`Result`と`Option`間には一般的なコンビネータの大きな交差点があります。
特に、`map`はその交差点の一部です：

```rust
use std::num::ParseIntError;

fn double_number(number_str: &str) -> Result<i32, ParseIntError> {
    number_str.parse::<i32>().map(|n| 2 * n)
}

fn main() {
    match double_number("10") {
        Ok(n) => assert_eq!(n, 20),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

[`unwrap_or`](../../std/result/enum.Result.html#method.unwrap_or)と[`and_then`](../../std/result/enum.Result.html#method.and_then)を含む通常の容疑者がすべて`Result`にあり[`and_then`](../../std/result/enum.Result.html#method.and_then)。
以降さらに、`Result`第二型パラメータを有している、などのみエラータイプに影響コンビネータ、ある[`map_err`](../../std/result/enum.Result.html#method.map_err)（代わりの`map`）と[`or_else`](../../std/result/enum.Result.html#method.or_else)（代わりに`and_then`）。

### `Result`型別名イディオム

標準ライブラリでは、`Result<i32>`ような型がよく見えます。
しかし、[私たちは`Result`](#code-result-def)に2つの型パラメータを持つよう[に定義しました](#code-result-def)。
どのように指定するだけで取り除くことができますか？
キーは、型パラメータの1つを特定の型に*固定*する`Result`型のエイリアスを定義することです。
通常、固定タイプはエラータイプです。
たとえば、前の例の解析用の整数は次のように書き直すことができます：

```rust
use std::num::ParseIntError;
use std::result;

type Result<T> = result::Result<T, ParseIntError>;

fn double_number(number_str: &str) -> Result<i32> {
    unimplemented!();
}
```

なぜ我々はこれを行うだろうか？
`ParseIntError`返す関数がたくさんある場合は、常に`ParseIntError`を使用するエイリアスを定義して、常に書き出す必要はありません。

このイディオムが標準ライブラリで使用される最も顕著な場所は、[`io::Result`](../../std/io/type.Result.html)です。
通常、`io::Result<T>`書くと、`std::result`プレーンな定義ではなく、`io`モジュールのタイプエイリアスを使用していることがわかります。
（このイディオムは[`fmt::Result`](../../std/fmt/type.Result.html)も使用されます）。

## 簡単な間奏：アンラップは悪くない

もしあなたがフォローしてきたのであれば、私はあなたのプログラムを`panic`て中止するかもしれない`unwrap`ようなメソッドを呼び出すことに対してかなり厳しい行を見たことに気づいたかもしれません。
*一般的に言えば*、これは良いアドバイスです。

しかし、`unwrap`は依然として慎重に使用することができます。
`unwrap`使用を正当に正当化するものは多少グレーの領域であり、合理的な人々は同意できません。
私はこの問題に関する私の*意見*を要約します。

* **例では、素早く 'n'のダーティコードです。**
   時には例や簡単なプログラムを書いていることもあり、エラー処理は単純ではありません。
   このようなシナリオでは、`unwrap`の利便性を`unwrap`することは難しいため、非常に魅力的です。
* **パニックがプログラムのバグを示すとき。**
   あなたのコードのインバリアントが特定のケースが起こらないようにする（空のスタックからポップするなど）場合、パニックが許されます。
   これは、プログラムのバグを公開するためです。
   これは明示的に`assert!`ことができます。`assert!`失敗した場合などです。配列へのインデックスが範囲外だったためです。

おそらく網羅的なリストではないでしょう。
さらに、`Option`を使用する場合、[`expect`](../../std/option/enum.Option.html#method.expect)メソッドを使用するほうがよい場合があります。
`expect`はあなたが`expect`するメッセージを出力する点を除いて、`unwrap`と全く同じことを行います。
これにより、"`None`値にアンラップされた"の代わりにメッセージが表示されるため、結果的なパニックが扱いやすくなります。

私の助言はこれにまでこだわります。良い判断をしてください。
「Xはしない」または「Yは有害とみなされる」という言葉が私の文章には現れない理由があります。
すべてのことにトレードオフがあります。ユースケースに受け入れられるものを判断するのはプログラマとしての任務です。
私の目標は、できるだけ正確にトレードオフを評価するのに役立つだけです。

Rustのエラー処理の基礎について説明し、アンラッピングについて説明したので、標準ライブラリの詳細を調べてみましょう。

# 複数のエラータイプの操作

これまでは、すべてが`Option<T>`または`Result<T, SomeError>`いずれかのエラー処理を見てきました。
しかし、`Option`と`Result`両方を持っているとどうなりますか？
または、`Result<T, Error1>`および`Result<T, Error2>`どうなりますか？
*個別のエラータイプの処理*は、私たちの前で次の課題です。このセクションの残りの部分では、主なテーマになります。

## `Option`と`Result`

今までは、`Option`に対して定義されたコンビネータと`Result`に対して定義されたコンビネータについて説明しました。
これらのコンビネータを使用して、明示的なケース分析を行うことなく、異なる計算の結果を構成することができます。

もちろん、実際のコードでは、物事は常にきれいではありません。
`Option`と`Result`タイプが混在していることがあります。
明示的なケース分析に頼らなければならないのですか、あるいはコンビネータを使用し続けることができますか？

ここでは、このセクションの最初の例の1つに戻ってみましょう。

```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
#//    let arg: String = argv.nth(1).unwrap(); // error 1
    let arg: String = argv.nth(1).unwrap(); // エラー1
#//    let n: i32 = arg.parse().unwrap(); // error 2
    let n: i32 = arg.parse().unwrap(); // エラー2
    println!("{}", 2 * n);
}
```

`Option`、 `Result`、およびそれらのさまざまなコンビネータに関する新しい知識があれば、エラーを正しく処理し、エラーがあればプログラムがパニックに陥らないように書き直してください。

ここでのトリッキーな側面は、`argv.nth(1)`は`Option`を生成し、`arg.parse()`は`Result`生成するということです。
これらは直接構成可能ではありません。
`Option`と`Result`両方に直面した場合、*通常*は`Option`を`Result`に変換します。
私たちの場合、（`env::args()`）コマンドラインパラメータがないということは、ユーザがプログラムを正しく呼び出さなかったことを意味します。
エラーを記述するために`String`を使用できます。
やってみよう：

<span id="code-error-double-string"></span>
```rust
use std::env;

fn double_arg(mut argv: env::Args) -> Result<i32, String> {
    argv.nth(1)
        .ok_or("Please give at least one argument".to_owned())
        .and_then(|arg| arg.parse::<i32>().map_err(|err| err.to_string()))
        .map(|n| 2 * n)
}

fn main() {
    match double_arg(env::args()) {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

この例ではいくつか新しいことがあります。
最初は、[`Option::ok_or`](../../std/option/enum.Option.html#method.ok_or)コンビネータの使用です。
これは`Option`を`Result`に変換する1つの方法です。
この変換では、`Option`が`None`場合に使用するエラーを指定する必要があります。
私たちが見た他のコンビネータと同様に、その定義は非常に簡単です：

```rust
fn ok_or<T, E>(option: Option<T>, err: E) -> Result<T, E> {
    match option {
        Some(val) => Ok(val),
        None => Err(err),
    }
}
```

ここで使用される新しいコンビネータは、[`Result::map_err`](../../std/result/enum.Result.html#method.map_err)です。
`Result::map`と似ていますが、関数を`Result`値の*エラー*部分にマップする点が異なります。
`Result`が`Ok(...)`値である場合、`Result`は変更されずに戻されます。

ここで`map_err`を使用して`map_err`ます。なぜなら、エラーの種類は同じである必要があるから`map_err`を使用しているため`and_then`）。
`Option<String>`（ `argv.nth(1)`）を`Result<String, String>`に変換することを選択したので、`ParseIntError`を`arg.parse()`から`String`も変換する必要があります。

## コンビネータの限界

IOを行い、入力を解析することは非常に一般的な作業であり、私が個人的にRustで多く行ったことです。
したがって、私たちはIOとさまざまな解析ルーチンを使用して（そして引き続き使用して）エラー処理を例示します。

簡単に始めましょう。
私たちは、ファイルを開き、すべての内容を読み込み、その内容を数値に変換することを任されています。
次に、`2`倍して出力します。

私はあなたに`unwrap`を使わないように説得しようとしましたが、最初に`unwrap`を使ってコードを書いておくと便利です。
これにより、エラー処理の代わりに問題に集中することができ、適切なエラー処理が必要な箇所が表示されます。
そこから始めましょう。そこで、コードのハンドルを取得して、より良いエラー処理を使用するようにリファクタリングします。

```rust,should_panic
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> i32 {
#//    let mut file = File::open(file_path).unwrap(); // error 1
    let mut file = File::open(file_path).unwrap(); // エラー1
    let mut contents = String::new();
#//    file.read_to_string(&mut contents).unwrap(); // error 2
    file.read_to_string(&mut contents).unwrap(); // エラー2
#//    let n: i32 = contents.trim().parse().unwrap(); // error 3
    let n: i32 = contents.trim().parse().unwrap(); // エラー3
    2 * n
}

fn main() {
    let doubled = file_double("foobar");
    println!("{}", doubled);
}
```

（NB `AsRef<Path>`は[、`std::fs::File::open`使用されている境界と同じ境界線であるため使用され`std::fs::File::open`](../../std/fs/struct.File.html#method.open)。これにより、ファイルパスとしてあらゆる種類の文字列を使用する人間工学になります。

ここで発生する可能性がある3つの異なるエラーがあります。

1. ファイルを開く際に問題が発生しました。
2. ファイルからデータを読み取る際に問題が発生しました。
3. データを数値として解析する問題。

最初の2つの問題は、[`std::io::Error`](../../std/io/struct.Error.html)型を介して記述されます。
これは、[`std::fs::File::open`](../../std/fs/struct.File.html#method.open)と[`std::io::Read::read_to_string`](../../std/io/trait.Read.html#method.read_to_string)の戻り値の型のために[`std::io::Read::read_to_string`](../../std/io/trait.Read.html#method.read_to_string)ます。
（どちらも使用することに注意してください[`Result`タイプエイリアスイディオムは、](#the-result-type-alias-idiom)あなたが上でクリックした場合。前述の`Result`タイプ、あなたはよ[タイプの別名を参照](../../std/io/type.Result.html)し、その結果、基礎となる`io::Error`タイプ。）第三の問題は次のように記述され[`std::num::ParseIntError`](../../std/num/struct.ParseIntError.html)型。
`io::Error`型は、特に標準ライブラリ全体に*広がっ*ています。
あなたはそれを何度も見ます。

`file_double`関数をリファクタリングするプロセスを開始しましょう。
この機能をプログラムの他のコンポーネントと組み合わせるには、上記のエラー条件のいずれかが満たされている場合、パニックにはなり*ません*。
効果的には、操作が失敗した場合に関数が*エラー*を*返す*必要*があります*。
私たちの問題は、`file_double`の戻り値の型が`i32`であるため、エラーを報告する有用な方法はありません。
したがって、戻り値の型を`i32`から別のものに変更することから始めなければなりません。

最初に決定する必要があるのは、`Option`または`Result`を使用するかどうかです。
我々は確かに非常に簡単に`Option`使用することができます。
3つのエラーのいずれかが発生した場合、単に`None`返すことができます。
これ*はうまくいってパニックよりも優れていますが、もっとうまく*いくことができます。
代わりに、発生したエラーについていくつかの詳細を渡す必要があります。
*エラー*の*可能性*を表現したいので、`Result<i32, E>`使うべきです。
しかし、`E`どうなるべきですか？
2つの*異なる*タイプのエラーが発生する可能性があるため、それらを共通のタイプに変換する必要があります。
そのようなタイプの1つは`String`です。
それが私たちのコードにどのように影響するのかを見てみましょう：

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    File::open(file_path)
         .map_err(|err| err.to_string())
         .and_then(|mut file| {
              let mut contents = String::new();
              file.read_to_string(&mut contents)
                  .map_err(|err| err.to_string())
                  .map(|_| contents)
         })
         .and_then(|contents| {
              contents.trim().parse::<i32>()
                      .map_err(|err| err.to_string())
         })
         .map(|n| 2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

このコードは少し毛深いです。
このようなコードが書くのが簡単になるには、かなりの練習が必要です。
私たちが書いているのは、*そのタイプに従うことです*。
`file_double`の戻り値の型を`Result<i32, String>`に変更するとすぐに、適切なコンビネータを探す必要がありました。
この例では、3つの異なるコンビネータを使用しました： `and_then`、 `map`、および`map_err`。

`and_then`は、各計算がエラーを返すことができる複数の計算を連鎖させるために使用されます。
ファイルを開いた後、失敗する可能性のある計算がもう2つあります：ファイルからの読み取りと内容を数値として解析することです。
対応して、`and_then`への呼び出しが2回あります。

`map`は、`Result` `Ok(...)`値に関数を適用するために使用されます。
たとえば、最後に`map`呼び出すと、`Ok(...)`値（`i32`）に`2`が乗算されます。
そのポイントの前にエラーが発生した場合、`map`がどのように定義されているかにより、この操作はスキップされます。

`map_err`はこのすべてのことを`map_err`トリックです。
`map_err`は、`Result` `Err(...)`値に関数を適用する点を除いて`map`と似ています。
この場合、すべてのエラーを1つの型に変換する必要があります。`String`。
`io::Error`と`num::ParseIntError`どちらも`ToString`を実装している`to_string()`、 `to_string()`メソッドを呼び出して変換することができます。

そのすべてが言われて、コードはまだ毛深いです。
コンビネータの使用をマスターすることは重要ですが、それらには限界があります。
別のアプローチ、早期復帰を試してみましょう。

## 早期返品

私は、前のセクションのコードを取り上げ、*早期復帰*を使用して書き直したいと思い*ます*。
早期返品により、早期に機能を終了することができます。
別のクロージャの内側から`file_double`早い段階で戻ることはできないので、明示的なケース分析に戻す必要があります。

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = match File::open(file_path) {
        Ok(file) => file,
        Err(err) => return Err(err.to_string()),
    };
    let mut contents = String::new();
    if let Err(err) = file.read_to_string(&mut contents) {
        return Err(err.to_string());
    }
    let n: i32 = match contents.trim().parse() {
        Ok(n) => n,
        Err(err) => return Err(err.to_string()),
    };
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

合理的な人は、このコードがコンビネータを使用するコードよりも優れているかどうかについては意見を異にすることができますが、コンビネータのアプローチに精通していない場合は、
これは、`match`と`if let`を使用した明示的なケース分析を使用`if let`ます。
エラーが発生すると、関数の実行が停止し、エラーが返されます（文字列に変換されます）。

しかしこれは後退していませんか？
以前は、人間工学的なエラー処理の鍵は、明示的なケース分析を減らすことですが、ここでは明示的なケース分析に戻しました。
これは、明示的なケース分析を低減するための*複数の*方法がありますが、判明しました。
コンビネータだけが唯一の方法ではありません。

## `try!`マクロ

Rustのエラー処理の基本は`try!`マクロです。
`try!`マクロはコンバイナのようなケース分析を抽象化しますが、コンビネータとは異なり、*コントロールフロー*も抽象化*します*。
つまり、上記の*早期復帰*パターンを抽象化することができます。

`try!`マクロの簡単な定義を以下に示します。

<span id="code-try-def-simple"></span>
```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

（[実際の定義](../../std/macro.try.html)はちょっと洗練されていますが、後でそれを扱います）。

`try!`マクロを使用する`try!`、最後の例を簡単に簡単にすることができます。
ケース分析と早期返品を行うので、読みやすい、より厳密なコードが得られます。

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = try!(File::open(file_path).map_err(|e| e.to_string()));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(|e| e.to_string()));
    let n = try!(contents.trim().parse::<i32>().map_err(|e| e.to_string()));
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

[`try!`定義を](#code-try-def-simple)考えると[、](#code-try-def-simple) `map_err`コールはまだ必要[`try!`](#code-try-def-simple)。
これは、エラータイプを引き続き`String`に変換する必要があるためです。
良いニュースは、私たちが間もなくそれらの`map_err`呼び出しを削除する方法を学ぶことです！
悪いニュースは、`map_err`呼び出しを削除する前に、標準ライブラリの重要な特性についてもう少し学ぶ必要があることです。

## 独自のエラータイプを定義する

標準的なライブラリのエラー特性のいくつかを知る前に、前の例のエラータイプとして`String`の使用を取り除いて、このセクションをまとめておきたいと思います。

以前の例で行ったように`String`を使用すると、エラーを文字列に変換したり、現場で文字列として独自のエラーを作成したりすることが容易になるので便利です。
しかし、エラーのために`String`を使用することにはいくつかの欠点があります。

最初の欠点は、エラーメッセージがコードを乱雑にする傾向があることです。
他の場所でエラーメッセージを定義することは可能ですが、あなたが異常に訓練されていない限り、エラーメッセージをコードに埋め込むことは非常に魅力的です。
実際、これ[previous example](#code-error-double-string)ではこれを正確に行いました。

第2の重要な欠点は、`String`が*損失であること*です。
つまり、すべてのエラーが文字列に変換された場合、呼び出し側に渡すエラーは完全に不透明になります。
呼び出し側が`String`エラーで行うことができる唯一の妥当なことは、ユーザーに表示することです。
確かに、エラーの種類を判断するために文字列を検査することは堅牢ではありません。
（確かに、この欠点は、アプリケーションとは対照的に、図書館の中ではるかに重要です。）

たとえば、`io::Error`型は、IO操作中に何が問題になったかを表す*構造化データ*である[`io::ErrorKind`](../../std/io/enum.ErrorKind.html)埋め込みます。
これは、エラーに応じて異なる反応を起こす可能性があるため、重要です。
（例えば、A `BrokenPipe`エラーは、`NotFound`エラーがエラーコードで終了してユーザにエラーを表示している間にプログラムを正常に終了することを意味するかもしれません）`io::ErrorKind`と、呼び出し側はケース分析これは、`String`内部でエラーの詳細を解説しようとするよりも厳密に優れています。

前述のファイルから整数を読み込む例では、エラータイプとして`String`を使用する代わりに、*構造化データの*エラーを表す独自のエラータイプを定義することができます。
発信者が詳細を調べたい場合、根本的なエラーから情報を削除しないように努めます。

*多くの可能性*を表現する理想的な方法は、`enum`を使って独自の和型を定義することです。
私たちの場合、エラーは`io::Error`または`num::ParseIntError`いずれかであるため、自然な定義が生成されます。

```rust
use std::io;
use std::num;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 私たちは、派生`Debug`すべての種類は、おそらく派生する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

私たちのコードを調整するのはとても簡単です。
エラーを文字列に変換するのではなく、対応する値コンストラクタを使用して`CliError`型に変換するだけです。

```rust
# #[derive(Debug)]
# enum CliError { Io(::std::io::Error), Parse(::std::num::ParseIntError) }
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path).map_err(CliError::Io));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(CliError::Io));
    let n: i32 = try!(contents.trim().parse().map_err(CliError::Parse));
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

ここでの唯一の変更は、`map_err(CliError::Io)`または`map_err(CliError::Parse)` `map_err(|e| e.to_string())`切り替えること`map_err(|e| e.to_string())`エラーを文字列に変換します`map_err(CliError::Parse)`。
*呼び出し元*は、ユーザーに報告する詳細レベルを決定します。
実際には、Error型として`String`を使用すると、Errorを記述する*構造化データ*に加えて、`CliError`が前のようにすべての便利さを呼び出し元に与えるような、カスタム`enum`エラー型を使用しながら呼び出し元から選択肢を削除します。

経験則は独自のエラータイプを定義することですが、特にアプリケーションを作成している場合は、`String`エラータイプをピンチで処理します。
ライブラリを作成する場合は、呼び出し元から不必要な選択肢を削除しないように、独自のエラータイプを定義することを強く推奨します。

# エラー処理に使用される標準ライブラリ特性

標準ライブラリは、エラー処理のために[`std::error::Error`](../../std/error/trait.Error.html)と[`std::convert::From`](../../std/convert/trait.From.html) 2つの不可欠な特性を定義しています。
`Error`は一般的にエラーを一般的に記述するために設計されていますが、`From`特性は2つの異なるタイプ間で値を変換するためのより一般的な役割を果たします。

