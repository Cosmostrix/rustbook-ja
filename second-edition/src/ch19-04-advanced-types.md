## 発展的な型

Rust型体系には、本書で述べたいくつかの機能がありますが、まだ説明はしていません。
新しい型の一般的な議論から始めることから、newtypeが型として有益な理由を調べます。
次に、newtypesに似ているが少し意味が異なる<ruby>別名<rt>エイリアス</rt></ruby>を入力します。
また`!`型と動的なサイズの型についても説明します。

> > 注。次の章では、前の章「外部型に外部<ruby>特性<rt>トレイト</rt></ruby>を実装するためのNewtypeパターン」を読んだことを前提としています。

### 型の安全性と抽象化のためのNewtypeパターンの使用

newtypeパターンは、値が混乱することがなく、値の単位を示すことを静的に強制型変換するなど、これまで説明したこと以外の仕事に役立ちます。
リスト19-23のユニットを示すためにnewtypesを使用する例を見てきました。 `Millimeters`と`Meters`構造体が`u32`値を包みたことを思い出してください。
`Millimeters`型のパラメータを持つ機能を書いた場合、誤ってその機能を`Meters`型の値または普通の`u32`型の値で呼び出そうとした<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>できませんでした。

newtypeパターンのもう1つの使用法は、型の実装の詳細を抽象化することです。新しい型は、新しい型を直接使用して使用可能な機能を制限すると、private型のAPIとは異なるpublic APIを<ruby>公開<rt>パブリック</rt></ruby>することができます。例。

ニュー型は、内部実装を隠すこともできます。
たとえば、名前に関連付けられた人のIDを格納する`HashMap<i32, String>`を包む`People`型を提供できます。
`People`を使用する<ruby>譜面<rt>コード</rt></ruby>は、`People`<ruby>集まり<rt>コレクション</rt></ruby>に名前<ruby>文字列<rt>ストリング</rt></ruby>を追加する<ruby>操作法<rt>メソッド</rt></ruby>など、提供する<ruby>公開<rt>パブリック</rt></ruby>APIとのみ対話します。
その<ruby>譜面<rt>コード</rt></ruby>は内部的に名前に`i32` IDを割り当てることを知る必要はありません。
newtypeパターンは、実装の詳細を隠すためのカプセル化を実現するための軽量な方法です。これについては、第17章の「実装の詳細を隠すカプセル化」の章で説明しました。

### 型<ruby>別名<rt>エイリアス</rt></ruby>を持つ型シノニムの作成

newtypeパターンに加えて、Rustは*型<ruby>別名<rt>エイリアス</rt></ruby>*を宣言して既存の型に別の名前を与える機能を提供します。
このためには、`type`予約語を使用します。
たとえば、次のように`i32`<ruby>別名<rt>エイリアス</rt></ruby>`Kilometers`を作成できます。

```rust
type Kilometers = i32;
```

さて、`Kilometers`の<ruby>別名<rt>エイリアス</rt></ruby>は`i32` *同義語*です。
異なり`Millimeters`と`Meters`リスト19-23で作成した型、`Kilometers`別の、新しい型ではありません。
`Kilometers`型の値は、型`i32`値と同じように扱われます。

```rust
type Kilometers = i32;

let x: i32 = 5;
let y: Kilometers = 5;

println!("x + y = {}", x + y);
```

`Kilometers`と`i32`は同じ型なので、両方の型の値を追加することができ、`i32`パラメーターを取る機能に`Kilometers`値を渡すことができます。
ただし、この<ruby>操作法<rt>メソッド</rt></ruby>を使用すると、前に説明したnewtypeパターンから得られる型チェックの利点は得られません。

型シノニムの主な使用例は、繰り返しを減らすことです。
たとえば、次のような長い型があるとします。

```rust,ignore
Box<Fn() + Send + 'static>
```

この長い型を関数型注釈と型<ruby>補注<rt>アノテーション</rt></ruby>として<ruby>譜面<rt>コード</rt></ruby>全体に記述すると、面倒で<ruby>誤り<rt>エラー</rt></ruby>が発生する可能性があります。
リスト19-32のような<ruby>譜面<rt>コード</rt></ruby>で完全な企画を持っていると想像してください。

```rust
let f: Box<Fn() + Send + 'static> = Box::new(|| println!("hi"));

fn takes_long_type(f: Box<Fn() + Send + 'static>) {
#    // --snip--
    //  --snip--
}

fn returns_long_type() -> Box<Fn() + Send + 'static> {
#    // --snip--
    //  --snip--
#     Box::new(|| ())
}
```

