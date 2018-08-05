## <ruby>特性<rt>トレイト</rt></ruby>。共有動作の定義

*<ruby>特性<rt>トレイト</rt></ruby>*は、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>に特定の型が持つ機能について知らせ、他の型と共有することができます。
<ruby>特性<rt>トレイト</rt></ruby>を使用して抽象的な方法で共有動作を定義することができます。
<ruby>特性<rt>トレイト</rt></ruby>縛りを使用して、総称化が特定の動作を持つ任意の型であることを指定できます。

> > 注意。<ruby>特性<rt>トレイト</rt></ruby>は、他の言語の*<ruby>接点<rt>インターフェース</rt></ruby>*とよく似ていますが、いくつかの違いがあります。

### <ruby>特性<rt>トレイト</rt></ruby>の定義

型の動作は、その型で呼び出すことができる<ruby>操作法<rt>メソッド</rt></ruby>から構成されます。
これらのすべての型に対して同じ<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができる場合、異なる型は同じ動作を共有します。
<ruby>特性<rt>トレイト</rt></ruby>定義は、<ruby>操作法<rt>メソッド</rt></ruby>型注釈をグループ化して、目的を達成するために必要な一連の動作を定義する方法です。

たとえば、さまざまな種類と量のテキストを保持する複数の構造体があるとしましょう。特定の場所に`NewsArticle`れているニュース記事を保持する`NewsArticle`構造体と、280文字以下のメタデータを持つことができる`Tweet`です。新しいツイート、リトウェット、または別のツイートへの返信。

`NewsArticle`または`Tweet`<ruby>実例<rt>インスタンス</rt></ruby>に保存されている可能性のあるデータの要約を表示できるメディアアグリゲータ<ruby>譜集<rt>ライブラリー</rt></ruby>を作成する必要があります。
これを行うには、それぞれの型から要約が必要です。<ruby>実例<rt>インスタンス</rt></ruby>に対して`summarize`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことによって要約を要求する必要があります。
リスト10-12は、この振る舞いを表す`Summary`<ruby>特性<rt>トレイト</rt></ruby>の定義を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Summary {
    fn summarize(&self) -> String;
}
```

<span class="caption">リスト10-12。 <code>summarize</code>操作法によって提供される振る舞いで構成される<code>Summary</code>特性</span>

ここでは、`trait`予約語を使用して`trait`を宣言し、次に<ruby>特性<rt>トレイト</rt></ruby>の名前を指定します。この場合、`Summary`です。
中かっこの中で、この<ruby>特性<rt>トレイト</rt></ruby>を実装する型の振る舞いを記述する<ruby>操作法<rt>メソッド</rt></ruby>の型注釈を宣言します。この場合、`fn summarize(&self) -> String`です。

<ruby>操作法<rt>メソッド</rt></ruby>型注釈の後に、中かっこで実装する代わりに、セミコロンを使用します。
この<ruby>特性<rt>トレイト</rt></ruby>を実装する各型は、<ruby>操作法<rt>メソッド</rt></ruby>の本体に対して独自の独自の動作を提供する必要があります。
<ruby>製譜器<rt>コンパイラー</rt></ruby>は、`Summary`<ruby>特性<rt>トレイト</rt></ruby>を持つすべての型で、この型注釈で定義された<ruby>操作法<rt>メソッド</rt></ruby>`summarize`正確に実行するように強制型変換します。

<ruby>特性<rt>トレイト</rt></ruby>は、本体に複数の<ruby>操作法<rt>メソッド</rt></ruby>を持つことができます。<ruby>操作法<rt>メソッド</rt></ruby>の型注釈は1行に1つずつリストされ、各行はセミコロンで終わります。

### 型上の<ruby>特性<rt>トレイト</rt></ruby>の実装

`Summary`<ruby>特性<rt>トレイト</rt></ruby>を使用して目的の動作を定義したので、これをメディアアグリゲータの型に実装できます。
リスト10-13は、見出し、作成者、および場所を使用して`summarize`戻り値を作成する`NewsArticle`構造体の`Summary`<ruby>特性<rt>トレイト</rt></ruby>の実装を示しています。
`Tweet`構造体の場合、ツイートの内容がすでに280文字に制限されていると仮定して、`summarize`を利用者名とそれに続くツイートのテキスト全体として定義します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub trait Summary {
#     fn summarize(&self) -> String;
# }
#
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

<span class="caption">リスト10-13。 <code>NewsArticle</code>と<code>Tweet</code>型に<code>Summary</code>特性を実装する</span>

ある型の<ruby>特性<rt>トレイト</rt></ruby>を実装することは、通常の<ruby>操作法<rt>メソッド</rt></ruby>を実装することと似ています。
違いは、`impl`後に実装する<ruby>特性<rt>トレイト</rt></ruby>名を入れてから`for`予約語を使い、その<ruby>特性<rt>トレイト</rt></ruby>を実装する型の名前を指定することです。
`impl`<ruby>段落<rt>ブロック</rt></ruby>内で、<ruby>特性<rt>トレイト</rt></ruby>定義が定義した<ruby>操作法<rt>メソッド</rt></ruby>の型注釈を入れます。
各署名の後にセミコロンを追加する代わりに、中かっこを使用して、<ruby>操作法<rt>メソッド</rt></ruby>本体に、特定の型に対して<ruby>特性<rt>トレイト</rt></ruby>の<ruby>操作法<rt>メソッド</rt></ruby>が持つ特定の動作を記入します。

この<ruby>特性<rt>トレイト</rt></ruby>を実装した後、次のように、`NewsArticle`と`Tweet`<ruby>実例<rt>インスタンス</rt></ruby>の<ruby>操作法<rt>メソッド</rt></ruby>を、通常の<ruby>操作法<rt>メソッド</rt></ruby>と同じ方法で呼び出すことができます。

```rust,ignore
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

