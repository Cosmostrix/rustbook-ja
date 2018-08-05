## 環境変数の操作

特別な機能を追加することで`minigrep`を改善します。大文字と小文字を区別しない検索のオプションで、利用者が環境変数で有効にすることができます。
この機能を<ruby>命令行<rt>コマンドライン</rt></ruby>選択肢にすることができ、利用者が適用するたびに入力する必要がありますが、代わりに環境変数を使用します。
そうすることで、利用者は環境変数を一度設定し、すべての検索でその<ruby>端末<rt>ターミナル</rt></ruby>セッションで大文字と小文字を区別することができます。

### 大文字と小文字を区別しない`search`機能の失敗テストの作成

環境変数がオンのときに呼び出す新しい`search_case_insensitive`機能を追加します。
TDD過程に従い続けますので、最初のステップは失敗したテストを書き直すことです。
リスト12-20に示すように、新しい`search_case_insensitive`機能の新しいテストを追加し、古いテストの名前を`one_result`から`case_sensitive`に変更して、2つのテストの違いを明確にします。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn case_sensitive() {
        let query = "duct";
        let contents = "\
Rust:
safe, fast, productive.
Pick three.
Duct tape.";

        assert_eq!(
            vec!["safe, fast, productive."],
            search(query, contents)
        );
    }

    #[test]
    fn case_insensitive() {
        let query = "rUsT";
        let contents = "\
Rust:
safe, fast, productive.
Pick three.
Trust me.";

        assert_eq!(
            vec!["Rust:", "Trust me."],
            search_case_insensitive(query, contents)
        );
    }
}
```

<span class="caption">リスト12-20。追加しようとしている大文字と小文字を区別しない機能のための新しい失敗テストを追加する</span>

古いテストの`contents`も編集していることに注意してください。
テキストに`"Duct tape."`という新しい行が追加されました`"Duct tape."`
大文字と小文字を区別して検索する際に、`"duct"`というクエリと一致しない大文字のDを使用します。
このように古いテストを変更することで、すでに実装されている大文字と小文字を区別した検索機能を誤って破損しないようになります。
このテストは今すぐ通過し、大文字と小文字を区別しない検索に取り組んでいきます。

大文字と*小文字を区別しない*検索の新しいテストでは、クエリとして`"rUsT"`使用されます。
追加しようとしている`search_case_insensitive`機能では、クエリ`"rUsT"`は`"Rust:"`を含む行と大文字Rを一致させ、`"Trust me."`という行に一致する必要があり`"Trust me."`
どちらもクエリーとは異なるケーシングを持っています。
これは失敗テストですが、`search_case_insensitive`機能をまだ定義していないため、<ruby>製譜<rt>コンパイル</rt></ruby>に失敗します。
リスト12-16の`search`機能の場合と同様に、空のベクトルを返すスケルトン実装を自由に追加して、テストの<ruby>製譜<rt>コンパイル</rt></ruby>と失敗を確認してください。

### `search_case_insensitive`機能の実装

リスト12-21に示す`search_case_insensitive`機能は、`search`機能とほぼ同じです。
唯一の違いは、小文字だろうということで`query`と各`line`ので、行がクエリが含まれているかどうかをチェックするときどんな入力引数の場合、それらは同じケースになるでしょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub fn search_case_insensitive<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let query = query.to_lowercase();
    let mut results = Vec::new();

    for line in contents.lines() {
        if line.to_lowercase().contains(&query) {
            results.push(line);
        }
    }

    results
}
```

<span class="caption">リスト12-21。 <code>search_case_insensitive</code>機能を定義して照会とその行を比較する前に小文字にする</span>

まず、`query`<ruby>文字列<rt>ストリング</rt></ruby>を小文字にして、同じ名前の影付き変数に格納し`query`。
クエリで`to_lowercase`を呼び出す必要があるので、利用者のクエリが`"rust"`、 `"RUST"`、 `"Rust:"`、 `"rUsT"`いずれのクエリであっても、クエリは`"rust"`であるかのように扱われますケース。

