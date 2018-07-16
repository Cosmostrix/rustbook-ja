# 数字当てゲーム

Rustのさわりを学びましょう！　
最初の企画では、古典的な初心者演譜問題、すなわち推測ゲームを実装します。
これはどのように動作するのでしょうか？　算譜は、1から100の間のランダムな整数を生成します。
その後、推測を入力するよう促します。
推測に入ると、低すぎるか高すぎるかを教えてくれるでしょう。
正しく推測すると、それを祝福します。
いいですね？　

途中、Rustについて少し学びます。
次の章「構文と意味論」では、各パートの詳細を説明します。

# 設定

新しい企画を立ち上げましょう。
企画のディレクトリに移動します。
ディレクトリ構造を作成する方法と`hello_world` `Cargo.toml`を`Cargo.toml`てい`hello_world`か？　
カーゴはためにそれを行う命令を持っています。
それを打ちましょう。

```bash
$ cd ~/projects
$ cargo new guessing_game --bin
     Created binary (application) `guessing_game` project
$ cd guessing_game
```

譜集ではなく二進譜を作っているので、`cargo new`、そして次に`--bin`フラグへの企画の名前を渡します。

生成された`Cargo.toml`チェックしてください。

```toml
[package]

name = "guessing_game"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

カーゴはあなたの環境からこの情報を得ます。
それが正しくない場合は、それを修正してください。

最後に、カーゴは「こんにちは、世界！　
わたしたちのため。
`src/main.rs`チェックしてください。

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargoが私たちに与えたことをまとめてみましょう。

```{bash}
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.53 secs
```

優れた！　
`src/main.rs`もう一度開きます。
このファイルにすべての譜面を記述します。

最後の章の`run`命令を覚えてい`run`か？　
もう一度試してみてください。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/guessing_game`
Hello, world!
```

すばらしいです！　
ゲームは、`run`企画の種類だけです。次の段階に進む前に、各繰り返しを素早くテストする必要があります。

# 推測を処理する

それに行きましょう！　
数字当てゲームにまず必要なことは、プレイヤーが推測を入力できることです。
これをあなたの`src/main.rs`入れてください。

```rust,no_run
use std::io;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

ここにはたくさんのことがあります！　
それを少しずつ見てみましょう。

```rust,ignore
use std::io;
```

ユーザーの入力を受け取り、その結果を出力として出力する必要があります。
そのため、標準譜集の`io`譜集が必要です。
Rustは自動的にいくつかのものをすべての算譜、[すなわち 'prelude'に][prelude]輸入します。
それが前奏譜にない場合は、それを直接`use`必要があります。
同様の機能を果たす[`io` prelude][ioprelude]という2つ目の 'prelude'もあります。それを輸入すると、有用な`io`関連のものが輸入されます。

[prelude]: ../../std/prelude/index.html
 [ioprelude]: ../../std/io/prelude/index.html


```rust,ignore
fn main() {
```

前に見たように、`main()`機能は算譜への開始地点です。
`fn`構文は新しい機能を宣言し、`()`は引数がないことを示し、`{`は機能の本体を開始します。
戻り値の型は含まれていないので、空の[tuple][tuples] `()`とみなされます。

[tuples]: primitive-types.html#tuples

```rust,ignore
    println!("Guess the number!");

    println!("Please input your guess.");
```

以前は`println!()`が[string][strings]を画面に表示する[macro][macros]ことが分かっていました。

[macros]: macros.html
 [strings]: strings.html


```rust,ignore
    let mut guess = String::new();
```

今、面白いです！　
この小さな線には多くのことが起こっています。
最初に気がつくのは、これが[let文で][let]、これは '変数束縛'を作成するために使用されます。
それらはこの形式を取る。

```rust,ignore
let foo = bar;
```

[let]: variable-bindings.html

これにより、`foo`という名前の新しい束縛が作成され、値`bar`束縛され`bar`。
多くの言語では、これは「変数」と呼ばれますが、Rustの変数束縛には、袖の上にいくつかのトリックがあります。

たとえば、自動的には[immutable][immutable]です。
そういうわけで、例は`mut`使用しています。それは、不変ではなく、束縛を変更可能にします。
`let`は割り当ての左側に名前を付けませんが、実際には ' [pattern][patterns] 'を受け入れます。
パターンは後で使用します。
今のところ使用するのは簡単です。

