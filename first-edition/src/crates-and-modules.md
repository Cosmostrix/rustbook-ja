# クレートとモジュール

プロジェクトが大規模になるにつれて、ソフトウェア工学の慣習として、小さな断片に分割し、それらを合わせることが考えられます。
また、一部の機能がプライベートで、一部が公開されるように、明確なインタフェースを持つことも重要です。
このようなことを容易にするために、Rustにはモジュールシステムがあります。

# 基本的な用語：箱とモジュール

Rustにはモジュールシステムに関連する2つの異なる用語があります： 'crate'と 'module'。
箱は、他の言語の 'ライブラリ'または 'パッケージ'と同義です。
したがって、Rustのパッケージ管理ツールの名前として「Cargo」：貨物を使ってあなたの箱を他の人に発送します。
クレートは、プロジェクトに応じて実行可能ファイルまたはライブラリを生成することができます。

各クレートには、そのクレートのコードを含む暗黙*ルートモジュール*があります。
そのルートモジュールの下にサブモジュールのツリーを定義することができます。
モジュールを使用すると、クレート自体の中にコードを分割することができます。

例として、*フレーズ*クレートを作ってみましょう。これは、さまざまな言語でさまざまなフレーズを提供します。
シンプルなものにするために、2つのフレーズとして「greetings」と「farewells」に固執し、それらのフレーズの2つの言語として英語と日本語（日本語）を使用します。このモジュールレイアウトを使用します：

```text
                                    +-----------+
                                +---| greetings |
                  +---------+   |   +-----------+
              +---| english |---+
              |   +---------+   |   +-----------+
              |                 +---| farewells |
+---------+   |                     +-----------+
| phrases |---+
+---------+   |                     +-----------+
              |                 +---| greetings |
              |   +----------+  |   +-----------+
              +---| japanese |--+
                  +----------+  |   +-----------+
                                +---| farewells |
                                    +-----------+
```

この例では、`phrases`はクレートの名前です。
残りはすべてモジュールです。
*木の根*であるクレートの*根*から分岐した木が形成されていることがわかります。`phrases`自体です。

ここで計画を立てたので、これらのモジュールをコードで定義しましょう。
まず、Cargoで新しいクレートを生成します。

```bash
$ cargo new phrases
$ cd phrases
```

あなたが覚えている場合、これは私たちのための簡単なプロジェクトを生成します：

```bash
$ tree .
.
├── Cargo.toml
└── src
    └── lib.rs

1 directory, 2 files
```

`src/lib.rs`は、上の図の`phrases`に対応するクレートルートです。

# モジュールの定義

それぞれのモジュールを定義するために、`mod`キーワードを使用します。
`src/lib.rs`を次のように見てみましょう：

```rust
mod english {
    mod greetings {
    }

    mod farewells {
    }
}

mod japanese {
    mod greetings {
    }

    mod farewells {
    }
}
```

`mod`キーワードの後に​​、モジュールの名前を指定します。
モジュール名は、他の錆識別子の規則に従います： `lower_snake_case`。
各モジュールの内容は中括弧（`{}`）で囲まれています。

与えられた内`mod`、あなたはサブ宣言でき`mod`秒。
私たちはサブコモンをダブルコロン（`::`:）表記と呼ぶことができます。ネストされた4つのモジュールは、 `english::greetings`、 `english::farewells`、 `japanese::greetings`、 `japanese::farewells`です。
これらのサブモジュールは親モジュールの下で名前空間になっているので、名前は矛盾しません`english::greetings`と`japanese::greetings`は、名前が両方とも`greetings`であっても区別されます。

このクレートには`main()`関数がなく、`lib.rs`と呼ばれる`lib.rs`、Cargoはこのクレートをライブラリとして構築します。

```bash
$ cargo build
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
$ ls target/debug
build  deps  examples  libphrases-a7448e02a0468eaa.rlib  native
```

`libphrases-<hash>.rlib`はコンパイル済みのクレートです。
別の箱からこの箱を使用する方法を見る前に、それを複数のファイルに分割してみましょう。

# 複数のファイルの箱

各クレートが1つのファイルだった場合、これらのファイルは非常に大きくなります。
多くの場合、クレートを複数のファイルに分割する方が簡単です.Rustはこれを2つの方法でサポートしています。

このようなモジュールを宣言するのではなく、

```rust,ignore
mod english {
#    // Contents of our module go here.
    // モジュールの内容はここにあります。
}
```

代わりに次のようにモジュールを宣言することができます：

```rust,ignore
mod english;
```

これを行うと、Rustは`english.rs`ファイルか`english/mod.rs`ファイルをモジュールの内容と一緒に見つけることになります。

これらのファイルでは、モジュールを再宣言する必要はないことに注意してください。これはすでに初期`mod`宣言で行われています。

