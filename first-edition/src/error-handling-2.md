## `Error`特性

`Error`特性は[標準譜集で定義されています](../../std/error/trait.Error.html)。

```rust
use std::fmt::{Debug, Display};

trait Error: Debug + Display {
#//  /// The lower level cause of this error, if any.
  /// この誤りが発生した場合は、その原因を示します。
  fn cause(&self) -> Option<&Error> { None }
}
```

この特性は、誤りを表す*すべての*型に対して実装されるため、超総称的です。
これは、後で見るように、合成可能な譜面を記述するのに便利です。
それ以外の場合は、少なくとも以下のことを行うことができます。

* 誤りの`Debug`式を取得します。
* 誤りのユーザー側の`Display`式を取得します。
* 誤りの因果連鎖?が存在する場合（`cause`操作法を使用して）、因果連鎖?を検査します。

最初の2つは、`Debug`と`Display`両方にimplを必要とする`Error`結果です。
後者の2つは`Error`定義された2つの操作法からのものです。
`Error`の威力は、すべての誤り型が`Error`になるという事実から来[ます](trait-objects.html)。これは、誤りが現実的に[特性対象](trait-objects.html)として定量化できることを意味し[ます](trait-objects.html)。
これは、`Box<Error>`または`&Error`いずれかとして現れます。
実際、`cause`操作法は`&Error`返します。これはそれ自体が特性対象です。
`Error` traitのユーティリティを後で特性対象として再訪します。

今のところ、`Error`特性を実装する例を示すだけで十分です。
[前の章で](#defining-your-own-error-type)定義した誤り型を使用しましょう。

```rust
use std::io;
use std::num;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 導出`Debug`すべての種類は、おそらく導出する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

この特定の誤り型は、I / Oを処理する誤りまたは文字列を数値に変換する誤りの2種類の誤りが発生する可能性を表します。
この誤りは、新しい場合値を`enum`定義に追加することで、必要な数の誤り型を式できます。

実装`Error`はかなり簡単です。
ほとんどの場合、明示的な場合分けが行われます。

```rust,ignore
use std::error;
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
#            // Both underlying errors already impl `Display`, so we defer to
#            // their implementations.
            // 両方の根底にある誤りは既に`Display`を暗示しているので、実装に遅れをとっています。
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
            //  NBこれらの暗黙的キャストの両方`err`その具体的な種類から（どちらか`&io::Error`または`&num::ParseIntError`特性対象への）`&Error`。これは両方の誤り型が`Error`実装しているために機能します。
            CliError::Io(ref err) => Some(err),
            CliError::Parse(ref err) => Some(err),
        }
    }
}
```

これは非常に典型的な`Error`。matchの実装であり、さまざまな種類の誤りに対応し、 `cause`に対して定義された約束事を満たしてい`cause`。

## `From`特性

`std::convert::From` traitは[標準譜集で定義されています](../../std/convert/trait.From.html)。

<span id="code-from-def"></span>
```rust
trait From<T> {
    fn from(T) -> Self;
}
```

おいしいシンプルな、はい？　
それは私たちに、特定の型*から*の変換について話をする汎用的な方法与えるので、非常に便利である`T`（この場合は、「他のいくつかの型が」IMPL、またはの対象である他のいくつかの型に`Self`）。
`From`の要点は[、標準譜集によって提供される一連の実装](../../std/convert/trait.From.html)です。

`From`仕組みを示す簡単な例がいくつかあります。

```rust
let string: String = From::from("foo");
let bytes: Vec<u8> = From::from("foo");
let cow: ::std::borrow::Cow<str> = From::from("foo");
```

OK、`From`は文字列間の変換に便利です。
しかし、誤りはどうでしょうか？　
それは、1つの重要な示唆があることが判明しました。

```rust,ignore
impl<'a, E: Error + 'a> From<E> for Box<Error + 'a>
```

これは、`Error`を意味する*任意の*型に対して、それを特性対象`Box<Error>`変換できることを意味します。
これはひどく驚くようなことではないかもしれませんが、一般的な文脈では役に立ちます。

以前に扱っていた2つの誤りを覚えていますか？　
具体的には、`io::Error`と`num::ParseIntError`です。
両方ともimpl `Error`であるため、`From`と動作します。

```rust
use std::error::Error;
use std::fs;
use std::io;
use std::num;

#// We have to jump through some hoops to actually get error values:
// 実際に誤り値を取得するには、いくつかのフープを飛ばしなければなりません。
let io_err: io::Error = io::Error::last_os_error();
let parse_err: num::ParseIntError = "not a number".parse::<i32>().unwrap_err();