```rust
#//let foo = 5; // `foo` is immutable.
let foo = 5; //  `foo`は不変です。
#//let mut bar = 5; // `bar` is mutable.
let mut bar = 5; //  `bar`は変更可能です。
```

[immutable]: mutability.html
 [patterns]: patterns.html


ああ、`//`そして、行末までコメントを開始します。
Rustは[comments][comments]すべてを無視し[comments][comments]。

[comments]: comments.html

だから今、それを知っている`let mut guess`可変結合命名導入します`guess`、の反対側を見ている`=`それが束縛されているもののために。 `String::new()`

`String`は、標準譜集によって提供される文字列型です。
[`String`][string]は、拡張可能なUTF-8で符号化された文言ビットです。

[string]: ../../std/string/struct.String.html

`::new()`構文は`::`使用します。これは特定の型の '関連する機能'です。
つまり、`String`特定の実例ではなく、`String`自体に関連付けられています。
他の言語はこれを「静的操作法」と呼びます。

この機能は、新しい空の`String`作成するため、`new()`という名前になります。
多くの型で`new()`機能が見つかるでしょう。何らかの新しい値を作るための一般的な名前です。

進んでみましょう。

```rust,ignore
    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");
```

それはもっとたくさん！　
ビットごとに行ってみましょう。
最初の行には2つの部分があります。
ここが最初です。

```rust,ignore
io::stdin()
```

算譜の最初の行でd `std::io`をどのように`use`か覚えていますか？　
これで関連する機能を呼び出すようになりました。
`use std::io`しなかった場合は、この行を`std::io::stdin()`書くことができます。

この特定の機能は、端末の標準入力への手綱を返します。
より具体的には、[std::io::Stdin][iostdin]。

[iostdin]: ../../std/io/struct.Stdin.html

次の部分は、この手綱を使用してユーザーからの入力を取得します。

```rust,ignore
.read_line(&mut guess)
```

ここでは、手綱に対して[`read_line`]操作法を呼び出します。
[Methods][method]は、関連する機能と似ていますが、型自体ではなく、型の特定の実例でのみ使用できます。
`read_line()` 1つの引数を渡します。 `&mut guess`。

[`read_line`]: ../../std/io/struct.Stdin.html#method.read_line
 [method]: method-syntax.html


我々 `guess`上記の`guess`どのように拘束した`guess`覚えています
それが変更可能だと言りました。
しかし、`read_line`なりません`String`引数としてを。それはとり`&mut String`。
Rustには「 [references][references] 」という機能があり、1つのデータに複数の参照を持たせることができ、コピーを減らすことができます。
参照は複雑な機能です。Rustの主なセールスポイントの1つは、参照を使用するのがどれほど安全で簡単なのかです。
しかし、今すぐ算譜を終了するために多くの詳細を知る必要はありません。
今のところ、知る必要があるのは`let`束縛を行うように、参照は自動的には不変であるということです。
したがって、書く必要が`&mut guess`ではなく、`&guess`。

なぜ`read_line()`は文字列への参照を変更できますか？　
その仕事は、ユーザが標準入力に入力したものを取り込み、それを文字列に配置することです。
その文字列を引数にとり、入力を追加するには、その文字列を変更可能にする必要があります。

[references]: references-and-borrowing.html

しかし、この譜面行ではあまり成し遂げられていません。
これは1行の文言ですが、1行の譜面の最初の部分だけです。

```rust,ignore
        .expect("Failed to read line");
```

`.foo()`構文で操作法を呼び出すと、改行やその他の空白を導入することができます。
これは、長い行を分割するのに役立ちます。
我々  _はでき_ た。

```rust,ignore
    io::stdin().read_line(&mut guess).expect("Failed to read line");
```

しかし、それは読みにくいです。
2つの操作法呼び出しの2行を分割しています。
`read_line()`についてすでに説明しましたが、`expect()`について`expect()`どうでしょうか？　
まあ、`read_line()`は、ユーザーが入力したものを`&mut String`に渡していることをすでに述べました。
しかし、それは値を返します。この場合、[`io::Result`][ioresult]です。
Rustには、標準譜集に`Result`という名前の型がいくつかあります。一般的な[`Result`][result]、 `io::Result`ような下位譜集の特定の版です。

[ioresult]: ../../std/io/type.Result.html
 [result]: ../../std/result/enum.Result.html


これらの`Result`型の目的は、誤り処理情報を符号化することです。
`Result`型の値は、どの型と同様、操作法が定義されています。
この場合、`io::Result`は、呼び出された値を取る[`expect()`操作法][expect]があります。成功していない場合は、渡したメッセージとともに[`panic!`][panic]なります。
このような`panic!`が発生すると、算譜が異常終了し、メッセージが表示されます。

