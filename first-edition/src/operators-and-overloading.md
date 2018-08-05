# 演算子とオーバーロード

錆は、限られた形式のオペレータ過負荷を可能にします。
過負荷になる可能性のある演算子があります。
タイプ間で特定の演算子をサポートするには、実装できる特定の特性があり、演算子に過負荷がかかります。

たとえば、`+`演算子は`Add`特性でオーバーロードすることができます。

```rust
use std::ops::Add;

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point { x: self.x + other.x, y: self.y + other.y }
    }
}

fn main() {
    let p1 = Point { x: 1, y: 0 };
    let p2 = Point { x: 2, y: 3 };

    let p3 = p1 + p2;

    println!("{:?}", p3);
}
```

では`main`、我々は使用することができます`+`我々の2つ上の`Point`私たちが実施してきたことから、sの`Add<Output=Point>`のための`Point`。

この方法でオーバーロードすることができる多数の演算子があり、関連するすべての特性は[`std::ops`][stdops]モジュールにあります。
完全なリストについては、そのドキュメントを調べてください。

[stdops]: ../../std/ops/index.html

これらの形質の実施にはパターンがあります。
[`Add`][add]をもっと詳しく見てみましょう：

```rust
# mod foo {
pub trait Add<RHS = Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}
# }
```

[add]: ../../std/ops/trait.Add.html

ここ`impl Add`は、`impl Add` for `impl Add`、 `RHS`、 `Self`をデフォルトとするタイプ、`Output` 3つのタイプがあります。
式の場合、`let z = x + y`、 `x`は`Self`型、`y`はRHS、`z`は`Self::Output`型です。

```rust
# struct Point;
# use std::ops::Add;
impl Add<i32> for Point {
    type Output = f64;

    fn add(self, rhs: i32) -> f64 {
#        // Add an i32 to a Point and get an f64.
        //  i32をポイントに追加し、f64を取得します。
# 1.0
    }
}
```

あなたにこれをさせるでしょう：

```rust,ignore
#//let p: Point = // ...
let p: Point = // ...
let x: f64 = p + 2i32;
```

# ジェネリック構造体の演算子特性の使用

演算子の特性がどのように定義されているかを知ったので、`HasArea`特性と`Square`構造を[特性の章][traits]からより一般的に定義できます。

[traits]: traits.html

```rust
use std::ops::Mul;

trait HasArea<T> {
    fn area(&self) -> T;
}

struct Square<T> {
    x: T,
    y: T,
    side: T,
}

impl<T> HasArea<T> for Square<T>
        where T: Mul<Output=T> + Copy {
    fn area(&self) -> T {
        self.side * self.side
    }
}

fn main() {
    let s = Square {
        x: 0.0f64,
        y: 0.0f64,
        side: 12.0f64,
    };

    println!("Area of s: {}", s.area());
}
```

`HasArea`と`Square`については、型パラメータ`T`を宣言し、`f64`をそれに置き換えます。
`impl`はより複雑な変更が必要です。

```rust,ignore
impl<T> HasArea<T> for Square<T>
        where T: Mul<Output=T> + Copy { ... }
```

`area`メソッドでは、辺を掛けることができるので、タイプ`T`は`std::ops::Mul`実装しなければならないと宣言します。
前述の`Add`ように、`Mul`自体は`Output`パラメーターをとります。数値は乗算されたときに型が変更されないことを知っているので、`T`も設定します。
`T`もコピーをサポートしなければならないので、Rustは`self.side`を戻り値に移動しようとしません。
