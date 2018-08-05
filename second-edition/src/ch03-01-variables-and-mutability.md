## 変数と変更可能性

第2章で述べたように、自動的には変数は不変です。
Rustは、Rustが提供する安全性と容易な並列実行を利用して<ruby>譜面<rt>コード</rt></ruby>を記述するために、多くのナッジの1つです。
ただし、変数を変更可能にする<ruby>選択肢<rt>オプション</rt></ruby>はあります。
どのように、そしてなぜRustがあなたに不変性を奨励し、なぜ時々オプトアウトを希望するのかを探そう。

変数が不変の場合、値が名前に束縛されると、その値を変更することはできません。
これを説明するために、`cargo new --bin variables`を使用して、*projects*ディレクトリに*variables*という新しい企画を生成しましょう。

次に、新しい*変数*ディレクトリで、*src/main.rs*を開き、その<ruby>譜面<rt>コード</rt></ruby>を、まだ<ruby>製譜<rt>コンパイル</rt></ruby>されない次の<ruby>譜面<rt>コード</rt></ruby>に置き換えます。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

カーゴランを使用して<ruby>算譜<rt>プログラム</rt></ruby>を保存して実行し`cargo run`。
次の出力に示すように、<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。

```text
error[E0384]: cannot assign twice to immutable variable `x`
 --> src/main.rs:4:5
  |
2 |     let x = 5;
  |         - first assignment to `x`
3 |     println!("The value of x is: {}", x);
4 |     x = 6;
  |     ^^^^^ cannot assign twice to immutable variable
```

この例は、<ruby>製譜器<rt>コンパイラー</rt></ruby>がどのように<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>を見つけるのに役立つかを示しています。
<ruby>製譜器<rt>コンパイラー</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>は苛立つことがありますが、<ruby>算譜<rt>プログラム</rt></ruby>はあなたがまだやりたいことを安全に実行していないことを意味します。
それらはあなたが良い<ruby>演譜師<rt>プログラマー</rt></ruby>では*ない*ということを意味するものではありません！　
経験豊富なRustびた人はまだ<ruby>製譜器<rt>コンパイラー</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

<ruby>誤り<rt>エラー</rt></ruby>メッセージは、immutable `x`変数に2番目の値を代入しようとしたため、<ruby>誤り<rt>エラー</rt></ruby>の原因が`cannot assign twice to immutable variable x`示しています。

このような状況がバグにつながる可能性があるため、以前は不変として指定した値を変更しようとすると<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が発生することが重要です。
<ruby>譜面<rt>コード</rt></ruby>の一部が変更されず、<ruby>譜面<rt>コード</rt></ruby>の別の部分がその値を変更すると仮定して<ruby>譜面<rt>コード</rt></ruby>の一部が動作する場合、<ruby>譜面<rt>コード</rt></ruby>の最初の部分は設計されたものを実行しない可能性があります。
この種のバグの原因は事実の後で追跡するのが難しい場合が*あり*ます。特に<ruby>譜面<rt>コード</rt></ruby>の2番目の部分が値を*時々*変更する場合は特にそうです。

Rustでは、<ruby>製譜器<rt>コンパイラー</rt></ruby>は、値が変更されないことを宣言すると、実際には変更されないことを保証します。
つまり、<ruby>譜面<rt>コード</rt></ruby>を読み書きしているときに、値と値がどこでどのように変化するかを把握する必要はありません。
したがって、<ruby>譜面<rt>コード</rt></ruby>は理性的に簡単です。

しかし、変更可能性は非常に便利です。
変数は自動的にのみ変更できません。
第2章で行ったように、変数名の前に`mut`を追加することで変数を変更可能にすることができます。
この値を変更できることに加えて、`mut`は、<ruby>譜面<rt>コード</rt></ruby>の他の部分がこの変数値を変更することを示すことによって、将来の<ruby>譜面<rt>コード</rt></ruby>読者に意図を伝えます。

たとえば、*src/main.rs*を次のように変更します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

<ruby>算譜<rt>プログラム</rt></ruby>を今実行すると、次のようになります。

```text
$ cargo run
   Compiling variables v0.1.0 (file:///projects/variables)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/variables`
