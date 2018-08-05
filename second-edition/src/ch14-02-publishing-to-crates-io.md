## <ruby>通い箱<rt>クレート</rt></ruby>をCrates.ioに<ruby>公開<rt>パブリック</rt></ruby>する

[crates.io](https://crates.io)パッケージを使用し[crates.io](https://crates.io)
 企画の依存として、あなた自身のパッケージを<ruby>公開<rt>パブリック</rt></ruby>して、他の人と<ruby>譜面<rt>コード</rt></ruby>を共有することもできます。
[crates.io](https://crates.io)の通い箱<ruby>登記簿<rt>レジストリ</rt></ruby>
 パッケージの原譜を配布するので、主に<ruby>公開<rt>パブリック</rt></ruby>原譜の<ruby>譜面<rt>コード</rt></ruby>をホストします。

RustとCargoには、<ruby>公開<rt>パブリック</rt></ruby>されたパッケージを人々が使いやすく見つけやすくするための機能があります。
これらの機能のいくつかについて次に説明し、次にパッケージを<ruby>公開<rt>パブリック</rt></ruby>する方法を説明します。

### 役に立つ開発資料の<ruby>注釈<rt>コメント</rt></ruby>を作る

パッケージを正確に文書化することで、他の利用者がいつ、どのように使用するのかを知ることができますので、時間をかけて文書を書く価値があります。
第3章では、2つのスラッシュを使ってRust<ruby>譜面<rt>コード</rt></ruby>を<ruby>注釈<rt>コメント</rt></ruby>する方法について説明しました`//`。
Rustには、HTML開発資料を生成する*開発資料集<ruby>注釈<rt>コメント</rt></ruby>*として便利な、開発資料に関する特別な種類の<ruby>注釈<rt>コメント</rt></ruby>もあります。
HTMLには、<ruby>通い箱<rt>クレート</rt></ruby>の*実装*方法とは対照的に、<ruby>通い箱<rt>クレート</rt></ruby>の*使用*方法を知りたい<ruby>演譜師<rt>プログラマー</rt></ruby>向けの<ruby>公開<rt>パブリック</rt></ruby>API項目の開発資料<ruby>注釈<rt>コメント</rt></ruby>の内容が表示されます。

開発資料<ruby>注釈<rt>コメント</rt></ruby>では、2つの代わりに3つのスラッシュ（`///`使用し、テキストの書式設定のためのMarkdown表記をサポートしています。
文書化している項目の直前に文書の<ruby>注釈<rt>コメント</rt></ruby>を置いてください。
リスト14-1はのための開発資料集<ruby>注釈<rt>コメント</rt></ruby>を示し`add_one`<ruby>通い箱<rt>クレート</rt></ruby>という名前で機能`my_crate`。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
#///// Adds one to the number given.
/// 与えられた数に1を加えます。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// let five = 5;
///  5 = 5とします。
///
#///// assert_eq!(6, my_crate::add_one(5));
///  assert_eq！　（6、my_crate:: add_one（5））;
#///// ```
///  `` ``
pub fn add_one(x: i32) -> i32 {
    x + 1
}
```

<span class="caption">リスト14-1。機能の開発資料注釈</span>

ここでは、何の記述与える`add_one`機能は、見出しと章開始しない`Examples`、次に使用する方法を示す<ruby>譜面<rt>コード</rt></ruby>を提供`add_one`機能を。
`cargo doc`実行することによって、この開発資料<ruby>注釈<rt>コメント</rt></ruby>からHTML開発資料を生成することができます。
この命令は、Rustと一緒に配布されている`rustdoc`道具を実行し、生成されたHTML開発資料を*target/doc*ディレクトリに置きます。

便宜上、`cargo doc --open` -openは現在の<ruby>通い箱<rt>クレート</rt></ruby>の文書（<ruby>通い箱<rt>クレート</rt></ruby>のすべての依存物に関する文書）用のHTMLを作成し、その結果をWebブラウザで開きます。
`add_one`機能に`add_one`すると、図14-1に示すように、開発資料<ruby>注釈<rt>コメント</rt></ruby>内のテキストがどのように表示されるかがわかります。

<img src="img/trpl14-01.png" alt="`my_crate`の` add_one`機能のためのHTML文書の<ruby>描出<rt>レンダリング</rt></ruby>" class="center" />
<span class="caption">図14-1。 <code>add_one</code>機能のHTML開発資料</span>

#### よく使われる章

使用`# Examples`値下げは、題名とHTML内の章を作成するには、リスト14-1に向かう。ここ<ruby>通い箱<rt>クレート</rt></ruby>の作者は、一般的に自分の開発資料で使用するいくつかの他の部分である「例」を。

* **パニック**。文書化されている機能がパニックに陥る可能性のある場合。
   <ruby>算譜<rt>プログラム</rt></ruby>のパニックを望まない機能の呼び出し側は、これらの状況で機能を呼び出さないようにする必要があります。
* **<ruby>誤り<rt>エラー</rt></ruby>**。機能が`Result`返す場合、発生する可能性のある<ruby>誤り<rt>エラー</rt></ruby>の種類と、その<ruby>誤り<rt>エラー</rt></ruby>が返される条件を記述することで、さまざまな種類の<ruby>誤り<rt>エラー</rt></ruby>を処理する<ruby>譜面<rt>コード</rt></ruby>をさまざまな方法で記述できるようになります。
* **安全性**。機能が`unsafe`場合（第19章で`unsafe`は`unsafe`ことを議論する）、機能が安全でない理由を説明し、機能が呼び出し側が維持しようとする不変量をカバーする章が存在するはずです。

ほとんどの開発資料集<ruby>注釈<rt>コメント</rt></ruby>はこれらの章のすべてを必要としませんが、<ruby>譜面<rt>コード</rt></ruby>を呼び出す人々が知りたいと思う<ruby>譜面<rt>コード</rt></ruby>の面を思い出させる良いチェックリストです。

#### テストとしての開発資料集<ruby>注釈<rt>コメント</rt></ruby>

開発資料集<ruby>注釈<rt>コメント</rt></ruby>に<ruby>譜面<rt>コード</rt></ruby>例ブ​​ロックを追加すると、<ruby>譜集<rt>ライブラリー</rt></ruby>の使用方法を示すのに役立ちます。そうすることで、追加のボーナスが得られます。実行中の`cargo test`は、開発資料集の<ruby>譜面<rt>コード</rt></ruby>例をテストとして実行します。
例を持つ文書より優れているものはありません。
しかし、開発資料が書かれてから<ruby>譜面<rt>コード</rt></ruby>が変更されたため、動作しない例よりも悪いものはありません。
リスト14-1の`add_one`機能の開発資料で`cargo test`を実行すると、次のようなテスト結果の章が表示されます。

```text
   Doc-tests my_crate

running 1 test
test src/lib.rs - add_one (line 5) ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

ここで、機能または例を変更して、例のパニックで`assert_eq!`再度実行し、`cargo test`再度実行すると、サンプルと<ruby>譜面<rt>コード</rt></ruby>が互いに同期していないことが開発資料テストで分かります。

#### 含まれている項目の<ruby>注釈<rt>コメント</rt></ruby>

開発資料<ruby>注釈<rt>コメント</rt></ruby>の別の作法`//!`は、<ruby>注釈<rt>コメント</rt></ruby>に続く項目に開発資料を追加するのではなく、<ruby>注釈<rt>コメント</rt></ruby>を含む項目に開発資料を追加します。
通常、*crate*ルートファイル（慣習的に*src/lib.rs*） *内また*はこれらの開発資料の<ruby>注釈<rt>コメント</rt></ruby>を<ruby>役区<rt>モジュール</rt></ruby>全体で使用して、<ruby>通い箱<rt>クレート</rt></ruby>または<ruby>役区<rt>モジュール</rt></ruby>全体を文書化します。

たとえば、`add_one`機能を含む`my_crate`の目的を記述した開発資料を追加したい場合は、*src/lib.rs*ファイルの先頭に`//!`で始まる開発資料<ruby>注釈<rt>コメント</rt></ruby>を追加することができます14-2。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
//! # My Crate
//!
//! `my_crate` is a collection of utilities to make performing certain
//! calculations more convenient.

#///// Adds one to the number given.
/// 与えられた数に1を加えます。
#// --snip--
//  --snip--
```

<span class="caption">リスト14-2。 <code>my_crate</code>通い箱全体の開発資料</span>

`//!`で始まる最後の行の後に<ruby>譜面<rt>コード</rt></ruby>がないことに注意してください。
`///`ではなく`//!`を使用して<ruby>注釈<rt>コメント</rt></ruby>を開始したので、この<ruby>注釈<rt>コメント</rt></ruby>の後に続く項目ではなく、この<ruby>注釈<rt>コメント</rt></ruby>を含む項目を文書化しています。
この場合、この<ruby>注釈<rt>コメント</rt></ruby>を含む項目は*src/lib.rs*ファイルであり、これは<ruby>通い箱<rt>クレート</rt></ruby>ルートです。
これらの<ruby>注釈<rt>コメント</rt></ruby>は<ruby>通い箱<rt>クレート</rt></ruby>全体を記述します。

`cargo doc --open`を実行すると、これらの<ruby>注釈<rt>コメント</rt></ruby>は、図14-2に示すように、<ruby>通い箱<rt>クレート</rt></ruby>内の<ruby>公開<rt>パブリック</rt></ruby>項目のリストの上にある`my_crate`の開発資料のフロントページに表示されます。

<img src="img/trpl14-02.png" alt="<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>注釈<rt>コメント</rt></ruby>全体をHTML形式で表示" class="center" />
<span class="caption">図14-2。 <code>my_crate</code>描出された開発資料。<ruby>通い箱<rt>クレート</rt></ruby>全体を説明する<ruby>注釈<rt>コメント</rt></ruby>を含む</span>

項目内の開発資料集<ruby>注釈<rt>コメント</rt></ruby>は、特に<ruby>通い箱<rt>クレート</rt></ruby>や<ruby>役区<rt>モジュール</rt></ruby>の説明に役立ちます。
これらを使用して、コンテナの全体的な目的を説明し、利用者が<ruby>通い箱<rt>クレート</rt></ruby>の組織を理解するのを助けます。

### `pub use`した便利な<ruby>公開<rt>パブリック</rt></ruby>APIの<ruby>輸出<rt>エクスポート</rt></ruby>

第7章では、`mod`予約語を使用して<ruby>譜面<rt>コード</rt></ruby>を<ruby>役区<rt>モジュール</rt></ruby>に編成する方法、`pub`予約語を使用して項目を<ruby>公開<rt>パブリック</rt></ruby>にする方法、`use`予約語を`use`して項目を<ruby>有効範囲<rt>スコープ</rt></ruby>に持ち込む方法について説明しました。
しかし、<ruby>通い箱<rt>クレート</rt></ruby>を開発している間にあなたに合った構造は、利用者にはあまり便利でないかもしれません。
構造体を複数の段階を含む階層に編成することもできますが、階層の中で深く定義した型を使用したい人は、その型が存在するかどうかを調べるのが難しいかもしれません。
それらは、`my_crate::some_module::another_module::UsefulType;` `use`しなければならないことに腹を`my_crate::some_module::another_module::UsefulType;`かもしれ`my_crate::some_module::another_module::UsefulType;`
`my_crate::UsefulType;` `use`ではなく`my_crate::UsefulType;`
。

<ruby>公開<rt>パブリック</rt></ruby>APIの構造は、<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>する際の主な考慮事項です。
<ruby>通い箱<rt>クレート</rt></ruby>を使用する人はものより構造にあまり精通しておらず、<ruby>通い箱<rt>クレート</rt></ruby>が大きな<ruby>役区<rt>モジュール</rt></ruby>階層を持っている場合、使用したい部分を見つけるのが難しいかもしれません。

良いことは、他の<ruby>譜集<rt>ライブラリー</rt></ruby>から他の<ruby>譜集<rt>ライブラリー</rt></ruby>で使用するのに構造*が*便利で*ない*場合、内部組織を再編成する必要はなく、項目を再<ruby>輸出<rt>エクスポート</rt></ruby>して私的な構造とは異なる<ruby>公開<rt>パブリック</rt></ruby>構造にすることができるということです`pub use`によって。
再<ruby>輸出<rt>エクスポート</rt></ruby>では、ある場所で<ruby>公開<rt>パブリック</rt></ruby>項目が使用され、別の場所で定義されているかのように、<ruby>公開<rt>パブリック</rt></ruby>項目が別の場所に<ruby>公開<rt>パブリック</rt></ruby>されます。

たとえば、`art`という概念をモデリングするために`art`という名前の<ruby>譜集<rt>ライブラリー</rt></ruby>を作成したとします。
この<ruby>譜集<rt>ライブラリー</rt></ruby>には、リスト14-3に示すように、`PrimaryColor`と`SecondaryColor` 2つの列挙型を含む`kinds`<ruby>役区<rt>モジュール</rt></ruby>と、`mix`という名前の機能を含む`utils`<ruby>役区<rt>モジュール</rt></ruby>があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
//! # Art
//!
//! A library for modeling artistic concepts.

pub mod kinds {
#//    /// The primary colors according to the RYB color model.
    ///  RYBカラー模型による原色。
    pub enum PrimaryColor {
        Red,
        Yellow,
        Blue,
    }

#//    /// The secondary colors according to the RYB color model.
    /// 二次色はRYBカラー模型に従う。
    pub enum SecondaryColor {
        Orange,
        Green,
        Purple,
    }
}

pub mod utils {
    use kinds::*;

#//    /// Combines two primary colors in equal amounts to create
    ///  2つの原色を同じ量で結合して作成します。
#//    /// a secondary color.
    /// 二次色。
    pub fn mix(c1: PrimaryColor, c2: PrimaryColor) -> SecondaryColor {
#        // --snip--
        //  --snip--
    }
}
```

<span class="caption">リスト14-3。 <code>art</code>に編成項目で譜集<code>kinds</code>と<code>utils</code>役区</span>

図14-3に、`cargo doc`によって生成されたこの<ruby>通い箱<rt>クレート</rt></ruby>の開発資料の最初のページを示します。

<img src="img/trpl14-03.png" alt="`kind`<ruby>役区<rt>モジュール</rt></ruby>と` utils`<ruby>役区<rt>モジュール</rt></ruby>をリストアップした `art`<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>描出<rt>レンダリング</rt></ruby>された開発資料" class="center" />
<span class="caption">図14-3。 <code>kinds</code>と<code>utils</code>役区をリストアップした<code>art</code>の開発資料のフロントページ</span>

`PrimaryColor`と`SecondaryColor`型はフロントページにもリストされていませんし、`mix`機能もありません。
それらを見るために`kinds`と`utils`をクリックしなければなりません。

この<ruby>譜集<rt>ライブラリー</rt></ruby>に依存する別の<ruby>通い箱<rt>クレート</rt></ruby>には、現在定義されている<ruby>役区<rt>モジュール</rt></ruby>構造を指定して、`art`から項目を<ruby>輸入<rt>インポート</rt></ruby>する`use`文が必要です。
リスト14-4は、`PrimaryColor`を使用し、`art`<ruby>通い箱<rt>クレート</rt></ruby>の項目を`mix`する<ruby>通い箱<rt>クレート</rt></ruby>の例を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate art;

use art::kinds::PrimaryColor;
use art::utils::mix;

fn main() {
    let red = PrimaryColor::Red;
    let yellow = PrimaryColor::Yellow;
    mix(red, yellow);
}
```

<span class="caption">リスト14-4。内部構造が<ruby>輸出<rt>エクスポート</rt></ruby>された<code>art</code>通い箱の項目を使用する通い箱</span>

使用して、リスト14-4の<ruby>譜面<rt>コード</rt></ruby>の作者`art`<ruby>通い箱<rt>クレート</rt></ruby>は、ということを理解しなければならなかった`PrimaryColor`である`kinds`の<ruby>役区<rt>モジュール</rt></ruby>と`mix`している`utils`<ruby>役区<rt>モジュール</rt></ruby>。
<ruby>役区<rt>モジュール</rt></ruby>構造`art`<ruby>通い箱<rt>クレート</rt></ruby>は、に取り組んで開発者により関連性のある`art`よりも使用して開発者に<ruby>通い箱<rt>クレート</rt></ruby>`art`<ruby>通い箱<rt>クレート</rt></ruby>を。
<ruby>通い箱<rt>クレート</rt></ruby>の一部を`kinds`<ruby>役区<rt>モジュール</rt></ruby>と`utils`<ruby>役区<rt>モジュール</rt></ruby>に編成する内部構造には、`art`<ruby>通い箱<rt>クレート</rt></ruby>の使用方法を理解しようとする人にとって有用な情報は含まれていません。
その代わりに、`art`<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>役区<rt>モジュール</rt></ruby>構造は混乱を招く。なぜなら、開発者はどこから見ているか把握しなければならず、開発者は`use`文に<ruby>役区<rt>モジュール</rt></ruby>名を指定しなければならないため、構造が不便であます。

<ruby>公開<rt>パブリック</rt></ruby>APIから内部組織を削除するには、<ruby>譜面<rt>コード</rt></ruby>リスト14-3の`art`<ruby>通い箱<rt>クレート</rt></ruby>・<ruby>譜面<rt>コード</rt></ruby>を変更して、リスト14-5に示すように、`pub use`文を追加して項目を最上位で再<ruby>輸出<rt>エクスポート</rt></ruby>することができます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
//! # Art
//!
//! A library for modeling artistic concepts.

pub use kinds::PrimaryColor;
pub use kinds::SecondaryColor;
pub use utils::mix;

pub mod kinds {
#    // --snip--
    //  --snip--
}

pub mod utils {
#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト14-5。項目を再<ruby>輸出<rt>エクスポート</rt></ruby>する<code>pub use</code>文の追加</span>

この<ruby>通い箱<rt>クレート</rt></ruby>用に`cargo doc`生成するAPI開発資料は、図14-4に示すように、フロントページに再<ruby>輸出<rt>エクスポート</rt></ruby>をリストして結合するようになり、`PrimaryColor`および`SecondaryColor`型と`mix`機能を簡単に見つけることができます。

<img src="img/trpl14-04.png" alt="フロントページに再<ruby>輸出<rt>エクスポート</rt></ruby>した「アート」枠の開発資料を<ruby>描出<rt>レンダリング</rt></ruby>しました。" class="center" />
<span class="caption">図14-4。再<ruby>輸出<rt>エクスポート</rt></ruby>を記載した<code>art</code>ための開発資料集の最初のページ</span>

リスト14-4に示すように、`art`<ruby>通い箱<rt>クレート</rt></ruby>利用者はリスト14-3の内部構造を見たり使用したりすることができます。リスト14-6で示すように、リスト14-5のより便利な構造を使用することもできます。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate art;

use art::PrimaryColor;
use art::mix;

fn main() {
#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト14-6。 <code>art</code>通い箱の再<ruby>輸出<rt>エクスポート</rt></ruby>された項目を使用する算譜</span>

入れ子になった<ruby>役区<rt>モジュール</rt></ruby>が多数ある場合、最上位で`pub use`して型を再<ruby>輸出<rt>エクスポート</rt></ruby>すると、<ruby>通い箱<rt>クレート</rt></ruby>を使用する人の経験に大きな違いが生じます。

便利な<ruby>公開<rt>パブリック</rt></ruby>API構造を作成することは、科学よりも芸術であり、利用者にとって最適なAPIを見つけることができます。
`pub use`を選択すると、<ruby>通い箱<rt>クレート</rt></ruby>を内部的にどのように構築するかに柔軟性がもたらされ、その内部構造を利用者に提示するものから切り離すことができます。
導入した<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>の一部を見て、内部構造が<ruby>公開<rt>パブリック</rt></ruby>APIと異なるかどうかを確認してください。

### Crates.ioアカウントを設定する

任意の<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>する前に、[crates.io](https://crates.io)アカウントを作成する必要があります
 API字句を取得します。
そうするには、[crates.io](https://crates.io)ホームページを[crates.io](https://crates.io)ください
 GitHubアカウント経由でログインしてください。
（GitHubアカウントは現在のところ必要ですが、将来的にアカウントを作成する他の方法をサポートしているかもしれません）。ログインしたら、アカウント設定を[https://crates.io/me/](https://crates.io/me/)して[https://crates.io/me/](https://crates.io/me/)
 APIキーを取得します。
次に、次のようにAPIキーを使って`cargo login`命令を実行します。

```text
$ cargo login abcdefghijklmnopqrstuvwxyz012345
```

この命令はCargoにAPI字句を通知し、*〜/.cargo/credentialsに*ローカルに格納し*ます*。
この字句は*秘密*です。他の誰とも共有しないでください。
何らかの理由で他の人と共有している場合は、それを取り消して[crates.io](https://crates.io)新しい字句を生成する必要があります
 。

### 新しい<ruby>通い箱<rt>クレート</rt></ruby>へのメタデータの追加

今、口座を持っています。出版したい<ruby>通い箱<rt>クレート</rt></ruby>を持っているとしましょう。
パブリッシュする前に、<ruby>通い箱<rt>クレート</rt></ruby>の*Cargo.toml*ファイルの`[package]`章にメタデータを追加して、<ruby>通い箱<rt>クレート</rt></ruby>にメタデータを追加する必要があります。

<ruby>通い箱<rt>クレート</rt></ruby>には一意の名前が必要です。
現地で<ruby>通い箱<rt>クレート</rt></ruby>を作っている間に、好きな<ruby>通い箱<rt>クレート</rt></ruby>を名づけることができます。
しかし、[crates.io](https://crates.io)<ruby>通い箱<rt>クレート</rt></ruby>の名前
 先着順に割り当てられます。
いったん<ruby>通い箱<rt>クレート</rt></ruby>の名前が取られると、誰もその名前の<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>することはできません。
サイトで使用する名前を検索し、使用されているかどうかを調べます。
そうでない場合は、`[package]`下の*Cargo.toml*ファイルの名前を編集して<ruby>公開<rt>パブリック</rt></ruby>用の名前を使用します。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
```

一意の名前を選択しても、この時点で`cargo publish`を発行して<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>すると、警告が表示され、<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
$ cargo publish
    Updating registry `https://github.com/rust-lang/crates.io-index`
warning: manifest has no description, license, license-file, documentation,
homepage or repository.
--snip--
error: api errors: missing or empty metadata fields: description, license.
```

その理由は、いくつかの重要な情報が欠落しているということです。<ruby>通い箱<rt>クレート</rt></ruby>が何をしているのか、どのような条件で使用できるのかを人々が知るための説明とライセンスが必要です。
この<ruby>誤り<rt>エラー</rt></ruby>を修正するには、この情報を*Cargo.toml*ファイルに含める必要があります。

<ruby>通い箱<rt>クレート</rt></ruby>と一緒に検索結果に表示されるため、1つまたは2つの説明だけを追加します。
`license`<ruby>欄<rt>フィールド</rt></ruby>では、*ライセンスIDの値を指定*する必要があり*ます*。
[Linux Foundationの<ruby>譜体<rt>アプリケーション</rt></ruby>パッケージデータ交換（SPDX）に][spdx]は、この値に使用できる識別子がリストされています。
たとえば、MITライセンスを使用して<ruby>通い箱<rt>クレート</rt></ruby>をライセンスしたことを指定するには、`MIT`識別子を追加します。

[spdx]: http://spdx.org/licenses/

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
license = "MIT"
```

SPDXに表示されないライセンスを使用する場合は、そのライセンスのテキストをファイルに格納し、そのファイルを企画に組み込み、`license-file`を使用してそのファイルの名前を指定する必要があります`license`キーを使用します。

どのライセンスが企画に適しているかについてのガイダンスは、この本の範囲を超えています。
Rustコミュニティの多くの人々は、`MIT OR Apache-2.0`二重ライセンスを使用して、Rustと同じ方法で企画のライセンスを取得します。
このプラクティスでは、`OR`区切られた複数のライセンスIDを指定して、企画に複数のライセンスを持たせることもできます。

一意の名前を使用すると、<ruby>通い箱<rt>クレート</rt></ruby>、説明、ライセンスが作成されたときに`cargo new`追加された版、作成者の詳細、パブリッシュできる企画の*Cargo.toml*ファイルは次のようになります。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
description = "A fun game where you guess what number the computer has chosen."
license = "MIT OR Apache-2.0"

[dependencies]
```

[Cargoの開発資料に](https://doc.rust-lang.org/cargo/)は、他の人が<ruby>通い箱<rt>クレート</rt></ruby>をより簡単に発見して使用できるように指定できる他のメタデータが記載されています。

### Crates.ioへの<ruby>公開<rt>パブリック</rt></ruby>

アカウントを作成し、API字句を保存し、<ruby>通い箱<rt>クレート</rt></ruby>の名前を選択し、必要なメタデータを指定したら、すぐに<ruby>公開<rt>パブリック</rt></ruby>できます！　
<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>すると特定の版が[crates.io](https://crates.io)アップ読み込みされ[crates.io](https://crates.io)
 他人が使用するために。

パブリッシュが*永久的である*ため、<ruby>通い箱<rt>クレート</rt></ruby>をパブリッシュするときは注意してください。
版を上書きすることはできず、<ruby>譜面<rt>コード</rt></ruby>を削除することはできません。
[crates.io](https://crates.io) 1つの主要な目標
 恒久的な<ruby>譜面<rt>コード</rt></ruby>の<ruby>収納<rt>アーカイブ</rt></ruby>として機能するので、[crates.io](https://crates.io)からの<ruby>通い箱<rt>クレート</rt></ruby>に依存するすべての企画が<ruby>組み上げ<rt>ビルド</rt></ruby>され[crates.io](https://crates.io)
 引き続き動作します。
版の削除を許可すると、その目標を達成することは不可能になります。
ただし、<ruby>公開<rt>パブリック</rt></ruby>できる<ruby>通い箱<rt>クレート</rt></ruby>版の数に制限はありません。

`cargo publish`命令を再度実行します。
それは今成功する必要があります。

```text
$ cargo publish
 Updating registry `https://github.com/rust-lang/crates.io-index`
Packaging guessing_game v0.1.0 (file:///projects/guessing_game)
Verifying guessing_game v0.1.0 (file:///projects/guessing_game)
Compiling guessing_game v0.1.0
(file:///projects/guessing_game/target/package/guessing_game-0.1.0)
 Finished dev [unoptimized + debuginfo] target(s) in 0.19 secs
Uploading guessing_game v0.1.0 (file:///projects/guessing_game)
```

おめでとう！　
Rustコミュニティと<ruby>譜面<rt>コード</rt></ruby>を共有しました。誰でも企画の依存として<ruby>通い箱<rt>クレート</rt></ruby>を簡単に追加できます。

### 既存の<ruby>通い箱<rt>クレート</rt></ruby>の新しい版を<ruby>公開<rt>パブリック</rt></ruby>する

<ruby>通い箱<rt>クレート</rt></ruby>を変更して新しい版をリリースする準備ができたら、*Cargo.toml*ファイルで指定された`version`値を変更して再発行します。
[セマンティックバージョニングルール][semver]を使用して、作成した変更の種類に基づいて適切な次の版番号を決定します。
その後、`cargo publish`を実行して新しい版をアップ読み込みします。

[semver]: http://semver.org/

### Crates.ioの版を`cargo yank`

以前の版の<ruby>通い箱<rt>クレート</rt></ruby>を削除することはできませんが、今後の企画では新しい依存関係として追加することはできません。
これは、<ruby>通い箱<rt>クレート</rt></ruby>版が何らかの理由で壊れている場合に便利です。
このような状況では、Cargoは<ruby>通い箱<rt>クレート</rt></ruby>版を*ヤンク*します。

版をヤンクすると、新しい企画がその版に依存し始めるのを防ぎますが、それに依存する既存の企画はすべてその版に<ruby>入荷<rt>ダウンロード</rt></ruby>して依存し続けます。
基本的に、ヤンクは、*Cargo.lock*を持つすべての企画が中断しないことを意味し、生成される将来の*Cargo.lock*ファイルは、ヤンクされた版を使用しません。

<ruby>通い箱<rt>クレート</rt></ruby>の版をヤンクするには、`cargo yank`を実行して、取り消したい版を指定します。

```text
$ cargo yank --vers 1.0.1
```

命令に`--undo`を追加することで、yankを取り消して、版に応じて企画を`--undo`することもできます。

```text
$ cargo yank --vers 1.0.1 --undo
```

ヤンク*は*<ruby>譜面<rt>コード</rt></ruby>を削除*しません*。
たとえば、誤ってアップ読み込みされた秘密を削除するための機能ではありません。
そのような場合は、すぐにそれらの秘密をリセットする必要があります。
