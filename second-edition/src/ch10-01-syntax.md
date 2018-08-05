## 汎用データ型

関数型注釈や構造体などの定義を作成するために総称化を使用できます。これらの定義は、多くの異なる具体的なデータ型で使用できます。
まず、総称化を使って機能、構造体、列挙型、および<ruby>操作法<rt>メソッド</rt></ruby>を定義する方法を見ていきましょう。
次に、総称化が<ruby>譜面<rt>コード</rt></ruby>のパフォーマンスにどのように影響するかについて説明します。

### 機能定義で

総称化を使用する機能を定義するとき、総称化を機能の型注釈に置きます。ここでは、通常、パラメータと戻り値のデータ型を指定します。
そうすることで、<ruby>譜面<rt>コード</rt></ruby>の柔軟性が高まり、<ruby>譜面<rt>コード</rt></ruby>の重複を防ぎながら、機能の呼び出し側に多くの機能が提供されます。

引き続き、`largest`機能をリスト10-4に示します。リスト10-4は、スライス内で最大の値を見つける2つの機能を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn largest_i32(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn largest_char(list: &[char]) -> char {
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

    let result = largest_i32(&number_list);
    println!("The largest number is {}", result);
#    assert_eq!(result, 100);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest_char(&char_list);
    println!("The largest char is {}", result);
#    assert_eq!(result, 'y');
}
```

<span class="caption">譜面リスト10-4。名前と型注釈の型だけが異なる2つの機能</span>

`largest_i32`機能は、最大見つけたリスト10-3で抽出されたものです`i32`スライスして。
`largest_char`機能は、スライス内で最大の`char`を検出します。
機能本体には同じ<ruby>譜面<rt>コード</rt></ruby>がありますので、単一の機能に汎用型パラメータを導入して重複を排除しましょう。

定義する新しい機能の型をパラメータ化するには、機能への値パラメータの場合と同様に、型パラメータの名前を付ける必要があります。
任意の識別子を型パラメータ名として使用できます。
しかし、慣習的には、Rustのパラメータ名は短く、しばしば単なる文字であり、Rustの型命名規則はCamelCaseであるため、`T`を使用します。
"type"の略で、`T`はほとんどのRust<ruby>演譜師<rt>プログラマー</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>の選択です。

機能の本体でパラメータを使用するときは、<ruby>製譜器<rt>コンパイラー</rt></ruby>がその名前の意味を知るように、型注釈にパラメータ名を宣言する必要があります。
同様に、関数型注釈に型パラメータ名を使用する場合は、型パラメータ名を宣言してから使用する必要があります。
一般的な`largest`機能を定義するには、型名宣言を機能の名前とパラメータリストの間に`<>`ように角かっこで囲みます。

```rust,ignore
fn largest<T>(list: &[T]) -> T {
```

この定義は次のように解釈されます。機能の`largest`は、ある型`T`に対して一般的です。
この機能には、`list`という名前の1つのパラメータがあります。このパラメータは、`T`型の値のスライスです。
`largest`機能は、同じ型`T`値を返します。

<ruby>譜面<rt>コード</rt></ruby>リスト10-5に、署名に汎用データ型を使用した`largest`機能定義を示します。
リストには、`i32`値のスライスまたは`char`値のいずれかで機能を呼び出す方法も示されています。
この<ruby>譜面<rt>コード</rt></ruby>はまだ<ruby>製譜<rt>コンパイル</rt></ruby>されませんが、この章の後半で修正します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn largest<T>(list: &[T]) -> T {
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

<span class="caption">譜面リスト10-5。総称型のパラメータを使用するが、まだ<ruby>製譜<rt>コンパイル</rt></ruby>していない<code>largest</code>機能の定義</span>

今すぐこの<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>すると、この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0369]: binary operation `>` cannot be applied to type `T`
 --> src/main.rs:5:12
  |
5 |         if item > largest {
  |            ^^^^^^^^^^^^^^
  |
  = note: an implementation of `std::cmp::PartialOrd` might be missing for `T`
```

このノートでは、*<ruby>特性<rt>トレイト</rt></ruby>*である`std::cmp::PartialOrd`について説明してい*ます*。
次の章では、<ruby>特性<rt>トレイト</rt></ruby>について説明します。
今のところ、この<ruby>誤り<rt>エラー</rt></ruby>は、`T`可能なすべての型に対して、`largest`の本体が機能しないことを示しています。
本体の`T`型の値を比較したいので、値を順序付けできる型しか使用できません。
比較を可能にするために、標準<ruby>譜集<rt>ライブラリー</rt></ruby>には型に対して実装できる`std::cmp::PartialOrd`<ruby>特性<rt>トレイト</rt></ruby>があります（この<ruby>特性<rt>トレイト</rt></ruby>の詳細については付録Cを参照してください）。
"Trait Bounds"章に総称型が特定の<ruby>特性<rt>トレイト</rt></ruby>を持つように指定する方法を学びますが、まず総称型パラメータを使用する他の方法を調べてみましょう。

### 構造定義で

また、`<>`構文を使用して、1つまたは複数の<ruby>欄<rt>フィールド</rt></ruby>で総称型パラメータを使用するように構造体を定義することもできます。
リスト10-6は、任意の型の`x`と`y`座標値を保持する`Point<T>`構造体を定義する方法を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}
```

<span class="caption">10-6のリスト。 <code>Point&lt;T&gt;</code>保持構造体<code>x</code>と<code>y</code>型の値<code>T</code></span>

構造体定義で総称化を使用する構文は、機能定義で使用される構文に似ています。
まず、構造体の名前の直後に<ruby>山<rt>スタック</rt></ruby>形かっこで囲まれた型パラメータの名前を宣言します。
次に、具体的なデータ型を指定する場合は、構造体定義の総称型を使用できます。

定義する唯一の総称型を使用しましたので、ことに注意してください`Point<T>`、この定義は、と言っている`Point<T>`のstructいくつかの型を超える一般的なものであり`T`、および<ruby>欄<rt>フィールド</rt></ruby>`x`と`y`、同じ型の*両方とも*、何でもその型多分。
リスト10-7のように、異なる型の値を持つ`Point<T>`<ruby>実例<rt>インスタンス</rt></ruby>を作成すると、<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let wont_work = Point { x: 5, y: 4.0 };
}
```

<span class="caption">リスト10-7。欄<code>x</code>と<code>y</code>は、両方とも同じ総称化データ型<code>T</code>持つため、同じ型でなければなりません。</span>

この例では、整数値5を`x`に代入すると、総称型`T`が`Point<T>`この<ruby>実例<rt>インスタンス</rt></ruby>の整数になることを<ruby>製譜器<rt>コンパイラー</rt></ruby>に知らせます。
次に、`x`と同じ型を持つと定義した`y`を4.0と指定すると、次のような型の不一致<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0308]: mismatched types
 --> src/main.rs:7:38
  |