<span class="caption">リスト19-32。多くの場所で長い型を使う</span>

型<ruby>別名<rt>エイリアス</rt></ruby>は、繰り返しを減らすことによって、この<ruby>譜面<rt>コード</rt></ruby>をより管理しやすくします。
リスト19-33では、冗長型の`Thunk`という<ruby>別名<rt>エイリアス</rt></ruby>を導入し、その型のすべての使用をより短い<ruby>別名<rt>エイリアス</rt></ruby>`Thunk`置き換えることができます。

```rust
type Thunk = Box<Fn() + Send + 'static>;

let f: Thunk = Box::new(|| println!("hi"));

fn takes_long_type(f: Thunk) {
#    // --snip--
    //  --snip--
}

fn returns_long_type() -> Thunk {
#    // --snip--
    //  --snip--
#     Box::new(|| ())
}
```

<span class="caption">リスト19-33。型<ruby>別名<rt>エイリアス</rt></ruby>の導入<code>Thunk</code>繰り返しを減らすために</span>

この<ruby>譜面<rt>コード</rt></ruby>は読み書きがはるかに簡単です！　
型<ruby>別名<rt>エイリアス</rt></ruby>の意味のある名前を選択することで、意図を伝えるのに役立ちます（*サンク*は後で評価される<ruby>譜面<rt>コード</rt></ruby>のため、保存される<ruby>閉包<rt>クロージャー</rt></ruby>の適切な名前です）。

型<ruby>別名<rt>エイリアス</rt></ruby>は`Result<T, E>`繰り返しを減らすために`Result<T, E>`型でもよく使用されます。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`std::io`<ruby>役区<rt>モジュール</rt></ruby>を考えてみましょう。
I/O操作は、操作が失敗した場合の状況を処理するために`Result<T, E>`を返すことがよくあります。
この<ruby>譜集<rt>ライブラリー</rt></ruby>には、すべての可能な入出力<ruby>誤り<rt>エラー</rt></ruby>を表す`std::io::Error`構造体があります。
`std::io`機能の多くは、`E`が`std::io::Error`である`Result<T, E>`返します。これらの機能は、`Write` trait。

```rust
use std::io::Error;
use std::fmt;

pub trait Write {
    fn write(&mut self, buf: &[u8]) -> Result<usize, Error>;
    fn flush(&mut self) -> Result<(), Error>;

    fn write_all(&mut self, buf: &[u8]) -> Result<(), Error>;
    fn write_fmt(&mut self, fmt: fmt::Arguments) -> Result<(), Error>;
}
```

`Result<..., Error>`は頻繁に繰り返されます。
したがって、`std::io`は、この型の<ruby>別名<rt>エイリアス</rt></ruby>宣言があります。

```rust,ignore
type Result<T> = Result<T, std::io::Error>;
```

この宣言は`std::io`<ruby>役区<rt>モジュール</rt></ruby>にあるので、完全修飾<ruby>別名<rt>エイリアス</rt></ruby>`std::io::Result<T>`を使用することができます。つまり、`Result<T, E>`は`E`を`std::io::Error`。
`Write` trait機能の型注釈は次のようになります。

```rust,ignore
pub trait Write {
    fn write(&mut self, buf: &[u8]) -> Result<usize>;
    fn flush(&mut self) -> Result<()>;

    fn write_all(&mut self, buf: &[u8]) -> Result<()>;
    fn write_fmt(&mut self, fmt: Arguments) -> Result<()>;
}
```

型の<ruby>別名<rt>エイリアス</rt></ruby>は、2つの方法で役立ちます。それは書くの<ruby>譜面<rt>コード</rt></ruby>が容易になり*、*それがすべてにわたって一貫した<ruby>接点<rt>インターフェース</rt></ruby>与え`std::io`。
それは<ruby>別名<rt>エイリアス</rt></ruby>なので、別の`Result<T, E>`。これは`Result<T, E>`で動作する<ruby>操作法<rt>メソッド</rt></ruby>を使用できることを意味し`?`
演算子。

### 決して戻らない絶対的な型

Rustには、型理論lingoで*空の型*として知られている、値がないので、特別な型の`!`があります。
機能が決して返ってこないときは、戻り型の代わりに立つので、*これをnever型*と呼んでいます。
次に例を示します。

```rust,ignore
fn bar() -> ! {
#    // --snip--
    //  --snip--
}
```

