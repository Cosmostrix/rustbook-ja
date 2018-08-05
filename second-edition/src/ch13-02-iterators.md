## <ruby>反復子<rt>イテレータ</rt></ruby>を使用した一連の項目の処理

<ruby>反復子<rt>イテレータ</rt></ruby>ー・パターンを使用すると、項目の列に対して何らかの仕事を順番に実行できます。
<ruby>反復子<rt>イテレータ</rt></ruby>は、各項目の反復処理の<ruby>論理<rt>ロジック</rt></ruby>と、列がいつ終了したかを判断します。
<ruby>反復子<rt>イテレータ</rt></ruby>ーを使用する場合、その<ruby>論理<rt>ロジック</rt></ruby>を自分自身で再実装する必要はありません。

Rustでは、<ruby>反復子<rt>イテレータ</rt></ruby>は*遅延してい*ます。<ruby>反復子<rt>イテレータ</rt></ruby>は、<ruby>反復子<rt>イテレータ</rt></ruby>を消費する<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すまで効果がありません。
たとえば、リスト13-13の<ruby>譜面<rt>コード</rt></ruby>は、`Vec<T>`定義されている`iter`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことによって、ベクトル`v1`項目に対する<ruby>反復子<rt>イテレータ</rt></ruby>を作成します。
この<ruby>譜面<rt>コード</rt></ruby>自体は役に立ちません。

```rust
let v1 = vec![1, 2, 3];

let v1_iter = v1.iter();
```

<span class="caption">リスト13-13。<ruby>反復子<rt>イテレータ</rt></ruby>の作成</span>

<ruby>反復子<rt>イテレータ</rt></ruby>を作成したら、さまざまな方法で使用できます。
第3章のリスト3-5では、`iter`と`for`ループを使用して各項目にいくつかの<ruby>譜面<rt>コード</rt></ruby>を実行しましたが、今まで`iter`の呼び出しが何をしていたのかを詳しく説明しました。

<ruby>譜面<rt>コード</rt></ruby>リスト13-14の例は、<ruby>反復子<rt>イテレータ</rt></ruby>の作成と、`for`ループの<ruby>反復子<rt>イテレータ</rt></ruby>の使用を分けています。
<ruby>反復子<rt>イテレータ</rt></ruby>は`v1_iter`変数に格納され、その時点で反復は行われません。
`v1_iter`の<ruby>反復子<rt>イテレータ</rt></ruby>を使用して`for`ループを呼び出すと、ループの1回の反復で<ruby>反復子<rt>イテレータ</rt></ruby>の各要素が使用され、各値が出力されます。

```rust
let v1 = vec![1, 2, 3];

let v1_iter = v1.iter();

for val in v1_iter {
    println!("Got: {}", val);
}
```

<span class="caption">リスト13-14。 <code>for</code>ループで<ruby>反復子<rt>イテレータ</rt></ruby>を使う</span>

標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供される<ruby>反復子<rt>イテレータ</rt></ruby>を持たない言語では、<ruby>添字<rt>インデックス</rt></ruby>0で変数を開始し、その変数を使用してベクトルに<ruby>添字<rt>インデックス</rt></ruby>を付けて値を取得し、変数値をループ内で増分することによって、ベクトル内の項目の総数に達するまで続けます。

<ruby>反復子<rt>イテレータ</rt></ruby>はあなたのためにすべての<ruby>論理<rt>ロジック</rt></ruby>を処理し、潜在的に混乱する可能性のある繰り返し<ruby>譜面<rt>コード</rt></ruby>を減らします。
<ruby>反復子<rt>イテレータ</rt></ruby>ーは、ベクトルのように<ruby>添字<rt>インデックス</rt></ruby>を付けることができるデータ構造だけでなく、さまざまな種類の列で同じ<ruby>論理<rt>ロジック</rt></ruby>を使用する柔軟性を提供します。
<ruby>反復子<rt>イテレータ</rt></ruby>がどのようにそれを行うのかを見てみましょう。

### `Iterator`<ruby>特性<rt>トレイト</rt></ruby>と`next`<ruby>操作法<rt>メソッド</rt></ruby>

すべての<ruby>反復子<rt>イテレータ</rt></ruby>は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>で定義されている`Iterator`という名前の<ruby>特性<rt>トレイト</rt></ruby>を実装しています。
<ruby>特性<rt>トレイト</rt></ruby>の定義は次のようになります。

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

