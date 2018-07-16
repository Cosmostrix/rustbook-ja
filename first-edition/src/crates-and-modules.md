# 通い箱と役区

企画が大規模になるにつれて、譜体工学の慣習として、小さな断片に分割し、それらを合わせることが考えられます。
また、一部の機能が内部用で、一部が公開されるように、明確な接点を持つことも重要です。
このようなことを容易にするために、Rustには役区システムがあります。

# 基本的な用語。通い箱と役区

Rustには役区システムに関連する2つの異なる用語があります。 'crate'と 'module'。
通い箱は、他の言語の '譜集'または 'パッケージ'と同義です。
したがって、Rustのパッケージ管理道具の名前として「Cargo」。カーゴを使ってあなたの通い箱を他の人に発送します。
通い箱は、企画に応じて実行可能ファイルまたは譜集を生成することができます。

各通い箱には、その通い箱の譜面を含む暗黙*ルート役区*があります。
そのルート役区の下に下位役区のツリーを定義することができます。
役区を使用すると、通い箱自体の中に譜面を分割することができます。

例として、*フレーズ*通い箱を作ってみましょう。これは、さまざまな言語でさまざまなフレーズを提供します。
シンプルなものにするために、2つのフレーズとして「greetings」と「farewells」に固執し、それらのフレーズの2つの言語として英語と日本語（日本語）を使用します。この役区配置を使用します。

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

この例では、`phrases`は通い箱の名前です。
残りはすべて役区です。
*木の根*である通い箱の*根*から分岐した木が形成されていることがわかります。`phrases`自体です。

ここで計画を立てたので、これらの役区を譜面で定義しましょう。
まず、Cargoで新しい通い箱を生成します。

```bash
$ cargo new phrases
$ cd phrases
```

あなたが覚えている場合、これは簡単な企画を生成します。

```bash
$ tree .
.
├── Cargo.toml
└── src
    └── lib.rs

1 directory, 2 files
```

`src/lib.rs`は、上の図の`phrases`に対応する通い箱ルートです。

# 役区の定義

それぞれの役区を定義するために、`mod`予約語を使用します。
`src/lib.rs`を次のように見てみましょう。

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

`mod`予約語の後に​​、役区の名前を指定します。
役区名は、他のRust識別子の規則に従います。 `lower_snake_case`。
各役区の内容は中かっこ（`{}`）で囲まれています。

与えられた内`mod`、あなたは下位宣言でき`mod`。
下位役区をダブルコロン（`::`:）表記と呼ぶことができます。入れ子になった4つの役区は、 `english::greetings`、 `english::farewells`、 `japanese::greetings`、 `japanese::farewells`です。
これらの下位役区は親役区の下で名前空間になっているので、名前は矛盾しません`english::greetings`と`japanese::greetings`は、名前が両方とも`greetings`であっても区別されます。

この通い箱には`main()`機能がなく、`lib.rs`と呼ばれる`lib.rs`、Cargoはこの通い箱を譜集として構築します。

```bash
$ cargo build
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
$ ls target/debug
build  deps  examples  libphrases-a7448e02a0468eaa.rlib  native
```

`libphrases-<hash>.rlib`は製譜済みの通い箱です。
別の通い箱からこの通い箱を使用する方法を見る前に、それを複数のファイルに分割してみましょう。

# 複数のファイルの通い箱

各通い箱が1つのファイルだった場合、これらのファイルは非常に大きくなります。
多くの場合、通い箱を複数のファイルに分割する方が簡単です。Rustはこれを2つの方法でサポートしています。

このような役区を宣言するのではなく、

```rust,ignore
mod english {
#    // Contents of our module go here.
    // 役区の内容はここにあります。
}
```

代わりに次のように役区を宣言することができます。

```rust,ignore
mod english;
```

これを行うと、Rustは`english.rs`ファイルか`english/mod.rs`ファイルを役区の内容と一緒に見つけることになります。

これらのファイルでは、役区を再宣言する必要はないことに注意してください。これはすでに初期`mod`宣言で行われています。

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

好みに応じて。
この場合、役区に下位役区があるため、`mod.rs`アプローチを選択し`mod.rs`。
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

これらの下位役区には独自の下位役区がないため、`src/english/greetings.rs`、 `src/english/farewells.rs`、 `src/japanese/greetings.rs`、 `src/japanese/farewells.rs`。
すごい！　

現在`src/english/greetings.rs`、 `src/english/farewells.rs`、 `src/japanese/greetings.rs`、 `src/japanese/farewells.rs`はすべて空です。
いくつかの機能を追加しましょう。

これを`src/english/greetings.rs`入れてください。

```rust
fn hello() -> String {
    "Hello!".to_string()
}
```

