% 数字当てゲーム

最初の企画にふさわしい、よく知られた初心者向け演譜問題を実装しましょう。数字当てゲームです。
私達の譜体〈プログラム〉は１から１００までの整数のどれかを無作為〈ランダム〉に生成します。
それから推理した数字を入力するよう指示してくるので、
数字を入れるとそれが大きすぎたか小さすぎたかを教えてくれます。
正しい数字を入れるとすぐに褒めてくれます。良さげでしょ？

<!--For our first project, we’ll implement a classic beginner programming
problem:
the guessing game. Here’s how it works: Our program will generate a random
integer between one and a hundred. It will then prompt us to enter a guess.
Upon entering our guess, it will tell us if we’re too low or too high. Once we
guess correctly, it will  us. Sounds good?-->

# 下準備

新しい企画を立ち上げましょう。企画用 階層〈ディレクトリ〉に移動します。
`hello_world` のときに階層構造と `Cargo.toml` を作った方法を覚えていますか？
Cargo にはそれをやってくれる命令があるのでした。やってみましょう。

<!--Let’s set up a new project. Go to your projects directory. Remember how we
had
to create our directory structure and a `Cargo.toml` for `hello_world`? Cargo
has a command that does that for us. Let’s give it a shot:-->

```bash
$ cd ~/projects
$ cargo new guessing_game --bin
$ cd guessing_game
```

`cargo new` に企画の名前と、譜集〈ライブラリ〉ではなく二進譜を作ろうとしているので
`--bin` 旗〈フラグ〉を渡します。

<!--We pass the name of our project to `cargo new`, and then the `--bin` flag,
since we’re making a binary, rather than a library.-->

生成された `Cargo.toml` を調べます。

<!--Check out the generated `Cargo.toml`:-->

```toml
[package]

name = "guessing_game"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

Cargo はこの情報をご利用の環境から取得します。正しくない場合は修正して次に進みます。

<!--Cargo gets this information from your environment. If it’s not correct, go
ahead
and fix that.-->

最後に、Cargo は「Hello, world!」を生成してくれました。`src/main.rs` を見てみます。

<!-- Finally, Cargo generated a ‘Hello, world!’ for us. Check out `src/main.rs`:
-->

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo が用意してくれたものを製譜 (compile) してみましょう。

<!-- Let’s try compiling what Cargo gave us: -->

```{bash}
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

素晴らしい！ 以後、譜面を `src/main.rs` に書き込んでいくためもう一度開いておきます。

<!--Excellent! Open up your `src/main.rs` again. We’ll be writing all of
our code in this file.-->

次の前に、Cargo のもうひとつの命令 `run` を紹介させてください。`cargo run`
は `cargo build` に似ていますが、生み出された実行形式の実行まで行います。では早速、

<!--Before we move on, let me show you one more Cargo command: `run`. `cargo
run`
is kind of like `cargo build`, but it also then runs the produced executable.
Try it out:-->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
Hello, world!
```
すごい！ `run` 命令は企画上で激しく反復する必要のあるときに大変重宝します。
今回のゲームはまさにこのようなもので、次の一歩の前に手早く今の一歩を試す必要があります。

<!--Great! The `run` command comes in handy when you need to rapidly iterate on
a
project. Our game is just such a project, we need to quickly test each
iteration before moving on to the next one.-->

# 入力の処理

<!-- # Processing a Guess -->

ここからです！ 数字当てゲームに必要な最初のものは数字の入力ができるような何かです。
`src/main.rs` を以下に書き換えます。

<!--Let’s get to it! The first thing we need to do for our guessing game is
allow our player to input a guess. Put this in your `src/main.rs`:-->

```rust,no_run
use std::io;

