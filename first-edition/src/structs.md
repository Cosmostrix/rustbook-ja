# 構造

`struct`はより複雑なデータ型を作成する方法です。
たとえば、2D空間で座標を含む計算を行う場合、`x`と`y`両方の値が必要です。

```rust
let origin_x = 0;
let origin_y = 0;
```

`struct`使用すると、これらの2つを、フィールドラベルとして`x`と`y`を持つ単一の統一データ型に結合できます。

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
#//    let origin = Point { x: 0, y: 0 }; // origin: Point
    let origin = Point { x: 0, y: 0 }; // 起点：ポイント

    println!("The origin is at ({}, {})", origin.x, origin.y);
}
```

ここにはたくさんのことがあるので、それを分解してみましょう。
`struct`を`struct`キーワードで宣言してから、名前を付けて宣言します。
規約では、`struct`は大文字で始まり、ラクダ化されます： `PointInSpace`ではなく`Point_In_Space`です。

通常通り、`let`を使って`struct`インスタンスを作成できますが、`key: value`スタイルの構文を使用して各フィールドを設定します。
順序は元の宣言と同じである必要はありません。

最後に、フィールドには名前があるため、ドット表記`origin.x`アクセスできます。

`struct`の値は、デフォルトでは不変です（Rustの他のバインディングと同じです）。
それらを変更可能にするには`mut`を使用します：

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    point.x = 5;

    println!("The point is at ({}, {})", point.x, point.y);
}
```

`The point is at (5, 0)`印刷されます。

Rustは言語レベルでのフィールドの変更をサポートしていないので、次のような記述はできません：

```rust,ignore
struct Point {
#//    mut x: i32, // This causes an error.
    mut x: i32, // これにより、エラーが発生します。
    y: i32,
}
```

変異性は、構造そのものではなく、結合の特性です。
フィールドレベルの可変性に慣れていれば、これは最初は奇妙に思えるかもしれませんが、大幅に単純化します。
一時的に変更可能にすることさえできます：

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    point.x = 5;

#//    let point = point; // `point` is now immutable.
    let point = point; //  `point`は現在不変です。

#//    point.y = 6; // This causes an error.
    point.y = 6; // これにより、エラーが発生します。
}
```

あなたの構造には`&mut`リファレンスが含まれていることがあります。これにより、いくつかの種類の突然変異をさせることができます：

```rust
struct Point {
    x: i32,
    y: i32,
}

struct PointRef<'a> {
    x: &'a mut i32,
    y: &'a mut i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    {
        let r = PointRef { x: &mut point.x, y: &mut point.y };

        *r.x = 5;
        *r.y = 6;
    }

    assert_eq!(5, point.x);
    assert_eq!(6, point.y);
}
```

データ構造のフィールド（struct、enum、union）の初期化は、データ構造のフィールドがフィールドと同じ名前の変数で初期化されるときに簡略化できます。

```rust
#[derive(Debug)]
struct Person<'a> {
    name: &'a str,
    age: u8
}

fn main() {
#    // Create struct with field init shorthand
    // フィールドinitを省略した構造体を作成する
    let name = "Peter";
    let age = 27;
    let peter = Person { name, age };

#    // Debug-print struct
    // デバッグ印刷の構造体
    println!("{:?}", peter);
}
```

# 構文の更新

`struct`は、いくつかの値に対して他の`struct`コピーを使用することを示すために`..`を含めることができます。
例えば：

```rust
struct Point3d {
    x: i32,
    y: i32,
    z: i32,
}

let mut point = Point3d { x: 0, y: 0, z: 0 };
point = Point3d { y: 1, .. point };
```

これにより、`point`に新しい`y`が与えられますが、古い`x`と`z`値は保持されます。
同じ`struct`である必要はなく、新しい構文を作成するときにこの構文を使用できます。指定しない場合は、この構文を使用してコピーします。

```rust
# struct Point3d {
#     x: i32,
#     y: i32,
#     z: i32,
# }
let origin = Point3d { x: 0, y: 0, z: 0 };
let point = Point3d { z: 1, x: 2, .. origin };
```

# タプル構造体

Rustには、[tuple][tuple]と`struct`間のハイブリッドのような、'タプル構造体'と呼ばれる別のデータ型があります。
タプル構造体は名前を持っていますが、フィールドはありません。
それらは`struct`キーワードで宣言され、その後にタプルが続く名前で宣言されます。

[tuple]: primitive-types.html#tuples

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

ここで、`black`と`origin`は同じ値を含んでいても同じ型ではありません。

タプル構造体のメンバは、通常のタプルと同じように、ドット表記またはdestructuring `let`によってアクセスできます。

```rust
# struct Color(i32, i32, i32);
# struct Point(i32, i32, i32);
# let black = Color(0, 0, 0);
# let origin = Point(0, 0, 0);
let black_r = black.0;
let Point(_, origin_y, origin_z) = origin;
```

`Point(_, origin_y, origin_z)`ようなパターンも[マッチ式で][match]使用され[ます][match]。

タプル構造体が非常に有用な場合は、要素が1つしかない場合です。
これを 'newtype'パターンと呼びます。これは、新しい型をその含まれた値とは異なり、独自の意味的意味を表現できるようにするためです。

```rust
struct Inches(i32);

let length = Inches(10);

let Inches(integer_length) = length;
println!("length is {} inches", integer_length);
```

上記のように、内部整数型は、非構造化`let`抽出できます。
この場合、`let Inches(integer_length)`は`integer_length` `10`を割り当てます。
同じことをするためにドット表記法を使うことができました：

```rust
# struct Inches(i32);
# let length = Inches(10);
let integer_length = length.0;
```

タプル構造`struct`代わりに`struct`を使用することは常に可能であり、より明確にすることができます。
代わりに次のように`Color`と`Point`書くことができます：

```rust
struct Color {
    red: i32,
    blue: i32,
    green: i32,
}

struct Point {
    x: i32,
    y: i32,
    z: i32,
}
```

良い名前は重要で、タプル構造体の値はドット表記でも参照できますが、`struct`は位置ではなく実際の名前を与えます。

[match]: match.html

# ユニットのような構造体

メンバーを一切持たない`struct`を定義することができます：

```rust,ignore
#//struct Electron {} // Use empty braces...
struct Electron {} // 空の中カッコを使う...
#//struct Proton;     // ...or just a semicolon.
struct Proton;     // ...またはちょうどセミコロン。

#// Use the same notation when creating an instance.
// インスタンスを作成するときは、同じ表記法を使用します。
let x = Electron {};
let y = Proton;
#//let z = Electron; // Error
let z = Electron; // エラー
```

このような`struct`は空のタプル`()` 「ユニット」と呼ばれることもあります`()`に似ているため、「ユニットのような」と呼ばれます。
タプル構造体のように、新しい型を定義します。

これはめったに役に立ちませんが（マーカータイプになることもありますが）、他の機能と組み合わせると便利になることがあります。
たとえば、ライブラリは、イベントを処理するために特定の[trait][trait]を実装する構造体を作成するよう要求することがあります。
構造体に格納する必要があるデータがない場合は、ユニットのような`struct`作成できます。

[trait]: traits.html
