## 制御の流れ

条件が真であるかどうかによっていくつかの譜面を実行するかどうかを決定し、条件が真である間に何度かの譜面を繰り返し実行することを決定することは、ほとんどの演譜言語の基本的な組み上げ段落です。
Rust譜面の実行フローを制御できる最も一般的な構造は`if`式とループの`if`です。

### `if`式

`if`式を使用すると、条件に応じて譜面を分岐することができます。
条件を指定し、「この条件が満たされている場合は、この譜面段落を実行します。
条件が満たされない場合は、この譜面段落を実行しないでください。

`if`式を調べるために、*projects*ディレクトリに*branches*という名前の新しい企画を作成します。
*src / main.rs*ファイルに、次のように入力します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let number = 3;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }
}
```


すべて`if`式は予約語`if`で始まり、その後に条件が続きます。
この場合、変数`number`の値が5より小さいかどうかがチェックされます。条件が真である場合に実行する譜面段落は、中かっこ内の条件の直後に配置されます。
状況に関連付けられた譜面の段落`if`だけで腕のように、式は時々 *武器*と呼ばれている`match`、第2章の「暗証番号を推測の比較」章で説明した表情。

必要に応じて、条件をfalseに評価した場合に実行する別の譜面段落を算譜に与えるために、ここで選択した`else`式を含めることもできます。
`else`式を指定せず、条件がfalseの場合、算譜は`if`段落をスキップして次の譜面に移ります。

この譜面を実行してみてください。
次の出力が表示されます。

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
condition was true
```

`number`の値を`false`にする値に変更して、何が起こるかを見てみましょう。

```rust,ignore
let number = 7;
```

算譜をもう一度実行し、出力を確認します。

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
condition was false
```

また、この譜面の条件が`bool` *なければならない*ことにも注意してください。
条件が`bool`でない場合は、誤りが発生します。
たとえば、次の譜面を実行してみてください。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let number = 3;

    if number {
        println!("number was three");
    }
}
```

今回は`if`条件の値が`3`評価され、Rustは誤りを送出します。

```text
error[E0308]: mismatched types
 --> src/main.rs:4:8
  |
4 |     if number {
  |        ^^^^^^ expected bool, found integral variable
  |
  = note: expected type `bool`
             found type `{integer}`
```

この誤りは、Rustが`bool`期待していたのに整数を持っていることを示しています。
RubyやJavaScriptなどの言語とは異なり、Rustはブール型以外の型をブール型に自動的に変換しようとはしません。
あなたは明示的でなければならず、いつも`if`を条件として真偽値を指定する必要があります。
たとえば、数字が`0`に等しくない場合にのみ`if` code段落を実行したい`if`、 `if`式を次のように変更できます。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let number = 3;

    if number != 0 {
        println!("number was something other than zero");
    }
}
```

この譜面を実行すると、print `number was something other than zero`。

#### `else if`複数の条件の処理`else if`

`else if`式で`if`と`else`を組み合わせることで`if`複数の条件を満たすことができます。
例えば。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let number = 6;

    if number % 4 == 0 {
        println!("number is divisible by 4");
    } else if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 4, 3, or 2");
    }
}
```

この算譜には4つの可能なパスがあります。
実行後、次の出力が表示されます。

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
number is divisible by 3
```

この算譜を実行すると、それはそれぞれのを確認し`if`式順番に、条件が成立しているため、第1の本体を実行します。
6が2で割り切れるにもかかわらず、出力`number is divisible by 2`で`number is not divisible by 4, 3, or 2`、 `else`段落から`else` `number is not divisible by 4, 3, or 2`文言で`number is not divisible by 4, 3, or 2`ことも分かりませ`else`。
これは、Rustが最初の真の条件の段落のみを実行し、見つかったら残りの部分をチェックしないからです。

式が譜面を混乱させる可能性がある`else if`余りにも多くを使用するので`else if`式がある場合は、譜面をリファクタリングすることができます。
第6章では、これらの場合の`match`と呼ばれる強力なRust分岐構造について説明します。

#### `let`文で`if`を使う

`if`は式なので、リスト3-2のように、`let`文の右側でそれを使用できます。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let condition = true;
    let number = if condition {
        5
    } else {
        6
    };

    println!("The value of number is: {}", number);
}
```