その注意`query`今ある`String`を呼び出すためではなく、<ruby>文字列<rt>ストリング</rt></ruby>スライス`to_lowercase`、既存のデータを参照するのではなく、新しいデータを作成します。
クエリが`"rUsT"`であるとしましょう。つまり、<ruby>文字列<rt>ストリング</rt></ruby>スライスには使用する小文字の`u`または`t`が含まれていないので、`"rust"`を含む新しい`String`を割り当てる必要があります。
通過すると`query`引数として`contains`今の方法を、の署名ので、アンパサンドを追加する必要が`contains`、<ruby>文字列<rt>ストリング</rt></ruby>のスライスを取るように定義されています。

次に、の呼び出しを追加`to_lowercase`それぞれに`line`それが含まれているかどうかを確認する前に、`query`すべての文字を小文字に。
`line`と`query`を小文字に変換したので、`query`大文字と小文字は関係ありません。

この実装がテストに合格したかどうかを見てみましょう。

```text
running 2 tests
test test::case_insensitive ... ok
test test::case_sensitive ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

すばらしいです！　
それらは合格した。
それでは、新しい呼びましょう`search_case_insensitive`から機能を`run`機能。
まず、`Config`構造体に構成<ruby>選択肢<rt>オプション</rt></ruby>を追加して、大文字小文字の区別と大/小文字を区別しない検索を切り替えます。
この<ruby>欄<rt>フィールド</rt></ruby>を追加すると、この<ruby>欄<rt>フィールド</rt></ruby>はまだどこにでも初期化されていないため、<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct Config {
    pub query: String,
    pub filename: String,
    pub case_sensitive: bool,
}
```

真偽値を保持する`case_sensitive`<ruby>欄<rt>フィールド</rt></ruby>を追加したことに注意してください。
次に、`run`機能を使用して`case_sensitive`<ruby>欄<rt>フィールド</rt></ruby>の値をチェックし、それを使用して`search`機能または`search_case_insensitive`機能を呼び出すかどうかを決定します（`search_case_insensitive`リスト12-22を参照）。
これはまだ<ruby>製譜<rt>コンパイル</rt></ruby>されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# use std::error::Error;
# use std::fs::File;
# use std::io::prelude::*;
#
# fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
#      vec![]
# }
#
# pub fn search_case_insensitive<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
#      vec![]
# }
#
# struct Config {
#     query: String,
#     filename: String,
#     case_sensitive: bool,
# }
#
pub fn run(config: Config) -> Result<(), Box<Error>> {
    let mut f = File::open(config.filename)?;

    let mut contents = String::new();
    f.read_to_string(&mut contents)?;

    let results = if config.case_sensitive {
        search(&config.query, &contents)
    } else {
        search_case_insensitive(&config.query, &contents)
    };

    for line in results {
        println!("{}", line);
    }

    Ok(())
}
```

<span class="caption">リスト12-22。 <code>config.case_sensitive</code>の値に基づいて<code>search</code>または<code>search_case_insensitive</code>を呼び出す</span>

最後に、環境変数を確認する必要があります。
環境変数を扱うための機能は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`env`<ruby>役区<rt>モジュール</rt></ruby>にあるので、`use std::env;`してその<ruby>役区<rt>モジュール</rt></ruby>を<ruby>有効範囲<rt>スコープ</rt></ruby>に入れたいと思っています`use std::env;`
*src/lib.rsの*先頭にある行。
次に、`env`<ruby>役区<rt>モジュール</rt></ruby>の`var`機能を使用して、`CASE_INSENSITIVE`という名前の環境変数をチェックします（`CASE_INSENSITIVE`リスト12-23を参照）。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
use std::env;
# struct Config {
#     query: String,
#     filename: String,
#     case_sensitive: bool,
# }

#// --snip--
//  --snip--

impl Config {
    pub fn new(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 3 {
            return Err("not enough arguments");
        }

        let query = args[1].clone();
        let filename = args[2].clone();

        let case_sensitive = env::var("CASE_INSENSITIVE").is_err();

        Ok(Config { query, filename, case_sensitive })
    }
}
```