#    // methods with default implementations elided
    // <ruby>黙用<rt>デフォルト</rt></ruby>実装を持つ<ruby>操作法<rt>メソッド</rt></ruby>は省略されました
}
```

この定義には、いくつかの新しい構文、`type Item`と`Self::Item`使用されていることに注目してください。これらは、この<ruby>特性<rt>トレイト</rt></ruby>で*関連する型*を定義しています。
関連する型については、第19章で詳しく説明します。ここでは、この<ruby>譜面<rt>コード</rt></ruby>では`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装するために`Item`型も定義する必要があり、この`Item`型は`next`方法。
つまり、`Item`型は<ruby>反復子<rt>イテレータ</rt></ruby>から返される型になります。

`Iterator`。<ruby>特性<rt>トレイト</rt></ruby>は、唯一の方法を定義するために実装する必要が`next`に包まれた時に、<ruby>反復子<rt>イテレータ</rt></ruby>の一つの項目を返す<ruby>操作法<rt>メソッド</rt></ruby>、`Some`反復が終わったとき、返さないと、`None`。

<ruby>反復子<rt>イテレータ</rt></ruby>の`next`<ruby>操作法<rt>メソッド</rt></ruby>を直接呼び出すことができます。
リスト13-15は、ベクトルから作成された<ruby>反復子<rt>イテレータ</rt></ruby>の`next`への繰り返し呼び出しから返される値を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

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

<span class="caption">リスト13-15。<ruby>反復子<rt>イテレータ</rt></ruby>で<code>next</code>操作法を呼び出す</span>

`v1_iter`変更可能にする必要があることに注意してください。<ruby>反復子<rt>イテレータ</rt></ruby>で`next`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すと、<ruby>反復子<rt>イテレータ</rt></ruby>が列内のどこにあるかを追跡するために内部状態が変更されます。
言い換えると、この<ruby>譜面<rt>コード</rt></ruby>は<ruby>反復子<rt>イテレータ</rt></ruby>を*消費する*か、またはそれを使い果たします。
`next`各呼び出しは、<ruby>反復子<rt>イテレータ</rt></ruby>から項目を取得します。
`for`ループを使用したときに`v1_iter`変更する必要はありませんでした。なぜなら、ループが`v1_iter`所有権を`v1_iter`、その背後で可変にできるからです。

また、`next`の呼び出しから得られる値は、ベクトル内の値への不変な参照であることにも注意してください。
`iter`<ruby>操作法<rt>メソッド</rt></ruby>は、不変参照の<ruby>反復子<rt>イテレータ</rt></ruby>を生成します。
`v1`所有権を持ち、所有されている値を返す<ruby>反復子<rt>イテレータ</rt></ruby>を作成したい場合は、`iter`代わりに`into_iter`を呼び出すことができます。
同様に、変更可能な参照を反復したい場合、`iter`代わりに`iter_mut`を呼び出すことができます。

### <ruby>反復子<rt>イテレータ</rt></ruby>を消費する<ruby>操作法<rt>メソッド</rt></ruby>

`Iterator`<ruby>特性<rt>トレイト</rt></ruby>には、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供される<ruby>黙用<rt>デフォルト</rt></ruby>の実装を使用してさまざまな<ruby>操作法<rt>メソッド</rt></ruby>があります。
これらの<ruby>操作法<rt>メソッド</rt></ruby>については、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>の標準<ruby>譜集<rt>ライブラリー</rt></ruby>API開発資料を参照してください。
これらの<ruby>操作法<rt>メソッド</rt></ruby>の中には、その定義内で`next`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すものがあります。そのため、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装する際に`next`<ruby>操作法<rt>メソッド</rt></ruby>を実装する必要があります。

