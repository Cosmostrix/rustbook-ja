% はじめよう、Rust

この章で私達は Rust とその道具立てを手にし、次へ進めるようになります。
初めに、Rustを導入〈インストール〉します。それから、古典的な「Hello World」算譜について話します。
最後に、Rust の組み上げ〈ビルド〉体系かつ〈パッケージマネジャー〉である Cargo についてお話します。

<!-- This first section of the book will get us going with Rust and its tooling.
First, we’ll install Rust. Then, the classic ‘Hello World’ program. Finally,
we’ll talk about Cargo, Rust’s build system and package manager. -->

# Rust を導入しよう

<!-- # Installing Rust -->

Rust を使う最初の一歩は Rust を導入〈インストール〉することです。
一般的に言うと、これから私達は Rust を網際網路〈インターネット〉より入荷〈ダウンロード〉
するため、この章の命令〈コマンド〉を実行するためには網際網路への接続が必要になります。

<!-- The first step to using Rust is to install it. Generally speaking, you’ll need
an Internet connection to run the commands in this chapter, as we’ll be
downloading Rust from the internet. -->

本書では端末〈ターミナル〉を使った数々の命令が登場します。
命令の書かれた行は `$` 記号が頭につく行で、これらは各命令のはじまりを示すだけの印ですので、
入力しないでください。次のような慣例に従った多くの指南書〈チュートリアル〉やお手本を Web
の各所で見かけると思います。 標準利用者〈ユーザー〉として実行する命令には `$` を付け、
管理者として実行しなければならない命令には `#` を付けて区別します。

<!-- We’ll be showing off a number of commands using a terminal, and those lines all
start with `$`. We don't need to type in the `$`s, they are there to indicate
the start of each command. We’ll see many tutorials and examples around the web
that follow this convention: `$` for commands run as our regular user, and `#`
for commands we should be running as an administrator. -->

## 土台環境〈プラットフォーム〉対応

<!-- ## Platform support -->

Rust 製譜器〈コンパイラー〉は動作も出力も多数の土台環境に対応していますが、
全ての土台環境に平等に対応しているわけではありません。
Rust の対応水準は一軍、二軍、三軍の３段階 (tier)〈ティア〉に分かれており、
それぞれ保証の内容が異なります。

<!-- The Rust compiler runs on, and compiles to, a great number of platforms, though
not all platforms are equally supported. Rust's support levels are organized
into three tiers, each with a different set of guarantees. -->

土台環境の区別には「標的三つ組 (target triple)」という、
ねらった環境に向けてどのような種類の出力をすべきかを製譜器に知らせる記号を使います。
以下の表は特定の土台環境でどの品が動くかを示しています。

<!-- Platforms are identified by their "target triple" which is the string to inform
the compiler what kind of output should be produced. The columns below indicate
whether the corresponding component works on the specified platform. -->

### 一軍 (Tier 1) 〈ティアワン〉

<!-- ### Tier 1 -->

一軍の環境は「組み上げと動作の保証がある」と考えて差し支えありません。
正確にはどれも以下の要件を満たしています。

<!-- Tier 1 platforms can be thought of as "guaranteed to build and work".
Specifically they will each satisfy the following requirements: -->

* その土台環境で検査〈テスト〉を実施するための自動検査の仕組みが整備されている
* 検査を通過した変更だけが `rust-lang/rust` 宝庫〈レポジトリ〉の master
分枝〈ブランチ〉に入る
* その土台環境向けに公式の放流〈リリース〉物が提供される
* その土台環境向けの使い方と組み上げ方の資料集〈ドキュメンテーション〉が利用可能

<!-- * Automated testing is set up to run tests for the platform.
* Landing changes to the `rust-lang/rust` repository's master branch is gated on
  tests passing.
* Official release artifacts are provided for the platform.
* Documentation for how to use and how to build the platform is available. -->

|  標的                         | std |rustc|cargo| 注                         |
|-------------------------------|-----|-----|-----|----------------------------|
| `x86_64-pc-windows-msvc`      |  ✓  |  ✓  |  ✓  | 64-bit MSVC (Windows 7+)   |
| `i686-pc-windows-gnu`         |  ✓  |  ✓  |  ✓  | 32-bit MinGW (Windows 7+)  |
| `x86_64-pc-windows-gnu`       |  ✓  |  ✓  |  ✓  | 64-bit MinGW (Windows 7+)  |
| `i686-apple-darwin`           |  ✓  |  ✓  |  ✓  | 32-bit OSX (10.7+, Lion+)  |
| `x86_64-apple-darwin`         |  ✓  |  ✓  |  ✓  | 64-bit OSX (10.7+, Lion+)  |
| `i686-unknown-linux-gnu`      |  ✓  |  ✓  |  ✓  | 32-bit Linux (2.6.18+)     |
| `x86_64-unknown-linux-gnu`    |  ✓  |  ✓  |  ✓  | 64-bit Linux (2.6.18+)     |

### 二軍

<!-- ### Tier 2 -->

二軍の環境は「組み上げの保証がある」と考えて差し支えありません。
自動検査は実施されていないので動作の保証はありませんが、
これらの環境はかなりの程度よく動きますし、改良も常に歓迎しています！
正確には以下の要件を満たしています。

<!-- Tier 2 platforms can be thought of as "guaranteed to build". Automated tests
are not run so it's not guaranteed to produce a working build, but platforms
often work to quite a good degree and patches are always welcome! Specifically,
these platforms are required to have each of the following: -->

* 自動組み上げは整備されているが、検査までは実施されないことがある
* **組み上げの** 成功をもって `rust-lang/rust` 宝庫の master 分枝に変更が入る。
一部の環境では標準譜集〈スタンダードライブラリ〉のみが組み上げられるが他の環境では完全に行われる場合があるという意味なので注意
* その土台環境向けに公式の放流物が提供される

<!-- * Automated building is set up, but may not be running tests.
* Landing changes to the `rust-lang/rust` repository's master branch is gated on
  platforms **building**. Note that this means for some platforms only the
  standard library is compiled, but for others the full bootstrap is run.