[panic]: error-handling.html
 [expect]: ../../std/result/enum.Result.html#method.expect


`expect()`呼び出さなければ、算譜は製譜されますが、警告が表示されます。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
warning: unused result which must be used, #[warn(unused_must_use)] on by default
  --> src/main.rs:10:5
   |
10 |     io::stdin().read_line(&mut guess);
   |     ^

    Finished debug [unoptimized + debuginfo] target(s) in 0.42 secs
```

Rustは`Result`値を使用していないことを警告します。
この警告は、`io::Result`が持つ特別な注釈から来ています。
Rustは可能な誤りを処理していないことを伝えようとしています。
誤りを抑制する正しい方法は、実際に誤り処理を記述することです。
幸いなことに、問題が発生した場合に異常終了する場合は、`expect()`使用できます。
何とか誤りから復旧できれば、何か他のことをやろうとしますが、将来の企画ではそれを保存します。

この最初の例の1行だけが残っています。

```rust,ignore
    println!("You guessed: {}", guess);
}
```

これは、入力を保存した文字列を出力します。`{}`は場所取りであるため、引数として`guess`して渡します。
複数の`{}`があった場合、複数の引数を渡します。

```rust
let x = 5;
let y = 10;

println!("x and y: {} and {}", x, y);
```

簡単です。

とにかく、それはツアーです。
`cargo run`を`cargo run`だ状態で持っていることを実行できます

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.44 secs
     Running `target/debug/guessing_game`
Guess the number!
Please input your guess.
6
You guessed: 6
```

大丈夫！　
最初の部分は完了です。キーボードから入力を受け取り、それを元に戻すことができます。

# 秘密の番号を生成する

次に、秘密番号を生成する必要があります。
Rustには標準譜集に乱数機能はまだ含まれていません。
しかし、Rustチームは[`rand`通い箱を][randcrate]提供しています。
'通い箱'は、Rustの譜面のパッケージです。
実行可能ファイルである「二進譜通い箱」を構築しています。
`rand`は譜集通い箱で、他の算譜で使用するための譜面が含まれています。

[randcrate]: https://crates.io/crates/rand

外部カーゴ通い箱を使用するのは、カーゴが本当に輝く場所です。
`rand`を使って譜面を書く前に、`Cargo.toml`を修正する必要があります。
開いて、数行を一番下に追加してください。

```toml
[dependencies]

rand = "0.3.0"
```

`Cargo.toml`の`[dependencies]`章は`[package]`章に似ています。次の章が始まるまで、それに続くすべてがその一部です。
Cargoは依存関係の章を使用して、あなたが持っている外部通い箱の依存関係と必要な版を確認します。
このケースでは、版`0.3.0`を指定し`0.3.0`。これはCargoがこの特定の版と互換性のあるリリースであることを理解しています。
Cargoは版番号を書くための標準である[意味つき付版管理を][semver]理解しています。
上のような裸の数字は、実際には「 `^0.3.0`と互換性のあるもの」を意味する`^0.3.0`省略形です。
`0.3.0`だけを正確に使用したい場合、`rand = "=0.3.0"`ことができます（2つの等号に注意してください）。
また、さまざまな版を使用することもできます。
[Cargoの開発資料に][cargodoc]は詳細が含まれています。

[semver]: http://semver.org
 [cargodoc]: http://doc.crates.io/specifying-dependencies.html


さて、譜面を変更することなく、企画を構築しましょう。

```bash
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.14
 Downloading libc v0.2.17
   Compiling libc v0.2.17
   Compiling rand v0.3.14
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 5.88 secs
```

もちろん、異なる版が表示されることがあります。

新しい出力がたくさん！　
Cargoは外部からの依存性があるので、レジストリから[Crates.io][cratesio]のデータのコピーであるすべての最新版を取得します。
Crates.ioは、Rust生態系の人々が他の人が使用するためのオープンソースのRust企画を投稿する場所です。

[cratesio]: https://crates.io

レジストリを更新した後、Cargoは`[dependencies]`を確認し、まだ持っていないものを入荷します。
この場合、`rand`に依存したいと言っただけですが、`libc`コピーも手に入れました。
これは、`rand`が`libc`に依存して動作するためです。
それらを入荷した後、製譜して企画を製譜します。