7 |     let wont_work = Point { x: 5, y: 4.0 };
  |                                      ^^^ expected integral variable, found
floating-point variable
  |
  = note: expected type `{integer}`
             found type `{float}`
```

`x`と`y`がともに総称化であるが異なる型を持つ`Point`構造体を定義するには、複数の総称型パラメータを使用できます。
たとえば、リスト10-8では、型`T`と型`U`ここで、`x`は型`T`、 `y`は型`U`に対して、`Point`の定義を汎用型に変更することができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

fn main() {
    let both_integer = Point { x: 5, y: 10 };
    let both_float = Point { x: 1.0, y: 4.0 };
    let integer_and_float = Point { x: 5, y: 4.0 };
}
```

<span class="caption">リスト10-8。 <code>Point&lt;T, U&gt;</code>は2つの型を総称し、 <code>x</code>と<code>y</code>は異なる型の値となりうる</span>

表示された`Point`すべての<ruby>実例<rt>インスタンス</rt></ruby>が許可されました！　
定義には、必要な数の総称化・型・パラメーターを使用できますが、数を超える数を使用すると、<ruby>譜面<rt>コード</rt></ruby>を読みにくくすることができます。
<ruby>譜面<rt>コード</rt></ruby>にたくさんの総称型が必要な場合は、<ruby>譜面<rt>コード</rt></ruby>がより小さな部分に再構成する必要があることを示している可能性があります。

### 列挙型の定義

構造体で行ったように、さまざまな種類の汎用データ型を保持する列挙型を定義できます。
第6章で使用した標準<ruby>譜集<rt>ライブラリー</rt></ruby>が提供する`Option<T>`列をもう一度見てみましょう。

```rust
enum Option<T> {
    Some(T),
    None,
}
```

