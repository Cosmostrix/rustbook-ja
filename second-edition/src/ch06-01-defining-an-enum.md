## 列挙型の定義

この例では、<ruby>譜面<rt>コード</rt></ruby>で表現したいと思う状況を見て、列挙型が構造体よりも有用で適切な理由を見てみましょう。
IP番地で作業する必要があるとします。
現在、IP番地には、版4と版6の2つの主要な標準が使用されています。
これらは、<ruby>算譜<rt>プログラム</rt></ruby>が遭遇するIP番地のための唯一の可能性です。列挙がその名前を取得するところのすべての可能な値を*列挙*することができます。

どのIP番地も、版4または版6のいずれかの番地にすることができますが、同時に両方を使用することはできません。
列挙型の値は<ruby>場合値<rt>バリアント</rt></ruby>の1つに過ぎないため、IP番地のそのプロパティは列挙型のデータ構造を適切にします。
版4と版6の両方の番地は、基本的にはIP番地なので、<ruby>譜面<rt>コード</rt></ruby>があらゆる種類のIP番地に適用される状況を処理する場合、同じ型として扱う必要があります。

`IpAddrKind`列挙を定義し、IP番地が`V4`と`V6`の可能な種類を列挙することで、この概念を<ruby>譜面<rt>コード</rt></ruby>で表現できます。
これらは列挙*型の<ruby>場合値<rt>バリアント</rt></ruby>*として知られてい*ます*。

```rust
enum IpAddrKind {
    V4,
    V6,
}
```

`IpAddrKind`は、<ruby>譜面<rt>コード</rt></ruby>内の他の場所でも使用できる独自のデータ型になりました。

### 列挙型の値

`IpAddrKind`ように、`IpAddrKind`の2つの<ruby>場合値<rt>バリアント</rt></ruby>それぞれの<ruby>実例<rt>インスタンス</rt></ruby>を作成できます。

```rust
# enum IpAddrKind {
#     V4,
#     V6,
# }
#
let four = IpAddrKind::V4;
let six = IpAddrKind::V6;
```

列挙型の<ruby>場合値<rt>バリアント</rt></ruby>はその識別子の下に名前空間があり、二重のコロンを使用してそれらを区切ることに注意してください。
これが便利な理由は、`IpAddrKind::V4`と`IpAddrKind::V6`両方の値が同じ型である`IpAddrKind`です。`IpAddrKind`です。
たとえば、`IpAddrKind`をとる機能を定義することができ`IpAddrKind`。

```rust
# enum IpAddrKind {
#     V4,
#     V6,
# }
#
fn route(ip_type: IpAddrKind) { }
```

そして、この機能をどちらかの<ruby>場合値<rt>バリアント</rt></ruby>で呼び出すことができます。

```rust
# enum IpAddrKind {
#     V4,
#     V6,
# }
#
# fn route(ip_type: IpAddrKind) { }
#
route(IpAddrKind::V4);
route(IpAddrKind::V6);
```

列挙型を使用するとさらに利点があります。
IP番地の種類についてもっと考えてみると、現時点では実際のIP番地の*データ*を格納する方法はありません。
それがどんな*種類*であるかだけを知っています。
第5章で構造体について学んだことを考えると、リスト6-1に示すように、この問題に取り組む可能性があります。

```rust
enum IpAddrKind {
    V4,
    V6,
}

struct IpAddr {
    kind: IpAddrKind,
    address: String,
}

let home = IpAddr {
    kind: IpAddrKind::V4,
    address: String::from("127.0.0.1"),
};

let loopback = IpAddr {
    kind: IpAddrKind::V6,
    address: String::from("::1"),
};
```

<span class="caption">リスト6-1。 <code>struct</code>を使用してIP番地のdataおよび<code>IpAddrKind</code>場合値を格納する</span>

ここでは、構造体の定義した`IpAddr` 2つの<ruby>欄<rt>フィールド</rt></ruby>を持っている`kind`の型である<ruby>欄<rt>フィールド</rt></ruby>`IpAddrKind`（前に定義された列挙型）と`address`型の<ruby>欄<rt>フィールド</rt></ruby>`String`。
この構造体には2つの<ruby>実例<rt>インスタンス</rt></ruby>があります。
最初の`home`は、その`kind`として`IpAddrKind::V4`という値を持ち、関連付けられた番地データは`127.0.0.1`です。
2番目の<ruby>実例<rt>インスタンス</rt></ruby>`loopback`は、その`kind`値`V6`として`IpAddrKind`の別の<ruby>場合値<rt>バリアント</rt></ruby>を持ち、番地`::1`関連付けています。
構造体を使用して`kind`と`address`値をまとめて束縛しました。そのため、<ruby>場合値<rt>バリアント</rt></ruby>は値に関連付けられます。

