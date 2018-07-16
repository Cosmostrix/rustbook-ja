## 機能

機能はRustの譜面に広がっています。
あなたはすでに言語の中で最も重要な機能の1つを見てきました。`main`機能は、多くの算譜の入り口です。
新しい機能を宣言できる`fn`予約語も見てきました。

Rust譜面は、機能名と変数名の従来のスタイルとして*スネークケース*を使用します。
スネークの場合、すべての文字は小文字で、単語は別々になっています。
ここに、機能定義の例を含む算譜があります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    println!("Hello, world!");

    another_function();
}

fn another_function() {
    println!("Another function.");
}
```

Rustの機能定義は`fn`で始まり、機能名の後にかっこが付きます。
中かっこは、機能本体の始まりと終わりを製譜器に伝えます。

定義した機能は、その名前の後ろにかっこを付けて呼び出すことができます。
`another_function`は算譜で定義されているので、`main`機能の内部から呼び出すことができます。
原譜の`main`機能の*後*に`another_function`を定義したことに注意してください。
それ以前にも定義できました。
Rustはどこで機能を定義するかは気にせず、どこかで定義されているだけです。

さらに機能を探索する*機能を*という名前の新しい二進譜企画を開始してみましょう。
`another_function`例を*src / main.rsに置き*、実行します。
次の出力が表示されます。

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.28 secs
     Running `target/debug/functions`
Hello, world!
Another function.
```

これらの行は、`main`機能に現れる順に実行されます。
まず、"Hello、world！　"メッセージが表示され、`another_function`が呼び出され、そのメッセージが表示されます。

### 機能のパラメータ

機能は、機能の型指示の一部である特殊変数である*パラメータ*を持つように定義することもできます。
機能にパラメータがある場合は、それらのパラメータの具体的な値を与えることができます。
技術的には、具体的な値は*引数*と呼ばれ*ます*が、カジュアルな会話では、機能の定義内の変数または機能を呼び出すときに渡される具体的な値のいずれかにword *パラメータ*と*引数を*交換する傾向があります。

`another_function`の次の書き直し版は、Rustでどのようなパラメータが見えるかを示しています。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    another_function(5);
}

fn another_function(x: i32) {
    println!("The value of x is: {}", x);
}
```

この算譜を実行してみてください。
次の出力が得られるはずです。

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 1.21 secs
     Running `target/debug/functions`
The value of x is: 5
```

`another_function`の宣言には、`x`という名前のパラメータが1つあります。
`x`の型は`i32`として指定されます。
`another_function` `5`が渡されると、`println!`マクロは、中かっこのペアが書式文字列内にあったところに`5`置きます。

関数型指示では、各パラメータの型を宣言する*必要*が*あり*ます。
これは、Rustの設計における意図的な決定です。機能の定義に型の注釈が必要なことは、製譜器が、譜面のどこかでそれらを使用する必要がほとんどないことを意味します。

機能に複数のパラメータを指定する場合は、パラメータ宣言を次のようにカンマで区切ります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    another_function(5, 6);
}

fn another_function(x: i32, y: i32) {
    println!("The value of x is: {}", x);
    println!("The value of y is: {}", y);
}
```

この例では、両方とも`i32`型の2つのパラメータを持つ機能を作成します。
この機能は、両方のパラメータに値を出力します。
機能のパラメータはすべて同じ型である必要はないことに注意してください。

この譜面を実行してみましょう。
*機能*企画の*src / main.rs*ファイルにある算譜を上記の例に置き換え、`cargo run`を使用して`cargo run`。

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/functions`
The value of x is: 5
The value of y is: 6
```

`x`の値として`5`を、`y`の値として`6`を渡したので、2つの文字列はこれらの値で出力されます。

### 機能本体には文と式が含まれています

機能本体は、選択肢で式で終わる一連の文で構成されます。
これまでは、式を終了することなく機能のみを扱ってきましたが、式の一部として式を参照しています。
Rustは式ベースの言語なので、これは重要な違いです。
他の言語でも同じ区別がないので、どの文や式がどのようなものか、その違いが機能の本体にどのように影響するかを見てみましょう。

実際にはすでに文と式を使用しています。
*文*は、何らかの動作を実行し、値を返さない命令です。
*式*は結果の値に評価されます。
いくつかの例を見てみましょう。

変数を作成し、`let`予約語を使用して変数に値を代入することは、文です。
リスト3-1では`let y = 6;`
声明です。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let y = 6;
}
```

<span class="caption">リスト3-1。1つの文を含む<code>main</code>機能宣言</span>