<span class="caption">リスト3-2。 <code>if</code>式の結果を変数に代入する</span>

`number`変数は、`if`式の結果に基づいて値に束縛されます。
この譜面を実行すると、何が起こるかを確認できます。

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/branches`
The value of number is: 5
```

譜面段落は、それらの中の最後の式に評価され、数字だけでも式であることを覚えておいてください。
この場合、`if`式全体の値は、実行する譜面の段落によって異なります。
つまり、`if`各腕の結果となる可能性のある値は同じ型でなけれ`if`なりません。
リスト3-2の`if` armと`else` armの両方の結果は`i32`整数でした。
次の例のように型が一致しない場合、誤りが発生します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let condition = true;

    let number = if condition {
        5
    } else {
        "six"
    };

    println!("The value of number is: {}", number);
}
```

この譜面を製譜しようとすると、誤りが発生します。
`if`と`else`武器には互換性のない値の型があり、Rustは算譜のどこで問題を見つけるかを正確に示します。

```text
error[E0308]: if and else have incompatible types
 --> src/main.rs:4:18
  |
4 |       let number = if condition {
  |  __________________^
5 | |         5
6 | |     } else {
7 | |         "six"
8 | |     };
  | |_____^ expected integral variable, found &str
  |
  = note: expected type `{integer}`
             found type `&str`
```

`if`段落の式は整数に評価され、`else`段落の式は文字列に評価されます。
変数は単一の型でなければならないため、これは機能しません。
Rustは、どのような型の製譜時に知っておく必要のある`number`変数が決定的であり、それは、その型はどこでも使用する有効であることを製譜時に確認することができます`number`。
実行時に`number`の型が決定されただけの場合、Rustはそれを実行できません。
製譜器はより複雑になり、任意の変数に対して複数の仮説型を追跡しなければならない場合、譜面の保証が少なくなります。

### ループによる繰り返し

1つの譜面段落を複数回実行すると便利なことがよくあります。
この仕事では、Rustはいくつかの*ループを*提供し*ます*。
ループは、ループ本体内の譜面を最後まで実行した後、最初からすぐに開始します。
ループを試すために、のは、*ループ*と呼ばれる新しい企画を作成してみましょう。

Rustには3種類のループがあります。 `loop`、 `while`、 `for`。
それぞれを試してみましょう。

#### `loop`譜面を`loop`

`loop`予約語は、Rustに譜面の段落を何度も何度も何度も何度も実行するように、または明示的に停止するよう指示するまで繰り返します。

例として、あなたの*ループ*ディレクトリの*src / main.rs*ファイルを*次の*ように変更します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    loop {
        println!("again!");
    }
}
```

この算譜を実行すると、表示されます`again!`算譜を手動で停止するまで継続的にオーバーオーバー印字さと。
ほとんどの端末では、キーボード近道<span class="keystroke">ctrl-c</span>を使用して、連続したループで停止している算譜を停止します。
試してみる。

```text
$ cargo run
   Compiling loops v0.1.0 (file:///projects/loops)
    Finished dev [unoptimized + debuginfo] target(s) in 0.29 secs
     Running `target/debug/loops`
again!
again!
again!
again!
^Cagain!
```

記号`^C`は、<span class="keystroke">ctrl-c</span>を押した場所を表します。
`^C`後には、停止信号を受信したときにループ内の譜面がどこにあったかに応じて、`again!`その単語が表示されるかどうかはわかりません。

幸いにも、Rustは、ループから脱出するための、より信頼性の高い別の方法を提供します。
ループ内で`break`予約語を使用して、ループの実行を停止するタイミングを算譜に指示できます。
ユーザーが正しい数を推測してゲームに勝ったときに算譜を終了するには、第2章の「正しい推測の後に終了する」章の推測ゲームでこれを実行したことを思い出してください。

#### `while`条件付きループ

算譜がループ内の状態を評価することはしばしば有用です。
条件が真である間に、ループが実行されます。
条件が真でなくなると、算譜は`break`呼び出してループを停止します。
このループ型は、`loop`、 `if`、 `else`、および`break`組み合わせを使用して実装できます。
あなたが望むのであれば、算譜でこれを試すことができます。