構造体内の列挙型ではなく、単に列挙型を使用して、各列挙型<ruby>場合値<rt>バリアント</rt></ruby>に直接データを入れて、同じ概念をより簡潔な方法で表現できます。
`IpAddr`列挙型のこの新しい定義によれば、`V4`と`V6`両方の<ruby>場合値<rt>バリアント</rt></ruby>には、関連付けられた`String`値があります。

```rust
enum IpAddr {
    V4(String),
    V6(String),
}

let home = IpAddr::V4(String::from("127.0.0.1"));

let loopback = IpAddr::V6(String::from("::1"));
```

列挙型の各<ruby>場合値<rt>バリアント</rt></ruby>にデータを直接添付するので、余分な構造体は必要ありません。

構造体ではなく、列挙型を使用することには別の利点があります。それぞれの<ruby>場合値<rt>バリアント</rt></ruby>は、関連するデータの型と量を異ならせることができます。
版4種類のIP番地は、常に保存したい場合は0〜255の値を持つことになります4つの数字の部品があります`V4` 4つのとして番地を`u8`値が、それでも表現`V6`一つとして、番地を`String`値を、持つことができないだろう構造体。
列挙型はこのケースを簡単に処理します。

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

let home = IpAddr::V4(127, 0, 0, 1);

let loopback = IpAddr::V6(String::from("::1"));
```

版4と版6のIP番地を格納するためにデータ構造を定義するいくつかの異なる方法を示しました。
しかし、明らかになったように、IP番地を格納して、どのような種類のものを符号化したいのかは、よくあることです[。標準<ruby>譜集<rt>ライブラリー</rt></ruby>には、使用できる定義があります。][IpAddr]
 標準<ruby>譜集<rt>ライブラリー</rt></ruby>が`IpAddr`をどのように定義しているかを見てみましょう。それは定義し使用した正確な列挙型と<ruby>場合値<rt>バリアント</rt></ruby>を持っていますが、<ruby>場合値<rt>バリアント</rt></ruby>ごとに異なって定義された2つの異なる構造体の形で、

[IpAddr]: ../../std/net/enum.IpAddr.html

```rust
struct Ipv4Addr {
#    // --snip--
    //  --snip--
}

struct Ipv6Addr {
#    // --snip--
    //  --snip--
}

enum IpAddr {
    V4(Ipv4Addr),
    V6(Ipv6Addr),
}
```

この<ruby>譜面<rt>コード</rt></ruby>は、列挙型の内部に任意の種類のデータ（<ruby>文字列<rt>ストリング</rt></ruby>、数値型、または構造体など）を入れることができることを示しています。
別の列挙型を含めることもできます！　
また、標準的な<ruby>譜集<rt>ライブラリー</rt></ruby>型は、思いつくよりもはるかに複雑ではありません。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>に`IpAddr`定義が含まれていても、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の定義を<ruby>有効範囲<rt>スコープ</rt></ruby>に持たないため、独自の定義を作成して使用することができます。
第7章では、型を<ruby>有効範囲<rt>スコープ</rt></ruby>内に持ち込む方法について詳しく説明します。

リスト6-2の別のenumの例を見てみましょう。これは、その<ruby>場合値<rt>バリアント</rt></ruby>にさまざまな型が埋め込まれています。

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

<span class="caption">譜面リスト6-2。 <code>Message</code>列挙型で、それぞれが異なる金額と型の値を格納する</span>

この列挙型には、さまざまな種類の4つの<ruby>場合値<rt>バリアント</rt></ruby>があります。

* `Quit`は、それに関連するデータはまったくありません。
* `Move`は、内部に無名の構造体が含まれます。
* `Write`には単一の`String`含まれます。
* `ChangeColor`は、3つの`i32`値が含まれます。

<ruby>譜面<rt>コード</rt></ruby>リスト6-2のような<ruby>場合値<rt>バリアント</rt></ruby>を持つ列挙型を定義することは、enumが`struct`予約語を使用せず、すべての<ruby>場合値<rt>バリアント</rt></ruby>が`Message`型で一緒にグループ化されることを除いて、異なる種類の構造体定義を定義することと似ています。
次の構造体は、前の列挙型が保持するデータと同じデータを保持できます。

```rust
#//struct QuitMessage; // unit struct
struct QuitMessage; // 単位構造
struct MoveMessage {
    x: i32,
    y: i32,
}
#//struct WriteMessage(String); // tuple struct
struct WriteMessage(String); // 組構造体
#//struct ChangeColorMessage(i32, i32, i32); // tuple struct
struct ChangeColorMessage(i32, i32, i32); // 組構造体
```

しかし、それぞれ独自の型を持つ異なる構造体を使用した場合、リスト6-2で定義されている`Message` enumと同様に、これらのメッセージのいずれかを取る機能を簡単に定義することはできません。型。

enumとstructの間にはもう1つの類似点があります。`impl`、 `impl`を使って構造体の<ruby>操作法<rt>メソッド</rt></ruby>を定義できるように、enumで<ruby>操作法<rt>メソッド</rt></ruby>を定義することもできます。
`Message` enumで定義できる`call`という<ruby>操作法<rt>メソッド</rt></ruby>があります。

```rust
# enum Message {
#     Quit,
#     Move { x: i32, y: i32 },
#     Write(String),
#     ChangeColor(i32, i32, i32),
# }
#
impl Message {
    fn call(&self) {
#        // method body would be defined here
        // <ruby>操作法<rt>メソッド</rt></ruby>本体はここで定義されます
    }
}

