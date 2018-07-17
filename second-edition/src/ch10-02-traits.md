## 特性。共有動作の定義

*特性*は、Rust製譜器に特定の型が持つ機能について知らせ、他の型と共有することができます。
特性を使用して抽象的な方法で共有動作を定義することができます。
特性縛りを使用して、総称化が特定の動作を持つ任意の型であることを指定できます。

> > 注意。特性は、他の言語の*接点*とよく似ていますが、いくつかの違いがあります。

### 特性の定義

型の動作は、その型で呼び出すことができる操作法から構成されます。
これらのすべての型に対して同じ操作法を呼び出すことができる場合、異なる型は同じ動作を共有します。
特性定義は、操作法型指示をグループ化して、目的を達成するために必要な一連の動作を定義する方法です。

たとえば、さまざまな種類と量のテキストを保持する複数の構造体があるとしましょう。特定の場所に`NewsArticle`れているニュース記事を保持する`NewsArticle`構造体と、280文字以下のメタデータを持つことができる`Tweet`です。新しいツイート、リトウェット、または別のツイートへの返信。

`NewsArticle`または`Tweet`実例に保存されている可能性のあるデータの要約を表示できるメディアアグリゲータ譜集を作成する必要があります。
これを行うには、それぞれの型から要約が必要です。実例に対して`summarize`操作法を呼び出すことによって要約を要求する必要があります。
リスト10-12は、この振る舞いを表す`Summary`特性の定義を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Summary {
    fn summarize(&self) -> String;
}
```

<span class="caption">リスト10-12。 <code>summarize</code>操作法によって提供される振る舞いで構成される<code>Summary</code>特性</span>

ここでは、`trait`予約語を使用して`trait`を宣言し、次に特性の名前を指定します。この場合、`Summary`です。
中かっこの中で、この特性を実装する型の振る舞いを記述する操作法の型指示を宣言します。この場合、`fn summarize(&self) -> String`です。

操作法型指示の後に、中かっこで実装する代わりに、セミコロンを使用します。
この特性を実装する各型は、操作法の本体に対して独自の独自の動作を提供する必要があります。
製譜器は、`Summary`特性を持つすべての型で、この型指示で定義された操作法`summarize`正確に実行するように強制型変換します。

特性は、本体に複数の操作法を持つことができます。操作法の型指示は1行に1つずつリストされ、各行はセミコロンで終わります。

### 型上の特性の実装

`Summary`特性を使用して目的の動作を定義したので、これをメディアアグリゲータの型に実装できます。
リスト10-13は、見出し、作成者、および場所を使用して`summarize`戻り値を作成する`NewsArticle`構造体の`Summary`特性の実装を示しています。
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

ある型の特性を実装することは、通常の操作法を実装することと似ています。
違いは、`impl`後に実装する特性名を入れてから`for`予約語を使い、その特性を実装する型の名前を指定することです。
`impl`段落内で、特性定義が定義した操作法の型指示を入れます。
各署名の後にセミコロンを追加する代わりに、中かっこを使用して、操作法本体に、特定の型に対して特性の操作法が持つ特定の動作を記入します。

この特性を実装した後、次のように、`NewsArticle`と`Tweet`実例の操作法を、通常の操作法と同じ方法で呼び出すことができます。

```rust,ignore
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

この譜面は、`1 new tweet: horse_ebooks: of course, as you probably already know, people`。

`Summary` `NewsArticle`と`NewsArticle`と`Tweet`型はリスト10-13の同じ*lib.rs*に定義されているため、すべて同じ有効範囲に入っています。
この*lib.rs*は、`aggregator`と呼ばれていたもの`aggregator`、他の誰かが、譜集の有効範囲内で定義された構造体に`Summary`特性を実装するために、通い箱の機能を使用したいとします。
それらは最初に特性をその有効範囲に輸入する必要があります。
それらは`use aggregator::Summary;`指定`use aggregator::Summary;`ことでそうするだろう`use aggregator::Summary;`
これにより、それらの型の`Summary`を実装することができます。
リスト10-12の`trait`前に`pub`予約語を置くので、`Summary`特性は、それを実装するための別の通い箱の公的特性である必要があります。

特性の実装で注意すべき制限の1つは、特性または型のいずれかが通い箱にローカルである場合にのみ、型に特性を実装できることです。
例えば、ような標準譜集の特性を実装することができます`Display`のような独自型の`Tweet`一環として、`aggregator`型ので、通い箱機能`Tweet`私たちにローカルな`aggregator`通い箱。
特性`Summary`は`aggregator`通い箱のローカルなので、`aggregator`通い箱で`Summary` on `Vec<T>`を実装することもできます。

しかし、外部の型に外部の特性を実装することはできません。
たとえば、`Display`および`Vec<T>`は標準譜集で定義されており、`aggregator` crateではローカルではないため、`aggregator`通い箱内で`Vec<T>` `Display`特性を実装することはできません。
この制限は、*コヒーレンス*と呼ばれる算譜のプロパティの一部であり、より具体的には、親型が存在しないために名前が付けられた*孤立ルール*です。
このルールは、他の人の譜面が譜面を破ることができないようにします。
ルールがなければ、2つの通い箱が同じ型の同じ特性を実装でき、Rustはどちらの実装を使用するかを知りません。

