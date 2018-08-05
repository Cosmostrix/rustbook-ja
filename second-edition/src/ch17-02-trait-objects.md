## 異なる型の値を許容する<ruby>特性<rt>トレイト</rt></ruby>対象の使用

第8章では、ベクトルの1つの制限は、1つの型の要素だけを格納できるということです。
リスト8-10では、整数、浮動小数点数、およびテキストを格納する<ruby>場合値<rt>バリアント</rt></ruby>を持つ`SpreadsheetCell`列挙型を定義しました。
これは、各セルに異なる型のデータを格納することができ、セルの行を表すベクトルを保持できることを意味していました。
これは、互換性のある項目が、<ruby>譜面<rt>コード</rt></ruby>の<ruby>製譜<rt>コンパイル</rt></ruby>時にわかっている固定セットの型である場合に、完全に良い解決策です。

しかし、時々、<ruby>譜集<rt>ライブラリー</rt></ruby>利用者は、特定の状況で有効な型のセットを拡張できるようにしたいことがあります。
これをどのように実現するかを示すために、項目のリストを反復し、それぞれを描画するために`draw`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出して、GUI道具の一般的な技法であるグラフィカル利用者<ruby>接点<rt>インターフェース</rt></ruby>（GUI）道具を作成します。
と呼ばれる<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>通い箱<rt>クレート</rt></ruby>作成します`gui` GUI<ruby>譜集<rt>ライブラリー</rt></ruby>の構造が含まれています。
この<ruby>通い箱<rt>クレート</rt></ruby>には、`Button`や`TextField`など、人々が使用するいくつかの型が含まれている場合があり`TextField`。
さらに、`gui`利用者は描画できる独自の型を作成する必要があります。たとえば、1つの<ruby>演譜師<rt>プログラマー</rt></ruby>が`Image`を追加し、別の<ruby>演譜師<rt>プログラマー</rt></ruby>が`SelectBox`追加する`SelectBox`ます。

この例では、本格的なGUI<ruby>譜集<rt>ライブラリー</rt></ruby>ーを実装することはしませんが、どのように組み合わせるかを示します。
<ruby>譜集<rt>ライブラリー</rt></ruby>の作成時には、他の<ruby>演譜師<rt>プログラマー</rt></ruby>が作成したいと思うすべての型を知り、定義することはできません。
しかし、`gui`がさまざまな型の多くの値を追跡する必要があることを知っています。そして、これらの型付けされた値のそれぞれについて`draw`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す必要があります。
`draw`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すときに何が起こるかを正確に知る必要はありません。ただ、その<ruby>操作法<rt>メソッド</rt></ruby>が呼び出し可能な<ruby>操作法<rt>メソッド</rt></ruby>を持つだけです。

継承と言語でこれを行うために、という名前のクラス定義することができます`Component`名前の<ruby>操作法<rt>メソッド</rt></ruby>がある`draw`、その上に。
`Button`、 `Image`、 `SelectBox`などの他のクラスは、`Component`から継承し、`draw`<ruby>操作法<rt>メソッド</rt></ruby>を継承します。
それらはそれぞれ独自のビヘイビアを定義するために`draw`<ruby>操作法<rt>メソッド</rt></ruby>を上書きすることができますが、Frameworkはすべての型を`Component`<ruby>実例<rt>インスタンス</rt></ruby>として扱い、それらを`draw`します。
しかし、Rustには継承がないため、利用者が新しい型で拡張できるように`gui`<ruby>譜集<rt>ライブラリー</rt></ruby>を構築する別の方法が必要です。

### 共通行動のための<ruby>特性<rt>トレイト</rt></ruby>の定義

