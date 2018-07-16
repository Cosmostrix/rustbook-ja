# 推測ゲームを演譜する

実践的な企画を一緒に進めて、Rustに飛び込みましょう！　
この章では、実際の算譜でそれらを使用する方法を示すことによって、いくつかの一般的なRustの概念を導入します。
`let`、 `match`、操作法、関連する機能、外部通い箱などについて学習します。
以下の章では、これらのアイデアについて詳しく説明します。
この章では、基本を練習します。

古典的な初心者演譜の問題を実装します。推測ゲームです。
これはどのように動作するのでしょうか？　算譜は1から100の間のランダムな整数を生成します。次に、推測を入力するようプレーヤーに促します。
推測が入力されると、推測値が低すぎるか高すぎるかを示す算譜が表示されます。
推測が正しい場合、ゲームは祝福メッセージを印字して終了します。

## 新しい企画を設定する

新しい企画を設定するには、第1章で作成した*projects*ディレクトリに移動し、Cargoを使用して新しい企画を作成します。次のようにします。

```text
$ cargo new guessing_game --bin
$ cd guessing_game
```

最初の命令`cargo new`は、企画の名前（`guessing_game`）を最初の引数として取ります。
`--bin`フラグはCargoに第1章のような二進譜企画を作るよう指示します。第2の命令は新しい企画のディレクトリに変わります。

生成された*Cargo.toml*ファイルを見てください。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[package]
name = "guessing_game"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
```

Cargoが環境から取得した著者情報が正しくない場合は、ファイルに修正してもう一度保存してください。

第1章で見たように、`cargo new`は "Hello、world！　"算譜を生成します。
*src / main.rs*ファイルをチェックしてください。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

次に、この "Hello、world！　"算譜を製譜して、`cargo run`命令を使用して同じ手順で実行してみましょう。

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50 secs
     Running `target/debug/guessing_game`
Hello, world!
```

`run`命令は、このゲームでやっているように、企画を迅速に反復する必要がある場合に便利です。各繰り返しをすばやくテストしてから次の企画に移行します。

*src / main.rs*ファイルを再度*開き*ます。
このファイルにすべての譜面を記述します。

## 推測を処理する

推測ゲーム算譜の最初の部分は、ユーザーの入力を求め、その入力を処理し、入力が予想される形式であることを確認します。
まず、プレイヤーに推測を入力させます。
リスト2-1の譜面を*src / main.rsに*入力します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
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

<span class="caption">譜面リスト2-1。ユーザーからの推測を​​取得して印字する譜面</span>

この譜面には多くの情報が含まれていますので、行ごとに説明しましょう。
ユーザの入力を取得し、その結果を出力として出力するには、`io`（入出力）譜集を有効範囲に入れる必要があります。
`io`譜集は標準譜集（`std`として知られてい`std`）から来ます。

```rust,ignore
use std::io;
```

自動的には、Rustは[、*プレリュードの*][prelude]すべての算譜の範囲にわずかな型しか持ちません
 。
使用する型がプレリュードにない場合は、`use`文を`use`してその型を有効範囲に明示的に持ち込む必要があります。
`std::io`譜集を使用すると、ユーザーの入力を受け入れる機能を含む多くの便利な機能が提供されます。

[prelude]: ../../std/prelude/index.html

第1章で見たように、`main`機能は算譜への入り口です。

```rust,ignore
fn main() {
```

`fn`構文は新しい機能を宣言し、カッコ`()`はパラメータがないことを示し、中かっこ（`{`）は機能の本体を開始します。

第1章で学んだように、`println!`は文字列を画面に表示するマクロです。

```rust,ignore
println!("Guess the number!");

println!("Please input your guess.");
```

この譜面は、ゲームが何であるかを示すプロンプトを表示し、ユーザーからの入力を要求しています。

### 値を変数に格納する

次に、次のようにユーザー入力を格納する場所を作成します。

```rust,ignore
let mut guess = String::new();
```

今、算譜は面白いです！　
この小さな線には多くのことが起こっています。
これは*変数*を作成するために使用される`let`文であることに注意してください。
別の例があります。

```rust,ignore
let foo = bar;
```