#// OK, here are the conversions:
// はい、コン版は次のとおりです。
let err1: Box<Error> = From::from(io_err);
let err2: Box<Error> = From::from(parse_err);
```

ここで本当に重要なパターンがあります。
`err1`と`err2`が*同じ型*です。
これは、それらが現存する定量化された型または特性対象であるためです。
特に、その基礎となる型は製譜器の知識から*消去さ*れるため、まったく同じものとして`err1`と`err2`真に見えます。
さらに、正確に同じ機能呼び出し、`From::from`を使用して`err1`と`err2`を構築`From::from`。
これは、`From::from`がその引数とその戻り型の両方で多重定義されているためです。

このパターンは、以前の問題を解決するため重要です。同じ機能を使用して誤りを同じ型に確実に変換する方法を提供します。

古い友達を再訪する時間。
`try!`マクロ。

## 本当の`try!`マクロ

これまで、`try!`この定義を提示しました。

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

これは実際の定義ではありません。
その実際の定義は[標準譜集にあります](../../std/macro.try.html)。

<span id="code-try-def"></span>
```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(::std::convert::From::from(err)),
    });
}
```

小さくても強力な変更が1つあります。誤り値は`From::from`渡さ`From::from`ます。
これにより、`try!`マクロをより強力にすることができます。これは、自動的に型変換を行うためです。

より強力な`try!`マクロを用意して、ファイルを読み込んでその内容を整数に変換するために以前書いた譜面を見てみましょう。

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
確かに、しなければならないのは、`From`作品を選ぶことだけです。
前の章で見たように、`From`は、あらゆる誤り型を`Box<Error>`に変換するための実装があります。

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

理想的な誤り処理に非常に近づいています。
`try!`マクロは3つのものを同時にカプセル化するため、誤り処理の結果としてオーバーヘッドはほとんどありません。

1. 場合分け。
2. 制御の流れ。
3. 誤り型変換。

3つのものがすべて結合されると、組子、`unwrap`または場合分けの呼び出しによって妨げられない譜面が得られます。

少し残っています。 `Box<Error>`型は*目隠し*です。
呼び出し元に`Box<Error>`を返すと、呼び出し元は基になる誤り型を（簡単に）検査できません。
状況がより確かに優れている`String`、発信者のような操作法を呼び出すことができますので[`cause`](../../std/error/trait.Error.html#method.cause)、しかし制限が残っています。 `Box<Error>`目隠しです。
（これは完全に真実ではありません。なぜなら、Rustには実行時リフレクションがあるからです。[これは、この章の範囲を超えて](https://crates.io/crates/error)いる場合で便利です）。

今度は、独自の`CliError`型を再訪し、すべてを結びつけるときです。

## 独自の誤り型の作成

最後の章では、実際の`try!`マクロと、誤り値の`From::from`を呼び出すことによって、自動型変換を行う方法を見てきました。
特に、誤りを`Box<Error>`に変換しましたが、これは動作しますが、型は呼び出し元に対して目隠しです。

これを修正するには、既に慣れ親しんでいるのと同じ措置、すなわち独自の誤り型を使用します。
もう一度、ファイルの内容を読み取り、それを整数に変換する譜面を次に示します。

```rust
use std::fs::File;
use std::io::{self, Read};
use std::num;
use std::path::Path;

#// We derive `Debug` because all types should probably derive `Debug`.
#// This gives us a reasonable human-readable description of `CliError` values.
// 導出`Debug`すべての種類は、おそらく導出する必要があるため`Debug`。これは`CliError`値を人が読めるように説明して`CliError`ます。
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
問題は、`io::Error`や`num::ParseIntError`ような誤り型から独自の`CliError`に変換することを可能にする`From` implは存在しないということ`CliError`。
もちろん、これを修正するのは簡単です！　
定義されているので`CliError`、IMPLできる`From`それと。

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

これらのすべての実装を教えてやっている`From`作成方法`CliError`他の誤り型からを。
場合、構築は対応する値構築子を呼び出すのと同じくらい簡単です。
確かに、これは*通常*簡単です。

最終的に`file_double`書き直すことができ`file_double`。

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
`try!`マクロが誤り値の`From::from`を呼び出すため、これらのマクロは不要になりました。
これは、出現する可能性のあるすべての誤り型に対して、`From`差し込み」 `From`提供されているために機能します。

