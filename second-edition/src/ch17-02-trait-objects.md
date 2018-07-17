## 異なる型の値を許容する特性対象の使用

第8章では、ベクトルの1つの制限は、1つの型の要素だけを格納できるということです。
リスト8-10では、整数、浮動小数点数、およびテキストを格納する場合値を持つ`SpreadsheetCell`列挙型を定義しました。
これは、各セルに異なる型のデータを格納することができ、セルの行を表すベクトルを保持できることを意味していました。
これは、互換性のある項目が、譜面の製譜時にわかっている固定セットの型である場合に、完全に良い解決策です。

しかし、時々、譜集利用者は、特定の状況で有効な型のセットを拡張できるようにしたいことがあります。
これをどのように実現するかを示すために、項目のリストを反復し、それぞれを描画するために`draw`操作法を呼び出して、GUI道具の一般的な技法であるグラフィカル利用者接点（GUI）道具を作成します。
と呼ばれる譜集の通い箱作成します`gui` GUI譜集の構造が含まれています。
この通い箱には、`Button`や`TextField`など、人々が使用するいくつかの型が含まれている場合があり`TextField`。
さらに、`gui`利用者は描画できる独自の型を作成する必要があります。たとえば、1つの演譜師が`Image`を追加し、別の演譜師が`SelectBox`追加する`SelectBox`ます。

この例では、本格的なGUI譜集ーを実装することはしませんが、どのように組み合わせるかを示します。
譜集の作成時には、他の演譜師が作成したいと思うすべての型を知り、定義することはできません。
しかし、`gui`がさまざまな型の多くの値を追跡する必要があることを知っています。そして、これらの型付けされた値のそれぞれについて`draw`操作法を呼び出す必要があります。
`draw`操作法を呼び出すときに何が起こるかを正確に知る必要はありません。ただ、その操作法が呼び出し可能な操作法を持つだけです。

継承と言語でこれを行うために、という名前のクラス定義することができます`Component`名前の操作法がある`draw`、その上に。
`Button`、 `Image`、 `SelectBox`などの他のクラスは、`Component`から継承し、`draw`操作法を継承します。
それらはそれぞれ独自のビヘイビアを定義するために`draw`操作法を上書きすることができますが、Frameworkはすべての型を`Component`実例として扱い、それらを`draw`します。
しかし、Rustには継承がないため、利用者が新しい型で拡張できるように`gui`譜集を構築する別の方法が必要です。

### 共通行動のための特性の定義

`gui`に必要な振る舞いを実装するために、`draw`という名前の1つの操作法を持つ`Draw`という名前の`Draw`を定義します。
次に、*trait対象*をとるベクトルを定義することができます。
特性対象は、指定した特性を実装する型の実例を指します。
`&` referenceや`Box<T>`スマート指し手のような何らかの指し手を指定し、関連する特性を指定することによって特性対象を作成します。
（特性対象は、19章の「動的にサイズが指定された型とサイズ」の節で指し手を使用する必要がある理由について話します。）汎用対象または具体的な型の代わりに特性対象を使用できます。
Rustの型算系は、特性対象を使用するたびに、製譜時に、その文脈で使用されるすべての値が特性対象の特性を実装することを保証します。
したがって、製譜時にすべての型を知る必要はありません。

Rustでは、他の言語の対象と区別するために構造体と列挙型を呼び出すことを控えています。
構造体または列挙型では、struct欄のデータと`impl`段落の動作は分離されていますが、他の言語では、データとビヘイビアが1つの概念に結合されて対象にラベル付けされることがよくあります。
しかし、特性対象*は*、データと動作を組み合わせる意味で、他の言語の対象によく似ています。
しかし、特性対象は、特性対象にデータを追加できないという点で、従来の対象とは異なります。
特性対象は、他の言語の対象として一般的には有用ではありません。具体的な目的は、共通の動作を超えた抽象化を可能にすることです。

