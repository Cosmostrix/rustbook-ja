## テスト駆動開発による譜集の機能開発

*src/lib.rsに*論理を抽出し、*src/main.rs*に引数の収集と誤り処理を残した*ので*、譜面のコア機能のテストを書く方がずっと簡単です。
命令行から二進譜を呼び出すことなく、さまざまな引数を使って機能を直接呼び出すことができ、戻り値をチェックすることができます。
`Config::new`機能のいくつかのテストを自由に作成し、自分で`run`ことができます。

この章では、テストドリブン開発（TDD）過程を使用して検索論理を`minigrep`算譜に追加します。
この譜体開発技法は、次の手順に従います。

1. 失敗したテストを作成して実行し、期待どおりに失敗したかどうかを確認します。
2. 新しいテストパスを作成するのに十分な譜面を書いたり修正したりしてください。
3. ちょうど追加または変更した譜面をリファクタリングし、テストが合格したことを確認してください。
4. ステップ1から繰り返してください！　

この過程は、譜体を書く多くの方法の1つに過ぎませんが、TDDは譜面設計の推進にも役立ちます。
テストをパスする譜面を書く前にテストを書くことは、過程全体を通して高いテストカバレッジを維持するのに役立ちます。

ファイル内容のクエリ文字列を実際に検索する機能の実装をテストし、クエリに一致する行のリストを生成します。
この機能を`search`という機能に追加し`search`。

### 失敗したテストの作成

これ以上必要ないので、算譜の動作を確認するために使用した*src/lib.rs*と*src/main.rs*から`println!`文を削除しましょう。
次に、*src/lib.rsに*、第11章で行ったように、テスト機能を含む`test`役区を追加します。テスト機能は、`search`機能に必要な動作を指定します。これは、クエリとテキストを検索すると、クエリを含むテキストの行だけが返されます。
リスト12-15はこのテストを示していますが、まだ製譜されません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
#      vec![]
# }
#
#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn one_result() {
        let query = "duct";
        let contents = "\
Rust:
safe, fast, productive.
Pick three.";

        assert_eq!(
            vec!["safe, fast, productive."],
            search(query, contents)
        );
    }
}
```

<span class="caption">リスト12-15。持っていたしたい<code>search</code>機能のための失敗テストの作成</span>

このテストは文字列`"duct"`検索します。
探しているテキストは3行で、そのうちの1つだけが`"duct"`を含んでいます。
`search`機能から返される値には、期待される行のみが含まれていると主張します。

このテストを実行することはできません。テストは製譜されていないため、失敗します。`search`機能はまだ存在しません。
そこで、リスト12-16に示すように、空のベクトルを常に返す`search`機能の定義を追加して、テストを製譜して実行するのに十分な譜面を追加します。
空のベクトルが`"safe, fast, productive."`という行を含むベクトルと一致しないため、テストは製譜して失敗するはず`"safe, fast, productive."`

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    vec![]
}
```

<span class="caption">リスト12-16。テストを製譜するための<code>search</code>機能を十分に定義する</span>

`search`の型指示で定義され、`contents`引数と戻り値とともに使用される明示的な有効期間`'a`が必要であることに注目してください。
第10章では、寿命パラメータは、どの引数の寿命が戻り値の存続時間に接続されるかを指定していることを思い出してください。
この場合、返されたベクトルには、（引数`query`ではなく）引数の`contents`スライスを参照する文字列スライスが含まれている必要があることを示し`query`。

言い換えれば、`search`機能によって返されるデータは、データが`contents`引数の`search`機能に渡される限り存続することをRustに伝えます。
これは重要！　
スライス*によって*参照*される*データは、参照を有効にするために有効である必要があります。
製譜器が`contents`ではなく`query`文字列スライスを作成していると仮定すると、安全性のチェックが正しく行われません。

寿命の注釈を忘れてこの機能を製譜しようとすると、この誤りが発生します。

```text
error[E0106]: missing lifetime specifier
 --> src/lib.rs:5:51
  |
5 | pub fn search(query: &str, contents: &str) -> Vec<&str> {
  |                                                   ^ expected lifetime
parameter
  |
  = help: this function's return type contains a borrowed value, but the
  signature does not say whether it is borrowed from `query` or `contents`
```

Rustはおそらく必要とする二つの議論のどれを知ることができないので、それを伝える必要があます。
`contents`はすべてのテキストを含む引数であり、一致するテキスト部分を返したいので、`contents`は寿命構文を使用して戻り値に接続する必要がある引数です。

他の演譜言語では、型指示の戻り値に引数を接続する必要はありません。
これは奇妙に思えるかもしれませんが、時間の経過とともに容易になります。
この例を第10章の「有効期間と参照の検証」の項と比較するとよいでしょう。

今度はテストを実行しましょう。

