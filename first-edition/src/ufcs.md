# 汎用関数呼び出しの構文

時々、関数は同じ名前を持つことがあります。
このコードを考えてみましょう：

```rust
trait Foo {
    fn f(&self);
}

trait Bar {
    fn f(&self);
}

struct Baz;

impl Foo for Baz {
    fn f(&self) { println!("Baz’s impl of Foo"); }
}

impl Bar for Baz {
    fn f(&self) { println!("Baz’s impl of Bar"); }
}

let b = Baz;
```

`bf()`を呼び出すと、エラーが発生します。

```text
error: multiple applicable methods in scope [E0034]
b.f();
  ^~~
note: candidate #1 is defined in an impl of the trait `main::Foo` for the type
`main::Baz`
    fn f(&self) { println!("Baz’s impl of Foo"); }
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: candidate #2 is defined in an impl of the trait `main::Bar` for the type
`main::Baz`
    fn f(&self) { println!("Baz’s impl of Bar"); }
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```

必要な方法を明確にする方法が必要です。
この機能は「汎用関数呼び出し構文」と呼ばれ、次のようになります。

```rust
# trait Foo {
#     fn f(&self);
# }
# trait Bar {
#     fn f(&self);
# }
# struct Baz;
# impl Foo for Baz {
#     fn f(&self) { println!("Baz’s impl of Foo"); }
# }
# impl Bar for Baz {
#     fn f(&self) { println!("Baz’s impl of Bar"); }
# }
# let b = Baz;
Foo::f(&b);
Bar::f(&b);
```

それを分解しましょう。

```rust,ignore
Foo::
Bar::
```

これらの呼び出しの半分は、`Foo`と`Bar`という2つの特性のタイプです。
これは、実際には2つの間の曖昧さ回避を行うことに終わるものです：Rustはあなたが使用する形質名から1つを呼び出します。

```rust,ignore
f(&b)
```

[メソッド構文][methodsyntax]を使って`bf()`ようなメソッドを呼び出すと、`f()`が`&self`取る場合、Rustは自動的に`b`借ります。
この場合、Rustはしないので、明示的な`&b`を渡す必要があります。

[methodsyntax]: method-syntax.html

# アングルブラケットフォーム

私たちが今話したUFCSの形式：

```rust,ignore
Trait::method(args);
```

短い手です。
いくつかの状況で必要とされる拡張された形式があります：

```rust,ignore
<Type as Trait>::method(args);
```

`<>::`構文は、型ヒントを提供する手段です。
型は`<>` sの中に入ります。
この場合、型は「 `Type as Trait`型」であり、`Trait`の`method`のバージョンをここで呼び出すことを示します。
`as Trait`部分はあいまいでない場合はオプションです。
山括弧と同じです。従って、より短い形です。

次に、長いフォームを使用する例を示します。

```rust
trait Foo {
    fn foo() -> i32;
}

struct Bar;

impl Bar {
    fn foo() -> i32 {
        20
    }
}

impl Foo for Bar {
    fn foo() -> i32 {
        10
    }
}

fn main() {
    assert_eq!(10, <Bar as Foo>::foo());
    assert_eq!(20, Bar::foo());
}
```

角括弧構文を使用すると、固有のものではなくtraitメソッドを呼び出すことができます。
