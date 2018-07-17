## 操作法の構文

*操作法*は機能と似ています。 `fn`予約語とその名前で宣言されています。パラメータと戻り値を持つことができ、他の場所から呼び出されたときに実行される譜面が含まれています。
しかし、操作法は構造体（またはそれぞれ第6章と第17章で説明するenumまたはtrait対象）の文脈内で定義されている点で機能と異なり、最初のパラメータは常に`self`であり、操作法が呼び出されている構造体の実例

### 操作法の定義

リスト5-13に示すように、`Rectangle`実例を持つ`area`機能をパラメータとして変更し、代わりに`Rectangle`構造体に定義された`area`操作法を作ってみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```

<span class="caption">リスト5-13。 <code>Rectangle</code> <code>area</code>操作法を定義するstruct</span>

`Rectangle`の文脈内で機能を定義するには、`impl`（実装）段落を開始します。
その後、移動`area`内の機能`impl`中かっこを最初に変更し（この場合、唯一の）パラメータがあると`self`署名で、どこでも体内で。
では`main`、と呼ばれる場所、 `area`機能を渡された`rect1`引数として、代わりに呼び出す*操作法の構文を*使用することができる`area`上の操作法`Rectangle`実例を。
操作法の構文は、実例の後に続きます。操作法名、かっこ、および引数の後にドットを追加します。

`area`の型指示では、`impl Rectangle`文脈内にあるため、Rustは`self`の型が`Rectangle`ことを知っているため、`rectangle: &Rectangle`代わりに`&self`を使用します。
`&Rectangle`ように`&`前に`self`を使う必要があることに注意してください。
操作法は、`self`所有権を取ることができ、ここでやったように`self`不変`self`に借りたり、他のパラメータと同じように`self`可変的に借りることができます。

機能版で`&Rectangle`を使用したのと同じ理由で、ここで`&self`を選択しました。所有権を奪いたくないので、構造体のデータを読み込み、書き込みしないだけです。
操作法を呼び出す実例を操作法の一部として変更したい場合は、`&mut self`を最初のパラメータとして使用します。
最初のパラメータとして`self`だけを使用して実例の所有権を取得する操作法を持つことはまれです。
この操作法は、通常、操作法が`self`を何かに変換し、呼び出し元が変換後に元の実例を使用しないようにしたい場合に使用されます。

機能の代わりに操作法を使用する主な利点は、操作法構文を使用することに加えて、すべての操作法の型指示で`self`の型を繰り返す必要がないことです。
提供する譜集のさまざまな場所で`Rectangle`機能を譜面検索する将来の利用者を作るのではなく、1つの`impl`段落で型の実例を使ってできることをすべて`impl`ました。

> ### `->`演算子はどこでしょうか？　
> 
> > CおよびC ++では、操作法を呼び出すために2つの異なる演算子が使用されます`.`
> > 直接対象の操作法を呼び出すとしている場合`->`対象への指し手で操作法を呼び出すと、最初の指し手を間接参照する必要がしている場合。
> > つまり、`object`が指し手の場合、`object->something()`は`(*object).something()`と似てい`(*object).something()`。
> 
> > Rustには、`->`演算子と同等のものはありません。
> > 代わりに、Rustには*自動参照と参照解除*と呼ばれる機能があります。
> > 操作法を呼び出すことは、この動作を持つRustの数少ない場所の1つです。
> 
> > これはどのように動作するのですか。 `object.something()`で操作法を呼び出すと、Rustは`&`、 `&mut`、または`*`自動的に追加し`object`は操作法の型指示に一致します。
> > 言い換えれば、以下は同じです。
> 
> ```rust
> # #[derive(Debug,Copy,Clone)]
> # struct Point {
> #     x: f64,
> #     y: f64,
> # }
> #
> # impl Point {
> #    fn distance(&self, other: &Point) -> f64 {
> #        let x_squared = f64::powi(other.x - self.x, 2);
> #        let y_squared = f64::powi(other.y - self.y, 2);
> #
> #        f64::sqrt(x_squared + y_squared)
> #    }
> # }
> # let p1 = Point { x: 0.0, y: 0.0 };
> # let p2 = Point { x: 5.0, y: 6.5 };
> p1.distance(&p2);
> (&p1).distance(&p2);
> ```
> 
> > 最初のものははるかにきれいに見えます。
> > 方法は明確な受信機の種類があるので、この自動参照の挙動が働く`self`。
> > レシーバと操作法の名前が与えられた場合、Rustは操作法が読み込み（`&self`）、変更（ `&mut self`）、または消費（ `self`）のいずれであるかを決定することができます。
> > Rustが操作の受け手に暗黙的に借用入れるという事実は、実際に利便性を保ちながら所有することの大きな部分です。

### より多くのパラメータを持つ操作法

`Rectangle`構造体に2番目の操作法を実装して、操作法を使用して練習しましょう。
今回は、の実例たい`Rectangle`の別の実例取るために`Rectangle`して返す`true`二場合`Rectangle`内に完全に適合することができ`self`。
それ以外の場合は`false`を返す必要があり`false`。
つまり、`can_hold`操作法を定義すると、リスト5-14に示す算譜を作成できます。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    let rect2 = Rectangle { width: 10, height: 40 };
    let rect3 = Rectangle { width: 60, height: 45 };

    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    println!("Can rect1 hold rect3? {}", rect1.can_hold(&rect3));
}
```