fn main() {
    println!("数字を当てよ!");

    println!("数字を推理して入力してください。");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .ok()
        .expect("行の読み取りに失敗しました");

    println!("あなたの予想は → {}", guess);
}
```

【訳者註】保存する際、文字符号〈文字コード〉を必ず UTF-8 にしてください。他の選択はありえません。

何かいろいろ出てきました！ 少しずつ、よく考えていきましょう。

<!-- There’s a lot here! Let’s go over it, bit by bit. -->

```rust,ignore
use std::io;
```

利用者からの入力を得て、結果を出力として印字する必要があるわけです。そのため、
標準 (standard) 譜集内の `io` 譜集が必要です。通常 Rust は各算譜に
「[前奏 (prelude)〈プレリュード〉][prelude]」というわずかなものしか取り込みません。
前奏に入っていないものは文字通り「使う」(`use`) 必要があります。２つめの「前奏」である
[`io` 前奏][ioprelude] もあります。それも似たような働きをし、
これを取り込む〈インポートする〉とそれが `io` 関連の便利なものをたくさん取り込んできます。

<!--We’ll need to take user input, and then print the result as output. As such,
we
need the `io` library from the standard library. Rust only imports a few things
by default into every program, [the ‘prelude’][prelude]. If it’s not in the
prelude, you’ll have to `use` it directly. There is also a second ‘prelude’, the
[`io` prelude][ioprelude], which serves a similar function: you import it, and
it
imports a number of useful, `io`-related things.-->

【訳者註】`io` または I/O は Input / Output すなわち「入出力」の略です。

[prelude]: ../std/prelude/index.html
[ioprelude]: ../std/io/prelude/index.html

```rust,ignore
fn main() {
```

前に言ったように、`main()` 機能は譜体の開始地点です。`fn` 構文は新しい機能を宣言し、
`()` は引数を持たないことを示し、`{` から機能本体が始まります。返り値の型は省いたので空の[組〈タプル〉]
[tuples] `()` と見なされます。

<!--As you’ve seen before, the `main()` function is the entry point into your
program. The `fn` syntax declares a new function, the `()`s indicate that
there are no arguments, and `{` starts the body of the function. Because
we didn’t include a return type, it’s assumed to be `()`, an empty
[tuple][tuples].-->

[tuples]: primitive-types.html#tuples

```rust,ignore
    println!("数字を当てよ!");

    println!("数字を推理して入力してください。");
```

`println!()` が画面に[文字列][strings]を印字する[マクロ][macros]であることは前に学びました。

<!--We previously learned that `println!()` is a [macro][macros] that
prints a [string][strings] to the screen.-->

[macros]: macros.html
[strings]: strings.html

```rust,ignore
    let mut guess = String::new();
```

ようやく面白くなってきました！ この短い行の中でたくさんのことが起きています。
まず気づくのは [let 文][let] です。
これは「変数束縛 (variable bindings)」を作るために使われます。形式は次の通りです。

<!--Now we’re getting interesting! There’s a lot going on in this little line.
The first thing to notice is that this is a [let statement][let], which is
used to create ‘variable bindings’. They take this form:-->

```rust,ignore
let なんとか = かんとか;
```

[let]: variable-bindings.html

【訳者註】`let` は「−にする」「−させる」の意味です。
よって上記は「なんとか(の値)をかんとかにする」と読めます。

これは `なんとか` と名付けられた新しい束縛を作り、そこに値 `かんとか` を束縛します。
多くの言語ではこれを(数に限らず)「変数 (variable)」と呼びますが、Rust の変数束縛は他とは
ちょっと異なります。

<!--This will create a new binding named `foo`, and bind it to the value `bar`.
In
many languages, this is called a ‘variable’, but Rust’s variable bindings have
a few tricks up their sleeves.？？？-->

例えば、あえて指示しない限り[不変][immutable] (immutable) になります。
さっきの例に `mut` が付いていたのはそのためで、束縛を不変ではなく可変 (mutable) にする効果があります。
`let` の文の左辺に置かれるのは名前だけに限りません。実は「[模式 (pattern)〈パターン〉][patterns]」
をとることができます。模式は後で使っていきます。今はこれだけで十分です。

<!--For example, they’re [immutable][immutable] by default. That’s why our
example
uses `mut`: it makes a binding mutable, rather than immutable. `let` doesn’t
take a name on the left hand side of the assignment, it actually accepts a
‘[pattern][patterns]’. We’ll use patterns later. It’s easy enough
to use for now:-->

```rust
let あれ = 5; // 不変 immutable
let mut それ = 5; // 可変 mutable
```

[immutable]: mutability.html
[patterns]: patterns.html

あ、っと「`//`」は注釈 (comment)〈コメント〉の始まりで、その行末までの全てを Rust
は[注釈][comments]として無視します。

<!--Oh, and `//` will start a comment, until the end of the line. Rust ignores
everything in [comments][comments].-->

[comments]: comments.html

というわけで `let mut guess` が `guess` という名前の可変な束縛を設けることが分かりました。
さて、`=` の右辺にある束縛される側も見なければなりません。`String::new()` です。

<!--So now we know that `let mut guess` will introduce a mutable binding named
`guess`, but we have to look at the other side of the `=` for what it’s
bound to: `String::new()`.-->

`String` は文字列 (string) 型 (type) で、標準譜集で提供されています。
[`String`][string] は UTF-8 方式で符号化された伸長可能な文章です。

<!--`String` is a string type, provided by the standard library. A
[`String`][string] is a growable, UTF-8 encoded bit of text.-->

[string]: ../std/string/struct.String.html

`::new()` 構文はある特定の型の「付属機能 (associated function)」なので `::` を使っています。
言うなれば、具体的な `String` のどれかではなく `String` 自身にひも付いているものです。
これを「静的操作法 (static method)」と呼ぶ言語もあります。

<!--The `::new()` syntax uses `::` because this is an ‘associated function’ of
a particular type. That is to say, it’s associated with `String` itself,
rather than a particular instance of a `String`. Some languages call this a
‘static method’.-->

この機能の名前が `new()` な理由は、新しい、空の `String` を作ることにあります。
ある種の新しい値を作るときによく使われる名前なので、多くの型に `new()` 機能を見かけることでしょう。

<!--This function is named `new()`, because it creates a new, empty `String`.
You’ll find a `new()` function on many types, as it’s a common name for making
a new value of some kind.-->

次へ進みましょう。

<!-- Let’s move forward: -->

```rust,ignore
    io::stdin().read_line(&mut guess)
        .ok()
        .expect("行の読み取りに失敗しました");
```

もっと増えました！ひとつずつやりましょう。最初の行は２つに分かれます。
１つ目はここ、

<!--That’s a lot more! Let’s go bit-by-bit. The first line has two parts.
Here’s
the first:-->

```rust,ignore
io::stdin()
```

`std::io` をこの算譜の一番最初の行で使った (`use`) ことを覚えていますか？
いまここでその付属機能を呼び出しているのです。
`use std::io` していなかった場合は、代わりに `std::io::stdio()` と書いていたことでしょう。

<!--Remember how we `use`d `std::io` on the first line of the program? We’re now
calling an associated function on it. If we didn’t `use std::io`, we could
have written this line as `std::io::stdin()`.-->

この特別な機能はお使いの端末の標準入力 (standard input, 通称 stdin) への手綱〈ハンドル〉を返します。
より正確には、[std::io::Stdin][iostdin] です。

<!--This particular function returns a handle to the standard input for your
terminal. More specifically, a [std::io::Stdin][iostdin].-->

[iostdin]: ../std/io/struct.Stdin.html

次の部分でこの手綱を使って利用者からの入力を得ます。

<!-- The next part will use this handle to get input from the user: -->

```rust,ignore
.read_line(&mut guess)
```

ここでは、手綱から(行読み) [`read_line()`][read_line] 操作法を呼びます。
[操作法 (method)〈メソッド〉][method] は付属機能に近いですが、
型自身でなく型の何かしらの実例に対してのみ利用出来ます。
`read_line()` には引数もひとつ `&mut guess` 渡しています。

<!--Here, we call the [`read_line()`][read_line] method on our handle.
[Methods][method] are like associated functions, but are only available on a
particular instance of a type, rather than the type itself. We’re also passing
one argument to `read_line()`: `&mut guess`.-->

[read_line]: ../std/io/struct.Stdin.html#method.read_line
[method]: method-syntax.html

`guess` をどのように束縛したか覚えていますか？可変であるといいましたが、
`read_line` は `String` を引数に取りません。`read_line` が取るのは `&mut String` です。
Rust には「[参照 (references)][references]」という仕組みがあり、
ひとつの場所にある実体に複数の場所から参照をはることで無駄な複写をなくすことができます。
参照は複雑な仕組みであり、参照を安全・カンタンに扱える点が Rust の大きな売りになっているほどです。
今作っている算譜を完成させるにあたって詳しいところまでたくさん知っている必要はないですけどね。
とりあえず知っておくべきことは、`let` 束縛のように参照も特に指示しない限りは不変であるということです。
ですので、`&guess` の代わりに `&mut guess` と書く必要があります。

<!--Remember how we bound `guess` above? We said it was mutable. However,
`read_line` doesn’t take a `String` as an argument: it takes a `&mut String`.
Rust has a feature called ‘[references][references]’, which allows you to have
multiple references to one piece of data, which can reduce copying. References
are a complex feature, as one of Rust’s major selling points is how safe and
easy it is to use references. We don’t need to know a lot of those details to
finish our program right now, though. For now, all we need to know is that
like `let` bindings, references are immutable by default. Hence, we need to
write `&mut guess`, rather than `&guess`.-->

どうして `read_line()` は文字列への可変な参照を取るのでしょうか？
その仕事は利用者が標準入力へ打ち込んだものを得てそれを文字列に置くことです。
そうするためにあの文字列を引数に取って、入力を追加するために可変でなければならないのです。

<!--Why does `read_line()` take a mutable reference to a string? Its job is
to take what the user types into standard input, and place that into a
string. So it takes that string as an argument, and in order to add
the input, it needs to be mutable.-->

[references]: references-and-borrowing.html

この行の譜はここで終わりではありませんよ。
一行ではありますが、実は論理的な行の始めの部分にすぎないのです。残りは、

<!--But we’re not quite done with this line of code, though. While it’s
a single line of text, it’s only the first part of the single logical line of
code:-->

```rust,ignore
        .ok()
        .expect("行の読み取りに失敗しました");
```

`.なんとか()` 構文で操作法を呼んだときは、改行して空白をいれても構いません。
長い行を分けられる点が嬉しいですね。 _あえて_ こう書くこともできました。

<!--When you call a method with the `.foo()` syntax, you may introduce a newline
and other whitespace. This helps you split up long lines. We _could_ have
done:-->

```rust,ignore
    io::stdin().read_line(&mut guess).ok().expect("行の読み取りに失敗しました");
```

が、これでは読みにくくなってしまいます。なので３つの操作呼び出しを３行に分けました。
`read_line()` についてはもう話しましたが、`ok()` と `expect()` は何でしょうか？
ええ、`read_line()` が利用者の入力を渡した `&mut String` に入れることにはもう触れましたが、
そこで帰ってくる値は、[`io::Result`][ioresult] になっています。Rust には結果 (`Result`)
という名前の型が標準譜集にたくさんあります。一般的な [`Result`][result] や、
下位譜集専用版の `io::Result` などです。

<!--But that gets hard to read. So we’ve split it up, three lines for three
method calls. We already talked about `read_line()`, but what about `ok()`
and `expect()`? Well, we already mentioned that `read_line()` puts what
the user types into the `&mut String` we pass it. But it also returns
a value: in this case, an [`io::Result`][ioresult]. Rust has a number of
types named `Result` in its standard library: a generic [`Result`][result],
and then specific versions for sub-libraries, like `io::Result`.-->

[ioresult]: ../std/io/type.Result.html
[result]: ../std/result/enum.Result.html

これらの `Result` 型の目的は誤り対処の情報を符号にすることです。
`Result` 型の値は他の型と同じく操作法が定義されています。この場合、`io::Result` は `ok()` 操作法をもち、
「この値が成功時のものだとしたい、違ったら誤り情報を投げてくれ」と言っています。
投げ捨てるのはなぜでしょうか？
そうですね、簡単な譜体として、基本的に何か問題があったら続行不可能なので、
全体誤りを印字するだけにしたいです。
[`ok()` 操作法][ok] が返す値には別の操作法 `expect()` が定義されています。[`expect()` 操作法][expect]
は呼んだ値を取り、それが失敗の値だった場合は渡した伝言で [`panic!`][panic] します。
このような `panic!` は作った譜体を急停止〈クラッシュ〉させ、その伝言を表示します。

<!--The purpose of these `Result` types is to encode error handling information.
Values of the `Result` type, like any type, have methods defined on them. In
this case, `io::Result` has an `ok()` method, which says ‘we want to assume
this value is a successful one. If not, just throw away the error
information’. Why throw it away? Well, for a basic program, we just want to
print a generic error, as basically any issue means we can’t continue. The
[`ok()` method][ok] returns a value which has another method defined on it:
`expect()`. The [`expect()` method][expect] takes a value it’s called on, and
if it isn’t a successful one, [`panic!`][panic]s with a message you
passed it. A `panic!` like this will cause our program to crash, displaying
the message.-->

[ok]: ../std/result/enum.Result.html#method.ok
[expect]: ../std/option/enum.Option.html#method.expect
[panic]: error-handling.html

この２つの操作法を削っても製譜はできますが、警告をもらいます。

<!--If we leave off calling these two methods, our program will compile, but
we’ll get a warning:-->

```bash
$ cargo build
   製譜中 guessing_game v0.1.0 (file:///home/名前/projects/guessing_game)
src/main.rs 10行5列~10行39列 警告。使われるべき結果が未使用です。
#[警告(未使用使うべし)] は通常有効です。
src/main.rs 10行     io::stdin().read_line(&mut guess);
                   ↑~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

実際の表示は以下のようになります。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
src/main.rs:10:5: 10:39 warning: unused result which must be used,
#[warn(unused_must_use)] on by default
src/main.rs:10     io::stdin().read_line(&mut guess);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

Rust は `Result` 値を使っていなかったことで警告しました。この警告は `io::Result`
に付された特別な補注〈アノテーション〉によるものです。Rust
はあなたが発生しうる誤りに対処していないことを伝えようとしています。この誤りをなくす正攻法は、
実際に誤りの対処を書くことです。
幸運にも、問題があるときに急停止させたいだけの場合は２つの小さな操作法を使うことができます。
誤りからどうにか回復できる場合は他にやることもあるでしょうが、それはあとの企画のために取っておきます。

<!--Rust warns us that we haven’t used the `Result` value. This warning comes
from
a special annotation that `io::Result` has. Rust is trying to tell you that you
haven’t
handled a possible error. The right way to suppress the error is
to actually write error handling. Luckily, if we just want to crash if there’s
a problem, we can use these two little methods. If we can recover from the
error somehow, we’d do something else, but we’ll save that for a future
project.-->

この最初の例も残すは１行になりました。

<!-- There’s just one line of this first example left: -->

```rust,ignore
    println!("あなたの予想は → {}", guess);
}
```

入力を取っておいた文字列を印字しています。`{}` は穴埋め〈プレースホルダー〉で、よって `guess`
を引数として渡しています。`{}` が複数あったらその数だけ引数を渡します。

<!--This prints out the string we saved our input in. The `{}`s are a
placeholder,
and so we pass it `guess` as an argument. If we had multiple `{}`s, we would
pass multiple arguments:-->

```rust
let x = 5;
let y = 10;

println!("x と y は {} と {}", x, y);
```

余裕です。

<!-- Easy. -->

ともかく、これは練習です。`cargo run` して何が出るか見られます。

<!-- Anyway, that’s the tour. We can run what we have with `cargo run`: -->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
数字を当てよ!
数字を推理して入力してください。
6
あなたの予想は → 6
```

よし！ 鍵盤〈キーボード〉から入力を得てそれを印字しなおすという最初の部分が終わりました。

<!--All right! Our first part is done: we can get input from the keyboard,
and then print it back out.-->

# 秘密の数字を作りだそう

<!-- # Generating a secret number -->

次に、秘密の数字を生成する必要があります。
Rust の標準譜集に乱数生成器はまだ入っていませんが、Rust 開発班は
[`rand` わく箱][randcrate] を用意しています。「わく箱 (crate)〈クレート〉」は Rust
譜面の〈パッケージ〉です。私達の作っている「二進譜わく箱」は実行可能形式です。
`rand` は「譜集わく箱」で、他の算譜から使われることを意図した譜面を含んでいます。

<!--Next, we need to generate a secret number. Rust does not yet include random
number functionality in its standard library. The Rust team does, however,
provide a [`rand` crate][randcrate]. A ‘crate’ is a package of Rust code.
We’ve been building a ‘binary crate’, which is an executable. `rand` is a
‘library crate’, which contains code that’s intended to be used with other
programs.-->

[randcrate]: https://crates.io/crates/rand

外部のわく箱  を使うとき Cargo はその真価を発揮します。`rand` を使った譜面を書く前に `Cargo.toml`
の変更が必要です。開いて、末尾に数行足します。

<!--Using external crates is where Cargo really shines. Before we can write
the code using `rand`, we need to modify our `Cargo.toml`. Open it up, and
add these few lines at the bottom:-->

```toml
[dependencies]

rand="0.3.0"
```

`Cargo.toml` の依存物の節 `[dependencies]` は `[package]` の節に似ており、
節の始まりから次の節の始まりまでの間にあるものはその節の一部になります。
Cargo は dependencies 節を見てどんな外部のわく箱への依存があるかを知ります。
また、あなたが要求した版数もそこで知ります。この場合の指定は約 `0.3.0` 版になっており、
Cargo はこの版と互換性のある版ならどれでもよいと理解します。
Cargo は版号の書き方の標準である[意味論的付版 (Semantic Versioning)][semver] を理解します。
厳格に第 `0.3.0` 版だけを使わせたい場合は、`=0.3.0` と書けます。最新版を使いたい場合は `*` を使えます。
さらに、版の範囲指定も可能です。[Cargo の開発資料集][cargodoc]に詳細があります。

<!--`[dependencies]` section of `Cargo.toml` is like the `[package]` section:
everything that follows it is part of it, until the next section starts.
Cargo uses the dependencies section to know what dependencies on external
crates you have, and what versions you require. In this case, we’ve specified
version `0.3.0`,
which Cargo understands to be any release that’s compatible with this specific
version.
Cargo understands [Semantic Versioning][semver], which is a standard for
writing version
numbers. If we wanted to use only `0.3.0` exactly, we could use `=0.3.0`. If we
wanted to use the latest version we could use `*`; We could use a range of
versions. [Cargo’s documentation][cargodoc] contains more details.-->

[semver]: http://semver.org
[cargodoc]: http://doc.crates.io/crates-io.html

それでは、譜面はそのまま企画を織り上げましょう。

<!-- Now, without changing any of our code, let’s build our project: -->

```bash
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.8
 Downloading libc v0.1.6
   Compiling libc v0.1.6
   Compiling rand v0.3.8
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

(もちろん、見える版は異なる場合があります)

<!-- (You may see different versions, of course.) -->

目新しい出力がたくさん！外部依存性ができたので、Cargo
は [Crates.io][cratesio] から写した登記簿〈レジストリ〉からそれぞれの最新版を取得します。
Crates.io は Rust 生態系の中の人々が他の人々のために〈オープンソース〉の Rust 企画を投稿する場所です。

<!--Lots of new output! Now that we have an external dependency, Cargo fetches
the
latest versions of everything from the registry, which is a copy of data from
[Crates.io][cratesio]. Crates.io is where people in the Rust ecosystem
post their open source Rust projects for others to use.-->

[cratesio]: https://crates.io

登記簿の更新後、Cargo は私達の `[dependencies]` を調べて未入荷のわく箱を入荷します。
今回は `rand` に依存したいと言っただけなのに `libc` も入荷されました。
これは、`rand` が動作するために `libc` に依存しているためです。
これらの入荷後、それぞれ製譜して、それから私達の企画を製譜します。

<!--After updating the registry, Cargo checks our `[dependencies]` and downloads
any we don’t have yet. In this case, while we only said we wanted to depend on
`rand`, we’ve also grabbed a copy of `libc`. This is because `rand` depends on
`libc` to work. After downloading them, it compiles them, and then compiles
our project.-->

`cargo build` を再度走らせると異なる出力が得られます。

<!-- If we run `cargo build` again, we’ll get different output: -->

```bash
$ cargo build
```

この通り、何もありません！ Cargo は私達の企画が織り上がり、その依存物もすべて織り上がり、
もはや なにもする必要がないことを知っています。することがないので終了するのみです。
`src/main.rs` をもう一度開いてちょっとでも手を加え、もう一度保存すると、一行表れるのが見えるでしょう。

<!--That’s right, no output! Cargo knows that our project has been built, and that
all of its dependencies are built, and so there’s no reason to do all that
stuff. With nothing to do, it simply exits. If we open up `src/main.rs` again,
make a trivial change, and then save it again, we’ll just see one line:-->

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

そう、Cargo に `rand` の `0.3.x` 系のどれかが必要だと伝えたので、これが書かれた時点の最新版、第 `0.3.8`
版を取ってきました。しかし一週間後、重大な不具合修正を含む第 `v0.3.9` 版が登場したとしたら？
不具合修正を入手することが大事な一方、もし `0.3.9` が譜面を壊す退行〈リグレッション〉を含んでいたら？

<!--So, we told Cargo we wanted any `0.3.x` version of `rand`, and so it fetched
the latest
version at the time this was written, `v0.3.8`. But what happens when next
week, version `v0.3.9` comes out, with an important bugfix? While getting
bugfixes is important, what if `0.3.9` contains a regressio that breaks our
code?-->

この問題への答えは今のあなたの企画階層の下にある `Cargo.lock` ファイルです。最初に企画を織ったとき、
Cargo が指示した基準に合った全ての版を見い出してそれらを `Cargo.lock` ファイルに書き込みます。
今後企画を織るとき Cargo は `Cargo.lock` の存在を知り、
もう一度版を探す作業を繰り返さずに先の版を使います。
これにより、何度でも織り上げられる状態に自動的になります。
つまり、意識的に昇格〈アップグレード〉するまで `0.3.8` のままということです。
固定 (lock) ファイルのおかげで、私達の譜面を共有した誰もがそうなります。

<!--The answer to this problem is the `Cargo.lock` file you’ll now find in your
project directory. When you build your project for the first time, Cargo
figures out all of the versions that fit your criteria, and then writes them
to the `Cargo.lock` file. When you build your project in the future, Cargo
will see that the `Cargo.lock` file exists, and then use that specific version
rather than do all the work of figuring out versions again. This lets you
have a repeatable build automatically. In other words, we’ll stay at `0.3.8`
until we explicitly upgrade, and so will anyone who we share our code with,
thanks to the lock file.-->

`v0.3.9` を _使いたい_ と思ったときはどうでしょうか？ Cargo にはもうひとつの命令 `update` があります。
これは「固定は行なわず、指定した条件に合う最新版をそれぞれ探しだし、
うまくいったらそれらの版を固定ファイルに書き込みなさい」という意味です。
しかし、黙用時に Cargo は `0.3.0` より大きく `0.4.0` より小さい版のみを探します。
`0.4.x` 系に移行したい場合は、`Cargo.toml` を直接変更せざるを得ません。そうすると、次回 `cargo build`
したときに Cargo が目次を更新し `rand` の求めるものを再評価します。

<!--What about when we _do_ want to use `v0.3.9`? Cargo has another command,
`update`, which says ‘ignore the lock, figure out all the latest versions that
fit what we’ve specified. If that works, write those versions out to the lock
file’. But, by default, Cargo will only look for versions larger than `0.3.0`
and smaller than `0.4.0`. If we want to move to `0.4.x`, we’d have to update
the `Cargo.toml` directly. When we do, the next time we `cargo build`, Cargo
will update the index and re-evaluate our `rand` requirements.-->

[Cargo][doccargo] と[その生態系][doccratesio]について言葉を尽くしたいことはまだまだありますが、
今はこれだけ知っておけば大丈夫です。Cargo は譜集をとても簡単に再利用できるようにします。
だから、Rustacean 達はいくつもの小さな企画を書き、
それらを多数の下位〈パッケージ〉として組み上げることが多いです。

<!--There’s a lot more to say about [Cargo][doccargo] and [its
ecosystem][doccratesio], but for now, that’s all we need to know. Cargo makes
it really easy to re-use libraries, and so Rustaceans tend to write smaller
projects which are assembled out of a number of sub-packages.-->

[doccargo]: http://doc.crates.io
[doccratesio]: http://doc.crates.io/crates-io.html

実際に `rand` を _使ってみる_ことにしましょう。次の一歩はこうです。

<!--Let’s get on to actually _using_ `rand`. Here’s our next step:-->

```rust,ignore
extern crate rand;

use std::io;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    println!("数字を推理して入力してください。");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .ok()
        .expect("行の読み取りに失敗しました");

    println!("あなたの予想は → {}", guess);
}
```

まず初めにしたことは１行目の変更です。`extern crate rand` となったところです。
`rand` を `[dependencies]` 内で宣言したので `extern crate` を使って Rust
にそれを利用するぞと伝えることができます。これは `use rand;` と全く同じ意味もあるため `rand` わく箱の中のものなら何でも `rand::`
を頭につけることで利用できるようになりました。

<!--The first thing we’ve done is change the first line. It now says
`extern crate rand`. Because we declared `rand` in our `[dependencies]`, we
can use `extern crate` to let Rust know we’ll be making use of it. This also
does the equivalent of a `use rand;` as well, so we can make use of anything
in the `rand` crate by prefixing it with `rand::`.-->

次に、`use` 行をもうひとつ加えました。`use rand::Rng` がそれです。`Rng` を要求する操作法をすぐ使うつもりのため `Rng`
が有効範囲内に入っていなければなりません。
基本的な考え方は、操作法は「特性 (trait)〈トレイト〉」と呼ばれるものの上に定義されていて、
その操作法が動くためにはその特性が有効範囲内に入っている必要があるということです。
詳しい内容は[特性][traits]の章をご覧ください。

<!--Next, we added another `use` line: `use rand::Rng`. We’re going to use a
method in a moment, and it requires that `Rng` be in scope to work. The basic
idea is this: methods are defined on something called ‘traits’, and for the
method to work, it needs the trait to be in scope. For more about the
details, read the [traits][traits] section.-->

[traits]: traits.html

中央に別の２行を追加しています。

<!--There are two other lines we added, in the middle:-->

```rust,ignore
    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);
