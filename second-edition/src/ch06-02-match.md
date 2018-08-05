## `match`<ruby>制御構造<rt>コントロールフロー</rt></ruby>演算子

Rustには非常に強力な<ruby>制御構造<rt>コントロールフロー</rt></ruby>演算子`match`があり、一連のパターンと値を比較し、一致するパターンに基づいて<ruby>譜面<rt>コード</rt></ruby>を実行することができます。
パターンは、<ruby>直書き<rt>リテラル</rt></ruby>値、変数名、ワイルドカード、その他多くのもので構成できます。
第18章では、さまざまな種類のパターンとそのパターンについて説明します。
`match`の威力は、パターンの表現力と、可能性のあるすべてのケースが処理されていることを<ruby>製譜器<rt>コンパイラー</rt></ruby>ーが確認したことにあります。

`match`式をコイン選別機のように考える。コインは、それに沿ってさまざまなサイズの穴があるトラックを滑り落ち、各コインは、適合する最初の穴に落ちます。
同様に、値は`match`各パターンを通過し、最初のパターンでは値が「適合」すると、その値は実行中に使用される関連する譜面<ruby>段落<rt>ブロック</rt></ruby>に分類されます。

ちょうどコインについて言及したので、`match`使用してコインを例として使用しましょう！　
リスト6-3に示すように、未知の米国のコインを受け取る機能を書くことができます。これは、計数機と同様に、コインがどれであるかを判定し、その値をセントで返すことができます。

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u32 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

<span class="caption">リスト6-3。列挙型とそのパターンとしての列挙型の変形を持つ<code>match</code>式</span>

`value_in_cents`機能の`match`を分解してみましょう。
まず、`match`予約語の後に​​式を指定します。この場合、値は`coin`です。
これはで使用される式に非常に似ているようだ`if`、しかし、大きな違いがあります。で`if`、式は真偽値を返す必要がありますが、ここでは、それがどの型にすることができます。
この例の`coin`の型は、1行目で定義した`Coin`列挙型です。

次は`match`分岐です。
分岐にはパターンと<ruby>譜面<rt>コード</rt></ruby>の2つの部分があります。
最初の分岐には、値`Coin::Penny`のパターンがあり、パターンと実行する<ruby>譜面<rt>コード</rt></ruby>を分ける`=>`演算子があります。
この場合の<ruby>譜面<rt>コード</rt></ruby>は値`1`すぎません。
各分岐は次の分岐とカンマで区切られています。

`match`式が実行されると、結果の値と各分岐のパターンが順番に比較されます。
パターンが値と一致する場合、そのパターンに関連付けられた<ruby>譜面<rt>コード</rt></ruby>が実行されます。
そのパターンが値と一致しない場合、コインソーティング機械と同様に、次の分岐に実行が継続されます。
リスト6-3では、`match`は4つの武器があります。

各分岐に関連付けられた<ruby>譜面<rt>コード</rt></ruby>は式であり、一致する分岐の式の結果の値は`match`式全体に対して返される値です。

カーブブラケットは、マッチ分岐<ruby>譜面<rt>コード</rt></ruby>が短い場合は通常は使用されません。リスト6-3のように、各分岐が値を返すだけです。
マッチ分岐で複数行の<ruby>譜面<rt>コード</rt></ruby>を実行する場合は、中かっこを使用できます。
たとえば、次の<ruby>譜面<rt>コード</rt></ruby>は、<ruby>操作法<rt>メソッド</rt></ruby>が`Coin::Penny`呼び出されるたびに "Lucky penny！　"を出力しますが、<ruby>段落<rt>ブロック</rt></ruby>の最後の値を返します（`1`。

```rust
# enum Coin {
#    Penny,
#    Nickel,
#    Dime,
#    Quarter,
# }
#
fn value_in_cents(coin: Coin) -> u32 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        },
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

### 値に束縛するパターン

マッチ分岐のもう1つの便利な機能は、パターンにマッチする値の部分に束縛できることです。
これは列挙型から値を抽出する方法です。

例として、enum<ruby>場合値<rt>バリアント</rt></ruby>の1つを内部に保持するように変更しましょう。
1999年から2008年にかけて、米国は50の州ごとに異なる設計の四半期を片面化した。
他の硬貨は国家の設計を得ていませんので、四半期にはこの特別な価値があります。
この情報を`enum`追加するには、`Quarter`<ruby>場合値<rt>バリアント</rt></ruby>を変更して、内部に格納された`UsState`値を`UsState`ます（リスト6-4を参照）。

```rust
#//#[derive(Debug)] // so we can inspect the state in a minute
#[derive(Debug)] // 1分で状態を検査することができます
enum UsState {
    Alabama,
    Alaska,
#    // --snip--
    //  --snip--
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}
```

<span class="caption"><code>UsState</code>リスト6-4。 <code>Quarter</code>場合値も<code>UsState</code>値を保持する<code>Coin</code>列挙型</span>

友人が全50州の四半期を収集しようとしているとしましょう。
コイン型で緩やかな変更を並べ替える間に、各四半期に関連する州の名前も呼び出すので、友達が持っていない場合は<ruby>集まり<rt>コレクション</rt></ruby>に追加することができます。

この<ruby>譜面<rt>コード</rt></ruby>の一致式では、変数`Coin::Quarter`値と一致するパターンに`state`という変数を追加します。
`Coin::Quarter`一致すると、`state`変数はその四半期の状態の値に束縛されます。
次に、そのような<ruby>譜面<rt>コード</rt></ruby>の`state`で、次のように使用できます。

```rust
# #[derive(Debug)]
# enum UsState {
#    Alabama,
#    Alaska,
# }
#
# enum Coin {
#    Penny,
#    Nickel,
#    Dime,
#    Quarter(UsState),
# }
#
fn value_in_cents(coin: Coin) -> u32 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        },
    }
}
```

`value_in_cents(Coin::Quarter(UsState::Alaska))`を呼び出す場合、`coin`は`Coin::Quarter(UsState::Alaska)`ます。
その値を各マッチ分岐と比較すると、`Coin::Quarter(state)`達するまで一致するものはありません。
その時点で、`state`の束縛は値`UsState::Alaska`ます。
`println!`式でその束縛を使うことができるので、`Quarter` `Coin`列挙型の内部状態値が得られます。

### `Option<T>`との照合

前の章では、`Option<T>`を使用して`Some`場合、`Some`場合の内部`T`値を取得したいと考えました。
`Coin` enumで行ったように、`Option<T>`を`match`扱うこともできます！　
コインを比較するのではなく、`Option<T>`<ruby>場合値<rt>バリアント</rt></ruby>を比較しますが、`match`式の動作方法は変わりません。

`Option<i32>`をとる機能を記述したいとしましょう。内部に値がある場合はその値に1を加えます。
内部に値がない場合、機能は`None`値を返し、何も操作を行わないようにしなければなりません。

この機能は、感謝して、書くのは非常に簡単で`match`、かつ、リスト6-5のようになります。

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

let five = Some(5);
let six = plus_one(five);
let none = plus_one(None);
```