この<ruby>譜面<rt>コード</rt></ruby>は、`1 new tweet: horse_ebooks: of course, as you probably already know, people`。

`Summary` `NewsArticle`と`NewsArticle`と`Tweet`型はリスト10-13の同じ*lib.rs*に定義されているため、すべて同じ<ruby>有効範囲<rt>スコープ</rt></ruby>に入っています。
この*lib.rs*は、`aggregator`と呼ばれていたもの`aggregator`、他の誰かが、<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>有効範囲<rt>スコープ</rt></ruby>内で定義された構造体に`Summary`<ruby>特性<rt>トレイト</rt></ruby>を実装するために、<ruby>通い箱<rt>クレート</rt></ruby>の機能を使用したいとします。
それらは最初に<ruby>特性<rt>トレイト</rt></ruby>をその<ruby>有効範囲<rt>スコープ</rt></ruby>に<ruby>輸入<rt>インポート</rt></ruby>する必要があります。
それらは`use aggregator::Summary;`指定`use aggregator::Summary;`ことでそうするだろう`use aggregator::Summary;`
これにより、それらの型の`Summary`を実装することができます。
リスト10-12の`trait`前に`pub`予約語を置くので、`Summary`<ruby>特性<rt>トレイト</rt></ruby>は、それを実装するための別の<ruby>通い箱<rt>クレート</rt></ruby>の公的<ruby>特性<rt>トレイト</rt></ruby>である必要があります。

<ruby>特性<rt>トレイト</rt></ruby>の実装で注意すべき制限の1つは、<ruby>特性<rt>トレイト</rt></ruby>または型のいずれかが<ruby>通い箱<rt>クレート</rt></ruby>にローカルである場合にのみ、型に<ruby>特性<rt>トレイト</rt></ruby>を実装できることです。
例えば、ような標準<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>特性<rt>トレイト</rt></ruby>を実装することができます`Display`のような独自の型の`Tweet`一環として、`aggregator`型ので、<ruby>通い箱<rt>クレート</rt></ruby>機能`Tweet`私たちにローカルな`aggregator`<ruby>通い箱<rt>クレート</rt></ruby>。
<ruby>特性<rt>トレイト</rt></ruby>`Summary`は`aggregator`<ruby>通い箱<rt>クレート</rt></ruby>のローカルなので、`aggregator`<ruby>通い箱<rt>クレート</rt></ruby>で`Summary` on `Vec<T>`を実装することもできます。

しかし、外部の型に外部の<ruby>特性<rt>トレイト</rt></ruby>を実装することはできません。
たとえば、`Display`および`Vec<T>`は標準<ruby>譜集<rt>ライブラリー</rt></ruby>で定義されており、`aggregator` crateではローカルではないため、`aggregator`<ruby>通い箱<rt>クレート</rt></ruby>内で`Vec<T>` `Display`<ruby>特性<rt>トレイト</rt></ruby>を実装することはできません。
この制限は、*コヒーレンス*と呼ばれる<ruby>算譜<rt>プログラム</rt></ruby>のプロパティの一部であり、より具体的には、親型が存在しないために名前が付けられた*孤立ルール*です。
このルールは、他の人の<ruby>譜面<rt>コード</rt></ruby>が<ruby>譜面<rt>コード</rt></ruby>を破ることができないようにします。
ルールがなければ、2つの<ruby>通い箱<rt>クレート</rt></ruby>が同じ型の同じ<ruby>特性<rt>トレイト</rt></ruby>を実装でき、Rustはどちらの実装を使用するかを知りません。