これらの2つの手法を使用して、2つのディレクトリと7つのファイルに分割することができます。

```bash
$ tree .
.
├── Cargo.lock
├── Cargo.toml
├── src
│   ├── english
│   │   ├── farewells.rs
│   │   ├── greetings.rs
│   │   └── mod.rs
│   ├── japanese
│   │   ├── farewells.rs
│   │   ├── greetings.rs
│   │   └── mod.rs
│   └── lib.rs
└── target
    └── debug
        ├── build
        ├── deps
        ├── examples
        ├── libphrases-a7448e02a0468eaa.rlib
        └── native
```

`src/lib.rs`は`src/lib.rs`ルートで、次のようになります。

```rust,ignore
mod english;
mod japanese;
```

これら2つの宣言はRustに

- `src/english.rs`または`src/english/mod.rs`いずれか
- `src/japanese.rs`または`src/japanese/mod.rs`いずれか、

私たちの好みに応じて。
この場合、モジュールにサブモジュールがあるため、`mod.rs`アプローチを選択し`mod.rs`。
`src/english/mod.rs`と`src/japanese/mod.rs`は次のようになります。

```rust,ignore
mod greetings;
mod farewells;
```

ここでも、これらの宣言はRustに

- `src/english/greetings.rs`または`src/english/greetings/mod.rs`、
- `src/english/farewells.rs`または`src/english/farewells/mod.rs`、
- `src/japanese/greetings.rs`または`src/japanese/greetings/mod.rs`、
- `src/japanese/farewells.rs`または`src/japanese/farewells/mod.rs`ます。

これらのサブモジュールには独自のサブモジュールがないため、`src/english/greetings.rs`、 `src/english/farewells.rs`、 `src/japanese/greetings.rs`、 `src/japanese/farewells.rs`。
すごい！

現在`src/english/greetings.rs`、 `src/english/farewells.rs`、 `src/japanese/greetings.rs`、 `src/japanese/farewells.rs`はすべて空です。
いくつかの関数を追加しましょう。

これを`src/english/greetings.rs`入れてください：

```rust
fn hello() -> String {
    "Hello!".to_string()
}
```

これを`src/english/farewells.rs`入れてください：

```rust
fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

これを`src/japanese/greetings.rs`入れてください：

```rust
fn hello() -> String {
    "こんにちは".to_string()
}
```

もちろん、このWebページからこれをコピーして貼り付けることができます。
モジュールシステムについて学ぶために実際に「こんにちは」を置くことは重要ではありません。

これを`src/japanese/farewells.rs`入れてください：

```rust
fn goodbye() -> String {
    "さようなら".to_string()
}
```

（これはあなたが好奇心が強いならば、「さよなら」です。）

さて、私たちの箱にいくつかの機能がありましたので、別の箱からそれを使ってみましょう。

# 外部クレートのインポート

私たちには図書室があります。
私たちのライブラリをインポートして使用する実行可能なクレートを作りましょう。

`src/main.rs`を作り、これを入れてください（これはまだコンパイルされません）：

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());

    println!("Hello in Japanese: {}", phrases::japanese::greetings::hello());
    println!("Goodbye in Japanese: {}", phrases::japanese::farewells::goodbye());
}
```

`extern crate`宣言は、Rustにコンパイルして`phrases`クレートにリンクする必要があることを伝えます。
この場合、`phrases`のモジュールを使用できます。
前述のように、二重コロンを使用してサブモジュールとその内部の関数を参照することができます。

（注：有効なRust識別子ではない "like-this"という名前にダッシュを含むクレートをインポートする場合は、ダッシュを下線に変更して変換されますので、`extern crate like_this;`と書いてください）

また、Cargoは、`src/main.rs`がライブラリクレートではなく、バイナリクレートのクレートルートであることを前提としています。
私たちのパッケージには`src/lib.rs`と`src/main.rs` 2つの`src/main.rs`ます。
このパターンは、実行可能なクレートではよく使用されます。ほとんどの機能はライブラリクレートにあり、実行可能なクレートはそのライブラリを使用します。
このようにして、他のプログラムもライブラリクレートを使用することができます。また、それは心配の良い分離です。

しかしこれはまだうまくいかない。
これに似た4つのエラーが発生します。

```bash
$ cargo build
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/main.rs:4:38: 4:72 error: function `hello` is private
src/main.rs:4     println!("Hello in English: {}", phrases::english::greetings::hello());
                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: in expansion of format_args!
<std macros>:2:25: 2:58 note: expansion site
<std macros>:1:1: 2:62 note: in expansion of print!
<std macros>:3:1: 3:54 note: expansion site
<std macros>:1:1: 3:58 note: in expansion of println!
phrases/src/main.rs:4:5: 4:76 note: expansion site
```

デフォルトでは、すべてがRustのプライベートです。
これについてもう少し詳しく話しましょう。