```

`rand::thread_rng()` 機能を使って乱数生成器の写しを得ます。
それは実行中の特定の[〈スレッド〉][concurrency]に局所的なものです。
上で `use rand::Rng` したので `gen_range()` 操作法が利用可能になりました。
この操作は２つの引数を取り、両者の間の数を一つ生成します。
数の範囲には下限を含みますが、上限は含まれません。
よって、１から１００までの数字を得るには `1` と `101` を指定する必要があります。

<!--We use the `rand::thread_rng()` function to get a copy of the random number
generator, which is local to the particular [thread][concurrency] of execution
we’re in. Because we `use rand::Rng`’d above, it has a `gen_range()` method
available. This method takes two arguments, and generates a number between
them. It’s inclusive on the lower bound, but exclusive on the upper bound,
so we need `1` and `101` to get a number ranging from one to a hundred.-->

[concurrency]: concurrency.html

二番目の行は単に秘密の数字を印字しています。
こうすると動作を簡単に検査できるので譜体の開発中は大変役に立ちます。
もちろん、最終版では削除する予定です。はじまる前から答えが見えていてはゲームになりませんからね。

<!--The second line just prints out the secret number. This is useful while
we’re developing our program, so we can easily test it out. But we’ll be
deleting it for the final version. It’s not much of a game if it prints out
the answer when you start it up!-->

新しくなった譜体を少し試してみます。

<!--Try running our new program a few times:-->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
数字を当てよ!
秘密の数字は …… 7
数字を推理して入力してください。
4
あなたの予想は → 4
$ cargo run
     Running `target/debug/guessing_game`
数字を当てよ!
秘密の数字は …… 83
数字を推理して入力してください。
5
あなたの予想は → 5
```

