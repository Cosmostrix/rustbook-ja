## `Error`特性

`Error`特性は[標準ライブラリで定義されています](../../std/error/trait.Error.html)：

```rust
use std::fmt::{Debug, Display};

trait Error: Debug + Display {
#//  /// The lower level cause of this error, if any.
  /// このエラーが発生した場合は、その原因を示します。
  fn cause(&self) -> Option<&Error> { None }
}
```

この特性は、エラーを表す*すべての*タイプに対して実装されるため、スーパージェネリックです。
これは、後で見るように、合成可能なコードを記述するのに便利です。
それ以外の場合は、少なくとも以下のことを行うことができます。

* エラーの`Debug`表現を取得します。
* エラーのユーザー側の`Display`表現を取得します。
* エラーの因果連鎖が存在する場合（`cause`メソッドを使用して）、因果連鎖を検査します。

最初の2つは、`Debug`と`Display`両方にimplを必要とする`Error`結果です。
後者の2つは`Error`定義された2つのメソッドからのものです。
`Error`の威力は、すべてのエラータイプが`Error`になるという事実から来[ます](trait-objects.html)。これは、エラーが現実的に[特性オブジェクト](trait-objects.html)として定量化できることを意味し[ます](trait-objects.html)。
これは、`Box<Error>`または`&Error`いずれかとして現れます。
実際、`cause`メソッドは`&Error`返します。これはそれ自体が特性オブジェクトです。
`Error` traitのユーティリティを後で特性オブジェクトとして再訪します。

今のところ、`Error`特性を実装する例を示すだけで十分です。
[前のセクションで](#defining-your-own-error-type)定義したエラータイプを使用しましょう：

```rust
use std::io;
use std::num;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 私たちは、派生`Debug`すべての種類は、おそらく派生する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

この特定のエラータイプは、I / Oを処理するエラーまたは文字列を数値に変換するエラーの2種類のエラーが発生する可能性を表します。
このエラーは、新しいバリアントを`enum`定義に追加することで、必要な数のエラータイプを表現できます。

実装`Error`はかなり簡単です。
ほとんどの場合、明示的なケース分析が行われます。

```rust,ignore
use std::error;
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
#            // Both underlying errors already impl `Display`, so we defer to
#            // their implementations.
            // 両方の根底にあるエラーは既に`Display`を暗示しているので、実装に遅れをとっています。
            CliError::Io(ref err) => write!(f, "IO error: {}", err),
            CliError::Parse(ref err) => write!(f, "Parse error: {}", err),
        }
    }
}

impl error::Error for CliError {
    fn cause(&self) -> Option<&error::Error> {
        match *self {
#            // N.B. Both of these implicitly cast `err` from their concrete
#            // types (either `&io::Error` or `&num::ParseIntError`)
#            // to a trait object `&Error`. This works because both error types
#            // implement `Error`.
            //  NBこれらの暗黙的キャストの両方`err`その具体的な種類から（どちらか`&io::Error`または`&num::ParseIntError`形質オブジェクトへの）`&Error`。これは両方のエラータイプが`Error`実装しているために機能します。
            CliError::Io(ref err) => Some(err),
            CliError::Parse(ref err) => Some(err),
        }
    }
}
```

これは非常に典型的な`Error`：matchの実装であり、さまざまな種類のエラーに対応し、 `cause`に対して定義されたコントラクトを満たしてい`cause`。

## `From`特性

`std::convert::From` traitは[標準ライブラリで定義されています](../../std/convert/trait.From.html)：

<span id="code-from-def"></span>
```rust
trait From<T> {
    fn from(T) -> Self;
}
```

おいしいシンプルな、はい？
それは私たちに、特定の型*から*の変換について話をする汎用的な方法与えるので、非常に便利である`T`（この場合は、「他のいくつかのタイプが」IMPL、またはの対象である他のいくつかのタイプに`Self`）。
`From`の要点は[、標準ライブラリによって提供される一連の実装](../../std/convert/trait.From.html)です。

`From`仕組みを示す簡単な例がいくつかあります：

```rust
let string: String = From::from("foo");
let bytes: Vec<u8> = From::from("foo");
let cow: ::std::borrow::Cow<str> = From::from("foo");
```

OK、`From`は文字列間の変換に便利です。
しかし、エラーはどうですか？
それは、1つの重要なインプリケーションがあることが判明しました。

```rust,ignore
impl<'a, E: Error + 'a> From<E> for Box<Error + 'a>
```

これは、`Error`を意味する*任意の*型に対して、それを特性オブジェクト`Box<Error>`変換できることを意味します。
これはひどく驚くようなことではないかもしれませんが、一般的な文脈では役に立ちます。

以前に扱っていた2つのエラーを覚えていますか？
具体的には、`io::Error`と`num::ParseIntError`です。
両方ともimpl `Error`であるため、`From`と動作します：

```rust
use std::error::Error;
use std::fs;
use std::io;
use std::num;