この行は`foo`という名前の新しい変数を作成し、それをバリュー`bar`束縛し`bar`。
Rustでは、変数は自動的には不変です。
この概念については、第3章の「変数と可変性」の章で詳しく説明します。次の例は、変数名の前に`mut`を使用して変数を可変にする方法を示しています。

```rust,ignore
#//let foo = 5; // immutable
let foo = 5; // 不変
#//let mut bar = 5; // mutable
let mut bar = 5; // 変更可能な
```

> > 注。 `//`構文は、行末まで続くコメントを開始します。
> > Rustはコメントのすべてを無視します。これについては第3章で詳しく説明します。

推測ゲーム算譜に戻りましょう。
あなたは今では知って`let mut guess`名前の変更可能な変数導入します`guess`。
等号（`=`）の反対側には、 `String`新しい実例を返す機能である`String::new`を呼び出した結果の`guess`値が束縛されています。
[`String`][string] <!--is a string type provided by the standard library that is a growable, UTF-8 encoded bit of text.-->
拡張可能なUTF-8符号化された文言・ビットである標準譜集ーによって提供される文字列・型です。

[string]: ../../std/string/struct.String.html

`::new`行の`::`構文は、`new`が`String`型の*関連する機能*であることを示します。
関連する機能は、型に、この場合に実現される`String`ではなく、特定の実例上で`String`。
他の言語はこれを*静的操作法*と呼びます。

この`new`機能は、空の新しい文字列を作成します。
新しい値を作る機能の一般的な名前なので、多くの型で`new`機能を見つけることができます。

要約すると、`let mut guess = String::new();`
現在、`String`新しい空の実例に束縛されている可変変数が作成されています。
すごい！　

`use std::io;`を`use std::io;`て標準譜集の入出力機能を組み込んだことを思い出してください`use std::io;`
算譜の最初の行に表示されます。
これで、`io`機能`stdin`呼び出します。

```rust,ignore
io::stdin().read_line(&mut guess)
    .expect("Failed to read line");
```

算譜の先頭に`use std::io`行を`use std::io`ていない場合は、この機能呼び出しを`std::io::stdin`と書くことができます。
`stdin`機能は、[`std::io::Stdin`][iostdin]実例を返します
 これは、端末の標準入力への手綱を表す型です。

[iostdin]: ../../std/io/struct.Stdin.html

譜面の次の部分、`.read_line(&mut guess)`は、[`read_line`][read_line]
 操作法を標準入力手綱に追加して、ユーザーからの入力を取得します。
`read_line` 1つの引数を`read_line`ます。 `&mut guess`。

[read_line]: ../../std/io/struct.Stdin.html#method.read_line

`read_line`の仕事は、ユーザーが標準入力に入力したものをそのまま文字列に入れて、その文字列を引数として取り出すことです。
文字列引数は変更可能である必要があり、操作法はユーザー入力を追加して文字列の内容を変更できます。

`&`は、この引数が*参照*であることを示しています。これにより、譜面の複数の部分に、そのデータを複数回記憶にコピーする必要なしに、1つのデータにアクセスできるようになります。
参照は複雑な機能であり、Rustの主な利点の1つは、参照を使用することがどれほど安全で簡単なのかです。
あなたは、この算譜を終了するために多くの詳細を知る必要はありません。
今のところ、あなたが知る必要があるのは、同じ変数の場合、参照は自動的には不変であるということです。
したがって、`&mut guess`ではなく、`&guess` `&mut guess`てmutableとする必要があります。
（第4章では、参照をより完全に説明します）。

### `Result`型による潜在的な障害の処理

この譜面行ではあまり成し遂げられていません。
これまで説明してきたのは1行の文言ですが、これは単一の論理的な譜面行の最初の部分にすぎません。
2番目の部分はこの操作法です。

```rust,ignore
.expect("Failed to read line");
```

`.foo()`構文を使って操作法を呼び出すときには、長い行を`.foo()`するのに役立つ改行やその他の空白を導入することが賢明です。
この譜面を次のように書くことができました。

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

しかし、1つの長い行は読みにくいので、分割することをお勧めします。2つの操作法呼び出しの2行です。
さて、この行が何をしているかについて話しましょう。