* Official release artifacts are provided for the platform. -->

|  標的                         | std |rustc|cargo| 注                         |
|-------------------------------|-----|-----|-----|----------------------------|
| `i686-pc-windows-msvc`        |  ✓  |  ✓  |  ✓  | 32-bit MSVC (Windows 7+)   |

### 三軍

<!-- ### Tier 3 -->

三軍の環境は Rust で対応しているものの、入る変更は組み上げと検査の通過で確認されません。
これらの土台環境で動作する版は限定的かもしれません。
その信頼性が協力者の方々の貢献次第で決まることが多いからです。
加えて、放流物と取付具〈インストーラー〉も提供されませんが、
有志による設備が非公式の場所でこれらを作成していることがあります。

<!-- Tier 3 platforms are those which Rust has support for, but landing changes is
not gated on the platform either building or passing tests. Working builds for
these platforms may be spotty as their reliability is often defined in terms of
community contributions. Additionally, release artifacts and installers are not
provided, but there may be community infrastructure producing these in
unofficial locations. -->

|  標的                         | std |rustc|cargo| 注                         |
|-------------------------------|-----|-----|-----|----------------------------|
| `x86_64-unknown-linux-musl`   |  ✓  |     |     | 64-bit Linux with MUSL     |
| `arm-linux-androideabi`       |  ✓  |     |     | ARM Android                |
| `i686-linux-android`          |  ✓  |     |     | 32-bit x86 Android         |
| `aarch64-linux-android`       |  ✓  |     |     | ARM64 Android              |
| `arm-unknown-linux-gnueabi`   |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
| `arm-unknown-linux-gnueabihf` |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
| `aarch64-unknown-linux-gnu`   |  ✓  |     |     | ARM64 Linux (2.6.18+)      |
| `mips-unknown-linux-gnu`      |  ✓  |     |     | MIPS Linux (2.6.18+)       |
| `mipsel-unknown-linux-gnu`    |  ✓  |     |     | MIPS (LE) Linux (2.6.18+)  |
| `powerpc-unknown-linux-gnu`   |  ✓  |     |     | PowerPC Linux (2.6.18+)    |
| `i386-apple-ios`              |  ✓  |     |     | 32-bit x86 iOS             |
| `x86_64-apple-ios`            |  ✓  |     |     | 64-bit x86 iOS             |
| `armv7-apple-ios`             |  ✓  |     |     | ARM iOS                    |
| `armv7s-apple-ios`            |  ✓  |     |     | ARM iOS                    |
| `aarch64-apple-ios`           |  ✓  |     |     | ARM64 iOS                  |
| `i686-unknown-freebsd`        |  ✓  |  ✓  |     | 32-bit FreeBSD             |
| `x86_64-unknown-freebsd`      |  ✓  |  ✓  |     | 64-bit FreeBSD             |
| `x86_64-unknown-openbsd`      |  ✓  |  ✓  |     | 64-bit OpenBSD             |
| `x86_64-unknown-netbsd`       |  ✓  |  ✓  |     | 64-bit NetBSD              |
| `x86_64-unknown-bitrig`       |  ✓  |  ✓  |     | 64-bit Bitrig              |
| `x86_64-unknown-dragonfly`    |  ✓  |  ✓  |     | 64-bit DragonFlyBSD        |
| `x86_64-rumprun-netbsd`       |  ✓  |     |     | 64-bit NetBSD Rump Kernel  |
| `i686-pc-windows-msvc` (XP)   |  ✓  |     |     | Windows XP support         |
| `x86_64-pc-windows-msvc` (XP) |  ✓  |     |     | Windows XP support         |

この表は今後さらに拡大していく可能性があり、これからも三軍環境の網羅的な一覧とは限らない点にご注意ください。

<!-- Note that this table can be expanded over time, this isn't the exhaustive set of
tier 3 platforms that will ever be! -->

## Linux または Mac に導入する

<!-- ## Installing on Linux or Mac -->

Linux または Mac をお使いの場合、
唯一必要なことは次の行を端末〈ターミナル〉で実行することだけです。

<!-- If we're on Linux or a Mac, all we need to do is open a terminal and type this: -->

```bash
$ curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

これは台譜〈スクリプト〉を入荷して導入を開始します。うまくいけば次の表示が現れるでしょう。

<!-- This will download a script, and stat the installation. If it all goes well,
you’ll see this appear: -->

```text
【参考訳】
Rust へようこそ。

この台譜は Rust 製譜器とその〈パッケージマネージャー〉Cargo を入荷し、/usr/local
に導入します。この台譜に --prefix=<場所> をつけて再度実行することで他の場所に導入できます。

この取付具は「sudo」の元で実行され、あなたの暗証文〈パスワード〉を問うかもしれません。
この代譜に「sudo」してほしくない場合は --disable-sudo 旗〈フラグ〉を渡してください。

後ほど撤去〈アンインストール〉するには /usr/local/lib/rustlib/uninstall.sh
を実行するか、この台譜を --uninstall 旗をつけて再度実行してください。

続けますか？ (y/N) ※入力せずに確定した場合、大文字の方が選択されます
```

```text
【原文】
Welcome to Rust.

This script will download the Rust compiler and its package manager, Cargo, and
install them to /usr/local. You may install elsewhere by running this script
with the --prefix=<path> option.

The installer will run under ‘sudo’ and may ask you for your password. If you do
not want the script to run ‘sudo’ then pass it the --disable-sudo flag.

You may uninstall later by running /usr/local/lib/rustlib/uninstall.sh,
or by running this script again with the --uninstall flag.