いいぞ！ 次は、推理された数字と秘密の数字を比べましょう。

<!--Great! Next up: let’s compare our guess to the secret guess.-->

# 数字を比較しよう

<!--# Comparing guesses-->

入力が手に入ったので当てずっぽうの数字と予想した数字を比べましょう。
次の段階はこうなりますが、まだ製譜はできません。

<!--Now that we’ve got user input, let’s compare our guess to the random guess.
Here’s our next step, though it doesn’t quite compile yet:-->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    println!("数字を推理して入力してください。");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .ok()
        .expect("行の読み取りに失敗しました");

    println!("あなたの予想は → {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("もっと大きい！"),
        Ordering::Greater => println!("もっと小さい！"),
        Ordering::Equal   => println!("あなたの勝ちです！"),
    }
}
```

新しいところがいくつか。まずはもう一つの `use` 。
型 `std::cmp::Ordering` を有効範囲に持ってきました。それから、下側にそれを使った５行。

<!--A few new bits here. The first is another `use`. We bring a type called
`std::cmp::Ordering` into scope. Then, five new lines at the bottom that use
it:-->

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("もっと大きい！"),
    Ordering::Greater => println!("もっと小さい！"),
    Ordering::Equal   => println!("あなたの勝ちです！"),
}
```

`cmp()` 操作法は比較できるものに対して呼ぶことができ、比較対象の参照を取ります。
返り値はさっき `use` した `Ordering` 型です。`Ordering` のどの種類かピタリと判定するために [`match`][match]
文を使います。`Ordering` は[列挙体 (`enum`)][enum] であり「すべて枚挙したもの (enumueration)」の略です。
例えば、次のように定義されています。

