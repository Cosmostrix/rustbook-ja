## 反復子を使用した一連の項目の処理

反復子ー・パターンを使用すると、項目のシーケンスに対して何らかの仕事を順番に実行できます。
反復子は、各項目の反復処理のロジックと、シーケンスがいつ終了したかを判断します。
反復子ーを使用する場合、そのロジックを自分自身で再実装する必要はありません。

Rustでは、反復子は*遅延してい*ます。反復子は、反復子を消費する操作法を呼び出すまで効果がありません。
たとえば、リスト13-13の譜面は、`Vec<T>`定義されている`iter`操作法を呼び出すことによって、ベクトル`v1`項目に対する反復子を作成します。
この譜面自体は役に立ちません。

```rust
let v1 = vec![1, 2, 3];

let v1_iter = v1.iter();
```

<span class="caption">リスト13-13。反復子の作成</span>

反復子を作成したら、さまざまな方法で使用できます。
第3章のリスト3-5では、`iter`と`for`ループを使用して各項目にいくつかの譜面を実行しましたが、今まで`iter`の呼び出しが何をしていたのかを詳しく説明しました。

譜面リスト13-14の例は、反復子の作成と、`for`ループの反復子の使用を分けています。
反復子は`v1_iter`変数に格納され、その時点で反復は行われません。
`v1_iter`の反復子を使用して`for`ループを呼び出すと、ループの1回の反復で反復子の各要素が使用され、各値が出力されます。

```rust
let v1 = vec![1, 2, 3];

let v1_iter = v1.iter();

for val in v1_iter {
    println!("Got: {}", val);
}
```

<span class="caption">リスト13-14。 <code>for</code>ループで反復子を使う</span>

標準譜集によって提供される反復子を持たない言語では、添字0で変数を開始し、その変数を使用してベクトルに添字を付けて値を取得し、変数値をループ内で増分することによって、ベクトル内の項目の総数に達するまで続けます。

反復子はあなたのためにすべてのロジックを処理し、潜在的に混乱する可能性のある繰り返し譜面を減らします。
反復子ーは、ベクトルのように添字を付けることができるデータ構造だけでなく、さまざまな種類のシーケンスで同じロジックを使用する柔軟性を提供します。
反復子がどのようにそれを行うのかを見てみましょう。

### `Iterator`特性と`next`操作法

すべての反復子は、標準譜集で定義されている`Iterator`という名前の特性を実装しています。
特性の定義は次のようになります。

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

#    // methods with default implementations elided
    // 黙用実装を持つ操作法は省略されました
}
```

この定義には、いくつかの新しい構文、`type Item`と`Self::Item`使用されていることに注目してください。これらは、この特性で*関連する型*を定義しています。
関連する型については、第19章で詳しく説明します。ここでは、この譜面では`Iterator`特性を実装するために`Item`型も定義する必要があり、この`Item`型は`next`方法。
つまり、`Item`型は反復子から返される型になります。

`Iterator`。特性は、唯一の方法を定義するために実装する必要が`next`に包まれた時に、反復子の一つの項目を返す操作法、`Some`反復が終わったとき、返さないと、`None`。

反復子の`next`操作法を直接呼び出すことができます。
リスト13-15は、ベクトルから作成された反復子の`next`への繰り返し呼び出しから返される値を示しています。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
#[test]
fn iterator_demonstration() {
    let v1 = vec![1, 2, 3];

    let mut v1_iter = v1.iter();

    assert_eq!(v1_iter.next(), Some(&1));
    assert_eq!(v1_iter.next(), Some(&2));
    assert_eq!(v1_iter.next(), Some(&3));
    assert_eq!(v1_iter.next(), None);
}
```

<span class="caption">リスト13-15。反復子で<code>next</code>操作法を呼び出す</span>

`v1_iter`変更可能にする必要があることに注意してください。反復子で`next`操作法を呼び出すと、反復子がシーケンス内のどこにあるかを追跡するために内部状態が変更されます。
言い換えると、この譜面は反復子を*消費する*か、またはそれを使い果たします。
`next`各呼び出しは、反復子から項目を取得します。
`for`ループを使用したときに`v1_iter`変更する必要はありませんでした。なぜなら、ループが`v1_iter`所有権を`v1_iter`、その背後で可変にできるからです。

