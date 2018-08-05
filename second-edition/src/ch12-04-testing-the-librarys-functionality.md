## テスト駆動開発による<ruby>譜集<rt>ライブラリー</rt></ruby>の機能開発

*src/lib.rsに*<ruby>論理<rt>ロジック</rt></ruby>を抽出し、*src/main.rs*に引数の収集と<ruby>誤り<rt>エラー</rt></ruby>処理を残した*ので*、<ruby>譜面<rt>コード</rt></ruby>のコア機能のテストを書く方がずっと簡単です。
<ruby>命令行<rt>コマンドライン</rt></ruby>から<ruby>二進譜<rt>バイナリ</rt></ruby>を呼び出すことなく、さまざまな引数を使って機能を直接呼び出すことができ、戻り値をチェックすることができます。
`Config::new`機能のいくつかのテストを自由に作成し、自分で`run`ことができます。

この章では、テストドリブン開発（TDD）過程を使用して検索<ruby>論理<rt>ロジック</rt></ruby>を`minigrep`<ruby>算譜<rt>プログラム</rt></ruby>に追加します。
この<ruby>譜体<rt>アプリケーション</rt></ruby>開発技法は、次の手順に従います。

1. 失敗したテストを作成して実行し、期待どおりに失敗したかどうかを確認します。
2. 新しいテストパスを作成するのに十分な<ruby>譜面<rt>コード</rt></ruby>を書いたり修正したりしてください。
3. ちょうど追加または変更した<ruby>譜面<rt>コード</rt></ruby>をリファクタリングし、テストが合格したことを確認してください。
4. ステップ1から繰り返してください！　

この過程は、<ruby>譜体<rt>アプリケーション</rt></ruby>を書く多くの方法の1つに過ぎませんが、TDDは<ruby>譜面<rt>コード</rt></ruby>設計の推進にも役立ちます。
テストをパスする<ruby>譜面<rt>コード</rt></ruby>を書く前にテストを書くことは、過程全体を通して高いテストカバレッジを維持するのに役立ちます。

ファイル内容のクエリ<ruby>文字列<rt>ストリング</rt></ruby>を実際に検索する機能の実装をテストし、クエリに一致する行のリストを生成します。
この機能を`search`という機能に追加し`search`。

### 失敗したテストの作成

これ以上必要ないので、<ruby>算譜<rt>プログラム</rt></ruby>の動作を確認するために使用した*src/lib.rs*と*src/main.rs*から`println!`文を削除しましょう。
次に、*src/lib.rsに*、第11章で行ったように、テスト機能を含む`test`<ruby>役区<rt>モジュール</rt></ruby>を追加します。テスト機能は、`search`機能に必要な動作を指定します。これは、クエリとテキストを検索すると、クエリを含むテキストの行だけが返されます。
リスト12-15はこのテストを示していますが、まだ<ruby>製譜<rt>コンパイル</rt></ruby>されません。

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

このテストは<ruby>文字列<rt>ストリング</rt></ruby>`"duct"`検索します。
探しているテキストは3行で、そのうちの1つだけが`"duct"`を含んでいます。
`search`機能から返される値には、期待される行のみが含まれていると主張します。

このテストを実行することはできません。テストは<ruby>製譜<rt>コンパイル</rt></ruby>されていないため、失敗します。`search`機能はまだ存在しません。
そこで、リスト12-16に示すように、空のベクトルを常に返す`search`機能の定義を追加して、テストを<ruby>製譜<rt>コンパイル</rt></ruby>して実行するのに十分な<ruby>譜面<rt>コード</rt></ruby>を追加します。
空のベクトルが`"safe, fast, productive."`という行を含むベクトルと一致しないため、テストは<ruby>製譜<rt>コンパイル</rt></ruby>して失敗するはず`"safe, fast, productive."`

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    vec![]
}
```

<span class="caption">リスト12-16。テストを<ruby>製譜<rt>コンパイル</rt></ruby>するための<code>search</code>機能を十分に定義する</span>

`search`の型注釈で定義され、`contents`引数と戻り値とともに使用される明示的な有効期間`'a`が必要であることに注目してください。
第10章では、寿命パラメータは、どの引数の寿命が戻り値の存続時間に接続されるかを指定していることを思い出してください。
この場合、返されたベクトルには、（引数`query`ではなく）引数の`contents`スライスを参照する<ruby>文字列<rt>ストリング</rt></ruby>スライスが含まれている必要があることを示し`query`。

