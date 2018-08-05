## <ruby>命令行<rt>コマンドライン</rt></ruby>引数の受け入れ

さんが使用して新しい企画を作成してみましょう、いつものように、`cargo new`。
システムに既にあるかもしれない`grep`道具とそれを区別するために企画`minigrep`を呼びます。

```text
$ cargo new --bin minigrep
     Created binary (application) `minigrep` project
$ cd minigrep
```

最初の作業は、`minigrep` 2つの<ruby>命令行<rt>コマンドライン</rt></ruby>引数、ファイル名と検索する<ruby>文字列<rt>ストリング</rt></ruby>を受け入れることです。
それは<ruby>算譜<rt>プログラム</rt></ruby>を実行できるようにしたい、ある`cargo run`そうのような、で検索し、検索する<ruby>文字列<rt>ストリング</rt></ruby>、およびファイルへのパス。

```text
$ cargo run searchstring example-filename.txt
```

現在、`cargo new`によって生成された<ruby>算譜<rt>プログラム</rt></ruby>は、与えられた引数を処理することはできません。
[Crates.io](https://crates.io/)既存の<ruby>譜集<rt>ライブラリー</rt></ruby>の中には、<ruby>命令行<rt>コマンドライン</rt></ruby>引数を受け入れる<ruby>算譜<rt>プログラム</rt></ruby>の作成に役立つものもありますが、この概念を学んでいるので、この機能を自分で実装しましょう。

### 引数値の読み込み

`minigrep`が渡す<ruby>命令行<rt>コマンドライン</rt></ruby>引数の値を読むためには、Rustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>`std::env::args`用意されている機能が必要です。
この機能は、`minigrep`に与えられた<ruby>命令行<rt>コマンドライン</rt></ruby>引数の*<ruby>反復子<rt>イテレータ</rt></ruby>*を返します。
<ruby>反復子<rt>イテレータ</rt></ruby>はまだ議論していませんが（第13章で詳しく説明します）、今のところ<ruby>反復子<rt>イテレータ</rt></ruby>に関する2つの詳細を知る必要があります。<ruby>反復子<rt>イテレータ</rt></ruby>は一連の値を生成し、<ruby>反復子<rt>イテレータ</rt></ruby>の`collect`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができます<ruby>反復子<rt>イテレータ</rt></ruby>が生成するすべての要素を含む、ベクトルなどの<ruby>集まり<rt>コレクション</rt></ruby>に変換します。

お使いできるように、リスト12-1の<ruby>譜面<rt>コード</rt></ruby>を使用し`minigrep`<ruby>算譜<rt>プログラム</rt></ruby>は、渡された任意の<ruby>命令行<rt>コマンドライン</rt></ruby>引数を読み、そしてベクターに値を収集します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args);
}
```

<span class="caption">譜面リスト12-1。<ruby>命令行<rt>コマンドライン</rt></ruby>引数をベクトルに集めて<ruby>印字<rt>プリント</rt></ruby>する</span>

まず、`std::env`<ruby>役区<rt>モジュール</rt></ruby>を`use`文で<ruby>有効範囲<rt>スコープ</rt></ruby>に持ってきて、`args`機能を使用できるようにします。
`std::env::args`機能は、2つの側の<ruby>役区<rt>モジュール</rt></ruby>にネストされています。
第7章で説明したように、目的の機能が複数の<ruby>役区<rt>モジュール</rt></ruby>にネストされている場合、親<ruby>役区<rt>モジュール</rt></ruby>を機能ではなく<ruby>有効範囲<rt>スコープ</rt></ruby>にするのが普通です。
そうすることで、`std::env`他の機能を簡単に使うことができます。
また、追加未満曖昧だ`use std::env::args`して、ただで機能を呼び出す`args`ので、`args`簡単に現在の<ruby>役区<rt>モジュール</rt></ruby>で定義されています機能のために誤解される可能性があります。

> ### `args`機能と無効なUnicode
> 
> > いずれかの引数に無効なUnicodeが含まれていると、`std::env::args`がパニックになることに注意してください。
> > <ruby>算譜<rt>プログラム</rt></ruby>が無効なUnicodeを含む引数を受け入れる必要がある場合は、代わりに`std::env::args_os`使用してください。
> > この機能は、`String`値の代わりに`OsString`値を生成する<ruby>反復子<rt>イテレータ</rt></ruby>を返します。
> > `OsString`値は<ruby>基盤環境<rt>プラットフォーム</rt></ruby>ごとに異なり、`String`値よりも`OsString`が複雑であるため、簡単にするために`std::env::args`を使用することにしました。

`main`の最初の行では`env::args`を呼び出し、直ちに`collect`を使用して<ruby>反復子<rt>イテレータ</rt></ruby>を生成し、<ruby>反復子<rt>イテレータ</rt></ruby>が生成したすべての値を含むベクトルにします。
`collect`機能を使って多くの種類の<ruby>集まり<rt>コレクション</rt></ruby>を作成`collect`ことができるので、`args`の型に明示的に<ruby>注釈<rt>コメント</rt></ruby>を付けて、<ruby>文字列<rt>ストリング</rt></ruby>のベクトルが必要であることを指定します。
非常にまれルーストに種類に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありませんが、`collect`しばしばRustが希望<ruby>集まり<rt>コレクション</rt></ruby>の種類を推測することはできないので、<ruby>注釈<rt>コメント</rt></ruby>を付ける必要がありますか1つの機能です。

最後に、次の<ruby>虫取り<rt>デバッグ</rt></ruby>フォーマッタを使用してベクトルを出力し`:?`
。
引き数を指定せずに<ruby>譜面<rt>コード</rt></ruby>を実行してから、2つの引数を指定して実行してみましょう。

```text
$ cargo run
--snip--
["target/debug/minigrep"]