この定義はあなたにもっと意味をなさされるはずです。
見ることができるように、`Option<T>`型の上に一般的なもので列挙型である`T`。と二つの<ruby>場合値<rt>バリアント</rt></ruby>がある`Some`、1型の値を保持している`T`、および`None`任意の値を保持していない<ruby>場合値<rt>バリアント</rt></ruby>を。
`Option<T>`列挙型を使用することによって、オプションの値を持つという抽象的な概念を表現することができます。`Option<T>`は汎用的なので、オプション値の型に関係なく抽象化を使用できます。

Enumは複数の総称型も使用できます。
第9章で使用した`Result` enumの定義は、一例です。

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`Result`列挙型の2種類、オーバー総称である`T`と`E`、および2つの<ruby>場合値<rt>バリアント</rt></ruby>があります。 `Ok`、型の値を保持`T`、と`Err`型の値を保持し、`E`。
この定義は、それが便利に使用できるようになり`Result`どこでも、成功（いくつかの型の値を返す可能性がある操作持って列挙型を`T`（いくつかの型の<ruby>誤り<rt>エラー</rt></ruby>を返す）または失敗を`E`）。
実際には、これはリスト9-3のファイルを開くために使用したものです。ファイルが正常にオープンされたときに`T`が型`std::fs::File`で埋められ、`E`が型`std::io::Error`ファイルを開くときに問題が発生したときの`std::io::Error`。

保持する値の型だけが異なる複数の構造体または列挙型定義を持つ<ruby>譜面<rt>コード</rt></ruby>の状況を認識すると、代わりに汎用型を使用して重複を避けることができます。

### <ruby>操作法<rt>メソッド</rt></ruby>定義

構造体と列挙型の<ruby>操作法<rt>メソッド</rt></ruby>を実装することができます（第5章で行ったように）。
リスト10-9は、リスト10-6で定義した`Point<T>`構造体に、`x`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を実装したものです。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```

<span class="caption">リスト10-9。 <code>T</code>型の<code>x</code>欄への参照を返す<code>Point&lt;T&gt;</code>構造体に<code>x</code>という名前の<ruby>操作法<rt>メソッド</rt></ruby>を実装する</span>

ここでは、<ruby>欄<rt>フィールド</rt></ruby>`x`データへの参照を返す`Point<T>` `x`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を定義しました。

`impl`直後に`T`を宣言しなければならないので、`Point<T>`型の<ruby>操作法<rt>メソッド</rt></ruby>を実装するよう指定する必要があります。
`impl`後に`T`を総称型として宣言することで、Rustは`Point`の角かっこ内の型が具体的な型ではなく総称型であることを識別できます。

たとえば、一般的な型の`Point<T>`<ruby>実例<rt>インスタンス</rt></ruby>ではなく、`Point<f32>`<ruby>実例<rt>インスタンス</rt></ruby>でのみ<ruby>操作法<rt>メソッド</rt></ruby>を実装できます。
リスト10-10では、具体的な型`f32`を使用します。つまり、`impl`後に型を宣言しません。

```rust
# struct Point<T> {
#     x: T,
#     y: T,
# }
#
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

<span class="caption">リスト10-10。総称型のパラメータ<code>T</code>特定の具体的な型を持つ構造体にのみ適用される<code>impl</code>段落</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`Point<f32>`型に`distance_from_origin`という名前の<ruby>操作法<rt>メソッド</rt></ruby>があり、`T`が`f32`型ではない`Point<T>`他の<ruby>実例<rt>インスタンス</rt></ruby>にこの<ruby>操作法<rt>メソッド</rt></ruby>が定義されていないことを意味します。
この<ruby>操作法<rt>メソッド</rt></ruby>は、ポイントが座標（0.0、0.0）のポイントからどれだけ離れているかを測定し、浮動小数点型に対してのみ使用可能な数学演算を使用します。

構造体定義の汎用型のパラメータは、その構造体の<ruby>操作法<rt>メソッド</rt></ruby>の型注釈で使用するものと必ずしも同じではありません。
例えば、リスト10-11は、リスト10-8の`Point<T, U>`構造体の<ruby>操作法<rt>メソッド</rt></ruby>`mixup`を定義しています。
この方法は、別のかかる`Point`とは異なる型かもしれませんパラメータとして`self` `Point`呼んでいる`mixup`上に。
この方法は、新規作成`Point`と<ruby>実例<rt>インスタンス</rt></ruby>`x`の値`self` `Point`（型の`T`）と`y`の値を渡された`Point`（型の`W`）。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