`gui`に必要な振る舞いを実装するために、`draw`という名前の1つの<ruby>操作法<rt>メソッド</rt></ruby>を持つ`Draw`という名前の`Draw`を定義します。
次に、*trait<ruby>対象<rt>オブジェクト</rt></ruby>*をとるベクトルを定義することができます。
<ruby>特性<rt>トレイト</rt></ruby>対象は、指定した<ruby>特性<rt>トレイト</rt></ruby>を実装する型の<ruby>実例<rt>インスタンス</rt></ruby>を指します。
`&` referenceや`Box<T>`スマート<ruby>指し手<rt>ポインタ</rt></ruby>のような何らかの<ruby>指し手<rt>ポインタ</rt></ruby>を指定し、関連する<ruby>特性<rt>トレイト</rt></ruby>を指定することによって<ruby>特性<rt>トレイト</rt></ruby>対象を作成します。
（<ruby>特性<rt>トレイト</rt></ruby>対象は、19章の「動的にサイズが指定された型とサイズ」の節で<ruby>指し手<rt>ポインタ</rt></ruby>を使用する必要がある理由について話します。）汎用<ruby>対象<rt>オブジェクト</rt></ruby>または具体的な型の代わりに<ruby>特性<rt>トレイト</rt></ruby>対象を使用できます。
Rustの型体系は、<ruby>特性<rt>トレイト</rt></ruby>対象を使用するたびに、<ruby>製譜<rt>コンパイル</rt></ruby>時に、その文脈で使用されるすべての値が<ruby>特性<rt>トレイト</rt></ruby>対象の<ruby>特性<rt>トレイト</rt></ruby>を実装することを保証します。
したがって、<ruby>製譜<rt>コンパイル</rt></ruby>時にすべての型を知る必要はありません。

Rustでは、他の言語の<ruby>対象<rt>オブジェクト</rt></ruby>と区別するために構造体と列挙型を呼び出すことを控えています。
構造体または列挙型では、struct<ruby>欄<rt>フィールド</rt></ruby>のデータと`impl`<ruby>段落<rt>ブロック</rt></ruby>の動作は分離されていますが、他の言語では、データとビヘイビアが1つの概念に結合されて<ruby>対象<rt>オブジェクト</rt></ruby>にラベル付けされることがよくあります。
しかし、<ruby>特性<rt>トレイト</rt></ruby>対象*は*、データと動作を組み合わせる意味で、他の言語の<ruby>対象<rt>オブジェクト</rt></ruby>によく似ています。
しかし、<ruby>特性<rt>トレイト</rt></ruby>対象は、<ruby>特性<rt>トレイト</rt></ruby>対象にデータを追加できないという点で、従来の<ruby>対象<rt>オブジェクト</rt></ruby>とは異なります。
<ruby>特性<rt>トレイト</rt></ruby>対象は、他の言語の<ruby>対象<rt>オブジェクト</rt></ruby>として一般的には有用ではありません。具体的な目的は、共通の動作を超えた抽象化を可能にすることです。

リスト17-3は、`draw`という名前の1つの<ruby>操作法<rt>メソッド</rt></ruby>で`Draw`という名前の<ruby>特性<rt>トレイト</rt></ruby>を定義する方法を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Draw {
    fn draw(&self);
}
```

<span class="caption">リスト17-3。 <code>Draw</code>特性の定義</span>

この構文は、第10章で<ruby>特性<rt>トレイト</rt></ruby>を定義する方法に関する議論から慣れているはずです。次に、新しい構文があります。リスト17-4は、`components`という名前のベクトルを保持する`Screen`という名前の構造体を定義してい`components`。
このベクトルは、型<ruby>対象<rt>オブジェクト</rt></ruby>である`Box<Draw>`型です。
これは、`Draw`<ruby>特性<rt>トレイト</rt></ruby>を実装する`Box`内のあらゆる型のスタンドインです。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub trait Draw {
#     fn draw(&self);
# }
#
pub struct Screen {
    pub components: Vec<Box<Draw>>,
}
```

<span class="caption">リスト17-4。 <code>Draw</code>特性を実装するtrait<ruby>対象<rt>オブジェクト</rt></ruby>のベクトルを保持する<code>components</code>欄を持つ<code>Screen</code>構造体の定義</span>