`next`呼び出す<ruby>操作法<rt>メソッド</rt></ruby>は、呼び出す<ruby>操作法<rt>メソッド</rt></ruby>が<ruby>反復子<rt>イテレータ</rt></ruby>を使い果たすので、*消費アダプタ*と呼ばれます。
1つの例は、<ruby>反復子<rt>イテレータ</rt></ruby>の所有権を取得し、`next`繰り返し呼び出すことによって項目を反復し、<ruby>反復子<rt>イテレータ</rt></ruby>を消費する`sum`<ruby>操作法<rt>メソッド</rt></ruby>です。
反復処理が繰り返されると、実行中の和に各項目が追加され、繰り返しが完了すると和が返されます。
<ruby>譜面<rt>コード</rt></ruby>リスト13-16に`sum`<ruby>操作法<rt>メソッド</rt></ruby>の使い方を示すテストがあります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[test]
fn iterator_sum() {
    let v1 = vec![1, 2, 3];

    let v1_iter = v1.iter();

    let total: i32 = v1_iter.sum();

    assert_eq!(total, 6);
}
```

<span class="caption">リスト13-16。 <code>sum</code>操作法を呼び出して<ruby>反復子<rt>イテレータ</rt></ruby>内のすべての項目の和を取得する</span>

`sum`が呼び出した<ruby>反復子<rt>イテレータ</rt></ruby>の所有権を取るので、`v1_iter`を`sum`の呼び出しの後に使用することはできません。

### 他の<ruby>反復子<rt>イテレータ</rt></ruby>を生成する<ruby>操作法<rt>メソッド</rt></ruby>

上で定義されたその他の方法`Iterator` *<ruby>反復子<rt>イテレータ</rt></ruby>アダプタ*として知られている特徴は、<ruby>反復子<rt>イテレータ</rt></ruby>の異なる種類に<ruby>反復子<rt>イテレータ</rt></ruby>を変更することができます。
<ruby>反復子<rt>イテレータ</rt></ruby>ー・アダプターへの複数の呼び出しをチェーン化して、複雑な動作を読み取り可能な方法で実行することができます。
しかし、すべての<ruby>反復子<rt>イテレータ</rt></ruby>は怠惰なので、<ruby>反復子<rt>イテレータ</rt></ruby>アダプタを呼び出して結果を得るためには、消費するアダプタ<ruby>操作法<rt>メソッド</rt></ruby>の1つを呼び出さなければなりません。

<ruby>譜面<rt>コード</rt></ruby>リスト13-17に、<ruby>反復子<rt>イテレータ</rt></ruby>・アダプタ・<ruby>操作法<rt>メソッド</rt></ruby>・`map`を呼び出しする例を示し`map`。この`map`では、各<ruby>反復子<rt>イテレータ</rt></ruby>を呼び出しする<ruby>閉包<rt>クロージャー</rt></ruby>を使用して新しい<ruby>反復子<rt>イテレータ</rt></ruby>を生成します。
ここでの<ruby>閉包<rt>クロージャー</rt></ruby>は、新しい<ruby>反復子<rt>イテレータ</rt></ruby>を作成します。この<ruby>反復子<rt>イテレータ</rt></ruby>では、ベクトルの各項目が1つずつ増分されます。ただし、この<ruby>譜面<rt>コード</rt></ruby>では警告が生成されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
let v1: Vec<i32> = vec![1, 2, 3];

v1.iter().map(|x| x + 1);
```

<span class="caption">リスト13-17。<ruby>反復子<rt>イテレータ</rt></ruby>・アダプタ・<code>map</code>を呼び出しして新しい<ruby>反復子<rt>イテレータ</rt></ruby>を作成する</span>

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

リスト13-17の<ruby>譜面<rt>コード</rt></ruby>は何もしません。
指定した<ruby>閉包<rt>クロージャー</rt></ruby>は決して呼び出されません。
この警告は、なぜ<ruby>反復子<rt>イテレータ</rt></ruby>アダプタが怠惰であるかを思い出させるもので、<ruby>反復子<rt>イテレータ</rt></ruby>をここで消費する必要があります。

これを修正して<ruby>反復子<rt>イテレータ</rt></ruby>を使用するには、リスト12-1の`env::args`で第12章で使用した`collect`<ruby>操作法<rt>メソッド</rt></ruby>を使用します。
この<ruby>操作法<rt>メソッド</rt></ruby>は<ruby>反復子<rt>イテレータ</rt></ruby>を使用し、結果の値を<ruby>集まり<rt>コレクション</rt></ruby>データ型に集めます。

<ruby>譜面<rt>コード</rt></ruby>リスト13-18では、呼び出しから返された<ruby>反復子<rt>イテレータ</rt></ruby>をベクトルに`map`するための反復の結果を収集します。
このベクトルは、元のベクトルから各項目を1つずつ増分したものになります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
let v1: Vec<i32> = vec![1, 2, 3];

let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();