先に述べたように、`read_line`は、`read_line`文字列にユーザーが入力したものを入れますが、値も返します。この場合、[`io::Result`][ioresult]
 。
Rustには、標準譜集に`Result`という名前のいくつかの型があります。一般的な[`Result`][result]
 `io::Result`ような下位役区用の特定の版も含まれます。

[ioresult]: ../../std/io/type.Result.html
 [result]: ../../std/result/enum.Result.html


`Result`型は[*enumerations*][enums]
 しばしば*列挙型*と呼ばれます。
列挙型は、固定値のセットを持つことができる型であり、その値は列挙型の*変種*と呼ばれ*ます*。
第6章では列挙型について詳しく説明します。

[enums]: ch06-00-enums.html

`Result`場合、場合値は`Ok`または`Err`です。
`Ok`変更体は、操作が成功したことを示し、そして内部`Ok`正常に生成された値です。
`Err`場合値は、操作が失敗したことを意味し、`Err`は、操作の失敗の理由または理由に関する情報が含まれています。

これらの`Result`型の目的は、誤り処理情報を符号化することです。
`Result`型の値は、任意の型の値と同様に、操作法が定義されています。
`io::Result`の実例には[`expect`操作法があります][expect]
 あなたが呼ぶことができるもの。
`io::Result`この実例が`Err`値の場合、`expect`は算譜が異常終了し、渡すメッセージを`expect`引数として表示します。
`read_line`操作法が`Err`返す場合は、基になるオペレーティングシステムからの誤りの結果である可能性があります。
この`io::Result`実例が`Ok`値である場合、`expect`は、`Ok`が保持している戻り値を受け取り、その値だけを返して使用できます。
この場合、その値はユーザーが標準入力に入力したバイト数です。

[expect]: ../../std/result/enum.Result.html#method.expect

`expect`呼び出さなければ、算譜は製譜されますが、警告が表示されます。

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
warning: unused `std::result::Result` which must be used
  --> src/main.rs:10:5
   |
10 |     io::stdin().read_line(&mut guess);
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   |
   = note: #[warn(unused_must_use)] on by default
```

Rustは、`read_line`から返された`Result`値を使用していないことを警告します。これは、算譜が誤りを処理しなかったことを示しています。

警告を抑制する正しい方法は、実際に誤り処理を書くことですが、問題が発生したときにこの算譜を異常終了させたいだけなので、`expect`を使用`expect`ことができます。
誤りからの回復については、第9章で学習します。

### `println!`場所取りによる値の印字

中かっこで囲まれた中かっこを除いて、これまでに追加された譜面ではさらに議論すべき行が1つしかありません。

```rust,ignore
println!("You guessed: {}", guess);
```

この行は、ユーザーの入力を保存した文字列を出力します。中かっこ`{}`は、場所取りです。`{}`は、値を保持する小さなカニのピンチャーであると考えてください。
中かっこを使用して複数の値を出力することができます。中かっこの最初のセットは、書式文字列の後にリストされた最初の値を保持し、2番目のセットは2番目の値を保持します。
`println!`への1回の呼び出しで複数の値を出力すると、次のようになります。

```rust
let x = 5;
let y = 10;

println!("x = {} and y = {}", x, y);
```

この譜面は`x = 5 and y = 10`ます。

### 最初の部分をテストする

推測ゲームの最初の部分をテストしましょう。
カーゴランを使用して`cargo run`。

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
     Running `target/debug/guessing_game`
Guess the number!
Please input your guess.
6
You guessed: 6
```

この時点で、ゲームの最初の部分が完了します。キーボードから入力を受け取り、それを印字しています。

## 秘密番号の生成

次に、ユーザーが推測しようとする秘密の番号を生成する必要があります。
秘密の番号は毎回異なるはずですので、ゲームは複数回遊ぶのが楽しいです。
1と100の間の乱数を使用して、ゲームがそれほど難しくないようにしましょう。
Rustには標準譜集に乱数機能はまだ含まれていません。
しかし、Rustチームは[`rand` crateを][randcrate]提供しています。

[randcrate]: https://crates.io/crates/rand

### 通い箱を使用してより多くの機能を利用する

通い箱はRustの譜面のパッケージであることに注意してください。
構築してきた企画は、実行可能ファイルである*二進譜・通い箱*です。
`rand` crateは*譜集通い箱で*、他の算譜で使用するための譜面が含まれています。