### <ruby>黙用<rt>デフォルト</rt></ruby>の実装

場合によっては、すべての型のすべての<ruby>操作法<rt>メソッド</rt></ruby>の実装を要求するのではなく、<ruby>特性<rt>トレイト</rt></ruby>の一部またはすべてに対して<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>動作を持たせると便利です。
次に、特定の型の<ruby>特性<rt>トレイト</rt></ruby>を実装する際に、各<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>動作を保持または上書きできます。

<ruby>譜面<rt>コード</rt></ruby>リスト10-14は、<ruby>譜面<rt>コード</rt></ruby>リスト10-12のように、<ruby>操作法<rt>メソッド</rt></ruby>型注釈を定義するだけでなく、`Summary`<ruby>特性<rt>トレイト</rt></ruby>の`summarize`<ruby>操作法<rt>メソッド</rt></ruby>の黙用<ruby>文字列<rt>ストリング</rt></ruby>を指定する方法を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

<span class="caption">リスト10-14。 <code>summarize</code>操作法の<ruby>黙用<rt>デフォルト</rt></ruby>実装による<code>Summary</code>特性の定義</span>

<ruby>黙用<rt>デフォルト</rt></ruby>の実装を使用して独自の実装を定義する代わりに`NewsArticle`<ruby>実例<rt>インスタンス</rt></ruby>を`impl Summary for NewsArticle {}`して空の`impl`<ruby>段落<rt>ブロック</rt></ruby>を指定します。

もはや定義しているにもかかわらず`summarize`で<ruby>操作法<rt>メソッド</rt></ruby>を`NewsArticle`直接、<ruby>黙用<rt>デフォルト</rt></ruby>の実装を提供していないとことを指定した`NewsArticle`実装`Summary`<ruby>特性<rt>トレイト</rt></ruby>を。
その結果、まだ呼び出すことができ`summarize`の<ruby>実例<rt>インスタンス</rt></ruby>で<ruby>操作法<rt>メソッド</rt></ruby>を`NewsArticle`このように、。

```rust,ignore
let article = NewsArticle {
    headline: String::from("Penguins win the Stanley Cup Championship!"),
    location: String::from("Pittsburgh, PA, USA"),
    author: String::from("Iceburgh"),
    content: String::from("The Pittsburgh Penguins once again are the best
    hockey team in the NHL."),
};

println!("New article available! {}", article.summarize());
```

この<ruby>譜面<rt>コード</rt></ruby>は`New article available! (Read more...)`<ruby>印字<rt>プリント</rt></ruby>し`New article available! (Read more...)`。

`summarize`ための<ruby>黙用<rt>デフォルト</rt></ruby>実装を作成しても、リスト10-13の`Summary` on `Tweet`実装について何も変更する必要はありません。
その理由は、既定の実装を上書きする構文は、既定の実装を持たないtrait<ruby>操作法<rt>メソッド</rt></ruby>を実装するための構文と同じであるためです。

既定の実装では、他の<ruby>操作法<rt>メソッド</rt></ruby>に既定の実装がない場合でも、既定の実装では同じ<ruby>特性<rt>トレイト</rt></ruby>の他の<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができます。
このようにして、<ruby>特性<rt>トレイト</rt></ruby>は多くの有用な機能を提供することができ、実装者がその一部を指定することだけを必要とします。
例えば、定義でき`Summary`持っている<ruby>特性<rt>トレイト</rt></ruby>を`summarize_author`その実装が要求される方法を、次に定義`summarize`呼び出し、<ruby>黙用<rt>デフォルト</rt></ruby>の実装がある方法`summarize_author`方法を。

```rust
pub trait Summary {
    fn summarize_author(&self) -> String;

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}
```

この版の`Summary`を使用するに`summarize_author`、ある型に対して<ruby>特性<rt>トレイト</rt></ruby>を実装するときに`summarize_author`を定義するだけで済みます。

```rust,ignore
impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
}
```

