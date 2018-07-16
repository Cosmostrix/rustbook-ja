# 入門

本の最初の章では、Rustとその道具を使って私たちに行くことができます。
まず、Rustを導入します。
そして、古典的な「Hello World」算譜。
最後に、Cargo、Rustの組立系とパッケージ管理系について説明します。

端末を使っていくつかの命令を見せてくれるでしょう。これらの行はすべて`$`始まります。
`$` sを入力する必要はありません。各命令の開始を示すためのものです。
この慣習に従ったWebの周りのチュートリアルや例は、通常のユーザーとして実行する命令の場合は`$`、管理者として実行する必要がある命令の場合は`#`れます。

# Rustの導入

Rustを使用するための最初のステップは、それを導入することです。
一般的に言えば、インターネットからRustを入荷するので、この章で命令を実行するにはインターネット接続が必要です。

Rust製譜器は多数の基盤環境上で実行され、製譜されますが、Linux、Mac、Windows、x86およびx86-64 CPUアーキテクチャで最もよく手入れされています。
これらの基盤環境用のRust製譜器と標準譜集の公式組み上げなどがあります。
[Rust基盤環境のサポートの詳細については、Webサイトを参照してください][platform-support]。

[platform-support]: https://forge.rust-lang.org/platform-support.html

## Rustの導入

LinuxやmacOSのようなUnixシステムで行う必要があるのは、端末を開いて次のように入力するだけです。

```bash
$ curl https://sh.rustup.rs -sSf | sh
```

台譜を入荷して導入を開始します。
すべてがうまくいくと、これが表示されます。

```text
Rust is installed now. Great! 
```

Windowsに導入するのは簡単です。 [rustup-init.exe]入荷して実行して[rustup-init.exe]。
操作台に導入を開始し、上記のメッセージを表示します。

その他の導入選択肢と情報については、Rust Webサイトの[install]ページを参照してください。

[rustup-init.exe]: https://win.rustup.rs
 [install]: https://www.rust-lang.org/install.html


## 撤去

Rustを取り除くのは、それを導入するのと同じくらい簡単です。

```bash
$ rustup self uninstall
```

## 困ったときは

Rustが導入されている場合は、司得を開いて次のように入力します。

```bash
$ rustc --version
```

版番号、ハッシュコミット、およびコミット日付が表示されます。

もしそうなら、Rustは正常に導入されました！　
おめでとう！　

そうしなければ、おそらく`PATH`環境変数にCargoの二進譜ディレクトリ、UNIXでは`~/.cargo/bin` `%USERPROFILE%\.cargo\bin`、Windowsでは`%USERPROFILE%\.cargo\bin`が含まれていないことを意味します。
これはRust開発道具が存在するディレクトリであり、ほとんどのRust開発者は`PATH`環境変数にそれを`rustc`しているので、命令行で`rustc`を実行することができます。
オペレーティングシステム、命令司得、および導入時のバグの違いにより、司得を再起動したり、システムからログアウトしたり、`PATH`手動で設定したりする必要があります。

Rustは独自のリンクをしないので、結合器を導入する必要があります。
そうすることは、あなたの特定のシステムに依存します。
Linuxベースのシステムの場合、Rustはリンクのために`cc`を呼び出そうとします。
`windows-msvc`（Microsoft Visual StudioでWindows上に構築されたRust）では、これは[Microsoft Visual C ++組み上げ道具が][msvbt]導入されているかどうかによって異なり[ます][msvbt]。
`rustc`がそれらを自動的に見つけるので、これらは`%PATH%`必要はありません。
一般的に、非伝統的な場所に結合器がある場合、`/path/to/cc`は結合器パスを指す必要がある`rustc linker=/path/to/cc`を呼び出すことができます。

[msvbt]: http://landinghub.visualstudio.com/visual-cpp-build-tools