また、`next`の呼び出しから得られる値は、ベクトル内の値への不変な参照であることにも注意してください。
`iter`操作法は、不変参照の反復子を生成します。
`v1`所有権を持ち、所有されている値を返す反復子を作成したい場合は、`iter`代わりに`into_iter`を呼び出すことができます。
同様に、変更可能な参照を反復したい場合、`iter`代わりに`iter_mut`を呼び出すことができます。

### 反復子を消費する操作法

`Iterator`特性には、標準譜集によって提供される黙用の実装を使用してさまざまな操作法があります。
これらの操作法については、`Iterator`特性の標準譜集API開発資料を参照してください。
これらの操作法の中には、その定義内で`next`操作法を呼び出すものがあります。そのため、`Iterator`特性を実装する際に`next`操作法を実装する必要があります。

`next`呼び出す操作法は、呼び出す操作法が反復子を使い果たすので、*消費アダプタ*と呼ばれます。
1つの例は、反復子の所有権を取得し、`next`繰り返し呼び出すことによって項目を反復し、反復子を消費する`sum`操作法です。
反復処理が繰り返されると、実行中の和に各項目が追加され、繰り返しが完了すると和が返されます。
譜面リスト13-16に`sum`操作法の使い方を示すテストがあります。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
#[test]
fn iterator_sum() {
    let v1 = vec![1, 2, 3];

    let v1_iter = v1.iter();

    let total: i32 = v1_iter.sum();

    assert_eq!(total, 6);
}
```

<span class="caption">リスト13-16。 <code>sum</code>操作法を呼び出して反復子内のすべての項目の和を取得する</span>

`sum`が呼び出した反復子の所有権を取るので、`v1_iter`を`sum`の呼び出しの後に使用することはできません。

### 他の反復子を生成する操作法

上で定義されたその他の方法`Iterator` *反復子アダプタ*として知られている特徴は、あなたが反復子の異なる種類に反復子を変更することができます。
反復子ー・アダプターへの複数の呼び出しをチェーン化して、複雑な動作を読み取り可能な方法で実行することができます。
しかし、すべての反復子は怠惰なので、反復子アダプタを呼び出して結果を得るためには、消費するアダプタ操作法の1つを呼び出さなければなりません。

譜面リスト13-17に、反復子・アダプタ・操作法・`map`を呼び出しする例を示し`map`。この`map`では、各反復子を呼び出しする閉包を使用して新しい反復子を生成します。
ここでの閉包は、新しい反復子を作成します。この反復子では、ベクトルの各項目が1つずつ増分されます。ただし、この譜面では警告が生成されます。

<span class="filename">ファイル名。src / main.rs</span>

```rust
let v1: Vec<i32> = vec![1, 2, 3];

v1.iter().map(|x| x + 1);
```

<span class="caption">リスト13-17。反復子・アダプタ・<code>map</code>を呼び出しして新しい反復子を作成する</span>

得る警告はこれです。

```text
warning: unused `std::iter::Map` which must be used: iterator adaptors are lazy
and do nothing unless consumed
 --> src/main.rs:4:5
  |
4 |     v1.iter().map(|x| x + 1);
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^
  |
  = note: #[warn(unused_must_use)] on by default
```

リスト13-17の譜面は何もしません。
指定した閉包は決して呼び出されません。
この警告は、なぜ反復子アダプタが怠惰であるかを思い出させるもので、反復子をここで消費する必要があります。

これを修正して反復子を使用するには、リスト12-1の`env::args`で第12章で使用した`collect`操作法を使用します。
この操作法は反復子を使用し、結果の値を集まりデータ型に集めます。

譜面リスト13-18では、呼び出しから返された反復子をベクトルに`map`するための反復の結果を収集します。
このベクトルは、元のベクトルから各項目を1つずつ増分したものになります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
let v1: Vec<i32> = vec![1, 2, 3];

let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();

assert_eq!(v2, vec![2, 3, 4]);
```

<span class="caption">リスト13-18。 <code>map</code>操作法を呼び出して新しい反復子を作成し、次に新しい反復子を消費する<code>collect</code>操作法を呼び出してベクトルを作成する</span>