`Screen`構造体では、`run`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を定義します。この<ruby>操作法<rt>メソッド</rt></ruby>は、リスト17-5に示すように、各`components`で`draw`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub trait Draw {
#     fn draw(&self);
# }
#
# pub struct Screen {
#     pub components: Vec<Box<Draw>>,
# }
#
impl Screen {
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}
```

<span class="caption">リスト17-5。各部品の<code>draw</code>操作法を呼び出す<code>Screen</code>上の<code>run</code>操作法</span>

これは、<ruby>特性<rt>トレイト</rt></ruby>の縛りで総称型のパラメータを使用する構造体を定義する方法とは異なります。
総称型パラメータは、一度に1つの具体的な型にのみ置き換えることができますが、trait<ruby>対象<rt>オブジェクト</rt></ruby>では、実行時に複数の具象型をtrait<ruby>対象<rt>オブジェクト</rt></ruby>に埋め込むことができます。
たとえば、リスト17-6のように総称型と<ruby>特性<rt>トレイト</rt></ruby>束縛を使用して`Screen`構造体を定義できました。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub trait Draw {
#     fn draw(&self);
# }
#
pub struct Screen<T: Draw> {
    pub components: Vec<T>,
}

impl<T> Screen<T>
    where T: Draw {
    pub fn run(&self) {
        for component in self.components.iter() {
            component.draw();
        }
    }
}
```

<span class="caption">リスト17-6。Genericと<ruby>特性<rt>トレイト</rt></ruby>縛りを使った<code>Screen</code>構造体とその<code>run</code>操作法の別の実装</span>

これにより、`Button`型のすべての部品または`TextField`型のすべての部品のリストを持つ`Screen`<ruby>実例<rt>インスタンス</rt></ruby>に制限され`TextField`。
同種の<ruby>集まり<rt>コレクション</rt></ruby>しか持たない場合は、総称化と<ruby>特性<rt>トレイト</rt></ruby>の縛りを使用する方が望ましいです。コンクリート型を使用するために<ruby>製譜<rt>コンパイル</rt></ruby>時に定義が単一化されるからです。

一方、trait<ruby>対象<rt>オブジェクト</rt></ruby>を使用する<ruby>操作法<rt>メソッド</rt></ruby>では、1つの`Screen`<ruby>実例<rt>インスタンス</rt></ruby>は、`Box<Button>`と`Box<TextField>`を含む`Vec<T>`を保持できます。
これがどのように動作するかを見てみましょう。次に実行時パフォーマンスの影響について説明します。

### <ruby>特性<rt>トレイト</rt></ruby>の実装

ここで、`Draw`<ruby>特性<rt>トレイト</rt></ruby>を実装するいくつかの型を追加します。
`Button`型を提供します。
GUI<ruby>譜集<rt>ライブラリー</rt></ruby>を実際に実装することはこの本の範囲を超えているので、`draw`<ruby>操作法<rt>メソッド</rt></ruby>はその本体に便利な実装を持たないでしょう。
実装がどのように見えるかを想像すると、リスト17-7に示すように、`Button`構造体に`width`、 `height`、および`label`<ruby>欄<rt>フィールド</rt></ruby>があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub trait Draw {
#     fn draw(&self);
# }
#
pub struct Button {
    pub width: u32,
    pub height: u32,
    pub label: String,
}

impl Draw for Button {
    fn draw(&self) {
#        // code to actually draw a button
        // ボタンを実際に描画する<ruby>譜面<rt>コード</rt></ruby>
    }
}
```

<span class="caption">リスト17-7。 <code>Draw</code>特性を実装する<code>Button</code>構造体</span>

`Button`の`width`、 `height`、および`label`<ruby>欄<rt>フィールド</rt></ruby>は、`TextField`型など、他の部品の<ruby>欄<rt>フィールド</rt></ruby>とは異なります。これらの<ruby>欄<rt>フィールド</rt></ruby>には、代わりに`placeholder`<ruby>欄<rt>フィールド</rt></ruby>が追加されます。
実装する画面に描画したい種類の各`Draw`<ruby>特性<rt>トレイト</rt></ruby>をしかしに異なる<ruby>譜面<rt>コード</rt></ruby>を使用する`draw`として、その特定の型を描画する方法を定義する方法`Button`ここに持っている範囲を超えており、実際のGUI<ruby>譜面<rt>コード</rt></ruby>なし（この章の）。
たとえば、`Button`型には、利用者がボタンをクリックしたときの処理に関連する<ruby>操作法<rt>メソッド</rt></ruby>を含む`impl`<ruby>段落<rt>ブロック</rt></ruby>が追加されている場合があります。
これらの種類の<ruby>操作法<rt>メソッド</rt></ruby>は、`TextField`ような型には適用されません。

<ruby>譜集<rt>ライブラリー</rt></ruby>を使用している人が、`width`、 `height`、および`options`<ruby>欄<rt>フィールド</rt></ruby>を持つ`SelectBox`構造体を実装することを決定した場合、リスト17-8で示すように、`SelectBox`型の`Draw`<ruby>特性<rt>トレイト</rt></ruby>も実装し`options`。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate gui;
use gui::Draw;

struct SelectBox {
    width: u32,
    height: u32,
    options: Vec<String>,
}

impl Draw for SelectBox {
    fn draw(&self) {
#        // code to actually draw a select box
        // 選択ボックスを実際に描画する<ruby>譜面<rt>コード</rt></ruby>
    }
}
```

<span class="caption">リスト17-8。 <code>SelectBox</code>構造体に<code>gui</code>を使って<code>Draw</code>特性を実装する別の通い箱</span>

<ruby>譜集<rt>ライブラリー</rt></ruby>の利用者は、`Screen`<ruby>実例<rt>インスタンス</rt></ruby>を作成するための`main`機能を書くことができます。
`Screen`<ruby>実例<rt>インスタンス</rt></ruby>に対しては、それぞれを`Box<T>`に配置して`SelectBox`と`Button`追加して、`SelectBox`することができます。
次に、それぞれの部品で`draw`を呼び出す`Screen`<ruby>実例<rt>インスタンス</rt></ruby>で`run`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができます。
リスト17-9にこの実装を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use gui::{Screen, Button};

fn main() {
    let screen = Screen {
        components: vec![
            Box::new(SelectBox {
                width: 75,
                height: 10,
                options: vec![
                    String::from("Yes"),
                    String::from("Maybe"),
                    String::from("No")
                ],
            }),
            Box::new(Button {
                width: 50,
                height: 10,
                label: String::from("OK"),
            }),
        ],
    };

    screen.run();
}
```

<span class="caption">リスト17-9。<ruby>特性<rt>トレイト</rt></ruby>対象を使用して、同じ<ruby>特性<rt>トレイト</rt></ruby>を実装する異なる型の値を格納する</span>

<ruby>譜集<rt>ライブラリー</rt></ruby>を書いたとき、誰かが追加される場合がありますことを知らなかった`SelectBox`種類を、`Screen`実装は、新しい型で動作しているため、それを描くことができた`SelectBox`実装`Draw`、それが実装さを意味し、型を`draw`する方法を。

この概念は、値が具体的な型ではなく応答するメッセージにのみ関係しているということです。これは、動的に型指定された言語での*ダックタイピング*の概念に似てい*ます。アヒルの*ように歩き、アヒルのように倒れた場合、アヒル！　
リスト17-5の`run` on `Screen`実装では、`run`は各部品の具体的な型が何であるかを知る必要はありません。
部品が`Button`か`SelectBox`<ruby>実例<rt>インスタンス</rt></ruby>かどうかはチェックされず、部品の`draw`<ruby>操作法<rt>メソッド</rt></ruby>が呼び出されます。
指定することにより、`Box<Draw>`の値の型として`components`ベクトル、定義した`Screen`、呼び出すことができます値必要に`draw`に方法を。

ダックタイピングを使用して<ruby>譜面<rt>コード</rt></ruby>に似た<ruby>譜面<rt>コード</rt></ruby>を書くために<ruby>特性<rt>トレイト</rt></ruby>対象とRustの型体系を使用する利点は、値が実行時に特定の<ruby>操作法<rt>メソッド</rt></ruby>を実装するかどうかをチェックする必要はなく、とにかくそれを呼びます。
値が<ruby>特性<rt>トレイト</rt></ruby>対象が必要とする<ruby>特性<rt>トレイト</rt></ruby>を実装していない場合、Rustは<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しません。

たとえば、リスト17-10は、`String`を部品として`Screen`を作成しようとするとどうなるかを示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate gui;
use gui::Screen;

fn main() {
    let screen = Screen {
        components: vec![
            Box::new(String::from("Hi")),
        ],
    };

    screen.run();
}
```

<span class="caption">リスト17-10。trait<ruby>対象<rt>オブジェクト</rt></ruby>の<ruby>特性<rt>トレイト</rt></ruby>を実装していない型の使用を試みる</span>

`String`は`Draw`<ruby>特性<rt>トレイト</rt></ruby>を実装していないため、この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0277]: the trait bound `std::string::String: gui::Draw` is not satisfied
  --> src/main.rs:7:13
   |
 7 |             Box::new(String::from("Hi")),
   |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ the trait gui::Draw is not
   implemented for `std::string::String`
   |
   = note: required for the cast to the object type `gui::Draw`
```

この<ruby>誤り<rt>エラー</rt></ruby>は、どちらかして何かを渡していることを知ることができます`Screen`合格するという意味ではありませんでしたし、さまざまな型を渡す必要があるか、実装する必要が`Draw`上で`String`ように`Screen`呼び出すことができるで`draw`ことに。

### <ruby>特性<rt>トレイト</rt></ruby>対象は動的<ruby>指名<rt>ディスパッチ</rt></ruby>を実行する

第10章の「Genericを使用した<ruby>譜面<rt>コード</rt></ruby>のパフォーマンス」の章で、総称化の<ruby>特性<rt>トレイト</rt></ruby>縛りを使用するときに<ruby>製譜器<rt>コンパイラー</rt></ruby>によって実行される単体化過程についての議論を行います。<ruby>製譜器<rt>コンパイラー</rt></ruby>は、使用する具体的な型ごとに、総称型パラメータの
単一形化に起因する<ruby>譜面<rt>コード</rt></ruby>は、<ruby>製譜<rt>コンパイル</rt></ruby>時に呼び出す<ruby>操作法<rt>メソッド</rt></ruby>を<ruby>製譜器<rt>コンパイラー</rt></ruby>が知っているときに*静的な<ruby>指名<rt>ディスパッチ</rt></ruby>を*実行しています。
これは*動的<ruby>指名<rt>ディスパッチ</rt></ruby>*とは対照的です。<ruby>製譜<rt>コンパイル</rt></ruby>時に呼び出す<ruby>操作法<rt>メソッド</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>時に通知できない場合です。
動的<ruby>指名<rt>ディスパッチ</rt></ruby>の場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は実行時に呼び出す<ruby>操作法<rt>メソッド</rt></ruby>を特定する<ruby>譜面<rt>コード</rt></ruby>を発行します。

<ruby>特性<rt>トレイト</rt></ruby>対象を使用する場合、Rustは動的<ruby>指名<rt>ディスパッチ</rt></ruby>を使用する必要があります。
<ruby>製譜器<rt>コンパイラー</rt></ruby>は、trait<ruby>対象<rt>オブジェクト</rt></ruby>を使用している<ruby>譜面<rt>コード</rt></ruby>で使用される可能性があるすべての型を認識しないため、呼び出す型の実装されている<ruby>操作法<rt>メソッド</rt></ruby>がわかりません。
代わりに、実行時に、Rustはtrait<ruby>対象<rt>オブジェクト</rt></ruby>内の<ruby>指し手<rt>ポインタ</rt></ruby>を使用して、呼び出す<ruby>操作法<rt>メソッド</rt></ruby>を知ります。
静的<ruby>指名<rt>ディスパッチ</rt></ruby>では発生しないこのルックアップが発生すると、実行時コストが発生します。
動的<ruby>指名<rt>ディスパッチ</rt></ruby>はまた、<ruby>製譜器<rt>コンパイラー</rt></ruby>が<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>を入行化することを選択できないようにします。これにより、いくつかの最適化が妨げられます。
しかし、リスト17-5で書いた<ruby>譜面<rt>コード</rt></ruby>では柔軟性があり、リスト17-9でサポートすることができたので、考慮する必要はありません。

### <ruby>特性<rt>トレイト</rt></ruby>対象には<ruby>対象<rt>オブジェクト</rt></ruby>の安全性が必要です

*<ruby>対象<rt>オブジェクト</rt></ruby>化安全な*<ruby>特性<rt>トレイト</rt></ruby>は、<ruby>特性<rt>トレイト</rt></ruby>対象にのみ作成できます。
複雑なルールの中には、<ruby>特性<rt>トレイト</rt></ruby>対象を安全にするすべてのプロパティを管理するものがありますが、実際には2つのルールのみが適切です。
<ruby>特性<rt>トレイト</rt></ruby>に定義されているすべての<ruby>操作法<rt>メソッド</rt></ruby>が次のプロパティを持つ場合、<ruby>特性<rt>トレイト</rt></ruby>は<ruby>対象<rt>オブジェクト</rt></ruby>化安全です。

* 戻り値の型は`Self`はありません。
* 総称型パラメータはありません。

`Self`予約語は、<ruby>特性<rt>トレイト</rt></ruby>や<ruby>操作法<rt>メソッド</rt></ruby>を実装する型の<ruby>別名<rt>エイリアス</rt></ruby>です。
<ruby>特性<rt>トレイト</rt></ruby>対象を使用すると、Rustはその<ruby>特性<rt>トレイト</rt></ruby>を実装している具体的な型を認識していないため、<ruby>特性<rt>トレイト</rt></ruby>対象は<ruby>対象<rt>オブジェクト</rt></ruby>化安全でなければなりません。
trait<ruby>操作法<rt>メソッド</rt></ruby>が具体的な`Self`型を返すが、Trait<ruby>対象<rt>オブジェクト</rt></ruby>が`Self`と同じ型を忘れた場合、<ruby>操作法<rt>メソッド</rt></ruby>が元の具象型を使用する方法はありません。
これは、<ruby>特性<rt>トレイト</rt></ruby>が使用されるときに具体的な型パラメータで埋められる総称型のパラメータにも当てはまります。具体的な型は、その型を実装する型の一部になります。
型<ruby>対象<rt>オブジェクト</rt></ruby>を使用して型を忘れると、汎用型のパラメータでどの型を埋めるべきかを知る方法がありません。

<ruby>操作法<rt>メソッド</rt></ruby>が<ruby>対象<rt>オブジェクト</rt></ruby>化安全ではない<ruby>特性<rt>トレイト</rt></ruby>の例は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`Clone`<ruby>特性<rt>トレイト</rt></ruby>です。
`Clone`<ruby>特性<rt>トレイト</rt></ruby>の`clone`<ruby>操作法<rt>メソッド</rt></ruby>の型注釈は次のようになります。

```rust
pub trait Clone {
    fn clone(&self) -> Self;
}
```

`String`型が実装`Clone`<ruby>特性<rt>トレイト</rt></ruby>を、そして呼ぶとき`clone`の<ruby>実例<rt>インスタンス</rt></ruby>で<ruby>操作法<rt>メソッド</rt></ruby>を`String`バックの<ruby>実例<rt>インスタンス</rt></ruby>を取得`String`。
呼ぶならば同様に、`clone`の<ruby>実例<rt>インスタンス</rt></ruby>に`Vec<T>`戻っての<ruby>実例<rt>インスタンス</rt></ruby>を取得`Vec<T>`。
`clone`の型注釈は、戻り値の型であるため、`Self`にどの型が含まれるかを知る必要があります。

<ruby>製譜器<rt>コンパイラー</rt></ruby>は、<ruby>特性<rt>トレイト</rt></ruby>対象に関して<ruby>対象<rt>オブジェクト</rt></ruby>の安全性のルールに違反する何かをしようとしているときにそれを表示します。
たとえば、リスト17-4の`Screen`構造体を実装して、`Draw`<ruby>特性<rt>トレイト</rt></ruby>の代わりに`Clone`<ruby>特性<rt>トレイト</rt></ruby>を実装する型を保持しようとしたとしましょう。

```rust,ignore
pub struct Screen {
    pub components: Vec<Box<Clone>>,
}
```

この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0038]: the trait `std::clone::Clone` cannot be made into an object
 --> src/lib.rs:2:5
  |
2 |     pub components: Vec<Box<Clone>>,
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ the trait `std::clone::Clone` cannot be
made into an object
  |
  = note: the trait cannot require that `Self : Sized`
```

この<ruby>誤り<rt>エラー</rt></ruby>は、この方法でこの<ruby>特性<rt>トレイト</rt></ruby>を<ruby>特性<rt>トレイト</rt></ruby>対象として使用できないことを意味します。
<ruby>対象<rt>オブジェクト</rt></ruby>の安全性の詳細については、[Rust RFC 255]参照してください。

[Rust RFC 255]: https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md