`cargo build`やり直すと、別の出力が得られます。

```bash
$ cargo build
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
```

そうです、何もされていません！　
Cargoは、企画が構築されていること、そしてその依存関係のすべてが構築されていることを知っているので、すべてのことをする理由はありません。
何もすることなく、それは単に終了します。
`src/main.rs`もう一度開き、簡単な変更を加えて再度保存すると、次の2行しか表示されません。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.45 secs
```

だから、Cargoに`0.3.x`版の`rand`ほしいと言ったので、これが書かれた時点で最新版を`v0.3.14`、 `v0.3.14`。
しかし、来週、版`v0.3.15`が出て、重要なバグ修正があったら何が起こるでしょうか？　
バグ修正を取得することは重要ですが、`0.3.15`に譜面を壊す退行現象が含まれている場合はどう`0.3.15`ますか？　

この問題への答えは、企画ディレクトリにある`Cargo.lock`ファイルです。
初めて企画を組み上げするとき、Cargoは基準に合ったすべての版を`Cargo.lock`、 `Cargo.lock`ファイルに書き込みます。
将来的に企画を組み上げすると、Cargoは`Cargo.lock`ファイルが存在することを確認してから、版を再`Cargo.lock`するすべての作業を行うのではなく、その特定の版を使用します。
これにより、繰り返し可能な組み上げを自動的に行うことができます。
つまり、明示的にアップグレードするまでは`0.3.14`留まり、固定ファイルのおかげで譜面を共有する人もそうです。

`v0.3.15`を使用 _し_ たいときは _どう_ でしょうか？　
カーゴは別の命令、持っ`update` 「、ロックを無視し、指定したものを合うすべての最新版を把握言います。
それがうまくいけば、それらの版を固定ファイルに書き出してください。'
しかし、自動的には、Cargoは`0.3.0`より大きく`0.4.0`より小さい版のみを探します。
`0.4.x`に移行したい場合は、`Cargo.toml`直接更新する`Cargo.toml`ます。
次回の`cargo build`時に、カーゴは添字を更新し、`rand`要件を再評価します。

[Cargo][doccargo]と[its ecosystem][doccratesio]については[Cargo][doccargo]多くのことが言えますが、今のところそれはすべて知っておく必要があります。
カーゴは譜集を再利用することを本当に簡単にしています。だから、ラステーシャンは、小さな企画を書く傾向があり、それはいくつかの下位パッケージから組み立てられます。

[doccargo]: http://doc.crates.io
 [doccratesio]: http://doc.crates.io/crates-io.html


実際に`rand`  _を使って_ みましょう。
次のステップがあります。

```rust,ignore
extern crate rand;

use std::io;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

最初に行ったことは、最初の行を変更することです。
今は`extern crate rand`と言います。
`[dependencies]`で`rand`を宣言していたので、`extern crate`を使ってRustにそれを利用することを知らせることができます。
これは`use rand;`と同等`use rand;`
同様に、`rand::`接頭辞を付けることで、`rand` crateの中の何かを利用することができます。

次に、別の`use`行。 `use rand::Rng`を追加しました。
しばらくのうちに操作法を使うつもりですが、`Rng`が動作するためには範囲が必要です。
基本的な考え方は次のとおりです。操作法は「特性」と呼ばれるものに定義され、操作法が機能するには、その特性が有効範囲内にあることが必要です。
詳細については、[traits][traits]章を参照してください。

[traits]: traits.html

途中に追加した2つの行があります。

```rust,ignore
    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);
```

`rand::thread_rng()`機能を使用して、乱数生成器のコピーを取得します。この生成器は、実行中の特定の[thread][concurrency]ローカルにあります。上記の`use rand::Rng` 'dを`use rand::Rng`ため、`gen_range()`操作法を使用できます。
この操作法は2つの引数をとり、それらの間に数値を生成します。
それは下限に含まれていますが、上限では排他的ですので、1から100までの数値を取得するには`1`と`101`が必要です。

[concurrency]: concurrency.html

2行目は暗証番号を表示します。
これは算譜を開発しているときに便利なので、簡単にテストすることができます。
しかし、最終版のためにそれを削除します。
あなたがそれを起動したときに答えを印字すれば、あまりゲームではありません！　

新しい算譜を数回試してみてください。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.55 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 7
Please input your guess.
4
You guessed: 4
$ cargo run
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

すばらしいです！　
次のステップ。推測を秘密の数字と比較します。

# 推測を比較する