<span class="caption">リスト5-14。 <code>can_hold</code> -yet- <code>can_hold</code> - <code>can_hold</code>操作法の使用</span>

両方の寸法いるためと予想される出力は、次のようになり`rect2`の寸法よりも小さい`rect1`が、`rect3`よりも広くなっている`rect1`。

```text
Can rect1 hold rect2? true
Can rect1 hold rect3? false
```

操作法を定義したいので、`impl Rectangle`段落内にあります。
操作法名は`can_hold`になり、パラメータとして別の`Rectangle`不変な借用を取ります。
`rect1.can_hold(&rect2)`は`&rect2`。これは、 `Rectangle`実例である`rect2`への不変の借用です。
唯一の読む必要があるので、これは理にかなって`rect2`（むしろ書くよりも、可変ボローが必要があると思います意味している）、そしてしたい`main`の所有権を保持する`rect2`呼び出した後に再使用できるよう`can_hold`方法を。
`can_hold`の戻り値は真偽値になり、実装は`self`幅と高さの両方がそれぞれ他の`Rectangle`幅と高さよりも大きいかどうかをチェックします。
リスト5-13の`impl`段落に新しい`can_hold`操作法を追加しましょう（リスト5-15を参照）。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# #[derive(Debug)]
# struct Rectangle {
#     width: u32,
#     height: u32,
# }
#
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

<span class="caption">リスト5-15。別の<code>Rectangle</code>実例をパラメータとして取る<code>Rectangle</code>で<code>can_hold</code>操作法を実装する</span>

リスト5-14の`main`機能でこの譜面を実行すると、望ましい出力が得られます。
操作法は、`self`パラメータの後に型指示に追加する複数のパラメータを取ることができ、これらのパラメータは機能のパラメータと同様に機能します。

### 関連する機能

`impl`段落のもう一つの有用な機能は、`self`をパラメータとして取ら*ない* `impl`段落内の機能を定義することが許されていることです。
これらは*関連する機能*と呼ばれ、構造体に関連付けられているためです。
それらは機能するものであり、操作法ではありません。構造体の実例がないからです。
関連する機能`String::from`既に`String::from`使用しています。

関連する機能は、構造体の新しい実例を返す構築子でよく使用されます。
たとえば、次元パラメータを1つ持ち、幅と高さの両方として使用する関連する機能を提供すると、同じ値を2回指定するのではなく正方形の`Rectangle`簡単に作成できます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# #[derive(Debug)]
# struct Rectangle {
#     width: u32,
#     height: u32,
# }
#
impl Rectangle {
    fn square(size: u32) -> Rectangle {
        Rectangle { width: size, height: size }
    }
}
```

この関連する機能を呼び出すには、`::`構文に構造体名を使用します。
`let sq = Rectangle::square(3);` 例です。
この機能は構造体によって名前空間を持ちます。`::`構文は、役区によって作成された関連する機能と名前空間の両方に使用されます。
役区については第7章で説明します。

### 多重`impl`段落

各構造体は複数の`impl`段落を持つことができます。
たとえば、譜面リスト5-15は譜面リスト5-16の譜面と同じです。リスト5-16では、各操作法が独自の`impl`段落にあります。

```rust
# #[derive(Debug)]
# struct Rectangle {
#     width: u32,
#     height: u32,
# }
#
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

<span class="caption">リスト5-16。複数の<code>impl</code>段落を使用したリスティングリスト5-15</span>

これらの操作法を複数の`impl`段落に分割する理由はありませんが、これは有効な構文です。
第10章では、複数の`impl`段落が有用な場合があります。第10章では、総称型と特性について説明します。

## 概要

構造体を使用すると、特定領域にとって意味のある独自の型を作成できます。
構造体を使用することにより、関連するデータを相互に接続し、各部分に名前を付けて譜面を明確にすることができます。
操作法を使用すると、構造体の実例が持つ動作を指定できます。また、関連する機能を使用すると、実例を使用せずに構造体に固有の名前空間機能を使用できます。

しかし、構造体は独自の型を作成する唯一の方法ではありません。道具ボックスに別の道具を追加するために、Rustのenum機能に切り替えましょう。
