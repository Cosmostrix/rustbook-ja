# 形質

特性とは、型が提供しなければならない機能についてRustコンパイラに知らせる言語機能です。

[method syntax][methodsyntax]関数を呼び出すために使用される`impl`キーワードを思い出してください：

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}
```

[methodsyntax]: method-syntax.html

形質は似ていますが、最初にメソッドシグネチャで形質を定義してから、型の特性を実装します。
この例では、`Circle`特性`HasArea`を実装します。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

trait HasArea {
    fn area(&self) -> f64;
}

impl HasArea for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}
```

あなたが見ることができるように、`trait`ブロックは、と非常によく似ています`impl`ブロックが、我々は、唯一の型シグネチャを体を定義していません。
私たちが形質を`impl`とき、`impl Item`だけでなく、`impl Trait for Item`を使用します。

`Self`型名で使用して、パラメータとして渡されたこの特性を実装する型のインスタンスを参照することができます。
`Self`、 `&Self`、 `&mut Self`は、必要な所有権のレベルに応じて使用できます。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

trait HasArea {
    fn area(&self) -> f64;

    fn is_larger(&self, &Self) -> bool;
}

impl HasArea for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }

    fn is_larger(&self, other: &Self) -> bool {
        self.area() > other.area()
    }
}
```

## ジェネリック関数の特性境界

形質は、型がその振る舞いについて一定の約束をすることができるので有益です。
汎用関数は、これを利用して、受け入れる型を制約したり、[bound][bounds]たりすることができます。
コンパイルされないこの関数を考えてみましょう：

[bounds]: glossary.html#bounds

```rust,ignore
fn print_area<T>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}
```

錆は文句を言う：

```text
error: no method named `area` found for type `T` in the current scope
```

`T`はどのような型でも構いませんので、それが`area`メソッドを実装しているかどうかは確かではありません。
しかし、ジェネリック`T`特徴的なものを追加して、以下のことを保証することができます：

```rust
# trait HasArea {
#     fn area(&self) -> f64;
# }
fn print_area<T: HasArea>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}
```

構文`<T: HasArea>` 「実装する任意の型の意味`HasArea`形質を。」形質は、関数型シグネチャを定義しているので、我々は実装する任意の型のことを確認することができます`HasArea`あります`.area()`メソッドを。

これはどのように動作するかの拡張例です：

```rust
trait HasArea {
    fn area(&self) -> f64;
}

struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl HasArea for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}

struct Square {
    x: f64,
    y: f64,
    side: f64,
}

impl HasArea for Square {
    fn area(&self) -> f64 {
        self.side * self.side
    }
}

fn print_area<T: HasArea>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}

fn main() {
    let c = Circle {
        x: 0.0f64,
        y: 0.0f64,
        radius: 1.0f64,
    };

    let s = Square {
        x: 0.0f64,
        y: 0.0f64,
        side: 1.0f64,
    };

    print_area(c);
    print_area(s);
}
```

このプログラムは、

```text
This shape has an area of 3.141593
This shape has an area of 1
```

お分かりのように、`print_area`は一般的なものですが、正しいタイプで渡されていることを保証します。
間違った型を渡すと：

```rust,ignore
print_area(5);
```

コンパイル時にエラーが発生する：

```text
error: the trait bound `_ : HasArea` is not satisfied [E0277]
```

## ジェネリック構造体の特性境界

ジェネリック構造体は、特性境界の恩恵を受けることもできます。
型パラメータを宣言するときに、バインドを追加するだけです。
新しい型の`Rectangle<T>`とその演算`is_square()`ます：

```rust
struct Rectangle<T> {
    x: T,
    y: T,
    width: T,
    height: T,
}

impl<T: PartialEq> Rectangle<T> {
    fn is_square(&self) -> bool {
        self.width == self.height
    }
}

fn main() {
    let mut r = Rectangle {
        x: 0,
        y: 0,
        width: 47,
        height: 47,
    };

    assert!(r.is_square());

    r.height = 42;
    assert!(!r.is_square());
}
```

`is_square()`は、辺が等しいことをチェックする必要があるので、辺は[`core::cmp::PartialEq`][PartialEq]特性を実装する型でなければなりません：

```rust,ignore
impl<T: PartialEq> Rectangle<T> { ... }
```

さて、矩形は、等しいかどうか比較することができる任意の型に関して定義することができます。

[PartialEq]: ../../core/cmp/trait.PartialEq.html

ここでは、等価性を比較できる限り、すべての精度（実際にはほとんどすべての型のオブジェクト）の数を受け入れる新しいstruct `Rectangle`を定義しました。
`HasArea`構造体である`Square`と`Circle`についても同じことができますか？
はい、しかし乗算が必要です。そのためには[演算子の特性][operators-and-overloading]についてもっと知る必要があります。

[operators-and-overloading]: operators-and-overloading.html

# 形質を実装するためのルール

これまでは、traitの実装を構造体に追加しただけですが、`f32`などの任意の型の特性を実装できます：

```rust
trait ApproxEqual {
    fn approx_equal(&self, other: &Self) -> bool;
}
impl ApproxEqual for f32 {
    fn approx_equal(&self, other: &Self) -> bool {
#        // Appropriate for `self` and `other` being close to 1.0.
        //  1.0に近い`self`と`other`に適しています。
        (self - other).abs() <= ::std::f32::EPSILON
    }
}