Continue? (y/N) 
```

ここで `y` を押して「yes」とします。それからは指示に従ってください。

<!-- From here, press `y` for ‘yes’, and then follow the rest of the prompts. -->

## Windows に導入する

<!-- ## Installing on Windows -->

Windows をお使いの場合、適切な[取付具〈インストーラー〉][install-page]を入荷してください。

<!-- If you're on Windows, please download the appropriate [installer][install-page]. -->

[install-page]: https://www.rust-lang.org/install.html

> 【訳者註】無料です。ひとまずは安定版 (stable)
> の「32-bit」または「64-bit」を環境に合うように選ぶと良いでしょう。

<!-- 【追加ここから】 -->

> 【注意】黙用的に〈デフォルトで〉、Windows 用取付具は %PATH% 算系〈システム〉環境変数に
> Rust の場所を追加しません。もしこの Rust が導入後に命令行〈コマンドライン〉から走らせたい
> ただひとつの版なら、導入画面の「Advanced」を押下〈クリック〉して道なりに進み、
> 「Product Features」画面の「Add to PATH」を選択し「Entire feature will be 
> installed on local hard drive」を確実に選択して進めてください。

<!-- 【追加ここまで】 -->

## 撤去〈アンインストール〉するには

<!-- ## Uninstalling -->

Rust の撤去は導入と同じくらい簡単です。
Linux または Mac 上では、次の撤去用台譜を実行するのみです。

<!-- Uninstalling Rust is as easy as installing it. On Linux or Mac, just run
the uninstall script:
 -->

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

Windows 用取付具を使った場合は、もう一度その `.msi` を実行すると撤去 (Uninstall)
の選択肢が現れます。

<!-- If we used the Windows installer, we can re-run the `.msi` and it will give us
an uninstall option. -->

<!-- 【追加ここから】Nightlyでは削除された部分だがあったほうがいいと思い残してみる -->

## お約束の免責事項

わりあい真っ当な方々はそうなのですが、`curl | sh` するように言うと激怒される方もいます。
根本的には、こうするとき Rust を保守している善良な人々が計算機〈コンピューター〉
を侵害して悪事をはたらかないことを当てにしているからです。
実によい洞察です！もしあなたがそのような方々の一員なら、開発資料集の
[Rust を原譜から組み上げる〈ビルド〉][from-source]や[公式 二進譜〈バイナリ〉置き場]
[install-page]を当たってみてください。

[from-source]: https://github.com/rust-lang/rust#building-from-source

<!-- 【追加ここまで】 -->

## 困ったときは

<!-- ## Troubleshooting -->

Rust の導入が無事済んだら、司得〈シェル〉を開いてこのように打てるようになります。

<!-- If we've got Rust installed, we can open up a shell, and type this: -->

```bash
$ rustc --version
```

版数〈バージョン〉、〈コミットハッシュ〉、〈コミット〉日時が表示されるはずです。

<!-- You should see the version number, commit hash, and commit date. -->

うまく表示されたら導入成功です！ やったね たえちゃん演譜ができるよ！

<!-- If you do, Rust has been installed successfully! Congrats! -->

Windows をお使いでうまく行かなかった場合は、%PATH% 算系環境変数に Rust
が含まれているか確認してください。もしなかった場合、取付具を再度走らせて
「Change, repair, or remove installation」ページ内の「Change」を選び、
「Add to PATH」が確実に「local hard drive」に導入されているようにしてください。

<!-- If you don't and you're on Windows, check that Rust is in your %PATH% system
variable. If it isn't, run the installer again, select "Change" on the "Change,
repair, or remove installation" page and ensure "Add to PATH" is installed on
the local hard drive. -->

もしダメでも、助けを求められる場所がたくさんあります。
一番簡単なのは、[irc.mozilla.org 上にある IRC #rust チャンネル (英語)][irc]で、そこには
[Mibbit][mibbit] を通して到達できます。〈リンク〉を押下すると、私達が他の心優しい 
Rustacean (私達が自分たちのことを呼ぶちゃらけた二つ名〈ニックネーム〉です)
達とおしゃべりしているはずです。
他によい場所には[井戸端会議所〈ユーザーフォーラム〉(英語)][users]と
[Stack Overflow (英語)][stackoverflow]などがあります。

<!-- If not, there are a number of places where we can get help. The easiest is
[the #rust IRC channel on irc.mozilla.org][irc], which we can access through
[Mibbit][mibbit]. Click that link, and we'll be chatting with other Rustaceans
(a silly nickname we call ourselves) who can help us out. Other great resources
include [the user’s forum][users], and [Stack Overflow][stackoverflow]. -->

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: https://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: https://stackoverflow.com/questions/tagged/rust

<!-- 【追加ここから】 -->

> 【訳者註】[スタック・オーバーフロー 日本語版][stackoverflow-ja]、[IRC #rust-jp チャンネル][irc-jp]、[Mibbit #rust-jp][mibbit-jp]、[Qiita の rust タグ][qiita]

[stackoverflow-ja]: https://ja.stackoverflow.com/questions/tagged/rust
[irc-jp]: irc://irc.mozilla.org/#rust-jp
[mibbit-jp]: https://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-jp
[qiita]: https://qiita.com/tags/rust

<!-- 【追加ここまで】 -->

この取付具は開発資料集の写し一式も手元に導入するので、無接続〈オフライン〉で読めます。
UNIX系算系では `/usr/local/share/doc/rust` がその場所です。
Windows では Rust が導入された階層〈フォルダ〉内の `share/doc`
階層にあります。

<!-- This installer also installs a copy of the documentation locally, so we can
read it offline. On UNIX systems, `/usr/local/share/doc/rust` is the location.
On Windows, it's in a `share/doc` directory, inside the directory to which Rust
was installed. -->

# Hello, world!

Rust を導入したからには早速最初の Rust 算譜〈プログラム〉を書いてみましょう。
新しい言語で最初の算譜を作るときは、
画面に“Hello, world!”の文を印字させるのが習わしです。

<!-- Now that you have Rust installed, we'll help you write your first Rust program.
It's traditional when learning a new language to write a little program to
print the text “Hello, world!” to the screen, and in this section, we'll follow
that tradition.  -->

こういった簡単な算譜から初める利点は、製譜器が単に導入できただけでなく
きちんと動作することまで確認できる点です。
何より画面に情報を印字する機会はとても多いので、早くからその練習をするのはよいことです。

<!-- The nice thing about starting with such a simple program is that you can
quickly verify that your compiler is installed, and that it's working properly.
Printing information to the screen is also just a pretty common thing to do, so
practicing it early on is good. -->

> 【訳者註】"hello, world" は いにしえの C 言語の本に由来しますが、初出には諸説あります。

> 【注意】この手引書は命令行を最小限扱えることを前提にしています。 Rust 
> 自身は特に編集と補助の道具についてや譜面〈コード〉をどこに置くかについて全く要求しません。
> 命令行より統合開発環境 (IDE) の方が好みなら、それも選択肢のひとつです。
> [SolidOak][solidoak] は Rust を念頭に開発されているので試す価値があるかもしれません。
> 有志に皆様により開発のすすむ拡張機能がたくさんあり、Rust 開発班も[様々な書房〈エディタ〉]
> [various editors]の拡張を出荷しています。
> 書房や IDE の調整はこの手引書の範囲を超えますので、それぞれの資料集を当たってください。

<!-- > Note: This book assumes basic familiarity with the command line. Rust itself
> makes no specific demands about your editing, tooling, or where your code
> lives, so if you prefer an IDE to the command line, that's an option. You may
> want to check out [SolidOak], which was built specifically with Rust in mind.
> There are a number of extensions in development by the community, and the
> Rust team ships plugins for [various editors]. Configuring your editor or
> IDE is out of the scope of this tutorial, so check the documentation for your
> specific setup. -->

[SolidOak]: https://github.com/oakes/SolidOak
[various editors]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md

## 企画〈プロジェクト〉用の〈ファイル〉を作る

<!-- ## Creating a Project File -->

最初に、Rust 譜面を収める〈ファイル〉を作ります。
Rust はあなたの譜面がどこにあるか気にしませんが本書では地階〈ホームディレクトリ〉に
*projects* 階層〈ディレクトリ〉を作り、そこに全ての企画を置くことをオススメします。
端末を開いて次の命令を打つと今回の企画にための階層ができあがります。

<!-- First, make a file to put your Rust code in. Rust doesn't care where your code
lives, but for this book, I suggest making a *projects* directory in your home
directory, and keeping all your projects there. Open a terminal and enter the
following commands to make a directory for this particular project: -->

```bash
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

