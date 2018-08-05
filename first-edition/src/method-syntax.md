# メソッドの構文

関数は素晴らしいですが、いくつかのデータでそれらの束を呼びたい場合は、扱いにくいかもしれません。
このコードを考えてみましょう：

```rust,ignore
baz(bar(foo));
```

これを左から右に読むと、「baz bar foo」と表示されます。
しかし、これは機能が呼び出される順番ではなく、それはインサイドアウトです： 'foo bar baz'。
代わりにこれを行うことができればいいのではないでしょうか？

```rust,ignore
foo.bar().baz();
```

幸いなことに、主な質問で推測したように、あなたはできます！
Rustは、この 'メソッド呼び出し構文'を`impl`キーワードで使用する機能を提供します。

# メソッド呼び出し

それはどのように動作するのです：

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

fn main() {
    let c = Circle { x: 0.0, y: 0.0, radius: 2.0 };
    println!("{}", c.area());
}
```

これにより`12.566371`が印刷され`12.566371`。

円を表す`struct`を作成しました。
次に、`impl`ブロックを記述し、その内部にメソッド、`area`定義します。

メソッドは特別な最初のパラメータをとります。その中に`self`、 `&self`、および`&mut self` 3つの変種があります。
この最初のパラメータは、`foo.bar()` `foo`であると考えることができます。
3つの変種は`foo`ができる3つの種類に対応します： `self`はスタック上の値なら`&self`、それがリファレンスならば`&mut self`、それが可変参照の場合は`&mut self`です。
`&self`パラメータを`area`に取ったので、他のパラメータと同様に使用できます。
`Circle`であることがわかっているので、他の`struct`と同様に`radius`アクセスできます。

所有権を借りることよりも借りることを望むべきであると同時に、変更可能なものよりも不変な参照を取ることを望むならば、`&self`を使うことをデフォルトにするべきです。
次の3つのバリアントの例を示します。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn reference(&self) {
       println!("taking self by reference!");
    }

    fn mutable_reference(&mut self) {
       println!("taking self by mutable reference!");
    }

    fn takes_ownership(self) {
       println!("taking ownership of self!");
    }
}
```

あなたは好きなだけ多くの`impl`ブロックを使うことができます。
前の例は次のように書かれているかもしれません：

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn reference(&self) {
       println!("taking self by reference!");
    }
}

impl Circle {
    fn mutable_reference(&mut self) {
       println!("taking self by mutable reference!");
    }
}

impl Circle {
    fn takes_ownership(self) {
       println!("taking ownership of self!");
    }
}
```

# メソッド呼び出しの連鎖

そこで、`foo.bar()`などのメソッドを呼び出す方法を知っています。
しかし、元の例`foo.bar().baz()`どうですか？
これは「メソッド連鎖」と呼ばれます。
例を見てみましょう：

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

    fn grow(&self, increment: f64) -> Circle {
        Circle { x: self.x, y: self.y, radius: self.radius + increment }
    }
}

fn main() {
    let c = Circle { x: 0.0, y: 0.0, radius: 2.0 };
    println!("{}", c.area());

    let d = c.grow(2.0).area();
    println!("{}", d);
}
```

戻り値の型を確認してください：

```rust
# struct Circle;
# impl Circle {
fn grow(&self, increment: f64) -> Circle {
# Circle } }
```

私たちは`Circle`返すと言います。
この方法では、新しい`Circle`を任意のサイズに拡大できます。

# 関連する関数

`self`パラメータを取らない関連する関数を定義することもできます。
Rustコードでよく見られるパターンは次のとおりです。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn new(x: f64, y: f64, radius: f64) -> Circle {
        Circle {
            x: x,
            y: y,
            radius: radius,
        }
    }
}

fn main() {
    let c = Circle::new(0.0, 0.0, 2.0);
}
```

この「関連付けられた関数」は、新しい`Circle`を作成します。
関連する関数は、`ref.method()`構文ではなく、`Struct::function()`構文で呼び出されることに注意してください。
他の言語では、関連する関数「静的メソッド」を呼び出します。

# ビルダーパターン

ユーザーが`Circle`を作成できるようにしたいと考えていますが、`Circle`のあるプロパティのみを設定できるようにします。
それ以外の場合、`x`および`y`属性は`0.0`になり、`radius`は`1.0`ます。
Rustには、メソッドのオーバーロード、名前付き引数、または可変引数はありません。
代わりにビルダーパターンを使用します。
これは次のようになります。

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

struct CircleBuilder {
    x: f64,
    y: f64,
    radius: f64,
}

impl CircleBuilder {
    fn new() -> CircleBuilder {
        CircleBuilder { x: 0.0, y: 0.0, radius: 1.0, }
    }

    fn x(&mut self, coordinate: f64) -> &mut CircleBuilder {
        self.x = coordinate;
        self
    }

    fn y(&mut self, coordinate: f64) -> &mut CircleBuilder {
        self.y = coordinate;
        self
    }

    fn radius(&mut self, radius: f64) -> &mut CircleBuilder {
        self.radius = radius;
        self
    }

    fn finalize(&self) -> Circle {
        Circle { x: self.x, y: self.y, radius: self.radius }
    }
}

fn main() {
    let c = CircleBuilder::new()
                .x(1.0)
                .y(2.0)
                .radius(2.0)
                .finalize();

    println!("area: {}", c.area());
    println!("x: {}", c.x);
    println!("y: {}", c.y);
}
```

私たちがここで行ったことは、別の`struct` `CircleBuilder`作ること`CircleBuilder`。
ビルダーメソッドを定義しました。
`Circle` `area()`メソッドも定義しました。
`CircleBuilder`もう一つのメソッド`finalize()`も作成しました。
このメソッドは、ビルダーから最終的な`Circle`を作成します。
ここでは、型システムを使用して懸念を`CircleBuilder`ました`CircleBuilder`のメソッドを使用して、`Circle`の選択を制限しています。
