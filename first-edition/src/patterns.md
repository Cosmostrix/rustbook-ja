# パターン

パターンはRustではかなり一般的です。
[variable bindings][bindings]、 [マッチ式][match]、その他の場所でもそれらを使用します。
パターンができるすべてのものの旋風のツアーに行きましょう！　

[bindings]: variable-bindings.html
 [match]: match.html


速いリフレッシャー。直書きと直接照合でき、`_`は任意のケースとして機能します。

```rust
let x = 1;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

これは`one`印字します。

いずれの場合でも、値の束縛を作成することは可能です。

```rust
let x = 1;

match x {
    y => println!("x: {} y: {}", x, y),
}
```

これは印字します。

```text
x: 1 y: 1
```

同じマッチ段落内にcatch-all `_`束縛とcatch-all束縛の両方を持つことは誤りです。

```rust
let x = 1;

match x {
    y => println!("x: {} y: {}", x, y),
#//    _ => println!("anything"), // this causes an error as it is unreachable
    _ => println!("anything"), // これは到達不能なので誤りを引き起こす
}
```

パターンには1つの落とし穴があります。新しい束縛を導入するもののように、シャドーイングを導入します。
例えば。

```rust
let x = 1;
let c = 'c';

match c {
    x => println!("x: {} c: {}", x, c),
}

println!("x: {}", x)
```

これは印字します。

```text
x: c c: c
x: 1
```

言い換えれば、`x =>`はパターンにマッチし、`x`という名前の新しい束縛を導入します。
この新しい束縛はマッチアームの範囲にあり、`c`の値をとり`c`。
値ことに注意してください`x`一致の範囲外での値にはベアリングがありません`x`その中に。
すでに`x`という名前の束縛があるので、この新しい`x`それを遮蔽します。

# 複数のパターン

複数のパターンを`|`
。

```rust
let x = 1;