println!("{}", 1.0.approx_equal(&1.00000001));
```

これはワイルド・ウェストのように見えるかもしれませんが、これを妨げてしまう特性を実現するには2つの制限があります。
最初に、その特性があなたの範囲に定義されていない場合、それは適用されないということです。
標準ライブラリには、`File` I / Oを実行するために`File`特別な機能を追加する[`Write`][write]特性があります。
デフォルトでは、`File`はそのメソッドを持ちません：

[write]: ../../std/io/trait.Write.html

```rust,ignore
let mut f = std::fs::File::create("foo.txt").expect("Couldn’t create foo.txt");
#//let buf = b"whatever"; // buf: &[u8; 8], a byte string literal.
let buf = b"whatever"; //  buf：＆ [u8; 8] [u8; 8]、バイト文字列リテラル。
let result = f.write(buf);
#//# result.unwrap(); // Ignore the error.
# result.unwrap(); // エラーを無視します。
```

ここにエラーがあります：

```text
error: type `std::fs::File` does not implement any method in scope named `write`
let result = f.write(buf);
               ^~~~~~~~~~
```

まず`Write`特性を`use`する必要があり`use`。

```rust,no_run
use std::io::Write;

let mut f = std::fs::File::create("foo.txt").expect("Couldn’t create foo.txt");
let buf = b"whatever";
let result = f.write(buf);
#//# result.unwrap(); // Ignore the error.
# result.unwrap(); // エラーを無視します。
```

これはエラーなしでコンパイルされます。

これは、たとえ誰かが`i32`にメソッドを追加するような何か悪いことをしても、あなた`use`その特性を`use`しない限り、あなたに影響を与えないこと`use`意味します。

形質の導入にはさらに1つの制限があります。形質または導入するタイプのいずれかを定義する必要があります。
より正確に言えば、それらのうちの1つは、あなたが書いている`impl`と同じクレートに定義されなければなりません。
Rustのモジュールとパッケージシステムの詳細については、[クレートとモジュールの][cm]章を参照してください。

したがって、私たちのコードに`HasArea`を定義した`HasArea`、私たちは`HasArea`型を`i32`実装することができました。
しかし、私たちがRustによって提供された特性である`ToString`を`i32`ために実装しようとした場合、私たちはできませんでした。なぜなら、特性も型も私たちの箱に定義されていないからです。

形質についての最後のこと：特性結合されたジェネリック関数は、「モノモーフ化」（モノ：1、モーフ：フォーム）を使用するため、静的にディスパッチされます。
どう言う意味ですか？
詳細は、[特性オブジェクト][to]の章を参照してください。

[cm]: crates-and-modules.html
 [to]: trait-objects.html


# 複数の特性境界

あなたは、ジェネリック型パラメータを特性と結びつけることができます：

```rust
fn foo<T: Clone>(x: T) {
    x.clone();
}
```

複数の境界が必要な場合は、`+`を使用できます。

```rust
use std::fmt::Debug;

fn foo<T: Clone + Debug>(x: T) {
    x.clone();
    println!("{:?}", x);
}
```

`T`現在、`Debug`と同様に`Clone`必要があります。

# Where節

少数のジェネリック型と少数の特性限界を持つ関数を書くことはそれほど悪くはありませんが、数が増えるにつれて構文がますます厄介になります：

```rust
use std::fmt::Debug;

fn foo<T: Clone, K: Clone + Debug>(x: T, y: K) {
    x.clone();
    y.clone();
    println!("{:?}", y);
}
```

関数の名前は一番左にあり、パラメータリストは一番右にあります。
境界線が途切れています。

錆には解決策があり、それは ' `where`句'と呼ばれています。

```rust
use std::fmt::Debug;

fn foo<T: Clone, K: Clone + Debug>(x: T, y: K) {
    x.clone();
    y.clone();
    println!("{:?}", y);
}

fn bar<T, K>(x: T, y: K) where T: Clone, K: Clone + Debug {
    x.clone();
    y.clone();
    println!("{:?}", y);
}

fn main() {
    foo("Hello", "world");
    bar("Hello", "world");
}
```

`foo()`は以前示した構文を使用し、`bar()`は`where`句を使用します。
型パラメーターを定義するときには境界を去り、パラメーター・リストの後ろに`where`を追加するだけです。
長いリストの場合は、空白を追加することができます：

```rust
use std::fmt::Debug;