`map`は閉包を使用するため、各項目で実行する操作を指定できます。
これは、`Iterator`特性が提供する反復動作を再利用しながら閉包がいくつかの動作をカスタマイズする方法の素晴らしい例です。

### 環境を取り込む閉包を使用する

反復子を導入したので、`filter`反復子アダプタを使用して環境を捕獲する閉包の一般的な使用方法を示すことができます。
反復子の`filter`操作法は、各項目を反復子から`filter`、真偽値を返す閉包を受け取ります。
閉包が`true`返す`true`、値は`filter`によって生成された反復子に含まれ`filter`。
閉包が`false`返すと、結果の反復子に値は含まれません。

リスト13-19では、環境から`shoe_size`変数を取得して`Shoe`構造体実例の集まりを反復処理する閉包を使用して`filter`を使用します。
指定されたサイズの靴だけが返されます。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
#[derive(PartialEq, Debug)]
struct Shoe {
    size: u32,
    style: String,
}

fn shoes_in_my_size(shoes: Vec<Shoe>, shoe_size: u32) -> Vec<Shoe> {
    shoes.into_iter()
        .filter(|s| s.size == shoe_size)
        .collect()
}

#[test]
fn filters_by_size() {
    let shoes = vec![
        Shoe { size: 10, style: String::from("sneaker") },
        Shoe { size: 13, style: String::from("sandal") },
        Shoe { size: 10, style: String::from("boot") },
    ];

    let in_my_size = shoes_in_my_size(shoes, 10);

    assert_eq!(
        in_my_size,
        vec![
            Shoe { size: 10, style: String::from("sneaker") },
            Shoe { size: 10, style: String::from("boot") },
        ]
    );
}
```

<span class="caption">リスト13-19。 <code>shoe_size</code>を捕獲する閉包での<code>filter</code>操作法の使用</span>

`shoes_in_my_size`機能は、パラメータとして靴のベクトルと靴のサイズの所有権を取得します。
指定されたサイズの靴のみを含むベクトルを返します。

本体で`shoes_in_my_size`、呼んで`into_iter`ベクトルの所有権を取得反復子を作成します。
次に、`filter`を呼び出して、その反復子を、反復子が`true`返す要素のみを含む新しい反復子に適合させるようにします。

閉包は、環境から`shoe_size`パラメータを取得し、値を各靴のサイズと比較し、指定されたサイズの靴のみを保持します。
最後に、`collect`を呼び出すと、適合反復子によって返された値が機能によって返されたベクトルに集まります。

テストでは、`shoes_in_my_size`を呼び出すと、指定した値と同じサイズのシューズのみが返されることが示されています。

### `Iterator`特性を使った独自の反復子の作成

ベクトルの`iter`、 `into_iter`、または`iter_mut`を呼び出すことによって、反復子を作成できることが`iter_mut`ました。
標準譜集の他の集まり型（ハッシュマップなど）から反復子ーを作成できます。
独自の型の`Iterator`特性を実装することで、任意の操作を行う反復子を作成することもできます。
前述のように、定義を提供するために必要な唯一の方法は`next`方法です。
これを済ませたら、`Iterator`特性によって提供される黙用の実装を持つ他のすべての操作法を使うことができます！　

デモを行うには、1から5までしかカウントしない反復子を作成しましょう。まず、いくつかの値を保持する構造体を作成します。
次に、`Iterator`特性を実装し、その実装の値を使用して、この構造体を反復子にします。

定義13-20たリスト`Counter`構造体と関連した`new`の実例を作成するための機能`Counter`。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}
```

<span class="caption">リスト13-20。 <code>count</code>初期値0を持つ<code>Counter</code>実例を作成する<code>Counter</code>構造体と<code>new</code>機能の定義</span>

`Counter`構造体には、`count`という名前の1つの欄があり`count`。
この欄には、保持している`u32`1から5まで反復の過程のどこにいるのを追跡します値`count`実装したいので、内部用で欄を`Counter`、その値を管理すること。
この`new`機能は、`count`欄に値0の新しい実例を常に開始する動作を強制型変換します。

