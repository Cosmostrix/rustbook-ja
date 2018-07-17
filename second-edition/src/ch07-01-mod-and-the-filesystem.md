## `mod`とファイル算系

Cargoで新しい企画を作成することで役区例を開始しますが、二進譜通い箱を作成する代わりに、他の人が依存関係として企画に取り込めるような譜集通い箱を作成します。
たとえば、第2章で説明した`rand` crateは、推測ゲーム企画の依存関係として使用した譜集通い箱です。

一般的なネットワーク機能を提供する譜集のスケルトンを作成します。
役区と機能の構成に集中しますが、機能本体にどのような譜面が含まれるかについては心配しません。
譜集`communicator`電話をします。
譜集を作成するには、-`--lib`代わりに`--bin`選択肢を`--lib`ます。

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

Cargoは、--`--bin`選択肢を使用したときに得られる "Hello、world！　"二進譜ではなく、譜集を起動するためのサンプルテストを作成します。
この章で後述する「 `super`役区を使用して親役区にアクセスする」の`#[]`と`mod tests`構文を見ていきますが、この譜面は*src/lib.rsの最後に置いてください*。

*src/main.rs*ファイルがないので、Cargoが`cargo run`命令で実行するものはありません。
したがって、譜集`cargo build`命令を使用して、譜集通い箱の譜面を製譜します。

譜面の意図に応じて、さまざまな状況に適した譜集の譜面を整理するためのさまざまな選択肢を見ていきます。

### 役区定義

`communicator`ネットワーキング・譜集については、`connect`という機能の定義を含む`network`という名前の役区をまず定義します。
Rustのすべての役区定義は`mod`予約語で始まります。
この譜面をテスト譜面の上の*src/lib.rs*ファイルの先頭に追加します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
mod network {
    fn connect() {
    }
}
```

`mod`予約語の後に​​、役区名、`network`、そして譜面段落を中かっこで入れます。
この段落内のすべてが名前空間`network`内にあります。
この場合、`connect`という単一の機能が`connect`ます。
この機能を`network`役区外の譜面から呼び出す場合は、役区を指定して、namespace構文`::` `network::connect()`を使用する必要があります。

同じ*src/lib.rs*ファイルに複数の役区を並べて配置することもできます。
たとえば、`connect`という名前の機能を持つ`client`役区を追加するには、リスト7-1のように追加します。

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
これらは完全に異なる機能を持つことができ、機能名は異なる役区に存在するため、互いに競合しません。

この場合、譜集を構築しているので、譜集を構築するための開始地点となるファイルは*src/lib.rs*です。
しかし、役区の作成に関しては、*src/lib.rsに*特別なことは何もありません。
譜集*crateのsrc/lib.rsに*役区を作成するのと同じ方法で、*src/main.rsに*役区を作成して二進譜通い箱を作成することもできます。
実際には、役区を役区内に置くことができます。これは、関連する機能をまとめて機能を分離するために役区が大きくなるにつれて役立ちます。
譜面を整理する方法は、譜面の各部分の関係をどのように考えるかによって異なります。
例えば、リスト7-2のように、`client`譜面とその`connect`機能が、代わりに`network`名前空間の内部にある場合、譜集の利用者にとっては意味があります。

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

*src/lib.rs*ファイルで、既存の`mod network`と`mod client`定義をリスト7-2の`mod client`定義に置き換えます。リスト7-2の`mod client`定義は、`network`内部役区として`client`役区を持ち`network`。
機能`network::connect`と`network::client::connect`はどちらも`connect`という名前ですが、異なる名前空間にあるため互いに矛盾しません。

このようにして、役区は階層を形成します。
*src/lib.rs*の内容は最上位にあり、下位役区は下位にあります。
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

階層は、リスト7-2の`client`が兄弟ではなく`network`役区の子であることを示してい`client`。
より複雑な企画は多くの役区を持つことができ、それらを追跡するために論理的に編成する必要があります。
企画における "論理的"とは、あなたと譜集の利用者が企画の特定領域についてどう思うかによって異なります。
ここに示す技法を使用して、任意の構造でサイドバイサイド役区と入れ子になった役区を作成します。

### 他のファイルへの役区の移動

役区は、階層構造を形成します。これは、あなたが慣れ親しんだコンピューティングのもう一つの構造と同じです。ファイル算系！　
Rustの役区算系と複数のファイルを使ってRust企画を分けることができるので、*src/lib.rs*や*src/main.rsに*すべてが存在するわけではありません。
この例では、リスト7-3の譜面から始めましょう。

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

<span class="caption">リスト7-3。3つの役区、 <code>client</code> 、 <code>network</code> 、 <code>network::server</code> 。全て<em>src/lib.rsで</em>定義されてい<code>network::server</code> 。</span>

*src/lib.rs*ファイルには、次の役区階層があります。

```text
communicator
 ├── client
 └── network
     └── server