<!--The `cmp()` method can be called on anything that can be compared, and it
takes a reference to the thing you want to compare it to. It returns the
`Ordering` type we `use`d earlier. We use a [`match`][match] statement to
determine exactly what kind of `Ordering` it is. `Ordering` is an
[`enum`][enum], short for ‘enumeration’, which looks like this:-->

```rust
enum Foo {
    Bar,
    Baz,
}
```

[match]: match.html
[enum]: enums.html

この定義では型 `Foo` である値は必ず `Foo::Bar` または `Foo::Baz` のどちらかです。
`::` を使って特定の `enum` の値を含む名前空間を示します。

<!--With this definition, anything of type `Foo` can be either a
`Foo::Bar` or a `Foo::Baz`. We use the `::` to indicate the
namespace for a particular `enum` variant.-->

順序列挙体 [`Ordering`][ordering] `enum` は３つの形を取ることができます。
より小さい `Less` ・ 等しい `Equal` ・ より大きい `Greater` の３つです。
`match` 文はある型の値を取って可能な値それぞれに対する「分岐」を作ることができます。
３種類の `Ordering` があるので３種類の分岐があります。

<!--The [`Ordering`][ordering] `enum` has three possible variants: `Less`,
`Equal`,
and `Greater`. The `match` statement takes a value of a type, and lets you
create an ‘arm’ for each possible value. Since we have three types of
`Ordering we have three arms:-->

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("もっと大きい！"),
    Ordering::Greater => println!("もっと小さい！"),
    Ordering::Equal   => println!("あなたの勝ちです！"),
}
```