# パブリックインターフェイスのエクスポート

Rustでは、インターフェイスのどの部分が公開されているかを正確に制御できるため、デフォルトはプライベートです。
物事を公開するには、`pub`キーワードを使用し`pub`。
最初に`english`モジュールに焦点を当てましょう`src/main.rs`をこれだけに減らしましょう：

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());
}
```

`src/lib.rs`では、`pub`を`english`モジュール宣言に追加しましょう：

```rust,ignore
pub mod english;
mod japanese;
```

`src/english/mod.rs`では、両方の`pub`作成しましょう：

```rust,ignore
pub mod greetings;
pub mod farewells;
```

私たちの`src/english/greetings.rs`では、`pub`を`fn`宣言に追加しましょう：

```rust,ignore
pub fn hello() -> String {
    "Hello!".to_string()
}
```

また、`src/english/farewells.rs`：

```rust,ignore
pub fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

さて、私たちの箱はコンパイルされますが、`japanese`機能を使用しないことについての警告があります：

```bash
$ cargo run
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/japanese/greetings.rs:1:1: 3:2 warning: function is never used: `hello`, #[warn(dead_code)] on by default
src/japanese/greetings.rs:1 fn hello() -> String {
src/japanese/greetings.rs:2     "こんにちは".to_string()
src/japanese/greetings.rs:3 }
src/japanese/farewells.rs:1:1: 3:2 warning: function is never used: `goodbye`, #[warn(dead_code)] on by default
src/japanese/farewells.rs:1 fn goodbye() -> String {
src/japanese/farewells.rs:2     "さようなら".to_string()
src/japanese/farewells.rs:3 }
     Running `target/debug/phrases`
Hello in English: Hello!
Goodbye in English: Goodbye.
```

`pub`は、`struct`とそのメンバーフィールドにも適用されます。
Rustの安全への傾向に合わせて、`struct`パブリックにするだけで自動的にメンバをパブリックにすることはありません。フィールドを`pub`個別にマークする必要があります。

私たちの機能が公開されたので、それらを使用することができます。
すばらしいです！
しかし、`phrases::english::greetings::hello()`は非常に長く、繰り返します。
Rustには、現在のスコープに名前をインポートするための別のキーワードがあります。これにより、短い名前で参照することができます。
`use`について話しましょう。

# `use`モジュールをインポート`use`

Rustには`use`キーワードがあり、ローカルスコープに名前をインポートできます。
`src/main.rs`を次のように変更しましょう：

```rust,ignore
extern crate phrases;

use phrases::english::greetings;
use phrases::english::farewells;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());
}
```

2つの`use`行は各モジュールをローカルスコープにインポートするので、関数をより短い名前で参照することができます。
慣習では、関数をインポートするときは、関数ではなくモジュールを直接インポートすることをお勧めします。
つまり、これ _を_ 行うこと _ができ_ ます：

```rust,ignore
extern crate phrases;

use phrases::english::greetings::hello;
use phrases::english::farewells::goodbye;

fn main() {
    println!("Hello in English: {}", hello());
    println!("Goodbye in English: {}", goodbye());
}
```

しかし、それは慣用的ではありません。
これは、命名の競合を引き起こす可能性がより高くなります。
短期プログラムでは大きな問題ではありませんが、成長するにつれて問題になります。
競合する名前がある場合、Rustはコンパイルエラーを返します。
たとえば、`japanese`関数を公開して、これを実行しようとしたとします。

```rust,ignore
extern crate phrases;

use phrases::english::greetings::hello;
use phrases::japanese::greetings::hello;

fn main() {
    println!("Hello in English: {}", hello());
    println!("Hello in Japanese: {}", hello());
}
```

錆は私たちにコンパイル時のエラーを与えます：

```text
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/main.rs:4:5: 4:40 error: a value named `hello` has already been imported in this module [E0252]
src/main.rs:4 use phrases::japanese::greetings::hello;
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `phrases`.
```

同じモジュールから複数の名前をインポートする場合、2回タイプする必要はありません。
これの代わりに：

```rust,ignore
use phrases::english::greetings;
use phrases::english::farewells;
```

このショートカットを使用することができます：

```rust,ignore
use phrases::english::{greetings, farewells};
```

## `pub use`による再輸出

あなたは識別子を短縮するためにuseを`use`するだけではありません。
あなたの箱の中でそれを使って、別のモジュールの中にある関数を再エクスポートすることもできます。
これにより、内部コード構成に直接マッピングされない可能性のある外部インターフェイスを提示することができます。

例を見てみましょう。
`src/main.rs`を次のように変更します：

```rust,ignore
extern crate phrases;

use phrases::english::{greetings,farewells};
use phrases::japanese;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());

    println!("Hello in Japanese: {}", japanese::hello());
    println!("Goodbye in Japanese: {}", japanese::goodbye());
}
```