リスト17-3は、`draw`という名前の1つの操作法で`Draw`という名前の特性を定義する方法を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Draw {
    fn draw(&self);
}
```

<span class="caption">リスト17-3。 <code>Draw</code>特性の定義</span>

この構文は、第10章で特性を定義する方法に関する議論から慣れているはずです。次に、新しい構文があります。リスト17-4は、`components`という名前のベクトルを保持する`Screen`という名前の構造体を定義してい`components`。
このベクトルは、型対象である`Box<Draw>`型です。
これは、`Draw`特性を実装する`Box`内のあらゆる型のスタンドインです。

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

<span class="caption">リスト17-4。 <code>Draw</code>特性を実装するtrait対象のベクトルを保持する<code>components</code>欄を持つ<code>Screen</code>構造体の定義</span>

`Screen`構造体では、`run`という名前の操作法を定義します。この操作法は、リスト17-5に示すように、各`components`で`draw`操作法を呼び出します。

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

これは、特性の縛りで総称型のパラメータを使用する構造体を定義する方法とは異なります。
総称型パラメータは、一度に1つの具体的な型にのみ置き換えることができますが、trait対象では、実行時に複数の具象型をtrait対象に埋め込むことができます。
たとえば、リスト17-6のように総称型と特性束縛を使用して`Screen`構造体を定義できました。

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

<span class="caption">リスト17-6。Genericと特性縛りを使った<code>Screen</code>構造体とその<code>run</code>操作法の別の実装</span>

これにより、`Button`型のすべての部品または`TextField`型のすべての部品のリストを持つ`Screen`実例に制限され`TextField`。
同種の集まりしか持たない場合は、総称化と特性の縛りを使用する方が望ましいです。コンクリート型を使用するために製譜時に定義が単一化されるからです。

一方、trait対象を使用する操作法では、1つの`Screen`実例は、`Box<Button>`と`Box<TextField>`を含む`Vec<T>`を保持できます。
これがどのように動作するかを見てみましょう。次に実行時パフォーマンスの影響について説明します。

### 特性の実装

ここで、`Draw`特性を実装するいくつかの型を追加します。
`Button`型を提供します。
GUI譜集を実際に実装することはこの本の範囲を超えているので、`draw`操作法はその本体に便利な実装を持たないでしょう。
実装がどのように見えるかを想像すると、リスト17-7に示すように、`Button`構造体に`width`、 `height`、および`label`欄があります。

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
        // ボタンを実際に描画する譜面
    }
}
```

<span class="caption">リスト17-7。 <code>Draw</code>特性を実装する<code>Button</code>構造体</span>

`Button`の`width`、 `height`、および`label`欄は、`TextField`型など、他の部品の欄とは異なります。これらの欄には、代わりに`placeholder`欄が追加されます。
実装する画面に描画したい種類の各`Draw`特性をしかしに異なる譜面を使用する`draw`として、その特定の型を描画する方法を定義する方法`Button`ここに持っている範囲を超えており、実際のGUI譜面なし（この章の）。
たとえば、`Button`型には、利用者がボタンをクリックしたときの処理に関連する操作法を含む`impl`段落が追加されている場合があります。
これらの種類の操作法は、`TextField`ような型には適用されません。

