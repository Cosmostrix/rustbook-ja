% Hello, Cargo!

【訳者註】Cargo (カーゴ) は「貨物」「積み荷」を意味します。

[Cargo][cratesio] は Rustacean 達が Rust 企画〈プロジェクト〉
の管理を楽にするために使用している補助具です。
Cargo は現在、準1.0 の状態にあり、未だ道半ばの製品です。
しかし、多くの Rust 企画に使うには十分な出来には達しており、
そういうわけで Rust 企画は最初から Cargo を使うことが想定されています。
[Cargo][cratesio] is a tool that Rustaceans use to help manage their Rust
projects. Cargo is currently in a pre-1.0 state, and so it is still a work in
progress. However, it is already good enough to use for many Rust projects, and
so it is assumed that Rust projects will use Cargo from the beginning.

[cratesio]: http://doc.crates.io

Cargo は３つのモノを管理します。譜面の織り上げ〈ビルド〉、必要になった依存物〈依存関係〉
の入荷、そして入荷された依存物の織り上げです。最初は私達の算譜に依存物が全くないので、
前者の機能だけを使うことになります。ゆくゆくは、もっと追加していくつもりです。
Cargo を使って書き始めたので追加は簡単にできるでしょう。
Cargo manages three things: building our code, downloading the dependencies our
code needs, and building those dependencies. At first, our program doesn’t have
any dependencies, so we’ll only be using the first part of its functionality.
Eventually, we’ll add more. Since we started off by using Cargo, it'll be easy
to add later.

Rust を公式の取付具から導入した場合は Cargo も入っているはずです。
Rust を他の手段で導入した場合は、導入について触れている
[Cargo の README に当たって][cargoreadme]特定の手順を踏みたいことでしょう。
If you installed Rust via the official installers you will also have Cargo. If
you installed Rust some other way, you may want to
[check the Cargo README][cargoreadme] for specific instructions about installing
it.

[cargoreadme]: https://github.com/rust-lang/cargo#installing-cargo-from-nightlies

## Cargo に移行するには
## Converting to Cargo

それでは、Hello World を Cargo に移していきましょう。
Let’s convert Hello World to Cargo.

企画を Cargo 化するためには以下の３つが必要です。設定〈ファイル〉 `Cargo.toml` の作成、
原譜の正しい場所への配置、以前の実行形式からの脱却（Windows では `main.exe`
、他では `main`）です。最後の部分から片付けましょう。
To Cargo-ify our project, we need to do three things: Make a `Cargo.toml`
configuration file, put our source file in the right place, and get rid of the
old executable (`main.exe` on Windows, `main` everywhere else). Let's do that part first:

```bash
$ mkdir src
$ mv main.rs src/main.rs
$ rm main  # Windows では 'rm main.exe'
```

> 【注意】今は実行形式を作ろうとしているので、原譜名 `main.rs` はそのままにします。
> もし代わりに〈ライブラリ〉を作りたいときは、`lib.rs` と名付けるとよいでしょう。
> この習慣的名前は Cargo が私達の企画をうまく製譜するために使用しますが、
> 望むのなら上書き変更できます。開始地点となる〈ファイル〉の場所は TOML〈ファイル〉の
> [`[lib]` または `[[bin]]`][crates-custom] 鍵〈キー〉で指定できます。
> Note: since we're creating an executable, we retain `main.rs` as the source
> filename. If we want to make a library instead, we should use `lib.rs`. This
> convention is used by Cargo to successfully compile our projects, but it can
> be overridden if we wish. Custom file locations for the entry point can be
> specified with a [`[lib]` or `[[bin]]`][crates-custom] key in the TOML file.

[crates-custom]: http://doc.crates.io/manifest.html#configuring-a-target

Cargo はすべての原譜が `src` 階層に収まっていると期待しています。こうすると最上位階層が
README 関係・許諾契約〈ライセンス〉情報・譜面に関係のないその他一切のために残ります。
Cargo は私達の企画を整然とした心地いいものに保つよう手伝ってくれます。
すべての物には置場があります。

次に、設定〈ファイル〉です。
Cargo expects our source files to live inside a `src` directory. That leaves the
top level for other things, like READMEs, license information, and anything not
related to our code. Cargo helps us keep our projects nice and tidy. A place for
everything, and everything in its place.

Next, our configuration file:

```bash
$ editor Cargo.toml # Windows では 'notepad Cargo.toml'
```

この名前は間違えないように。`C` は必ず大文字です。

中身は、
Make sure to get this name right: we need the capital `C`!

Put this inside:

```toml
[package]

name = "hello_world"
version = "0.0.1"
authors = [ "Your name <you@example.com>" ]
```

【訳者註】`Cargo.toml` は作者の国籍にかかわらず英語表記が標準です。
本書では一貫して英語表記が普通のところは訳さずに残し、目印にしています。
わからない単語は辞書や検索窓に聞いて、たゆまずに励んでください。

この〈ファイル〉は [TOML][toml] 形式です。
TOML は INI に似ていますが、特別なおまけが付いています。TOML の資料によると、
This file is in the [TOML][toml] format. TOML is similar to INI, but has some
extra goodies. According to the TOML docs,

> TOML は、明快な動作による読みやすい最小の設定〈ファイル〉形式を目指しています。
> TOML は曖昧さを残さず切り混ぜ表〈ハッシュテーブル〉に一対一対応するよう設計されました。
> TOML は広範な言語の〈データ〉構造に楽に構文解析できるはずです。
> TOML aims to be a minimal configuration file format that's easy to read due
> to obvious semantics. TOML is designed to map unambiguously to a hash table.
> TOML should be easy to parse into data structures in a wide variety of
> languages.

[toml]: https://github.com/toml-lang/toml

一回この〈ファイル〉をあるべき企画の最上階へと置くと、
織り上げ〈ビルド〉の準備ができたはずです！ そうするには、実行↓
Once we have this file in place in our project's root directory, we should be
ready to build! To do so, run:

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/あなたの名前/projects/hello_world)
$ ./target/debug/hello_world
Hello, world!
```

ドン！ いま `cargo build` を使い私達の企画を織ったあと `./target/debug/hello_world`
にて実行しました。`cargo run` なら両方とも一発で行えます。
Bam! We built our project with `cargo build`, and ran it with
`./target/debug/hello_world`. We can do both in one step with `cargo run`:

```bash
$ cargo run
     Running `target/debug/hello_world`