$ cargo run needle haystack
--snip--
["target/debug/minigrep", "needle", "haystack"]
```

ベクトルの最初の値は`"target/debug/minigrep"`。これは<ruby>二進譜<rt>バイナリ</rt></ruby>の名前です。
これはCの引数リストの振る舞いと一致し、<ruby>算譜<rt>プログラム</rt></ruby>は実行時に呼び出された名前を使用します。
メッセージに<ruby>印字<rt>プリント</rt></ruby>したり、<ruby>算譜<rt>プログラム</rt></ruby>を呼び出すために使用された<ruby>命令行<rt>コマンドライン</rt></ruby>別名に基づいて<ruby>算譜<rt>プログラム</rt></ruby>の動作を変更したい場合は、<ruby>算譜<rt>プログラム</rt></ruby>名にアクセスすることが便利なことがよくあります。
しかし、この章では、それを無視して必要な2つの引数だけを保存します。

### 変数への引数値の保存

引数ベクトルの値を表示すると、<ruby>算譜<rt>プログラム</rt></ruby>は<ruby>命令行<rt>コマンドライン</rt></ruby>引数として指定された値にアクセスできます。
今度は、2つの引数の値を変数に保存して、残りの値を使用する必要があります。
リスト12-2に示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    let query = &args[1];
    let filename = &args[2];

    println!("Searching for {}", query);
    println!("In file {}", filename);
}
```

<span class="caption">リスト12-2。クエリ引数とファイル名引数を保持する変数の作成</span>

ベクトルを出力したときに見たように、<ruby>算譜<rt>プログラム</rt></ruby>の名前は`args[0]`でベクトルの最初の値をとります。したがって、<ruby>添字<rt>インデックス</rt></ruby>`1`から始まります。
最初の引数`minigrep`は検索する<ruby>文字列<rt>ストリング</rt></ruby>ですから、最初の引数への参照を変数`query`。
2番目の引数はファイル名になるので、2番目の引数への参照を変数`filename`。

これらの変数の値を一時的に表示して、<ruby>譜面<rt>コード</rt></ruby>が意図したとおりに機能していることを証明します。
`test`と`sample.txt`という引数を使ってこの<ruby>算譜<rt>プログラム</rt></ruby>をもう一度実行してみましょう。

```text
$ cargo run test sample.txt
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep test sample.txt`
Searching for test
In file sample.txt
```

偉大な、<ruby>算譜<rt>プログラム</rt></ruby>が動作しています！　
必要な引数の値は正しい変数に保存されています。
後で、利用者が引数を指定しないなど、潜在的な<ruby>誤り<rt>エラー</rt></ruby>のある状況に対処するための<ruby>誤り<rt>エラー</rt></ruby>処理を追加します。
今のところ、その状況を無視し、ファイル読み取り機能を追加する作業を行います。
