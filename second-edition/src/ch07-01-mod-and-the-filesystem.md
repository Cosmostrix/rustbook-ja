## `mod`とファイルシステム

Cargoで新しい企画を作成することで<ruby>役区<rt>モジュール</rt></ruby>例を開始しますが、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱を作成する代わりに、他の人が依存関係として企画に取り込めるような譜集<ruby>通い箱<rt>クレート</rt></ruby>を作成します。
たとえば、第2章で説明した`rand` crateは、推測ゲーム企画の依存関係として使用した譜集<ruby>通い箱<rt>クレート</rt></ruby>です。

一般的なネットワーク機能を提供する<ruby>譜集<rt>ライブラリー</rt></ruby>のスケルトンを作成します。
<ruby>役区<rt>モジュール</rt></ruby>と機能の構成に集中しますが、機能本体にどのような<ruby>譜面<rt>コード</rt></ruby>が含まれるかについては心配しません。
<ruby>譜集<rt>ライブラリー</rt></ruby>`communicator`電話をします。
<ruby>譜集<rt>ライブラリー</rt></ruby>を作成するには、-`--lib`代わりに`--bin`<ruby>選択肢<rt>オプション</rt></ruby>を`--lib`ます。

```text
$ cargo new communicator --lib
$ cd communicator
```

Cargoは*src/main.rsの*代わりに*src/lib.rsを*生成したことに注意して*ください*。
*src/lib.rsの*中には次のものがあります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
```

Cargoは、--`--bin`<ruby>選択肢<rt>オプション</rt></ruby>を使用したときに得られる "Hello、world！　"<ruby>二進譜<rt>バイナリ</rt></ruby>ではなく、<ruby>譜集<rt>ライブラリー</rt></ruby>を起動するためのサンプルテストを作成します。
この章で後述する「 `super`<ruby>役区<rt>モジュール</rt></ruby>を使用して親<ruby>役区<rt>モジュール</rt></ruby>にアクセスする」の`#[]`と`mod tests`構文を見ていきますが、この<ruby>譜面<rt>コード</rt></ruby>は*src/lib.rsの最後に置いてください*。

*src/main.rs*ファイルがないので、Cargoが`cargo run`命令で実行するものはありません。
したがって、<ruby>譜集<rt>ライブラリー</rt></ruby>`cargo build`命令を使用して、譜集<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>します。

<ruby>譜面<rt>コード</rt></ruby>の意図に応じて、さまざまな状況に適した<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>を整理するためのさまざまな<ruby>選択肢<rt>オプション</rt></ruby>を見ていきます。

### <ruby>役区<rt>モジュール</rt></ruby>定義

`communicator`ネットワーキング・<ruby>譜集<rt>ライブラリー</rt></ruby>については、`connect`という機能の定義を含む`network`という名前の<ruby>役区<rt>モジュール</rt></ruby>をまず定義します。
Rustのすべての<ruby>役区<rt>モジュール</rt></ruby>定義は`mod`予約語で始まります。
この<ruby>譜面<rt>コード</rt></ruby>をテスト<ruby>譜面<rt>コード</rt></ruby>の上の*src/lib.rs*ファイルの先頭に追加します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
mod network {
    fn connect() {
    }
}
```

`mod`予約語の後に​​、<ruby>役区<rt>モジュール</rt></ruby>名、`network`、そして譜面<ruby>段落<rt>ブロック</rt></ruby>を中かっこで入れます。
この<ruby>段落<rt>ブロック</rt></ruby>内のすべてが名前空間`network`内にあります。
この場合、`connect`という単一の機能があります。
この機能を`network`<ruby>役区<rt>モジュール</rt></ruby>外の<ruby>譜面<rt>コード</rt></ruby>から呼び出す場合は、<ruby>役区<rt>モジュール</rt></ruby>を指定して、namespace構文`::` `network::connect()`を使用する必要があります。

同じ*src/lib.rs*ファイルに複数の<ruby>役区<rt>モジュール</rt></ruby>を並べて配置することもできます。
たとえば、`connect`という名前の機能を持つ`client`<ruby>役区<rt>モジュール</rt></ruby>を追加するには、リスト7-1のように追加します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
mod network {
    fn connect() {
    }
}

mod client {
    fn connect() {
    }
}
```

<span class="caption">リスト7-1。 <em>src/lib.rsに</em>並んで定義された<code>network</code>役区と<code>client</code>役区</span>

