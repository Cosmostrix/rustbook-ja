## こんにちは、カーゴ！　

CargoはRustの組立系とパッケージ管理系ーです。
ほとんどのRustびた人はこの道具を使ってRust企画を管理しています。Cargoは譜面の構築、譜面が依存する譜集の入荷、それらの譜集の構築など、多くの仕事を処理するためです。
（あなたの譜面に*依存関係*が必要な譜集を呼び出します）。

これまでに書いたような最も単純なRust算譜は、依存関係を持たない。
だから、こんにちは、世界を作りました！　
Cargo企画では、譜面の作成を担当するCargoの部分のみを使用します。
もっと複雑なRust算譜を書くと、依存関係が追加され、Cargoを使用して企画を開始すると、依存関係を追加する方がはるかに簡単になります。

Rust企画の大部分はCargoを使用しているため、この本の残りの部分では、Cargoも使用していると仮定しています。
「導入」章で説明した公式の導入譜を使用した場合、CargoにはRustが導入されます。
他の方法でRustを導入した場合、Cargoが導入されているかどうかは、端末に次のように入力して確認してください。

```text
$ cargo --version
```

版番号が表示されている場合は、それを持っています！　
`command not found`などの誤りが表示された場合は、導入方法の開発資料を参照して、カーゴを個別に導入する方法を決定してください。

### カーゴを含む企画の作成

Cargoを使用して新しい企画を作成し、オリジナルのHello、worldとどのように違うのかを見てみましょう！　
企画。
*企画*ディレクトリ（または譜面を保存することを決めた場所）に戻ます。
次に、すべてのオペレーティングシステムで、次の命令を実行します。

```text
$ cargo new hello_cargo --bin
$ cd hello_cargo
```

最初の命令は、*hello_cargo*という新しい二進譜実行可能ファイルを作成します。
`cargo new`渡された`--bin`引数は、譜集ではなく実行可能な譜体（*二進譜*と呼ばれることが多い）を作成します。
企画*hello_cargo*に名前をつけ、Cargoは同じ名前のディレクトリにファイルを作成します。

*hello_cargo*ディレクトリに移動し、ファイルを一覧表示します。
Cargoは2つのファイルと1つのディレクトリ、*つまりCargo.toml*ファイルと*main.rs*ファイルのある*src*ディレクトリを生成していることが*わかり*ます。
また、*.gitignore*ファイルとともに新しいGitリポジトリを初期化しました。

> > 注意。Gitは一般的な版管理システムです。
> > `--vcs`フラグを使用して、別の版管理システムを使用するか、または版管理システムを使用しないように、`cargo new`を変更することができます。
> > `cargo new --help`を実行すると、使用可能な選択肢が表示されます。

選択した文言書房で*Cargo.toml*を開きます。
リスト1-2の譜面に似ているはずです。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
```

<span class="caption">リスト1-2。 <em>cargo</em>によって生成された<em>Cargo.tomlの</em>内容<code>cargo new</code></span>

このファイルは[*TOML*][toml]にあり[*TOML*][toml]
 （*Tom's Obvious、Minimal Language*）形式で、これはCargoの構成形式です。

[toml]: https://github.com/toml-lang/toml

最初の行`[package]`は、次の文がパッケージを構成していることを示す章見出しです。
このファイルに情報を追加すると、他の章も追加されます。

次の3行は、Cargoが算譜を製譜するために必要な設定情報を設定します。名前、版、およびそれを書いた人。
Cargoはお使いの環境からあなたの名前とEメール情報を取得します。その情報が正しくない場合は、ここで情報を修正してからファイルを保存してください。

最後の行`[dependencies]`は、企画の依存関係のリストを表示する章の先頭です。
Rustでは、譜面のパッケージは*通い箱*と呼ばれます。
この企画では他の通い箱は必要ありませんが、第2章の最初の企画ではこの依存関係の章を使用します。

*src / main.rs*を開いて見てください。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

カーゴは、こんにちは、世界を生成しています！　
あなたのための算譜は、リスト1-1で書いたのとまったく同じです！　
これまでの企画とCargo企画の違いは、Cargoが*src*ディレクトリに譜面を配置し、*Cargo.toml*構成ファイルがトップディレクトリにあることです。

Cargoはあなたの原本が*src*ディレクトリ内に存在することを期待しています。
最上位の企画ディレクトリは、READMEファイル、ライセンス情報、設定ファイル、および譜面に関係のないその他のものです。
Cargoを使用すると、企画を整理するのに役立ちます。
すべての場所があり、すべてがその場所にあります。

あなたがハロー、世界で行ったように、カーゴを使用しない企画を開始した場合！　
それをカーゴを使用する企画に変換することができます。
企画譜面を*src*ディレクトリに移動し、適切な*Cargo.toml*ファイルを作成します。

### カーゴ企画の構築と実行

さあ、こんにちは、世界を構築して実行するときの違いを見てみましょう！　
カーゴとの算譜！　
*hello_cargo*ディレクトリから、次の命令を入力して企画を組み上げします。

```text
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