match x {
    1 | 2 => println!("one or two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

これは、`one or two`印字します。

# 破壊

[`struct`][struct]ような複合データ型を持つ場合は、パターン内で[`struct`][struct]化することができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { x, y } => println!("({},{})", x, y),
}
```

[struct]: structs.html

使用することができます`:`値に別の名前を付けるために。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { x: x1, y: y1 } => println!("({},{})", x1, y1),
}
```

値の一部しか気にしない場合は、すべての名前を指定する必要はありません。

```rust
struct Point {
    x: i32,
    y: i32,
}

let point = Point { x: 2, y: 3 };

match point {
    Point { x, .. } => println!("x is {}", x),
}
```

この`x is 2`です。

最初の要素だけでなく、どの要素でも次のような種類のマッチを行うことができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

let point = Point { x: 2, y: 3 };

match point {
    Point { y, .. } => println!("y is {}", y),
}
```

この`y is 3`です。

この「非構造化」動作は、[tuples][tuples]や[enums][enums]型などの複合データ型で機能します。

[tuples]: primitive-types.html#tuples
 [enums]: enums.html


# 束縛を無視する

パターンで`_`を使用すると、型と値を無視できます。
たとえば、`Result<T, E>` `match` `Result<T, E>`。

```rust
# let some_value: Result<i32, &'static str> = Err("There was an error");
match some_value {
    Ok(value) => println!("got a value: {}", value),
    Err(_) => println!("an error occurred"),
}
```

最初の腕では、`Ok`場合値内の値をvalueに束縛し`value`。
しかし、`Err`アームで`_`を使用して特定の誤りを無視し、一般的な誤りメッセージを表示します。

`_`は、束縛を作成するすべてのパターンで有効です。
これは、より大きな構造の部分を無視するのに便利です。

```rust
fn coordinate() -> (i32, i32, i32) {
#    // Generate and return some sort of triple tuple.
    // 生成し、何らかの3つの組を返します。
# (1, 2, 3)
}

let (x, _, z) = coordinate();
```

ここでは、組の最初と最後の要素を`x`と`z`に束縛しますが、中間の要素は無視します。

`_`を使用すると、最初は値が束縛されないことに注意してください。これは、値が移動しないことを意味します。

```rust
let tuple: (u32, String) = (5, String::from("five"));

#// Here, tuple is moved, because the String moved:
// ここでは、文字列が移動されたため、組が移動されます。
let (x, _s) = tuple;

#// The next line would give "error: use of partially moved value: `tuple`".
#// println!("Tuple is: {:?}", tuple);
// 次の行は、"誤り。部分的に移動された値の使用。 `tuple` "となります。println！　（"組は。{。？　}"、組）;

#// However,
// しかしながら、

let tuple = (5, String::from("five"));

#// Here, tuple is _not_ moved, as the String was never moved, and u32 is Copy:
// ここで、組は移動され _ません。_ 文字列は決して移動されず、u32はCopy。
let (x, _) = tuple;

#// That means this works:
// これは、この作品を意味します。
println!("Tuple is: {:?}", tuple);
```

これは、文の終わりに一時変数がすべて削除されることを意味します。

```rust
#// Here, the String created will be dropped immediately, as it’s not bound:
// ここでは、作成されたStringは、束縛されていないため、すぐに削除されます。

let _ = String::from("  hello  ").trim();
```

また、複数の値を無視するパターンで`..`を使用することもでき`..`

```rust
enum OptionalTuple {
    Value(i32, i32, i32),
    Missing,
}

let x = OptionalTuple::Value(5, -2, 3);

match x {
    OptionalTuple::Value(..) => println!("Got a tuple!"),
    OptionalTuple::Missing => println!("No such luck."),
}
```

この印字`Got a tuple!`。

# refとref mut

[reference][ref]を取得するには、`ref`予約語を使用します。

```rust
let x = 5;

match x {
    ref r => println!("Got a reference to {}", r),
}
```

この印字`Got a reference to 5`。

[ref]: references-and-borrowing.html

ここでは、`match`内の`r`は`&i32`型です。
言い換えると、`ref`予約語 _は_ 、パターンで使用するための参照を _作成_ します。
mutable参照が必要な場合、`ref mut`は同じように動作します。

```rust
let mut x = 5;

match x {
    ref mut mr => println!("Got a mutable reference to {}", mr),
}
```

# レンジ

あなたは値の範囲を`...`と一致させることができ`...`。

```rust
let x = 1;

match x {
    1 ... 5 => println!("one through five"),
    _ => println!("anything"),
}
```

これは`one through five`印字します。

範囲は主に整数と`char`使用されます。

```rust
let x = '💅';

match x {
    'a' ... 'j' => println!("early letter"),
    'k' ... 'z' => println!("late letter"),
    _ => println!("something else"),
}
```

これは`something else`印字`something else`。

# 束縛

名前を`@`束縛することができます。

```rust
let x = 1;

match x {
    e @ 1 ... 5 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

この印字`got a range element 1`ます。
これは、データ構造の一部の複雑な一致を実行する場合に便利です。

```rust
#[derive(Debug)]
struct Person {
    name: Option<String>,
}

let name = "Steve".to_string();
let x: Option<Person> = Some(Person { name: Some(name) });
match x {
    Some(Person { name: ref a @ Some(_), .. }) => println!("{:?}", a),
    _ => {}
}
```

これは`Some("Steve")`印字`a`ます。内側の`name`を`a`束縛しまし`a`。

`@`を`|`と使用すると、
名前がパターンの各部分に束縛されていることを確認する必要があります。

```rust
let x = 5;

match x {
    e @ 1 ... 5 | e @ 8 ... 10 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

# 警備員

次の`if` 「マッチガード」を導入することができます。

```rust
enum OptionalInt {
    Value(i32),
    Missing,
}

let x = OptionalInt::Value(5);

match x {
    OptionalInt::Value(i) if i > 5 => println!("Got an int bigger than five!"),
    OptionalInt::Value(..) => println!("Got an int!"),
    OptionalInt::Missing => println!("No such luck."),
}
```

これ`Got an int!`。

複数のパターンを持つ`if`を使用している`if`、 `if`は両側に適用されます。

```rust
let x = 4;
let y = false;

match x {
    4 | 5 if y => println!("yes"),
    _ => println!("no"),
}
```

これは`no`。これは、 `if`が`4 | 5`の全体に適用されるため`if` `4 | 5`
`4 | 5`だけではなく、`5`だけではありません。
つまり、`if`の優先順位は次のようになります。

```text
(4 | 5) if y => ...
```

これではない。

```text
4 | (5 if y) => ...
```

# ミックスアンドマッチ

すごい！　
それは物事にマッチするさまざまな方法ですが、あなたがしていることに応じて、それらはすべて混合してマッチさせることができます。

```rust,ignore
match x {
    Foo { x: Some(ref name), y: None } => ...
}
```

パターンは非常に強力です。
それらをうまく活用してください。