今度は`network::connect`機能と`client::connect`機能があります。
これらは完全に異なる機能を持つことができ、機能名は異なる<ruby>役区<rt>モジュール</rt></ruby>に存在するため、互いに競合しません。

この場合、<ruby>譜集<rt>ライブラリー</rt></ruby>を構築しているので、<ruby>譜集<rt>ライブラリー</rt></ruby>を構築するための<ruby>開始地点<rt>エントリーポイント</rt></ruby>となるファイルは*src/lib.rs*です。
しかし、<ruby>役区<rt>モジュール</rt></ruby>の作成に関しては、*src/lib.rsに*特別なことは何もありません。
<ruby>譜集<rt>ライブラリー</rt></ruby>*crateのsrc/lib.rsに*<ruby>役区<rt>モジュール</rt></ruby>を作成するのと同じ方法で、*src/main.rsに*<ruby>役区<rt>モジュール</rt></ruby>を作成して<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱を作成することもできます。
実際には、<ruby>役区<rt>モジュール</rt></ruby>を<ruby>役区<rt>モジュール</rt></ruby>内に置くことができます。これは、関連する機能をまとめて機能を分離するために<ruby>役区<rt>モジュール</rt></ruby>が大きくなるにつれて役立ちます。
<ruby>譜面<rt>コード</rt></ruby>を整理する方法は、<ruby>譜面<rt>コード</rt></ruby>の各部分の関係をどのように考えるかによって異なります。
例えば、リスト7-2のように、`client`<ruby>譜面<rt>コード</rt></ruby>とその`connect`機能が、代わりに`network`名前空間の内部にある場合、<ruby>譜集<rt>ライブラリー</rt></ruby>の利用者にとっては意味があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
mod network {
    fn connect() {
    }

    mod client {
        fn connect() {
        }
    }
}
```

<span class="caption">リスト7-2。 <code>client</code>役区を<code>network</code>役区内で移動する</span>

*src/lib.rs*ファイルで、既存の`mod network`と`mod client`定義をリスト7-2の`mod client`定義に置き換えます。リスト7-2の`mod client`定義は、`network`内部<ruby>役区<rt>モジュール</rt></ruby>として`client`<ruby>役区<rt>モジュール</rt></ruby>を持ち`network`。
機能`network::connect`と`network::client::connect`はどちらも`connect`という名前ですが、異なる名前空間にあるため互いに矛盾しません。

このようにして、<ruby>役区<rt>モジュール</rt></ruby>は階層を形成します。
*src/lib.rs*の内容は最上位にあり、下位<ruby>役区<rt>モジュール</rt></ruby>は下位にあります。
リスト7-1の例の構成は、階層として考えられているように見えます。

```text
communicator
 ├── network
 └── client
```

リスト7-2の例に対応する階層を次に示します。

```text
communicator
 └── network
     └── client
```

階層は、リスト7-2の`client`が兄弟ではなく`network`<ruby>役区<rt>モジュール</rt></ruby>の子であることを示してい`client`。
より複雑な企画は多くの<ruby>役区<rt>モジュール</rt></ruby>を持つことができ、それらを追跡するために<ruby>論理<rt>ロジック</rt></ruby>的に編成する必要があります。
企画における "<ruby>論理<rt>ロジック</rt></ruby>的"とは、あなたと<ruby>譜集<rt>ライブラリー</rt></ruby>の利用者が企画の特定領域についてどう思うかによって異なります。
ここに示す技法を使用して、任意の構造でサイドバイサイド<ruby>役区<rt>モジュール</rt></ruby>と入れ子になった<ruby>役区<rt>モジュール</rt></ruby>を作成します。

### 他のファイルへの<ruby>役区<rt>モジュール</rt></ruby>の移動

<ruby>役区<rt>モジュール</rt></ruby>は、階層構造を形成します。これは、あなたが慣れ親しんだコンピューティングのもう一つの構造と同じです。ファイルシステム！　
Rustの<ruby>役区<rt>モジュール</rt></ruby>体系と複数のファイルを使ってRust企画を分けることができるので、*src/lib.rs*や*src/main.rsに*すべてが存在するわけではありません。
この例では、リスト7-3の<ruby>譜面<rt>コード</rt></ruby>から始めましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
mod client {
    fn connect() {
    }
}

mod network {
    fn connect() {
    }

    mod server {
        fn connect() {
        }
    }
}
```

<span class="caption">リスト7-3。3つの<ruby>役区<rt>モジュール</rt></ruby>、 <code>client</code> 、 <code>network</code> 、 <code>network::server</code> 。全て<em>src/lib.rsで</em>定義されてい<code>network::server</code> 。</span>