譜集を使用している人が、`width`、 `height`、および`options`欄を持つ`SelectBox`構造体を実装することを決定した場合、リスト17-8で示すように、`SelectBox`型の`Draw`特性も実装し`options`。

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
        // 選択ボックスを実際に描画する譜面
    }
}
```

<span class="caption">リスト17-8。 <code>SelectBox</code>構造体に<code>gui</code>を使って<code>Draw</code>特性を実装する別の通い箱</span>

譜集の利用者は、`Screen`実例を作成するための`main`機能を書くことができます。
`Screen`実例に対しては、それぞれを`Box<T>`に配置して`SelectBox`と`Button`追加して、`SelectBox`することができます。
次に、それぞれの部品で`draw`を呼び出す`Screen`実例で`run`操作法を呼び出すことができます。
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

<span class="caption">リスト17-9。特性対象を使用して、同じ特性を実装する異なる型の値を格納する</span>

譜集を書いたとき、誰かが追加される場合がありますことを知らなかった`SelectBox`種類を、`Screen`実装は、新しい型で動作しているため、それを描くことができた`SelectBox`実装`Draw`、それが実装さを意味し、型を`draw`する方法を。

この概念は、値が具体的な型ではなく応答するメッセージにのみ関係しているということです。これは、動的に型指定された言語での*ダックタイピング*の概念に似てい*ます。アヒルの*ように歩き、アヒルのように倒れた場合、アヒル！　
リスト17-5の`run` on `Screen`実装では、`run`は各部品の具体的な型が何であるかを知る必要はありません。
部品が`Button`か`SelectBox`実例かどうかはチェックされず、部品の`draw`操作法が呼び出されます。
指定することにより、`Box<Draw>`の値の型として`components`ベクトル、定義した`Screen`、呼び出すことができます値必要に`draw`に方法を。

ダックタイピングを使用して譜面に似た譜面を書くために特性対象とRustの型算系を使用する利点は、値が実行時に特定の操作法を実装するかどうかをチェックする必要はなく、とにかくそれを呼びます。
値が特性対象が必要とする特性を実装していない場合、Rustは譜面を製譜しません。

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

<span class="caption">リスト17-10。trait対象の特性を実装していない型の使用を試みる</span>

`String`は`Draw`特性を実装していないため、この誤りが発生します。

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

この誤りは、どちらかして何かを渡していることを知ることができます`Screen`合格するという意味ではありませんでしたし、さまざまな型を渡す必要があるか、実装する必要が`Draw`上で`String`ように`Screen`呼び出すことができるで`draw`ことに。

### 特性対象は動的指名を実行する

第10章の「Genericを使用した譜面のパフォーマンス」の章で、総称化の特性縛りを使用するときに製譜器によって実行される単体化過程についての議論を行います。製譜器は、使用する具体的な型ごとに、総称型パラメータの
単一形化に起因する譜面は、製譜時に呼び出す操作法を製譜器が知っているときに*静的な指名を*実行しています。
これは*動的指名*とは対照的です。製譜時に呼び出す操作法を製譜時に通知できない場合です。
動的指名の場合、製譜器は実行時に呼び出す操作法を特定する譜面を発行します。

特性対象を使用する場合、Rustは動的指名を使用する必要があります。
製譜器は、trait対象を使用している譜面で使用される可能性があるすべての型を認識しないため、呼び出す型の実装されている操作法がわかりません。
代わりに、実行時に、Rustはtrait対象内の指し手を使用して、呼び出す操作法を知ります。
静的指名では発生しないこのルックアップが発生すると、実行時コストが発生します。
動的指名はまた、製譜器が操作法の譜面をイン行化することを選択できないようにします。これにより、いくつかの最適化が妨げられます。
しかし、リスト17-5で書いた譜面では柔軟性があり、リスト17-9でサポートすることができたので、考慮する必要はありません。

### 特性対象には対象の安全性が必要です

*対象化安全な*特性は、特性対象にのみ作成できます。
複雑なルールの中には、特性対象を安全にするすべてのプロパティを管理するものがありますが、実際には2つのルールのみが適切です。
特性に定義されているすべての操作法が次のプロパティを持つ場合、特性は対象化安全です。

* 戻り値の型は`Self`はありません。
* 総称型パラメータはありません。

`Self`予約語は、特性や操作法を実装する型の別名です。
特性対象を使用すると、Rustはその特性を実装している具体的な型を認識していないため、特性対象は対象化安全でなければなりません。
trait操作法が具体的な`Self`型を返すが、Trait対象が`Self`と同じ型を忘れた場合、操作法が元の具象型を使用する方法はありません。
これは、特性が使用されるときに具体的な型パラメータで埋められる総称型のパラメータにも当てはまります。具体的な型は、その型を実装する型の一部になります。
型対象を使用して型を忘れると、汎用型のパラメータでどの型を埋めるべきかを知る方法がありません。

操作法が対象化安全ではない特性の例は、標準譜集の`Clone`特性です。
`Clone`特性の`clone`操作法の型指示は次のようになります。

```rust
pub trait Clone {
    fn clone(&self) -> Self;
}
```

`String`型が実装`Clone`特性を、そして呼ぶとき`clone`の実例で操作法を`String`バックの実例を取得`String`。
呼ぶならば同様に、`clone`の実例に`Vec<T>`戻っての実例を取得`Vec<T>`。
`clone`の型指示は、戻り値の型であるため、`Self`にどの型が含まれるかを知る必要があります。

製譜器は、特性対象に関して対象の安全性のルールに違反する何かをしようとしているときにそれを表示します。
たとえば、リスト17-4の`Screen`構造体を実装して、`Draw`特性の代わりに`Clone`特性を実装する型を保持しようとしたとしましょう。

```rust,ignore
pub struct Screen {
    pub components: Vec<Box<Clone>>,
}
```

この誤りが発生します。

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

この誤りは、この方法でこの特性を特性対象として使用できないことを意味します。
対象の安全性の詳細については、[Rust RFC 255]参照してください。

[Rust RFC 255]: https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md
