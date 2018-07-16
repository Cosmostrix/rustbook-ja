# 開発資料集

開発資料は譜体企画の重要な部分であり、Rustの一級市民です。
Rustがあなたの企画を文書化するための道具を話しましょう。

## `rustdoc`について

Rust頒布物には、文書を生成する道具、`rustdoc`含まれています。
`rustdoc`またを通じてカーゴで使用されている`cargo doc`。

開発資料は、原譜と別個のMarkdownファイルの2つの方法で生成できます。

## 原譜の文書化

Rust企画を文書化する主な方法は、原譜に注釈を付けることです。
この目的のために開発資料集コメントを使用することができます。

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
///  5 = Rc:: new（5）とします。
#///// ```
///  `` ``
pub fn new(value: T) -> Rc<T> {
#    // Implementation goes here.
    // 実装はここにあります。
}
```

この譜面は、次の[ような][rc-new]開発資料を生成します。
私は実装を外し、その場所に定期的なコメントを残しました。

この注釈について最初に気付くのは、`//`代わりに`///`を使用することです。
3つのスラッシュは開発資料集のコメントを示します。

開発資料集コメントはMarkdownで書かれています。

Rustはこれらのコメントを追跡し、開発資料集を生成するときにこれらのコメントを使用します。
enumのようなものを文書化するときは、これが重要です。

```rust
#///// The `Option` type. See [the module level documentation](index.html) for more.
///  `Option`型。詳細について[は、役区レベルの開発資料](index.html)を参照してください。
enum Option<T> {
#//    /// No value
    /// 値なし
    None,
#//    /// Some value `T`
    /// ある値`T`
    Some(T),
}
```

上の作品は、これはしません。

```rust,ignore
#///// The `Option` type. See [the module level documentation](index.html) for more.
///  `Option`型。詳細について[は、役区レベルの開発資料](index.html)を参照してください。
enum Option<T> {
#//    None, /// No value
    None, /// 値なし
#//    Some(T), /// Some value `T`
    Some(T), /// ある値`T`
}
```

誤りが表示されます。

```text
hello.rs:4:1: 4:2 error: expected ident, found `}`
hello.rs:4 }
           ^
```