> 【注意】Windows 上で PowerShell 以外を使っている場合、`~` は使えません。
> 詳しくはお使いの司得〈シェル〉の開発資料集を引いてください。

<!-- > Note: If you’re on Windows and not using PowerShell, the `~` may not work.
> Consult the documentation for your shell for more details. -->

>【訳者註】コマンドプロンプトで `~` に相当する場所（地階）は `C:\Users\【ユーザー名】`
> です。 `~` の代わりに `%USERPROFILE%` と書くこともできます。
> また、スタートメニューからコマンドプロンプトを起動した直後なら `~/` を省略できます。

## Rust 算譜を書いて走らせよう

<!-- ## Writing and Running a Rust Program -->

次に、新しい原譜 (source)〈ソース〉を作成して *main.rs* と名づけます。
Rust 譜にはいつも拡張子 *.rs* がお尻に付いています。
〈ファイル〉名に２単語以上を使うときは下線を用いて、 *helloworld.rs* のかわりに
*hello_world.rs* と命名します。

<!-- Next, make a new source file and call it *main.rs*. Rust files always end
in a *.rs* extension. If you’re using more than one word in your filename, use
an underscore to separate them; for example, you'd use *hello_world.rs* rather
than *helloworld.rs*. -->

今作った *main.rs* を開いて、次の譜面を打ち込みます。

<!-- Now open the *main.rs* file you just created, and type the following code: -->

```rust
fn main() {
    println!("Hello, world!");
}
```

保存して、端末窓に戻ります。 Linux または OS X 上では次の命令を打ち込みます。

<!-- Save the file, and go back to your terminal window. On Linux or OSX, enter the
following commands: -->

```bash
$ rustc main.rs
$ ./main 
Hello, world!
```

Windows では、上の `main` を `main.exe` に読み替えてください。
どの基本算系 (OS)〈オペレーティングシステム〉でも、`Hello, world!`
という文字列が端末に見られるはずです。
そうなったら成功です。

おめでとうございます！

あなたは正式に Rust 算譜を書いたのです。
こうして晴れてあなたも Rust 演譜師〈プログラマー〉の一員となりました！
歓迎します。

<!-- In Windows, just replace `main` with `main.exe`. Regardless of your operating
system, you should see the string `Hello, world!` print to the terminal. If you
did, then congratulations! You've officially written a Rust program. That makes
you a Rust programmer! Welcome.  -->

## Rust 算譜の生体構造

<!-- ## Anatomy of a Rust Program -->

さて、あなたの "Hello, world!" 算譜の中で実際に何が起こったのか詳しく追っていきましょう。
謎解きの最初のカギはこちらです。

<!-- Now, let’s go over what just happened in your "Hello, world!" program in
detail. Here's the first piece of the puzzle: -->

```rust
fn main() {

}
```

これらの行は Rust における *機能* (*function*)〈関数〉 を定義しています。
`main` 機能は特別で、全ての Rust 譜体の開始地点〈エントリーポイント〉になっています。
最初の行はこう読めます。「私は `main` という名前の機能 (*fn*) を宣言します。
それは引数に何も取らず、最後に何も返しません。」
もし仮に引数を取る場合は、引数を丸かっこ (小かっこ) で括り (`(` と `)`)、
そしてこの機能からは何も返していないので戻り値の型全体を省略できます。

<!-- These lines define a *function* in Rust. The `main` function is special: it's
the beginning of every Rust program. The first line says, “I’m declaring a
function named `main` that takes no arguments and returns nothing.” If there
were arguments, they would go inside the parentheses (`(` and `)`), and because
we aren’t returning anything from this function, we can omit the return type
entirely. -->

