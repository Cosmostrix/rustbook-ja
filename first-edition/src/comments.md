# コメント

ここではいくつかの機能があるので、コメントについて学ぶのは良い考えです。
コメントは、他の演譜師にあなたの譜面に関することを説明するのに役立つメモです。
製譜器はほとんど無視します。

Rustには、*行コメント*と*文書コメントの* 2種類のコメントがあります。

```rust
#// Line comments are anything after ‘//’ and extend to the end of the line.
// 行コメントは '//'の後ろにあり、行の終わりまで拡張されます。

#//let x = 5; // This is also a line comment.
let x = 5; // これも行コメントです。

#// If you have a long explanation for something, you can put line comments next
#// to each other. Put a space between the // and your comment so that it’s
#// more readable.
// 長い説明がある場合は、行のコメントを隣に置くことができます。//とあなたのコメントの間にスペースを入れて、読みやすくします。
```

他の種類のコメントは開発資料コメントです。
開発資料コメントは、`//`代わりに`///`を使用し、Markdown表記を内部でサポートします。

```rust
#///// Adds one to the number given.
/// 与えられた数に1を加えます。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// let five = 5;
///  5 = 5とします。
///
#///// assert_eq!(6, add_one(5));
///  assert_eq！　（6、add_one（5））;
#///// # fn add_one(x: i32) -> i32 {
///  ＃fn add_one（x。i32）-> i32 {
#///// #     x + 1
///  ＃x + 1
#///// # }
///  ＃}
#///// ```
///  `` ``
fn add_one(x: i32) -> i32 {
    x + 1
}
```

それに続く項目の代わりに、項目（例えば、通い箱、役区、または機能）をコメントするための、docコメントの別のスタイル`//!`があります。
root（lib.rs）またはroot（mod.rs）役区の内部で一般的に使用されます。

```
//! # The Rust Standard Library
//!
//! The Rust Standard Library provides the essential runtime
//! functionality for building portable Rust software.
```

開発資料集のコメントを書くときには、使用法の例をいくつか挙げておくと非常に役に立ちます。
`assert_eq!`という新しいマクロが使用されています。
これは2つの値を比較し、互いに等しくなければ`panic!`なります。
これは文書化に非常に役立ちます。
別のマクロ、あります`assert!`、 `panic!` sがそれに渡された値がある場合`false`。

[`rustdoc`](documentation.html)道具を使用して、これらの開発資料コメントからHTML開発資料を生成したり、譜面サンプルをテストとして実行したりすることができます。