次に`src/lib.rs`を変更して`japanese` modをpublicにします：

```rust,ignore
pub mod english;
pub mod japanese;
```

次に、`src/japanese/greetings.rs`の2つの関数をpublicにします。

```rust,ignore
pub fn hello() -> String {
    "こんにちは".to_string()
}
```

そして`src/japanese/farewells.rs`：

```rust,ignore
pub fn goodbye() -> String {
    "さようなら".to_string()
}
```

最後に、`src/japanese/mod.rs`を次のように変更します。

```rust,ignore
pub use self::greetings::hello;
pub use self::farewells::goodbye;

mod greetings;
mod farewells;
```

`pub use`宣言は、モジュール階層のこの部分で関数をスコープに入れます。
私たちがきたので`pub use` D私達のこの内部`japanese`モジュールを、我々は今持っている`phrases::japanese::hello()`関数と`phrases::japanese::goodbye()`それらのコードはに住んでいるにもかかわらず、機能を`phrases::japanese::greetings::hello()`と`phrases::japanese::farewells::goodbye()`
私たちの社内組織は外部インターフェースを定義していません。

ここでは、私たちが`japanese`範囲に持っていきたい機能ごとに`pub use`しています。
代わりに、ワイルドカード構文を使用して、`greetings`から現在のスコープにすべてを含めることができます： `pub use self::greetings::*`。

`self`についてはどうですか？
さて、デフォルトでは、`use`宣言はあなたのクレートルートから始まる絶対パスです。
`self`はそのパスを階層内のあなたの現在の場所に相対的にします。
もっと特殊な`use`あり`use`： `use super::`を`use super::`して、現在の場所からツリーの1つ上のレベルに到達`use super::`ことができ`use super::`。
何人かの人は`self`ことと思うのが好き`.`
そして`super`など`..`、現在のディレクトリと親ディレクトリのための多くのシェルの表示から。

`use`外で`use`、パスは相対パスです`foo::bar()`は、`foo`内部の関数を参照しています。
これに`::`、 `::foo::bar()`のように接頭辞が付いている場合は、別の`foo`参照します。これは、あなたのクレートルートからの絶対パスです。

これが構築され実行されます：

```bash
$ cargo run
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
     Running `target/debug/phrases`
Hello in English: Hello!
Goodbye in English: Goodbye.
Hello in Japanese: こんにちは
Goodbye in Japanese: さようなら
```

## 複雑なインポート

錆は、あなたの`extern crate`と`use`ステートメントにコンパクトさと利便性を追加できるいくつかの高度なオプションを提供します。
次に例を示します。

```rust,ignore
extern crate phrases as sayings;

use sayings::japanese::greetings as ja_greetings;
use sayings::japanese::farewells::*;
use sayings::english::{self, greetings as en_greetings, farewells as en_farewells};

fn main() {
    println!("Hello in English; {}", en_greetings::hello());
    println!("And in Japanese: {}", ja_greetings::hello());
    println!("Goodbye in English: {}", english::farewells::goodbye());
    println!("Again: {}", en_farewells::goodbye());
    println!("And in Japanese: {}", goodbye());
}
```

何が起きてる？

まず、`extern crate`と`use`両方で、インポートされているものの名​​前を変更できます。
だから木箱はまだ "フレーズ"と呼ばれていますが、ここではそれを "言葉"と呼んでいます。
同様に、最初の`use`文は、`japanese::greetings`モジュールをクレートから引き出しますが、単に`greetings`とは対照的に`ja_greetings`として利用できます。
これにより、同じ名前のアイテムを別の場所からインポートするときのあいまいさを避けることができます。

2番目の`use`文は、star globを使用して、`sayings::japanese::farewells`モジュールからすべてのパブリックシンボルを`sayings::japanese::farewells`ます。
ご覧のように、後でモジュールの修飾子なしで日本語の`goodbye`関数を参照することができます。
この種のグロブは控えめに使用する必要があります。
globbingを行っているコードが同じモジュール内にあっても、パブリックシンボルのみをインポートすることに注意してください。

3番目の`use`ステートメントは、より詳細な説明をしています。
3つの`use`ステートメントを1つに圧縮`use` "中括拡張"グロブを`use`（この種の構文は、以前にLinuxシェルスクリプトを作成していれば分かります）。
このステートメントの非圧縮形式は次のとおりです。

```rust,ignore
use sayings::english;
use sayings::english::greetings as en_greetings;
use sayings::english::farewells as en_farewells;
```

ご覧のように、中括弧は、同じパスの下のいくつかの項目の`use`ステートメントを圧縮します。このコンテキストでは、`self`はそのパスを参照します。
注：中括弧は入れ子にすることも、スターグロブと混在させることもできません。