#// We have to jump through some hoops to actually get error values:
// 実際にエラー値を取得するには、いくつかのフープを飛ばしなければなりません。
let io_err: io::Error = io::Error::last_os_error();
let parse_err: num::ParseIntError = "not a number".parse::<i32>().unwrap_err();

#// OK, here are the conversions:
// はい、コンバージョンは次のとおりです。
let err1: Box<Error> = From::from(io_err);
let err2: Box<Error> = From::from(parse_err);
```

ここで本当に重要なパターンがあります。
`err1`と`err2`が*同じタイプ*です。
これは、それらが現存する定量化された型または形質オブジェクトであるためです。
特に、その基礎となる型はコンパイラの知識から*消去さ*れるため、まったく同じものとして`err1`と`err2`真に見えます。
さらに、正確に同じ関数呼び出し、`From::from`を使用して`err1`と`err2`を構築`From::from`。
これは、`From::from`がその引数とその戻り型の両方でオーバーロードされているためです。

このパターンは、以前の問題を解決するため重要です。同じ関数を使用してエラーを同じタイプに確実に変換する方法を提供します。

古い友達を再訪する時間。
`try!`マクロ。

## 本当の`try!`マクロ

これまで、私たちは`try!`この定義を提示しました：

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

これは実際の定義ではありません。
その実際の定義は[標準ライブラリにあります](../../std/macro.try.html)：

<span id="code-try-def"></span>
```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(::std::convert::From::from(err)),
    });
}
```

小さくても強力な変更が1つあります。エラー値は`From::from`渡さ`From::from`ます。
これにより、`try!`マクロをより強力にすることができます。これは、自動的に型変換を行うためです。

より強力な`try!`マクロを用意して、ファイルを読み込んでその内容を整数に変換するために以前書いたコードを見てみましょう：

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = try!(File::open(file_path).map_err(|e| e.to_string()));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(|e| e.to_string()));
    let n = try!(contents.trim().parse::<i32>().map_err(|e| e.to_string()));
    Ok(2 * n)
}
```

以前は、`map_err`呼び出しを取り除くことができると約束しました。
確かに、私たちがしなければならないのは、`From`作品を選ぶことだけです。
前のセクションで見たように、`From`は、あらゆるエラータイプを`Box<Error>`に変換するためのインプリメンテーションがあります。

```rust
use std::error::Error;
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, Box<Error>> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n = try!(contents.trim().parse::<i32>());
    Ok(2 * n)
}
```

理想的なエラー処理に非常に近づいています。
`try!`マクロは3つのものを同時にカプセル化するため、エラー処理の結果としてオーバーヘッドはほとんどありません。

1. ケース分析。
2. 制御フロー。
3. エラータイプ変換。

3つのものがすべて結合されると、コンビネータ、`unwrap`またはケース分析の呼び出しによって妨げられないコードが得られます。