カーゴの外部通い箱の使用は、それが本当に輝く場所です。
`rand`を使用する譜面を書く前に、`rand` *crateを*依存関係として含めるように*Cargo.toml*ファイルを変更する必要があります。
そのファイルを開き、Cargoがあなたのために作成した`[dependencies]`章ヘッダーの下に次の行を追加します。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[dependencies]

rand = "0.3.14"
```

*Cargo.toml*ファイルでは、ヘッダーの後に続くすべてが、別の章が開始するまで続く章の一部です。
`[dependencies]`章では、Cargoに、企画が依存する外部のひな型と、必要とするこれらのひな型の版を指定します。
この場合、意味つき付版指定子`0.3.14` `rand` `0.3.14`指定し`0.3.14`。
カーゴは[Semantic Versioning][semver]理解する
 （*SemVer*とも呼ばれ*ます*）は、版番号を記述するための標準です。
数値`0.3.14`は、実際には`^0.3.14`、「版0.3.14と互換性のある公開APIを持つすべての版」を意味します。

[semver]: http://semver.org

さて、譜面を変更せずに、リスト2-2に示すように、企画を組み上げしましょう。

```text
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.14
 Downloading libc v0.2.14
   Compiling libc v0.2.14
   Compiling rand v0.3.14
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

<span class="caption">リスト2-2。rand crateを依存関係として追加した後の実行中の<code>cargo build</code>からの出力</span>

異なる版番号が表示されることがあります（しかし、それらはすべてSemVerのおかげで譜面と互換性があります）。また、行の順序が異なる場合があります。

Cargoは外部からの依存性があるので、*レジストリ*から[Crates.io][cratesio]のデータのコピーであるすべての最新版を取得し*ます*。
Crates.ioは、Rust生態系の人々が他の人が使用するためのオープンソースのRust企画を投稿する場所です。

[cratesio]: https://crates.io

レジストリを更新した後、Cargoは`[dependencies]`章をチェックし、まだ持っていない通い箱を入荷します。
このケースでは、`rand`は依存関係としてリストされていましたが、Cargoは`libc`コピーも`libc`しました。なぜなら、`rand`は`libc`に依存しているからです。
通い箱を入荷した後、Rustはそれらを製譜し、利用可能な依存関係で企画を製譜します。

変更を加えずに直ちに`cargo build`実行すると、`Finished`行以外の出力は得られません。
Cargoはそれがすでに依存関係を入荷して製譜していることを知っており、*Cargo.toml*ファイルでそれらについて何も変更していません。
カーゴは、あなたが譜面について何も変更していないことも知っているので、それを再製譜しません。
何もすることなく、それは単に終了します。

*src / main.rs*ファイルを開き、簡単な変更を行い、それを保存してもう一度組み上げすると、2行の出力しか表示されません。

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

これらの行は、Cargoが*src / main.rs*ファイルへの小さな変更で組み上げを更新するだけであることを*示してい*ます。
依存関係は変更されていないので、Cargoはすでに入荷して製譜したものを再利用できることを認識しています。
譜面の一部を再構築するだけです。

#### *Cargo.lock*ファイルによる再現可能な組み上げの保証

Cargoには、あなたや他の誰かがあなたの譜面を組み上げするたびに、同じアーティファクトを再構築できる仕組みがあります。あなたが指定するまで、Cargoはあなたが指定した依存関係の版のみを使用します。
たとえば、`rand` crateの次の版0.3.15が出てきて、重要なバグ修正が含まれているだけでなく、譜面を壊す退行現象が含まれているとどうなりますか？　

この問題への答えは、*Cargo.lock*ファイルです。これは、最初に`cargo build`を実行したときに作成され、今*guessing_game*ディレクトリにあります。
初めて企画を組み上げするとき、Cargoは基準に合致するすべての版の依存関係を*把握*し、*Cargo.lock*ファイルに書き込みます。
将来的に企画を組み上げすると、Cargoは*Cargo.lock*ファイルが存在することを確認し、*版を再検討*するすべての作業を行うのではなく、指定された版を使用します。
これにより、自動的に再現可能な組み上げが可能になります。
つまり、*Cargo.lock*ファイルのおかげで、明示的にアップグレードするまで企画は`0.3.14`ままです。

