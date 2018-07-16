## 命令行引数の受け入れ

さんが使用して新しい企画を作成してみましょう、いつものように、`cargo new`。
あなたのシステムに既にあるかもしれない`grep`道具とそれを区別するために企画`minigrep`を呼びます。

```text
$ cargo new --bin minigrep
     Created binary (application) `minigrep` project
$ cd minigrep
```

最初の作業は、`minigrep` 2つの命令行引数、ファイル名と検索する文字列を受け入れることです。
それは算譜を実行できるようにしたい、ある`cargo run`そうのような、で検索し、検索する文字列、およびファイルへのパス。

```text
$ cargo run searchstring example-filename.txt
```

現在、`cargo new`によって生成された算譜は、与えられた引数を処理することはできません。
[Crates.io](https://crates.io/)既存の譜集の中には、命令行引数を受け入れる算譜の作成に役立つものもありますが、この概念を学んでいるので、この機能を自分で実装しましょう。

### 引数値の読み込み

`minigrep`が渡す命令行引数の値を読むためには、Rustの標準譜集`std::env::args`用意されている機能が必要です。
この機能は、`minigrep`に与えられた命令行引数の*反復子*を返します。
反復子はまだ議論していませんが（第13章で詳しく説明します）、今のところ反復子に関する2つの詳細を知る必要があります。反復子は一連の値を生成し、反復子の`collect`操作法を呼び出すことができます反復子が生成するすべての要素を含む、ベクトルなどの集まりに変換します。

お使いできるように、リスト12-1の譜面を使用し`minigrep`算譜は、渡された任意の命令行引数を読み、そしてベクターに値を収集します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args);
}
```

<span class="caption">譜面リスト12-1。命令行引数をベクトルに集めて印字する</span>

まず、`std::env`役区を`use`文で有効範囲に持ってきて、`args`機能を使用できるようにします。
`std::env::args`機能は、2つのレベルの役区にネストされています。
第7章で説明したように、目的の機能が複数の役区にネストされている場合、親役区を機能ではなく有効範囲にするのが普通です。
そうすることで、`std::env`他の機能を簡単に使うことができます。
また、追加未満曖昧だ`use std::env::args`して、ただで機能を呼び出す`args`ので、`args`簡単に現在の役区で定義されています機能のために誤解される可能性があります。

> ### `args`機能と無効なUnicode
> 
> > いずれかの引数に無効なUnicodeが含まれていると、`std::env::args`がパニックになることに注意してください。
> > 算譜が無効なUnicodeを含む引数を受け入れる必要がある場合は、代わりに`std::env::args_os`使用してください。
> > この機能は、`String`値の代わりに`OsString`値を生成する反復子を返します。
> > `OsString`値は基盤環境ごとに異なり、`String`値よりも`OsString`が複雑であるため、簡単にするために`std::env::args`を使用することにしました。

`main`の最初の行では`env::args`を呼び出し、直ちに`collect`を使用して反復子を生成し、反復子が生成したすべての値を含むベクトルにします。
`collect`機能を使って多くの種類の集まりを作成`collect`ことができるので、`args`の型に明示的に注釈を付けて、文字列のベクトルが必要であることを指定します。
非常にまれルーストに種類に注釈を付ける必要はありませんが、`collect`あなたはしばしばRustが希望集まりの種類を推測することはできないので、注釈を付ける必要がありますか1つの機能です。

最後に、次の虫取りフォーマッタを使用してベクトルを出力し`:?`
。
引き数を指定せずに譜面を実行してから、2つの引数を指定して実行してみましょう。

```text
$ cargo run
--snip--
["target/debug/minigrep"]

$ cargo run needle haystack
--snip--
["target/debug/minigrep", "needle", "haystack"]
```

ベクトルの最初の値は`"target/debug/minigrep"`。これは二進譜の名前です。
これはCの引数リストの振る舞いと一致し、算譜は実行時に呼び出された名前を使用します。
メッセージに印字したり、算譜を呼び出すために使用された命令行別名に基づいて算譜の動作を変更したい場合は、算譜名にアクセスすることが便利なことがよくあります。
しかし、この章では、それを無視して必要な2つの引数だけを保存します。

### 変数への引数値の保存

引数ベクトルの値を表示すると、算譜は命令行引数として指定された値にアクセスできます。
今度は、2つの引数の値を変数に保存して、残りの値を使用する必要があります。
リスト12-2に示します。

<span class="filename">ファイル名。src / main.rs</span>

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

ベクトルを出力したときに見たように、算譜の名前は`args[0]`でベクトルの最初の値をとります。したがって、添字`1`から始まります。
最初の引数`minigrep`は検索する文字列ですから、最初の引数への参照を変数`query`。
2番目の引数はファイル名になるので、2番目の引数への参照を変数`filename`。

これらの変数の値を一時的に表示して、譜面が意図したとおりに機能していることを証明します。
`test`と`sample.txt`という引数を使ってこの算譜をもう一度実行してみましょう。

```text
$ cargo run test sample.txt
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep test sample.txt`
Searching for test
In file sample.txt
```

偉大な、算譜が動作しています！　
必要な引数の値は正しい変数に保存されています。
後で、ユーザーが引数を指定しないなど、潜在的な誤りのある状況に対処するための誤り処理を追加します。
今のところ、その状況を無視し、ファイル読み取り機能を追加する作業を行います。