しかし、このパターンは非常に一般的なので、Rustには`while`ループと呼ばれる組み込みの言語構造が`while`ます。
譜面リスト3-3は`while`使っています。算譜は3回ループし、毎回カウントダウンしてから、ループの後に別のメッセージを出力して終了します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{}!", number);

        number = number - 1;
    }

    println!("LIFTOFF!!!");
}
```

<span class="caption">リスト3-3。条件がtrueのときに<code>while</code>ループを使って譜面を実行する</span>

この構造体は、`loop`、 `if`、 `else`、および`break`を使用した場合に必要となる多くのネストを排除し、より明確になります。
条件が成立している間は、譜面が実行されます。
それ以外の場合は、ループを終了します。

#### 集まりをループ`for`

`while`構造体を使用して、配列などの集まりの要素をループすることができます。
たとえば、リスト3-4を見てみましょう。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];
    let mut index = 0;

    while index < 5 {
        println!("the value is: {}", a[index]);

        index = index + 1;
    }
}
```

<span class="caption">リスト3-4。 <code>while</code>ループを使って集まりの各要素<code>while</code>ループする</span>

ここで、譜面は配列内の要素をカウントアップします。
添字`0`から始まり、配列の最後の添字に到達するまでループします（つまり、`index < 5`がもはや真ではない場合）。
この譜面を実行すると、配列のすべての要素が出力されます。

```text
$ cargo run
   Compiling loops v0.1.0 (file:///projects/loops)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
     Running `target/debug/loops`
the value is: 10
the value is: 20
the value is: 30
the value is: 40
the value is: 50
```

期待どおり、5つの配列値がすべて端末に表示されます。
`index`がある時点で`5`値に達するにもかかわらず、ループは実行を停止してから、配列から6番目の値をフェッチしようとします。

しかし、このアプローチは誤りが起こりやすい。
添字の長さが間違っていると、算譜がパニックに陥る可能性があります。
製譜器ーは、ループを介したすべての反復ですべての要素の条件チェックを実行するための実行時譜面を追加するため、処理速度も遅くなります。

より簡潔な方法として、`for`ループを使用して、集まり内の各項目に対していくつかの譜面を実行することができます。
`for`ループは譜面リスト3-5の譜面のようになります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];

    for element in a.iter() {
        println!("the value is: {}", element);
    }
}
```

<span class="caption">リスト3-5。 <code>for</code>ループを使って集まりの各要素<code>for</code>ループする</span>

この譜面を実行すると、譜面リスト3-4と同じ出力が表示されます。
さらに重要なのは、譜面の安全性を高め、配列の終わりを越えるか、十分に遠くに行かなくても、いくつかの項目が見つからないことに起因するバグの可能性を排除したことです。

たとえば、リスト3-4の譜面では`a`配列から項目を削除したが`while index < 4`条件を更新するのを忘れた場合、譜面はパニックに陥ります。
`for`ループを使用する`for`、配列内の値の数を変更した場合は、他の譜面を変更する必要はありません。

`for`ループの安全性と簡潔さは、Rustの最も一般的に使用されるループ構造になります。
リスト3-3の`while`ループを使用したカウントダウンの例のように、特定の回数だけ譜面を実行したい場合でも、ほとんどのRustびた人は`for`ループを使用`for`ます。
これを行う方法は、`Range`を使用すること`Range`。これは、標準譜集によって提供される型で、すべての数値を1つの数値から順番に生成し、別の数値より前に終了する形式です。

ここでは、カウントダウンは、`for`ループと、まだ取り上げていない`rev`を使って範囲を逆転させるようなものです。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    for number in (1..4).rev() {
        println!("{}!", number);
    }
    println!("LIFTOFF!!!");
}
```

この譜面はちょっといいですね。

## 概要

やった！　
それはかなりの章でした。変数、スカラーと複合データ型、機能、コメント、`if`式、ループについて学びました！　
この章で説明する概念で練習する場合は、以下のことを行う算譜を作成してみてください。

* 華氏と摂氏の間の温度を変換します。
* n番目のフィボナッチ数を生成します。
* 歌の繰り返しを利用して、クリスマスキャロル「The Twelve Days of Christmas」に歌詞を印字します。

次に進む準備が整ったら、他の演譜言語に*は*一般的に存在*しない* Rustの概念、つまり所有権について説明します。