#### 新しい版を取得するための通い箱の更新

あなたは通い箱を更新し*ない*場合、カーゴは別の命令、提供`update` *Cargo.lockファイル*を無視し*Cargo.toml*であなたの仕様に合わせて、すべての最新版を把握します。
それがうまくいくならば、Cargoはそれらの版を*Cargo.lock*ファイルに書き込みます。

しかし、自動的には、Cargoは`0.3.0`より大きく`0.4.0`より小さい版のみを探します。
`rand` `0.3.15` 2つの新しい版、`0.3.15`と`0.4.0`をリリースした場合、`cargo update`を実行すると、次のように表示されます。

```text
$ cargo update
    Updating registry `https://github.com/rust-lang/crates.io-index`
    Updating rand v0.3.14 -> v0.3.15
```

この時点で、*Cargo.lock*ファイルの変更に気づくでしょう。現在使用している`rand` *crate*の版は`0.3.15`です。

`rand`版`0.4.0`または`0.4.x`シリーズのいずれかの版を使用する場合は、代わりに*Cargo.toml*ファイルを次のように更新する*必要があり*ます。

```toml
[dependencies]

rand = "0.4.0"
```

次に`cargo build`を実行`cargo build`、Cargoは利用可能な通い箱の登録を更新し、あなたが指定した新しい版に従ってあなたの`rand`要件を再評価します。

[Cargo][doccargo]についてもっと多くのことがあります
 [its ecosystem][doccratesio]
 これについては第14章で説明しますが、今のところあなたが知る必要があるのはこれだけです。
カーゴは譜集の再利用を非常に簡単にします。したがって、ラステーシャンは多くのパッケージから組み立てられた小さな企画を書くことができます。

[doccargo]: http://doc.crates.io
 [doccratesio]: http://doc.crates.io/crates-io.html


### 乱数の生成

今、あなたが追加したことを`rand` *Cargo.toml*に通い箱を、の使用を開始しましょう`rand`。
次のステップは、リスト2-3に示すように、*src / main.rs*を更新することです。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト2-3。譜面を追加して乱数を生成する</span>

まず、Rustに外部依存として`rand` crateを使用することを知らせる行を追加します。
これは`use rand`を呼び出すのと同じことです。だから、`rand`前に`rand::`置くことで、`rand` crateの中の何かを呼び出すことができます。

次に、別の`use`行。 `use rand::Rng`を追加し`use`。
`Rng`特性は、乱数生成器が実装する操作法を定義しており、これらの操作法を使用するには、この特性が有効でなければなりません。
第10章では、特性の詳細について説明します。

また、中央に2行追加しています。
`rand::thread_rng`機能は、使用する特定の乱数生成器を提供します。現在の実行走脈の局所的であり、オペレーティングシステムによってシードされるものです。
次に、乱数生成器の`gen_range`操作法を呼び出します。
この操作法は、`use rand::Rng`文を`use rand::Rng`して有効範囲に入れた`Rng`特性によって定義されます。
`gen_range`操作法は引数として2つの数値をとり、それらの間に乱数を生成します。
これは下限に含まれていますが上限には含まれませんので、1と100の間の数値を要求するには`1`と`101`を指定する必要があります。

> > 注。使用する特性や、通い箱から呼び出す操作法や機能はわかりません。
> > 通い箱を使用するための説明は各通い箱の文書に記載されています。
> > Cargoのもう一つの特徴は、すべての依存関係によって提供される開発資料をローカルで作成し、ブラウザで開く`cargo doc --open`命令を実行できることです。
> > たとえば、`rand`他の機能に興味がある場合は、`cargo doc --open`を実行し、左側のサイドバーで`rand`をクリックします。

譜面に追加した2行目は、暗証番号を出力します。
これは、テストできるように算譜を開発している間は便利ですが、最終版から削除します。
算譜が起動するとすぐに答えが表示されるのは、あまりゲームではありません！　

数回算譜を実行してみてください。

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 7
Please input your guess.
4
You guessed: 4
$ cargo run
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

あなたは異なる乱数を得なければなりません。それらはすべて1から100までの数字でなければなりません。

## 推測を秘密の番号と比較する

ユーザー入力と乱数があるので、比較することができます。
リスト2-4にその手順を示します。
ここで説明するように、この譜面はまだ製譜されません。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {

#    // ---snip---
    //  ---スニップ---

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal => println!("You win!"),
    }
}
```