少し残っています： `Box<Error>`タイプは*不透明*です。
呼び出し元に`Box<Error>`を返すと、呼び出し元は基になるエラータイプを（簡単に）検査できません。
状況がより確かに優れている`String`、発信者のようなメソッドを呼び出すことができますので[`cause`](../../std/error/trait.Error.html#method.cause)、しかし制限が残っています： `Box<Error>`不透明です。
（これは完全に真実ではありません。なぜなら、Rustにはランタイムリフレクションがあるからです。[これは、このセクションの範囲を超えて](https://crates.io/crates/error)いるシナリオで便利です）。

今度は、カスタム`CliError`型を再訪し、すべてを結びつけるときです。

## カスタムエラータイプの作成

最後のセクションでは、実際の`try!`マクロと、エラー値の`From::from`を呼び出すことによって、自動型変換を行う方法を見てきました。
特に、エラーを`Box<Error>`に変換しましたが、これは動作しますが、タイプは呼び出し元に対して不透明です。

これを修正するには、既に慣れ親しんでいるのと同じ措置、すなわちカスタムエラータイプを使用します。
もう一度、ファイルの内容を読み取り、それを整数に変換するコードを次に示します。

```rust
use std::fs::File;
use std::io::{self, Read};
use std::num;
use std::path::Path;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 私たちは、派生`Debug`すべての種類は、おそらく派生する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}

fn file_double_verbose<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path).map_err(CliError::Io));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(CliError::Io));
    let n: i32 = try!(contents.trim().parse().map_err(CliError::Parse));
    Ok(2 * n)
}
```

`map_err`の呼び出しがまだあることに注意して`map_err`。
どうして？
まあ、[`try!`](#code-try-def)と[`From`](#code-from-def)定義を思い出して[`try!`](#code-try-def)。
問題は、`io::Error`や`num::ParseIntError`ようなエラー型から私たちのカスタム`CliError`に変換することを可能にする`From` implは存在しないということ`CliError`。
もちろん、これを修正するのは簡単です！
我々が定義されているので`CliError`、我々はIMPLできる`From`それと：

```rust
# #[derive(Debug)]
# enum CliError { Io(io::Error), Parse(num::ParseIntError) }
use std::io;
use std::num;

impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<num::ParseIntError> for CliError {
    fn from(err: num::ParseIntError) -> CliError {
        CliError::Parse(err)
    }
}
```

これらのすべてのimplsを教えてやっている`From`作成方法`CliError`他のエラータイプからを。
私たちの場合、構築は対応する値コンストラクタを呼び出すのと同じくらい簡単です。
確かに、これは*通常*簡単です。

最終的に`file_double`書き直すことができ`file_double`：

```rust
# use std::io;
# use std::num;
# enum CliError { Io(::std::io::Error), Parse(::std::num::ParseIntError) }
# impl From<io::Error> for CliError {
#     fn from(err: io::Error) -> CliError { CliError::Io(err) }
# }
# impl From<num::ParseIntError> for CliError {
#     fn from(err: num::ParseIntError) -> CliError { CliError::Parse(err) }
# }

use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n: i32 = try!(contents.trim().parse());
    Ok(2 * n)
}
```

ここで唯一行ったことは、`map_err`への呼び出しを削除すること`map_err`。
`try!`マクロがエラー値の`From::from`を呼び出すため、これらのマクロは不要になりました。
これは、出現する可能性のあるすべてのエラータイプに対して、`From`差し込み」 `From`提供されているために機能します。

`file_double`関数を変更して、たとえば文字列を浮動小数点数に変換するなどの操作を実行した場合は、新しいバリアントをエラータイプに追加する必要があります。

```rust
use std::io;
use std::num;

enum CliError {
    Io(io::Error),
    ParseInt(num::ParseIntError),
    ParseFloat(num::ParseFloatError),
}
```

新規追加`From`のimpl：

```rust
# enum CliError {
#     Io(::std::io::Error),
#     ParseInt(num::ParseIntError),
#     ParseFloat(num::ParseFloatError),
# }

use std::num;

impl From<num::ParseFloatError> for CliError {
    fn from(err: num::ParseFloatError) -> CliError {
        CliError::ParseFloat(err)
    }
}
```

以上です！

## 図書館の作家のためのアドバイス

ライブラリでカスタムエラーをレポートする必要がある場合は、おそらく独自のエラータイプを定義する必要があります。
その表現（[`ErrorKind`](../../std/io/enum.ErrorKind.html)）を公開するかどうか、または[`ParseIntError`](../../std/num/struct.ParseIntError.html)ように非表示にするかどうかは、あなた次第です。
それをどうしているかにかかわらず、少なくともエラーの情報を`String`表現を超えて提供することは、通常は良い方法です。
しかし、確かに、これはユースケースによって異なります。

少なくとも、[`Error`](../../std/error/trait.Error.html)特性を実装するべきです。
これにより、ライブラリのユーザーは[エラー](#the-real-try-macro)を[作成する](#the-real-try-macro)ための柔軟性が[失われ](#the-real-try-macro)ます。
`Error`特性を実装することは、`fmt::Debug`と`fmt::Display`両方にimplを必要とするため、ユーザーがエラーの文字列表現を取得することが保証されていることも意味します。

それ以外にも、エラータイプの`From`実装を提供すると便利です。
これにより、あなた（ライブラリ作成者）とユーザーは[より詳細なエラー](#composing-custom-error-types)を[作成することができ](#composing-custom-error-types)ます。
例えば、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)は、`io::Error`と`byteorder::Error`両方`From` implsを提供します。

最後に、あなたの好みに応じて、特にライブラリで単一のエラータイプが定義されている場合は、[`Result`型のエイリアス](#the-result-type-alias-idiom)を定義することもできます。
これは、[`io::Result`](../../std/io/type.Result.html)と[`fmt::Result`](../../std/fmt/type.Result.html)の標準ライブラリで使用されます。

# ケーススタディ：人口データを読み込むプログラム

このセクションは長く、あなたの背景にもよるが、それはむしろ密であるかもしれない。
散文と一緒に行くためのサンプルコードはたくさんありますが、そのほとんどは教育的であるように特別に設計されています。
だから、我々は新しいことをするつもりです：事例研究。

このために、世界の人口データを照会するコマンドラインプログラムを構築します。
目的は簡単です：あなたはそれに場所を与え、人口を教えてくれるでしょう。
シンプルさにもかかわらず、間違っていることがたくさんあります！

使用するデータは、[Data Science Toolkitに][11]基づいています。
この演習では、いくつかのデータを用意しました。
[世界人口データ][12]（41MB gzip圧縮、145MB非圧縮）または[米国人口データ][13]（2.2MB gzip圧縮、7.2MB非圧縮）だけを[取得できます][13]。

これまでは、コードをRustの標準ライブラリに限定していました。
このような実際のタスクでは、少なくともCSVデータを解析し、プログラムの引数を解析し、その情報をRust型に自動的にデコードする必要があります。
そのために、[`csv`](https://crates.io/crates/csv)と[`rustc-serialize`](https://crates.io/crates/rustc-serialize)使用します。

## 初期設定

Cargoのプロジェクトでは、すでに[Cargoセクション](getting-started.html#hello-cargo)と[Cargoのドキュメンテーションで][14]十分にカバーされているため、プロジェクトを立ち上げるのに多くの時間を費やすつもりはありません。

ゼロから始めるには、`cargo new --bin city-pop`を実行し、`Cargo.toml`が次のようになっていることを確認してください：

```text
[package]
name = "city-pop"
version = "0.1.0"
authors = ["Andrew Gallant <jamslam@gmail.com>"]

[[bin]]
name = "city-pop"

[dependencies]
csv = "0.*"
rustc-serialize = "0.*"
getopts = "0.*"
```

あなたはすでに実行することができます：

```text
cargo build --release
./target/release/city-pop
# Outputs: Hello, world!
```

## 引数の解析

引き分けに引数の解析をしましょう。
私たちはGetoptsについて詳しく説明しませんが、それを記述する[良い文書][15]があります。
短い話は、Getoptsがオプションのベクトルから引数パーザとヘルプメッセージを生成することです（ベクトルであるという事実は、構造体とメソッドのセットの背後に隠されています）。
解析が完了すると、パーサは、定義されたオプションと残りの "空き"引数との一致を記録する構造体を返します。
そこから、フラグの情報、例えば、渡されたかどうか、どのような引数があるかなどの情報を取得できます。
ここでは、適切な`extern crate` crateステートメントとGetoptsの基本引数設定を使って、プログラムを紹介します：

```rust,ignore
extern crate getopts;
extern crate rustc_serialize;

use getopts::Options;
use std::env;

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };
    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }
    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

#    // Do stuff with information.
    // 情報を詰め込む
}
```

まず、プログラムに渡された引数のベクトルを取得します。
次に、プログラムの名前であることを認識して、最初のものを保存します。
これが終わると、引数フラグを設定します。この場合、単純なヘルプメッセージフラグです。
引数フラグが設定されると、`Options.parse`を使用して引数ベクトルを解析します（インデックス0はプログラム名です）。
これが成功した場合、解析されたオブジェクトにマッチを割り当てます。そうでなければ、パニックになります。
それを過ぎると、ユーザーがヘルプフラグを渡したかどうかテストし、もしそうなら、使用法のメッセージを出力します。
オプションのヘルプメッセージはGetoptsによって構築されるので、使用法のメッセージを出力するために必要なことは、プログラム名とテンプレートのために印刷することだけです。
ユーザーがヘルプフラグを渡さなかった場合、適切な変数を対応する引数に割り当てます。

## 論理を書く

私たちはすべてコードを違って書いていますが、通常はエラー処理が考えています。
これはプログラム全体の設計にはあまり適していませんが、ラピッドプロトタイピングには役立ちます。
Rustはエラー処理を明示的に（強制的に`unwrap`呼び出すことによって）強制するので、プログラムのどの部分がエラーを引き起こすかを簡単に知ることができます。

このケーススタディでは、ロジックは本当に簡単です。
必要なのは、私たちに与えられたCSVデータを解析して、一致する行にフィールドを印刷することだけです。
やってみましょう。
（`extern crate csv;`をファイルの先頭に追加してください）

```rust,ignore
use std::fs::File;

#// This struct represents the data in each row of the CSV file.
#// Type based decoding absolves us of a lot of the nitty-gritty error
#// handling, like parsing strings as integers or floats.
// この構造体は、CSVファイルの各行のデータを表します。型に基づくデコードでは、文字列を整数または浮動小数点として解析するような、きめ細かなエラー処理がたくさんあります。
#[derive(Debug, RustcDecodable)]
struct Row {
    country: String,
    city: String,
    accent_city: String,
    region: String,

#    // Not every row has data for the population, latitude or longitude!
#    // So we express them as `Option` types, which admits the possibility of
#    // absence. The CSV parser will fill in the correct value for us.
    // すべての行に人口、緯度、経度のデータがあるわけではありません！だから私たちは`Option` typesとしてそれらを表現します。これは欠如の可能性を認めています。CSVパーサーが正しい値を入力します。
    population: Option<u64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

    let file = File::open(data_path).unwrap();
    let mut rdr = csv::Reader::from_reader(file);

    for row in rdr.decode::<Row>() {
        let row = row.unwrap();

        if row.city == city {
            println!("{}, {}: {:?}",
                row.city, row.country,
                row.population.expect("population count"));
        }
    }
}
```

エラーの概要を説明しましょう。
明白なことから始めることができます。`unwrap`と呼ばれる3つの場所は、

1. [`File::open`](../../std/fs/struct.File.html#method.open)は[`io::Error`](../../std/io/struct.Error.html)返すことができます。
2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode)は一度に一つのレコードを[デコードし、レコード](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)を[デコードする](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)と（`Iterator` implで`Item`関連タイプを調べると）、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)が生成されます。
3. `row.population`が`None`場合、`expect`を呼び出すとパニックになります。

他に何かありますか？
一致する都市が見つからない場合はどうすればよいですか？
`grep`ようなツールはエラーコードを返すので、おそらくそれも必要です。
だから我々の問題に固有の論理エラー、IOエラー、CSV解析エラーがある。
これらのエラーを処理するための2つの異なる方法を検討します。

私は`Box<Error>`から始めたいと思います。
後で、独自のエラータイプの定義がどのように役立つかを見ていきます。

## `Box<Error>`エラー処理`Box<Error>`

`Box<Error>`それ*だけで動作します*ので、いいです。
独自のエラータイプを定義する必要はなく、`From`実装は必要ありません。
欠点は、`Box<Error>`が特性オブジェクトであるため*、型を消去する*ということです。つまり、コンパイラは根本的な型を理由に考えることができなくなります。

[Previously](#the-limits-of-combinators)は、関数の型を`T`から`Result<T, OurErrorType>`変更して、コードをリファクタリングし始めました。
この場合、`OurErrorType`は`Box<Error>`のみです。
しかし、`T`何ですか？
`main`戻り値型を追加できますか？

2番目の質問に対する答えは「いいえ、できません。
つまり、新しい関数を書く必要があります。
しかし、`T`とは何ですか？
一番簡単なのは、一致する`Row`値のリストを`Vec<Row>`として返すことです。
（より良いコードはイテレータを返しますが、それは読者の練習として残されています）。

私たちのコードを独自の関数にリファクタリングしましょうが、呼び出しを`unwrap`するようにしましょう。
その行を無視するだけで、人口不足の可能性を処理することに注意してください。

```rust,ignore
use std::path::Path;

struct Row {
#    // This struct remains unchanged.
    // この構造体は変更されません。
}

struct PopulationCount {
    city: String,
    country: String,
#    // This is no longer an `Option` because values of this type are only
#    // constructed if they have a population count.
    // これは、もはや`Option`はない。なぜなら、このタイプの値は、人口数がある場合にのみ構築されるからである。
    count: u64,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn search<P: AsRef<Path>>(file_path: P, city: &str) -> Vec<PopulationCount> {
    let mut found = vec![];
    let file = File::open(file_path).unwrap();
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = row.unwrap();
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    found
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = &matches.free[0];
    let city: &str = &matches.free[1];

    for pop in search(data_path, city) {
        println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
    }
}

```

`expect`使い方（`unwrap`ほうが良い）を取り除いていますが、検索結果が存在しない場合は処理する必要があります。

これを適切なエラー処理に変換するには、以下を実行する必要があります。

1. `search`の戻り値の型を`Result<Vec<PopulationCount>, Box<Error>>`ます。
2. プログラムをパニックするのではなく、エラーが呼び出し元に返されるように[`try!`マクロを](#code-try-def)使用して[`try!`](#code-try-def)。
3. `main`のエラーを処理します。

試してみよう：

```rust,ignore
use std::error::Error;

#// The rest of the code before this is unchanged.
// それ以前のコードの残りの部分は変更されていません。

fn search<P: AsRef<Path>>
         (file_path: P, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error>> {
    let mut found = vec![];
    let file = try!(File::open(file_path));
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(From::from("No matching cities with a population were found."))
    } else {
        Ok(found)
    }
}
```

`x.unwrap()`代わりに`try!(x)`て`try!(x)`。
関数が`Result<T, E>`返すので、エラーが発生した場合、`try!`マクロは関数の早い段階で返されます。

`search`の終わりに、[対応する`From` impls](../../std/convert/trait.From.html)を使用してプレーン文字列をエラータイプに変換します。

```rust,ignore
#// We are making use of this impl in the code above, since we call `From::from`
#// on a `&'static str`.
// 我々は呼んで以来、私たちは、上記のコードでは、このIMPLを利用している`From::from`の`&'static str`。
impl<'a> From<&'a str> for Box<Error>

#// But this is also useful when you need to allocate a new string for an
#// error message, usually with `format!`.
// しかしこれは、エラーメッセージに新しい文字列を割り当てる必要がある場合にも便利です（通常は`format!`。
impl From<String> for Box<Error>
```

以来`search`今や返す`Result<T, E>`、 `main`呼び出し時にケースの分析を使用する必要があります`search`：

```rust,ignore
...
    match search(data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
            }
        }
        Err(err) => println!("{}", err)
    }
...
```

`Box<Error>`で適切なエラー処理を行う方法を見てきたので、独自のカスタムエラータイプで別のアプローチを試してみましょう。
しかし、まず、エラー処理から簡単に休みを取り、`stdin`からの読み込みのサポートを追加しましょう。

## スタンダードから読む

私たちのプログラムでは、入力用に1つのファイルを受け入れ、データを1つのファイルに渡します。
つまり、stdinの入力を受け入れることができるはずです。
しかし、現在のフォーマットも好きかもしれません。

stdinのサポートを追加することは、実際には非常に簡単です。
私たちがしなければならないことは3つしかありません：

1. 母集団のデータをstdinから読み込んでいる間に、単一のパラメータ（都市）を受け入れることができるように、プログラムの引数を調整します。
2. stdinに渡されない場合、オプション`-f`がファイルを取り出せるようにプログラムを変更します。
3. *オプションの*ファイルパスを*使用*するように`search`機能を変更します。
    `None`ときは、stdinから読むことを知るべきです。

まず、新しい使用法を次に示します。

```rust,ignore
fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <city>", program)));
}
```
もちろん引数の処理コードを変更する必要があります。

```rust,ignore
...
    let mut opts = Options::new();
    opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    ...
    let data_path = matches.opt_str("f");

    let city = if !matches.free.is_empty() {
        &matches.free[0]
    } else {
        print_usage(&program, opts);
        return;
    };

    match search(&data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
            }
        }
        Err(err) => println!("{}", err)
    }
...
```

残りのフリーの引数`city`が存在しないときに、範囲外インデックスからのパニックではなく、使用法のメッセージを表示することで、ユーザーエクスペリエンスを少し改善しました。

`search`変更はややこしい。
`csv`クレートは、[`io::Read`を実装する任意のタイプの](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.from_reader)パーサーを構築できます。
しかし、どのようにして両方の型で同じコードを使うことができますか？
実際にはこれについていくつかの方法があります。
1つの方法は、`io::Read`を満たすいくつかの型パラメータ`R`汎用であるように`search`を書くことです。
別の方法は、特性オブジェクトを使用することです。

```rust,ignore
use std::io;

#// The rest of the code before this is unchanged.
// それ以前のコードの残りの部分は変更されていません。

fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error>> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
#    // The rest remains unchanged!
    // 残りは変わりません！
}
```

## カスタムタイプによるエラー処理

以前は[、カスタムエラータイプを使用してエラーを構成する](#composing-custom-error-types)方法を学習しました。
これを行うには、エラータイプを`enum`型として定義し、`Error`と`From`を実装します。

3つの異なるエラー（IO、CSV解析、見つからない）があるので、3つのバリアントを持つ`enum`を定義しましょう：

```rust,ignore
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Csv(csv::Error),
    NotFound,
}
```

そして今、`Display`と`Error`含意します：

```rust,ignore
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CliError::Io(ref err) => err.fmt(f),
            CliError::Csv(ref err) => err.fmt(f),
            CliError::NotFound => write!(f, "No matching cities with a \
                                             population were found."),
        }
    }
}