```

これらの役区に多くの機能があり、それらの機能が長くなっている場合は、このファイルをスクロールして作業したい譜面を見つけるのは難しいでしょう。
機能は1つまたは複数の`mod`段落の内部にネストされているので、機能内の譜面行も長くなるようになります。
これらは、`client`、 `network`、および`server`役区を*src/lib.rs*から分離して、それらを独自のファイルに置く良い理由になります。

まずは、代わって`client`の宣言のみで役区譜面を`client`リスト7-4に示す譜面のように見える*のsrc/lib.rs*ように役区。

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

ここでは`client`役区を*宣言し*てい`client`が、段落をセミコロンに置き換えることで、Rustに`client`役区の有効範囲内で定義された譜面の別の場所を探すように指示します。
言い換えれば、行`mod client;`
これは、

```rust,ignore
mod client {
#    // contents of client.rs
    //  client.rsの内容
}
```

今度は、その役区名で外部ファイルを作成する必要があります。
*src /*階層に*client.rs*ファイルを作成して*開き*ます。
次に、前の手順で削除した`client`役区の`connect`機能である、次のように入力します。

<span class="filename">ファイル名。src/client.rs</span>

```rust
fn connect() {
}
```

*src/lib.rsに* `mod`を持つ`client`役区をすでに宣言しているので、このファイルには`mod`宣言は必要ありません。
このファイルは`client`役区の*内容*を提供するだけです。
ここに`mod client`を置くと、`client`役区に`client`という名前の下位役区が与えられ`client`！　

Rustは、自動的に*src/lib.rs*を見ることしか知りません。
企画にさらにファイルを追加したい場合は、*src/lib.rsの* Rustに他のファイルを見るように指示する必要があります。
これはなぜある`mod client` *SRC/lib.rs*で定義する必要があり*、SRC/client.rs*に定義することはできません。

これで企画は正常に製譜されますが、いくつかの警告が表示されます。
使用することを忘れないでください`cargo build`の代わりに、`cargo run`、譜集の通い箱ではなく、二進譜通い箱を持っているので。

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

次に、`network`役区を同じパターンで独自のファイルに展開しましょう。
*src/lib.rs*で、`network`役区の本体を削除し、次のように宣言にセミコロンを追加します。

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

この役区ファイルにはまだ`mod`宣言があることに注意してください。
これは、`server`を`network`下位役区にしたいから`network`。

`cargo build`再度実行します。
成功！　
私たちにはさらに1つの抽出役区があり`server`。
これは下位役区、つまり役区内の役区なので、役区をその役区の名前をつけたファイルに展開する現在の方法は機能しません。
とにかく試してみると、誤りが表示されます。
まず、*src/network.rs*を変更して`mod server;`
`server`役区の内容の代わりに。

<span class="filename">ファイル名。src/network.rs</span>

```rust,ignore
fn connect() {
}