機能が波かっこ（中かっこ）で包まれているのにお気づきでしょう(`{` と `}`)。 Rust 
は機能本体がこのように囲われていることを要求します。開きかっこを機能宣言と同じ行に置き、
半角空白を一つ挟む書き方がよい作法であると考えられています。

<!-- Also note that the function body is wrapped in curly braces (`{` and `}`). Rust
requires these around all function bodies. It's considered good style to put
the opening curly brace on the same line as the function declaration, with one
space in between. -->

これは `main()` 機能の内側です。

<!-- Inside the `main()` function: -->

```rust
    println!("Hello, world!");
```

この行は私達の小さな譜体で行っている仕事のすべてです。 画面に文字を印字しています。
ここには重要な細部がいくつもあります。
まず４つの半角空白で字下げされており、タブ (TAB) 文字を使っていないこと。

<!-- This line does all of the work in this little program: it prints text to the
screen. There are a number of details that are important here. The first is
that it’s indented with four spaces, not tabs. -->

二番目は `println!()` の部分です。これは Rust の[マクロ (macro)][macro]
と呼ばれ、Rust で演譜の演譜〈メタプログラミング〉を行うための手段です。
もしこれが機能であったなら、`println()` (! がありません)
のような見た目になっていることでしょう。
マクロについては後ほど詳しく議論しますが、いま覚えていて欲しいことは、
`!` を見かけたとき普通の機能ではなくマクロを呼んでいるということです。

<!-- The second important part is the `println!()` line. This is calling a Rust
*[macro]*, which is how metaprogramming is done in Rust. If it were calling a
function instead, it would look like this: `println()` (without the !). We'll
discuss Rust macros in more detail later, but for now you just need to
know that when you see a `!` that means that you’re calling a macro instead of
a normal function.  -->

[macro]: macros.html

> 【訳者註】C 言語のマクロとは全くの別物です。恐れる必要はありません。

次に、`"Hello, world!"` は「文字列 (string)」です。
文字列は算系演譜言語では驚くほど奥の深い話題で、これは *[静的に割り付けられた]
[statically allocated]* 文字列です。
この文字列を引数として `println!` に渡すと、画面に文字列を印字してくれます。
ね、簡単でしょ？

> 【訳者註】勘の良い方はお気づきでしょう。println は print line(s) の略です。

<!-- Next is `"Hello, world!"` which is a *string*. Strings are a surprisingly
complicated topic in a systems programming language, and this is a *[statically
allocated]* string. We pass this string as an argument to `println!`, which
prints the string to the screen. Easy enough! -->

[statically allocated]: the-stack-and-the-heap.html

行がセミコロン (`;`) で終わっています。Rust は *[式指向][expression oriented]*
の言語であり、ほとんどのものは文の代わりに式で表現されます。
`;` はこの式はここで終わったと示し、次の式の始まりを示します。
Rust 譜面の大半は `;` で終わります。

<!-- The line ends with a semicolon (`;`). Rust is an *[expression oriented]*
language, which means that most things are expressions, rather than statements.
The `;` indicates that this expression is over, and the next one is ready to
begin. Most lines of Rust code end with a `;`. -->

[expression oriented]: glossary.html#expression-oriented-language

## 製譜と実行の 2 段に分かれています

<!-- ## Compiling and Running Are Separate Steps -->

「Rust 算譜を書いて走らせよう」で新しく作った算譜をどのように走らせる (実行させる) 
かお見せしました。 
これからその過程をひもといて各段階を調べていきます。

<!-- In "Writing and Running a Rust Program", we showed you how to run a newly
created program. We'll break that process down and examine each step now. --> 

Rust 算譜を走らせる前に、それを製譜しておく必要があります。
Rust 製譜器は `rustc` 命令を打って原譜の名前を渡すことで使えます。
このようにです。

<!-- Before running a Rust program, you have to compile it. You can use the Rust
compiler by entering the `rustc` command and passing it the name of your source
file, like this: -->

```bash
$ rustc main.rs
```

C や C++ の経験者なら `gcc` や `clang` に似ていると思うでしょう。
無事製譜できたら Rust は実行可能な二進譜 (binary)〈バイナリ〉を出力します。
Linux や OS X 上では `ls` 命令を司得に打つとこのように見られます。

<!-- If you come from a C or C++ background, you'll notice that this is similar to
`gcc` or `clang`. After compiling successfully, Rust should output a binary
executable, which you can see on Linux or OSX by entering the `ls` command in
your shell as follows: -->

```bash
$ ls
main  main.rs
```

Windows では、このように。

<!-- On Windows, you'd enter: -->

```bash
$ dir
main.exe  main.rs
```

`.rs` の拡張子のついた私達の原譜と、実行形式 (Windows では `main.exe` 他は `main`)
の２つの〈ファイル〉があります。
残るは `main` または `main.exe` の実行のみです。

<!-- This shows we have two files: the source code, with an `.rs` extension, and the
executable (`main.exe` on Windows, `main` everywhere else). All that's left to
do from here is run the `main` or `main.exe` file, like this: -->

```bash
$ ./main  # または Windows では main.exe
```

この *main.rs* が先の "Hello, world!" 算譜なら端末に `Hello, world!` と印字されます。

<!-- If *main.rs* were your "Hello, world!" program, this would print `Hello,
world!` to your terminal. -->

もしあなたが Ruby・Python・JavaScript のような動的言語の世界から来たのであれば、
製譜と実行を分けることに慣れていなかったかもしれません。
Rust は「事前に製譜する言語」に属するので、譜体をあらかじめ製譜して他の人にあげても、
その人は Rust を導入することなしに実行が可能です。
もし他の人に `.rb` や `.py` や `.js` 台譜をあげるには受け取る側が
Ruby/Python/JavaScript の実装を (それぞれ) 導入しておく必要がありますが、
製譜と実行の両方を一回の命令で済ませることができます。
すべては言語設計における両立しないものの間の妥協です。これが Rust の選んだ道というわけです。

