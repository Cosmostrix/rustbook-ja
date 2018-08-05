# ループ

Rustは現在、何らかの反復アクティビティを実行するための3つのアプローチを提供しています。
それらは： `loop`、 `while`と`for`。
各アプローチにはそれぞれ独自の使用法があります。

## ループ

無限`loop`は、Rustで利用可能な最も単純なループです。
Rustは、キーワード`loop`を使用して、終了ステートメントに達するまで無期限にループする方法を提供します。
錆の無限`loop`のようになります：

```rust,ignore
loop {
    println!("Loop forever!");
}
```

## while

錆には`while`ループもあります。
これは次のようになります。

```rust
#//let mut x = 5; // mut x: i32
let mut x = 5; //  mut x：i32
#//let mut done = false; // mut done: bool
let mut done = false; //  mut done：bool

while !done {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 {
        done = true;
    }
}
```

`while`ループは、ループする必要がある回数が不明な場合には正しい選択です。

無限ループが必要な場合は、次のように書くことができます。

```rust,ignore
while true {
```

しかし、このケースを処理するには`loop`がはるかに適しています。

```rust,ignore
loop {
```

Rustのコントロールフロー分析は、このループが常にループすることがわかっているので、この構成`while true`とは異なるものとして扱います。
一般的に、コンパイラに与えることができる情報が多くなればなるほど、安全性とコード生成が向上するので、無限`loop`ときは常に`loop`を優先する必要があります。

## ために

`for`ループは、特定の回数のループに使用されます。
しかし、Rustの`for`ループは、他のシステム言語とは少し違って動作します。
Rust's `for`ループは、この "Cスタイル"`for`ループのようには見えません：

```c
for (x = 0; x < 10; x++) {
    printf( "%d\n", x );
}
```

代わりに、次のようになります。

```rust
for x in 0..10 {
#//    println!("{}", x); // x: i32
    println!("{}", x); //  x：i32
}
```

やや抽象的な言葉では、

```rust,ignore
for var in expression {
    code
}
```

式は[`IntoIterator`]を使って[iterator]変換できるアイテムです。
イテレータは一連の要素を返します。ループの反復ごとに1つの要素が返されます。
その値はループ本体に有効な`var`という名前にバインドされます。
ボディーが終了すると、イテレーターから次の値がフェッチされ、もう一度ループします。
それ以上の値がない場合、`for`ループは終了します。

[iterator]: iterators.html
 [`IntoIterator`]: ../../std/iter/trait.IntoIterator.html


この例では、`0..10`は開始位置と終了位置をとり、それらの値を反復子とする式です。
上限は、しかし、排他的なので、私たちのループが印刷されます`0`を通じて`9`、ではない`10`。

Rustには目的の`for` "Cスタイル"`for`ループはありません。
経験豊富なC開発者であっても、ループの各要素を手動で制御することは複雑でエラーが発生しやすくなります。

### 列挙する

ループした回数を追跡する必要がある場合は、`.enumerate()`関数を使用できます。

#### オンレンジ：

```rust
for (index, value) in (5..10).enumerate() {
    println!("index = {} and value = {}", index, value);
}
```

出力：

```text
index = 0 and value = 5
index = 1 and value = 6
index = 2 and value = 7
index = 3 and value = 8
index = 4 and value = 9
```

範囲の周りにかっこを追加することを忘れないでください。

#### イテレータでは：

```rust
let lines = "hello\nworld".lines();

for (linenumber, line) in lines.enumerate() {
    println!("{}: {}", linenumber, line);
}
```

出力：

```text
0: hello
1: world
```

## 初期の反復の終了

のは、その見てみましょう`while`、我々は以前持っていたループを：

```rust
let mut x = 5;
let mut done = false;

while !done {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 {
        done = true;
    }
}
```

私たちは、専用続けなければならなかった`mut`、結合ブール変数を`done`、我々はループの外に出る必要があるときに知っています、。
Rustには、繰り返しを修正するのに役立つ2つのキーワード`break` ＆ `continue`ます。

この場合、`break`を`break`てより良い方法でループを書くことができます：

```rust
let mut x = 5;

loop {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 { break; }
}
```

私たちは今、ループで永遠に`loop`、早めにブレークアウトする`break`にブレークを使います。
明示的な`return`文を発行すると、ループを早期に終了させることもできます。

`continue`も同様ですが、ループを終了する代わりに、次の繰り返しに進みます。
奇数のみが出力されます：

```rust
for x in 0..10 {
    if x % 2 == 0 { continue; }

    println!("{}", x);
}
```

## ループラベル

ネストされたループがあり、`break`または`continue`ステートメントの対象となるステートメントを指定する必要がある場合もあります。
他のほとんどの言語と同様に、Rustの`break`または`continue`は最も内側のループに適用されます。
外部ループの1つを`break`または`continue`したい場合は、ラベルを使用して`break`または`continue`ステートメントが適用されるループを指定できます。
以下の例では、我々は、`continue`の次の反復に`outer`ときループ`x`偶数で、我々はしながら、`continue`の次の反復に`inner` yが偶数である場合、ループ。
したがって、`x`と`y`両方が奇数であるときに`println!`を実行します。

```rust
'outer: for x in 0..10 {
    'inner: for y in 0..10 {
#//        if x % 2 == 0 { continue 'outer; } // Continues the loop over `x`.
        if x % 2 == 0 { continue 'outer; } // ループを`x`続行します。
#//        if y % 2 == 0 { continue 'inner; } // Continues the loop over `y`.
        if y % 2 == 0 { continue 'inner; } // ループを`y`続行します。
        println!("x: {}, y: {}", x, y);
    }
}
```