### 黙用の実装

場合によっては、すべての型のすべての操作法の実装を要求するのではなく、特性の一部またはすべてに対して操作法の黙用動作を持たせると便利です。
次に、特定の型の特性を実装する際に、各操作法の黙用動作を保持または上書きできます。

譜面リスト10-14は、譜面リスト10-12のように、操作法型指示を定義するだけでなく、`Summary`特性の`summarize`操作法の黙用文字列を指定する方法を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

<span class="caption">リスト10-14。 <code>summarize</code>操作法の黙用実装による<code>Summary</code>特性の定義</span>

黙用の実装を使用して独自の実装を定義する代わりに`NewsArticle`実例を`impl Summary for NewsArticle {}`して空の`impl`段落を指定します。

もはや定義しているにもかかわらず`summarize`で操作法を`NewsArticle`直接、黙用の実装を提供していないとことを指定した`NewsArticle`実装`Summary`特性を。
その結果、まだ呼び出すことができ`summarize`の実例で操作法を`NewsArticle`このように、。

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

この譜面は`New article available! (Read more...)`印字し`New article available! (Read more...)`。

`summarize`ための黙用実装を作成しても、リスト10-13の`Summary` on `Tweet`実装について何も変更する必要はありません。
その理由は、既定の実装を上書きする構文は、既定の実装を持たないtrait操作法を実装するための構文と同じであるためです。

既定の実装では、他の操作法に既定の実装がない場合でも、既定の実装では同じ特性の他の操作法を呼び出すことができます。
このようにして、特性は多くの有用な機能を提供することができ、実装者がその一部を指定することだけを必要とします。
例えば、定義でき`Summary`持っている特性を`summarize_author`その実装が要求される方法を、次に定義`summarize`呼び出し、黙用の実装がある方法`summarize_author`方法を。

```rust
pub trait Summary {
    fn summarize_author(&self) -> String;

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}
```

この版の`Summary`を使用するに`summarize_author`、ある型に対して特性を実装するときに`summarize_author`を定義するだけで済みます。

```rust,ignore
impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
}
```

定義した後`summarize_author`、呼び出すことができます`summarize`の実例に`Tweet`構造体、および黙用の実装で`summarize`の定義を呼び出します`summarize_author`提供してきました。
`summarize_author`を実装しているので、`Summary`特性は、これ以上の譜面を書く必要なしに`summarize`操作法の動作を与えました。