<!-- If you come from a dynamic language like Ruby, Python, or JavaScript, you may
not be used to compiling and running a program being separate steps. Rust is an
*ahead-of-time compiled* language, which means that you can compile a program,
give it to someone else, and they can run it even without Rust installed. If
you give someone a `.rb` or `.py` or `.js` file, on the other hand, they need
to have a Ruby, Python, or JavaScript implementation installed (respectively),
but you only need one command to both compile and run your program. Everything
is a tradeoff in language design. -->

簡単なものには `rustc` を使うだけでも十分ですが、企画が成長するにつれて、備えた選択肢
すべての管理を簡単にし、作った譜面を他の人々や企画と共有しやすくする何かが欲しくなります。
次は、もうひとつの道具、Cargo を紹介したいと思います。Cargo は実世界の Rust
算譜を書きやすくするために使われています。

<!-- Just compiling with `rustc` is fine for simple programs, but as your project
grows, you'll want to be able to manage all of the options your project has,
and make it easy to share your code with other people and projects. Next, I'll
introduce you to a tool called Cargo, which will help you write real-world Rust
programs. -->

# Hello, Cargo!

> 【訳者註】Cargo (カーゴ) は「貨物」「積み荷」を意味します。

Cargo は Rust の組み上げ体系 兼 〈パッケージマネージャー〉で、Rustacean 達が Rust
企画〈プロジェクト〉の管理に使用しているものです。 Cargo は３つのモノを管理します。
譜面〈コード〉の組み上げ〈ビルド〉、あなたの算譜が依存する譜集〈ライブラリ〉の入荷、
そういった譜集の組み上げです。ある譜面が必要としている譜集のことを「依存物
(dependencies)」といいます。

<!-- Cargo is Rust’s build system and package manager, and Rustaceans use Cargo to
manage their Rust projects. Cargo manages three things: building your code,
downloading the libraries your code depends on, and building those libraries.
We call libraries your code needs ‘dependencies’ since your code depends on
them. -->

最も簡単な Rust 算譜には 1 つも依存物がないので、そう今ちょうど、
前者の機能だけを使うことになります。 もっと複雑な Rust 算譜を書くようになると、
もっと依存物を増やしたくなります。
そして、もし Cargo を使って書き始めたのであれば追加はずっと簡単にできるでしょう。

<!-- The simplest Rust programs don’t have any dependencies, so right now, you'd
only use the first part of its functionality. As you write more complex Rust
programs, you’ll want to add dependencies, and if you start off using Cargo,
that will be a lot easier to do. -->

圧倒的多数の Rust 企画が Cargo を利用していることから、以後この本の中でも Cargo
を使っていくものとして話をすすめます。
公式の取付具から導入した場合は Cargo が Rust 自身に付属しています。
他の手段で導入した場合は端末に以下のように打って Cargo が入っているか確認できます。

<!-- As the vast, vast majority of Rust projects use Cargo, we will assume that
you’re using it for the rest of the book. Cargo comes installed with Rust
itself, if you used the official installers. If you installed Rust through some
other means, you can check if you have Cargo installed by typing: -->

```bash
$ cargo --version
```

版数が出たら、バッチリです！ 「`command not found`」などの誤りだったら
Rust を入れた算系に対応する資料集を探して Cargo が別になっていないか確かめてください。

<!-- Into a terminal. If you see a version number, great! If you see an error like
‘`command not found`’, then you should look at the documentation for the system
in which you installed Rust, to determine if Cargo is separate. -->

## Cargo に移行する

<!-- ## Converting to Cargo -->

それでは、Hello World を Cargo に移していきましょう。
企画を Cargo 化するためには以下の３つが必要です。

<!-- Let’s convert the Hello World program to Cargo. To Cargo-fy a project, you need
to do three things:  -->

1. 原譜を正しい場所への配置
2. 以前の実行形式からの脱却 (Windows では `main.exe`、他では `main`)
3. 構成〈ファイル〉 `Cargo.toml` の作成

<!-- 1. Put your source file in the right directory.
2. Get rid of the old executable (`main.exe` on Windows, `main` everywhere else)
   and make a new one.
3. Make a Cargo configuration file. -->

では始めましょう！

<!-- Let's get started! -->

### 新しい実行形式と原譜用階層をつくる

<!-- ### Creating a new Executable and Source Directory -->

まずは端末にもどって *hello_world* 階層に移動し、次の命令を打ち込みます。

<!-- First, go back to your terminal, move to your *hello_world* directory, and
enter the following commands: -->

```bash
$ mkdir src
$ mv main.rs src/main.rs
$ rm main  # または Windows では del main.exe
```
Cargo はすべての原譜が `src` 階層に収まっていると期待しているので、まずそのようにします。
こうすると最上位階層 (ここでは *hello_world*) が README (お読みください)関係、
使用許諾 (license)〈ライセンス〉情報、譜面に関係のないその他一切のために残ります。
このようにして Cargo は私達の企画を整然とした心地いいものに保つよう手伝ってくれます。
すべての物には置き場があります。

<!-- Cargo expects your source files to live inside a *src* directory, so do that
first. This leaves the top-level project directory (in this case,
*hello_world*) for READMEs, license information, and anything else not related
to your code. In this way, using Cargo helps you keep your projects nice and
tidy. There's a place for everything, and everything is in its place.  -->

というわけで、 *main.rs* を *src* 階層に写して、`rustc` で作った製譜済みのものは削除です。
例のごとく Windows では `main` を `main.exe` に読み替えてください。

<!-- Now, copy *main.rs* to the *src* directory, and delete the compiled file you
created with `rustc`. As usual, replace `main` with `main.exe` if you're on
Windows. -->

今は実行形式を作ろうとしているので、原譜名 `main.rs` はそのままにします。もし逆に譜集
(library)〈ライブラリ〉を作りたいときは、`lib.rs` と名付けるとよいでしょう。
この習慣的名前は Cargo が私達の企画を難なく製譜するために使用しますが、
望むときは上書き変更できます。

