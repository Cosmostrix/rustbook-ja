# 誤り処理

ほとんどの演譜言語と同様に、Rustは演譜師に特定の方法で誤りを処理させるよう促します。
一般に、誤り処理は、例外と戻り値の2つの大きな分類に分かれています。
Rustは戻り値を選択します。

この章では、Rustの誤り処理方法の包括的な扱いを提供するつもりです。
それ以上に、一度に1つずつ誤り処理を導入しようとします。そうすれば、すべてのものがどのように適合しているかについての実用的な知識を得ることができます。

バカ正直に行うすると、Rustの誤り処理が冗長でわずらわしくなる可能性があります。
この章では、これらの障害段落を調べ、標準譜集を使用して誤り処理を簡潔かつ使い勝手を改善する方法を示します。

# 目次

この章は非常に長く、ほとんどの場合、最初に和型と組子で開始し、Rustが誤り処理を段階的に行う方法を動機付けようとしているからです。
したがって、他の式型システムでの経験を持つ演譜師は、飛び回りたいかもしれません。

* [基礎](#the-basics)
    * [つけはがしの説明](#unwrapping-explained)
    * [`Option`種類](#the-option-type)
        * [`Option<T>`値の作成](#composing-optiont-values)
    * [`Result`型](#the-result-type)
        * [整数の解析](#parsing-integers)
        * [`Result`型別名慣例](#the-result-type-alias-idiom)
    * [簡単な間奏。はがしは悪くない](#a-brief-interlude-unwrapping-isnt-evil)
* [複数の誤り型の操作](#working-with-multiple-error-types)
    * [`Option`と`Result`](#composing-option-and-result)
    * [組子の限界](#the-limits-of-組子)
    * [早期復帰](#early-returns)
    * [`try!`マクロ](#the-try-macro)
    * [独自の誤り型を定義する](#defining-your-own-error-type)
* [誤り処理に使用される標準譜集特性](#standard-library-traits-used-for-error-handling)
    * [`Error`特性](#the-error-trait)
    * [`From`特性](#the-from-trait)
    * [本当の`try!`マクロ](#the-real-try-macro)
    * [独自の誤り型の作成](#composing-custom-error-types)
    * [譜集の作家のためのアドバイス](#advice-for-library-writers)
* [事例で学ぶ。人口データを読み込む算譜](#case-study-a-program-to-read-population-data)
    * [初期設定](#initial-setup)
    * [引数の解析](#argument-parsing)
    * [論理を書く](#writing-the-logic)
    * [`Box<Error>`誤り処理`Box<Error>`](#error-handling-with-boxerror)
    * [標準入力から読む](#reading-from-stdin)
    * [独自の型による誤り処理](#error-handling-with-a-custom-type)
    * [機能の追加](#adding-functionality)
* [短編小説](#the-short-story)

# 基礎

誤り処理は、*場合分け*を使用して計算が成功したかどうかを判断すると考えることができます。
ご存じのように、人間工学的な誤り処理の鍵は、演譜師が譜面を構成可能に保ちながら明示的な場合分けを減らすことです。

譜面を構成可能にすることは重要です。なぜなら、そのような要件がなければ、予期せぬことが起こるたびに[`panic`](../../std/macro.panic.html)です。
（`panic`により現在の仕事が巻き戻され、ほとんどの場合、算譜全体が異常終了します）。次に例を示します。

```rust,should_panic
#// Guess a number between 1 and 10.
#// If it matches the number we had in mind, return `true`. Else, return `false`.
//  1と10の間の数字を推測し`true`。気にしていた数字と一致する場合は`true`返し`true`。それ以外の場合は`false`返し`false`。
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

この譜面を実行しようとすると、算譜は次のようなメッセージで異常終了します。

```text
thread 'main' panicked at 'Invalid number: 11', src/bin/panic-simple.rs:5
```

ここにもう少し人工的ではない別の例があります。
引数として整数を受け取り、倍精度化して出力する算譜。

<span id="code-unwrap-double"></span>
```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
#//    let arg: String = argv.nth(1).unwrap(); // error 1
    let arg: String = argv.nth(1).unwrap(); // 誤り1
#//    let n: i32 = arg.parse().unwrap(); // error 2
    let n: i32 = arg.parse().unwrap(); // 誤り2
    println!("{}", 2 * n);
}
```

この算譜にゼロ引数（誤り1）を渡すか、最初の引数が整数でない場合（誤り2）、算譜は最初の例のようにパニックになります。

この誤り処理のスタイルは、中国の店を走っているブルと同様に考えることができます。
牛はどこに行きたいのか分かりますが、その過程ですべてを踏みにじります。

## つけはがしの説明

前の例では、算譜が2つの誤り条件のいずれかに達した場合にパニックになると主張しましたが、算譜には最初の例のように明示的な`panic`呼び出しは含まれていません。
これは、パニックが`unwrap`の呼び出しに埋め込まれているためです。

Rustの中の何かを "unwrap"するのは、"計算の結果を教えてください。誤りがあった場合は、パニックを起こして算譜を止めてください"ということです。それを行うには、まず`Option`と`Result`型を調べる必要があります。
これらの両方の型には、`unwrap`という操作法が定義されています。

### `Option`種類

`Option`型は[標準譜集で定義されています][5]。

```rust
enum Option<T> {
    None,
    Some(T),
}
```

`Option`型は、Rustの型システムを使用して*不在*の*可能性*を式する方法です。
型システムへの不在の可能性を譜面化することは、製譜器が演譜師にその不在を処理させるため、重要な概念です。
文字列内の文字を検索しようとする例を見てみましょう。

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

この機能が一致する文字を見つけると、`offset`返すだけではないことに注意してください。
代わりに、`Some(offset)`返します。
`Some`は、`Option`型の場合値または*値構築子*です。
これは、`fn<T>(value: T) -> Option<T>`型の機能と考えることができます。
これに対応して、`None`も引数を持たないことを除いて、値の構築子です。
`None`は`fn<T>() -> Option<T>`型の機能と考えることができます。

これは何のためにも大きな騒ぎのように思えるかもしれませんが、これは物語の半分に過ぎません。
残りの半分は、書いた`find`機能を*使っ*てい`find`。
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

この譜面は、[模式照合][1]を使用して、`find`機能によって返された`Option<usize>`に対して*場合分け*を行います。
実際、場合分けは、`Option<T>`内に格納された値を取得する唯一の方法です。
これは、演譜師として、`Option<T>` `Some(t)`が`Some(t)`ではなく`None` `Some(t)` `None`の場合に対処する必要があることを意味します。

しかし、[previously](#code-unwrap-double)に使った`unwrap`はどうでしょうか？　
そこに事例分析はなかった！　
代わりに、場合分けを`unwrap`操作法の中に入れました。
あなたが望むならそれを自分で定義することができます。

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

`unwrap`操作法*は、場合分けを抽象化します*。
これはまさに使い勝手のよい`unwrap`を使用することです。
残念なことに、その`panic!`は、`unwrap`が構成可能でないことを意味します。それは中国の店の雄牛です。

### `Option<T>`値の作成

[前](#code-option-ex-string-find)の[例では](#code-option-ex-string-find)、 `find`を使用してファイル名の拡張子を検出する方法を見てきました。
もちろん、すべてのファイル名にaが付いているわけではありません`.`
そのため、ファイル名には拡張子がない可能性があります。
この*不在の可能性は、* `Option<T>`を使用して型に譜面化されます。
言い換えると、製譜器は、拡張が存在しない可能性に対処するように強制型変換します。
場合は、そのようなメッセージだけを出力します。

ファイル名の拡張子を取得するのはかなり一般的な操作なので、それを機能に入れるのは理にかなっています。

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

（ひとこと。この譜面は使用しないでください。代わりに標準譜集の[`extension`](../../std/path/struct.Path.html#method.extension)操作法を使用してください）。

譜面は単純なままですが、気付くべき重要なことは、`find`の型が`find`私たちに不在の可能性を考慮させることです。
これは、ファイル名に拡張子が付いていない場合を製譜器ーが誤って忘れてしまうことを意味しないため、良いことです。
一方、毎回`extension_explicit`行ったような明示的な場合分けを行うと、少し面倒なことが起こります。

実際には、中ケース解析`extension_explicit`非常に一般的なパターンに従う。の内部値への機能を*マップ* `Option<T>`選択肢がない場合を除き、`None`、その場合には、返さない`None`。

Rustはパラメータ多相性を持つため、このパターンを抽象化する組子を定義するのは非常に簡単です。

<span id="code-option-map"></span>
```rust
fn map<F, T, A>(option: Option<T>, f: F) -> Option<A> where F: FnOnce(T) -> A {
    match option {
        None => None,
        Some(value) => Some(f(value)),
    }
}
```

実際、`map`は標準譜集の`Option<T>` [操作法として定義されてい][2]ます。
操作法として、それはわずかに異なる型指示を持ちます。操作法は、`self`、 `&self`、または`&mut self`を最初の引数として取ります。

新しい組子を使用して、`extension_explicit`操作法を書き直して、場合分けを取り除くことができます。

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

よく見かけるもう一つのパターンは、`Option`値が`None`場合に黙用値を代入することです。
たとえば、ファイルが存在しない場合でもファイルの拡張子が`rs`であると算譜が想定しているとします。
ご想像のように、これについての場合分けは、ファイル拡張子に固有のものではなく、`Option<T>`動作します。

```rust
fn unwrap_or<T>(option: Option<T>, default: T) -> T {
    match option {
        None => default,
        Some(value) => value,
    }
}
```

上記の`map`と同様に、標準譜集の実装は空き機能ではなく操作法です。

ここでのトリックは、黙用値が`Option<T>`内にある可能性のある値と同じ型でなければならないということです。
場合、それを使うのは簡単ではありません。

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

（`unwrap_or`は標準譜集の`Option<T>` [操作法として定義されているので、][3]上で[定義した][3]自立機能の代わりにここで使用します）もっと一般的な[`unwrap_or_else`][4]操作法をチェックしてください。

特別な注意を払う価値のある組子がもう１つあります。 `and_then`。
これは*、不在*の*可能性*を認める明確な計算を容易に構成します。
たとえば、この章の譜面の大部分は、ファイル名を指定して拡張子を見つけることです。
これを行うには、まずファイル*パス*から抽出されるファイル名が必要です。
ほとんどのファイルパスはファイル名を持っていますが、*すべて*のファイルパスではありません。
たとえば、`.`
、`..`または`/`。

したがって、ファイル*パスを*与えられた拡張子を見つけるという課題に取り組んでいます。
明示的な場合分けから始めましょう。

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

あなたは事例分析を減らすために`map`組子を使うことができると思うかもしれませんが、その型はあまり適切ではありません...

```rust,ignore
fn file_path_ext(file_path: &str) -> Option<&str> {
#//    file_name(file_path).map(|x| extension(x)) // This causes a compilation error.
    file_name(file_path).map(|x| extension(x)) // これにより、製譜誤りが発生します。
}
```

`map`機能は、`extension`機能によって返された値を`Option<_>`中に包みます。`extension`機能自身が`Option<&str>`返すので、式`file_name(file_path).map(|x| extension(x))`実際に`Option<Option<&str>>`

しかし、`file_path_ext`は`Option<&str>`（ `Option<Option<&str>>`ではなく）を返すので、製譜誤りが発生します。

入力としてマップで捕捉された機能の結果は*、常に*され[て包み直し`Some`](#code-option-map)。
代わりに、`map`ようなものが必要ですが、呼び出し元が`Option<_>`を別の`Option<_>`包むことなく直接返すことができます。

一般的な実装は`map`よりも簡単です。

```rust
fn and_then<F, T, A>(option: Option<T>, f: F) -> Option<A>
        where F: FnOnce(T) -> Option<A> {
    match option {
        None => None,
        Some(value) => f(value),
    }
}
```

これで、明示的な場合分けなしで`file_path_ext`機能を書き直すことができます。

```rust
# fn extension(file_name: &str) -> Option<&str> { None }
# fn file_name(file_path: &str) -> Option<&str> { None }
fn file_path_ext(file_path: &str) -> Option<&str> {
    file_name(file_path).and_then(extension)
}
```

はしがき。 `and_then`本質的に`map`ように動作し`map`が、`Option<Option<_>>`ではなく`Option<_>`返します。これは他の言語では`flatmap`として知られています。

`Option`型には[、標準譜集で定義され][5]ている他の多くの組子[があります][5]。
このリストを読み飛ばして、利用可能なものを熟知することは良い考えです。それらはあなたの場合分けを減らすことができます。
これらの組子に慣れ親しむことで、`Result`ために定義されている（同様の意味論で）ため、配当を支払うことになります。

組子は、明示的な場合分けを減らすため、使い勝手のよい`Option`ような型を使用します。
それらは発信者が自らの方法で不在の可能性を扱うことができるので、構成も可能です。
`unwrap`ような操作法は、`Option<T>`が`None`場合にパニックになるので選択肢を削除します。

## `Result`型

`Result`型も[標準譜集で定義されています][6]。

<span id="code-result-def"></span>
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`Result`型は、より豊富な版の`Option`です。
`Option`ような*不在*の可能性を式する代わりに、`Result`は*誤り*の可能性を表し*ます*。
通常、この*誤り*は、何らかの計算の実行が失敗した理由を説明するために使用されます。
これは厳密により一般的な`Option`です。
以下の型の別名を考えてみましょう。これは、実際の`Option<T>`と意味的に等価です。

```rust
type Option<T> = Result<T, ()>;
```

これは`Result`第2の型パラメータを常にbe `()`（「単位」または「空組」と発音する`()`修正します。
ちょうど1つの値が`()`型に存在します。（`()`。
（はい、型と値レベルの用語は同じ表記です！　）

`Result`型は、計算において2つの可能な結果のうちの1つを表す方法です。
慣例により、一方の結果は期待されるか、「 `Ok` 」を意味し、他方の結果は予期しないまたは「 `Err` 」を意味します。

`Option`と同様に、`Result`型には標準譜集に[定義さ][7]れている[`unwrap`操作法][7]もあります。
それを定義しよう。

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

これは[、`Option::unwrap`定義](#code-option-def-unwrap)と事実上同じですが、`panic!`メッセージに誤り値が含まれている点が異なります。
これにより虫取りが容易になりますが、`E`型パラメータ（誤り型を表す）に[`Debug`][8]制約を追加する必要があります。
大多数の型は`Debug`制約を満たす必要があるため、実際にはうまくいく傾向があります。
（型の`Debug`は、その型の値の人間が判読可能な記述を出力する合理的な方法があることを単に意味します）。

さて、例に移りましょう。

### 整数の解析

Rust標準譜集は、文字列を整数に変換するのを簡単にします。
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

これはむしろ見苦しいものです。もしこれがあなたが使っている譜集の中で起こったのであれば、あなたはわずらわしいかもしれません。
代わりに、機能の誤りを処理して、呼び出し元に何をすべきかを決定させるべきです。
これは、`double_number`の戻り値の型を変更することを意味します。
しかし何に？　
つまり、標準譜集の[`parse` method][9]型指示を調べる必要があります。

```rust,ignore
impl str {
    fn parse<F: FromStr>(&self) -> Result<F, F::Err>;
}
```

うーん。
だから少なくとも`Result`を使う必要があることは分かっています。
確かに、これは`Option`を返す可能性があります。
結局のところ、文字列は数値として解析するか、そうではないのでしょうか？　
これは確かに合理的な方法ですが、実装は文字列が整数として解析されなかった*理由を*内部的に区別します。
（それは大きすぎるか小さすぎる、空の文字列、無効な数字、だかどうか。）ので、使用して`Result`単によりも多くの情報を提供したいので、理にかなっている「が存在しないことを。」構文解析が失敗した*理由を*言いたいです。
`Option`と`Result`間の選択に直面したとき、この推論の行を再現しようとする必要があります。
詳細な誤り情報を提供できる場合は、おそらく必要です。
（後で詳しく説明します）

はい、戻り値の型はどうやって書くのでしょうか？　
上で定義した`parse`操作法は、標準譜集で定義されているすべての異なる数値型に対して汎用です。
機能を一般的にすることもできますが、おそらくそうすべきです。
`i32`だけを気にするので[、`FromStr`実装](../../std/primitive.i32.html)を[見つける](../../std/primitive.i32.html)必要があり[ます](../../std/primitive.i32.html)（あなたのブラウザーで "FromStr"の`CTRL-F`を実行）し、[関連する型][10] `Err`を[調べる](../../std/primitive.i32.html)必要があります。
具体的な誤り型を見つけるためにこれを行いました。
この場合、[`std::num::ParseIntError`](../../std/num/struct.ParseIntError.html)です。
最後に、機能を書き直すことができます。

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

これはやや良いですが、今はもっと譜面を書いています！　
事例分析がもう一度私たちに咬まれた。

救助者との組子！　
`Option`と同様に、`Result`は操作法として定義された多数の組子があります。
`Result`と`Option`間には一般的な組子の大きな交差点があります。
特に、`map`はその交差点の一部です。

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
以降さらに、`Result`第二型パラメータを有している、などのみ誤り型に作用組子、ある[`map_err`](../../std/result/enum.Result.html#method.map_err)（代わりの`map`）と[`or_else`](../../std/result/enum.Result.html#method.or_else)（代わりに`and_then`）。

### `Result`型別名慣例

標準譜集では、`Result<i32>`ような型がよく見えます。
しかし、[`Result`](#code-result-def)に2つの型パラメータを持つよう[に定義しました](#code-result-def)。
どのように指定するだけで取り除くことができますか？　
キーは、型パラメータの1つを特定の型に*固定*する`Result`型の別名を定義することです。
通常、固定型は誤り型です。
たとえば、前の例の解析用の整数は次のように書き直すことができます。

```rust
use std::num::ParseIntError;
use std::result;

type Result<T> = result::Result<T, ParseIntError>;

fn double_number(number_str: &str) -> Result<i32> {
    unimplemented!();
}
```

なぜこれを行うだろうか？　
`ParseIntError`返す機能がたくさんある場合は、常に`ParseIntError`を使用する別名を定義して、常に書き出す必要はありません。

この慣例が標準譜集で使用される最も顕著な場所は、[`io::Result`](../../std/io/type.Result.html)です。
通常、`io::Result<T>`書くと、`std::result`そのままな定義ではなく、`io`役区の型別名を使用していることがわかります。
（この慣例は[`fmt::Result`](../../std/fmt/type.Result.html)も使用されます）。

## 簡単な間奏。はがしは悪くない

もしあなたがフォローしてきたのであれば、私はあなたの算譜を`panic`て中止するかもしれない`unwrap`ような操作法を呼び出すことに対してかなり厳しい行を見たことに気づいたかもしれません。
*一般的に言えば*、これは良いアドバイスです。

しかし、`unwrap`は依然として慎重に使用することができます。
`unwrap`使用を正当に正当化するものは多少グレーの領域であり、合理的な人々は同意できません。
私はこの問題に関する私の*意見*を要約します。

* **例では、素早く 'n'のダーティ譜面です。**
   時には例や簡単な算譜を書いていることもあり、誤り処理は単純ではありません。
   このような場合では、`unwrap`の利便性を`unwrap`することは難しいため、非常に魅力的です。
* **パニックが算譜のバグを示すとき。**
   あなたの譜面の不変条件が特定のケースが起こらないようにする（空の山からポップするなど）場合、パニックが許されます。
   これは、算譜のバグを公開するためです。
   これは明示的に`assert!`ことができます。`assert!`失敗した場合などです。配列への添字が範囲外だったためです。

おそらく網羅的なリストではないでしょう。
さらに、`Option`を使用する場合、[`expect`](../../std/option/enum.Option.html#method.expect)操作法を使用するほうがよい場合があります。
`expect`はあなたが`expect`するメッセージを出力する点を除いて、`unwrap`と全く同じことを行います。
これにより、"`None`値にはがされた"の代わりにメッセージが表示されるため、結果的なパニックが扱いやすくなります。

私の助言はこれにまでこだわります。良い判断をしてください。
「Xはしない」または「Yは有害とみなされる」という言葉が私の文章には現れない理由があります。
すべてのことに相殺取引があります。使用例に受け入れられるものを判断するのは演譜師としての任務です。
私の目標は、できるだけ正確に相殺取引を評価するのに役立つだけです。

Rustの誤り処理の基礎について説明し、つけはがしについて説明したので、標準譜集の詳細を調べてみましょう。

# 複数の誤り型の操作

これまでは、すべてが`Option<T>`または`Result<T, SomeError>`いずれかの誤り処理を見てきました。
しかし、`Option`と`Result`両方を持っているとどうなりますか？　
または、`Result<T, Error1>`および`Result<T, Error2>`どうなりますか？　
*個別の誤り型の処理*は、前で次の課題です。この章の残りの部分では、主なテーマになります。

## `Option`と`Result`

今までは、`Option`に対して定義された組子と`Result`に対して定義された組子について説明しました。
これらの組子を使用して、明示的な場合分けを行うことなく、異なる計算の結果を構成することができます。

もちろん、実際の譜面では、物事は常にきれいではありません。
`Option`と`Result`型が混在していることがあります。
明示的な場合分けに頼らなければならないのですか、あるいは組子を使用し続けることができますか？　

ここでは、この章の最初の例の1つに戻ってみましょう。

```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
#//    let arg: String = argv.nth(1).unwrap(); // error 1
    let arg: String = argv.nth(1).unwrap(); // 誤り1
#//    let n: i32 = arg.parse().unwrap(); // error 2
    let n: i32 = arg.parse().unwrap(); // 誤り2
    println!("{}", 2 * n);
}
```

`Option`、 `Result`、およびそれらのさまざまな組子に関する新しい知識があれば、誤りを正しく処理し、誤りがあれば算譜がパニックに陥らないように書き直してください。

ここでのトリッキーな側面は、`argv.nth(1)`は`Option`を生成し、`arg.parse()`は`Result`生成するということです。
これらは直接構成可能ではありません。
`Option`と`Result`両方に直面した場合、*通常*は`Option`を`Result`に変換します。
場合、（`env::args()`）命令行パラメータがないということは、ユーザが算譜を正しく呼び出さなかったことを意味します。
誤りを記述するために`String`を使用できます。
やってみよう。

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
最初は、[`Option::ok_or`](../../std/option/enum.Option.html#method.ok_or)組子の使用です。
これは`Option`を`Result`に変換する1つの方法です。
この変換では、`Option`が`None`場合に使用する誤りを指定する必要があります。
見た他の組子と同様に、その定義は非常に簡単です。

```rust
fn ok_or<T, E>(option: Option<T>, err: E) -> Result<T, E> {
    match option {
        Some(val) => Ok(val),
        None => Err(err),
    }
}
```

ここで使用される新しい組子は、[`Result::map_err`](../../std/result/enum.Result.html#method.map_err)です。
`Result::map`と似ていますが、機能を`Result`値の*誤り*部分にマップする点が異なります。
`Result`が`Ok(...)`値である場合、`Result`は変更されずに戻されます。

ここで`map_err`を使用して`map_err`ます。なぜなら、誤りの種類は同じである必要があるから`map_err`を使用しているため`and_then`）。
`Option<String>`（ `argv.nth(1)`）を`Result<String, String>`に変換することを選択したので、`ParseIntError`を`arg.parse()`から`String`も変換する必要があります。

## 組子の限界

IOを行い、入力を解析することは非常に一般的な作業であり、私が個人的にRustで多く行ったことです。
したがって、IOとさまざまな解析ルーチンを使用して（そして引き続き使用して）誤り処理を例示します。

簡単に始めましょう。
ファイルを開き、すべての内容を読み込み、その内容を数値に変換することを任されています。
次に、`2`倍して出力します。

私はあなたに`unwrap`を使わないように説得しようとしましたが、最初に`unwrap`を使って譜面を書いておくと便利です。
これにより、誤り処理の代わりに問題に集中することができ、適切な誤り処理が必要な箇所が表示されます。
そこから始めましょう。そこで、譜面の手綱を取得して、より良い誤り処理を使用するようにリファクタリングします。

```rust,should_panic
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> i32 {
#//    let mut file = File::open(file_path).unwrap(); // error 1
    let mut file = File::open(file_path).unwrap(); // 誤り1
    let mut contents = String::new();
#//    file.read_to_string(&mut contents).unwrap(); // error 2
    file.read_to_string(&mut contents).unwrap(); // 誤り2
#//    let n: i32 = contents.trim().parse().unwrap(); // error 3
    let n: i32 = contents.trim().parse().unwrap(); // 誤り3
    2 * n
}

fn main() {
    let doubled = file_double("foobar");
    println!("{}", doubled);
}
```

（NB `AsRef<Path>`は[、`std::fs::File::open`使用されている縛りと同じ縛りであるため使用され`std::fs::File::open`](../../std/fs/struct.File.html#method.open)。これにより、ファイルパスとしてあらゆる種類の文字列を使用する使いやすい実装。

ここで発生する可能性がある3つの異なる誤りがあります。

1. ファイルを開く際に問題が発生しました。
2. ファイルからデータを読み取る際に問題が発生しました。
3. データを数値として解析する問題。

最初の2つの問題は、[`std::io::Error`](../../std/io/struct.Error.html)型を介して記述されます。
これは、[`std::fs::File::open`](../../std/fs/struct.File.html#method.open)と[`std::io::Read::read_to_string`](../../std/io/trait.Read.html#method.read_to_string)の戻り値の型のために[`std::io::Read::read_to_string`](../../std/io/trait.Read.html#method.read_to_string)ます。
（どちらも使用することに注意してください[`Result`型別名慣例は、](#the-result-type-alias-idiom)あなたが上でクリックした場合。前述の`Result`型、あなたはよ[型の別名を参照](../../std/io/type.Result.html)し、その結果、基礎となる`io::Error`型。）第三の問題は次のように記述され[`std::num::ParseIntError`](../../std/num/struct.ParseIntError.html)型。
`io::Error`型は、特に標準譜集全体に*広がっ*ています。
あなたはそれを何度も見ます。

`file_double`機能をリファクタリングする過程を開始しましょう。
この機能を算譜の他の部品と組み合わせるには、上記の誤り条件のいずれかが満たされている場合、パニックにはなり*ません*。
効果的には、操作が失敗した場合に機能が*誤り*を*返す*必要*があります*。
問題は、`file_double`の戻り値の型が`i32`であるため、誤りを報告する有用な方法はありません。
したがって、戻り値の型を`i32`から別のものに変更することから始めなければなりません。

最初に決定する必要があるのは、`Option`または`Result`を使用するかどうかです。
確かに非常に簡単に`Option`使用することができます。
3つの誤りのいずれかが発生した場合、単に`None`返すことができます。
これ*はうまくいってパニックよりも優れていますが、もっとうまく*いくことができます。
代わりに、発生した誤りについて詳細を渡す必要があります。
*誤り*の*可能性*を式したいので、`Result<i32, E>`使うべきです。
しかし、`E`どうなるべきでしょうか？　
2つの*異なる*型の誤りが発生する可能性があるため、それらを共通の型に変換する必要があります。
そのような型の1つは`String`です。
それが譜面にどのように影響するのかを見てみましょう。

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

この譜面は少し毛深いです。
このような譜面が書くのが簡単になるには、かなりの練習が必要です。
書いているのは、*その型に従うことです*。
`file_double`の戻り値の型を`Result<i32, String>`に変更するとすぐに、適切な組子を探す必要がありました。
この例では、3つの異なる組子を使用しました。 `and_then`、 `map`、および`map_err`。

`and_then`は、各計算が誤りを返すことができる複数の計算を連鎖させるために使用されます。
ファイルを開いた後、失敗する可能性のある計算がもう2つあります。ファイルからの読み取りと内容を数値として解析することです。
対応して、`and_then`への呼び出しが2回あります。

`map`は、`Result` `Ok(...)`値に機能を適用するために使用されます。
たとえば、最後に`map`呼び出すと、`Ok(...)`値（`i32`）に`2`が乗算されます。
そのポイントの前に誤りが発生した場合、`map`がどのように定義されているかにより、この操作はスキップされます。

`map_err`はこのすべてのことを`map_err`トリックです。
`map_err`は、`Result` `Err(...)`値に機能を適用する点を除いて`map`と似ています。
この場合、すべての誤りを1つの型に変換する必要があります。`String`。
`io::Error`と`num::ParseIntError`どちらも`ToString`を実装している`to_string()`、 `to_string()`操作法を呼び出して変換することができます。

そのすべてが言われて、譜面はまだ毛深いです。
組子の使用をマスターすることは重要ですが、それらには限界があります。
別のアプローチ、早期復帰を試してみましょう。

## 早期復帰

私は、前の章の譜面を取り上げ、*早期復帰*を使用して書き直したいと思い*ます*。
早期復帰により、早期に機能を終了することができます。
別の閉包の内側から`file_double`早い段階で戻ることはできないので、明示的な場合分けに戻す必要があります。

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

合理的な人は、この譜面が組子を使用する譜面よりも優れているかどうかについては意見を異にすることができますが、組子のアプローチに精通していない場合は、
これは、`match`と`if let`を使用した明示的な場合分けを使用`if let`ます。
誤りが発生すると、機能の実行が停止し、誤りが返されます（文字列に変換されます）。

しかしこれは後退していませんか？　
以前は、人間工学的な誤り処理の鍵は、明示的な場合分けを減らすことですが、ここでは明示的な場合分けに戻しました。
これは、明示的な場合分けを低減するための*複数の*方法がありますが、判明しました。
組子だけが唯一の方法ではありません。

## `try!`マクロ

Rustの誤り処理の基本は`try!`マクロです。
`try!`マクロは組子のような場合分けを抽象化しますが、組子とは異なり、*制御の流れ*も抽象化*します*。
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
場合分けと早期復帰を行うので、読みやすい、より厳密な譜面が得られます。

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

[`try!`定義を](#code-try-def-simple)考えると[、](#code-try-def-simple) `map_err`呼び出しはまだ必要[`try!`](#code-try-def-simple)。
これは、誤り型を引き続き`String`に変換する必要があるためです。
良いニュースは、間もなくそれらの`map_err`呼び出しを削除する方法を学ぶことです！　
悪いニュースは、`map_err`呼び出しを削除する前に、標準譜集の重要な特性についてもう少し学ぶ必要があることです。

## 独自の誤り型を定義する

標準的な譜集の誤り特性のいくつかを知る前に、前の例の誤り型として`String`の使用を取り除いて、この章をまとめておきたいと思います。

以前の例で行ったように`String`を使用すると、誤りを文字列に変換したり、現場で文字列として独自の誤りを作成したりすることが容易になるので便利です。
しかし、誤りのために`String`を使用することにはいくつかの欠点があります。

最初の欠点は、誤りメッセージが譜面を乱雑にする傾向があることです。
他の場所で誤りメッセージを定義することは可能ですが、あなたが異常に訓練されていない限り、誤りメッセージを譜面に埋め込むことは非常に魅力的です。
実際、これ[previous example](#code-error-double-string)ではこれを正確に行いました。

第2の重要な欠点は、`String`が*損失であること*です。
つまり、すべての誤りが文字列に変換された場合、呼び出し側に渡す誤りは完全に目隠しになります。
呼び出し側が`String`誤りで行うことができる唯一の妥当なことは、ユーザーに表示することです。
確かに、誤りの種類を判断するために文字列を検査することは堅牢ではありません。
（確かに、この欠点は、譜体とは対照的に、譜集の中ではるかに重要です。）

たとえば、`io::Error`型は、IO操作中に何が問題になったかを表す*構造化データ*である[`io::ErrorKind`](../../std/io/enum.ErrorKind.html)埋め込みます。
これは、誤りに応じて異なる反応を起こす可能性があるため、重要です。
（例えば、A `BrokenPipe`誤りは、`NotFound`誤りが誤り譜面で終了してユーザに誤りを表示している間に算譜を正常に終了することを意味するかもしれません）`io::ErrorKind`と、呼び出し側は場合分けこれは、`String`内部で誤りの詳細を解説しようとするよりも厳密に優れています。

前述のファイルから整数を読み込む例では、誤り型として`String`を使用する代わりに、*構造化データの*誤りを表す独自の誤り型を定義することができます。
発信者が詳細を調べたい場合、根本的な誤りから情報を削除しないように努めます。

*多くの可能性*を式する理想的な方法は、`enum`を使って独自の和型を定義することです。
場合、誤りは`io::Error`または`num::ParseIntError`いずれかであるため、自然な定義が生成されます。

```rust
use std::io;
use std::num;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 導出`Debug`すべての種類は、おそらく導出する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

譜面を調整するのはとても簡単です。
誤りを文字列に変換するのではなく、対応する値構築子を使用して`CliError`型に変換するだけです。

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

ここでの唯一の変更は、`map_err(CliError::Io)`または`map_err(CliError::Parse)` `map_err(|e| e.to_string())`切り替えること`map_err(|e| e.to_string())`誤りを文字列に変換します`map_err(CliError::Parse)`。
*呼び出し元*は、ユーザーに報告する詳細レベルを決定します。
実際には、Error型として`String`を使用すると、Errorを記述する*構造化データ*に加えて、`CliError`が前のようにすべての便利さを呼び出し元に与えるような、独自の`enum`誤り型を使用しながら呼び出し元から選択肢を削除します。

経験則は独自の誤り型を定義することですが、特に譜体を作成している場合は、`String`誤り型をピンチで処理します。
譜集を作成する場合は、呼び出し元から不必要な選択肢を削除しないように、独自の誤り型を定義することを強く推奨します。

# 誤り処理に使用される標準譜集特性

標準譜集は、誤り処理のために[`std::error::Error`](../../std/error/trait.Error.html)と[`std::convert::From`](../../std/convert/trait.From.html) 2つの不可欠な特性を定義しています。
`Error`は一般的に誤りを一般的に記述するために設計されていますが、`From`特性は2つの異なる型間で値を変換するためのより一般的な役割を果たします。

## `Error`特性

`Error`特性は[標準譜集で定義されています](../../std/error/trait.Error.html)。

```rust
use std::fmt::{Debug, Display};

trait Error: Debug + Display {
#//  /// The lower level cause of this error, if any.
  /// この誤りが発生した場合は、その原因を示します。
  fn cause(&self) -> Option<&Error> { None }
}
```

この特性は、誤りを表す*すべての*型に対して実装されるため、超総称的です。
これは、後で見るように、合成可能な譜面を記述するのに便利です。
それ以外の場合は、少なくとも以下のことを行うことができます。

* 誤りの`Debug`式を取得します。
* 誤りのユーザー側の`Display`式を取得します。
* 誤りの因果連鎖?が存在する場合（`cause`操作法を使用して）、因果連鎖?を検査します。

最初の2つは、`Debug`と`Display`両方にimplを必要とする`Error`結果です。
後者の2つは`Error`定義された2つの操作法からのものです。
`Error`の威力は、すべての誤り型が`Error`になるという事実から来[ます](trait-objects.html)。これは、誤りが現実的に[特性対象](trait-objects.html)として定量化できることを意味し[ます](trait-objects.html)。
これは、`Box<Error>`または`&Error`いずれかとして現れます。
実際、`cause`操作法は`&Error`返します。これはそれ自体が特性対象です。
`Error` traitのユーティリティを後で特性対象として再訪します。

今のところ、`Error`特性を実装する例を示すだけで十分です。
[前の章で](#defining-your-own-error-type)定義した誤り型を使用しましょう。

```rust
use std::io;
use std::num;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 導出`Debug`すべての種類は、おそらく導出する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

この特定の誤り型は、I / Oを処理する誤りまたは文字列を数値に変換する誤りの2種類の誤りが発生する可能性を表します。
この誤りは、新しい場合値を`enum`定義に追加することで、必要な数の誤り型を式できます。

実装`Error`はかなり簡単です。
ほとんどの場合、明示的な場合分けが行われます。

```rust,ignore
use std::error;
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
#            // Both underlying errors already impl `Display`, so we defer to
#            // their implementations.
            // 両方の根底にある誤りは既に`Display`を暗示しているので、実装に遅れをとっています。
            CliError::Io(ref err) => write!(f, "IO error: {}", err),
            CliError::Parse(ref err) => write!(f, "Parse error: {}", err),
        }
    }
}

impl error::Error for CliError {
    fn cause(&self) -> Option<&error::Error> {
        match *self {
#            // N.B. Both of these implicitly cast `err` from their concrete
#            // types (either `&io::Error` or `&num::ParseIntError`)
#            // to a trait object `&Error`. This works because both error types
#            // implement `Error`.
            //  NBこれらの暗黙的キャストの両方`err`その具体的な種類から（どちらか`&io::Error`または`&num::ParseIntError`特性対象への）`&Error`。これは両方の誤り型が`Error`実装しているために機能します。
            CliError::Io(ref err) => Some(err),
            CliError::Parse(ref err) => Some(err),
        }
    }
}
```

これは非常に典型的な`Error`。matchの実装であり、さまざまな種類の誤りに対応し、 `cause`に対して定義された約束事を満たしてい`cause`。

## `From`特性

`std::convert::From` traitは[標準譜集で定義されています](../../std/convert/trait.From.html)。

<span id="code-from-def"></span>
```rust
trait From<T> {
    fn from(T) -> Self;
}
```

おいしいシンプルな、はい？　
それは私たちに、特定の型*から*の変換について話をする汎用的な方法与えるので、非常に便利である`T`（この場合は、「他のいくつかの型が」IMPL、またはの対象である他のいくつかの型に`Self`）。
`From`の要点は[、標準譜集によって提供される一連の実装](../../std/convert/trait.From.html)です。

`From`仕組みを示す簡単な例がいくつかあります。

```rust
let string: String = From::from("foo");
let bytes: Vec<u8> = From::from("foo");
let cow: ::std::borrow::Cow<str> = From::from("foo");
```

OK、`From`は文字列間の変換に便利です。
しかし、誤りはどうでしょうか？　
それは、1つの重要な示唆があることが判明しました。

```rust,ignore
impl<'a, E: Error + 'a> From<E> for Box<Error + 'a>
```

これは、`Error`を意味する*任意の*型に対して、それを特性対象`Box<Error>`変換できることを意味します。
これはひどく驚くようなことではないかもしれませんが、一般的な文脈では役に立ちます。

以前に扱っていた2つの誤りを覚えていますか？　
具体的には、`io::Error`と`num::ParseIntError`です。
両方ともimpl `Error`であるため、`From`と動作します。

```rust
use std::error::Error;
use std::fs;
use std::io;
use std::num;

#// We have to jump through some hoops to actually get error values:
// 実際に誤り値を取得するには、いくつかのフープを飛ばしなければなりません。
let io_err: io::Error = io::Error::last_os_error();
let parse_err: num::ParseIntError = "not a number".parse::<i32>().unwrap_err();

#// OK, here are the conversions:
// はい、コン版は次のとおりです。
let err1: Box<Error> = From::from(io_err);
let err2: Box<Error> = From::from(parse_err);
```

ここで本当に重要なパターンがあります。
`err1`と`err2`が*同じ型*です。
これは、それらが現存する定量化された型または特性対象であるためです。
特に、その基礎となる型は製譜器の知識から*消去さ*れるため、まったく同じものとして`err1`と`err2`真に見えます。
さらに、正確に同じ機能呼び出し、`From::from`を使用して`err1`と`err2`を構築`From::from`。
これは、`From::from`がその引数とその戻り型の両方で多重定義されているためです。

このパターンは、以前の問題を解決するため重要です。同じ機能を使用して誤りを同じ型に確実に変換する方法を提供します。

古い友達を再訪する時間。
`try!`マクロ。

## 本当の`try!`マクロ

これまで、`try!`この定義を提示しました。

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

これは実際の定義ではありません。
その実際の定義は[標準譜集にあります](../../std/macro.try.html)。

<span id="code-try-def"></span>
```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(::std::convert::From::from(err)),
    });
}
```

小さくても強力な変更が1つあります。誤り値は`From::from`渡さ`From::from`ます。
これにより、`try!`マクロをより強力にすることができます。これは、自動的に型変換を行うためです。

より強力な`try!`マクロを用意して、ファイルを読み込んでその内容を整数に変換するために以前書いた譜面を見てみましょう。

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
```

以前は、`map_err`呼び出しを取り除くことができると約束しました。
確かに、しなければならないのは、`From`作品を選ぶことだけです。
前の章で見たように、`From`は、あらゆる誤り型を`Box<Error>`に変換するための実装があります。

```rust
use std::error::Error;
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, Box<Error>> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n = try!(contents.trim().parse::<i32>());
    Ok(2 * n)
}
```

理想的な誤り処理に非常に近づいています。
`try!`マクロは3つのものを同時にカプセル化するため、誤り処理の結果としてオーバーヘッドはほとんどありません。

1. 場合分け。
2. 制御の流れ。
3. 誤り型変換。

3つのものがすべて結合されると、組子、`unwrap`または場合分けの呼び出しによって妨げられない譜面が得られます。

少し残っています。 `Box<Error>`型は*目隠し*です。
呼び出し元に`Box<Error>`を返すと、呼び出し元は基になる誤り型を（簡単に）検査できません。
状況がより確かに優れている`String`、発信者のような操作法を呼び出すことができますので[`cause`](../../std/error/trait.Error.html#method.cause)、しかし制限が残っています。 `Box<Error>`目隠しです。
（これは完全に真実ではありません。なぜなら、Rustには実行時リフレクションがあるからです。[これは、この章の範囲を超えて](https://crates.io/crates/error)いる場合で便利です）。

今度は、独自の`CliError`型を再訪し、すべてを結びつけるときです。

## 独自の誤り型の作成

最後の章では、実際の`try!`マクロと、誤り値の`From::from`を呼び出すことによって、自動型変換を行う方法を見てきました。
特に、誤りを`Box<Error>`に変換しましたが、これは動作しますが、型は呼び出し元に対して目隠しです。

これを修正するには、既に慣れ親しんでいるのと同じ措置、すなわち独自の誤り型を使用します。
もう一度、ファイルの内容を読み取り、それを整数に変換する譜面を次に示します。

```rust
use std::fs::File;
use std::io::{self, Read};
use std::num;
use std::path::Path;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 導出`Debug`すべての種類は、おそらく導出する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}

fn file_double_verbose<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path).map_err(CliError::Io));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(CliError::Io));
    let n: i32 = try!(contents.trim().parse().map_err(CliError::Parse));
    Ok(2 * n)
}
```

`map_err`の呼び出しがまだあることに注意して`map_err`。
どうして？　
まあ、[`try!`](#code-try-def)と[`From`](#code-from-def)定義を思い出して[`try!`](#code-try-def)。
問題は、`io::Error`や`num::ParseIntError`ような誤り型から独自の`CliError`に変換することを可能にする`From` implは存在しないということ`CliError`。
もちろん、これを修正するのは簡単です！　
定義されているので`CliError`、IMPLできる`From`それと。

```rust
# #[derive(Debug)]
# enum CliError { Io(io::Error), Parse(num::ParseIntError) }
use std::io;
use std::num;

impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<num::ParseIntError> for CliError {
    fn from(err: num::ParseIntError) -> CliError {
        CliError::Parse(err)
    }
}
```

これらのすべての実装を教えてやっている`From`作成方法`CliError`他の誤り型からを。
場合、構築は対応する値構築子を呼び出すのと同じくらい簡単です。
確かに、これは*通常*簡単です。

最終的に`file_double`書き直すことができ`file_double`。

```rust
# use std::io;
# use std::num;
# enum CliError { Io(::std::io::Error), Parse(::std::num::ParseIntError) }
# impl From<io::Error> for CliError {
#     fn from(err: io::Error) -> CliError { CliError::Io(err) }
# }
# impl From<num::ParseIntError> for CliError {
#     fn from(err: num::ParseIntError) -> CliError { CliError::Parse(err) }
# }

use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n: i32 = try!(contents.trim().parse());
    Ok(2 * n)
}
```

ここで唯一行ったことは、`map_err`への呼び出しを削除すること`map_err`。
`try!`マクロが誤り値の`From::from`を呼び出すため、これらのマクロは不要になりました。
これは、出現する可能性のあるすべての誤り型に対して、`From`差し込み」 `From`提供されているために機能します。

`file_double`機能を変更して、たとえば文字列を浮動小数点数に変換するなどの操作を実行した場合は、新しい場合値を誤り型に追加する必要があります。

```rust
use std::io;
use std::num;

enum CliError {
    Io(io::Error),
    ParseInt(num::ParseIntError),
    ParseFloat(num::ParseFloatError),
}
```

新規追加`From`のimpl。

```rust
# enum CliError {
#     Io(::std::io::Error),
#     ParseInt(num::ParseIntError),
#     ParseFloat(num::ParseFloatError),
# }

use std::num;

impl From<num::ParseFloatError> for CliError {
    fn from(err: num::ParseFloatError) -> CliError {
        CliError::ParseFloat(err)
    }
}
```

以上です！　

## 譜集の作家のためのアドバイス

譜集で独自の誤りをレポートする必要がある場合は、おそらく独自の誤り型を定義する必要があります。
その式（[`ErrorKind`](../../std/io/enum.ErrorKind.html)）を公開するかどうか、または[`ParseIntError`](../../std/num/struct.ParseIntError.html)ように非表示にするかどうかは、あなた次第です。
それをどうしているかにかかわらず、少なくとも誤りの情報を`String`式を超えて提供することは、通常は良い方法です。
しかし、確かに、これは使用例によって異なります。

少なくとも、[`Error`](../../std/error/trait.Error.html)特性を実装するべきです。
これにより、譜集のユーザーは[誤り](#the-real-try-macro)を[作成する](#the-real-try-macro)ための柔軟性が[失われ](#the-real-try-macro)ます。
`Error`特性を実装することは、`fmt::Debug`と`fmt::Display`両方にimplを必要とするため、ユーザーが誤りの文字列式を取得することが保証されていることも意味します。

それ以外にも、誤り型の`From`実装を提供すると便利です。
これにより、あなた（譜集作成者）とユーザーは[より詳細な誤り](#composing-custom-error-types)を[作成することができ](#composing-custom-error-types)ます。
例えば、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)は、`io::Error`と`byteorder::Error`両方`From` 実装を提供します。

最後に、あなたの好みに応じて、特に譜集で単一の誤り型が定義されている場合は、[`Result`型の別名](#the-result-type-alias-idiom)を定義することもできます。
これは、[`io::Result`](../../std/io/type.Result.html)と[`fmt::Result`](../../std/fmt/type.Result.html)の標準譜集で使用されます。

# 事例で学ぶ。人口データを読み込む算譜

この章は長く、あなたの背景にもよるが、それはむしろ密であるかもしれない。
散文と一緒に行くための譜面例はたくさんありますが、そのほとんどは教育的であるように特別に設計されています。
だから、新しいことをするつもりです。事例研究。

このために、世界の人口データを照会する命令行算譜を構築します。
目的は簡単です。あなたはそれに場所を与え、人口を教えてくれるでしょう。
シンプルさにもかかわらず、間違っていることがたくさんあります！　

使用するデータは、[Data Science Toolkitに][11]基づいています。
この演習では、それ用のデータを用意しました。
[世界人口データ][12]（41MB gzip圧縮、145MB非圧縮）または[米国人口データ][13]（2.2MB gzip圧縮、7.2MB非圧縮）だけを[取得できます][13]。

これまでは、譜面をRustの標準譜集に限定していました。
このような実際の仕事では、少なくともCSVデータを解析し、算譜の引数を解析し、その情報をRust型に自動的に解読する必要があります。
そのために、[`csv`](https://crates.io/crates/csv)と[`rustc-serialize`](https://crates.io/crates/rustc-serialize)使用します。

## 初期設定

Cargoの企画では、すでに[Cargo章](getting-started.html#hello-cargo)と[Cargoの開発資料集で][14]十分にカバーされているため、企画を立ち上げるのに多くの時間を費やすつもりはありません。

ゼロから始めるには、`cargo new --bin city-pop`を実行し、`Cargo.toml`が次のようになっていることを確認してください。

```text
[package]
name = "city-pop"
version = "0.1.0"
authors = ["Andrew Gallant <jamslam@gmail.com>"]

[[bin]]
name = "city-pop"

[dependencies]
csv = "0.*"
rustc-serialize = "0.*"
getopts = "0.*"
```

あなたはすでに実行することができます。

```text
cargo build --release
./target/release/city-pop
# Outputs: Hello, world!
```

## 引数の解析

引き分けに引数の解析をしましょう。
Getoptsについて詳しく説明しませんが、それを記述する[良い文書][15]があります。
短い話は、Getoptsが選択肢のベクトルから引数構文解析器と手引きメッセージを生成することです（ベクトルであるという事実は、構造体と操作法のセットの背後に隠されています）。
解析が完了すると、構文解析器は、定義された選択肢と残りの "空き"引数との一致を記録する構造体を返します。
そこから、フラグの情報、例えば、渡されたかどうか、どのような引数があるかなどの情報を取得できます。
ここでは、適切な`extern crate` crate文とGetoptsの基本引数設定を使って、算譜を導入します。

```rust,ignore
extern crate getopts;
extern crate rustc_serialize;

use getopts::Options;
use std::env;

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };
    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }
    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

#    // Do stuff with information.
    // 情報を詰め込む
}
```

まず、算譜に渡された引数のベクトルを取得します。
次に、算譜の名前であることを認識して、最初のものを保存します。
これが終わると、引数フラグを設定します。この場合、単純な手引きメッセージフラグです。
引数フラグが設定されると、`Options.parse`を使用して引数ベクトルを解析します（添字0は算譜名です）。
これが成功した場合、解析された対象にマッチを割り当てます。そうでなければ、パニックになります。
それを過ぎると、ユーザーが手引きフラグを渡したかどうかテストし、もしそうなら、使用法のメッセージを出力します。
選択肢の手引きメッセージはGetoptsによって構築されるので、使用法のメッセージを出力するために必要なことは、算譜名とひな型のために印字することだけです。
ユーザーが手引きフラグを渡さなかった場合、適切な変数を対応する引数に割り当てます。

## 論理を書く

すべて譜面を違って書いていますが、通常は誤り処理が考えています。
これは算譜全体の設計にはあまり適していませんが、ラピッドプロトタイピングには役立ちます。
Rustは誤り処理を明示的に（強制的に`unwrap`呼び出すことによって）強制型変換するので、算譜のどの部分が誤りを引き起こすかを簡単に知ることができます。

この事例で学ぶでは、ロジックは本当に簡単です。
必要なのは、私たちに与えられたCSVデータを解析して、一致する行に欄を印字することだけです。
やってみましょう。
（`extern crate csv;`をファイルの先頭に追加してください）

```rust,ignore
use std::fs::File;

#// This struct represents the data in each row of the CSV file.
#// Type based decoding absolves us of a lot of the nitty-gritty error
#// handling, like parsing strings as integers or floats.
// この構造体は、CSVファイルの各行のデータを表します。型に基づく解読では、文字列を整数または浮動小数点として解析するような、きめ細かな誤り処理がたくさんあります。
#[derive(Debug, RustcDecodable)]
struct Row {
    country: String,
    city: String,
    accent_city: String,
    region: String,

#    // Not every row has data for the population, latitude or longitude!
#    // So we express them as `Option` types, which admits the possibility of
#    // absence. The CSV parser will fill in the correct value for us.
    // すべての行に人口、緯度、経度のデータがあるわけではありません！　だから`Option` typesとしてそれらを式します。これは欠如の可能性を認めています。CSV構文解析器ーが正しい値を入力します。
    population: Option<u64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

    let file = File::open(data_path).unwrap();
    let mut rdr = csv::Reader::from_reader(file);

    for row in rdr.decode::<Row>() {
        let row = row.unwrap();

        if row.city == city {
            println!("{}, {}: {:?}",
                row.city, row.country,
                row.population.expect("population count"));
        }
    }
}
```

誤りの概要を説明しましょう。
明白なことから始めることができます。`unwrap`と呼ばれる3つの場所は、

1. [`File::open`](../../std/fs/struct.File.html#method.open)は[`io::Error`](../../std/io/struct.Error.html)返すことができます。
2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode)は一度に一つの記録票を[解読し、記録票](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)を[解読する](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)と（`Iterator` implで`Item`関連型を調べると）、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)が生成されます。
3. `row.population`が`None`場合、`expect`を呼び出すとパニックになります。

他に何かありますか？　
一致する都市が見つからない場合はどうすればよいでしょうか？　
`grep`ような道具は誤り譜面を返すので、おそらくそれも必要です。
だから問題に固有の論理誤り、IO誤り、CSV解析誤りがあます。
これらの誤りを処理するための2つの異なる方法を検討します。

私は`Box<Error>`から始めたいと思います。
後で、独自の誤り型の定義がどのように役立つかを見ていきます。

## `Box<Error>`誤り処理`Box<Error>`

`Box<Error>`それ*だけで動作します*ので、いいです。
独自の誤り型を定義する必要はなく、`From`実装は必要ありません。
欠点は、`Box<Error>`が特性対象であるため*、型を消去する*ということです。つまり、製譜器は根本的な型を理由に考えることができなくなります。

[Previously](#the-limits-of-組子)は、機能の型を`T`から`Result<T, OurErrorType>`変更して、譜面をリファクタリングし始めました。
この場合、`OurErrorType`は`Box<Error>`のみです。
しかし、`T`何でしょうか？　
`main`戻り値型を追加できますか？　

2番目の質問に対する答えは「いいえ、できません。
つまり、新しい機能を書く必要があります。
しかし、`T`とは何でしょうか？　
一番簡単なのは、一致する`Row`値のリストを`Vec<Row>`として返すことです。
（より良い譜面は反復子を返しますが、それは読者の練習課題として残されています）。

譜面を独自の機能にリファクタリングしましょうが、呼び出しを`unwrap`するようにしましょう。
その行を無視するだけで、人口不足の可能性を処理することに注意してください。

```rust,ignore
use std::path::Path;

struct Row {
#    // This struct remains unchanged.
    // この構造体は変更されません。
}

struct PopulationCount {
    city: String,
    country: String,
#    // This is no longer an `Option` because values of this type are only
#    // constructed if they have a population count.
    // これは、もはや`Option`はない。なぜなら、この型の値は、人口数がある場合にのみ構築されるからであます。
    count: u64,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn search<P: AsRef<Path>>(file_path: P, city: &str) -> Vec<PopulationCount> {
    let mut found = vec![];
    let file = File::open(file_path).unwrap();
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = row.unwrap();
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    found
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

    for pop in search(data_path, city) {
        println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
    }
}

```

`expect`使い方（`unwrap`ほうが良い）を取り除いていますが、検索結果が存在しない場合は処理する必要があります。

これを適切な誤り処理に変換するには、以下を実行する必要があります。

1. `search`の戻り値の型を`Result<Vec<PopulationCount>, Box<Error>>`ます。
2. 算譜をパニックするのではなく、誤りが呼び出し元に返されるように[`try!`マクロを](#code-try-def)使用して[`try!`](#code-try-def)。
3. `main`の誤りを処理します。

試してみよう。

```rust,ignore
use std::error::Error;

#// The rest of the code before this is unchanged.
// それ以前の譜面の残りの部分は変更されていません。

fn search<P: AsRef<Path>>
         (file_path: P, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error>> {
    let mut found = vec![];
    let file = try!(File::open(file_path));
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(From::from("No matching cities with a population were found."))
    } else {
        Ok(found)
    }
}
```

`x.unwrap()`代わりに`try!(x)`て`try!(x)`。
機能が`Result<T, E>`返すので、誤りが発生した場合、`try!`マクロは機能の早い段階で返されます。

`search`の終わりに、[対応する`From` 実装](../../std/convert/trait.From.html)を使用してそのまま文字列を誤り型に変換します。

```rust,ignore
#// We are making use of this impl in the code above, since we call `From::from`
#// on a `&'static str`.
// 呼んで以来、上記の譜面では、このIMPLを利用している`From::from`の`&'static str`。
impl<'a> From<&'a str> for Box<Error>

#// But this is also useful when you need to allocate a new string for an
#// error message, usually with `format!`.
// しかしこれは、誤りメッセージに新しい文字列を割り当てる必要がある場合にも便利です（通常は`format!`。
impl From<String> for Box<Error>
```

以来`search`今や返す`Result<T, E>`、 `main`呼び出し時に場合分けを使用する必要があります`search`。

```rust,ignore
...
    match search(data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
            }
        }
        Err(err) => println!("{}", err)
    }
...
```

`Box<Error>`で適切な誤り処理を行う方法を見てきたので、独自の独自の誤り型で別のアプローチを試してみましょう。
しかし、まず、誤り処理から簡単に休みを取り、`stdin`からの読み込みのサポートを追加しましょう。

## 標準入力から読む

算譜では、入力用に1つのファイルを受け入れ、データを1つのファイルに渡します。
つまり、stdinの入力を受け入れることができるはずです。
しかし、現在の形式も好きかもしれません。

stdinのサポートを追加することは、実際には非常に簡単です。
しなければならないことは3つしかありません。

1. 母集団のデータをstdinから読み込んでいる間に、単一のパラメータ（都市）を受け入れることができるように、算譜の引数を調整します。
2. stdinに渡されない場合、選択肢`-f`がファイルを取り出せるように算譜を変更します。
3. *選択肢の*ファイルパスを*使用*するように`search`機能を変更します。
    `None`ときは、stdinから読むことを知るべきです。

まず、新しい使用法を次に示します。

```rust,ignore
fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <city>", program)));
}
```
もちろん引数の処理譜面を変更する必要があります。

```rust,ignore
...
    let mut opts = Options::new();
    opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    ...
    let data_path = matches.opt_str("f");

    let city = if !matches.free.is_empty() {
        &matches.free[0]
    } else {
        print_usage(&program, opts);
        return;
    };

    match search(&data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
            }
        }
        Err(err) => println!("{}", err)
    }
...
```

残りのフリーの引数`city`が存在しないときに、範囲外添字からのパニックではなく、使用法のメッセージを表示することで、使用感を少し改善しました。

`search`変更はややこしい。
`csv`通い箱は、[`io::Read`を実装する任意の型の](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.from_reader)構文解析器ーを構築できます。
しかし、どのようにして両方の型で同じ譜面を使うことができますか？　
実際にはこれについていくつかの方法があります。
1つの方法は、`io::Read`を満たすいくつかの型パラメータ`R`汎用であるように`search`を書くことです。
別の方法は、特性対象を使用することです。

```rust,ignore
use std::io;

#// The rest of the code before this is unchanged.
// それ以前の譜面の残りの部分は変更されていません。

fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error>> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
#    // The rest remains unchanged!
    // 残りは変わりません！　
}
```

## 独自の型による誤り処理

以前は[、独自の誤り型を使用して誤りを構成する](#composing-custom-error-types)方法を学習しました。
これを行うには、誤り型を`enum`型として定義し、`Error`と`From`を実装します。

3つの異なる誤り（IO、CSV解析、見つからない）があるので、3つの場合値を持つ`enum`を定義しましょう。

```rust,ignore
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Csv(csv::Error),
    NotFound,
}
```

そして今、`Display`と`Error`含意します。

```rust,ignore
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CliError::Io(ref err) => err.fmt(f),
            CliError::Csv(ref err) => err.fmt(f),
            CliError::NotFound => write!(f, "No matching cities with a \
                                             population were found."),
        }
    }
}

impl Error for CliError {
    fn cause(&self) -> Option<&Error> {
        match *self {
            CliError::Io(ref err) => Some(err),
            CliError::Csv(ref err) => Some(err),
#            // Our custom error doesn't have an underlying cause,
#            // but we could modify it so that it does.
            // 独自の誤りには根本的な原因はありませんが、変更することができます。
            CliError::NotFound => None,
        }
    }
}
```

`CliError`型を`search`機能で使用するには、`CliError`、 `From` 実装というカップルを提供する必要があります。
どのような実装が提供されるのかはどのようにわかりますか？　
さて、`io::Error`と`csv::Error`両方を`CliError`に変換する必要があります。
これらは唯一の外部誤りであるため、ここ`From` 2つの実装を必要とします。

```rust,ignore
impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<csv::Error> for CliError {
    fn from(err: csv::Error) -> CliError {
        CliError::Csv(err)
    }
}
```

`From` 実装は、[`try!`](#code-try-def)がどのように[定義されて](#code-try-def)いるかによって重要です。
特に、誤りが発生した場合は、`From::from`が誤りで呼び出されます。この場合、誤り型`CliError`変換されます。

`From` 実装 doneを使用すると、`search`機能の戻り値の型と "見つからない"という2つの小さな調整が必要になります。
ここにそれはいっぱいです。

```rust,ignore
fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, CliError> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(CliError::NotFound)
    } else {
        Ok(found)
    }
}
```

その他の変更は必要ありません。

## 機能の追加

一般的な譜面を書くことは素晴らしいことです。一般化することはすばらしく、後で役に立ちます。
しかし時には、ジュースは圧搾に値するものではありません。
前のステップで行ったことを見てください。

1. 新しい誤り型を定義しました。
2. 追加しました実装 `Error`、 `Display`とするための2つ`From`。

ここでの大きな欠点は、算譜が全体的に改善されなかったことです。
`enum`の誤りを式するには、特にこのような短い算譜ではかなりのオーバーヘッドがあります。

ここで行ったような独自の誤り型を使用する*1つの*有用な側面は、`main`機能が誤りを別々に処理することを選択できるようにすることです。
以前は、`Box<Error>`を使用していましたが、選択肢はあまりありませんでした。メッセージを印字するだけです。
まだここでそれをやっていますが、もし`--quiet`フラグを追加したいとしたら？　
`--quiet`フラグは冗長な出力を抑止します。

今のところ、算譜が一致するものを見つけられなかった場合、それを示すメッセージが出力されます。
これは、特にあなたが司得台譜で算譜を使うつもりならば、ややこしいかもしれません。

ですから、フラグを追加することから始めましょう。
前と同じように、使用文字列を調整し、Option変数にフラグを追加する必要があります。
これをしたら、Getoptsは残りを行います。

```rust,ignore
...
    let mut opts = Options::new();
    opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    opts.optflag("q", "quiet", "Silences errors and warnings.");
...
```

これで "静かな"機能を実装するだけです。
これは、`main`場合分けを微調整する必要があります。

```rust,ignore
use std::process;
...
    match search(&data_path, city) {
        Err(CliError::NotFound) if matches.opt_present("q") => process::exit(1),
        Err(err) => panic!("{}", err),
        Ok(pops) => for pop in pops {
            println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
        }
    }
...
```

確かに、IO誤りがあった場合、またはデータが解析できなかった場合には静かではありません。
したがって、誤りの種類があるかどうかを確認するために場合分けを使用し`NotFound`場合*と* `--quiet`有効になっています。
検索が失敗した場合でも、終了譜面（`grep`の規則に従って）で終了します。

`Box<Error>`で動かなかった場合、--`--quiet`機能を実装するのはかなり難しいでしょう。

これは事例で学ぶをかなり要約しています。
ここから、あなたは世界に出かけて、適切な誤り処理をして独自の算譜と譜集を書く準備ができているはずです。

# ショート・ストーリー

この章は長いので、Rustの誤り処理についての簡単な要約があると便利です。
これらは、いくつかの良い「経験則」です。これらは、重大な戒めではあり*ません*。これらの経験則のすべてを破る良い理由があります。

* 誤り処理によって多重定義になるような短い譜面例を書いているのなら、おそらく`unwrap`（ [`Result::unwrap`](../../std/result/enum.Result.html#method.unwrap)、 [`Option::unwrap`](../../std/option/enum.Option.html#method.unwrap)または[`Option::expect`](../../std/option/enum.Option.html#method.expect)）を使用しても問題ありません。
   譜面の消費者は、適切な誤り処理を使用することを知っている必要があります。
   （そうでない場合は、ここに送ってください！　）
* 間に合わせの算譜を書いているのなら、`unwrap`を使うと恥ずかしがり屋ではありません。
   警告。誰かの手の中に巻き込まれている場合は、誤りメッセージが貧弱になっても驚かないでください！　
* 間に合わせの算譜を作成していて、とにかくパニックになるのを恥ずかしく思っているなら、あなたの誤り型には`String`か`Box<Error>`を使います。
* それ以外の場合は、算譜内で、適切な[`From`](../../std/convert/trait.From.html)と[`Error`](../../std/error/trait.Error.html) 実装を使用して独自の誤り型を定義し、[`try!`](../../std/macro.try.html) macroをより使い勝手を改善します。
* 譜集を作成しているときに譜面で誤りが発生する場合は、独自の誤り型を定義し、[`std::error::Error`](../../std/error/trait.Error.html)特性を実装して[`std::error::Error`](../../std/error/trait.Error.html)。
   必要に応じて、[`From`](../../std/convert/trait.From.html)を実装して、譜集の譜面と呼び出し元の譜面の両方を簡単に書くことができます。
   （Rustの一貫性の規則のため、呼び出し元はあなたの誤り型`From`実装を行うことができないので、譜集はそれを行う必要があります。）
* [`Option`](../../std/option/enum.Option.html)と[`Result`](../../std/result/enum.Result.html)定義された組子を学んでください。
   それらを独占的に使用することは時々少し疲れることがありますが、私は個人的には魅力的な`try!`と組子の健康な組み合わせを見つけました。
   `and_then`、 `map`と`unwrap_or`は私のお気に入りです。

[1]: patterns.html
 [2]: ../../std/option/enum.Option.html#method.map
 [3]: ../../std/option/enum.Option.html#method.unwrap_or
 [4]: ../../std/option/enum.Option.html#method.unwrap_or_else
 [5]: ../../std/option/enum.Option.html
 [6]: ../../std/result/index.html
 [7]: ../../std/result/enum.Result.html#method.unwrap
 [8]: ../../std/fmt/trait.Debug.html
 [9]: ../../std/primitive.str.html#method.parse
 [10]: associated-types.html
 [11]: https://github.com/petewarden/dstkdata
 [12]: http://burntsushi.net/stuff/worldcitiespop.csv.gz
 [13]: http://burntsushi.net/stuff/uscitiespop.csv.gz
 [14]: http://doc.crates.io/guide.html
 [15]: http://doc.rust-lang.org/getopts/getopts/index.html