言い換えれば、`search`機能によって返されるデータは、データが`contents`引数の`search`機能に渡される限り存続することをRustに伝えます。
これは重要！　
スライス*によって*参照*される*データは、参照を有効にするために有効である必要があります。
<ruby>製譜器<rt>コンパイラー</rt></ruby>が`contents`ではなく`query`<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成していると仮定すると、安全性のチェックが正しく行われません。

寿命の<ruby>注釈<rt>コメント</rt></ruby>を忘れてこの機能を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

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

他の<ruby>演譜<rt>プログラミング</rt></ruby>言語では、型注釈の戻り値に引数を接続する必要はありません。
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

### テストに合格する<ruby>譜面<rt>コード</rt></ruby>を書く

現在、常に空のベクトルを返すので、テストは失敗しています。
それを修正して`search`を実装`search`は、<ruby>算譜<rt>プログラム</rt></ruby>で次の手順を実行する必要があります。

* 内容の各行を繰り返します。
* 行にクエリ<ruby>文字列<rt>ストリング</rt></ruby>が含まれているかどうかを確認します。
* そうであれば、返す値のリストに追加します。
* そうでない場合は、何もしないでください。
* 一致する結果のリストを返します。

各ステップを繰り返し、最初から最後まで繰り返してみましょう。

#### `lines`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`lines`繰り返す

Rustは、リスト12-17に示すように、便利な名前の`lines`である行単位の<ruby>文字列<rt>ストリング</rt></ruby>の繰り返し処理に役立つ<ruby>操作法<rt>メソッド</rt></ruby>を持っています。
これはまだ<ruby>製譜<rt>コンパイル</rt></ruby>されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    for line in contents.lines() {
#        // do something with line
        // ラインで何かする
    }
}
```

<span class="caption">リスト12-17。 <code>contents</code>各行を繰り返す</span>

`lines`<ruby>操作法<rt>メソッド</rt></ruby>は<ruby>反復子<rt>イテレータ</rt></ruby>を返します。
第13章で<ruby>反復子<rt>イテレータ</rt></ruby>について詳しく説明しますが、リスト3-5の<ruby>反復子<rt>イテレータ</rt></ruby>を使用するこの方法では、<ruby>反復子<rt>イテレータ</rt></ruby>を使用して`for`ループを使用して、<ruby>集まり<rt>コレクション</rt></ruby>の各項目に対していくつかの<ruby>譜面<rt>コード</rt></ruby>を実行しました。

#### 各行のクエリの検索

次に、現在の行にクエリ<ruby>文字列<rt>ストリング</rt></ruby>が含まれているかどうかを確認します。
幸いにも、<ruby>文字列<rt>ストリング</rt></ruby>には`contains`という名前の便利な<ruby>操作法<rt>メソッド</rt></ruby>があり、これはためにこれを行います！　
リスト12-18に示すように、`search`機能の`contains`<ruby>操作法<rt>メソッド</rt></ruby>への呼び出しを追加します。
これはまだ<ruby>製譜<rt>コンパイル</rt></ruby>されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    for line in contents.lines() {
        if line.contains(query) {
#            // do something with line
            // ラインで何かする
        }
    }
}
```

<span class="caption">譜面リスト12-18。 <code>query</code>文字列が含まれているかどうかを調べる機能を追加する</span>

#### 照合ラインの保存

また、クエリ<ruby>文字列<rt>ストリング</rt></ruby>を含む行を格納する方法も必要です。
そのためには、`for`ループの前に変更可能なベクトルを作成し、`push`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出してベクトルに`line`を格納することができます。
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
検索機能の<ruby>譜面<rt>コード</rt></ruby>はそれほど悪くはありませんが、<ruby>反復子<rt>イテレータ</rt></ruby>の便利な機能を利用していません。
第13章のこの例に戻ります。ここでは、<ruby>反復子<rt>イテレータ</rt></ruby>を詳細に調査し、<ruby>反復子<rt>イテレータ</rt></ruby>を改善する方法を見ていきます。

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

まだ`for`ループを使って`search`から各行を返し、それを<ruby>印字<rt>プリント</rt></ruby>します。

今や<ruby>算譜<rt>プログラム</rt></ruby>全体がうまくいくはずです！　
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
独自のミニ版の古典的な道具を構築し、<ruby>譜体<rt>アプリケーション</rt></ruby>の構造化方法について多くのことを学びました。
また、ファイルの入出力、寿命、テスト、および<ruby>命令行<rt>コマンドライン</rt></ruby>解析についても少し学びました。

この企画を完成させるために、環境変数を使って作業する方法と標準<ruby>誤り<rt>エラー</rt></ruby>に<ruby>印字<rt>プリント</rt></ruby>する方法を簡単に説明します。どちらも<ruby>命令行<rt>コマンドライン</rt></ruby>算譜を書くときに便利です。
