# `Deref`強制

標準ライブラリは特別な特性[`Deref`][deref]提供します。
これは、通常、デリファレンス演算子`*`をオーバーロードするために使用されます。

```rust
use std::ops::Deref;

struct DerefExample<T> {
    value: T,
}

impl<T> Deref for DerefExample<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.value
    }
}

fn main() {
    let x = DerefExample { value: 'a' };
    assert_eq!('a', *x);
}
```

[deref]: ../../std/ops/trait.Deref.html

これは、カスタムポインタ型を記述するのに便利です。
しかし、`Deref`関連する言語機能があります： 'deref coercions'。
ルールは次のとおりです：タイプ`U`を持ち、`Deref<Target=T>`実装している場合、`&U`値は自動的に`&T`強制的に変換されます。
ここに例があります：

```rust
fn foo(s: &str) {
#    // Borrow a string for a second.
    //  1秒間ストリングを借りてください。
}

#// String implements Deref<Target=str>.
//  StringはDerefを実装しています。
let owned = "Hello".to_string();

#// Therefore, this works:
// したがって、これは動作します：
foo(&owned);
```

値の前にアンパサンドを使用すると、値が参照されます。
だから、`owned`である`String`、 `&owned`いる`&String`、および以降`impl Deref<Target=str> for String`、 `&String`するDEREFます`&str` `foo()`とります。

それでおしまい。
このルールは、Rustが自動変換を行う唯一の場所の1つですが、多くの柔軟性が追加されています。
例えば、`Rc<T>`型は`Deref<Target=T>`実装しているので、これはうまく`Deref<Target=T>`ます：

```rust
use std::rc::Rc;

fn foo(s: &str) {
#    // Borrow a string for a second.
    //  1秒間ストリングを借りてください。
}

#// String implements Deref<Target=str>.
//  StringはDerefを実装しています。
let owned = "Hello".to_string();
let counted = Rc::new(owned);

#// Therefore, this works:
// したがって、これは動作します：
foo(&counted);
```

私たちがしたのは、`String`を`Rc<T>`ラップすることだけでした。
しかし、我々は今、渡すことができます`Rc<String>`我々は持っているだろうどこにでも周りの`String`。
`foo`のシグネチャは変更されませんでしたが、いずれのタイプでも同様に機能します。
この例では`&Rc<String>`を`&String`変換し、`&String`を`&str`変換し`&str`。
タイプが一致するまで、Rustはできるだけ多くの回数これを行います。

標準ライブラリによって提供される別の非常に一般的な実装は次のとおりです。

```rust
fn foo(s: &[i32]) {
#    // Borrow a slice for a second.
    //  1秒間スライスを借りてください。
}

#// Vec<T> implements Deref<Target=[T]>.
//  Vec Derefを実装する。
let owned = vec![1, 2, 3];

foo(&owned);
```

ベクトルはスライスに`Deref`できます。

## Derefとメソッド呼び出し

メソッドを呼び出すときに`Deref`も`Deref`ます。
次の例を考えてみましょう。

```rust
struct Foo;

impl Foo {
    fn foo(&self) { println!("Foo"); }
}

let f = &&Foo;

f.foo();
```

`f`は`&&Foo`で`foo`は`&self`取るが、これは機能する。
これは、これらのことが同じであるためです。

```rust,ignore
f.foo();
(&f).foo();
(&&f).foo();
(&&&&&&&&f).foo();
```

`&&&&&&&&&&&&&&&&Foo`値は、`Foo`定義されたメソッドを`&&&&&&&&&&&&&&&&Foo`ことができます。これは、コンパイラが必要なだけ多くの*演算を挿入するためです。
そして、`*` sを挿入しているので、`Deref`を使用しています。