fn bar<T, K>(x: T, y: K)
    where T: Clone,
          K: Clone + Debug {

    x.clone();
    y.clone();
    println!("{:?}", y);
}
```

この柔軟性は、複雑な状況では明瞭さを増すことができます。

`where`にも簡単な構文よりも強力です。
例えば：

```rust
trait ConvertTo<Output> {
    fn convert(&self) -> Output;
}

impl ConvertTo<i64> for i32 {
    fn convert(&self) -> i64 { *self as i64 }
}

#// Can be called with T == i32.
//  T == i32で呼び出すことができます。
fn convert_t_to_i64<T: ConvertTo<i64>>(x: T) -> i64 {
    x.convert()
}

#// Can be called with T == i64.
//  T == i64で呼び出すことができます。
fn convert_i32_to_t<T>(x: i32) -> T
#        // This is using ConvertTo as if it were "ConvertTo<i64>".
        // これは、ConvertToを "ConvertTo"のように使用しています "
        where i32: ConvertTo<T> {
    x.convert()
}
```

これは`where`句の追加機能を示しています。これは型パラメータ`T`だけでなく型（この場合は`i32`）の左側に境界を許します。
この例では、`i32`は`ConvertTo<T>`実装する必要があります。
`i32`が何であるかを定義するのではなく（ここから明らかです）、`where`節は`T`制約します。

# デフォルトのメソッド

典型的な実装者がどのようにメソッドを定義するかが既にわかっている場合、デフォルトメソッドを特性定義に追加することができます。
例えば、`is_invalid()`の逆のように定義される`is_valid()`

```rust
trait Foo {
    fn is_valid(&self) -> bool;

    fn is_invalid(&self) -> bool { !self.is_valid() }
}
```

`Foo`特性の実装者は、追加されたデフォルト動作のために`is_invalid()`を実装する必要がありますが、`is_valid()`実装する必要はありません。
このデフォルトの動作は、次のようにオーバーライドできます。

```rust
# trait Foo {
#     fn is_valid(&self) -> bool;
#
#     fn is_invalid(&self) -> bool { !self.is_valid() }
# }
struct UseDefault;

impl Foo for UseDefault {
    fn is_valid(&self) -> bool {
        println!("Called UseDefault.is_valid.");
        true
    }
}

struct OverrideDefault;

impl Foo for OverrideDefault {
    fn is_valid(&self) -> bool {
        println!("Called OverrideDefault.is_valid.");
        true
    }

    fn is_invalid(&self) -> bool {
        println!("Called OverrideDefault.is_invalid!");
#//        true // Overrides the expected value of `is_invalid()`.
        true //  `is_invalid()`期待値をオーバーライドします。
    }
}

let default = UseDefault;
#//assert!(!default.is_invalid()); // Prints "Called UseDefault.is_valid."
assert!(!default.is_invalid()); //  「Called UseDefault.is_valid」を印刷します。

let over = OverrideDefault;
#//assert!(over.is_invalid()); // Prints "Called OverrideDefault.is_invalid!"
assert!(over.is_invalid()); //  "OverrideDefault.is_invalid！が呼び出されました！"
```

# 継承

場合によっては、特性を実装するには別の特性を実装する必要があります。

```rust
trait Foo {
    fn foo(&self);
}

trait FooBar : Foo {
    fn foobar(&self);
}
```

`FooBar`実装者は、次のように`Foo`実装する必要があります。

```rust
# trait Foo {
#     fn foo(&self);
# }
# trait FooBar : Foo {
#     fn foobar(&self);
# }
struct Baz;

impl Foo for Baz {
    fn foo(&self) { println!("foo"); }
}

impl FooBar for Baz {
    fn foobar(&self) { println!("foobar"); }
}
```

`Foo`実装を忘れた場合、Rustは次のように伝えます：

```text
error: the trait bound `main::Baz : main::Foo` is not satisfied [E0277]
```

# 導く

`Debug`と`Default`ような特性を繰り返し実装することは非常に面倒なことになります。
そのため、Rustには、Rustが自動的に特性を実装できるようにする[attribute][attributes]が用意されています。

```rust
#[derive(Debug)]
struct Foo;

fn main() {
    println!("{:?}", Foo);
}
```

[attributes]: attributes.html

しかし、派生はある種の形質に限られています。

- [`Clone`](../../core/clone/trait.Clone.html)
- [`Copy`](../../core/marker/trait.Copy.html)
- [`Debug`](../../core/fmt/trait.Debug.html)
- [`Default`](../../core/default/trait.Default.html)
- [`Eq`](../../core/cmp/trait.Eq.html)
- [`Hash`](../../core/hash/trait.Hash.html)
- [`Ord`](../../core/cmp/trait.Ord.html)
- [`PartialEq`](../../core/cmp/trait.PartialEq.html)
- [`PartialOrd`](../../core/cmp/trait.PartialOrd.html)
