% Hello, world!

Rust を導入したからには早速最初の Rust 譜体〈プログラム〉を書いてみましょう。
新しい言語で最初の譜体を作るときは、
画面に“Hello, world!”の文を印字させるのが習わしです。
こういった簡単な譜体から初める利点は、製譜器が単に導入できただけでなく
きちんと動作することまで確認できる点です。
何より画面に情報を印字する機会はとても多いです。

まずは譜面〈コード〉を収める〈ファイル〉を作る必要があります。
私は企画〈プロジェクト〉専用の `projects` 階層を地階〈ホームディレクトリ〉
に用意して自身の企画をすべてそこに保存するやり方が好きです。
別に Rust は譜面の置き場所を気にしませんが。

これは実際には別に取り組む必要のある懸念の元になります。
それは、この手引書が命令行を最小限扱えることを前提にしているからです。Rust
自身は特に編集の道具についてや譜面をどこに住まわせるかについて要求をしません。
命令行より統合開発環境 (IDE) の方が好みなら [SolidOak][solidoak]
を試してみると合うかもしれませんし、お気に入りの IDE の拡張〈プラグイン〉
でもよいでしょう。数ある様々な品質の拡張機能が有志により開発中です。
Rust 開発班も[様々な書房〈エディタ〉の拡張][plugins]を出荷しています。
書房や IDE の調整はこの本の範囲を超えますので、
具体的には設定用の開発資料集を当たってください。

[solidoak]: https://github.com/oakes/SolidOak
[plugins]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md

などと言いつつ、企画用の階層の中に新しい階層を作っていきます。

```bash
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

Windows 上で PowerShell 以外を使っている場合、`~` は使えません。
詳しくはお使いの司得〈シェル〉の開発資料集を引いてください。

【訳者註】コマンドプロンプトで `~` に相当する場所（地階）は
`C:\Users\【ユーザー名】`です。`~` の代わりに `%USERPROFILE%`
と書いても全く同じです。

次に新しい原譜を作成します。この〈ファイル〉を `main.rs` と呼びます。
Rust の原譜はいつも拡張子 `.rs` がお尻に付いています。
〈ファイル〉名に２単語以上を使うときは下線を用いて、`helloworld.rs` ではなく
`hello_world.rs` と命名します。

譜を開いたので、このように打ち込みます。

```rust
fn main() {
    println!("Hello, world!");
}
```

保存して、端末窓にこう打ち込みます。

```bash
$ rustc main.rs
$ ./main # Windows では main.exe
Hello, world!
```

成功です！ 実際に何が起こったのか詳しく追っていきましょう。

```rust
fn main() {

}
```

これらの行は Rust における *機能* (*function*) を定義しています。
`main` 機能は特別で、全ての Rust 譜体の開始地点になっています。
最初の行はこう読めます。「私は `main` という名前の機能 (*fn*) を宣言します。
それは引数に何も取らず、最後に何も返しません。」
引数を取るには、それらを丸括弧 (小括弧) で括り (`(` と `)`)、
そしてこの機能からは何も返していないので戻り値の型全体を省略できます。
後でそこに着手する予定です。

機能が波括弧（中括弧）で包まれているのにお気づきでしょう(`{` と `}`)。
Rust は機能本体がこのように囲われていることを要求します。
開き括弧を機能宣言と同じ行に置き、
半角空白を一つ挟む書き方が作法であるとも考えられています。

次はこの行の番です。

```rust
    println!("Hello, world!");
```

この行は私達の小さな譜体で行っている仕事のすべてです。
ここには重要な細部がいくつもあります。まず４つの半角空白で字下げされており、
タブ文字を使っていないこと。タブ鍵〈キー〉で４つの空白を挿入するよう、
選びとった書房を調整してください。
私達は[様々な書房用の設定例][configs]も提供しています。

[configs]: https://github.com/rust-lang/rust/tree/master/src/etc/CONFIGS.md

二番目は `println!()` の部分です。これは Rust の[マクロ (macro)][macro]
と呼ばれ、Rust で演譜の演譜〈メタプログラミング〉を行うための手段です。
If it were a
function instead, it would look like this: `println()`. For our purposes, we
don’t need to worry about this difference. Just know that sometimes, we’ll see a
`!`, and that means that we’re calling a macro instead of a normal function.
Rust implements `println!` as a macro rather than a function for good reasons,
but that's an advanced topic. One last thing to mention: Rust’s macros are
significantly different from C macros, if you’ve used those. Don’t be scared of
using macros. We’ll get to the details eventually, you’ll just have to take it
on trust for now.

[macro]: macros.html

Next, `"Hello, world!"` is a ‘string’. Strings are a surprisingly complicated
topic in a systems programming language, and this is a ‘statically allocated’
string. If you want to read further about allocation, check out [the stack and
the heap][allocation], but you don’t need to right now if you don’t want to. We
pass this string as an argument to `println!`, which prints the string to the
screen. Easy enough!

[allocation]: the-stack-and-the-heap.html

Finally, the line ends with a semicolon (`;`). Rust is an [‘expression oriented’
language][expression-oriented language], which means that most things are
expressions, rather than statements. The `;` is used to indicate that this
expression is over, and the next one is ready to begin. Most lines of Rust code
end with a `;`.

[expression-oriented language]: glossary.html#expression-oriented-language

Finally, actually compiling and running our program. We can compile with our
compiler, `rustc`, by passing it the name of our source file:

```bash
$ rustc main.rs
```

This is similar to `gcc` or `clang`, if you come from a C or C++ background.
Rust will output a binary executable. We can see it with `ls`:

```bash
$ ls
main  main.rs
```

Or on Windows:

```bash
$ dir
main.exe  main.rs
```

There are now two files: our source code, with the `.rs` extension, and the
executable (`main.exe` on Windows, `main` everywhere else).

```bash
$ ./main  # or main.exe on Windows
```

This prints out our `Hello, world!` text to our terminal.

If you come from a dynamic language like Ruby, Python, or JavaScript, you may
not be used to these two steps being separate. Rust is an ‘ahead-of-time
compiled language’, which means that we can compile a program, give it to
someone else, and they don't need to have Rust installed. If we give someone a
`.rb` or `.py` or `.js` file, they need to have a Ruby/Python/JavaScript
implementation installed, but we just need one command to both compile and run
our program. Everything is a tradeoff in language design, and Rust has made its
choice.

Congratulations! You have officially written a Rust program. That makes you a
Rust programmer! Welcome. 🎊🎉👍

Next, I'd like to introduce you to another tool, Cargo, which is used to write
real-world Rust programs. Just using `rustc` is nice for simple things, but as
our project grows, we'll want something to help us manage all of the options
that it has, and to make it easy to share our code with other people and
projects.