機能定義も文です。
前の例全体が単独の文です。

文は値を返しません。
したがって、`let`文を別の変数に代入することはできません。次の譜面が実行しようとしています。
誤りが表示されます。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let x = (let y = 6);
}
```

この算譜を実行すると、次のような誤りが表示されます。

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
error: expected expression, found statement (`let`)
 --> src/main.rs:2:14
  |
2 |     let x = (let y = 6);
  |              ^^^
  |
  = note: variable declaration using `let` is a statement
```

`let y = 6`文は値を返さないので、`x`に束縛するものはありません。
これは、代入が代入の値を返すCやRubyなど、他の言語で行われる処理とは異なります。
それらの言語では、`x = y = 6`と書くことができ、`x`と`y`両方に値`6`持たせることができます。
それはRustの場合ではありません。

式は何かに評価され、Rustで書く残りの譜面のほとんどを占めます。
`5 + 6`ような単純な数学演算を考えてみましょう。これは値`11`評価される式です。
式は文の一部です。リスト3-1では、文の`6`が`let y = 6;`
値`6`評価される式です。
機能の呼び出しは式です。
マクロの呼び出しは式です。
新しい有効範囲を作成するために使用する段落`{}`は式です。たとえば、次のようになります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let x = 5;

    let y = {
        let x = 3;
        x + 1
    };

    println!("The value of y is: {}", y);
}
```

この式は、

```rust,ignore
{
    let x = 3;
    x + 1
}
```

この場合、`4`と評価される段落です。
その値は`let`文の一部として`y`に束縛されます。
最後にセミコロンを付けない`x + 1`行に注目してください。これはあなたがこれまで見てきたほとんどの行とは異なります。
式には終了セミコロンは含まれません。
式の最後にセミコロンを追加すると、文に変換され、文に値が返されません。
次に機能の戻り値と式を調べるときは、このことを覚えておいてください。

### 戻り値を持つ機能

機能はそれらを呼び出す譜面に値を返すことができます。
戻り値の名前は付けませんが、矢印の後に型を宣言します（`->`）。
Rustでは、機能の戻り値は、機能本体の段落内の最終式の値と同義です。
`return`予約語を使用して値を指定することで、機能から早期に戻ることができますが、ほとんどの機能は最後の式を暗黙的に返します。
次に、値を返す機能の例を示します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn five() -> i32 {
    5
}

fn main() {
    let x = five();

    println!("The value of x is: {}", x);
}
```

`five`機能には機能呼び出し、マクロ、または`let`文はありません。それは`5`番だけです。
これは、Rustの完全に有効な機能です。
機能の戻り値の型も`-> i32`として指定されていることに注意してください。
この譜面を実行してみてください。
出力は次のようになります。

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/functions`
The value of x is: 5
```

`5`中`five`戻り値の型である理由である機能の戻り値であり、`i32`。
これをより詳細に調べてみましょう。
重要な2つのビットがあります。まず、`let x = five();`
変数の初期化に機能の戻り値を使用していることを示しています。
機能ので`five`戻る`5`、その行は、次のと同じです。

```rust
let x = 5;
```

第2に、`five`機能はパラメータを持たず、戻り値の型を定義しますが、機能の本体はセミコロンを持たない孤独な`5`です。

別の例を見てみましょう。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let x = plus_one(5);

    println!("The value of x is: {}", x);
}

fn plus_one(x: i32) -> i32 {
    x + 1
}
```

この譜面を実行すると`The value of x is: 6`ます。
しかし、`x + 1`を含む行の最後にセミコロンを置いて式から文に変更すると、誤りが発生します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let x = plus_one(5);

    println!("The value of x is: {}", x);
}

fn plus_one(x: i32) -> i32 {
    x + 1;
}
```

この譜面を実行すると、次のような誤りが発生します。

```text
error[E0308]: mismatched types
 --> src/main.rs:7:28
  |
7 |   fn plus_one(x: i32) -> i32 {
  |  ____________________________^
8 | |     x + 1;
  | |          - help: consider removing this semicolon
9 | | }
  | |_^ expected i32, found ()
  |
  = note: expected type `i32`
             found type `()`
```

メインの誤りメッセージ "型が一致しません"では、この譜面の中核的な問題が明らかになります。
機能`plus_one`の定義では、`i32`を返しますが、文は評価されません。この値は空の組`()`で表されます。
したがって、何も返されず、機能定義と矛盾し、誤りが発生します。
この出力では、Rustはこの問題を解決するためのメッセージを提供します。セミコロンを削除することが推奨されています。これにより誤りが修正されます。