impl<T, U> Point<T, U> {
    fn mixup<V, W>(self, other: Point<V, W>) -> Point<T, W> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 5, y: 10.4 };
    let p2 = Point { x: "Hello", y: 'c'};

    let p3 = p1.mixup(p2);

    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
}
```

<span class="caption">リスト10-11。構造体の定義とは異なる総称型を使用する操作法</span>

`main`では、`x` `i32`（値`5`）と`y` `f64`（値`10.4`）を持つ`Point`を定義しました。
`p2`変数である`Point`の<ruby>文字列<rt>ストリング</rt></ruby>スライス有する構造体`x`（値が`"Hello"`）及び`char`用の`y`（値と`c`）。
`p1`を引数`p2`で`mixup`すると、`p3` `i32` `x`は`p1`から来たので、`x` `i32`を持ちます。
`y`は`p2`から来たので、`p3`変数は`y` `char`を持ちます。
`println!`マクロ呼び出しは`p3.x = 5, p3.y = c`ます。

この例の目的は、いくつかの総称化パラメータが`impl`で宣言され、いくつかが<ruby>操作法<rt>メソッド</rt></ruby>定義で宣言される状況を示すことです。
ここでは、一般的なパラメータ`T`と`U`は、構造体定義に従うため、`impl`後に宣言されています。
総称化パラメータ`V`と`W`は、`fn mixup`後に宣言されます。なぜなら、それらは<ruby>操作法<rt>メソッド</rt></ruby>にのみ関連しているからです。

### Genericsを使用した<ruby>譜面<rt>コード</rt></ruby>のパフォーマンス

総称型パラメータを使用しているときに実行時コストがあるかどうか疑問に思うかもしれません。
良いニュースは、Rustは総称型を具体的な型よりも遅く実行しないように総称型を実装することです。

Rustは、<ruby>製譜<rt>コンパイル</rt></ruby>時に総称化を使用している<ruby>譜面<rt>コード</rt></ruby>の単体化を実行することでこれを実現します。
*単体化*は、<ruby>製譜<rt>コンパイル</rt></ruby>時に使用される具体的な型を*埋め込む*ことによって、汎用<ruby>譜面<rt>コード</rt></ruby>を特定の<ruby>譜面<rt>コード</rt></ruby>に変換する過程です。

この過程では、<ruby>製譜器<rt>コンパイラー</rt></ruby>は<ruby>譜面<rt>コード</rt></ruby>リスト10-5の総称化機能を作成するために使用した手順の逆を行います。<ruby>製譜器<rt>コンパイラー</rt></ruby>は総称化<ruby>譜面<rt>コード</rt></ruby>が呼び出されるすべての場所を調べ、総称化<ruby>譜面<rt>コード</rt></ruby>が呼び出される具象型の<ruby>譜面<rt>コード</rt></ruby>を生成します。

これは、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`Option<T>`列挙型を使用する例でどのように動作するかを見てみましょう。

```rust
let integer = Some(5);
let float = Some(5.0);
```

Rustがこの<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>すると、単形化が実行されます。
この過程中、<ruby>製譜器<rt>コンパイラー</rt></ruby>は`Option<T>`<ruby>実例<rt>インスタンス</rt></ruby>で使用された値を読み込み、2種類の`Option<T>`を識別します。1つは`i32`で、もう1つは`f64`です。
そのため、`Option<T>`の汎用定義を`Option_i32`と`Option_f64`、汎用定義を特定のものに置き換えます。

<ruby>譜面<rt>コード</rt></ruby>の単形化版は以下のようになります。
一般的な`Option<T>`は、<ruby>製譜器<rt>コンパイラー</rt></ruby>によって作成された特定の定義に置き換えられます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
enum Option_i32 {
    Some(i32),
    None,
}

enum Option_f64 {
    Some(f64),
    None,
}

fn main() {
    let integer = Option_i32::Some(5);
    let float = Option_f64::Some(5.0);
}
```

Rustは総称化<ruby>譜面<rt>コード</rt></ruby>を各<ruby>実例<rt>インスタンス</rt></ruby>の型を指定する<ruby>譜面<rt>コード</rt></ruby>に<ruby>製譜<rt>コンパイル</rt></ruby>するので、総称化の使用には実行時コストはかかりません。
<ruby>譜面<rt>コード</rt></ruby>が実行されると、各定義を手作業で複製した場合と同じように機能します。
単相化の過程は、実行時にRustの総称化を非常に効率的にします。