[ordering]: ../std/cmp/enum.Ordering.html

結果が `Less` だった場合は、`もっと大きい！`を、`Greater` だった場合は`もっと小さい！`を、`Equal`
だった場合は`あなたの勝ちです！`を印字します。
`match` はあまりに便利なため Rust ではしょっちゅう使われています。

<!--If it’s `Less`, we print `もっと大きい！`, if it’s `Greater`, `もっと小さい！`, and if
`Equal`, `あなたの勝ちです！`. `match` is really useful, and is used often in Rust.-->

まだ製譜はできないと言っていましたね。やってみましょう。

<!-- I did mention that this won’t quite compile yet, though. Let’s try it: -->

```bash
$ cargo build
   製譜中 guessing_game v0.1.0 (file:///home/名前/projects/guessing_game)
src/main.rs内28行21列~28行35列 誤り。型が噛み合いません。
 `&collections::string::String` と思いきや、
    `&_` でした
(構造体 `collections::string::String` と思いきや、
    整数の変数でした。) [E0308]
src/main.rs内28行     match guess.cmp(&secret_number) {
                                     ↑~~~~~~~~~~~~~
誤り。前述の誤りにより中止します
`guessing_game` を製譜できませんでした。
```

例のごとく本物の Rust 製譜器の出力を並べます。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
src/main.rs:28:21: 28:35 error: mismatched types:
 expected `&collections::string::String`,
    found `&_`
(expected struct `collections::string::String`,
    found integral variable) [E0308]