これを`src/english/farewells.rs`入れてください。

```rust
fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

これを`src/japanese/greetings.rs`入れてください。

```rust
fn hello() -> String {
    "こんにちは".to_string()
}
```

もちろん、このWebページからこれをコピーして貼り付けることができます。
役区システムについて学ぶために実際に「こんにちは」を置くことは重要ではありません。

これを`src/japanese/farewells.rs`入れてください。

```rust
fn goodbye() -> String {
    "さようなら".to_string()
}
```

（これはあなたが好奇心が強いならば、「さよなら」です。）

さて、通い箱にいくつかの機能がありましたので、別の通い箱からそれを使ってみましょう。

# 外部通い箱の輸入

私たちには譜集があります。
譜集を輸入して使用する実行可能な通い箱を作りましょう。

`src/main.rs`を作り、これを入れてください（これはまだ製譜されません）。

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());

    println!("Hello in Japanese: {}", phrases::japanese::greetings::hello());
    println!("Goodbye in Japanese: {}", phrases::japanese::farewells::goodbye());
}
```

`extern crate`宣言は、Rustに製譜して`phrases`通い箱に結合する必要があることを伝えます。
この場合、`phrases`の役区を使用できます。
前述のように、二重コロンを使用して下位役区とその内部の機能を参照することができます。

（注。有効なRust識別子ではない "like-this"という名前にダッシュを含む通い箱を輸入する場合は、ダッシュを下線に変更して変換されますので、`extern crate like_this;`と書いてください）

また、Cargoは、`src/main.rs`が譜集通い箱ではなく、二進譜通い箱の通い箱ルートであることを前提としています。
パッケージには`src/lib.rs`と`src/main.rs` 2つの`src/main.rs`ます。
このパターンは、実行可能な通い箱ではよく使用されます。ほとんどの機能は譜集通い箱にあり、実行可能な通い箱はその譜集を使用します。
このようにして、他の算譜も譜集通い箱を使用することができます。また、それは良い関心の分離です。

しかしこれはまだうまくいかない。
これに似た4つの誤りが発生します。

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

自動的には、すべてがRustの内部用です。
これについてもう少し詳しく話しましょう。

# 公開接点の輸出

Rustでは、接点のどの部分が公開されているかを正確に制御できるため、黙用は内部用です。
物事を公開するには、`pub`予約語を使用し`pub`。
最初に`english`役区に焦点を当てましょう`src/main.rs`をこれだけに減らしましょう。

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());
}
```

`src/lib.rs`では、`pub`を`english`役区宣言に追加しましょう。

```rust,ignore
pub mod english;
mod japanese;
```

`src/english/mod.rs`では、両方の`pub`作成しましょう。

```rust,ignore
pub mod greetings;
pub mod farewells;
```

`src/english/greetings.rs`では、`pub`を`fn`宣言に追加しましょう。

```rust,ignore
pub fn hello() -> String {
    "Hello!".to_string()
}
```

また、`src/english/farewells.rs`。

```rust,ignore
pub fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

さて、通い箱は製譜されますが、`japanese`機能を使用しないことについての警告があります。

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

`pub`は、`struct`とその要素欄にも適用されます。
Rustの安全への傾向に合わせて、`struct`公開にするだけで自動的に要素を公開にすることはありません。欄を`pub`個別にマークする必要があります。

機能が公開されたので、それらを使用することができます。
すばらしいです！　
しかし、`phrases::english::greetings::hello()`は非常に長く、繰り返します。
Rustには、現在の有効範囲に名前を輸入するための別の予約語があります。これにより、短い名前で参照することができます。
`use`について話しましょう。

# `use`役区を輸入`use`

Rustには`use`予約語があり、ローカル有効範囲に名前を輸入できます。
`src/main.rs`を次のように変更しましょう。

```rust,ignore
extern crate phrases;

use phrases::english::greetings;
use phrases::english::farewells;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());
}
```

2つの`use`行は各役区をローカル有効範囲に輸入するので、機能をより短い名前で参照することができます。
慣習では、機能を輸入するときは、機能ではなく役区を直接輸入することをお勧めします。
つまり、これ _を_ 行うこと _ができ_ ます。

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
短期算譜では大きな問題ではありませんが、成長するにつれて問題になります。
競合する名前がある場合、Rustは製譜誤りを返します。
たとえば、`japanese`機能を公開して、これを実行しようとしたとします。

```rust,ignore
extern crate phrases;

use phrases::english::greetings::hello;
use phrases::japanese::greetings::hello;

fn main() {
    println!("Hello in English: {}", hello());
    println!("Hello in Japanese: {}", hello());
}
```