assert_eq!(v2, vec![2, 3, 4]);
```

<span class="caption">リスト13-18。 <code>map</code>操作法を呼び出して新しい<ruby>反復子<rt>イテレータ</rt></ruby>を作成し、次に新しい<ruby>反復子<rt>イテレータ</rt></ruby>を消費する<code>collect</code>操作法を呼び出してベクトルを作成する</span>

`map`は<ruby>閉包<rt>クロージャー</rt></ruby>を使用するため、各項目で実行する操作を指定できます。
これは、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>が提供する反復動作を再利用しながら<ruby>閉包<rt>クロージャー</rt></ruby>がいくつかの動作をカスタマイズする方法の素晴らしい例です。

### 環境を取り込む<ruby>閉包<rt>クロージャー</rt></ruby>を使用する

<ruby>反復子<rt>イテレータ</rt></ruby>を導入したので、`filter`<ruby>反復子<rt>イテレータ</rt></ruby>アダプタを使用して環境を捕獲する<ruby>閉包<rt>クロージャー</rt></ruby>の一般的な使用方法を示すことができます。
<ruby>反復子<rt>イテレータ</rt></ruby>の`filter`<ruby>操作法<rt>メソッド</rt></ruby>は、各項目を<ruby>反復子<rt>イテレータ</rt></ruby>から`filter`、真偽値を返す<ruby>閉包<rt>クロージャー</rt></ruby>を受け取ります。
<ruby>閉包<rt>クロージャー</rt></ruby>が`true`返す`true`、値は`filter`によって生成された<ruby>反復子<rt>イテレータ</rt></ruby>に含まれ`filter`。
<ruby>閉包<rt>クロージャー</rt></ruby>が`false`返すと、結果の<ruby>反復子<rt>イテレータ</rt></ruby>に値は含まれません。

リスト13-19では、環境から`shoe_size`変数を取得して`Shoe`構造体<ruby>実例<rt>インスタンス</rt></ruby>の<ruby>集まり<rt>コレクション</rt></ruby>を反復処理する<ruby>閉包<rt>クロージャー</rt></ruby>を使用して`filter`を使用します。
指定されたサイズの靴だけが返されます。

<span class="filename">ファイル名。src/lib.rs</span>

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

<span class="caption">リスト13-19。 <code>shoe_size</code>を捕獲する<ruby>閉包<rt>クロージャー</rt></ruby>での<code>filter</code>操作法の使用</span>

`shoes_in_my_size`機能は、パラメータとして靴のベクトルと靴のサイズの所有権を取得します。
指定されたサイズの靴のみを含むベクトルを返します。

本体で`shoes_in_my_size`、呼んで`into_iter`ベクトルの所有権を取得<ruby>反復子<rt>イテレータ</rt></ruby>を作成します。
次に、`filter`を呼び出して、その<ruby>反復子<rt>イテレータ</rt></ruby>を、<ruby>反復子<rt>イテレータ</rt></ruby>が`true`返す要素のみを含む新しい<ruby>反復子<rt>イテレータ</rt></ruby>に適合させるようにします。

<ruby>閉包<rt>クロージャー</rt></ruby>は、環境から`shoe_size`パラメータを取得し、値を各靴のサイズと比較し、指定されたサイズの靴のみを保持します。
最後に、`collect`を呼び出すと、適合<ruby>反復子<rt>イテレータ</rt></ruby>によって返された値が機能によって返されたベクトルに<ruby>集まり<rt>コレクション</rt></ruby>ます。

テストでは、`shoes_in_my_size`を呼び出すと、指定した値と同じサイズのシューズのみが返されることが示されています。

### `Iterator`<ruby>特性<rt>トレイト</rt></ruby>を使った独自の<ruby>反復子<rt>イテレータ</rt></ruby>の作成

ベクトルの`iter`、 `into_iter`、または`iter_mut`を呼び出すことによって、<ruby>反復子<rt>イテレータ</rt></ruby>を作成できることが`iter_mut`ました。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の他の<ruby>集まり<rt>コレクション</rt></ruby>型（ハッシュマップなど）から<ruby>反復子<rt>イテレータ</rt></ruby>ーを作成できます。
独自の型の`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装することで、任意の操作を行う<ruby>反復子<rt>イテレータ</rt></ruby>を作成することもできます。
前述のように、定義を提供するために必要な唯一の方法は`next`方法です。
これを済ませたら、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>によって提供される<ruby>黙用<rt>デフォルト</rt></ruby>の実装を持つ他のすべての<ruby>操作法<rt>メソッド</rt></ruby>を使うことができます！　

デモを行うには、1から5までしかカウントしない<ruby>反復子<rt>イテレータ</rt></ruby>を作成しましょう。まず、いくつかの値を保持する構造体を作成します。
次に、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装し、その実装の値を使用して、この構造体を<ruby>反復子<rt>イテレータ</rt></ruby>にします。

定義13-20たリスト`Counter`構造体と関連した`new`の<ruby>実例<rt>インスタンス</rt></ruby>を作成するための機能`Counter`。