この命令は、現在のディレクトリではなく、*target / debug / hello_cargo*（またはWindowsでは*target \ debug \ hello_cargo.exe*）に実行可能ファイルを作成します。
この命令で実行可能ファイルを実行することができます。

```text
$ ./target/debug/hello_cargo # or .\target\debug\hello_cargo.exe on Windows
Hello, world!
```

すべてうまくいけば、`Hello, world!`は端末に印字する必要があります。
最初に`cargo build`を実行`cargo build`と、Cargoは最上位の新しいファイル*Cargo.lock*を作成します。
このファイルは企画の依存関係の正確な版を追跡します。
この企画は依存関係がないので、ファイルは少しばかりです。
手動でこのファイルを変更する必要はありません。
カーゴはあなたのためにその内容を管理します。

`./target/debug/hello_cargo` `cargo build`て企画を`cargo build`して実行し`./target/debug/hello_cargo`、 `cargo run`使用して譜面を製譜し、実行可能な実行可能ファイルをすべて1つの命令で実行することもできます。

```text
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

今回は、Cargoが`hello_cargo`を製譜していたことを示す出力が表示されなかったことに注意してください。
Cargoはファイルが変更されていないことを知ったので、二進譜を実行しました。
原譜を変更した場合、Cargoは企画を実行する前に企画を再構築しています。この出力は次のようになります。

```text
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

カーゴには、`cargo check`と呼ばれる命令もあります。
この命令は、譜面が製譜されているかどうかをすぐにチェックしますが、実行可能ファイルは生成しません。

```text
$ cargo check
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

なぜあなたは実行可能ファイルを望んでいませんか？　
多くの場合、`cargo check`よりもはるかに高速である`cargo build`それが実行可能ファイルを生成するステップをスキップしているため、。
譜面の作成中に作業を継続的にチェックしている場合は、`cargo check`を使用`cargo check`と過程がスピードアップします！　
このように、多くのRustびた人は定期的に`cargo check`を行い、製譜を確実にするために算譜を書く。
次に、実行可能ファイルを使用する準備ができたら、`cargo build`実行します。

これまでにカーゴについて学んだことを要約しましょう。

* `cargo build`または`cargo check`を使用して企画を構築することができます。
* `cargo run`を使って1つのステップで企画を構築し、実行することができ`cargo run`。
* 組み上げ結果を譜面と同じディレクトリに保存する代わりに、Cargoは*目標/虫取り*ディレクトリに格納します。

Cargoを使用することのもう一つの利点は、あなたが作業しているオペレーティングシステムに関係なく命令が同じであることです。
だから、現時点では、LinuxとmacOS対Windowsのための具体的な手順は提供しなくなります。

### リリースのための組み上げ

あなたの企画が最終的にリリース準備が整ったら、`cargo build --release`を使って最適化で製譜`cargo build --release`ことができます。
この命令は、*target / debugの*代わりに*target / release*に実行可能ファイルを作成します。
最適化によってRust譜面はより速く実行されますが、算譜を製譜するのにかかる時間が長くなります。
これは、2つの異なるプロファイルがあります。1つは開発用、もう1つは迅速かつ頻繁に再構築するため、もう1つは繰り返しリ組み上げされないで、可能。
譜面の実行時間をベンチマークしている場合、`cargo build --release`とbenchmarkを*target / releaseの*実行可能ファイルで実行してください。

### 慣例としてのカーゴ

単純な企画では、Cargoは`rustc`を使用するだけでは価値がありませんが、算譜が複雑になるにつれてその価値は証明されます。
複数の通い箱で構成される複雑な企画では、Cargoが組み上げを調整するのがずっと簡単です。

`hello_cargo`企画はシンプルですが、残りのRustのキャリアで使用する実際の道具の多くを使用します。
実際、既存の企画を操作するには、次の命令を使用してGitを使って譜面をチェックアウトし、その企画のディレクトリに変更して組み上げします。

```text
$ git clone someurl.com/someproject
$ cd someproject
$ cargo build
```

カーゴの詳細については、[its documentation]し[its documentation]ください。

[its documentation]: https://doc.rust-lang.org/cargo/

## 概要

あなたはすでにRustびた旅の素晴らしいスタートを切っています！　
この章では、以下の方法を学習しました。

* `rustup`を使用して最新の安定版Rustを導入して`rustup`
* より新しいRust版へのアップデート
* ローカルに導入された開発資料を開く
* こんにちは、世界を書いて実行してください！　
   `rustc`直接使用している算譜
* Cargoの規則を使用して新しい企画を作成して実行する

これは、Rustの譜面の読み書きに慣れるためのより充実した算譜を構築する素晴らしい時間です。
したがって、第2章では、推測ゲーム算譜を作成します。
Rustで一般的な演譜の概念がどのように機能するかを学ぶことから始める場合は、第3章を参照してから第2章に戻ります。