`file_double`機能を変更して、たとえば文字列を浮動小数点数に変換するなどの操作を実行した場合は、新しい場合値を誤り型に追加する必要があります。

```rust
use std::io;
use std::num;

enum CliError {
    Io(io::Error),
    ParseInt(num::ParseIntError),
    ParseFloat(num::ParseFloatError),
}
```

新規追加`From`のimpl。

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

## 譜集の作家のためのアドバイス

譜集で独自の誤りをレポートする必要がある場合は、おそらく独自の誤り型を定義する必要があります。
その式（[`ErrorKind`](../../std/io/enum.ErrorKind.html)）を公開するかどうか、または[`ParseIntError`](../../std/num/struct.ParseIntError.html)ように非表示にするかどうかは、あなた次第です。
それをどうしているかにかかわらず、少なくとも誤りの情報を`String`式を超えて提供することは、通常は良い方法です。
しかし、確かに、これは使用例によって異なります。

少なくとも、[`Error`](../../std/error/trait.Error.html)特性を実装するべきです。
これにより、譜集のユーザーは[誤り](#the-real-try-macro)を[作成する](#the-real-try-macro)ための柔軟性が[失われ](#the-real-try-macro)ます。
`Error`特性を実装することは、`fmt::Debug`と`fmt::Display`両方にimplを必要とするため、ユーザーが誤りの文字列式を取得することが保証されていることも意味します。

それ以外にも、誤り型の`From`実装を提供すると便利です。
これにより、あなた（譜集作成者）とユーザーは[より詳細な誤り](#composing-custom-error-types)を[作成することができ](#composing-custom-error-types)ます。
例えば、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)は、`io::Error`と`byteorder::Error`両方`From` 実装を提供します。

最後に、あなたの好みに応じて、特に譜集で単一の誤り型が定義されている場合は、[`Result`型の別名](#the-result-type-alias-idiom)を定義することもできます。
これは、[`io::Result`](../../std/io/type.Result.html)と[`fmt::Result`](../../std/fmt/type.Result.html)の標準譜集で使用されます。

# 事例で学ぶ。人口データを読み込む算譜

この章は長く、あなたの背景にもよるが、それはむしろ密であるかもしれない。
散文と一緒に行くための譜面例はたくさんありますが、そのほとんどは教育的であるように特別に設計されています。
だから、新しいことをするつもりです。事例研究。

このために、世界の人口データを照会する命令行算譜を構築します。
目的は簡単です。あなたはそれに場所を与え、人口を教えてくれるでしょう。
シンプルさにもかかわらず、間違っていることがたくさんあります！　

使用するデータは、[Data Science Toolkitに][11]基づいています。
この演習では、それ用のデータを用意しました。
[世界人口データ][12]（41MB gzip圧縮、145MB非圧縮）または[米国人口データ][13]（2.2MB gzip圧縮、7.2MB非圧縮）だけを[取得できます][13]。

これまでは、譜面をRustの標準譜集に限定していました。
このような実際の仕事では、少なくともCSVデータを解析し、算譜の引数を解析し、その情報をRust型に自動的に解読する必要があります。
そのために、[`csv`](https://crates.io/crates/csv)と[`rustc-serialize`](https://crates.io/crates/rustc-serialize)使用します。

## 初期設定

Cargoの企画では、すでに[Cargo章](getting-started.html#hello-cargo)と[Cargoの開発資料集で][14]十分にカバーされているため、企画を立ち上げるのに多くの時間を費やすつもりはありません。

ゼロから始めるには、`cargo new --bin city-pop`を実行し、`Cargo.toml`が次のようになっていることを確認してください。

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

あなたはすでに実行することができます。

```text
cargo build --release
./target/release/city-pop
# Outputs: Hello, world!
```

## 引数の解析

引き分けに引数の解析をしましょう。
Getoptsについて詳しく説明しませんが、それを記述する[良い文書][15]があります。
短い話は、Getoptsが選択肢のベクトルから引数構文解析器と手引きメッセージを生成することです（ベクトルであるという事実は、構造体と操作法のセットの背後に隠されています）。
解析が完了すると、構文解析器は、定義された選択肢と残りの "空き"引数との一致を記録する構造体を返します。
そこから、フラグの情報、例えば、渡されたかどうか、どのような引数があるかなどの情報を取得できます。
ここでは、適切な`extern crate` crate文とGetoptsの基本引数設定を使って、算譜を導入します。

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

まず、算譜に渡された引数のベクトルを取得します。
次に、算譜の名前であることを認識して、最初のものを保存します。
これが終わると、引数フラグを設定します。この場合、単純な手引きメッセージフラグです。
引数フラグが設定されると、`Options.parse`を使用して引数ベクトルを解析します（添字0は算譜名です）。
これが成功した場合、解析された対象にマッチを割り当てます。そうでなければ、パニックになります。
それを過ぎると、ユーザーが手引きフラグを渡したかどうかテストし、もしそうなら、使用法のメッセージを出力します。
選択肢の手引きメッセージはGetoptsによって構築されるので、使用法のメッセージを出力するために必要なことは、算譜名とひな型のために印字することだけです。
ユーザーが手引きフラグを渡さなかった場合、適切な変数を対応する引数に割り当てます。

## 論理を書く

すべて譜面を違って書いていますが、通常は誤り処理が考えています。
これは算譜全体の設計にはあまり適していませんが、ラピッドプロトタイピングには役立ちます。
Rustは誤り処理を明示的に（強制的に`unwrap`呼び出すことによって）強制型変換するので、算譜のどの部分が誤りを引き起こすかを簡単に知ることができます。

この事例で学ぶでは、ロジックは本当に簡単です。
必要なのは、私たちに与えられたCSVデータを解析して、一致する行に欄を印字することだけです。
やってみましょう。
（`extern crate csv;`をファイルの先頭に追加してください）

```rust,ignore
use std::fs::File;

#// This struct represents the data in each row of the CSV file.
#// Type based decoding absolves us of a lot of the nitty-gritty error
#// handling, like parsing strings as integers or floats.
// この構造体は、CSVファイルの各行のデータを表します。型に基づく解読では、文字列を整数または浮動小数点として解析するような、きめ細かな誤り処理がたくさんあります。
#[derive(Debug, RustcDecodable)]
struct Row {
    country: String,
    city: String,
    accent_city: String,
    region: String,

#    // Not every row has data for the population, latitude or longitude!
#    // So we express them as `Option` types, which admits the possibility of
#    // absence. The CSV parser will fill in the correct value for us.
    // すべての行に人口、緯度、経度のデータがあるわけではありません！　だから`Option` typesとしてそれらを式します。これは欠如の可能性を認めています。CSV構文解析器ーが正しい値を入力します。
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

誤りの概要を説明しましょう。
明白なことから始めることができます。`unwrap`と呼ばれる3つの場所は、

1. [`File::open`](../../std/fs/struct.File.html#method.open)は[`io::Error`](../../std/io/struct.Error.html)返すことができます。
2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode)は一度に一つの記録票を[解読し、記録票](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)を[解読する](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html)と（`Iterator` implで`Item`関連型を調べると）、[`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html)が生成されます。
3. `row.population`が`None`場合、`expect`を呼び出すとパニックになります。

他に何かありますか？　
一致する都市が見つからない場合はどうすればよいでしょうか？　
`grep`ような道具は誤り譜面を返すので、おそらくそれも必要です。
だから問題に固有の論理誤り、IO誤り、CSV解析誤りがあます。
これらの誤りを処理するための2つの異なる方法を検討します。

私は`Box<Error>`から始めたいと思います。
後で、独自の誤り型の定義がどのように役立つかを見ていきます。

## `Box<Error>`誤り処理`Box<Error>`

`Box<Error>`それ*だけで動作します*ので、いいです。
独自の誤り型を定義する必要はなく、`From`実装は必要ありません。
欠点は、`Box<Error>`が特性対象であるため*、型を消去する*ということです。つまり、製譜器は根本的な型を理由に考えることができなくなります。

[Previously](#the-limits-of-組子)は、機能の型を`T`から`Result<T, OurErrorType>`変更して、譜面をリファクタリングし始めました。
この場合、`OurErrorType`は`Box<Error>`のみです。
しかし、`T`何でしょうか？　
`main`戻り値型を追加できますか？　

2番目の質問に対する答えは「いいえ、できません。
つまり、新しい機能を書く必要があります。
しかし、`T`とは何でしょうか？　
一番簡単なのは、一致する`Row`値のリストを`Vec<Row>`として返すことです。
（より良い譜面は反復子を返しますが、それは読者の練習課題として残されています）。

譜面を独自の機能にリファクタリングしましょうが、呼び出しを`unwrap`するようにしましょう。
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
    // これは、もはや`Option`はない。なぜなら、この型の値は、人口数がある場合にのみ構築されるからであます。
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

これを適切な誤り処理に変換するには、以下を実行する必要があります。

1. `search`の戻り値の型を`Result<Vec<PopulationCount>, Box<Error>>`ます。
2. 算譜をパニックするのではなく、誤りが呼び出し元に返されるように[`try!`マクロを](#code-try-def)使用して[`try!`](#code-try-def)。
3. `main`の誤りを処理します。

試してみよう。

```rust,ignore
use std::error::Error;

#// The rest of the code before this is unchanged.
// それ以前の譜面の残りの部分は変更されていません。

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
機能が`Result<T, E>`返すので、誤りが発生した場合、`try!`マクロは機能の早い段階で返されます。

`search`の終わりに、[対応する`From` 実装](../../std/convert/trait.From.html)を使用してそのまま文字列を誤り型に変換します。

```rust,ignore
#// We are making use of this impl in the code above, since we call `From::from`
#// on a `&'static str`.
// 呼んで以来、上記の譜面では、このIMPLを利用している`From::from`の`&'static str`。
impl<'a> From<&'a str> for Box<Error>

#// But this is also useful when you need to allocate a new string for an
#// error message, usually with `format!`.
// しかしこれは、誤りメッセージに新しい文字列を割り当てる必要がある場合にも便利です（通常は`format!`。
impl From<String> for Box<Error>
```

以来`search`今や返す`Result<T, E>`、 `main`呼び出し時に場合分けを使用する必要があります`search`。

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

`Box<Error>`で適切な誤り処理を行う方法を見てきたので、独自の独自の誤り型で別のアプローチを試してみましょう。
しかし、まず、誤り処理から簡単に休みを取り、`stdin`からの読み込みのサポートを追加しましょう。

## 標準入力から読む

算譜では、入力用に1つのファイルを受け入れ、データを1つのファイルに渡します。
つまり、stdinの入力を受け入れることができるはずです。
しかし、現在の形式も好きかもしれません。

stdinのサポートを追加することは、実際には非常に簡単です。
しなければならないことは3つしかありません。

1. 母集団のデータをstdinから読み込んでいる間に、単一のパラメータ（都市）を受け入れることができるように、算譜の引数を調整します。
2. stdinに渡されない場合、選択肢`-f`がファイルを取り出せるように算譜を変更します。
3. *選択肢の*ファイルパスを*使用*するように`search`機能を変更します。
    `None`ときは、stdinから読むことを知るべきです。

まず、新しい使用法を次に示します。

```rust,ignore
fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <city>", program)));
}
```
もちろん引数の処理譜面を変更する必要があります。

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

残りのフリーの引数`city`が存在しないときに、範囲外添字からのパニックではなく、使用法のメッセージを表示することで、使用感を少し改善しました。

`search`変更はややこしい。
`csv`通い箱は、[`io::Read`を実装する任意の型の](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.from_reader)構文解析器ーを構築できます。
しかし、どのようにして両方の型で同じ譜面を使うことができますか？　
実際にはこれについていくつかの方法があります。
1つの方法は、`io::Read`を満たすいくつかの型パラメータ`R`汎用であるように`search`を書くことです。
別の方法は、特性対象を使用することです。

```rust,ignore
use std::io;

#// The rest of the code before this is unchanged.
// それ以前の譜面の残りの部分は変更されていません。

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

## 独自の型による誤り処理

以前は[、独自の誤り型を使用して誤りを構成する](#composing-custom-error-types)方法を学習しました。
これを行うには、誤り型を`enum`型として定義し、`Error`と`From`を実装します。

3つの異なる誤り（IO、CSV解析、見つからない）があるので、3つの場合値を持つ`enum`を定義しましょう。

```rust,ignore
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Csv(csv::Error),
    NotFound,
}
```

そして今、`Display`と`Error`含意します。

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
            // 独自の誤りには根本的な原因はありませんが、変更することができます。
            CliError::NotFound => None,
        }
    }
}
```

`CliError`型を`search`機能で使用するには、`CliError`、 `From` 実装というカップルを提供する必要があります。
どのような実装が提供されるのかはどのようにわかりますか？　
さて、`io::Error`と`csv::Error`両方を`CliError`に変換する必要があります。
これらは唯一の外部誤りであるため、ここ`From` 2つの実装を必要とします。

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

`From` 実装は、[`try!`](#code-try-def)がどのように[定義されて](#code-try-def)いるかによって重要です。
特に、誤りが発生した場合は、`From::from`が誤りで呼び出されます。この場合、誤り型`CliError`変換されます。

`From` 実装 doneを使用すると、`search`機能の戻り値の型と "見つからない"という2つの小さな調整が必要になります。
ここにそれはいっぱいです。

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

一般的な譜面を書くことは素晴らしいことです。一般化することはすばらしく、後で役に立ちます。
しかし時には、ジュースは圧搾に値するものではありません。
前のステップで行ったことを見てください。

1. 新しい誤り型を定義しました。
2. 追加しました実装 `Error`、 `Display`とするための2つ`From`。

ここでの大きな欠点は、算譜が全体的に改善されなかったことです。
`enum`の誤りを式するには、特にこのような短い算譜ではかなりのオーバーヘッドがあります。

ここで行ったような独自の誤り型を使用する*1つの*有用な側面は、`main`機能が誤りを別々に処理することを選択できるようにすることです。
以前は、`Box<Error>`を使用していましたが、選択肢はあまりありませんでした。メッセージを印字するだけです。
まだここでそれをやっていますが、もし`--quiet`フラグを追加したいとしたら？　
`--quiet`フラグは冗長な出力を抑止します。

今のところ、算譜が一致するものを見つけられなかった場合、それを示すメッセージが出力されます。
これは、特にあなたが司得台譜で算譜を使うつもりならば、ややこしいかもしれません。

ですから、フラグを追加することから始めましょう。
前と同じように、使用文字列を調整し、Option変数にフラグを追加する必要があります。
これをしたら、Getoptsは残りを行います。

```rust,ignore
...
    let mut opts = Options::new();
    opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    opts.optflag("q", "quiet", "Silences errors and warnings.");
...
```

これで "静かな"機能を実装するだけです。
これは、`main`場合分けを微調整する必要があります。

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

確かに、IO誤りがあった場合、またはデータが解析できなかった場合には静かではありません。
したがって、誤りの種類があるかどうかを確認するために場合分けを使用し`NotFound`場合*と* `--quiet`有効になっています。
検索が失敗した場合でも、終了譜面（`grep`の規則に従って）で終了します。

`Box<Error>`で動かなかった場合、--`--quiet`機能を実装するのはかなり難しいでしょう。

これは事例で学ぶをかなり要約しています。
ここから、あなたは世界に出かけて、適切な誤り処理をして独自の算譜と譜集を書く準備ができているはずです。

# ショート・ストーリー

この章は長いので、Rustの誤り処理についての簡単な要約があると便利です。
これらは、いくつかの良い「経験則」です。これらは、重大な戒めではあり*ません*。これらの経験則のすべてを破る良い理由があります。

* 誤り処理によって多重定義になるような短い譜面例を書いているのなら、おそらく`unwrap`（ [`Result::unwrap`](../../std/result/enum.Result.html#method.unwrap)、 [`Option::unwrap`](../../std/option/enum.Option.html#method.unwrap)または[`Option::expect`](../../std/option/enum.Option.html#method.expect)）を使用しても問題ありません。
   譜面の消費者は、適切な誤り処理を使用することを知っている必要があります。
   （そうでない場合は、ここに送ってください！　）
* 間に合わせの算譜を書いているのなら、`unwrap`を使うと恥ずかしがり屋ではありません。
   警告。誰かの手の中に巻き込まれている場合は、誤りメッセージが貧弱になっても驚かないでください！　
* 間に合わせの算譜を作成していて、とにかくパニックになるのを恥ずかしく思っているなら、あなたの誤り型には`String`か`Box<Error>`を使います。
* それ以外の場合は、算譜内で、適切な[`From`](../../std/convert/trait.From.html)と[`Error`](../../std/error/trait.Error.html) 実装を使用して独自の誤り型を定義し、[`try!`](../../std/macro.try.html) macroをより使い勝手を改善します。
* 譜集を作成しているときに譜面で誤りが発生する場合は、独自の誤り型を定義し、[`std::error::Error`](../../std/error/trait.Error.html)特性を実装して[`std::error::Error`](../../std/error/trait.Error.html)。
   必要に応じて、[`From`](../../std/convert/trait.From.html)を実装して、譜集の譜面と呼び出し元の譜面の両方を簡単に書くことができます。
   （Rustの一貫性の規則のため、呼び出し元はあなたの誤り型`From`実装を行うことができないので、譜集はそれを行う必要があります。）
* [`Option`](../../std/option/enum.Option.html)と[`Result`](../../std/result/enum.Result.html)定義された組子を学んでください。
   それらを独占的に使用することは時々少し疲れることがありますが、私は個人的には魅力的な`try!`と組子の健康な組み合わせを見つけました。
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