あなたがまだ立ち往生しているなら、助けを得ることができる場所がいくつかあります。
最も簡単である[irc.mozilla.orgの＃Rust-初心者のIRCチャネル][irc-beginners]や一般的な議論のための[irc.mozilla.orgの#rust IRCチャネル][irc]介してアクセスすることができ、[Mibbit][mibbit]。
それから私たちを助けることができる他のRustびた人（私たち自身と呼ぶ愚かなニックネーム）とチャットします。
その他の素晴らしい資源には[、ユーザーフォーラム][users]と[スタック・オーバーフローがあり][stackoverflow]ます。

[irc-beginners]: irc://irc.mozilla.org/#rust-beginners
 [irc]: irc://irc.mozilla.org/#rust
 [mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-beginners,%23rust
 [users]: https://users.rust-lang.org/
 [stackoverflow]: http://stackoverflow.com/questions/tagged/rust


この導入譜は、開発資料集のコピーもローカルに導入するので、オフ行で読むことができます。
それは唯一の`rustup doc`です！　

# こんにちは世界！　

Rustを導入したので、最初のRust算譜を書くのを手伝います。
従来新しい言語を学んで、"Hello、world！　"という文言を画面に表示する小さな算譜を書いています。この章では、その伝統に従います。

このようなシンプルな算譜を使い始めることの良い点は、製譜器が導入されていることと、正しく動作していることを素早く確認できることです。
画面に情報を印字することも非常に一般的なことです。早く練習することは良いことです。

> > 注意。この説明書では、命令行についての基本的な知識があることを前提としています。
> > Rustそのものは、編集、道具立て、譜面がどこに保存されているかについて特別な要求をしません。そのため、命令行へのIDEを望むなら、それは選択肢です。
> > あなたは、Rustを念頭に置いて作られた[SolidOak]をチェックしたいかもしれません。
> > コミュニティの開発にはいくつかの拡張があり、Rustチームは[various editors]用のプラグインを提供し[various editors]ます。
> > 書房またはIDEの設定はこのチュートリアルの範囲外です。具体的な設定については、開発資料をチェックしてください。

[SolidOak]: https://github.com/oakes/SolidOak
 [various editors]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md


## 企画ファイルの作成

まず、Rust譜面を入れるファイルを作ってください。Rustはあなたの譜面がどこにあるのか気にしませんが、この本ではあなたのホームディレクトリに*projects*ディレクトリを作ってそこにすべての企画を置いておくことをお勧めします。
端末を開き、次の命令を入力して、この特定の企画のディレクトリを作成します。

```bash
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

> > 注。Windows上でPowerShellを使用していない場合、`~`が機能しない可能性があります。
> > 詳細については、司得の説明書を参照してください。

## Rust算譜の作成と実行

Rust算譜用の原本を作成する必要があります。
Rustファイルは常に*.rs*拡張子で終わります。
ファイル名に複数の単語を使用している場合は、下線を使用して単語を区切ります。
たとえば、*myprogram.rs*ではなく*my_program.rs*を使用します。

さて、新しいファイルを作り、それを*main.rs*と呼んで*ください*。
ファイルを開き、次の譜面を入力します。

```rust
fn main() {
    println!("Hello, world!");
}
```

ファイルを保存して、端末窓に戻ります。
LinuxまたはmacOSの場合は、次の命令を入力します。

```bash
$ rustc main.rs
$ ./main
Hello, world!
```

Windowsでは`main`を`main.exe`に置き換えて`main.exe`。
オペレーティングシステムにかかわらず、文字列`Hello, world!`という文字列が端末に表示されます。
あなたがしたら、おめでとう！　
あなたは正式にRust算譜を書いています。
それであなたはRustの演譜師になります！　
ようこそ。

## Rust算譜の解剖

今、あなたの「こんにちは、世界！　」で起こったことを見て行きましょう。
詳細な算譜。
パズルの最初の部分は次のとおりです。

```rust
fn main() {

}
```

これらの行は、Rustの*機能*を定義し*ます*。
`main`機能は特別です。すべてのRust算譜の始まりです。
最初の行では、「引数を取らずに何も返さない`main`という機能を宣言しています」引数があれば、それらはかっこの中に入ります（`(`と`)`）。機能では、戻り値の型を完全に省略することができます。

機能本体は中かっこ（`{`と`}`）で囲まれています。
Rustはすべての機能体の周りにこれらを必要とします。
開始中かっこを機能宣言と同じ行に置き、その間に1つのスペースを入れるのは良いスタイルだと考えられます。

`main()`機能の内部。

```rust
    println!("Hello, world!");
```

この行は、この小さな算譜のすべての作業を行います。画面に文言を印字します。
ここで重要な多くの詳細があります。
1つは、タブではなく4つのスペースで字下げされていることです。

2番目の重要な部分は`println!()`行です。
これは、Rust *[マクロ]を*呼び出しています。これは、Rustでメタ演譜が行われる方法です。
代わりに機能を呼び出していた場合は、`println()`（！　なし`println()`ようになります。
Rustマクロについては、後で詳しく説明しますが、今のところ、通常の機能の代わりにマクロを呼び出すことを意味する`!`を知る必要があります。


[macro]: macros.html

次は`"Hello, world!"`という*文字列*です。
文字列は、システム演譜言語では驚くほど複雑な話題であり、*[静的に割り当てられた]*文字列です。
この文字列を`println!`への引数として渡します。この文字列は画面に文字列を出力します。
十分に簡単！　

[statically allocated]: the-stack-and-the-heap.html

行はセミコロン（`;`）で終わり`;`。
Rustは*[式指向言語]*です。つまり、ほとんどのことは文ではなく式です。
`;`
この式が終了し、次の式が開始する準備ができていることを示します。
ほとんどの行のRust譜面はaで終わり`;`
。

[expression-oriented language]: glossary.html#expression-oriented-language

## 製譜と実行は別々の手順です

「Rust算譜の作成と実行」では、新しく作成した算譜を実行する方法を示しました。
その過程を打ち破り、それぞれのステップを今調べます。

Rust算譜を実行する前に、それを製譜する必要があります。
Rust製譜器を使用するには、`rustc`命令を入力し、原本の名前を次のように渡します。

```bash
$ rustc main.rs
```

CまたはC ++の経験がある来た場合、これは`gcc`または`clang`似ていることが`clang`ます。
正常に製譜した後、Rustは二進譜実行可能ファイルを出力する必要があります。この実行可能ファイルは、LinuxまたはMacOS上で、次のように`ls`命令を司得に入力すると表示されます。

```bash
$ ls
main  main.rs
```

Windowsでは、次のように入力します。

```bash
$ dir
main.exe
main.rs
```

これは、原譜と拡張子が`.rs` 2つのファイルと、実行可能ファイル（Windowsの場合は`main.exe`、他のすべては`main`）です。
ここからやるべきことは、`main`や`main.exe`ファイルを次のように実行することです。

```bash
$ ./main  # or .\main.exe on Windows
```

*main.rs*があなたの「こんにちは、世界！　
これはあなたの端末に`Hello, world!`を出力します。

Ruby、Python、JavaScriptなどの動的言語を使用している場合、別の手順で算譜を製譜して実行することはできません。
Rustは*先に製譜された*言語です。つまり、算譜を製譜して他の人に与えることができ、Rustを導入しなくても実行できます。
一方、`.rb`ファイルまたは`.py`または`.js`ファイルを提供する場合は、Ruby、Python、またはJavaScript実装をそれぞれ導入する必要がありますが、算譜を製譜して実行するには1つの命令だけが必要です。
すべてが言語設計の相殺取引です。

`rustc`を`rustc`製譜するだけで簡単な算譜はうまくいきますが、企画が成長するにつれて、企画にあるすべての選択肢を管理し、他の人や企画と譜面を簡単に共有できるようにしたいと考えています。
次に、Cargoという道具を導入しましょう。実際のRust算譜を書くのに役立ちます。

# こんにちは、カーゴ！　

CargoはRustの組立系とパッケージ管理系ーであり、ラステーシャンはRust企画を管理するためにCargoを使用しています。
Cargoは、譜面の構築、譜面が依存する譜集の入荷、およびそれらの譜集の構築といった3つのことを管理します。
あなたの譜面はそれらに依存しているので、譜集にあなたの譜面が必要とするものを「依存関係」と呼びます。

最も単純なRust算譜は依存性がないので、今はその機能の最初の部分のみを使用します。
もっと複雑なRust算譜を書いていくうちに、依存関係を追加したいと思っています。そして、Cargoを使い始めた方がはるかに簡単です。

膨大な数のRust企画がCargoを使用しているので、あなたはそれを他の本のために使用していると想定します。
あなたが公式の導入譜を使用した場合、CargoにはRust自身が導入されています。
Rustを他の手段で導入した場合は、次のように入力してCargoが導入されているかどうかを確認できます。

```bash
$ cargo --version
```

端末に。
版番号が表示されている場合は、素晴らしい！　
' `command not found` 'のような誤りが表示された場合は、Rustを導入したシステムの開発資料を参照して、Cargoが分離しているかどうかを判断する必要があります。

## カーゴに変換する

Hello World算譜をCargoに変換しましょう。
企画をカーゴにするには、次の3つのことを行う必要があります。

1. あなたの原本を正しいディレクトリに置きます。
2. 古い実行可能ファイル（Windowsの`main.exe`、他のすべての`main`）を取り除く。
3. カーゴ設定ファイルを作成します。

始めましょう！　

### ソースディレクトリの作成と古い実行ファイルの削除

まず、端末に戻り、*hello_world*ディレクトリに移動し、次の命令を入力します。

```bash
$ mkdir src
$ mv main.rs src/main.rs # or 'move main.rs src/main.rs' on Windows
$ rm main  # or 'del main.exe' on Windows
```

Cargoはあなたの原本が*src*ディレクトリ内に存在することを期待しています。
これにより、最上位の企画ディレクトリ（この場合は*hello_world*）に、README、ライセンス情報、および譜面に関係のないものが残ります。
このように、Cargoを使用すると、企画をきれいに整えておくことができます。
すべての場所があり、すべてがその場所にあります。

*main.rs*を*src*ディレクトリに移動し、`rustc`作成した製譜済みファイルを削除します。
いつものように、Windowsの場合`main`を`main.exe`に置き換えてください。

この例では、原本名として`main.rs`を保持しているため、実行可能ファイルが作成されています。
代わりに譜集を作成したい場合は、ファイル名を`lib.rs`ます。
この慣用的名前は、Cargoによって企画の製譜に使用されますが、必要に応じて上書きできます。

### 構成ファイルの作成

次に、*hello_world*ディレクトリ内に新しいファイルを作成し、`Cargo.toml`という`Cargo.toml`ます。

`Cargo.toml`で`C`を大文字にしてください。そうしないと、Cargoは設定ファイルの処理方法を知らないでしょう。

このファイルは*[TOML]*（Tom's Obvious、Minimal Language）形式です。
TOMLはINIに似ていますが、いくつかの追加機能があり、Cargoの設定形式として使用されています。

[TOML]: https://github.com/toml-lang/toml

このファイルの中に、次の情報を入力します。

```toml
[package]

name = "hello_world"
version = "0.0.1"
authors = [ "Your name <you@example.com>" ]
```

最初の行`[package]`は、次の文がパッケージを構成していることを示します。
このファイルに情報を追加すると、他の章も追加されますが、今のところパッケージの設定のみが行われています。

他の3行は、あなたの算譜を製譜するためにCargoが知っておく必要がある3ビットの設定を設定します。名前、版、版

この情報を*Cargo.toml*ファイルに追加したら、保存して設定ファイルの作成を完了します。

## カーゴ企画の構築と実行

*Cargo.toml*ファイルを企画のルートディレクトリに置き、Hello World算譜を組み上げして実行する準備ができているはずです。
これを行うには、次の命令を入力します。

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
$ ./target/debug/hello_world
Hello, world!
```

バム！　
すべてうまくいけば、`Hello, world!`もう一度端末に印字してください。

あなたは単に`cargo build`企画を`cargo build`し、. `./target/debug/hello_world`で走らせましたが、実際には両方とも、以下のように`cargo run`て1つのステップで行うことができます。

```bash
$ cargo run
     Running `target/debug/hello_world`
Hello, world!
```

`run`命令は、企画を迅速に反復処理する必要がある場合に便利です。

この例は企画を再構築しなかったことに注意してください。
Cargoはファイルが変更されていないと判断し、二進譜を実行しました。
原譜を変更した場合、Cargoは企画を実行する前に企画を再構築しています。

```bash
$ cargo run
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

Cargoは、企画のファイルが変更されたかどうかを確認し、最後に組み上げしてから変更があった場合にのみ企画を再構築します。

シンプルな企画では、Cargoは`rustc`だけを使用しているだけではありませんが、将来的には便利になります。
これは、あなたが通い箱を使用し始めたときに特に当てはまります。
これらは他の演譜言語の '譜集'または 'パッケージ'と同義です。
複数の通い箱で構成される複雑な企画の場合、Cargoに組み上げを調整させるのはずっと簡単です。
カーゴを使用`cargo build`、 `cargo build`を実行することができ、正しい方法で動作するはずです。

### リリースのための組み上げ

企画のリリース準備が整ったら、`cargo build --release`を使用して企画を最適化して製譜できます。
これらの最適化により、Rust譜面はより速く実行されますが、これらを有効にすると、算譜の製譜時間が長くなります。
これは、開発用のプロファイルと、ユーザーに与える最終的な算譜を構築するプロファイルの2つのプロファイルが存在する理由です。

### `Cargo.lock`とは何でしょうか？　

`cargo build`実行`cargo build`と、Cargoは*Cargo.lock*という新しいファイルを作成します。これは次のようになります。

```toml
[root]
name = "hello_world"
version = "0.0.1"
```

Cargoは*Cargo.lock*ファイルを使用して譜体の依存関係を追跡します。
これはHello World企画の*Cargo.lock*ファイルです。
この企画は依存関係がないので、ファイルは少しばかりです。
現実的に、あなたはこのファイルを自分で触れる必要はありません。
Cargoにそれを処理させてください。

それでおしまい！　
あなたがフォローしてきたなら、Cargoで`hello_world`を正常に構築しておく必要があります。

企画はシンプルですが、現在はRustの残りの仕事に使用する実際の道具の多くを使用しています。
実際には、以下の命令でいくつかのバリエーションを使ってほぼ全てのRust企画を開始することが期待できます。

```bash
$ git clone someurl.com/foo
$ cd foo
$ cargo build
```

## 新しいカーゴ企画を簡単にする

新しい企画を開始するたびに、前の過程を終了する必要はありません。
カーゴはすぐに開発を開始できる骨組みだけの企画ディレクトリをすぐに作ることができます。

Cargoで新規企画を開始するには、命令行で`cargo new`入力します。

```bash
$ cargo new hello_world --bin
```

この命令は、譜集ではなく、実行可能な譜体を作成することを目的としているため、--`--bin`を`--bin`ます。
実行可能ファイルは、*二進譜*と呼ばれることがよくあります（UNIXシステムの場合は、`/usr/bin`ように）。

Cargoは2つのファイルと1つのディレクトリを生成しています`Cargo.toml`と*src*ディレクトリに*main.rs*ファイルがあります。
これらはよく知られているはずです。

この出力は、始めに必要なものです。
まず、`Cargo.toml`開き`Cargo.toml`。
これは次のようになります。

```toml
[package]

name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
```

`[dependencies]`行を心配しないで、後でそれに戻ります。

Cargoは、*Cargo.tomlに*与えた引数と`git`全体設定に基づいて、適切な黙用値を設定しています。
Cargoが`hello_world`ディレクトリを`git`リポジトリとして初期化していることに気付くかもしれません。

`src/main.rs`は何が必要でしょうか？　

```rust
fn main() {
    println!("Hello, world!");
}
```

カーゴは "ハローワールド！　"を生成しました。
あなたのために、あなたは作譜を開始する準備ができています！　

> > 注。カーゴをより詳細に見たい場合は、すべての機能をカバーする公式の[Cargo guide]を参照してください。

[Cargo guide]: http://doc.crates.io/guide.html

# 終わりの思考

この章では、この本の残りの部分で十分に役立つ基本と、Rustの残りの部分について説明しました。
道具を手に入れたので、Rust言語そのものについて詳しく説明します。

2つの選択肢があります。「 [チュートリアル。ゲーム][guessinggame]の[推測][guessinggame] 」を使って企画に潜入するか、下から始めて「 [構文と意味論][syntax] 」で作業してください。
より経験豊富なシステム演譜師は、おそらく「チュートリアル。推測ゲーム」を好むでしょうが、動的な背景の演譜師もどちらかを楽しむことができます。
さまざまな人々が違った方法で学ぶ！　
あなたに合ったものを選んでください。

[guessinggame]: guessing-game.html
 [syntax]: syntax-and-semantics.html

