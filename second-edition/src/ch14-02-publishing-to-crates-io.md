## 通い箱をCrates.ioに公開する

[crates.io](https://crates.io)パッケージを使用し[crates.io](https://crates.io)
 企画の依存として、あなた自身のパッケージを公開して、他の人と譜面を共有することもできます。
[crates.io](https://crates.io)の通い箱レジストリ
 パッケージの原譜を配布するので、主にオープンソースの譜面をホストします。

RustとCargoには、公開されたパッケージを人々が使いやすく見つけやすくするための機能があります。
これらの機能のいくつかについて次に説明し、次にパッケージを公開する方法を説明します。

### 役に立つ開発資料のコメントを作る

パッケージを正確に文書化することで、他のユーザーがいつ、どのように使用するのかを知ることができますので、時間をかけて文書を書く価値があります。
第3章では、2つのスラッシュを使ってRust譜面をコメントする方法について説明しました`//`。
Rustには、HTML開発資料を生成する*開発資料集コメント*として便利な、開発資料に関する特別な種類のコメントもあります。
HTMLには、あなたの通い箱の*実装*方法とは対照的に、通い箱の*使用*方法を知りたい演譜師向けの公開API項目の開発資料コメントの内容が表示されます。

開発資料コメントでは、2つの代わりに3つのスラッシュ（`///`使用し、文言の書式設定のためのMarkdown表記をサポートしています。
文書化している項目の直前に文書のコメントを置いてください。
リスト14-1はのための開発資料集コメントを示し`add_one`通い箱という名前で機能`my_crate`。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト14-1。機能の開発資料コメント</span>

ここでは、何の記述与える`add_one`機能は、見出しと章開始しない`Examples`、次に使用する方法を示す譜面を提供`add_one`機能を。
`cargo doc`実行することによって、この開発資料コメントからHTML開発資料を生成することができます。
この命令は、Rustと一緒に配布されている`rustdoc`道具を実行し、生成されたHTML開発資料を*target / doc*ディレクトリに置きます。

便宜上、`cargo doc --open` -openはあなたの現在の通い箱の文書（あなたの通い箱のすべての依存物に関する文書）用のHTMLを作成し、その結果をWebブラウザで開きます。
`add_one`機能に`add_one`すると、図14-1に示すように、開発資料コメント内の文言がどのように表示されるかがわかります。

<img src="img/trpl14-01.png" alt="`my_crate`の` add_one`機能のためのHTML文書の描出" class="center" />
<span class="caption">図14-1。 <code>add_one</code>機能のHTML開発資料</span>

#### よく使われる章

使用`# Examples`値下げは、題名とHTML内の章を作成するには、リスト14-1に向かう。ここ通い箱の作者は、一般的に自分の開発資料で使用するいくつかの他の部分である「例」を。

* **パニック**。文書化されている機能がパニックに陥る可能性のある場合。
   算譜のパニックを望まない機能の呼び出し側は、これらの状況で機能を呼び出さないようにする必要があります。
* **誤り**。機能が`Result`返す場合、発生する可能性のある誤りの種類と、その誤りが返される条件を記述することで、さまざまな種類の誤りを処理する譜面をさまざまな方法で記述できるようになります。
* **安全性**。機能が`unsafe`場合（第19章で`unsafe`は`unsafe`ことを議論する）、機能が安全でない理由を説明し、機能が呼び出し側が維持しようとする不変量をカバーする章が存在するはずです。

ほとんどの開発資料集コメントはこれらの章のすべてを必要としませんが、あなたの譜面を呼び出す人々が知りたいと思う譜面の面を思い出させる良いチェックリストです。

#### テストとしての開発資料集コメント

開発資料集コメントに譜面例ブ​​ロックを追加すると、譜集の使用方法を示すのに役立ちます。そうすることで、追加のボーナスが得られます。実行中の`cargo test`は、開発資料集の譜面例をテストとして実行します。
例を持つ文書より優れているものはありません。
しかし、開発資料が書かれてから譜面が変更されたため、動作しない例よりも悪いものはありません。
リスト14-1の`add_one`機能の開発資料で`cargo test`を実行すると、次のようなテスト結果の章が表示されます。

```text
   Doc-tests my_crate

running 1 test
test src/lib.rs - add_one (line 5) ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

ここで、機能または例を変更して、例のパニックで`assert_eq!`再度実行し、`cargo test`再度実行すると、サンプルと譜面が互いに同期していないことが開発資料テストで分かります。

#### 含まれている項目のコメント

開発資料コメントの別のスタイル`//!`は、コメントに続く項目に開発資料を追加するのではなく、コメントを含む項目に開発資料を追加します。
通常、*crate*ルートファイル（慣習的に*src / lib.rs*） *内また*はこれらの開発資料のコメントを役区全体で使用して、通い箱または役区全体を文書化します。

たとえば、`add_one`機能を含む`my_crate`の目的を記述した開発資料を追加したい場合は、*src / lib.rs*ファイルの先頭に`//!`で始まる開発資料コメントを追加することができます14-2。

<span class="filename">ファイル名。src / lib.rs</span>

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

`//!`で始まる最後の行の後に譜面がないことに注意してください。
`///`ではなく`//!`を使用してコメントを開始したので、このコメントの後に続く項目ではなく、このコメントを含む項目を文書化しています。
この場合、このコメントを含む項目は*src / lib.rs*ファイルであり、これは通い箱ルートです。
これらのコメントは通い箱全体を記述します。

`cargo doc --open`を実行すると、これらのコメントは、図14-2に示すように、通い箱内の公開項目のリストの上にある`my_crate`の開発資料のフロントページに表示されます。

<img src="img/trpl14-02.png" alt="通い箱のコメント全体をHTML形式で表示" class="center" />
<span class="caption">図14-2。 <code>my_crate</code>描出された開発資料。通い箱全体を説明するコメントを含む</span>

項目内の開発資料集コメントは、特に通い箱や役区の説明に役立ちます。
これらを使用して、コンテナの全体的な目的を説明し、ユーザーが通い箱の組織を理解するのを助けます。

### `pub use`した便利な公開APIの輸出

第7章では、`mod`予約語を使用して譜面を役区に編成する方法、`pub`予約語を使用して項目を公開にする方法、`use`予約語を`use`して項目を有効範囲に持ち込む方法について説明しました。
しかし、あなたが通い箱を開発している間にあなたに合った構造は、あなたのユーザーにはあまり便利でないかもしれません。
構造体を複数のレベルを含む階層に編成することもできますが、階層の中で深く定義した型を使用したい人は、その型が存在するかどうかを調べるのが難しいかもしれません。
それらは、`my_crate::some_module::another_module::UsefulType;` `use`しなければならないことに腹を`my_crate::some_module::another_module::UsefulType;`かもしれ`my_crate::some_module::another_module::UsefulType;`
`my_crate::UsefulType;` `use`ではなく`my_crate::UsefulType;`
。

あなたの公開APIの構造は、通い箱を公開する際の主な考慮事項です。
あなたの通い箱を使用する人はあなたのものより構造にあまり精通しておらず、あなたの通い箱が大きな役区階層を持っている場合、使用したい部分を見つけるのが難しいかもしれません。

良いことは、他の譜集から他の譜集で使用するのに構造*が*便利で*ない*場合、内部組織を再編成する必要はなく、項目を再輸出して私的な構造とは異なる公開構造にすることができるということです`pub use`によって。
再輸出では、ある場所で公開項目が使用され、別の場所で定義されているかのように、公開項目が別の場所に公開されます。

たとえば、`art`という概念をモデリングするために`art`という名前の譜集を作成したとします。
この譜集には、リスト14-3に示すように、`PrimaryColor`と`SecondaryColor` 2つの列挙型を含む`kinds`役区と、`mix`という名前の機能を含む`utils`役区があります。

<span class="filename">ファイル名。src / lib.rs</span>

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

図14-3に、`cargo doc`によって生成されたこの通い箱の開発資料の最初のページを示します。

<img src="img/trpl14-03.png" alt="`kind`役区と` utils`役区をリストアップした `art`通い箱の描出された開発資料" class="center" />
<span class="caption">図14-3。 <code>kinds</code>と<code>utils</code>役区をリストアップした<code>art</code>の開発資料のフロントページ</span>

`PrimaryColor`と`SecondaryColor`型はフロントページにもリストされていませんし、`mix`機能もありません。
それらを見るために`kinds`と`utils`をクリックしなければなりません。

この譜集に依存する別の通い箱には、現在定義されている役区構造を指定して、`art`から項目を輸入する`use`文が必要です。
リスト14-4は、`PrimaryColor`を使用し、`art`通い箱の項目を`mix`する通い箱の例を示しています。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト14-4。内部構造が輸出された<code>art</code>通い箱の項目を使用する通い箱</span>

使用して、リスト14-4の譜面の作者`art`通い箱は、ということを理解しなければならなかった`PrimaryColor`である`kinds`の役区と`mix`している`utils`役区。
役区構造`art`通い箱は、に取り組んで開発者により関連性のある`art`よりも使用して開発者に通い箱`art`通い箱を。
通い箱の一部を`kinds`役区と`utils`役区に編成する内部構造には、`art`通い箱の使用方法を理解しようとする人にとって有用な情報は含まれていません。
その代わりに、`art`通い箱の役区構造は混乱を招く。なぜなら、開発者はどこから見ているか把握しなければならず、開発者は`use`文に役区名を指定しなければならないため、構造が不便であます。

公開APIから内部組織を削除するには、譜面リスト14-3の`art`通い箱・譜面を変更して、リスト14-5に示すように、`pub use`文を追加して項目を最上位で再輸出することができます。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト14-5。項目を再輸出する<code>pub use</code>文の追加</span>

この通い箱用に`cargo doc`生成するAPI開発資料は、図14-4に示すように、フロントページに再輸出をリストして結合するようになり、`PrimaryColor`および`SecondaryColor`型と`mix`機能を簡単に見つけることができます。

<img src="img/trpl14-04.png" alt="フロントページに再輸出した「アート」枠の開発資料を描出しました。" class="center" />
<span class="caption">図14-4。再輸出を記載した<code>art</code>ための開発資料集の最初のページ</span>

リスト14-4に示すように、`art`通い箱ユーザーはリスト14-3の内部構造を見たり使用したりすることができます。リスト14-6で示すように、リスト14-5のより便利な構造を使用することもできます。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
extern crate art;

use art::PrimaryColor;
use art::mix;

fn main() {
#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト14-6。 <code>art</code>通い箱の再輸出された項目を使用する算譜</span>

入れ子になった役区が多数ある場合、最上位で`pub use`して型を再輸出すると、通い箱を使用する人の経験に大きな違いが生じます。

便利な公開API構造を作成することは、科学よりも芸術であり、ユーザーにとって最適なAPIを見つけることができます。
`pub use`を選択すると、あなたの通い箱を内部的にどのように構築するかに柔軟性がもたらされ、その内部構造をユーザーに提示するものから切り離すことができます。
導入した通い箱の譜面の一部を見て、内部構造が公開APIと異なるかどうかを確認してください。

### Crates.ioアカウントを設定する

任意の通い箱を公開する前に、[crates.io](https://crates.io)アカウントを作成する必要があります
 API字句を取得します。
そうするには、[crates.io](https://crates.io)ホームページを[crates.io](https://crates.io)ください
 GitHubアカウント経由でログインしてください。
（GitHubアカウントは現在のところ必要ですが、将来的にアカウントを作成する他の方法をサポートしているかもしれません）。ログインしたら、アカウント設定を[https://crates.io/me/](https://crates.io/me/)して[https://crates.io/me/](https://crates.io/me/)
 APIキーを取得します。
次に、次のようにAPIキーを使って`cargo login`命令を実行します。

```text
$ cargo login abcdefghijklmnopqrstuvwxyz012345
```

この命令はCargoにAPI字句を通知し、*〜/.cargo / credentialsに*ローカルに格納し*ます*。
この字句は*秘密*です。他の誰とも共有しないでください。
何らかの理由で他の人と共有している場合は、それを取り消して[crates.io](https://crates.io)新しい字句を生成する必要があります
 。

### 新しい通い箱へのメタデータの追加

今、あなたは口座を持っています。あなたが出版したい通い箱を持っているとしましょう。
パブリッシュする前に、通い箱の*Cargo.toml*ファイルの`[package]`章にメタデータを追加して、通い箱にメタデータを追加する必要があります。

あなたの通い箱には一意の名前が必要です。
あなたは現地で通い箱を作っている間に、あなたが好きな通い箱を名づけることができます。
しかし、[crates.io](https://crates.io)通い箱の名前
 先着順に割り当てられます。
いったん通い箱の名前が取られると、誰もその名前の通い箱を公開することはできません。
サイトで使用する名前を検索し、使用されているかどうかを調べます。
そうでない場合は、`[package]`下の*Cargo.toml*ファイルの名前を編集して公開用の名前を使用します。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
```

一意の名前を選択しても、この時点で`cargo publish`を発行して通い箱を公開すると、警告が表示され、誤りが表示されます。

```text
$ cargo publish
    Updating registry `https://github.com/rust-lang/crates.io-index`
warning: manifest has no description, license, license-file, documentation,
homepage or repository.
--snip--
error: api errors: missing or empty metadata fields: description, license.
```

その理由は、いくつかの重要な情報が欠落しているということです。あなたの通い箱が何をしているのか、どのような条件で使用できるのかを人々が知るための説明とライセンスが必要です。
この誤りを修正するには、この情報を*Cargo.toml*ファイルに含める必要があります。

あなたの通い箱と一緒に検索結果に表示されるため、1つまたは2つの説明だけを追加します。
`license`欄では、*ライセンスIDの値を指定*する必要があり*ます*。
[Linux Foundationの譜体パッケージデータ交換（SPDX）に][spdx]は、この値に使用できる識別子がリストされています。
たとえば、MITライセンスを使用してあなたの通い箱をライセンスしたことを指定するには、`MIT`識別子を追加します。

[spdx]: http://spdx.org/licenses/

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
license = "MIT"
```

SPDXに表示されないライセンスを使用する場合は、そのライセンスの文言をファイルに格納し、そのファイルを企画に組み込み、`license-file`を使用してそのファイルの名前を指定する必要があります`license`キーを使用します。

どのライセンスが企画に適しているかについてのガイダンスは、この本の範囲を超えています。
Rustコミュニティの多くの人々は、`MIT OR Apache-2.0`二重ライセンスを使用して、Rustと同じ方法で企画のライセンスを取得します。
このプラクティスでは、`OR`区切られた複数のライセンスIDを指定して、企画に複数のライセンスを持たせることもできます。

一意の名前を使用すると、通い箱、説明、ライセンスが作成されたときに`cargo new`追加された版、作成者の詳細、パブリッシュできる企画の*Cargo.toml*ファイルは次のようになります。

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

[Cargoの開発資料に](https://doc.rust-lang.org/cargo/)は、他の人があなたの通い箱をより簡単に発見して使用できるように指定できる他のメタデータが記載されています。

### Crates.ioへの公開

アカウントを作成し、API字句を保存し、あなたの通い箱の名前を選択し、必要なメタデータを指定したら、すぐに公開できます！　
通い箱を公開すると特定の版が[crates.io](https://crates.io)アップ読み込みされ[crates.io](https://crates.io)
 他人が使用するために。

パブリッシュが*永久的である*ため、通い箱をパブリッシュするときは注意してください。
版を上書きすることはできず、譜面を削除することはできません。
[crates.io](https://crates.io) 1つの主要な目標
 恒久的な譜面の収納として機能するので、[crates.io](https://crates.io)からの通い箱に依存するすべての企画が組み上げされ[crates.io](https://crates.io)
 引き続き動作します。
版の削除を許可すると、その目標を達成することは不可能になります。
ただし、公開できる通い箱版の数に制限はありません。

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
あなたはRustコミュニティと譜面を共有しました。誰でもあなたの企画の依存としてあなたの通い箱を簡単に追加できます。

### 既存の通い箱の新しい版を公開する

あなたの通い箱を変更して新しい版をリリースする準備ができたら、*Cargo.toml*ファイルで指定された`version`値を変更して再発行します。
[セマンティックバージョニングルール][semver]を使用して、作成した変更の種類に基づいて適切な次の版番号を決定します。
その後、`cargo publish`を実行して新しい版をアップ読み込みします。

[semver]: http://semver.org/

### Crates.ioの版を`cargo yank`

以前の版の通い箱を削除することはできませんが、今後の企画では新しい依存関係として追加することはできません。
これは、通い箱版が何らかの理由で壊れている場合に便利です。
このような状況では、Cargoは通い箱版を*ヤンク*します。

版をヤンクすると、新しい企画がその版に依存し始めるのを防ぎますが、それに依存する既存の企画はすべてその版に入荷して依存し続けます。
基本的に、ヤンクは、*Cargo.lock*を持つすべての企画が中断しないことを意味し、生成される将来の*Cargo.lock*ファイルは、ヤンクされた版を使用しません。

通い箱の版をヤンクするには、`cargo yank`を実行して、取り消したい版を指定します。

```text
$ cargo yank --vers 1.0.1
```

命令に`--undo`を追加することで、yankを取り消して、版に応じて企画を`--undo`することもできます。

```text
$ cargo yank --vers 1.0.1 --undo
```

ヤンク*は*譜面を削除*しません*。
たとえば、誤ってアップ読み込みされた秘密を削除するための機能ではありません。
そのような場合は、すぐにそれらの秘密をリセットする必要があります。