<span class="caption">リスト12-23。 <code>CASE_INSENSITIVE</code>という名前の環境変数をチェックする</span>

ここでは、`case_sensitive`という新しい変数を作成します。
その値を設定するには、`env::var`機能を呼び出して、`CASE_INSENSITIVE`環境変数の名前を`CASE_INSENSITIVE`ます。
`env::var`機能は、環境変数が設定されている場合、環境変数の値を含む成功した`Ok`<ruby>場合値<rt>バリアント</rt></ruby>になる`Result`を返します。
環境変数が設定されていない場合、`Err`<ruby>場合値<rt>バリアント</rt></ruby>が返されます。

`Result`上で`is_err`<ruby>操作法<rt>メソッド</rt></ruby>を使用して<ruby>誤り<rt>エラー</rt></ruby>であるかどうかをチェックしています。つまり、大文字と小文字を区別して検索する*必要*があります。
`CASE_INSENSITIVE`環境変数が何かに設定されている場合、`is_err`はfalseを返し、<ruby>算譜<rt>プログラム</rt></ruby>は大文字と小文字を区別しない検索を実行します。
それが設定または設定解除ちょうどかどうか、環境変数の*値*を気にしないので、チェックしている`is_err`ではなく、使用して`unwrap`、 `expect`、あるいは上で見てきた他の方法のいずれかの`Result`。

リスト12-22で実装したように、`run`機能がその値を読み取って`search`または`search_case_insensitive`を呼び出すかどうかを判断できるように、`case_sensitive`変数の値を`Config`<ruby>実例<rt>インスタンス</rt></ruby>に`search_case_insensitive`ます。

やるだけやってみよう！　
まず、環境変数を設定せずにクエリ`to`使用`to`て<ruby>算譜<rt>プログラム</rt></ruby>を実行します。これは "to"という単語を含む行とすべて小文字で一致します。

```text
$ cargo run to poem.txt
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep to poem.txt`
Are you nobody, too?
How dreary to be somebody!
```

それはまだ動作するように見えます！　
さて、`CASE_INSENSITIVE`を`1`設定して、同じクエリ`to`使って<ruby>算譜<rt>プログラム</rt></ruby>を実行しましょう。

PowerShellを使用している場合は、環境変数を設定し、<ruby>算譜<rt>プログラム</rt></ruby>を1つではなく2つの命令で実行する必要があります。

```text
$ $env:CASE_INSENSITIVE=1
$ cargo run to poem.txt
```

大文字の "to"を含む行を取得する必要があります。

```text
$ CASE_INSENSITIVE=1 cargo run to poem.txt
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep to poem.txt`
Are you nobody, too?
How dreary to be somebody!
To tell your name the livelong day
To an admiring bog!
```

優秀、また、"To"を含む行を持っています！　
`minigrep`<ruby>算譜<rt>プログラム</rt></ruby>は、環境変数によって制御される大文字と小文字を区別しない検索を行うことができます。
<ruby>命令行<rt>コマンドライン</rt></ruby>引数または環境変数のいずれかを使用して設定された<ruby>選択肢<rt>オプション</rt></ruby>を管理する方法が分かりました。

<ruby>算譜<rt>プログラム</rt></ruby>によっては、同じ構成に対して引数*と*環境変数を使用できるものが*あり*ます。
そのような場合、<ruby>算譜<rt>プログラム</rt></ruby>はどちらか一方が優先されると判断します。
あなた自身の別の練習問題については、<ruby>命令行<rt>コマンドライン</rt></ruby>引数か環境変数のどちらかで大文字と小文字の区別を制御してみてください。
<ruby>算譜<rt>プログラム</rt></ruby>が、大文字小文字を区別するように設定し、大文字小文字を区別しないで実行する場合は、<ruby>命令行<rt>コマンドライン</rt></ruby>引数または環境変数を優先するかどうかを決定します。

`std::env`<ruby>役区<rt>モジュール</rt></ruby>には、環境変数を扱うためのより多くの便利な機能が含まれています。