impl Error for CliError {
    fn cause(&self) -> Option<&Error> {
        match *self {
            CliError::Io(ref err) => Some(err),
            CliError::Csv(ref err) => Some(err),
#            // Our custom error doesn't have an underlying cause,
#            // but we could modify it so that it does.
            // 私たちのカスタムエラーには根本的な原因はありませんが、変更することができます。
            CliError::NotFound => None,
        }
    }
}
```

`CliError`型を`search`関数で使用するには、`CliError`、 `From` implsというカップルを提供する必要があります。
どのようなインプラントが提供されるのかはどのようにわかりますか？
さて、`io::Error`と`csv::Error`両方を`CliError`に変換する必要があります。
これらは唯一の外部エラーであるため、ここ`From` 2つのインプレッションを必要とします：

```rust,ignore
impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<csv::Error> for CliError {
    fn from(err: csv::Error) -> CliError {
        CliError::Csv(err)
    }
}
```

`From` implsは、[`try!`](#code-try-def)がどのように[定義されて](#code-try-def)いるかによって重要です。
特に、エラーが発生した場合は、`From::from`がエラーで呼び出されます。この場合、エラータイプ`CliError`変換されます。

`From` impls doneを使用すると、`search`関数の戻り値の型と "見つからない"という2つの小さな調整が必要になります。
ここにそれはいっぱいです：

```rust,ignore
fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, CliError> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
#//            None => { } // Skip it.
            None => { } // それをスキップします。
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(CliError::NotFound)
    } else {
        Ok(found)
    }
}
```

その他の変更は必要ありません。

## 機能の追加

一般的なコードを書くことは素晴らしいことです。一般化することはすばらしく、後で役に立ちます。
しかし時には、ジュースは圧搾に値するものではありません。
前のステップで行ったことを見てください。

1. 新しいエラータイプを定義しました。
2. 追加しましたimpls `Error`、 `Display`とするための2つ`From`。

ここでの大きな欠点は、私たちのプログラムが全体的に改善されなかったことです。
`enum`のエラーを表現するには、特にこのような短いプログラムではかなりのオーバーヘッドがあります。

ここで行ったようなカスタムエラータイプを使用する*1つの*有用な側面は、`main`関数がエラーを別々に処理することを選択できるようにすることです。
以前は、`Box<Error>`を使用していましたが、選択肢はあまりありませんでした。メッセージを印刷するだけです。
私たちはまだここでそれをやっていますが、もし`--quiet`フラグを追加したいとしたら？
`--quiet`フラグは冗長な出力を抑止します。

今のところ、プログラムが一致するものを見つけられなかった場合、それを示すメッセージが出力されます。
これは、特にあなたがシェルスクリプトでプログラムを使うつもりならば、ややこしいかもしれません。

ですから、フラグを追加することから始めましょう。
前と同じように、使用文字列を調整し、Option変数にフラグを追加する必要があります。
私たちがこれをしたら、Getoptsは残りを行います：

```rust,ignore
...
    let mut opts = Options::new();
    opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    opts.optflag("q", "quiet", "Silences errors and warnings.");