<span class="caption">リスト2-4。2つの数値を比較する可能な戻り値の処理</span>

最初の新しいビットは別の`use`文で、`std::cmp::Ordering`という型を標準譜集の有効範囲に持っています。
`Result`、 `Ordering`は別の列挙型ですが、`Ordering`の場合値は`Less`、 `Greater`、 `Equal`です。
これらは、2つの値を比較したときに可能な3つの結果です。

次に、`Ordering`型を使用する下部に5つの新しい行を追加します。
`cmp`操作法は2つの値を比較し、比較できるものすべてに対して呼び出すことができます。
それはあなたが比較したいものを参照します。ここでは、`guess`を`secret_number`と比較してい`secret_number`。
次に、`use`文で有効範囲に入れた`Ordering`列挙の変形を返します。
[`match`][match]を使用する
 式を使用して、`guess`と`secret_number`値を持つ`cmp`の呼び出しから返された`Ordering`変種に基づいて、次に何をするかを決定します。

[match]: ch06-02-match.html

`match`式は*腕で*構成されて*い*ます。
アームは*パターン*と、`match`式の先頭に与えられた値がそのアームのパターンに合っている場合に実行される譜面で構成されます。
Rustがために与えられた値取り`match`し、順番に各アームのパターンを介して見えます。
`match`コンストラクトとパターンはRustの強力な機能で、譜面で発生する可能性のあるさまざまな状況を式し、それらをすべて処理することを保証します。
これらの機能については、それぞれ第6章と第18章で詳しく説明します。

ここで使用される`match`式で何が起こるかの例を見てみましょう。
50と38を比較すると、50が38より大きいため、`cmp`操作法は`Ordering::Greater`を返します。`match`式は`Ordering::Greater`値で、各腕のパターンをチェックし始めます。
最初の腕のパターン`Ordering::Less`を見て、`Ordering::Greater`の値が`Ordering::Less`と一致しないので、その腕の譜面を無視して次の腕に移動します。
次の腕のパターンは、`Ordering::Greater`、マッチ*し* `Ordering::Greater`！　
そのアームの関連譜面が実行され、画面に`Too big!`印字されます。
この場合で最後の腕を見る必要がないので、`match`式が終了します。

しかし、リスト2-4の譜面はまだ製譜されません。
試してみよう。

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
error[E0308]: mismatched types
  --> src/main.rs:23:21
   |
