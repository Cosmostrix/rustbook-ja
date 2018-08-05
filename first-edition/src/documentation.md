# ドキュメンテーション

ドキュメントはソフトウェアプロジェクトの重要な部分であり、Rustのファーストクラスです。
Rustがあなたのプロジェクトを文書化するためのツールを話しましょう。

## `rustdoc`について

Rustディストリビューションには、文書を生成するツール、`rustdoc`含まれています。
`rustdoc`またを通じて貨物で使用されている`cargo doc`。

ドキュメントは、ソースコードとスタンドアロンのMarkdownファイルの2つの方法で生成できます。

## ソースコードの文書化

Rustプロジェクトを文書化する主な方法は、ソースコードに注釈を付けることです。
この目的のためにドキュメンテーションコメントを使用することができます。

```rust,ignore
#///// Constructs a new `Rc<T>`.
/// 新しい`Rc<T>`構築します。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// use std::rc::Rc;
///  std:: rc:: Rcを使用します。
///
#///// let five = Rc::new(5);
///  5 = Rc:: new（5）とする。
#///// ```
///  `` ``
pub fn new(value: T) -> Rc<T> {
#    // Implementation goes here.
    // 実装はここにあります。
}
```

このコードは、次の[ような][rc-new]ドキュメントを生成します。
私は実装を外し、その場所に定期的なコメントを残しました。

このアノテーションについて最初に気付くのは、`//`代わりに`///`を使用することです。
トリプルスラッシュはドキュメンテーションのコメントを示します。

ドキュメンテーションコメントはMarkdownで書かれています。

Rustはこれらのコメントを追跡し、ドキュメンテーションを生成するときにこれらのコメントを使用します。
enumのようなものを文書化するときは、これが重要です。

```rust
#///// The `Option` type. See [the module level documentation](index.html) for more.
///  `Option`タイプ。詳細について[は、モジュールレベルのドキュメント](index.html)を参照してください。
enum Option<T> {
#//    /// No value
    /// 値なし
    None,
#//    /// Some value `T`
    /// ある値`T`
    Some(T),
}
```

上の作品は、これはしません：

```rust,ignore
#///// The `Option` type. See [the module level documentation](index.html) for more.
///  `Option`タイプ。詳細について[は、モジュールレベルのドキュメント](index.html)を参照してください。
enum Option<T> {
#//    None, /// No value
    None, /// 値なし
#//    Some(T), /// Some value `T`
    Some(T), /// ある値`T`
}
```

エラーが表示されます：

```text
hello.rs:4:1: 4:2 error: expected ident, found `}`
hello.rs:4 }
           ^
```