The value of x is: 5
The value of x is: 6
```

`mut`が使用されているとき、`x`束縛する値を`5`から`6`に変更することができます。
場合によっては、変数を変更可能にする必要があります。これは、変数に不変な変数がある場合よりも、<ruby>譜面<rt>コード</rt></ruby>を書く方が便利なためです。

バグの防止に加えて、考慮すべき複数の<ruby>相殺取引<rt>トレードオフ</rt></ruby>があります。
たとえば、大規模なデータ構造を使用している場合、<ruby>実例<rt>インスタンス</rt></ruby>を変更すると、新しく割り当てられた<ruby>実例<rt>インスタンス</rt></ruby>をコピーして返すよりも速くなる場合があります。
より小さなデータ構造では、新しい<ruby>実例<rt>インスタンス</rt></ruby>を作成し、より機能的な<ruby>演譜<rt>プログラミング</rt></ruby>作法で記述することが考えやすくなります。そのため、パフォーマンスが低下すると、その明快さを得るための価値のあるペナルティになる可能性があります。

### 変数と定数の違い

変数の値を変更できない場合は、他のほとんどの言語で使用されている別の<ruby>演譜<rt>プログラミング</rt></ruby>概念、つまり*定数*を思い出させるかもしれません。
不変変数と同様に、定数は名前に束縛され、変更が許可されない値ですが、定数と変数の間にはいくつかの違いがあります。

まず、定数で`mut`を使用することはできません。
定数は、自動的に不変ではなく、常に不変です。

`let`予約語の代わりに`const`予約語を使用して定数を宣言し、値の型に<ruby>注釈<rt>コメント</rt></ruby>を付ける*必要*が*あり*ます。
次の章「データ型」で型と型名を扱いますので、今のところ詳細を心配しないでください。
必ず型に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があることをご存じですか。

定数は大域<ruby>有効範囲<rt>スコープ</rt></ruby>を含む任意の<ruby>有効範囲<rt>スコープ</rt></ruby>で宣言することができ、<ruby>譜面<rt>コード</rt></ruby>の多くの部分が知る必要がある値に便利です。

最後の違いは、定数は機能呼び出しの結果や実行時にのみ計算できる他の値ではなく、定数式にのみ設定できることです。

次に、定数の名前が`MAX_POINTS`、その値が100,000に設定されている定数宣言の例を示します。
（Rustの定数の命名規則では、単語の間に下線を付けて大文字を使用します）。

```rust
const MAX_POINTS: u32 = 100_000;
```

定数は、<ruby>算譜<rt>プログラム</rt></ruby>が実行されている間、宣言された<ruby>有効範囲<rt>スコープ</rt></ruby>内で有効です。<ruby>算譜<rt>プログラム</rt></ruby>の複数の部分について知る必要のある<ruby>譜体<rt>アプリケーション</rt></ruby>特定領域内の値（たとえば、最大ポイント数ゲームのプレイヤーは、光の速度を得ることができます。

<ruby>算譜<rt>プログラム</rt></ruby>全体で定数として使用されているハード作譜された値の名前は、その値の意味を将来の<ruby>譜面<rt>コード</rt></ruby>のメンテナに伝えるのに便利です。
また、ハード<ruby>譜面<rt>コード</rt></ruby>された値を将来更新する必要がある場合は、<ruby>譜面<rt>コード</rt></ruby>内に1つの場所だけを変更して変更する必要があります。

### 遮蔽イング

第2章の「推測値と秘密番号の比較」の章のゲームのチュートリアルで見たように、以前の変数と同じ名前の新しい変数を宣言し、新しい変数が前の変数を遮蔽します。
ラステーシャンは、最初の変数は2番目の変数によって*覆わ*れていると言います。つまり、2番目の変数の値は変数が使用されたときの値です。
同じ変数の名前を使用し、`let`予約語の使用を次のように繰り返して、変数をシャドーできます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let x = 5;

    let x = x + 1;

    let x = x * 2;

    println!("The value of x is: {}", x);
}
```

この<ruby>算譜<rt>プログラム</rt></ruby>はまず、`x`を値`5`束縛します。
それ影`x`繰り返すことにより、`let x =`、元の値を取得し、追加`1`の値ように`x`次にである`6`。
3番目の`let`文は`x`遮蔽し、前の値に`2`を掛けて`x`に最終値`12`を与えます。
この<ruby>算譜<rt>プログラム</rt></ruby>を実行すると、次のものが出力されます。

```text
$ cargo run
   Compiling variables v0.1.0 (file:///projects/variables)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/variables`
The value of x is: 12
```

シャドーイングは変数を`mut`としてマークするのとは異なります。なぜなら、誤って`let`予約語を使用`let`ずにこの変数に再割り当てしようとすると、<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が発生するからです。
`let`を使って、値に対していくつかの変換を実行できますが、変換が完了した後は変数を不変にすることができます。

`mut`とshadowingのもう一つの違いは、`let`予約語を再び使用するときに新しい変数を効果的に作成するため、同じ名前を再利用することができます。
例えば、<ruby>算譜<rt>プログラム</rt></ruby>では、スペース文字を入力することによってテキストの間にいくつのスペースが必要かを表示するように利用者に求めていますが、実際にはその入力を数値として保存したいとします。

```rust
let spaces = "   ";
let spaces = spaces.len();
```

最初の`spaces`変数が<ruby>文字列<rt>ストリング</rt></ruby>型で、最初のものと同じ名前を持つまったく新しい変数である2番目の`spaces`変数が数値型なので、この構造体は許可されています。
したがって、`spaces_str`や`spaces_num`ような異なる名前を`spaces_num`ます。
代わりに、より単純な`spaces`名を再利用することができ`spaces`。
ただし、ここに示すように`mut`を使用しようとすると、<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```rust,ignore
let mut spaces = "   ";
spaces = spaces.len();
```

<ruby>誤り<rt>エラー</rt></ruby>は、変数の型を変更することができないと言っています。

```text
error[E0308]: mismatched types
 --> src/main.rs:3:14
  |
3 |     spaces = spaces.len();
  |              ^^^^^^^^^^^^ expected &str, found usize
  |
  = note: expected type `&str`
             found type `usize`
```

変数がどのように機能するかを調べたので、もっと多くのデータ型を見てみましょう。
