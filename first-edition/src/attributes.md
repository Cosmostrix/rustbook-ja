# 属性

宣言には、Rustの 'attributes'という注釈を付けることができます。
それらはこのように見えます。

```rust
#[test]
# fn foo() {}
```

またはこのように。

```rust
# mod foo {
#![test]
# }
```

両者の違いは、属性の適用対象を変更する`!`。

```rust,ignore
#[foo]
struct Foo;

mod bar {
    #![bar]
}
```

`#[foo]`属性は`struct`宣言である次の項目に適用されます。
`#![bar]`属性は、それを囲む項目に適用されます。これは`mod`宣言です。
そうでなければ、それらは同じです。
両方とも、彼らが何らかの形で付属している項目の意味を変えます。

たとえば、次のような機能を考えてみましょう。

```rust
#[test]
fn check() {
    assert_eq!(2, 1 + 1);
}
```

`#[test]`とマークされています。
これは特別なことです。 [tests][tests]を実行すると、この機能が実行されます。
いつものように製譜すると、それは含められません。
この機能はテスト機能になりました。

[tests]: testing.html

属性には追加データが含まれている場合もあります。

```rust
#[inline(always)]
fn super_fast_fn() {
# }
```

またはキーと値さえ。

```rust
#[cfg(target_os = "macos")]
mod macos_only {
# }
```

Rustの属性は、さまざまなものに使用されます。
[参照に][reference]は属性の完全なリストがあります。
現在、独自の属性を作成することはできません。Rust製譜器は、独自の属性を定義します。

[reference]: ../../reference/attributes.html