ユーザー入力があったので、推測を秘密の番号と比較してみましょう。
次のステップがありますが、まだ製譜されていません。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal   => println!("You win!"),
    }
}
```

ここに新しいビットがいくつかあります。
最初の方法は別の`use`です。
`std::cmp::Ordering`という型を有効範囲に持ち込みます。
次に、それを使用する下部に5つの新しい行。

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("Too small!"),
    Ordering::Greater => println!("Too big!"),
    Ordering::Equal   => println!("You win!"),
}
```

`cmp()`操作法は、比較できるものすべてに対して呼び出すことができ、それを比較したいものへの参照を取ります。
これは、先に`use`た`Ordering`型を返します。
[`match`][match]文を使用して、それがどんな種類の`Ordering`であるかを正確に判断します。
`Ordering`は[`enum`][enum]、列挙型の略で、次のようになります。

```rust
enum Foo {
    Bar,
    Baz,
}
```

[match]: match.html
 [enum]: enums.html


この定義では、`Foo`型のものは`Foo::Bar`または`Foo::Baz`いずれかになります。
特定の`enum`型の名前空間を示すために、`::`を使用します。

[`Ordering`][ordering] `enum`は、`Less`、 `Equal`、 `Greater` 3つの変形があります。
`match`文は型の値をとり、可能な値ごとに '腕'を作成できるようにします。
3つの型の`Ordering`があるので、3つの腕があります。

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("Too small!"),
    Ordering::Greater => println!("Too big!"),
    Ordering::Equal   => println!("You win!"),
}
```

[ordering]: ../../std/cmp/enum.Ordering.html

それが`Less`であれば、`Too small!`、それが`Greater`、 `Too big!`、 `Equal`なら`You win!`。
`match`は本当に便利で、しばしばRustで使用されます。

私はこれがまだかなり製譜されないと言いました。
試してみよう。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
error[E0308]: mismatched types
  --> src/main.rs:23:21
   |
23 |     match guess.cmp(&secret_number) {
   |                     ^^^^^^^^^^^^^^ expected struct `std::string::String`, found integral variable
   |
   = note: expected type `&std::string::String`
   = note:    found type `&{integer}`

error: aborting due to previous error

error: Could not compile `guessing_game`.

To learn more, run the command again with --verbose.
```

すごい！　
これは大きな誤りです。
その核心は、「型違い」ということです。
Rustは強力な静的型のシステムを持っています。
ただし、型推論もあります。
`let guess = String::new()`を書いたとき、Rustは`guess`が`String`でなければならないと`guess`することができたので、型を書き出すことはできません。
そして、私たちと`secret_number`。1と百の間の値を持つことができる種類が多数ある`i32`、32 2ビット数、または`u32`、符号なし三〇から二ビット数、または`i64`、sixty-は4ビットの数字などがあります。
これまでのところ、それは重要ではないので、Rustは`i32`黙用設定されています。
しかし、ここでは、Rustは`guess`と`secret_number`比較方法を知らない。
それらは同じ型である必要があります。
最終的には、入力として読み取った`String`を実数型に変換して比較したいと考えています。
それをさらに2つの行で行うことができます。
新しい算譜があります。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal   => println!("You win!"),
    }
}
```

新しい2行。

```rust,ignore
    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");
```

私はすでに`guess`ていた`guess`ました`guess`？　
やっていますが、Rustは以前の`guess`を新しいもので遮蔽することができます。
これは、この正確な状況でよく使用されます。`guess`は`String`として開始しますが、`u32`に変換します。
`guess_str`で`guess`、 `guess_str`や`guess`などの2つの固有の名前が`guess_str`ではなく、`guess`名を再利用できます。

先ほど書いたような式に`guess`を束縛します。

```rust,ignore
guess.trim().parse()
```

ここでは、`guess`古いを参照`guess`だった1 `String`その中に入力を持ちます。
`String`の`trim()`操作法は、`String`の先頭と最後の空白を削除します。
`read_line()`を満たすために 'return'キーを押しなければならなかったので、これは重要です。
これは、`5`を入力してエンターキーを打つすると、`5\n`ように`guess`れることを意味します。
`\n`は、入力キーである改行を表します。
`trim()`はこれを取り除き、文字列には`5`だけを残します。
[文字列][parse]の[`parse()`操作法][parse]は、文字列をある種の数値に解析します。
さまざまな数字を解析できるので、望む正確な型の数字についてRustにヒントを与える必要があります。
したがって、`let guess: u32`。
コロン（`:`）の後`guess`、その型に注釈を付けるつもりRustを伝えます。
`u32`は符号なしの32ビット整数です。
Rustに[は数多くの組み込みの数値型][number]があり[ますが][number]、 `u32`を選択しました。
これは小さな正の数のための良い黙用の選択です。

[parse]: ../../std/primitive.str.html#method.parse
 [number]: primitive-types.html#numeric-types


`read_line()`と同様に、`parse()`呼び出すと誤りが発生する可能性があります。
文字列に`A👍%`含まれているとどうなりますか？　
それを数字に変換する方法はありません。
そのため、`read_line()`行ったのと同じことを行います。誤りが発生した場合は、`expect()`操作法を使用して異常終了します。

算譜を試してみましょう！　

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.57 secs
     Running `target/guessing_game`
Guess the number!
The secret number is: 58
Please input your guess.
  76
You guessed: 76
Too big!
```