この[不幸な誤り](https://github.com/rust-lang/rust/issues/22547)は正しいです。
開発資料集コメントは後のものに適用され、最後のコメントの後には何もありません。

[rc-new]: ../../std/rc/struct.Rc.html#method.new

### 開発資料のコメントを書く

とにかく、このコメントの各部分について詳しく説明しましょう。

```rust
#///// Constructs a new `Rc<T>`.
/// 新しい`Rc<T>`構築します。
# fn foo() {}
```

開発資料集コメントの最初の行は、その機能の簡単な要約です。
一文。
ちょうど基本。
上級。

```rust
///
#///// Other details about constructing `Rc<T>`s, maybe describing complicated
///  `Rc<T>`構築に関する他の詳細は、おそらく複雑な
#///// semantics, maybe additional options, all kinds of stuff.
/// 意味論、多分追加選択肢、すべての種類のもの。
///
# fn foo() {}
```

元の例には要約がありましたが、もっと多くのことを言えば、新しい段落に説明を追加することができました。

#### 特別章

次に、特別な章です。
これらは見出し、`#`示されます。
一般的に使用される見出しは4種類あります。
それらは特別な構文ではなく、今のところ慣例です。

```rust
#///// # Panics
///  ＃パニック
# fn foo() {}
```

Rustの機能の回復不能な誤用（演譜誤り）は、通常パニックで表示され、少なくとも現在の走脈全体を強制型変換終了します。
あなたの機能がこのような単純な契約をしていない場合、それはパニックによって検出され/強制型変換され、それを文書化することは非常に重要です。

```rust
#///// # Errors
///  ＃誤り
# fn foo() {}
```

あなたの機能または操作法が`Result<T, E>`返す場合、`Err(E)`返す条件を記述するのは良いことです。
これは`Panics`よりも重要ではありません。なぜなら、障害は型システムに譜面化されているからです。でも、やはりこれは良いことです。

```rust
#///// # Safety
///  ＃ 安全性
# fn foo() {}
```

あなたの機能が`unsafe`場合、呼び出し側が保守を担当している不変条件を説明する必要があります。

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
///  5 = Rc:: new（5）とします。
#///// ```
///  `` ``
# fn foo() {}
```

第4の`Examples`。
機能や操作法を使用する例を1つ以上含めると、ユーザーはすごく喜ぶでしょう。
これらの例は、譜面段落の注釈の中にあります。これについては、すぐに説明します。複数の章を持つことができます。

```rust
#///// # Examples
///  ＃例
///
#///// Simple `&str` patterns:
/// シンプル`&str`パターン。
///
#///// ```
///  `` ``
#///// let v: Vec<&str> = "Mary had a little lamb".split(' ').collect();
///  v。Vec <＆str> = "メアリーは小さな子羊を持っていました".split（''）.collect（）;
#///// assert_eq!(v, vec!["Mary", "had", "a", "little", "lamb"]);
///  assert_eq！　（v、vec！　["Mary"、"had"、"a"、"little"、"lamb"
#///// ```
///  `` ``
///
#///// More complex patterns with a lambda:
/// ラムダを用いたより複雑なパターン。
///
#///// ```
///  `` ``
#///// let v: Vec<&str> = "abc1def2ghi".split(|c: char| c.is_numeric()).collect();
///  v。Vec <＆str> = "abc1def2ghi".split（| c。char | c.is_numeric（））。
#///// assert_eq!(v, vec!["abc", "def", "ghi"]);
///  assert_eq！　（v、vec！　["abc"、"def"、"ghi"
#///// ```
///  `` ``
# fn foo() {}
```

#### 譜面段落の注釈

コメントにRustの譜面を書くには、3重スラッシュを使用します。

```rust
#///// ```
///  `` ``
#///// println!("Hello, world");
///  println！　（"こんにちは、世界"）;
#///// ```
///  `` ``
# fn foo() {}
```

これにより、譜面の強調表示が追加されます。
平文のみを表示している場合は、3重スラッシュの後に`rust`代わりに文言を入れ`text`（下記参照）。

## テストとしての開発資料

サンプルのサンプル開発資料について説明します。

```rust
#///// ```
///  `` ``
#///// println!("Hello, world");
///  println！　（"こんにちは、世界"）;
#///// ```
///  `` ``
# fn foo() {}
```

`fn main()`やその他のものは必要ありません。
`rustdoc`はヒューリスティックを使用して譜面の周りに`main()`の包みを自動的に追加し、正しい場所に配置しようとします。
例えば。

```rust
#///// ```
///  `` ``
#///// use std::rc::Rc;
///  std:: rc:: Rcを使用します。
///
#///// let five = Rc::new(5);
///  5 = Rc:: new（5）とします。
#///// ```
///  `` ``
# fn foo() {}
```

これでテストが終了します。

```rust
fn main() {
    use std::rc::Rc;
    let five = Rc::new(5);
}
```

rustdocが例を前処理するために使用する完全な計算手続きは次のとおりです。

1. すべての先頭の`#![foo]`属性は、そのままcrate属性として残されます。
2. `unused_variables`、 `unused_assignments`、 `unused_mut`、 `unused_attributes`、および`dead_code`を含むいくつかの一般的な`allow`属性が挿入されます。
    小さな例がこれらの糸くずを引き金にすることがあります。
3. 例が含まれていない場合`extern crate`、その後`extern crate <mycrate>;`
    （`#[macro_use]`がないことに注意してください）。
4. 最後に、この例に`fn main`が含まれていない場合、残りの文言は`fn main() { your_code }`包まれます。

これにより、`fn main`が生成されることがあります。
`use`文で参照される`extern crate`またはexample譜面内の`mod`文がある場合は、少なくとも`fn main() {}`を`#[macro_use] extern crate`手順4を禁止しなければ解決できません。`#[macro_use] extern crate`も同様です通い箱ルート以外では動作しません。したがって、マクロをテストするときは、明示的`main`が常に必要です。
それは、あなたの開発資料を混乱させる必要はありませんが、-読んでください！　

ただし、この計算手続きでは十分ではありません。
たとえば、これらの譜面サンプルはすべて`///`話していますか？　
原文。

```text
#///// Some documentation.
/// いくつかの開発資料。
# fn foo() {}
```

出力と異なって見える。

```rust
#///// Some documentation.
/// いくつかの開発資料。
# fn foo() {}
```

はい、そうです。`#`で始まる行を追加することができます。それらは出力から隠されますが、譜面を製譜するときに使用されます。
これをあなたの利益に利用することができます。
この場合、開発資料のコメントはある種の機能に適用する必要があるので、開発資料のコメントだけを表示したい場合は、その下に小さな機能の定義を追加する必要があります。
同時に、それは製譜器を満たすためだけにあるので、それを隠すことで例がより明確になります。
このテクニックを使用すると、開発資料のテスト容易性を維持しながら、より長いサンプルを詳細に説明することができます。

たとえば、この譜面を文書化したとします。

```rust
let x = 5;
let y = 6;
println!("{}", x + y);
```

開発資料が次のようになってしまうことがあります。

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

各譜面段落をテスト可能にするために、各段落に算譜全体が必要ですが、毎回すべての行を読者に見せたくありません。
原譜の内容は次のとおりです。

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

この例のすべての部分を繰り返すことで、説明のその部分に関連する部分のみを表示しながら、例が製譜されていることを確認できます。

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
///  panic_unless！　（1 + 1 == 2、"数学は壊れています。"）;
#///// # }
///  ＃}
#///// ```
///  `` ``
///
#///// ```rust,should_panic
///  `` `Rust、should_panic
#///// # #[macro_use] extern crate foo;
///  ＃＃ [macro_use] extern [macro_use] foo;
#///// # fn main() {
///  ＃fn main（）{
#///// panic_unless!(true == false, “I’m broken.”);
///  panic_unless！　（true == false、"私は壊れています。"）;
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

3つのことに注意しましょう。 `#[macro_use]`属性を追加できるように、独自の`extern crate` `#[macro_use]`行を追加する必要があります。
次に、私たち自身の`main()`も追加する必要があります（上で説明した理由により）。
最後に、これらの2つのことをコメント化するために賢明に`#`を使用するので、出力には表示されません。

`#`の使用が便利な別のケースは、誤り処理を無視したい場合です。
あなたは以下を望んでいると言います。

```rust,ignore
#///// use std::io;
///  std:: ioを使用します。
#///// let mut input = String::new();
///  let mut = String:: new（）;を入力します。
#///// try!(io::stdin().read_line(&mut input));
/// 試してみてください！　（io:: stdin（）。read_line（＆mut入力））;
```

問題は、`try!`が`Result<T, E>`を返し、テスト機能が何も返さないので、これが不一致の型誤りを与えることです。

```rust,ignore
#///// A doc test using try!
///  try！　を使ったdocテスト
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
/// 試してみてください！　（io:: stdin（）。read_line（＆mut入力））;
#///// # Ok(())
///  ＃ OK（（））
#///// # }
///  ＃}
#///// ```
///  `` ``
# fn foo() {}
```

譜面を機能に包むことで、この問題を回避できます。
これは、開発資料でテストを実行しているときに`Result<T, E>`捕捉して取り込みます。
このパターンは、標準譜集に定期的に表示されます。

### 開発資料テストの実行

テストを実行するには、次のいずれかを実行します。

```bash
$ rustdoc --test path/to/my/crate/root.rs
# or
$ cargo test
```

そうですね、`cargo test`テストにも開発資料集が組み込まれています。
**しかし、`cargo test`は二進譜通い箱をテストするのではなく、譜集のみをテストします。**
これは`rustdoc`動作する方法によるものです。これはテスト対象の譜集とリンクしますが、二進譜で結合するものはありません。

あなたの譜面をテストするときに`rustdoc`が正しいことをするのに役立つ注釈がいくつかあります。

```rust
#///// ```rust,ignore
///  ``Rust、無視する
#///// fn foo() {
///  fn foo（）{
#///// ```
///  `` ``
# fn foo() {}
```

`ignore`ディレクティブは、あなたの譜面を無視するようRustに指示します。
これは最も一般的なので、ほとんどあなたが望むものではありません。
その代わり、とそれに注釈を検討し`text`は、譜面ではない場合、または使用して`#`のみ、あなたが気に一部を示している実施例を取得するのを。

```rust
#///// ```rust,should_panic
///  `` `Rust、should_panic
#///// assert!(false);
/// アサートする！　（false）;
#///// ```
///  `` ``
# fn foo() {}
```

`should_panic`は、譜面が正しく製譜されるべきであることを`should_panic`伝え`rustdoc`が、実際にはテストとして渡されません。

```rust
#///// ```rust,no_run
///  `` `rust、no_run
#///// loop {
/// ループ{
#/////     println!("Hello, world");
///  println！　（"こんにちは、世界"）;
#///// }
///  }
#///// ```
///  `` ``
# fn foo() {}
```

`no_run`属性は譜面を製譜しますが、実行するわけではありません。
これは、製譜を確実にしたいが、ネットワークにアクセスできないテスト環境で実行される「Webページを取得する方法はここにある」のような例にとって重要です。

### 役区の文書化

Rustには別の種類の開発資料コメント`//!`ます。
このコメントは、次の項目ではなく、囲み項目を記録します。
言い換えると。

```rust
mod foo {
    //! This is documentation for the `foo` module.
    //!
    //! # Examples

#    // ...
    // ...
}
```

これは、役区の開発資料のために、最も頻繁に使用される`//!`が表示される場所です。
`foo.rs`に役区がある場合は、その譜面を開いて次のように表示します。

```rust
//! A module for using `foo`s.
//!
//! The `foo` module contains a lot of useful functionality blah blah blah...
```

### 通い箱の開発資料

通い箱は、通い箱ルート（別名`lib.rs`）の先頭に内側の文書コメント（ `//!`）を置くことで文書化することができます。

```rust
//! This is documentation for the `foo` crate.
//!
//! The foo crate is meant to be used for bar.
```

### 開発資料のコメントスタイル

開発資料のスタイルと書式に関する完全な規則については、[RFC 505][rfc505]を参照し[て][rfc505]ください。

[rfc505]: https://github.com/rust-lang/rfcs/blob/master/text/0505-api-comment-conventions.md

## その他の開発資料

この動作はすべて非Rust原本でも機能します。
コメントはMarkdownで書かれているので、`.md`ファイルになることがよくあります。

Markdownファイルに開発資料を書き込むときに、開発資料集にコメントを付ける必要はありません。
例えば。

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
///  5 = Rc:: new（5）とします。
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
しかし、1つのしわがあります。Markdownファイルは、このような題名を持つ必要があります。

```markdown
% The title

This is the example documentation.
```

この`%`行は、ファイルの最初の行でなければなりません。

## `doc`属性

より深いレベルでは、開発資料集コメントは開発資料集属性の略記法です。

```rust
#///// this
/// この
# fn foo() {}

#[doc="this"]
# fn bar() {}
```

これらは同じです。

```rust
//! this

#![doc="this"]
```

この属性は開発資料の作成に使用されることはよくありませんが、いくつかの選択肢を変更するときやマクロを書くときに役立ちます。

### 再輸出

`rustdoc`は、両方の場所で公的再輸出のための文書を表示します。

```rust,ignore
extern crate foo;

pub use foo::bar;
```

これにより、通い箱`foo`開発資料の中の`bar`の開発資料と、あなたの通い箱の開発資料が作成されます。
両方の場所で同じ文書を使用します。

この動作は`no_inline`で抑止できます。

```rust,ignore
extern crate foo;

#[doc(no_inline)]
pub use foo::bar;
```

## 不足している開発資料

時には、特にあなたが譜集で作業しているときに、企画内のすべての公開されたものが文書化されていることを確認したいことがあります。
Rustは、項目に開発資料がない場合、警告または誤りを生成することを可能にします。
使用している`warn`を生成するには、

```rust,ignore
#![warn(missing_docs)]
```

また、`deny`を使用`deny`誤りを生成するに`deny`。

```rust,ignore
#![deny(missing_docs)]
```

これらの警告/誤りを無効にして、文書化されていないものを明示的に残したい場合があります。
これは`allow`を使って行い`allow`。

```rust
#[allow(missing_docs)]
struct Undocumented;
```

開発資料から項目を完全に隠すこともできます。

```rust
#[doc(hidden)]
struct Hidden;
```

### HTMLの制御

`rustdoc`生成するHTMLの一部の側面を、属性の`#![doc]`版を通して制御することができます。

```rust,ignore
#![doc(html_logo_url = "https://www.rust-lang.org/logos/rust-logo-128x128-blk-v2.png",
       html_favicon_url = "https://www.rust-lang.org/favicon.ico",
       html_root_url = "https://doc.rust-lang.org/")]
```

これは、ロゴ、ファビコン、およびルートURLを使用して、いくつかの異なる選択肢を設定します。

### 開発資料テストの設定

`rustdoc`開発資料の例を`#![doc(test(..))]`属性でテストする方法を設定することもできます。

```rust
#![doc(test(attr(allow(unused_variables), deny(warnings))))]
```

これにより、サンプル内の未使用変数が許可されますが、送出された他の残塵警告に対してテストが失敗します。

## 生成選択肢

`rustdoc`には、さらにカスタマイズするために、命令行にいくつかの選択肢があります。

- `--html-in-header FILE`。 `<head>...</head>`章の最後にFILEの内容を含めます。
- `--html-before-content FILE`。描出された内容（検索バーを含む）の前に、 `<body>`直後にFILEの内容を含めます。
- `--html-after-content FILE`。描出されたすべての内容の後にFILEの内容を含めます。

## 安全上の注意

開発資料集コメントのMarkdownは、処理せずに最終的なWebページに配置されます。
直書きHTMLに注意してください。

```rust
#///// <script>alert(document.cookie)</script>
Div ("",[],[("data-l","/// ")]) [RawBlock (Format "html") "<script>alert(document.cookie)</script>"]# fn foo() {}
```