次に、反復子が使用されているときに何を実行するかを指定する`next`操作法の本体を定義することによって、`Counter`型の`Iterator`特性を実装します（譜面リスト13-21を参照）。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# struct Counter {
#     count: u32,
# }
#
impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        self.count += 1;

        if self.count < 6 {
            Some(self.count)
        } else {
            None
        }
    }
}
```

<span class="caption">リスト13-21。 <code>Counter</code>構造体の<code>Iterator</code>特性の実装</span>

関連する設定`Item`に対する当社の反復子の型`u32`反復子が返されますを意味し、`u32`値を。
ここでも、関連付けられた型については心配しないでください。第19章でそれらを扱います。

反復子は現在の状態に1を加算したいので、最初に1を返すように`count`を0に初期化し`count`。
`count`の値が6より小さい場合、`next`は、`Some`で包まれた現在の値を返しますが、`count`が6以上であれば、反復子は`None`を返します。

#### `Counter` Iteratorの`next`操作法の使用

`Iterator`特性を実装したら、反復子を使用します。
13-22のリストの反復子の機能を使用できることを実証テストを示す`Counter`呼び出すことにより、構造体を`next`リスト13-15でベクターから作成された反復子でやったように、直接それに方法を。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# struct Counter {
#     count: u32,
# }
#
# impl Iterator for Counter {
#     type Item = u32;
#
#     fn next(&mut self) -> Option<Self::Item> {
#         self.count += 1;
#
#         if self.count < 6 {
#             Some(self.count)
#         } else {
#             None
#         }
#     }
# }
#
#[test]
fn calling_next_directly() {
    let mut counter = Counter::new();

    assert_eq!(counter.next(), Some(1));
    assert_eq!(counter.next(), Some(2));
    assert_eq!(counter.next(), Some(3));
    assert_eq!(counter.next(), Some(4));
    assert_eq!(counter.next(), Some(5));
    assert_eq!(counter.next(), None);
}
```

<span class="caption">リスト13-22。 <code>next</code>操作法実装の機能のテスト</span>

このテストでは、`counter`変数に新しい`Counter`実例が作成され、`next`繰り返し呼び出して、この反復子ーに必要な動作を実装していることを確認します。値を1から5に戻します。

#### 他の`Iterator`特性操作法の使用

`next`操作法を定義することで`Iterator`特性を実装しました。標準の譜集で定義されている`Iterator` trait操作法の黙用の実装は、すべて`next`操作法の機能を使用するため使用できます。

たとえば、何らかの理由で`Counter`実例によって生成された値を取得し、最初の値をスキップして別の`Counter`実例によって生成された値とペアにし、各ペアを掛け合わせ、3で割り切れる結果を保持し、リスト13-23のテストに示されているように、すべての結果の値を一緒に追加することができます。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# struct Counter {
#     count: u32,
# }
#
# impl Counter {
#     fn new() -> Counter {
#         Counter { count: 0 }
#     }
# }
#
# impl Iterator for Counter {
#//#     // Our iterator will produce u32s
#     // 反復子はu32sを生成します
#     type Item = u32;
#
#     fn next(&mut self) -> Option<Self::Item> {
#//#         // increment our count. This is why we started at zero.
#         // カウントを増やす。これがゼロから始めた理由です。
#         self.count += 1;
#
#//#         // check to see if we've finished counting or not.
#         // カウントが終了したかどうかを確認してください。
#         if self.count < 6 {
#             Some(self.count)
#         } else {
#             None
#         }
#     }
# }
#
#[test]
fn using_other_iterator_trait_methods() {
    let sum: u32 = Counter::new().zip(Counter::new().skip(1))
                                 .map(|(a, b)| a * b)
                                 .filter(|x| x % 3 == 0)
                                 .sum();
    assert_eq!(18, sum);
}
```

<span class="caption">リスト13-23。 <code>Counter</code> iteratorでさまざまな<code>Iterator</code> trait操作法を使う</span>

`zip`は4ペアしか生成しないことに注意してください。
入力反復子のいずれかが`None`返すとき、`zip`は`None`返すので、理論上の5番目のペア`(5, None)`は決して生成され`None`。

`next`操作法がどのように動作するかを指定したので、これらの操作法呼び出しはすべて可能です。標準譜集は、`next`呼び出す操作法の黙用の実装を提供します。