23 |     match guess.cmp(&secret_number) {
   |                     ^^^^^^^^^^^^^^ expected struct `std::string::String`, found integral variable
   |
   = note: expected type `&std::string::String`
   = note:    found type `&{integer}`

error: aborting due to previous error
Could not compile `guessing_game`.
```

誤りの核心には、*型*が*一致し*ていないことが記載されてい*ます*。
Rustは強力な静的型のシステムを持っています。
ただし、型推論もあります。
`let guess = String::new()`を書いたとき、Rustは`guess`が`String`なければならないと`guess`することができ、型を書き込まないようにしました。
一方、`secret_number`は数値型です。
複数の数値型は、1〜100の値を持つことができます`i32`ビットの数値。
`u32`、符号なし32ビットの数値。
`i64`ビットの数値。
他のものと同様であます。
他の場所で型情報を追加しないと、Rustは異なる数値型を推論することになりますが、Rustの黙用は`i32`。これは`secret_number`型です。
誤りの原因は、Rustが文字列と数値型を比較できないためです。

最終的には、算譜が入力として読み取る`String`実数型に変換して、推測と数値的に比較することができます。
`main`機能本体に次の2行を追加することで、これを行うことができます。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
#// --snip--
//  --snip--

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal => println!("You win!"),
    }
}
```

2つの新しい行は次のとおりです。

```rust,ignore
let guess: u32 = guess.trim().parse()
    .expect("Please type a number!");
```

`guess`という名前の変数を作成します。
しかし、待って、算譜はすでに`guess`呼ばれる変数を持っていないの`guess`か？　
それはありませんが、Rustは、以前の値*遮蔽*することができます`guess`新しいものに。
この機能は、値をある型から別の型に変換する場合によく使用されます。
`guess_str`で`guess`、 `guess_str`や`guess`などの2つの一意の変数を強制的に作成するのではなく、`guess`変数名を再利用できます。
（第3章では、シャドーイングについて詳しく説明しています）。

`guess.trim().parse()`という式に`guess`を束縛します。
式の`guess`では、元の`guess`が入力された`String`であったことを示します。
`String`実例の`trim`操作法は、先頭と末尾の空白を削除します。
が、`u32`唯一の数字を含めることができ、ユーザーが満足するには<span class="keystroke">、Enter</span>キーを押す必要があり`read_line`。
ユーザが<span class="keystroke">enterを</span>押すと、改行文字が文字列に追加されます。
たとえば、ユーザーが<span class="keystroke">5</span>と<span class="keystroke">入力してEnter</span>を押すと、`5\n` `guess`ます。
`\n`は、<span class="keystroke">Enter</span>を押した結果の改行を表します。
`trim`操作法は`\n`取り除き、結果としてわずか`5`ます。

[文字列][parse]の[`parse`操作法][parse]
 文字列をある種の数に解析します。
この操作法はさまざまな数値型を解析できるため、Rustには`let guess: u32`を使用して必要な正確な数値型を指定する必要があります。
コロン（`:`）の後`guess`変数の型に注釈を付けますRustを伝えます。
Rustにはいくつかの組み込みの数値型があります。
ここに見られる`u32`は符号なしの32ビット整数です。
これは小さな正の数のための良い黙用の選択です。
第3章で他の数値型についても学習します。さらに、このサンプル算譜の`u32`注釈と`secret_number`との比較は、Rustが`secret_number`も`u32`なければならないことを意味します。
今比較は同じ型の2つの値の間になります！　

[parse]: ../../std/primitive.str.html#method.parse

`parse`呼び出すと、誤りが発生しやすくなります。
たとえば、文字列に`A👍%`が含まれていた場合、それを数値に変換する方法はありません。
この操作法が失敗する可能性があるため、`parse`操作法は`read_line`操作法と同じように`Result`型を返します（前述の「結果型での潜在的な障害の処理」で説明しています）。
`expect`操作法を再度使用して、この`Result`同じ方法で処理します。
文字列から数字を作成できなかったため、`parse`が`Err` `Result`場合値を返した場合、`expect`呼び出しはゲームを異常終了させ、与えたメッセージを出力します。
`parse`が文字列を数値に変換`parse`ことができれば、`Result`の`Ok`型が返され、`expect`値が`Ok`値から返されます。

今すぐ算譜を実行しよう！　

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 0.43 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 58
Please input your guess.
  76
You guessed: 76
Too big!
```

ナイス！　
推測の前に空白が追加されたにもかかわらず、算譜はユーザーが76を推測したと考えました。異なる種類の入力で異なる動作を確認するために算譜を数回実行します。数字を正しく推測し、あまりにも低い数字を推測してください。

現在ゲームのほとんどを動作させていますが、ユーザーは1つしか推測できません。
ループを追加して変更しましょう！　

## 繰り返しによる複数の推測の許可

`loop`予約語は、無限ループを作成します。
これを追加して、ユーザーに番号を推測する機会を増やします。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
#// --snip--
//  --snip--

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

#        // --snip--
        //  --snip--

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => println!("You win!"),
        }
    }
}
```

ご覧のとおり、推測入力プロンプトからすべてをループに移しました。
ループ内の行をそれぞれ4つのスペースで字下げして、算譜を再度実行してください。
算譜は、言ったことをまさにやっているので、新しい問題があることに注意してください。別の推測を永遠に求めてください！　
ユーザーが終了できるようには見えません！　

ユーザーはキーボード近道<span class="keystroke">ctrl-c</span>を使用して算譜を停止でき<span class="keystroke">ます</span>。
しかし、「推測を秘密の数字に比較する」の`parse`ディスカッションで述べたように、この不安定なモンスターから脱出する別の方法があります。ユーザーが非数字の答えを入力すると、算譜が異常終了します。
ここに示すように、ユーザーは終了するためにそれを利用することができます。

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50 secs
     Running `target/debug/guessing_game`
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
thread 'main' panicked at 'Please type a number!: ParseIntError { kind: InvalidDigit }', src/libcore/result.rs:785
note: Run with `RUST_BACKTRACE=1` for a backtrace.
error: Process didn't exit successfully: `target/debug/guess` (exit code: 101)
```

入力を`quit`実際にゲームは終了しますが、他の数字以外の入力も終了します。
しかし、これは最も少なく言えば準最適です。
正しい数字が推測されると、ゲームは自動的に停止します。

### 正しい推測の後に終了する

ユーザーが`break`文を追加して勝利したときにゲームを終了するように算譜しましょう。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
#// --snip--
//  --snip--

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
```

`You win!`後に`break`行を追加すると、ユーザーが秘密の番号を正しく推測したときに算譜がループを終了します。
ループを終了すると、ループが`main`最後の部分であるため、算譜を終了することも意味します。

### 無効な入力の処理

ユーザが非数字を入力したときに算譜を異常終了させるのではなく、ゲームの動作をさらに洗練するために、ゲームが推測を続けることができるように数字以外の数字を無視してみましょう。
リスト2-5に示すように、`guess`が`String`から`u32`に変換される行を変更することで、これを行うことができます。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
#// --snip--
//  --snip--

io::stdin().read_line(&mut guess)
    .expect("Failed to read line");

let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};