ナイス！　
あなたは私の推測の前にスペースを追加したことが分かりますが、それでも私は76を推測しました。算譜を数回実行して、数字を推測するだけでなく、数字が小さすぎると推測することを確認します。

今ではゲームのほとんどが機能していますが、推測することはできます。
ループを追加することでそれを変えよう！　

# 繰り返し

`loop`予約語は無限ループを与えます。
それを追加しましょう。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = guess.trim().parse()
            .expect("Please type a number!");

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => println!("You win!"),
        }
    }
}
```

そしてそれを試してみてください。
しかし、待って、無限ループを追加しませんでしたか？　
うん。
`parse()`についての議論を覚えていますか？　
非数字の答えを与えると、`panic!`を`panic!`して終了します。
観察する。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.58 secs
     Running `target/guessing_game`
Guess the number!
The secret number is: 59
Please input your guess.
45
You guessed: 45
Too small!
Please input your guess.
60
You guessed: 60
Too big!
Please input your guess.
59
You guessed: 59
You win!
Please input your guess.
quit
thread 'main' panicked at 'Please type a number!'
```

ハ！　
`quit`実際に終了します。
他の非数値入力も同様です。
まあ、これは最も少なく言い表すには最適以下です。
まず、ゲームに勝ったときに実際に終了しましょう。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = guess.trim().parse()
            .expect("Please type a number!");

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

`You win!`を`You win!`後に`break`行を追加することで、`You win!`ループを終了します。
ループを終了することは、`main()`最後のものであるため、算譜を終了することも意味します。
誰かが非数字を入力したときに終了したくない場合は、無視したいと考えています。
これを次のようにすることができます。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

変更された行は次のとおりです。

```rust,ignore
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
```
これは、`expect()`から`match`文に切り替える`expect()`によって、一般的に '誤り時に異常終了する'から '実際に誤りを処理する'に移動する方法です。
`Result`は`parse()`によって返され`parse()`。これは`Ordering`ような`enum`ですが、この場合、各場合値にはそれ用のデータが関連付けられています`Ok`は成功し、`Err`は失敗です。
それぞれにはより多くの情報が含まれます。正常に解析された整数、または誤り型。
この例では、名前`num`をはがされた`Ok`値（整数）に設定する`Ok(num)`を`match`させ、次にそれを右側に返します。
`Err`場合、どのような種類の誤りでも気にしないので、名前の代わりにcatch all `_`使用します。
これは`Ok`でないすべてのものを捕捉し、`continue`はループの次の繰り返しに移動します。
実際には、これによりすべての誤りを無視して算譜を続行することができます。

今良いべきだ！　
やってみよう。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
    Finished debug [unoptimized + debuginfo] target(s) in 0.57 secs
     Running `target/guessing_game`
Guess the number!
The secret number is: 61
Please input your guess.
10
You guessed: 10
Too small!
Please input your guess.
99
You guessed: 99
Too big!
Please input your guess.
foo
Please input your guess.
61
You guessed: 61
You win!
```

驚くばかり！　
最後の小さな調整で、推測ゲームを終えました。
あなたはそれが何であるか考えることができますか？　
そうです、秘密の番号を印字したくありません。
それはテストのためには良いものでしたが、ゲームのようなものが残っていました。
ここに最終的な原譜があります。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

# コンプリート！　

この企画では、`let`、 `match`、操作法、関連する機能、外部通い箱の使用など、多くのことがわかりました。

この時点で、あなたは正常に推測ゲームを構築しました！　
おめでとう！　