<span class="filename">ファイル名。src/lib.rs</span>

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

`Counter`構造体には、`count`という名前の1つの<ruby>欄<rt>フィールド</rt></ruby>があり`count`。
この<ruby>欄<rt>フィールド</rt></ruby>には、保持している`u32`1から5まで反復の過程のどこにいるのを追跡します値`count`実装したいので、<ruby>内部用<rt>プライベート</rt></ruby>で<ruby>欄<rt>フィールド</rt></ruby>を`Counter`、その値を管理すること。
この`new`機能は、`count`<ruby>欄<rt>フィールド</rt></ruby>に値0の新しい<ruby>実例<rt>インスタンス</rt></ruby>を常に開始する動作を強制型変換します。

次に、<ruby>反復子<rt>イテレータ</rt></ruby>が使用されているときに何を実行するかを指定する`next`<ruby>操作法<rt>メソッド</rt></ruby>の本体を定義することによって、`Counter`型の`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装します（<ruby>譜面<rt>コード</rt></ruby>リスト13-21を参照）。

<span class="filename">ファイル名。src/lib.rs</span>

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

関連する設定`Item`に対する当社の<ruby>反復子<rt>イテレータ</rt></ruby>の型`u32`<ruby>反復子<rt>イテレータ</rt></ruby>が返されますを意味し、`u32`値を。
ここでも、関連付けられた型については心配しないでください。第19章でそれらを扱います。

<ruby>反復子<rt>イテレータ</rt></ruby>は現在の状態に1を加算したいので、最初に1を返すように`count`を0に初期化し`count`。
`count`の値が6より小さい場合、`next`は、`Some`で包まれた現在の値を返しますが、`count`が6以上であれば、<ruby>反復子<rt>イテレータ</rt></ruby>は`None`を返します。

#### `Counter` Iteratorの`next`<ruby>操作法<rt>メソッド</rt></ruby>の使用

`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装したら、<ruby>反復子<rt>イテレータ</rt></ruby>を使用します。
13-22のリストの<ruby>反復子<rt>イテレータ</rt></ruby>の機能を使用できることを実証テストを示す`Counter`呼び出すことにより、構造体を`next`リスト13-15でベクターから作成された<ruby>反復子<rt>イテレータ</rt></ruby>でやったように、直接それに方法を。

<span class="filename">ファイル名。src/lib.rs</span>

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

このテストでは、`counter`変数に新しい`Counter`<ruby>実例<rt>インスタンス</rt></ruby>が作成され、`next`繰り返し呼び出して、この<ruby>反復子<rt>イテレータ</rt></ruby>ーに必要な動作を実装していることを確認します。値を1から5に戻します。

#### 他の`Iterator`特性<ruby>操作法<rt>メソッド</rt></ruby>の使用

`next`<ruby>操作法<rt>メソッド</rt></ruby>を定義することで`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装しました。標準の<ruby>譜集<rt>ライブラリー</rt></ruby>で定義されている`Iterator` trait<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>の実装は、すべて`next`<ruby>操作法<rt>メソッド</rt></ruby>の機能を使用するため使用できます。

たとえば、何らかの理由で`Counter`<ruby>実例<rt>インスタンス</rt></ruby>によって生成された値を取得し、最初の値をスキップして別の`Counter`<ruby>実例<rt>インスタンス</rt></ruby>によって生成された値とペアにし、各ペアを掛け合わせ、3で割り切れる結果を保持し、リスト13-23のテストに示されているように、すべての結果の値を一緒に追加することができます。

<span class="filename">ファイル名。src/lib.rs</span>

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
#     // <ruby>反復子<rt>イテレータ</rt></ruby>はu32sを生成します
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

<span class="caption">リスト13-23。 <code>Counter</code> iteratorでさまざまな<code>Iterator</code> trait<ruby>操作法<rt>メソッド</rt></ruby>を使う</span>

`zip`は4ペアしか生成しないことに注意してください。
入力<ruby>反復子<rt>イテレータ</rt></ruby>のいずれかが`None`返すとき、`zip`は`None`返すので、理論上の5番目のペア`(5, None)`は決して生成され`None`。

`next`<ruby>操作法<rt>メソッド</rt></ruby>がどのように動作するかを指定したので、これらの<ruby>操作法<rt>メソッド</rt></ruby>呼び出しはすべて可能です。標準<ruby>譜集<rt>ライブラリー</rt></ruby>は、`next`呼び出す<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>の実装を提供します。