```text
$ cargo test
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
--warnings--
    Finished dev [unoptimized + debuginfo] target(s) in 0.43 secs
     Running target/debug/deps/minigrep-abcabcabc

running 1 test
test test::one_result ... FAILED

failures:

---- test::one_result stdout ----
        thread 'test::one_result' panicked at 'assertion failed: `(left ==
right)`
left: `["safe, fast, productive."]`,
right: `[]`)', src/lib.rs:48:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.


failures:
    test::one_result

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out

error: test failed, to rerun pass '--lib'
```

うーん、期待通りにテストが失敗します。
テストをパスしましょう！　

### テストに合格する譜面を書く

現在、常に空のベクトルを返すので、テストは失敗しています。
それを修正して`search`を実装`search`は、算譜で次の手順を実行する必要があります。

* 内容の各行を繰り返します。
* 行にクエリ文字列が含まれているかどうかを確認します。
* そうであれば、返す値のリストに追加します。
* そうでない場合は、何もしないでください。
* 一致する結果のリストを返します。

各ステップを繰り返し、最初から最後まで繰り返してみましょう。

#### `lines`操作法を使用して`lines`繰り返す

Rustは、リスト12-17に示すように、便利な名前の`lines`である行単位の文字列の繰り返し処理に役立つ操作法を持っています。
これはまだ製譜されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    for line in contents.lines() {
#        // do something with line
        // 行で何かする
    }
}
```

<span class="caption">リスト12-17。 <code>contents</code>各行を繰り返す</span>

`lines`操作法は反復子を返します。
第13章で反復子について詳しく説明しますが、リスト3-5の反復子を使用するこの方法では、反復子を使用して`for`ループを使用して、集まりの各項目に対していくつかの譜面を実行しました。

#### 各行のクエリの検索

次に、現在の行にクエリ文字列が含まれているかどうかを確認します。
幸いにも、文字列には`contains`という名前の便利な操作法があり、これはためにこれを行います！　
リスト12-18に示すように、`search`機能の`contains`操作法への呼び出しを追加します。
これはまだ製譜されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    for line in contents.lines() {
        if line.contains(query) {
#            // do something with line
            // 行で何かする
        }
    }
}
```

<span class="caption">譜面リスト12-18。 <code>query</code>文字列が含まれているかどうかを調べる機能を追加する</span>

#### 照合行の保存

また、クエリ文字列を含む行を格納する方法も必要です。
そのためには、`for`ループの前に変更可能なベクトルを作成し、`push`操作法を呼び出してベクトルに`line`を格納することができます。
`for`ループの後に、リスト12-19に示すようにベクトルを返します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let mut results = Vec::new();

    for line in contents.lines() {
        if line.contains(query) {
            results.push(line);
        }
    }

    results
}
```

<span class="caption">リスト12-19。一致する行を保存して返すことができる</span>

これで`search`機能は`query`を含む行だけを返すようになり、テストは成功するはずです。
テストを実行しましょう。

```text
$ cargo test
--snip--
running 1 test
test test::one_result ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

テストは合格しました。

現時点では、検索機能の実装をリファクタリングして、同じ機能を維持するためにテストを通過させる機会を考慮することができます。
検索機能の譜面はそれほど悪くはありませんが、反復子の便利な機能を利用していません。
第13章のこの例に戻ります。ここでは、反復子を詳細に調査し、反復子を改善する方法を見ていきます。

#### `run`機能の`search`機能の使用

`search`機能が動作しテストされたので、`run`機能から`search`を呼び出す必要があります。
合格する必要が`config.query`値と`contents` `run`にファイルから読み込み`search`機能を。
次に、`run`は`search`から返された各行を出力し`search`。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn run(config: Config) -> Result<(), Box<Error>> {
    let mut f = File::open(config.filename)?;

    let mut contents = String::new();
    f.read_to_string(&mut contents)?;

    for line in search(&config.query, &contents) {
        println!("{}", line);
    }

    Ok(())
}
```

まだ`for`ループを使って`search`から各行を返し、それを印字します。

今や算譜全体がうまくいくはずです！　
エミリー・ディキンソンの詩「カエル」からちょうど1行戻ってくる言葉でまず試してみましょう。

```text
$ cargo run frog poem.txt
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.38 secs
     Running `target/debug/minigrep frog poem.txt`
How public, like a frog
```

クール！　
次に、"body"のように複数の行に一致する単語を試してみましょう。

```text
$ cargo run body poem.txt
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep body poem.txt`
I’m nobody! Who are you?
Are you nobody, too?
How dreary to be somebody!
```

そして、最後に、"monomorphization"のような、詩のどこにもない単語を検索するときに、どんな行をも作らないようにしましょう。

```text
$ cargo run monomorphization poem.txt
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep monomorphization poem.txt`
```

優れた！　
独自のミニ版の古典的な道具を構築し、譜体の構造化方法について多くのことを学びました。
また、ファイルの入出力、寿命、テスト、および命令行解析についても少し学びました。

この企画を完成させるために、環境変数を使って作業する方法と標準誤りに印字する方法を簡単に説明します。どちらも命令行算譜を書くときに便利です。