Rustは私たちに製譜時の誤りを与えます。

```text
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/main.rs:4:5: 4:40 error: a value named `hello` has already been imported in this module [E0252]
src/main.rs:4 use phrases::japanese::greetings::hello;
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `phrases`.
```

同じ役区から複数の名前を輸入する場合、二度打つ必要はありません。
これの代わりに。

```rust,ignore
use phrases::english::greetings;
use phrases::english::farewells;
```

この近道を使用することができます。

```rust,ignore
use phrases::english::{greetings, farewells};
```

## `pub use`による再輸出

あなたは識別子を短縮するためにuseを`use`するだけではありません。
あなたの通い箱の中でそれを使って、別の役区の中にある機能を再輸出することもできます。
これにより、内部譜面構成に直接マッピングされない可能性のある外部接点を提示することができます。

例を見てみましょう。
`src/main.rs`を次のように変更します。

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

次に`src/lib.rs`を変更して`japanese` modをpublicにします。

```rust,ignore
pub mod english;
pub mod japanese;
```

次に、`src/japanese/greetings.rs`の2つの機能をpublicにします。

```rust,ignore
pub fn hello() -> String {
    "こんにちは".to_string()
}
```

そして`src/japanese/farewells.rs`。

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

`pub use`宣言は、役区階層のこの部分で機能を有効範囲に入れます。
きたので`pub use` D私達のこの内部`japanese`役区を、今持っている`phrases::japanese::hello()`機能と`phrases::japanese::goodbye()`それらの譜面はに存在しているにもかかわらず、機能を`phrases::japanese::greetings::hello()`と`phrases::japanese::farewells::goodbye()`
内部の構成は外部接点を定義していません。

ここでは、`japanese`範囲に持っていきたい機能ごとに`pub use`しています。
代わりに、ワイルドカード構文を使用して、`greetings`から現在の有効範囲にすべてを含めることができます。 `pub use self::greetings::*`。

`self`についてはどうでしょうか？　
さて、自動的には、`use`宣言はあなたの通い箱ルートから始まる絶対パスです。
`self`はそのパスを階層内のあなたの現在の場所に相対的にします。
もっと特殊な`use`あり`use`。 `use super::`を`use super::`して、現在の場所からツリーの1つ上のレベルに到達`use super::`ことができ`use super::`。
何人かの人は`self`ことと思うのが好き`.`
そして`super`など`..`、現在のディレクトリと親ディレクトリのための多くの司得の表示から。

`use`外で`use`、パスは相対パスです`foo::bar()`は、`foo`内部の機能を参照しています。
これに`::`、 `::foo::bar()`のように接頭辞が付いている場合は、別の`foo`参照します。これは、あなたの通い箱ルートからの絶対パスです。

これが構築され実行されます。

```bash
$ cargo run
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
     Running `target/debug/phrases`
Hello in English: Hello!
Goodbye in English: Goodbye.
Hello in Japanese: こんにちは
Goodbye in Japanese: さようなら
```

## 複雑な輸入

Rustは、あなたの`extern crate`と`use`文にコンパクトさと利便性を追加できるいくつかの高度な選択肢を提供します。
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

何が起きているのでしょう？　

まず、`extern crate`と`use`両方で、輸入されているものの名​​前を変更できます。
だから通い箱はまだ "フレーズ"と呼ばれていますが、ここではそれを "言葉"と呼んでいます。
同様に、最初の`use`文は、`japanese::greetings`役区を通い箱から引き出しますが、単に`greetings`とは対照的に`ja_greetings`として利用できます。
これにより、同じ名前の項目を別の場所から輸入するときのあいまいさを避けることができます。

2番目の`use`文は、パターン展開を使用して、`sayings::japanese::farewells`役区からすべての公開シンボルを`sayings::japanese::farewells`ます。
ご覧のように、後で役区の修飾子なしで日本語の`goodbye`機能を参照することができます。
この種のグロブは控えめに使用する必要があります。
パターン展開を行っている譜面が同じ役区内にあっても、公開シンボルのみを輸入することに注意してください。

3番目の`use`文は、より詳細な説明をしています。
3つの`use`文を1つに圧縮`use` "中括拡張"グロブを`use`（この種の構文は、以前にLinux司得台譜を作成していれば分かります）。
この文の非圧縮形式は次のとおりです。

```rust,ignore
use sayings::english;
use sayings::english::greetings as en_greetings;
use sayings::english::farewells as en_farewells;
```

ご覧のように、中かっこは、同じパスの下の複数の項目の`use`文を圧縮します。この文脈では、`self`はそのパスを参照します。
注。中かっこは入れ子にすることも、パターン展開と混在させることもできません。