定義した後`summarize_author`、呼び出すことができます`summarize`の<ruby>実例<rt>インスタンス</rt></ruby>に`Tweet`構造体、および<ruby>黙用<rt>デフォルト</rt></ruby>の実装で`summarize`の定義を呼び出します`summarize_author`提供してきました。
`summarize_author`を実装しているので、`Summary`<ruby>特性<rt>トレイト</rt></ruby>は、これ以上の<ruby>譜面<rt>コード</rt></ruby>を書く必要なしに`summarize`<ruby>操作法<rt>メソッド</rt></ruby>の動作を与えました。

```rust,ignore
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

この<ruby>譜面<rt>コード</rt></ruby>は、`1 new tweet: (Read more from @horse_ebooks...)`。

同じ<ruby>操作法<rt>メソッド</rt></ruby>の上書き実装から<ruby>黙用<rt>デフォルト</rt></ruby>実装を呼び出すことはできません。

### <ruby>特性<rt>トレイト</rt></ruby>縛り

今度は、<ruby>特性<rt>トレイト</rt></ruby>を定義し、それらの型を型に実装する方法を知ったので、型を総称型パラメータで使用する方法を探ることができます。
*<ruby>特性<rt>トレイト</rt></ruby>縛り*を使用して総称型を制約することで、その型が特定の<ruby>特性<rt>トレイト</rt></ruby>や動作を実装するものに限定されるようにすることができます。

たとえば、リスト10-13では、`NewsArticle`と`Tweet`型について`Summary` `NewsArticle`を実装しました。
`summarize`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す機能`notify`を定義することができます。これは、汎用型`T`パラメータ`item`です。
呼び出すことができるようにするに`summarize`上で`item`総称型ということを告げて、<ruby>誤り<rt>エラー</rt></ruby>得ることなく`T`<ruby>操作法<rt>メソッド</rt></ruby>が実装されていない`summarize`、上の<ruby>特性<rt>トレイト</rt></ruby>縛りを使用することができます`T`ように指定する`item`実装型でなければならない`Summary`<ruby>特性<rt>トレイト</rt></ruby>を。

```rust,ignore
pub fn notify<T: Summary>(item: T) {
    println!("Breaking news! {}", item.summarize());
}
```

コロンと内側の角かっこの後に、総称型パラメータの宣言で<ruby>特性<rt>トレイト</rt></ruby>縛りを配置します。
`T`の<ruby>特性<rt>トレイト</rt></ruby>に縛られているため、`NewsArticle`や`Tweet`<ruby>実例<rt>インスタンス</rt></ruby>を`notify`して渡すことができます。
`String`や`i32`ような他の型の機能を呼び出す<ruby>譜面<rt>コード</rt></ruby>は、それらの型が`Summary`実装していないため、<ruby>製譜<rt>コンパイル</rt></ruby>されません。

`+`構文を使用して総称型に複数の<ruby>特性<rt>トレイト</rt></ruby>縛りを指定することができます。
例えば、機能の型`T`と`summarize`<ruby>操作法<rt>メソッド</rt></ruby>の表示書式を使用するには、`T: Summary + Display`を使用します`T`は、`Summary`と`Display`を実装する任意の型とすることができます。

しかし、あまりにも多くの<ruby>特性<rt>トレイト</rt></ruby>縛りを使用することには欠点があります。
各総称化には独自の<ruby>特性<rt>トレイト</rt></ruby>縛りがあるため、複数の総称型パラメータを持つ機能は、機能名とそのパラメータリストの間に多くの<ruby>特性<rt>トレイト</rt></ruby>束縛情報を持ち、関数型注釈を読みにくくします。
この理由から、Rustは、関数型注釈の後に`where`句の中で<ruby>特性<rt>トレイト</rt></ruby>縛りを指定するための代替構文を持っています。
だからこれを書くのではなく。

```rust,ignore
fn some_function<T: Display + Clone, U: Clone + Debug>(t: T, u: U) -> i32 {
```

次のように`where`句を使用できます。

```rust,ignore
fn some_function<T, U>(t: T, u: U) -> i32
    where T: Display + Clone,
          U: Clone + Debug
{
```

この機能の型注釈は、機能名、パラメータリスト、および戻り値の型が密接に接しているので、あまりうまく機能しません。

### <ruby>特性<rt>トレイト</rt></ruby>縛りで`largest`機能を固定する

総称型パラメータの縛りを使用して使用する動作を指定する方法を知ったので、リスト10-5に戻り、総称型パラメータを使用する`largest`機能の定義を修正しましょう。
前回この<ruby>譜面<rt>コード</rt></ruby>を実行しようとしましたが、この<ruby>誤り<rt>エラー</rt></ruby>が発生しました。

```text
error[E0369]: binary operation `>` cannot be applied to type `T`
 --> src/main.rs:5:12
  |
5 |         if item > largest {
  |            ^^^^^^^^^^^^^^
  |
  = note: an implementation of `std::cmp::PartialOrd` might be missing for `T`
```

`largest`の本体では、より大きい（`>`）演算子を使用して`T`型の2つの値を比較したいと考えました。
この演算子は標準<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>特性<rt>トレイト</rt></ruby>`std::cmp::PartialOrd`黙用<ruby>操作法<rt>メソッド</rt></ruby>として定義されているため、`T`の<ruby>特性<rt>トレイト</rt></ruby>縛りに`PartialOrd`を指定する必要があります。そのため、`largest`機能は比較可能なすべての型のスライスを処理できます。
`PartialOrd`入れているので、`PartialOrd`を<ruby>有効範囲<rt>スコープ</rt></ruby>に入れる必要はありません。
`largest`の署名を次のように変更します。

```rust,ignore
fn largest<T: PartialOrd>(list: &[T]) -> T {
```

今回は、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>するときに、異なる一連の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0508]: cannot move out of type `[T]`, a non-copy slice
 --> src/main.rs:2:23
  |
2 |     let mut largest = list[0];
  |                       ^^^^^^^
  |                       |
  |                       cannot move out of here
  |                       help: consider using a reference instead: `&list[0]`

error[E0507]: cannot move out of borrowed content
 --> src/main.rs:4:9
  |
4 |     for &item in list.iter() {
  |         ^----
  |         ||
  |         |hint: to prevent move, use `ref item` or `ref mut item`
  |         cannot move out of borrowed content
```

この<ruby>誤り<rt>エラー</rt></ruby>のキー行は`cannot move out of type [T], a non-copy slice`は`cannot move out of type [T], a non-copy slice`。
`largest`機能の非総称化版では、最大の`i32`または`char`を見つけようとしていました。
第4章の「<ruby>山<rt>スタック</rt></ruby>専用データ。コピー」の項で説明したように、既知のサイズの`i32`や`char`などの型を<ruby>山<rt>スタック</rt></ruby>に格納できるため、`Copy`<ruby>特性<rt>トレイト</rt></ruby>が実装されます。
しかし、`largest`汎用機能を作成したとき、`list`パラメータには`Copy`<ruby>特性<rt>トレイト</rt></ruby>を実装しない型を持つことが可能になりました。
したがって、`list[0]`から`largest`変数に値を移動することができず、この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

`Copy`<ruby>特性<rt>トレイト</rt></ruby>を実装する型だけでこの<ruby>譜面<rt>コード</rt></ruby>を呼び出すには、`T`！　の<ruby>特性<rt>トレイト</rt></ruby>縛りに`Copy`を追加することができます。
リスト10-15は、機能に渡すスライス内の値の型が、`PartialOrd` *と* `Copy`<ruby>特性<rt>トレイト</rt></ruby>を実装している限り、<ruby>製譜<rt>コンパイル</rt></ruby>する一般的な`largest`機能の完全な<ruby>譜面<rt>コード</rt></ruby>を示しています（`i32`や`char`。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest(&char_list);
    println!("The largest char is {}", result);
}
```

<span class="caption">リスト10-15。 <code>PartialOrd</code>と<code>Copy</code>特性を実装する総称型で動作する<code>largest</code>機能の動作定義</span>

`largest`機能を`Copy`<ruby>特性<rt>トレイト</rt></ruby>を実装する型に制限したくない場合、`T`は`Copy`代わりに`Clone`に束縛された<ruby>特性<rt>トレイト</rt></ruby>を持つと指定することができます。
次に、`largest`機能に所有権を持たせたいときに、スライス内の各値を複製できます。
`clone`機能を使用すると、`String`ような原データを所有する型の場合に原割り当てを増やす可能性があり、大量のデータを扱う場合は原割り当てが遅くなる可能性があります。

`largest`実装できる別の方法は、機能がスライス内の`T`値への参照を返すことです。
して戻り値の型を変更した場合は`&T`の代わりに、`T`、それによって参照を返すために、機能の本体を変更し、必要はありません`Clone`または`Copy`<ruby>特性<rt>トレイト</rt></ruby>縛りを、原割り当てを避けることができます。
これらの代替ソリューションを自分で実装してみてください！　

### <ruby>特性<rt>トレイト</rt></ruby>縛りを使用して条件付きで<ruby>操作法<rt>メソッド</rt></ruby>を実装する

総称型パラメータを使用する`impl`<ruby>段落<rt>ブロック</rt></ruby>で束縛された<ruby>特性<rt>トレイト</rt></ruby>を使用することによって、指定された<ruby>特性<rt>トレイト</rt></ruby>を実装する型に対して条件付きで<ruby>操作法<rt>メソッド</rt></ruby>を実装できます。
たとえば、リスト10-16の`Pair<T>`型は常に`new`機能を実装します。
しかし、`Pair<T>`のみを実装`cmp_display`そのインナー型の場合、この<ruby>操作法<rt>メソッド</rt></ruby>`T`実装`PartialOrd` *比較*可能な<ruby>特性<rt>トレイト</rt></ruby>`Display`、<ruby>印字<rt>プリント</rt></ruby>を可能に<ruby>特性<rt>トレイト</rt></ruby>を。

```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self {
            x,
            y,
        }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

<span class="caption">リスト10-16。<ruby>特性<rt>トレイト</rt></ruby>縛りに応じて総称型の<ruby>操作法<rt>メソッド</rt></ruby>を条件付きで実装する</span>

また、別の<ruby>特性<rt>トレイト</rt></ruby>を実装する任意の型のための条件を条件付きで実装することもできます。
<ruby>特性<rt>トレイト</rt></ruby>縛りを満たす任意の型の<ruby>特性<rt>トレイト</rt></ruby>の実装は*ブランケット実装*と呼ばれ、Rust標準<ruby>譜集<rt>ライブラリー</rt></ruby>で広く使用されています。
たとえば、標準<ruby>譜集<rt>ライブラリー</rt></ruby>は、`Display`<ruby>特性<rt>トレイト</rt></ruby>を実装する任意の型の`ToString`<ruby>特性<rt>トレイト</rt></ruby>を実装します。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`impl`<ruby>段落<rt>ブロック</rt></ruby>は、次の<ruby>譜面<rt>コード</rt></ruby>に似ています。

```rust,ignore
impl<T: Display> ToString for T {
#    // --snip--
    //  --snip--
}
```

標準<ruby>譜集<rt>ライブラリー</rt></ruby>にはこのブランケット実装があるため、`Display`<ruby>特性<rt>トレイト</rt></ruby>を実装するすべての型の`ToString`<ruby>特性<rt>トレイト</rt></ruby>で定義された`to_string`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができます。
たとえば、整数が`Display`実装するため、整数を対応する`String`値に変換できます。

```rust
let s = 3.to_string();
```

ブランケット実装は、「実装者」章の<ruby>特性<rt>トレイト</rt></ruby>に関する開発資料に記載されています。

<ruby>特性<rt>トレイト</rt></ruby>と<ruby>特性<rt>トレイト</rt></ruby>縛りは、複製を減らすために総称型パラメータを使用する<ruby>譜面<rt>コード</rt></ruby>を書くだけでなく、総称型に特定の動作を持たせたいという<ruby>製譜器<rt>コンパイラー</rt></ruby>を指定します。
<ruby>製譜器<rt>コンパイラー</rt></ruby>は、<ruby>特性<rt>トレイト</rt></ruby>束縛情報を使用して、<ruby>譜面<rt>コード</rt></ruby>で使用されているすべての具体的な型が正しい動作を提供しているかどうかをチェックできます。
動的に型付けされた言語では、型が実装しなかった型に対して<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すと、実行時に<ruby>誤り<rt>エラー</rt></ruby>が発生します。
しかし、Rustはこれらの<ruby>誤り<rt>エラー</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>するために<ruby>製譜<rt>コンパイル</rt></ruby>するので、<ruby>譜面<rt>コード</rt></ruby>を実行する前に問題を修正する必要があります。
さらに、<ruby>製譜<rt>コンパイル</rt></ruby>時にすでにチェックしているため、実行時に動作をチェックする<ruby>譜面<rt>コード</rt></ruby>を記述する必要はありません。
そうすることで、総称化の柔軟性を失うことなく、パフォーマンスが向上します。

すでに使用している別の種類の総称化を*寿命*と呼びます。
型が望むふるまいを持つことを保証するのではなく、寿命は、参照が必要である限り有効であることを保証します。
寿命がどのようにそれをするかを見てみましょう。