src/main.rs:28     match guess.cmp(&secret_number) {
                                   ^~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `guessing_game`.
```

なんと！ これは大きな間違いでした。
「型が噛み合わない (mismatched types)」点がそのキモです。
Rust は強い、静的な型体系を備えています。一方、型推論も備えています。
`let guess = String::new()` と書いた瞬間、Rust は `guess` が `String` であるべきと推論することが可能です。
そうすることで私達はわざわざ型を書かずに済んでいます。`secret_number` については、
１から１００までの値が持てる型がいろいろあり、32ビット整数の `i32`、32ビット非負 (unsigned) 整数の `u32`、64ビット整数の
`i64` 、…他にもあります。これまでのところ、それは問題になっておらず、Rust は `i32` を黙用します。
しかし、ここで、Rust は `guess` と `secret_number` を比較する方法を知りません。
両者は同じ型でなければなりません。最終的には、入力として読みだした `String` を比較のために実数型へ変換したいです。
３行の追加で可能になります。新しい譜面はこの通り。

<!--Whew! This is a big error. The core of it is that we have ‘mismatched types’.
Rust has a strong, static type system. However, it also has type inference.
When we wrote `let guess = String::new()`, Rust was able to infer that `guess`
should be a `String`, and so it doesn’t make us write out the type. And with
our `secret_number`, there are a number of types which can have a value
between one and a hundred: `i32`, a thirty-two-bit number, or `u32`, an
unsigned thirty-two-bit number, or `i64`, a sixty-four-bit number or others.
So far, that hasn’t mattered, and so Rust defaults to an `i32`. However, here,
Rust doesn’t know how to compare the `guess` and the `secret_number`. They
need to be the same type. Ultimately, we want to convert the `String` we
read as input into a real number type, for comparison. We can do that
with three more lines. Here’s our new program:-->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    println!("数字を推理して入力してください。");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .ok()
        .expect("行の読み取りに失敗しました");

    let guess: u32 = guess.trim().parse()
        .ok()
        .expect("数字を１つ入力してください！");

    println!("あなたの予想は → {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("もっと大きい！"),
        Ordering::Greater => println!("もっと小さい！"),
        Ordering::Equal   => println!("あなたの勝ちです！"),
    }
}
```

新しい３行はこちら。

<!-- The new three lines: -->

```rust,ignore
    let guess: u32 = guess.trim().parse()
        .ok()
        .expect("数字を１つ入力してください！");
```

ちょっと待って、`guess` はもう作ったはずですが？
そうです。しかし、Rust は以前の `guess` を新しいもので「覆い隠す (shadow)」ことを認めています。
ちょうどこのような、`guess` がはじめ `String` だったけれど `u32` に変換したくなった状況でよく使われる方法です。
覆い隠すことで `guess` という名前を再利用でき、`guess_str` と `guess` 等々のように２つのかぶらない名前を考える
ことに労を費やさずに済みます。

<!--Wait a minute, I thought we already had a `guess`? We do, but Rust allows us
to ‘shadow’ the previous `guess` with a new one. This is often used in this
exact situation, where `guess` starts as a `String`, but we want to convert it
to an `u32`.
Shadowing lets us re-use the `guess` name, rather than forcing us
to come up with two unique names like `guess_str` and `guess`, or something
else.-->

`guess` を以前に書いたものに近い形の式に束縛します。

<!-- We bind `guess` to an expression that looks like something we wrote earlier: -->

```rust,ignore
guess.trim().parse()
```

`ok().expect()` の呼出しの次です。ここで、`guess` は古い方の `guess` をさし、入力が入っている `String`
の方です。`String` の `trim()` 操作法は文字列の両端にある空白を取り除きます。
`read_line()` を満足させるために「Enter」(または「Return」)鍵を押す必要があるためこれが重要です。
どういう意味かというと、`5` を打って Enter 鍵を叩くと、`guess` は `5\n` となります。
`\n` は「改行 (newline)」を表す特殊文字で Enter 鍵です。`trim()` はこれをなくして `5`
が残るようにしています。[文字列の `parse()` 操作法][parse]は文字列を何かしらの数に変換します。
変換先になりうる数の種類はとても多いので、Rust にどの型の数が欲しいか正確に伝える必要があります。
そういうわけで、`let guess: u32` です。`guess` の直後のコロン (`:`) は Rust にその型を補注したいと言っています。
`u32` は１つの、非負の（符号なし、０または正の数）３２ビット(長の) 整数です。
Rust は[多種にわたる織り込み済み〈ビルトイン〉数値型][number]を持っていますが、私達は `u32`
を選びました。`u32` は小さな正(と０)の整数に向いている普通の選択肢です。

<!--Followed by an `ok().expect()` invocation. Here, `guess` refers to the old
`guess`, the one that was a `String` with our input in it. The `trim()`
method on `String`s will eliminate any white space at the beginning and end of
our string. This is important, as we had to press the ‘return’ key to satisfy
`read_line()`. This means that if we type `5` and hit return, `guess` looks
like this: `5\n`. The `\n` represents ‘newline’, the enter key. `trim()` gets
rid of this, leaving our string with just the `5`. The [`parse()` method on
strings][parse] parses a string into some kind of number. Since it can parse a
variety of numbers, we need to give Rust a hint as to the exact type of number
we want. Hence, `let guess: u32`. The colon (`:`) after `guess` tells Rust
we’re going to annotate its type. `u32` is an unsigned, thirty-two bit
integer. Rust has [a number of built-in number types][number], but we’ve
chosen `u32`. It’s a good default choice for a small positive number.-->

[parse]: ../std/primitive.str.html#method.parse
[number]: primitive-types.html#numeric-types

`read_line()` と同じように、`parse()` の呼出しは誤りを生じ得ます。
もし文字列が `A👍%` だったら？ これを１つの数値に変換する方法はないでしょう。
というわけで、`read_line()` でやったのと同じように `ok()` と `expect()` 操作法を使って誤りがあった場合に譜体を急停止させます。

<!--Just like `read_line()`, our call to `parse()` could cause an error. What if
our string contained `A👍%`? There’d be no way to convert that to a number. As
such, we’ll do the same thing we did with `read_line()`: use the `ok()` and
`expect()` methods to crash if there’s an error.-->

できた算譜を試してみましょう！

<!-- Let’s try our program out! -->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
数字を当てよ!
秘密の数字は …… 58
数字を推理して入力してください。
  76
あなたの予想は → 76
もっと小さい！
```

いいですね！数字の前に空白を足しても 76 を予想したと分かってくれたことが見てとれます。
何度か実行してみて、小さすぎる数字の予想について数字当てが機能しているか確かめてください。

<!--Nice! You can see I even added spaces before my guess, and it still
figured
out that I guessed 76. Run the program a few times, and verify that guessing
the number works, as well as guessing a number too small.-->

これでゲームの大半が動くようになってきましたが、まだ一回しか推理できません。
繰り返し (loop)〈ループ〉を加えてその点を改善しましょう。

<!--Now we’ve got most of the game working, but we can only make one guess.
Let’s
change that by adding loops!-->

# 繰り返し

<!-- # Looping -->

予約語 `loop` の力で無限繰り返し〈無限ループ〉を作れます。これを中に追加して…

<!-- The `loop` keyword gives us an infinite loop. Let’s add that in: -->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    loop {
        println!("数字を推理して入力してください。");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .ok()
            .expect("行の読み取りに失敗しました");

        let guess: u32 = guess.trim().parse()
            .ok()
            .expect("数字を１つ入力してください！");

        println!("あなたの予想は → {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("もっと大きい！"),
            Ordering::Greater => println!("もっと小さい！"),
            Ordering::Equal   => println!("あなたの勝ちです！"),
        }
    }
}
```

そして試してみましょう。でも待ってください、私達が足したのはただの無限繰り返しですよね？
そうです。`parse()` についての議論を覚えていますか？
数字でない答えを与えたときは `return` して終了するといいました。観察しましょう。

<!--And try it out. But wait, didn’t we just add an infinite loop? Yup. Remember
our discussion about `parse()`? If we give a non-number answer, we’ll `return`
and quit. Observe:-->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
数字を当てよ!
秘密の数字は …… 59
数字を推理して入力してください。
45
あなたの予想は → 45
もっと大きい！
数字を推理して入力してください。
60
あなたの予想は → 60
もっと小さい！
数字を推理して入力してください。
59
あなたの予想は → 59
あなたの勝ちです！
数字を推理して入力してください。
おわり
thread '<main>' panicked at '数字を１つ入力してください！'
```

ほう！ `おわり` で確かに終了しました。数字以外の入力ではどれも終了します。
ええ、これでは控えめに言っても最善ではありません。
まずは、ゲームに勝ったとき本当に終了するようにしましょう。

<!--Ha! `quit` actually quits. As does any other non-number input. Well, this is
suboptimal to say the least. First, let’s actually quit when you win the game:-->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    loop {
        println!("数字を推理して入力してください。");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .ok()
            .expect("行の読み取りに失敗しました");

        let guess: u32 = guess.trim().parse()
            .ok()
            .expect("数字を１つ入力してください！");

        println!("あなたの予想は → {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("もっと大きい！"),
            Ordering::Greater => println!("もっと小さい！"),
            Ordering::Equal   => {
                println!("あなたの勝ちです！");
                break;
            }
        }
    }
}
```

`あなたの勝ちです！` の次の行に `break` を加えることで、勝ったときに繰り返しを脱出するようにします。
この繰り返しは `main()` の最後にあるので、繰り返しからの脱出は譜体の終了も意味します。
もうひとつ作りかえるところがあります。誰かが数字以外を入力したとき、終了したくはなくて、
単に無視したいのです。こうするとできます。

<!--By adding the `break` line after the `あなたの勝ちです！`, we’ll exit the loop when we
win. Exiting the loop also means exiting the program, since it’s the last
thing in `main()`. We have just one more tweak to make: when someone inputs a
non-number, we don’t want to quit, we just want to ignore it. We can do that
like this:-->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("秘密の数字は …… {}", secret_number);

    loop {
        println!("数字を推理して入力してください。");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .ok()
            .expect("行の読み取りに失敗しました");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("あなたの予想は → {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("もっと大きい！"),
            Ordering::Greater => println!("もっと小さい！"),
            Ordering::Equal   => {
                println!("あなたの勝ちです！");
                break;
            }
        }
    }
}
```

変わった行はここです。

<!-- These are the lines that changed: -->

```rust,ignore
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
```

上記は `ok().expect()` を `match` 文に切り替えることで「誤ったら急停止」を「実際に誤りに対処」にできるか一般的に示しています。
`parse()` で返された結果 `Result` は `Ordering` と同じ列挙体 `enum` です。
しかしこの場合は、値の種類のそれぞれに付属する情報があります。`Ok` は成功、`Err` は失敗です。
どちらもさらに情報を持っており、文字解析に成功した整数値または誤り型です。
この場合、`Ok(num)` に `match` して、`Ok` の内側の値を `num` という名前で束縛します。
そして右辺側ですぐ `num` を返します。
`Err` の場合、誤りの種類は気にしないので名前の代わりに `_` を使います。
これで誤りを無視し、`continue` で `loop` の次の反復に進みます。

<!--This is how you generally move from ‘crash on error’ to ‘actually handle the
error’, by switching from `ok().expect()` to a `match` statement. The `Result`
returned by `parse()` is an `enum` just like `Ordering`, but in this case, each
variant has some data associated with it: `Ok` is a success, and `Err` is a
failure. Each contains more information: the successfully parsed integer, or an
error type. In this case, we `match` on `Ok(num)`, which sets the inner value
of the `Ok` to the name `num`, and then we just return it on the right-hand
side. In the `Err` case, we don’t care what kind of error it is, so we just
use `_` instead of a name. This ignores the error, and `continue` causes us
to go to the next iteration of the `loop`.-->

これでうまくできたはずです！ 試しましょう。

<!-- Now we should be good! Let’s try: -->

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
数字を当てよ!
秘密の数字は …… 61
数字を推理して入力してください。
10
あなたの予想は → 10
もっと大きい！
数字を推理して入力してください。
99
あなたの予想は → 99
もっと小さい！
数字を推理して入力してください。
foo
数字を推理して入力してください。
61
あなたの予想は → 61
あなたの勝ちです！
```