この<ruby>譜面<rt>コード</rt></ruby>は、「機能`bar`は決して返さない」と解釈されます。決して返されない機能は*分岐機能*と呼ばれ*ます*。
`bar`が決して戻ってこないように、型`!`値を作成することはできません。

しかし、あなたは価値を創造することができない型は何でしょうか？　
リスト2-5の<ruby>譜面<rt>コード</rt></ruby>を思い出してください。
リスト19-34にその一部を再現しました。

```rust
# let guess = "3";
# loop {
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
# break;
# }
```

<span class="caption">リスト19-34。 <code>continue</code>で終わる分岐との<code>match</code></span>

当時、この<ruby>譜面<rt>コード</rt></ruby>で詳細をスキップしました。
第6章「 `match`<ruby>制御構造<rt>コントロールフロー</rt></ruby>演算子」の章では、`match`分岐はすべて同じ型を返さなければならないと説明しました。
たとえば、次の<ruby>譜面<rt>コード</rt></ruby>は機能しません。

```rust,ignore
let guess = match guess.trim().parse() {
    Ok(_) => 5,
    Err(_) => "hello",
}
```

この<ruby>譜面<rt>コード</rt></ruby>の`guess`の型は整数*と*<ruby>文字列<rt>ストリング</rt></ruby>でなければならず、Rustは`guess`は1つの型しか持たないことが必要`guess`。
だから何をし`continue`リターンを？　
どのようにして、1つの分岐から`u32`を返すことを許されたのでしょうか？　そしてリスト19-34に`continue`ます。

推測したように、`continue`は`!`値を持っています。
つまり、Rustが`guess`の型を計算するとき、両方のマッチ・分岐を調べます。前者は`u32`値を、後者は`!`値を持ちます。
`!`は決して値を持つことができないので、Rustは`guess`の型を`u32`と決定します。

この振る舞いを記述する正式な方法は、型`!`式を他の型に強制型変換することができるということです。
`continue`は値を返さないので、この`match`分岐を`continue`終了することができます。
代わりに、制御をループの先頭に戻します。したがって、`Err`場合、`guess`する値を決して割り当てません。

never型は`panic!`マクロにも便利です。
`Option<T>`値を呼び出して値またはパニックを生成する`unwrap`機能を覚えていますか？　
ここにその定義があります。

```rust,ignore
impl<T> Option<T> {
    pub fn unwrap(self) -> T {
        match self {
            Some(val) => val,
            None => panic!("called `Option::unwrap()` on a `None` value"),
        }
    }
}
```

この<ruby>譜面<rt>コード</rt></ruby>では、同じことが起こるのように`match`リスト19-34で。Rustがいることを見ている`val`型がある`T`と`panic!`型がある`!`、その全体的な結果`match`式がある`T`。
この<ruby>譜面<rt>コード</rt></ruby>は`panic!`が値を生成しないために機能します。
<ruby>算譜<rt>プログラム</rt></ruby>を終了します。
`None`場合、`unwrap`から値を返さないので、この<ruby>譜面<rt>コード</rt></ruby>は有効です。

`!`を持つ最後の式の1つは`loop`です。

```rust,ignore
print!("forever ");

loop {
    print!("and ever ");
}
```

ここで、ループは終了しないので、`!`は式の値です。
含まれている場合しかし、これは真実ではないでしょう`break`それに着いたとき、ループが終了してしまうため、`break`。

### 動的なサイズの型と`Sized`<ruby>特性<rt>トレイト</rt></ruby>

特定の型の値にどれくらいの空間を割り当てるかなど、細部を知る必要があるため、混乱を招く可能性のある型体系の一角があり*ます*。 *動的なサイズの型の*概念です。
*DST*または*unsized型*と呼ばれることもあり*ますが*、これらの型では、実行時にしか認識できないサイズの値を使用して<ruby>譜面<rt>コード</rt></ruby>を記述できます。

`str`と呼ばれる動的なサイズの型の詳細を掘り下げてみましょう。
それは正しいです、`&str`ではなく、`str`は単独で、DSTです。
実行時までの<ruby>文字列<rt>ストリング</rt></ruby>の長さはわかりません。つまり、`str`型の変数を作成することはできません。また、`str`型の引数を取ることもできません。
動作しない次の<ruby>譜面<rt>コード</rt></ruby>を考えてみましょう。

```rust,ignore
let s1: str = "Hello there!";
let s2: str = "How's it going?";
```