Hello, world!
```

今回は企画を織り直していなかったことに目を向けてください。Cargo は原譜に手が加わってなかった
ことを見抜き２進譜を実行するに留めました。
もし手を加えていれば両方ともが行なわれる様子を見ていたでしょう。
Notice that we didn’t re-build the project this time. Cargo figured out that
we hadn’t changed the source file, and so it just ran the binary. If we had
made a modification, we would have seen it do both:

```bash
$ cargo run
   Compiling hello_world v0.0.1 (file:///home/あなたの名前/projects/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

これは `rustc` の素朴な使い方に対してかなりやり過ぎでしょうか、
しかし先のことを考えてみましょう。企画が複雑になっていくにつれ、
一つにまとめてキチンと製譜するためにすべきことが増えていきます。
Cargo があれば、たとえ私達の企画が大きく成長しようとも、ただ `cargo build`
を走らせるだけで一件落着です。
This hasn’t bought us a whole lot over our simple use of `rustc`, but think
about the future: when our project gets more complex, we need to do more
things to get all of the parts to properly compile. With Cargo, as our project
grows, we can just run `cargo build`, and it’ll work the right way.

ついに私達の企画が放流の時を迎えたら、`cargo build --release`
を使って企画を最適化 (optimizations) ありで製譜できます。
When our project is finally ready for release, we can use `cargo build
--release` to compile our project with optimizations.

Cargo が新しい〈ファイル〉`Cargo.lock` を作っていたことにも気づくでしょう。
You'll also notice that Cargo has created a new file: `Cargo.lock`.

```toml
[root]
name = "hello_world"
version = "0.0.1"
```

この `Cargo.lock` は Cargo が作った譜体の依存物を追跡するために使われています。
ちょうど今は何もないのでちょっとスカスカですね。
私達自身はこの〈ファイル〉に触る必要は全くなく、ただ Cargo にすべてを委ねます。
The `Cargo.lock` file is used by Cargo to keep track of dependencies in our
application. Right now, we don’t have any, so it’s a bit sparse. We won't ever
need to touch this file ourselves, just let Cargo handle it.

以上！ `hello_world` を見事 Cargo で織り上げました。私達の譜体はごく簡単なものでしたが、
今度の Rust の経歴でずっと使われる実際の道具を大いに利用しました。
実質的にすべての Rust 企画は次のようにして取りかかれると期待してください。
That’s it! We’ve successfully built `hello_world` with Cargo. Even though our
program is simple, it’s using much of the real tooling that we’ll use for the
rest of our Rust career. We can expect to do this to get started with virtually
all Rust projects:

```bash
$ git clone どこかのurl.com/なんとか
$ cd なんとか
$ cargo build
```

## 新しい企画へ
## A New Project

新しい企画を始めようと思ったとき、毎回この一連の流れをこなさなくても大丈夫！
Cargo には開発をすぐ始められる骨組みだけの企画の階層を作る能力があります。
We don’t have to go through this whole process every time we want to start a new
project! Cargo has the ability to make a bare-bones project directory in which
we can start developing right away.

Cargo で新しい企画を始める呪文は `cargo new` です。
To start a new project with Cargo, we use `cargo new`:

```bash
$ cargo new hello_world --bin
```

目標はいきなり（〈ライブラリ〉ではなく）実行可能な譜体を作ることなので、`--bin`
を渡しています。実行形式はよく２進譜「binary (バイナリー)」と呼ばれています。
(Unix 算系をお使いなら `/usr/bin` に同じ。)
We’re passing `--bin` because our goal is to get straight to making an
executable application, as opposed to a library. Executables are often called
‘binaries.’ (as in `/usr/bin`, if we’re on a Unix system)

Cargo が生成してくれたところを調べてみましょう。
Let's check out what Cargo has generated for us:

```bash
$ cd hello_world
$ tree .
.
├── Cargo.toml
└── src
    └── main.rs

1 directory, 2 files
```

`tree` 命令が算系に入っていなければ、おそらく頒布物〈ディストリビューション〉の
〈パッケージマネージャー〉から入手できます。必須ではありませんが、確かに役立つものです。
If we don't have the `tree` command, we can probably get it from our
distribution’s package manager. It’s not necessary, but it’s certainly useful.

これから必要なものはみな揃いました。まずは `Cargo.toml` を見ていきましょう。
This is all we need to get started. First, let’s check out `Cargo.toml`:

```toml
[package]

name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

Cargo は与えた引数と `git` の全体設定を元に妥当な黙用値〈デフォルト〉
を含んだこの〈ファイル〉を作りました。Cargo が `hello_world` 階層を `git`〈レポジトリ〉
として初期化したことにも気づいたかもしれません。
Cargo has populated this file with reasonable defaults based off the arguments
we gave it and our `git` global configuration. You may notice that Cargo has
also initialized the `hello_world` directory as a `git` repository.

`src/main.rs` の中はこうなっています。
Here’s what’s in `src/main.rs`:

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo が "Hello World!" を生成してくれたので、すぐ譜面に向かう用意ができました！
Cargo にはそれ自身の[手引き][guide]があり、Cargo の特徴をより深く網羅しています。
Cargo has generated a "Hello World!" for us, and we’re ready to start coding!
Cargo has its own [guide][guide] which covers Cargo’s features in much more
depth.

[guide]: http://doc.crates.io/guide.html

基本的な道具の使い方が分かったところで、Rust 言語自体についてもっと実際に学んでいきましょう。
これらは、これから Rust を使っていく中でとても役立つ基本中の基本です。
Now that we’ve got the tools down, let’s actually learn more about the Rust
language itself. These are the basics that will serve us well through the rest
of our time with Rust.

あなたには２つの選択肢があります。
「[Rust を学ぼう][learnrust]」へ進んで企画に飛び込むもよし、
または「[構文も、意味論も、あるんだよ][syntax]」へ進んで地盤から着実に学んでもよいでしょう。
比較的経験のある算系演譜師〈システムプログラマー〉は多分「Rust を学ぼう」を選ぶでしょう。
動的言語を学んできた方々はどちらでも楽しめると思いますけどね。
学びの様は人それぞれです！あなたに合っている方を選んでください。
You have two options: Dive into a project with ‘[Learn Rust][learnrust]’, or
start from the bottom and work your way up with
‘[Syntax and Semantics][syntax]’. More experienced systems programmers will
probably prefer ‘Learn Rust’, while those from dynamic backgrounds may enjoy
either. Different people learn differently! Choose whatever’s right for you.

[learnrust]: learn-rust.html
[syntax]: syntax-and-semantics.html