let m = Message::Write(String::from("hello"));
m.call();
```

<ruby>操作法<rt>メソッド</rt></ruby>の本体は`self`を使用して、<ruby>操作法<rt>メソッド</rt></ruby>を呼び出した値を取得します。
この例では、値`Message::Write(String::from("hello"))`を持つ変数`m`を作成しました。これは、`call`<ruby>操作法<rt>メソッド</rt></ruby>の本体で`self`が`m.call()`が実行されます。

非常に一般的で便利な標準<ruby>譜集<rt>ライブラリー</rt></ruby>の別の列挙型を見てみましょう。 `Option`。

### `Option`列挙型とそのヌル値に対する利点

前の章では、`IpAddr`列挙型がRustの型体系を使用して、<ruby>算譜<rt>プログラム</rt></ruby>のデータだけでなく、より多くの情報を符号化する方法を見てきました。
この章では、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって定義された別の列挙型である`Option`事例で学ぶについて説明します。
`Option`型は、値が何かになる可能性がある、または何もできないという非常に一般的な場合を符号化するため、多くの場所で使用されます。
この概念を型体系の観点から表現すると、<ruby>製譜器<rt>コンパイラー</rt></ruby>は処理する必要があるすべてのケースを処理したかどうかをチェックできます。
この機能により、他の<ruby>演譜<rt>プログラミング</rt></ruby>言語で非常に一般的なバグを防ぐことができます。

<ruby>演譜<rt>プログラミング</rt></ruby>言語の設計は、どの機能を含むかという点ではよく考えられますが、除外する機能も重要です。
Rustには他の多くの言語が持つヌル機能はありません。
*Null*は値がないことを意味する値です。
nullを持つ言語では、変数は常にnullまたはnot-nullの2つの状態のいずれかになります。

2009年のプレゼンテーション「Null References。The 10億ドルの間違い」では、nullの発明者であるTony Hoareがこう言っています。

> > 私はそれを億ドルの間違いと呼ぶ。
> > 当時、私は<ruby>対象<rt>オブジェクト</rt></ruby>指向言語での参照のための最初の包括的型体系を設計していました。
> > 私の目標は、参照のすべての使用が完全に安全であることと、<ruby>製譜器<rt>コンパイラー</rt></ruby>によって自動的にチェックが行われることを確実にすることでした。
> > しかし、簡単に実装することができたからといって、ヌル参照を入れるという誘惑に抵抗することはできませんでした。
> > これにより、おそらく過去40年間に10億ドルの苦痛と損害を引き起こした無数の<ruby>誤り<rt>エラー</rt></ruby>、脆弱性、システム<ruby>異常終了<rt>クラッシュ</rt></ruby>が発生しました。

ヌル値の問題は、ヌル値をヌル値として使用しようとすると、何らかの<ruby>誤り<rt>エラー</rt></ruby>が発生することです。
このnullまたはnot-nullプロパティは広く使用されているため、この種の<ruby>誤り<rt>エラー</rt></ruby>は非常に簡単です。

しかし、nullが表現しようとしている概念は、まだ有用なものです。nullは、何らかの理由で現在無効であるか存在しない値です。

問題は実際には概念ではなく、特定の実装であます。
そのため、Rustにはnullはありませんが、値の存在または不在を符号化できる列挙型があります。
この列挙型は`Option<T>`であり[、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって定義されています][option]
 次のように。

[option]: ../../std/option/enum.Option.html

```rust
enum Option<T> {
    Some(T),
    None,
}
```

`Option<T>`列挙型は非常に有用であり、それは前奏譜にも含まれています。
それを明示的に<ruby>有効範囲<rt>スコープ</rt></ruby>に入れる必要はありません。
さらに、その亜種もそうです。 `Some`と`None`を`Option::`プリフィックス`None`直接使うことができます。
`Option<T>`列挙型は依然として通常の列挙型であり、`Some(T)`と`None`はまだ`Option<T>`型の<ruby>場合値<rt>バリアント</rt></ruby>です。

`<T>`構文は、まだ説明していないRustの機能です。
これは総称型のパラメータであり、第10章で総称化について詳しく説明します。今のところ、`<T>`は`Option` enumの`Some` <ruby>場合値<rt>バリアント</rt></ruby>が任意の型のデータを保持できることを意味します。
`Option`値を使用して数値型と<ruby>文字列<rt>ストリング</rt></ruby>型を保持する例をいくつか示します。

```rust
let some_number = Some(5);
let some_string = Some("a string");