```rust,ignore
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

この譜面は、`1 new tweet: (Read more from @horse_ebooks...)`。

同じ操作法の上書き実装から黙用実装を呼び出すことはできません。

### 特性縛り

今度は、特性を定義し、それらの型を型に実装する方法を知ったので、型を総称型パラメータで使用する方法を探ることができます。
*特性縛り*を使用して総称型を制約することで、その型が特定の特性や動作を実装するものに限定されるようにすることができます。

たとえば、リスト10-13では、`NewsArticle`と`Tweet`型について`Summary` `NewsArticle`を実装しました。
`summarize`操作法を呼び出す機能`notify`を定義することができます。これは、汎用型`T`パラメータ`item`です。
呼び出すことができるようにするに`summarize`上で`item`総称型ということを告げて、誤り得ることなく`T`操作法が実装されていない`summarize`、上の特性縛りを使用することができます`T`ように指定する`item`実装型でなければならない`Summary`特性を。

```rust,ignore
pub fn notify<T: Summary>(item: T) {
    println!("Breaking news! {}", item.summarize());
}
```

コロンと内側の角かっこの後に、総称型パラメータの宣言で特性縛りを配置します。
`T`の特性に縛られているため、`NewsArticle`や`Tweet`実例を`notify`して渡すことができます。
`String`や`i32`ような他の型の機能を呼び出す譜面は、それらの型が`Summary`実装していないため、製譜されません。

`+`構文を使用して総称型に複数の特性縛りを指定することができます。
例えば、機能の型`T`と`summarize`操作法の表示書式を使用するには、`T: Summary + Display`を使用します`T`は、`Summary`と`Display`を実装する任意の型とすることができます。

しかし、あまりにも多くの特性縛りを使用することには欠点があります。
各総称化には独自の特性縛りがあるため、複数の総称型パラメータを持つ機能は、機能名とそのパラメータリストの間に多くの特性束縛情報を持ち、機能型指示を読みにくくします。
この理由から、Rustは、機能型指示の後に`where`句の中で特性縛りを指定するための代替構文を持っています。
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

この機能の型指示は、機能名、パラメータリスト、および戻り値の型が密接に接しているので、あまりうまく機能しません。

### 特性縛りで`largest`機能を固定する

総称型パラメータの縛りを使用して使用する動作を指定する方法を知ったので、リスト10-5に戻り、総称型パラメータを使用する`largest`機能の定義を修正しましょう。
前回この譜面を実行しようとしましたが、この誤りが発生しました。

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
この演算子は標準譜集の特性`std::cmp::PartialOrd`黙用操作法として定義されているため、`T`の特性縛りに`PartialOrd`を指定する必要があります。そのため、`largest`機能は比較可能なすべての型のスライスを処理できます。
`PartialOrd`入れているので、`PartialOrd`を有効範囲に入れる必要はありません。
`largest`の署名を次のように変更します。

```rust,ignore
fn largest<T: PartialOrd>(list: &[T]) -> T {
```

今回は、譜面を製譜するときに、異なる一連の誤りが発生します。

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

この誤りのキー行は`cannot move out of type [T], a non-copy slice`は`cannot move out of type [T], a non-copy slice`。
`largest`機能の非総称化版では、最大の`i32`または`char`を見つけようとしていました。
第4章の「山専用データ。コピー」の項で説明したように、既知のサイズの`i32`や`char`などの型を山に格納できるため、`Copy`特性が実装されます。
しかし、`largest`汎用機能を作成したとき、`list`パラメータには`Copy`特性を実装しない型を持つことが可能になりました。
したがって、`list[0]`から`largest`変数に値を移動することができず、この誤りが発生します。

`Copy`特性を実装する型だけでこの譜面を呼び出すには、`T`！　の特性縛りに`Copy`を追加することができます。
リスト10-15は、機能に渡すスライス内の値の型が、`PartialOrd` *と* `Copy`特性を実装している限り、製譜する一般的な`largest`機能の完全な譜面を示しています（`i32`や`char`。

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

`largest`機能を`Copy`特性を実装する型に制限したくない場合、`T`は`Copy`代わりに`Clone`に束縛された特性を持つと指定することができます。
次に、`largest`機能に所有権を持たせたいときに、スライス内の各値を複製できます。
`clone`機能を使用すると、`String`ような原データを所有する型の場合に原割り当てを増やす可能性があり、大量のデータを扱う場合は原割り当てが遅くなる可能性があります。

`largest`実装できる別の方法は、機能がスライス内の`T`値への参照を返すことです。
して戻り値の型を変更した場合は`&T`の代わりに、`T`、それによって参照を返すために、機能の本体を変更し、必要はありません`Clone`または`Copy`特性縛りを、原割り当てを避けることができます。
これらの代替ソリューションを自分で実装してみてください！　

### 特性縛りを使用して条件付きで操作法を実装する

総称型パラメータを使用する`impl`段落で束縛された特性を使用することによって、指定された特性を実装する型に対して条件付きで操作法を実装できます。
たとえば、リスト10-16の`Pair<T>`型は常に`new`機能を実装します。
しかし、`Pair<T>`のみを実装`cmp_display`そのインナー型の場合、この操作法`T`実装`PartialOrd` *比較*可能な特性`Display`、印字を可能に特性を。

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

<span class="caption">リスト10-16。特性縛りに応じて総称型の操作法を条件付きで実装する</span>

また、別の特性を実装する任意の型のための条件を条件付きで実装することもできます。
特性縛りを満たす任意の型の特性の実装は*ブランケット実装*と呼ばれ、Rust標準譜集で広く使用されています。
たとえば、標準譜集は、`Display`特性を実装する任意の型の`ToString`特性を実装します。
標準譜集の`impl`段落は、次の譜面に似ています。

```rust,ignore
impl<T: Display> ToString for T {
#    // --snip--
    //  --snip--
}
```

標準譜集にはこのブランケット実装があるため、`Display`特性を実装するすべての型の`ToString`特性で定義された`to_string`操作法を呼び出すことができます。
たとえば、整数が`Display`実装するため、整数を対応する`String`値に変換できます。

```rust
let s = 3.to_string();
```

ブランケット実装は、「実装者」章の特性に関する開発資料に記載されています。

特性と特性縛りは、複製を減らすために総称型パラメータを使用する譜面を書くだけでなく、総称型に特定の動作を持たせたいという製譜器を指定します。
製譜器は、特性束縛情報を使用して、譜面で使用されているすべての具体的な型が正しい動作を提供しているかどうかをチェックできます。
動的に型付けされた言語では、型が実装しなかった型に対して操作法を呼び出すと、実行時に誤りが発生します。
しかし、Rustはこれらの誤りを製譜するために製譜するので、譜面を実行する前に問題を修正する必要があります。
さらに、製譜時にすでにチェックしているため、実行時に動作をチェックする譜面を記述する必要はありません。
そうすることで、総称化の柔軟性を失うことなく、パフォーマンスが向上します。

すでに使用している別の種類の総称化を*寿命*と呼びます。
型が望むふるまいを持つことを保証するのではなく、寿命は、参照が必要である限り有効であることを保証します。
寿命がどのようにそれをするかを見てみましょう。