println!("You guessed: {}", guess);

#// --snip--
//  --snip--
```

<span class="caption">リスト2-5。数字以外の推測を無視し、算譜を異常終了させる代わりに別の推測を求める</span>

`expect`呼び出しから`match`式への切り替えは、一般的に誤りが発生したときから誤りを処理するまでに移動する方法です。
`parse` `Result`は`Result`型を返し、`Result`はVari型の`Ok`または`Err`を持つ列挙型であることを覚えておいてください。
`cmp`操作法の`Ordering`結果と同じように、ここで`match`式を使用しています。

`parse`が文字列を数値に変換することができれば、結果の数値を含む`Ok`値を返します。
その`Ok`値は最初の腕のパターンと`match`し、`match`式は`parse`された`num`値を返すだけで`Ok`値になります。
その数字は、作成している新しい`guess`変数に必要なところで終了します。

`parse`で文字列を数値に変換でき*ない*場合は、誤りに関する詳細情報を含む`Err`値が返されます。
`Err`値は最初の`match`アームの`Ok(num)`パターンと一致しませんが、2番目のアームの`Err(_)`パターンと一致します。
下線（`_`）は捕捉オール値です。
この例では、内部にどのような情報があっても、すべての`Err`値を一致させたいとしています。
だから、この算譜は、第二アームの譜面を実行します`continue`の次の繰り返しに行くための算譜指示した、`loop`や別の推測をお願いします。
そのため、算譜は`parse`するすべての誤りを無視します。

これで、算譜のすべてが期待どおりに動作するはずです。
試してみよう。

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
     Running `target/debug/guessing_game`
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
1つの小さな最終調整で、推測ゲームを終了します。
算譜は依然として秘密番号を印字していることを思い出してください。
それはテストのためにはうまくいきましたが、ゲームを破壊します。
秘密番号を出力する`println!`削除しましょう。
リスト2-6に最終譜面を示します。

<span class="filename">ファイル名。src / main.rs</span>

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
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
```

<span class="caption">リスト2-6。ゲーム譜面を推測する</span>

## 概要

この時点で、推測ゲームを正常に構築しました。
おめでとう！　

この企画は、`let`、 `match`、methods、関連機能、外部通い箱など、多くの新しいRust概念をあなたに導入する実践的な方法でした。
次のいくつかの章では、これらの概念についてより詳しく学びます。
第3章では、変数、データ型、機能などのほとんどの演譜言語の概念と、Rustでそれらを使用する方法を示します。
第4章では所有権について説明します。Rustは他の言語とは異なります。
第5章では構造体と操作法の構文について説明し、第6章ではenumがどのように機能するかについて説明します。