let absent_number: Option<i32> = None;
```

`Some`ではなく`None`を使用する場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は`Some`型が`None`値だけを見て保持する型を推論することができないため、Rustにどの型の`Option<T>`渡す必要があります。

`Some`値があるときは、ある値が存在し、その値が`Some`値内に保持されていることがわかります。
`None`値がある場合、ある意味ではnullと同じ意味を持ちます。有効な値がありません。
なぜ、`Option<T>`がnullを持つよりも優れているのでしょうか？　

要するに、`Option<T>`と`T`（ `T`は任意の型とすることができる）は異なる型であるため、<ruby>製譜器<rt>コンパイラー</rt></ruby>は`Option<T>`値をあたかも正当な値であるかのように使用しません。
たとえば、この<ruby>譜面<rt>コード</rt></ruby>は`i8`を`Option<i8>`に追加しようとしているため<ruby>製譜<rt>コンパイル</rt></ruby>されません。

```rust,ignore
let x: i8 = 5;
let y: Option<i8> = Some(5);

let sum = x + y;
```

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、次のような<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。

```text
error[E0277]: the trait bound `i8: std::ops::Add<std::option::Option<i8>>` is
not satisfied
 -->
  |
5 |     let sum = x + y;
  |                 ^ no implementation for `i8 + std::option::Option<i8>`
  |
```

激しい！　
実際、この<ruby>誤り<rt>エラー</rt></ruby>メッセージは、異なる型のため、Rustは`i8`と`Option<i8>`追加方法を理解していないことを意味します。
Rustの`i8`ような型の値を持つとき、<ruby>製譜器<rt>コンパイラー</rt></ruby>は常に正しい値を持つことを保証します。
その値を使用する前に、nullをチェックする必要はありません。
`Option<i8>`（またはそれが働いている値の種類）を持っている場合にのみ、値を持たない可能性について心配する必要があります。<ruby>製譜器<rt>コンパイラー</rt></ruby>は値を使用する前にそのケースを処理するようにします。

言い換えれば、変換する必要があります`Option<T>`する`T`実行する前に`T`それとの動作を制御します。
一般に、これはヌルに関する最も一般的な問題の1つを<ruby>捕捉<rt>キャッチ</rt></ruby>するのに役立ちます。実際には何かがnullではないと仮定します。

値がNULLではないと誤って心配する必要はなく、<ruby>譜面<rt>コード</rt></ruby>に自信を持たせることができます。
nullになる可能性のある値を持つためには、その値の型を`Option<T>`明示的にオプトインする必要があります。
次に、その値を使用するときは、値がnullの場合に明示的に処理する必要があります。
どこでも値がない型があることを`Option<T>`、安全に値がnullでないと仮定*することができ*ます。
これは、Rustがnullの普及を制限し、Rust<ruby>譜面<rt>コード</rt></ruby>の安全性を高めるための意図的な設計決定でした。

だから、`Option<T>`型の値を持つときに`T`値を`Some`型からどのように取得すると、その値を使うことができるのでしょうか？　
`Option<T>`列挙型は、さまざまな状況で便利な多数の<ruby>操作法<rt>メソッド</rt></ruby>を持っています。
[その開発資料で][docs]それらをチェックすることができ[ます][docs]
 。
`Option<T>`<ruby>操作法<rt>メソッド</rt></ruby>に慣れると、Rustの旅に非常に役立ちます。

[docs]: ../../std/option/enum.Option.html

一般的に、`Option<T>`値を使用するには、各<ruby>場合値<rt>バリアント</rt></ruby>を処理する<ruby>譜面<rt>コード</rt></ruby>を用意する必要があります。
`Some(T)`値があるときにのみ実行されるいくつかの<ruby>譜面<rt>コード</rt></ruby>が必要です。この<ruby>譜面<rt>コード</rt></ruby>は内部`T`を使用することができます。
`None`値があり、その<ruby>譜面<rt>コード</rt></ruby>に利用可能な`T`値がない場合、他の<ruby>譜面<rt>コード</rt></ruby>を実行する必要があります。
`match`式は、列挙型で使用されている場合にのみこれを行う<ruby>制御構造<rt>コントロールフロー</rt></ruby>構造です。列挙型の<ruby>場合値<rt>バリアント</rt></ruby>に応じて異なる<ruby>譜面<rt>コード</rt></ruby>を実行し、一致する値内のデータを使用することができます。