*src/lib.rs*ファイルには、次の<ruby>役区<rt>モジュール</rt></ruby>階層があります。

```text
communicator
 ├── client
 └── network
     └── server
```

これらの<ruby>役区<rt>モジュール</rt></ruby>に多くの機能があり、それらの機能が長くなっている場合は、このファイルをスクロールして作業したい<ruby>譜面<rt>コード</rt></ruby>を見つけるのは難しいでしょう。
機能は1つまたは複数の`mod`<ruby>段落<rt>ブロック</rt></ruby>の内部にネストされているので、機能内の<ruby>譜面<rt>コード</rt></ruby>行も長くなるようになります。
これらは、`client`、 `network`、および`server`<ruby>役区<rt>モジュール</rt></ruby>を*src/lib.rs*から分離して、それらを独自のファイルに置く良い理由になります。

まずは、代わって`client`の宣言のみで<ruby>役区<rt>モジュール</rt></ruby>譜面を`client`リスト7-4に示す<ruby>譜面<rt>コード</rt></ruby>のように見える*のsrc/lib.rs*ように<ruby>役区<rt>モジュール</rt></ruby>。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
mod client;

mod network {
    fn connect() {
    }

    mod server {
        fn connect() {
        }
    }
}
```

<span class="caption">リスト7-4。 <code>client</code>役区の内容を抽出するが、宣言は<em>src/lib.rsに残す</em></span>

ここでは`client`<ruby>役区<rt>モジュール</rt></ruby>を*宣言し*てい`client`が、<ruby>段落<rt>ブロック</rt></ruby>をセミコロンに置き換えることで、Rustに`client`<ruby>役区<rt>モジュール</rt></ruby>の<ruby>有効範囲<rt>スコープ</rt></ruby>内で定義された<ruby>譜面<rt>コード</rt></ruby>の別の場所を探すように指示します。
言い換えれば、ライン`mod client;`
これは、

```rust,ignore
mod client {
#    // contents of client.rs
    //  client.rsの内容
}
```

今度は、その<ruby>役区<rt>モジュール</rt></ruby>名で外部ファイルを作成する必要があります。
*src /*ディレクトリに*client.rs*ファイルを作成して*開き*ます。
次に、前の手順で削除した`client`<ruby>役区<rt>モジュール</rt></ruby>の`connect`機能である、次のように入力します。

<span class="filename">ファイル名。src/client.rs</span>

```rust
fn connect() {
}
```

*src/lib.rsに* `mod`を持つ`client`<ruby>役区<rt>モジュール</rt></ruby>をすでに宣言しているので、このファイルには`mod`宣言は必要ありません。
このファイルは`client`<ruby>役区<rt>モジュール</rt></ruby>の*内容*を提供するだけです。
ここに`mod client`を置くと、`client`<ruby>役区<rt>モジュール</rt></ruby>に`client`という名前の下位<ruby>役区<rt>モジュール</rt></ruby>が与えられ`client`！　

Rustは、自動的に*src/lib.rs*を見ることしか知りません。
企画にさらにファイルを追加したい場合は、*src/lib.rsの* Rustに他のファイルを見るように指示する必要があります。
これはなぜある`mod client` *SRC/lib.rs*で定義する必要があり*、SRC/client.rs*に定義することはできません。

これで企画は正常に<ruby>製譜<rt>コンパイル</rt></ruby>されますが、いくつかの警告が表示されます。
使用することを忘れないでください`cargo build`の代わりに、`cargo run`、<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>通い箱<rt>クレート</rt></ruby>ではなく、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱を持っているので。

```text
$ cargo build
   Compiling communicator v0.1.0 (file:///projects/communicator)
warning: function is never used: `connect`
 --> src/client.rs:1:1
  |
1 |/fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default

warning: function is never used: `connect`
 --> src/lib.rs:4:5
  |
4 |/    fn connect() {
5 | |     }
  | |_____^

warning: function is never used: `connect`
 --> src/lib.rs:8:9
  |
8 |/        fn connect() {
9 | |         }
  | |_________^
```

これらの警告は、使用されていない機能があることを示しています。
今はこれらの警告を心配しないでください。
この章の「 `pub`可視性の制御」の後半で説明します。
良いニュースは、それらはただの警告だということです。
企画はうまくいった！　

次に、`network`<ruby>役区<rt>モジュール</rt></ruby>を同じパターンで独自のファイルに展開しましょう。
*src/lib.rs*で、`network`<ruby>役区<rt>モジュール</rt></ruby>の本体を削除し、次のように宣言にセミコロンを追加します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
mod client;

mod network;
```

新しい*src/network.rs*ファイルを作成し、次のように入力します。

<span class="filename">ファイル名。src/network.rs</span>

```rust
fn connect() {
}

mod server {
    fn connect() {
    }
}
```

この<ruby>役区<rt>モジュール</rt></ruby>ファイルにはまだ`mod`宣言があることに注意してください。
これは、`server`を`network`下位<ruby>役区<rt>モジュール</rt></ruby>にしたいから`network`。

`cargo build`再度実行します。
成功！　
私たちにはさらに1つの抽出<ruby>役区<rt>モジュール</rt></ruby>があり`server`。
これは下位<ruby>役区<rt>モジュール</rt></ruby>、つまり<ruby>役区<rt>モジュール</rt></ruby>内の<ruby>役区<rt>モジュール</rt></ruby>なので、<ruby>役区<rt>モジュール</rt></ruby>をその<ruby>役区<rt>モジュール</rt></ruby>の名前をつけたファイルに展開する現在の方法は機能しません。
とにかく試してみると、<ruby>誤り<rt>エラー</rt></ruby>が表示されます。
まず、*src/network.rs*を変更して`mod server;`
`server`<ruby>役区<rt>モジュール</rt></ruby>の内容の代わりに。

<span class="filename">ファイル名。src/network.rs</span>

```rust,ignore
fn connect() {
}

mod server;
```

次に、*src/server.rs*ファイルを作成し、抽出した`server`<ruby>役区<rt>モジュール</rt></ruby>の内容を入力し`server`。

<span class="filename">ファイル名。src/server.rs</span>

```rust
fn connect() {
}
```

`cargo build`を実行しようとすると、リスト7-5の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
$ cargo build
   Compiling communicator v0.1.0 (file:///projects/communicator)
error: cannot declare a new module at this location
 --> src/network.rs:4:5
  |
4 | mod server;
  |     ^^^^^^
  |
note: maybe move this module `src/network.rs` to its own directory via `src/network/mod.rs`
 --> src/network.rs:4:5
  |
4 | mod server;
  |     ^^^^^^
note: ... or maybe `use` the module `server` instead of possibly redeclaring it
 --> src/network.rs:4:5
  |
4 | mod server;
  |     ^^^^^^
```

<span class="caption">譜面リスト7-5。 <code>server</code>下位<ruby>役区<rt>モジュール</rt></ruby>を<em>src/server.rs</em>に展開しようとすると<ruby>誤り<rt>エラー</rt></ruby>が発生する</span>

<ruby>誤り<rt>エラー</rt></ruby>は`cannot declare a new module at this location`は`cannot declare a new module at this location`、 `mod server;`指していると言い`mod server;`
*src/network.rsの*行。
だから*src/network.rs*は*src/lib.rsとは*何とか違っています。

リスト7-5の真ん中のメモは、実際にはまだ話していないことを指摘しているので、実際には非常に役立ちます。

```text
note: maybe move this module `network` to its own directory via
`network/mod.rs`
```

これまでに使用したのと同じファイル命名パターンを続行するのではなく、ノートで示唆していることを実行できます。

1. 親<ruby>役区<rt>モジュール</rt></ruby>の名前である*network*という名前の新しい*ディレクトリを作成し*ます。
2. *src/network.rs*ファイルを新しい*ネットワーク*ディレクトリに移動し、*src /* *network/mod.rsという*名前に変更します。
3. 下位<ruby>役区<rt>モジュール</rt></ruby>ファイル*src/server.rs*を*ネットワーク*ディレクトリに移動します。

これらの手順を実行する命令は次のとおりです。

```text
$ mkdir src/network
$ mv src/network.rs src/network/mod.rs
$ mv src/server.rs src/network
```

今、`cargo build`を実行しようと`cargo build`、<ruby>製譜<rt>コンパイル</rt></ruby>がうまくいくでしょう（ただし、まだ警告があります）。
<ruby>譜面<rt>コード</rt></ruby>リスト7-3の*src/lib.rs*にすべての<ruby>譜面<rt>コード</rt></ruby>が含まれていたときと同じように、<ruby>役区<rt>モジュール</rt></ruby>の配置はまったく同じです。

```text
communicator
 ├── client
 └── network
     └── server
```

対応するファイル配置は次のようになります。

```text
└── src
    ├── client.rs
    ├── lib.rs
    └── network
        ├── mod.rs
        └── server.rs
```

抽出したいときに`network::server`<ruby>役区<rt>モジュール</rt></ruby>を、なぜまた*、SRC /ネットワーク/ mod.rsファイル*へ*のsrc/network.rs*ファイルを変更し、ための<ruby>譜面<rt>コード</rt></ruby>入れなければならなかったの`network::server` *ネットワーク*ディレクトリに*src/network/server.rsにあり*ますか？　
なぜ単に*src/server.rsに* `network::server`<ruby>役区<rt>モジュール</rt></ruby>を抽出できないのでしょうか？　
その理由は、*server.rs*ファイルが*src*ディレクトリにある場合、Rustは`server`が`network`下位<ruby>役区<rt>モジュール</rt></ruby>であると認識していないことになります。
ここでRustの動作を明らかにするために、すべての定義が*src/lib.rsに*ある次の<ruby>役区<rt>モジュール</rt></ruby>階層の別の例を考えてみましょう。

```text
communicator
 ├── client
 └── network
     └── client
```

この例では、`client`、 `network`、および`network::client` 3つの<ruby>役区<rt>モジュール</rt></ruby>が再びあり`network::client`。
以前に<ruby>役区<rt>モジュール</rt></ruby>をファイルに解凍したのと同じ手順で、`client`<ruby>役区<rt>モジュール</rt></ruby>の*src/client.rs*を作成します。
`network`<ruby>役区<rt>モジュール</rt></ruby>の場合、*src/network.rs*を作成します。
しかし、`network::client`<ruby>役区<rt>モジュール</rt></ruby>を*src/client.rs*ファイルに*展開*することはできません。これは、最上位の`client`<ruby>役区<rt>モジュール</rt></ruby>用にすでに存在しているからです！　
*src/client.rs*ファイルに`client`と`network::client`<ruby>役区<rt>モジュール</rt></ruby>の*両方*の<ruby>譜面<rt>コード</rt></ruby>を入れることができれば、Rustは<ruby>譜面<rt>コード</rt></ruby>が`client`か`network::client`用かを知ることができません。

したがって、`network`<ruby>役区<rt>モジュール</rt></ruby>の`network::client`下位<ruby>役区<rt>モジュール</rt></ruby>用のファイルを抽出するために、*src/network.rs*ファイルの代わりに`network`<ruby>役区<rt>モジュール</rt></ruby>用のディレクトリを作成する必要がありました。
`network`<ruby>役区<rt>モジュール</rt></ruby>にある<ruby>譜面<rt>コード</rt></ruby>は*src/network/mod.rs*ファイルに入り、下位<ruby>役区<rt>モジュール</rt></ruby>`network::client`は独自の*src/network/client.rs*ファイルを持つことができます。
現在、最上位の*src/client.rs*は、`client`<ruby>役区<rt>モジュール</rt></ruby>に属する<ruby>譜面<rt>コード</rt></ruby>を明白に示してい`client`。

### <ruby>役区<rt>モジュール</rt></ruby>ファイルシステムのルール

ファイルに関する<ruby>役区<rt>モジュール</rt></ruby>のルールを要約しましょう。

* `foo`という名前の<ruby>役区<rt>モジュール</rt></ruby>に下位<ruby>役区<rt>モジュール</rt></ruby>がない場合は、`foo`の宣言を*foo.rs*という名前のファイルに配置する必要があります。
* `foo`という名前の<ruby>役区<rt>モジュール</rt></ruby>に下位<ruby>役区<rt>モジュール</rt></ruby>がある場合は、`foo`の宣言を*foo/mod.rs*という名前のファイルに配置する必要があります。

これらのルールは再帰的に適用されるため、`foo`という名前の<ruby>役区<rt>モジュール</rt></ruby>に`bar`という名前の下位<ruby>役区<rt>モジュール</rt></ruby>があり、`bar`下位<ruby>役区<rt>モジュール</rt></ruby>がない場合は、*src*ディレクトリに次のファイルがあります。

```text
└── foo
    ├── bar.rs (contains the declarations in `foo::bar`)
    └── mod.rs (contains the declarations in `foo`, including `mod bar`)
```

<ruby>役区<rt>モジュール</rt></ruby>は、`mod`予約語を使用して親<ruby>役区<rt>モジュール</rt></ruby>のファイルで宣言する必要があります。

次に、`pub`予約語について説明し、その警告を取り除きます！　