Rustは、特定の型の値に割り当てられる<ruby>記憶域<rt>メモリー</rt></ruby>の量を知る必要があり、ある型のすべての値は同じ量の記憶を使用する必要があります。
Rustがこの<ruby>譜面<rt>コード</rt></ruby>を書くことを許可した場合、これらの2つの`str`値は同じ量のスペースを占める必要があり`str`。
しかし、それらの長さは異なります`s1`は12バイトの<ruby>格納庫<rt>ストレージ</rt></ruby>が必要であり、`s2`は15が必要です。これは、動的にサイズの変更された型を保持する変数を作成できない理由です。

どうしようか？　
この場合、すでに答えを知っています。つまり、`s1`と`s2`型を`&str`ではなくa `&str`し`str`。
第4章の「<ruby>文字列<rt>ストリング</rt></ruby>スライス」の章では、スライスデータ構造にスライスの開始位置と長さが格納されていることを思い出してください。

がそう`&T`ここでの記憶番地格納する単一の値であり、`T`配置されているが、A `&str`の番地。 *二つの*値である`str`とその長さ。
したがって、<ruby>製譜<rt>コンパイル</rt></ruby>時の`&str`値のサイズはわかり`&str` `usize`長さの2倍`usize`。
つまり、<ruby>文字列<rt>ストリング</rt></ruby>の長さに関係なく、`&str`サイズは常にわかり`&str`。
一般に、これはRustで動的に使用されるサイズの型が使用される方法です。動的情報のサイズを格納する余分なビットのメタデータがあります。
動的なサイズの型のゴールデンルールは、ある種の<ruby>指し手<rt>ポインタ</rt></ruby>の後ろに常に動的に大きさを持つ型の値を置かなければならないということです。

たとえば、`Box<str>`や`Rc<str>`ように、`str`とあらゆる種類の<ruby>指し手<rt>ポインタ</rt></ruby>を組み合わせることができ`Rc<str>`。
実際には、以前はこれを見たことがありますが、型が異なる動的なサイズの<ruby>特性<rt>トレイト</rt></ruby>があります。
すべての<ruby>特性<rt>トレイト</rt></ruby>は、<ruby>特性<rt>トレイト</rt></ruby>の名前を使って参照できる動的なサイズの型です。
第17章「異なる型の値を許容する型<ruby>対象<rt>オブジェクト</rt></ruby>の使用」の章では、型をTrait<ruby>対象<rt>オブジェクト</rt></ruby>として使用するには、`&Trait`または`Box<Trait>`（ `Rc<Trait>`うまくいくだろう）。

DSTで作業するために、Rustには`Sized`<ruby>特性<rt>トレイト</rt></ruby>と呼ばれる特定の<ruby>特性<rt>トレイト</rt></ruby>があり、<ruby>製譜<rt>コンパイル</rt></ruby>時に型のサイズが分かっているかどうかを判断します。
この<ruby>特性<rt>トレイト</rt></ruby>は、<ruby>製譜<rt>コンパイル</rt></ruby>時にサイズがわかっているすべてのものに対して自動的に実装されます。
さらに、Rustは、`Sized`束縛を暗黙的にすべての汎用機能に追加します。
つまり、次のような汎用機能の定義です。

```rust,ignore
fn generic<T>(t: T) {
#    // --snip--
    //  --snip--
}
```

実際にはこれを書いたかのように扱われます。

```rust,ignore
fn generic<T: Sized>(t: T) {
#    // --snip--
    //  --snip--
}
```

自動的には、汎用機能は<ruby>製譜<rt>コンパイル</rt></ruby>時に既知のサイズを持つ型に対してのみ機能します。
ただし、次の特殊構文を使用してこの制限を緩和することができます。

```rust,ignore
fn generic<T: ?Sized>(t: &T) {
#    // --snip--
    //  --snip--
}
```

<ruby>特性<rt>トレイト</rt></ruby>は上の束縛`?Sized`上に結合<ruby>特性<rt>トレイト</rt></ruby>の反対で`Sized`。「これを読んでいました`T`たりしてもしなくてもよい`Sized`。」この構文はのためにのみ利用可能です`Sized`ではなく、任意の他の<ruby>特性<rt>トレイト</rt></ruby>。

また、`t`パラメータの型を`T`から`&T`に変更したことにも注意してください。
型は`Sized`ではない可能性があるため、ある種の<ruby>指し手<rt>ポインタ</rt></ruby>の後ろで使用する必要があります。
この場合、参照を選択しました。

次に、機能と<ruby>閉包<rt>クロージャー</rt></ruby>について説明します。