<span class="caption">リスト6-5。 <code>Option&lt;i32&gt;</code> <code>match</code>式を使用する機能</span>

`plus_one`の最初の実行を詳細に調べてみましょう。
`plus_one(five)`を呼び出すと、`plus_one(five)`本体の変数`x`に`Some(5)`という値が`plus_one`されます。
次に、それを各マッチ分岐と比較します。

```rust,ignore
None => None,
```

`Some(5)`値がパターン`None`と一致しないので、次の分岐に進みます。

```rust,ignore
Some(i) => Some(i + 1),
```

`Some(5)`は`Some(5)` `Some(i)`マッチしますか？　
なぜそうですか！　
同じ<ruby>場合値<rt>バリアント</rt></ruby>を持っています。
`i`中に含まれる値に結合する`Some`、そう`i`価値取る`5`。
次に、マッチ分岐の<ruby>譜面<rt>コード</rt></ruby>が実行されるので、`i`の値に1を加え、内部に和`6`個の新しい`Some`値を作成します。

リスト6-5の2番目の`plus_one`呼び出しを考えてみましょう。ここで`x`は`None`です。
`match`入り、最初の分岐と比較します。

```rust,ignore
None => None,
```

それは一致します！　
追加する値はないので、<ruby>算譜<rt>プログラム</rt></ruby>は停止し、`=>`右側に`None`値を返します。
最初の分岐が一致したので、他の分岐は比較されません。

`match`と列挙を組み合わせることは、多くの状況で役立ちます。
このパターンはRust<ruby>譜面<rt>コード</rt></ruby>でよく見えます。enumとの`match`、変数を内部のデータに束縛し、それに基づいて<ruby>譜面<rt>コード</rt></ruby>を実行します。
最初はややこしいですが、慣れてしまえば、すべての言語でそれを使いたいと思うでしょう。
一貫して利用者のお気に入りです。

### マッチは徹底的です

一つの他の側面があります`match`、議論する必要があるが。
バグがあり、<ruby>製譜<rt>コンパイル</rt></ruby>されない`plus_one`機能のこの版を考えてみましょう。

```rust,ignore
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        Some(i) => Some(i + 1),
    }
}
```

`None`ケースは扱わなかったので、この<ruby>譜面<rt>コード</rt></ruby>はバグを引き起こします。
幸いにも、それはバグです。Rustはどのように捕まえるのかを知っています。
この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0004]: non-exhaustive patterns: `None` not covered
 -->
  |
6 |         match x {
  |               ^ pattern `None` not covered
```

Rustは、あらゆる可能なケースをカバーしていないことを知っていて、忘れたパターンも知っている！　
Rustのマッチは*網羅的*です。<ruby>譜面<rt>コード</rt></ruby>が有効であるためには、最後のすべての可能性を排除しなければなりません。
特に`Option<T>`場合、Rustが`None`ケースを明示的に処理するのを忘れるのを防ぎます。Nustがあると仮定することから私たちを保護して、10億ドルの間違いを早期に解消します。

### `_`<ruby>場所取り<rt>プレースホルダ</rt></ruby>

Rustには、すべての可能な値をリストしたくないときに使用できるパターンもあります。
たとえば、`u8`は0〜255の有効な値を持つことができます`u8`、および7の値のみを`u8`場合、`u8`かをリストする必要はありません。9までは最大255までです。幸い、特別なパターン`_`代わりに使用する必要はありません。

```rust
let some_u8_value = 0u8;
match some_u8_value {
    1 => println!("one"),
    3 => println!("three"),
    5 => println!("five"),
    7 => println!("seven"),
    _ => (),
}
```

`_`パターンは任意の値と一致します。
他の武器の後ろに置くことで、`_`はその前に指定されていない可能性のあるすべてのケースに一致します。
`()`は単なる単なる値なので、`_`場合は何も起こりません。
その結果、`_`<ruby>場所取り<rt>プレースホルダ</rt></ruby>の前にリストされていない可能性のあるすべての値に対して何もしないと言うことができます。

しかし、`match`式は、ケースの*うちの1つ*だけを気にする状況では、ちょっとしたものになる可能性があります。
この状況では`if let`提供します。