この[不幸なエラー](https://github.com/rust-lang/rust/issues/22547)は正しいです。
ドキュメンテーションコメントは後のものに適用され、最後のコメントの後には何もありません。

[rc-new]: ../../std/rc/struct.Rc.html#method.new

### ドキュメントのコメントを書く

とにかく、このコメントの各部分について詳しく説明しましょう：

```rust
#///// Constructs a new `Rc<T>`.
/// 新しい`Rc<T>`構築します。
# fn foo() {}
```

ドキュメンテーションコメントの最初の行は、その機能の簡単な要約です。
一文。
ちょうど基本。
上級。

```rust
///
#///// Other details about constructing `Rc<T>`s, maybe describing complicated
///  `Rc<T>`構築に関する他の詳細は、おそらく複雑な
#///// semantics, maybe additional options, all kinds of stuff.
/// セマンティクス、多分追加オプション、すべての種類のもの。
///
# fn foo() {}
```

私たちの元の例には要約がありましたが、もっと多くのことを言えば、新しい段落に説明を追加することができました。

#### 特別セクション

次に、特別なセクションです。
これらはヘッダー、`#`示されます。
一般的に使用されるヘッダーは4種類あります。
それらは特別な構文ではなく、今のところコンベンションです。

```rust
#///// # Panics
///  ＃パニック
# fn foo() {}
```

Rustの関数の回復不能な誤用（プログラミングエラー）は、通常パニックで表示され、少なくとも現在のスレッド全体を強制終了します。
あなたの関数がこのような単純な契約をしていない場合、それはパニックによって検出され/強制され、それを文書化することは非常に重要です。

```rust
#///// # Errors
///  ＃エラー
# fn foo() {}
```

あなたの関数またはメソッドが`Result<T, E>`返す場合、`Err(E)`返す条件を記述するのは良いことです。
これは`Panics`よりも重要ではありません。なぜなら、障害は型システムにコード化されているからです。でも、やはりこれは良いことです。

```rust
#///// # Safety
///  ＃ 安全性
# fn foo() {}
```

あなたの関数が`unsafe`場合、呼び出し側が保守を担当している不変条件を説明する必要があります。

```rust
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// use std::rc::Rc;
///  std:: rc:: Rcを使用します。
///
#///// let five = Rc::new(5);
///  5 = Rc:: new（5）とする。
#///// ```
///  `` ``
# fn foo() {}
```

第4の`Examples`。
関数やメソッドを使用する例を1つ以上含めると、ユーザーはあなたを愛するでしょう。
これらの例は、コードブロックの注釈の中にあります。これについては、すぐに説明します。複数のセクションを持つことができます。

```rust
#///// # Examples
///  ＃例
///
#///// Simple `&str` patterns:
/// シンプル`&str`パターン：
///
#///// ```
///  `` ``
#///// let v: Vec<&str> = "Mary had a little lamb".split(' ').collect();
///  v：Vec <＆str> = "メアリーは小さな子羊を持っていました".split（''）.collect（）;
#///// assert_eq!(v, vec!["Mary", "had", "a", "little", "lamb"]);
///  assert_eq！（v、vec！["Mary"、"had"、"a"、"little"、"lamb"
#///// ```
///  `` ``
///
#///// More complex patterns with a lambda:
/// ラムダを用いたより複雑なパターン：
///
#///// ```
///  `` ``
#///// let v: Vec<&str> = "abc1def2ghi".split(|c: char| c.is_numeric()).collect();
///  v：Vec <＆str> = "abc1def2ghi".split（| c：char | c.is_numeric（））。
#///// assert_eq!(v, vec!["abc", "def", "ghi"]);
///  assert_eq！（v、vec！["abc"、"def"、"ghi"
#///// ```
///  `` ``
# fn foo() {}
```

#### コードブロックの注釈

コメントに錆のコードを書くには、三重墓を使用します：

```rust
#///// ```
///  `` ``
#///// println!("Hello, world");
///  println！（"こんにちは、世界"）;
#///// ```
///  `` ``
# fn foo() {}
```

これにより、コードの強調表示が追加されます。
プレーンテキストのみを表示している場合は、三重墓地の後に`rust`代わりにテキストを入れ`text`（下記参照）。

## テストとしてのドキュメント

サンプルのサンプルドキュメントについて説明します。

```rust
#///// ```
///  `` ``
#///// println!("Hello, world");
///  println！（"こんにちは、世界"）;
#///// ```
///  `` ``
# fn foo() {}
```

`fn main()`やその他のものは必要ありません。
`rustdoc`はヒューリスティックを使用してコードの周りに`main()`ラッパーを自動的に追加し、正しい場所に配置しようとします。
例えば：

```rust
#///// ```
///  `` ``
#///// use std::rc::Rc;
///  std:: rc:: Rcを使用します。
///
#///// let five = Rc::new(5);
///  5 = Rc:: new（5）とする。
#///// ```
///  `` ``
# fn foo() {}
```

これでテストが終了します：

```rust
fn main() {
    use std::rc::Rc;
    let five = Rc::new(5);
}
```

rustdocが例を前処理するために使用する完全なアルゴリズムは次のとおりです。

1. すべての先頭の`#![foo]`属性は、そのままcrate属性として残されます。
2. `unused_variables`、 `unused_assignments`、 `unused_mut`、 `unused_attributes`、および`dead_code`を含むいくつかの一般的な`allow`属性が挿入されます。
    小さな例がこれらの糸くずを引き金にすることがあります。
3. 例が含まれていない場合`extern crate`、その後`extern crate <mycrate>;`
    （`#[macro_use]`がないことに注意してください）。
4. 最後に、この例に`fn main`が含まれていない場合、残りのテキストは`fn main() { your_code }`ラップされます。

これにより、`fn main`が生成されることがあります。
`use`文で参照される`extern crate`またはexampleコード内の`mod`文がある場合は、少なくとも`fn main() {}`を`#[macro_use] extern crate`手順4を禁止しなければ解決できません。`#[macro_use] extern crate`も同様ですクレートルート以外では動作しません。したがって、マクロをテストするときは、明示的`main`が常に必要です。
それは、あなたのドキュメントを混乱させる必要はありませんが、-読んでください！

ただし、このアルゴリズムでは十分ではありません。
たとえば、これらのコードサンプルはすべて`///`話していますか？
原文：

```text
#///// Some documentation.
/// いくつかのドキュメント。
# fn foo() {}
```

出力と異なって見える：

```rust
#///// Some documentation.
/// いくつかのドキュメント。
# fn foo() {}
```

はい、そうです。`#`で始まる行を追加することができます。それらは出力から隠されますが、コードをコンパイルするときに使用されます。
これをあなたの利益に利用することができます。
この場合、ドキュメントのコメントはある種の関数に適用する必要があるので、ドキュメントのコメントだけを表示したい場合は、その下に小さな関数の定義を追加する必要があります。
同時に、それはコンパイラを満たすためだけにあるので、それを隠すことで例がより明確になります。
このテクニックを使用すると、ドキュメントのテスト容易性を維持しながら、より長いサンプルを詳細に説明することができます。

たとえば、このコードを文書化したとします。

```rust
let x = 5;
let y = 6;
println!("{}", x + y);
```

ドキュメントが次のようになってしまうことがあります。

> > まず、`x`を5に設定します。
> 
> ```rust
> let x = 5;
> # let y = 6;
> # println!("{}", x + y);
> ```
> 
> > 次に、`y`を6に設定します。
> 
> ```rust
> # let x = 5;
> let y = 6;
> # println!("{}", x + y);
> ```
> 
> > 最後に、`x`と`y`和を出力します。
> 
> ```rust
> # let x = 5;
> # let y = 6;
> println!("{}", x + y);
> ```

各コードブロックをテスト可能にするために、各ブロックにプログラム全体が必要ですが、毎回すべての行を読者に見せたくありません。
ソースコードの内容は次のとおりです。

```text
    First, we set `x` to five:

    ```rust
    let x = 5;
    # let y = 6;
    # println!("{}", x + y);
    ```

    Next, we set `y` to six:

    ```rust
    # let x = 5;
    let y = 6;
    # println!("{}", x + y);
    ```

    Finally, we print the sum of `x` and `y`:

    ```rust
    # let x = 5;
    # let y = 6;
    println!("{}", x + y);
    ```
```

この例のすべての部分を繰り返すことで、説明のその部分に関連する部分のみを表示しながら、例がコンパイルされていることを確認できます。

### マクロの文書化

マクロの文書化の例を次に示します。

```rust
#///// Panic with a given message unless an expression evaluates to true.
/// 式が真と評価されない限り、与えられたメッセージを持つパニック。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// # #[macro_use] extern crate foo;
///  ＃＃ [macro_use] extern [macro_use] foo;
#///// # fn main() {
///  ＃fn main（）{
#///// panic_unless!(1 + 1 == 2, “Math is broken.”);
///  panic_unless！（1 + 1 == 2、"数学は壊れています。"）;
#///// # }
///  ＃}
#///// ```
///  `` ``
///
#///// ```rust,should_panic
///  `` `錆、should_panic
#///// # #[macro_use] extern crate foo;
///  ＃＃ [macro_use] extern [macro_use] foo;
#///// # fn main() {
///  ＃fn main（）{
#///// panic_unless!(true == false, “I’m broken.”);
///  panic_unless！（true == false、"私は壊れています。"）;
#///// # }
///  ＃}
#///// ```
///  `` ``
#[macro_export]
macro_rules! panic_unless {
    ($condition:expr, $($rest:expr),+) => ({ if ! $condition { panic!($($rest),+); } });
}
# fn main() {}
```

3つのことに注意しましょう： `#[macro_use]`属性を追加できるように、独自の`extern crate` `#[macro_use]`行を追加する必要があります。
次に、私たち自身の`main()`も追加する必要があります（上で説明した理由により）。
最後に、これらの2つのことをコメントアウトするために賢明に`#`を使用するので、出力には表示されません。

`#`の使用が便利な別のケースは、エラー処理を無視したい場合です。
あなたは以下を望んでいると言います。

```rust,ignore
#///// use std::io;
///  std:: ioを使用します。
#///// let mut input = String::new();
///  let mut = String:: new（）;を入力します。
#///// try!(io::stdin().read_line(&mut input));
/// 試してみてください！（io:: stdin（）。read_line（＆mut入力））;
```

問題は、`try!`が`Result<T, E>`を返し、テスト関数が何も返さないので、これが不一致の型エラーを与えることです。

```rust,ignore
#///// A doc test using try!
///  try！を使ったdocテスト
///
#///// ```
///  `` ``
#///// use std::io;
///  std:: ioを使用します。
#///// # fn foo() -> io::Result<()> {
///  ＃fn foo（）-> io:: Result <（）> {
#///// let mut input = String::new();
///  let mut = String:: new（）;を入力します。
#///// try!(io::stdin().read_line(&mut input));
/// 試してみてください！（io:: stdin（）。read_line（＆mut入力））;
#///// # Ok(())
///  ＃ OK（（））
#///// # }
///  ＃}
#///// ```
///  `` ``
# fn foo() {}
```

コードを関数にラップすることで、この問題を回避できます。
これは、ドキュメントでテストを実行しているときに`Result<T, E>`キャッチして取り込みます。
このパターンは、標準ライブラリに定期的に表示されます。

### ドキュメントテストの実行

テストを実行するには、次のいずれかを実行します。

```bash
$ rustdoc --test path/to/my/crate/root.rs
# or
$ cargo test
```

そうですね、`cargo test`テストにもドキュメンテーションが組み込まれています。
**しかし、`cargo test`はバイナリボックスをテストするのではなく、ライブラリのみをテストします。**
これは`rustdoc`動作する方法によるものです。これはテスト対象のライブラリとリンクしますが、バイナリでリンクするものはありません。

あなたのコードをテストするときに`rustdoc`が正しいことをするのに役立つアノテーションがいくつかあります：

```rust
#///// ```rust,ignore
///  ``錆、無視する
#///// fn foo() {
///  fn foo（）{
#///// ```
///  `` ``
# fn foo() {}
```

`ignore`ディレクティブは、あなたのコードを無視するようRustに指示します。
これは最も一般的なので、ほとんどあなたが望むものではありません。
その代わり、とそれに注釈を検討し`text`は、コードではない場合、または使用して`#`のみ、あなたが気に一部を示している実施例を取得するのを。

```rust
#///// ```rust,should_panic
///  `` `錆、should_panic
#///// assert!(false);
/// アサートする！（false）;
#///// ```
///  `` ``
# fn foo() {}
```

`should_panic`は、コードが正しくコンパイルされるべきであることを`should_panic`伝え`rustdoc`が、実際にはテストとして渡されません。

```rust
#///// ```rust,no_run
///  `` `rust、no_run
#///// loop {
/// ループ{
#/////     println!("Hello, world");
///  println！（"こんにちは、世界"）;
#///// }
///  }
#///// ```
///  `` ``
# fn foo() {}
```

`no_run`属性はコードをコンパイルしますが、実行するわけではありません。
これは、コンパイルを確実にしたいが、ネットワークにアクセスできないテスト環境で実行される「Webページを取得する方法はここにある」のような例にとって重要です。

### モジュールの文書化

Rustには別の種類のドキュメントコメント`//!`ます。
このコメントは、次のアイテムではなく、囲みアイテムを記録します。
言い換えると：

```rust
mod foo {
    //! This is documentation for the `foo` module.
    //!
    //! # Examples

#    // ...
    // ...
}
```

これは、モジュールのドキュメントのために、最も頻繁に使用される`//!`が表示される場所です。
`foo.rs`にモジュールがある場合は、そのコードを開いて次のように表示します。

```rust
//! A module for using `foo`s.
//!
//! The `foo` module contains a lot of useful functionality blah blah blah...
```

### クレートのドキュメント

クレートは、クレートルート（別名`lib.rs`）の先頭に内側の文書コメント（ `//!`）を置くことで文書化することができます：

```rust
//! This is documentation for the `foo` crate.
//!
//! The foo crate is meant to be used for bar.
```

### ドキュメントのコメントスタイル

ドキュメントのスタイルと書式に関する完全な規則については、[RFC 505][rfc505]を参照し[て][rfc505]ください。

[rfc505]: https://github.com/rust-lang/rfcs/blob/master/text/0505-api-comment-conventions.md

## その他のドキュメント

この動作はすべて非Rustソースファイルでも機能します。
コメントはMarkdownで書かれているので、`.md`ファイルになることがよくあります。

Markdownファイルにドキュメントを書き込むときに、ドキュメンテーションにコメントを付ける必要はありません。
例えば：

```rust
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// use std::rc::Rc;
///  std:: rc:: Rcを使用します。
///
#///// let five = Rc::new(5);
///  5 = Rc:: new（5）とする。
#///// ```
///  `` ``
# fn foo() {}
```

次のとおりです。

~~~マークダウン＃例

```
use std::rc::Rc;

let five = Rc::new(5);
```
~~~

それがMarkdownファイルにあるとき
しかし、1つのしわがあります：Markdownファイルは、このようなタイトルを持つ必要があります：

```markdown
% The title

This is the example documentation.
```

この`%`行は、ファイルの最初の行でなければなりません。

## `doc`属性

より深いレベルでは、ドキュメンテーションコメントはドキュメンテーション属性の構文上の砂糖です：

```rust
#///// this
/// この
# fn foo() {}

#[doc="this"]
# fn bar() {}
```

これらは同じです：

```rust
//! this

#![doc="this"]
```

この属性はドキュメントの作成に使用されることはよくありませんが、いくつかのオプションを変更するときやマクロを書くときに役立ちます。

### 再輸出

`rustdoc`は、両方の場所で公的再輸出のための文書を表示します：

```rust,ignore
extern crate foo;

pub use foo::bar;
```

これにより、クレート`foo`ドキュメントの中の`bar`のドキュメントと、あなたのクレートのドキュメントが作成されます。
両方の場所で同じ文書を使用します。

この動作は`no_inline`で抑止できます：

```rust,ignore
extern crate foo;

#[doc(no_inline)]
pub use foo::bar;
```

## 不足しているドキュメント

時には、特にあなたが図書館で作業しているときに、プロジェクト内のすべての公共のものが文書化されていることを確認したいことがあります。
錆は、アイテムにドキュメントがない場合、警告またはエラーを生成することを可能にします。
使用している`warn`を生成するには、

```rust,ignore
#![warn(missing_docs)]
```

また、`deny`を使用`deny`エラーを生成するに`deny`：

```rust,ignore
#![deny(missing_docs)]
```

これらの警告/エラーを無効にして、文書化されていないものを明示的に残したい場合があります。
これは`allow`を使って行い`allow`：

```rust
#[allow(missing_docs)]
struct Undocumented;
```

ドキュメントからアイテムを完全に隠すこともできます。

```rust
#[doc(hidden)]
struct Hidden;
```

### HTMLの制御

`rustdoc`生成するHTMLのいくつかの側面を、属性の`#![doc]`バージョンを通して制御することができます：

```rust,ignore
#![doc(html_logo_url = "https://www.rust-lang.org/logos/rust-logo-128x128-blk-v2.png",
       html_favicon_url = "https://www.rust-lang.org/favicon.ico",
       html_root_url = "https://doc.rust-lang.org/")]
```

これは、ロゴ、ファビコン、およびルートURLを使用して、いくつかの異なるオプションを設定します。

### ドキュメントテストの設定

`rustdoc`ドキュメントの例を`#![doc(test(..))]`属性でテストする方法を設定することもできます。

```rust
#![doc(test(attr(allow(unused_variables), deny(warnings))))]
```

これにより、サンプル内の未使用変数が許可されますが、スローされた他のリント警告に対してテストが失敗します。

## 生成オプション

`rustdoc`には、さらにカスタマイズするために、コマンドラインにいくつかのオプションがあります。

- `--html-in-header FILE`： `<head>...</head>`セクションの最後にFILEの内容を含めます。
- `--html-before-content FILE`：レンダリングされたコンテンツ（検索バーを含む）の前に、 `<body>`直後にFILEのコンテンツを含めます。
- `--html-after-content FILE`：レンダリングされたすべてのコンテンツの後にFILEの内容を含めます。

## セキュリティノート

ドキュメンテーションコメントのMarkdownは、処理せずに最終的なWebページに配置されます。
リテラルHTMLに注意してください：

```rust
#///// <script>alert(document.cookie)</script>
Div ("",[],[("data-l","/// ")]) [RawBlock (Format "html") "<script>alert(document.cookie)</script>"]# fn foo() {}
```