お見事！ 最後にひとつだけ手直しをして、数字当てゲームは完成になります。
一体何かわかりますか？ その通り、秘密の数字を印字したくはないですよね。
検査には向いていたとはいえ、ゲームを台無しにするものです。最終原譜はこちらです。

<!--Awesome! With one tiny last tweak, we have finished the guessing game. Can
you
think of what it is? That’s right, we don’t want to print out the secret
number. It was good for testing, but it kind of ruins the game. Here’s our
final source:-->

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("数字を当てよ!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    loop {
        println!("数字を推理して入力してください。");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .ok()
            .expect("行の読み取りに失敗しました");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("あなたの予想は → {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("もっと大きい！"),
            Ordering::Greater => println!("もっと小さい！"),
            Ordering::Equal   => {
                println!("あなたの勝ちです！");
                break;
            }
        }
    }
}
```

# 完成！

<!-- # Complete! -->

この時点で、あなたは数字当てゲームを首尾よく織り上げました！ おめでとうございます！

<!-- At this point, you have successfully built the Guessing Game!
Congratulations! -->

この初めての企画ではたくさんのものをお見せしました。
`let`、`match`、操作法、付属機能、外部わく箱の利用などです。次の企画ではさらに多くをお見せします。

<!--This first project showed you a lot: `let`, `match`, methods, associated
functions, using external crates, and more. Our next project will show off
even more.-->