...
```

これで "静かな"機能を実装するだけです。
これは、`main`ケース分析を微調整する必要があります。

```rust,ignore
use std::process;
...
    match search(&data_path, city) {
        Err(CliError::NotFound) if matches.opt_present("q") => process::exit(1),
        Err(err) => panic!("{}", err),
        Ok(pops) => for pop in pops {
            println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
        }
    }
...
```

確かに、私たちはIOエラーがあった場合、またはデータが解析できなかった場合には静かではありません。
したがって、我々は、エラーの種類があるかどうかを確認するためにケースの分析を使用し`NotFound`場合*と* `--quiet`有効になっています。
検索が失敗した場合でも、終了コード（`grep`の規則に従って）で終了します。

`Box<Error>`で動かなかった場合、--`--quiet`機能を実装するのはかなり難しいでしょう。

これは私たちのケーススタディをかなり要約しています。
ここから、あなたは世界に出かけて、適切なエラー処理をして独自のプログラムとライブラリを書く準備ができているはずです。

# ショート・ストーリー

このセクションは長いので、Rustのエラー処理についての簡単な要約があると便利です。
これらは、いくつかの良い「経験則」です。これらは、重大な戒めではあり*ません*。これらの経験則のすべてを破る良い理由があります。

* エラー処理によって過負荷になるような短いサンプルコードを書いているのなら、おそらく`unwrap`（ [`Result::unwrap`](../../std/result/enum.Result.html#method.unwrap)、 [`Option::unwrap`](../../std/option/enum.Option.html#method.unwrap)または[`Option::expect`](../../std/option/enum.Option.html#method.expect)）を使用しても問題ありません。
   コードの消費者は、適切なエラー処理を使用することを知っている必要があります。
   （そうでない場合は、ここに送ってください！）
* クイックアンドダーティプログラムを書いているのなら、`unwrap`を使うと恥ずかしがり屋ではありません。
   警告：誰かの手の中に巻き込まれている場合は、エラーメッセージが貧弱になっても驚かないでください！
* クイックアンドダーティープログラムを作成していて、とにかくパニックになるのを恥ずかしく思っているなら、あなたのエラータイプには`String`か`Box<Error>`を使います。
* それ以外の場合は、プログラム内で、適切な[`From`](../../std/convert/trait.From.html)と[`Error`](../../std/error/trait.Error.html) implsを使用して独自のエラータイプを定義し、[`try!`](../../std/macro.try.html) macroをより人間工学的にする。
* ライブラリを作成しているときにコードでエラーが発生する場合は、独自のエラータイプを定義し、[`std::error::Error`](../../std/error/trait.Error.html)特性を実装して[`std::error::Error`](../../std/error/trait.Error.html)。
   必要に応じて、[`From`](../../std/convert/trait.From.html)を実装して、ライブラリのコードと呼び出し元のコードの両方を簡単に書くことができます。
   （Rustの一貫性の規則のため、呼び出し元はあなたのエラータイプ`From`インプリメントを行うことができないので、ライブラリはそれを行う必要があります。）
* [`Option`](../../std/option/enum.Option.html)と[`Result`](../../std/result/enum.Result.html)定義されたコンビネータを学んでください。
   それらを独占的に使用することは時々少し疲れることがありますが、私は個人的には魅力的な`try!`とcombinatorsの健康な組み合わせを見つけました。
   `and_then`、 `map`と`unwrap_or`は私のお気に入りです。

[1]: patterns.html
 [2]: ../../std/option/enum.Option.html#method.map
 [3]: ../../std/option/enum.Option.html#method.unwrap_or
 [4]: ../../std/option/enum.Option.html#method.unwrap_or_else
 [5]: ../../std/option/enum.Option.html
 [6]: ../../std/result/index.html
 [7]: ../../std/result/enum.Result.html#method.unwrap
 [8]: ../../std/fmt/trait.Debug.html
 [9]: ../../std/primitive.str.html#method.parse
 [10]: associated-types.html
 [11]: https://github.com/petewarden/dstkdata
 [12]: http://burntsushi.net/stuff/worldcitiespop.csv.gz
 [13]: http://burntsushi.net/stuff/uscitiespop.csv.gz
 [14]: http://doc.crates.io/guide.html
 [15]: http://doc.rust-lang.org/getopts/getopts/index.html