mod server;
```

次に、*src/server.rs*ファイルを作成し、抽出した`server`役区の内容を入力し`server`。

<span class="filename">ファイル名。src/server.rs</span>

```rust
fn connect() {
}
```

`cargo build`を実行しようとすると、リスト7-5の誤りが発生します。

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

<span class="caption">譜面リスト7-5。 <code>server</code>下位役区を<em>src/server.rs</em>に展開しようとすると誤りが発生する</span>

誤りは`cannot declare a new module at this location`は`cannot declare a new module at this location`、 `mod server;`指していると言い`mod server;`
*src/network.rsの*行。
だから*src/network.rs*は*src/lib.rsとは*何とか違っています。

リスト7-5の真ん中のメモは、実際にはまだ話していないことを指摘しているので、実際には非常に役立ちます。

```text
note: maybe move this module `network` to its own directory via
`network/mod.rs`
```

これまでに使用したのと同じファイル命名パターンを続行するのではなく、ノートで示唆していることを実行できます。

1. 親役区の名前である*network*という名前の新しい*階層を作成し*ます。
2. *src/network.rs*ファイルを新しい*ネットワーク*階層に移動し、*src /* *network/mod.rsという*名前に変更します。
3. 下位役区ファイル*src/server.rs*を*ネットワーク*階層に移動します。

これらの手順を実行する命令は次のとおりです。

```text
$ mkdir src/network
$ mv src/network.rs src/network/mod.rs
$ mv src/server.rs src/network
```

今、`cargo build`を実行しようと`cargo build`、製譜がうまくいくでしょう（ただし、まだ警告があります）。
譜面リスト7-3の*src/lib.rs*にすべての譜面が含まれていたときと同じように、役区の配置はまったく同じです。

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

抽出したいときに`network::server`役区を、なぜまた*、SRC /ネットワーク/ mod.rsファイル*へ*のsrc/network.rs*ファイルを変更し、ための譜面入れなければならなかったの`network::server` *ネットワーク*階層に*src/network/server.rsにあり*ますか？　
なぜ単に*src/server.rsに* `network::server`役区を抽出できないのでしょうか？　
その理由は、*server.rs*ファイルが*src*階層にある場合、Rustは`server`が`network`下位役区であると認識していないことになります。
ここでRustの動作を明らかにするために、すべての定義が*src/lib.rsに*ある次の役区階層の別の例を考えてみましょう。

```text
communicator
 ├── client
 └── network
     └── client
```

この例では、`client`、 `network`、および`network::client` 3つの役区が再びあり`network::client`。
以前に役区をファイルに解凍したのと同じ手順で、`client`役区の*src/client.rs*を作成します。
`network`役区の場合、*src/network.rs*を作成します。
しかし、`network::client`役区を*src/client.rs*ファイルに*展開*することはできません。これは、最上位の`client`役区用にすでに存在しているからです！　
*src/client.rs*ファイルに`client`と`network::client`役区の*両方*の譜面を入れることができれば、Rustは譜面が`client`か`network::client`用かを知ることができません。

したがって、`network`役区の`network::client`下位役区用のファイルを抽出するために、*src/network.rs*ファイルの代わりに`network`役区用の階層を作成する必要がありました。
`network`役区にある譜面は*src/network/mod.rs*ファイルに入り、下位役区`network::client`は独自の*src/network/client.rs*ファイルを持つことができます。
現在、最上位の*src/client.rs*は、`client`役区に属する譜面を明白に示してい`client`。

### 役区ファイル算系のルール

ファイルに関する役区のルールを要約しましょう。

* `foo`という名前の役区に下位役区がない場合は、`foo`の宣言を*foo.rs*という名前のファイルに配置する必要があります。
* `foo`という名前の役区に下位役区がある場合は、`foo`の宣言を*foo/mod.rs*という名前のファイルに配置する必要があります。

これらのルールは再帰的に適用されるため、`foo`という名前の役区に`bar`という名前の下位役区があり、`bar`下位役区がない場合は、*src*階層に次のファイルがあります。

```text
└── foo
    ├── bar.rs (contains the declarations in `foo::bar`)
    └── mod.rs (contains the declarations in `foo`, including `mod bar`)
```

役区は、`mod`予約語を使用して親役区のファイルで宣言する必要があります。

次に、`pub`予約語について説明し、その警告を取り除きます！　