<!-- This example retains `main.rs` as the source filename because it's creating an
executable. If you wanted to make a library instead, you'd name the file
`lib.rs`. This convention is used by Cargo to successfully compile your
projects, but it can be overridden if you wish.  -->

### 構成〈ファイル〉をつくる

<!-- ### Creating a Configuration File -->

次に、 *hello_world* 階層に新しい〈ファイル〉を作り、 `Cargo.toml` と名づけます。

<!-- Next, create a new file inside your *hello_world* directory, and call it
`Cargo.toml`. -->

この名前は間違えないように。`Cargo.toml` の `C` は必ず大文字です。
間違うと Cargo が構成を見つけられず、どうすればよいのかわかりません。

<!-- Make sure to capitalize the `C` in `Cargo.toml`, or Cargo won't know what to do
with the configuration file.  -->

この〈ファイル〉は *[TOML]* (Tom's Obvious, Minimal Language, トムの明快最小言語)
形式です。
TOML は INI に似ていますが、より優れた面があるので Cargo の構成形式に使われます。

<!-- This file is in the *[TOML]* (Tom's Obvious, Minimal Language) format. TOML is
similar to INI, but has some extra goodies, and is used as Cargo’s
configuration format. -->

[TOML]: https://github.com/toml-lang/toml

中身はこうします。

<!-- Inside this file, type the following information: -->

```toml
[package]

name = "hello_world"
version = "0.0.1"
authors = [ "Your name <you@example.com>" ]
```

> 【訳者註】`Cargo.toml` は作者の国籍にかかわらず英語表記が標準です。
> 本書では一貫して英語表記が普通のところは訳さずに残し、目印にしています。
> わからない単語は辞書や検索窓に聞いて、納得と、ときに驚きを得てください。

一行目 `[package]` は続く文が〈パッケージ〉を構成していることを意味します。
この〈ファイル〉にもっと情報をのせるほど節の数が増えていきますが、今は〈パッケージ〉構成だけです。

<!-- The first line, `[package]`, indicates that the following statements are
configuring a package. As we add more information to this file, we’ll add other
sections, but for now, we just have the package configuration. -->

他の 3 行は Cargo が算譜を製譜するとき知っておくべき構成を書いています。
名前と、版数と、作者名です。

<!-- The other three lines set the three bits of configuration that Cargo needs to
know to compile your program: its name, what version it is, and who wrote it. -->

一度 *Cargo.toml* 〈ファイル〉にこの情報を書き込んだら、保存して構成は終わりです。

<!-- Once you've added this information to the *Cargo.toml* file, save it to finish
creating the configuration file. -->

## Cargo 企画の組み上げと実行

<!-- ## Building and Running a Cargo Project  -->

*Cargo.toml* 〈ファイル〉を企画階層の最上階に置くと、Hello World
算譜の組み上げと実行の準備ができたはずです！ そうするには、次の命令を打ちます。

<!-- With your *Cargo.toml* file in place in your project's root directory, you
should be ready to build and run your Hello World program! To do so, enter the
following commands: -->

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
$ ./target/debug/hello_world
Hello, world!
```

ドン！ 全てが上手くいくと `Hello, world!` が端末にもう一回印字されるはずです。

<!-- Bam! If all goes well, `Hello, world!` should print to the terminal once more.  -->

`cargo build` で企画を組み上げ、 `./target/debug/hello_world` で実行しました。
ですが、実はこの両方を一度に行う方法 `cargo run` があります。

<!-- You just built a project with `cargo build` and ran it with
`./target/debug/hello_world`, but you can actually do both in one step with
`cargo run` as follows: -->

```bash
$ cargo run
     Running `target/debug/hello_world`
Hello, world!
```

今回は企画を組み直さなかったことに目を向けてください。
Cargo は原譜に手が加わってなかったことを見抜き、二進譜を実行するに留めました。
もし手を加えていれば Cargo が実行前に企画を組み直す様子を見てとれたでしょう。

<!-- Notice that this example didn’t re-build the project. Cargo figured out that
the file hasn’t changed, and so it just ran the binary. If you'd modified your
source code, Cargo would have rebuilt the project before running it, and you
would have seen something like this: -->

```bash
$ cargo run
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

Cargo は企画の〈ファイル〉群が修正されたかどうかを調べ、
前回の組み上げから変更があった場合にだけ組み直しを行います。

<!-- Cargo checks to see if any of your project’s files have been modified, and only
rebuilds your project if they’ve changed since the last time you built it. -->

今はごく簡単な企画なので `rustc`
の素朴な使い方と大差ない状態ですが、便利になるのはこれからです。
複数のわく箱〈クレート〉の入り組んだ複雑な企画では Cargo に丸投げしたほうがずっと楽です。
Cargo があれば、たとえ私達の企画が大きく成長しようとも、ただ `cargo build`
を走らせるだけで一件落着です。

<!-- With simple projects, Cargo doesn't bring a whole lot over just using `rustc`,
but it will become useful in future. With complex projects composed of multiple
crates, it’s much easier to let Cargo coordinate the build. With Cargo, you can
just run `cargo build`, and it should work the right way. -->

## 放流版を組み上げる

<!-- ## Building for Release -->

ついに私達の企画が放流 (release) の時を迎えたら、`cargo build --release`
を使って企画を最適化ありで製譜できます。
最適化すると Rust 譜面がより速く走るようになる反面、製譜にかかる時間が増します。
開発用と、利用者に配布する最終算譜の組み上げ用の二段構えになっているにはそのためです。

<!-- When your project is finally ready for release, you can use `cargo build
- -release` to compile your project with optimizations. These optimizations make
your Rust code run faster, but turning them on makes your program take longer
to compile. This is why there are two different profiles, one for development,
and one for building the final program you’ll give to a user. -->

この命令を実行するとさらに、Cargo は新しく *Cargo.lock* という〈ファイル〉をつくります。
中身はこのようになっています。

<!-- Running this command also causes Cargo to create a new file called
*Cargo.lock*, which looks like this: -->

```toml
[root]
name = "hello_world"
version = "0.0.1"
```

この `Cargo.lock` は Cargo 
が作った譜体〈アプリケ―ション〉の依存物を追跡するために使われています。
これは Hello World 企画の *Cargo.lock* 〈ファイル〉です。
この企画には依存物がないのでほぼ空っぽですね。
現実的には私達自身はこの〈ファイル〉に触る必要は全くなく、ただ Cargo にすべてを委ねます。

<!-- Cargo uses the *Cargo.lock* file to keep track of dependencies in your
application. This is the Hello World project's *Cargo.lock* file. This project
doesn't have dependencies, so the file is a bit sparse. Realistically, you
won't ever need to touch this file yourself; just let Cargo handle it. -->

以上！ ここまでついて来てくれたなら `hello_world` が見事 Cargo で組み上っているはずです。

<!-- That’s it! If you've been following along, you should have successfully built
`hello_world` with Cargo.  -->

今回の企画はごく簡単なものでしたが、
今度の Rust の経歴でずっと使われる、実際の道具を大いに活用しました。
事実、実質的にすべての Rust
企画は多少の差はあれど次のようにして始められると期待できます。

<!-- Even though the project is simple, it now uses much of the real tooling you’ll
use for the rest of your Rust career. In fact, you can expect to start
virtually all Rust projects with some variation on the following commands: -->

```bash
$ git clone どこかのurl.com/なんとか
$ cd なんとか
$ cargo build
```

## もっと楽して新しい Cargo 企画をつくる

<!-- ## Making A New Cargo Project the Easy Way -->

新しい企画を始めようと思ったとき、毎回この一連の流れをこなさなくても大丈夫！
Cargo には開発をすぐ始められる骨組みだけの企画階層を作る能力があります。

<!-- You don’t have to go through that previous process every time you want to start
a new project! Cargo can quickly make a bare-bones project directory that you
can start developing in right away. -->

Cargo で新しい企画をはじめる呪文は `cargo new` です。

<!-- To start a new project with Cargo, enter `cargo new` at the command line: -->

```bash
$ cargo new hello_world --bin
```

目標はいきなり（譜集ではなく）実行可能な譜体を作ることなので、`--bin`を渡しています。
実行形式はよく「二進譜 (binary)〈バイナリー〉」と呼ばれています。
(Unix 算系をお使いなら `/usr/bin` も同じ意味。)

<!-- This command passes `--bin` because the goal is to get straight to making an
executable application, as opposed to a library. Executables are often called
*binaries* (as in `/usr/bin`, if you’re on a Unix system). -->

Cargo は 2 つの〈ファイル〉と 1 つの階層を作ってくれました。
`Cargo.toml` と *main.rs* 〈ファイル〉の入った *src* 階層です。
見覚えがあるというのも、さっき手で作ったものと全く同じだからです。

<!-- Cargo has generated two files and one directory for us: a `Cargo.toml` and a
*src* directory with a *main.rs* file inside. These should look familliar,
they’re exactly what we created by hand, above. -->

この出力で必要なものはみな揃いました。 まずは `Cargo.toml` を開きます。
きっとこうなっているはずです。

<!-- This output is all you need to get started. First, open `Cargo.toml`. It should
look something like this: -->

```toml
[package]

name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

Cargo は与えた引数と `git`
の全体設定を元に妥当な黙用値〈デフォルト〉を含んだこの〈ファイル〉を作りました。
Cargo が `hello_world` 階層を`git` 
宝庫〈レポジトリ〉として初期化したことにも気づいたかもしれません。

<!-- Cargo has populated *Cargo.toml* with reasonable defaults based on the arguments
you gave it and your `git` global configuration. You may notice that Cargo has
also initialized the `hello_world` directory as a `git` repository. -->

`src/main.rs` の中はこうなっているはずです。

<!-- Here’s what should be in `src/main.rs`: -->

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo が "Hello World!" を生成してくれたので、すぐ作譜にかかれます！

<!-- Cargo has generated a "Hello World!" for you, and you’re ready to start coding!  -->

> 【注意】 Cargo についてもっと詳しく知りたくなったら、Cargo のすべてを網羅している
> [公式手引き][Cargo guide]を参照してください。

<!-- > Note: If you want to look at Cargo in more detail, check out the official [Cargo
guide], which covers all of its features. -->

[Cargo guide]: http://doc.crates.io/guide.html

## 結びのことば

<!-- # Closing Thoughts -->

本章では最終章、そしてこれから Rust と過ごす時間を通じて役に立つ基本事項を学びました。
道具の使い方も腑に落ちたところで、Rust 言語自体についてもっと学んでいきましょう。

<!-- This chapter covered the basics that will serve you well through the rest of
this book, and the rest of your time with Rust. Now that you’ve got the tools
down, we'll cover more about the Rust language itself.  -->

あなたには２つの選択肢があります。
「[Rust を学ぼう][learnrust]」へ進んで企画に飛び込むもよし、
または「[構文も、意味論も、あるんだよ][syntax]」へ進んで地盤から着実に学んでもよいでしょう。
比較的経験のある算系演譜師〈システムプログラマー〉ならおそらく「Rust
を学ぼう」を取るでしょう。 動的言語を学んできた方々はどちらでも楽しめると思いますけどね。
学びの様は人それぞれです！ あなたに合っている方を選んでください。

<!-- You have two options: Dive into a project with ‘[Learn Rust][learnrust]’, or
start from the bottom and work your way up with ‘[Syntax and
Semantics][syntax]’. More experienced systems programmers will probably prefer
‘Learn Rust’, while those from dynamic backgrounds may enjoy either. Different
people learn differently! Choose whatever’s right for you. -->

[learnrust]: learn-rust.html
[syntax]: syntax-and-semantics.html
