## 標準出力ではなく標準<ruby>誤り<rt>エラー</rt></ruby>への<ruby>誤り<rt>エラー</rt></ruby>メッセージの書き込み

現時点では、`println!`機能を使用して、すべての出力を<ruby>端末<rt>ターミナル</rt></ruby>に書き出しています。
ほとんどの<ruby>端末<rt>ターミナル</rt></ruby>は、一般情報の*標準出力*（ `stdout`）と<ruby>誤り<rt>エラー</rt></ruby>メッセージの*標準<ruby>誤り<rt>エラー</rt></ruby>*（ `stderr`）の2種類の出力を提供します。
この区別によって、利用者は<ruby>算譜<rt>プログラム</rt></ruby>の正常な出力をファイルに指示することができますが、<ruby>誤り<rt>エラー</rt></ruby>メッセージは画面に出力されます。

`println!`機能は標準出力にしか<ruby>印字<rt>プリント</rt></ruby>できないので、標準<ruby>誤り<rt>エラー</rt></ruby>に<ruby>印字<rt>プリント</rt></ruby>するために別のものを使用する必要があります。

### <ruby>誤り<rt>エラー</rt></ruby>が書き込まれた場所を確認する

まず、`minigrep`で<ruby>印字<rt>プリント</rt></ruby>された内容が現在標準出力に書き込まれている様子を見てみましょう。
標準的な出力ストリームをファイルにリダイレクトし、意図的に<ruby>誤り<rt>エラー</rt></ruby>が発生するようにします。
標準<ruby>誤り<rt>エラー</rt></ruby>ストリームをリダイレクトしないので、標準<ruby>誤り<rt>エラー</rt></ruby>に送信された内容はすべて画面に表示され続けます。

標準出力ストリームをファイルにリダイレクトしても、<ruby>命令行<rt>コマンドライン</rt></ruby>算譜は標準<ruby>誤り<rt>エラー</rt></ruby>ストリームに<ruby>誤り<rt>エラー</rt></ruby>メッセージを送信して、画面に<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されることが予想されます。
<ruby>算譜<rt>プログラム</rt></ruby>は、現在正常に動作していません。<ruby>誤り<rt>エラー</rt></ruby>メッセージの出力をファイルに保存しています。

この動作を示す方法は、標準出力ストリームをリダイレクトする`>`とファイル名*output.txt*で<ruby>算譜<rt>プログラム</rt></ruby>を実行することです。
引数を渡すことはありません。<ruby>誤り<rt>エラー</rt></ruby>が発生するはずです。

```text
$ cargo run > output.txt
```

`>`構文は、標準出力の内容を画面の代わりに*output.txt*に書き込むように<ruby>司得<rt>シェル</rt></ruby>に指示します。
画面に<ruby>印字<rt>プリント</rt></ruby>されることを期待していた<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されなかったので、ファイルに終わったはずです。
これは*output.txtに*含まれています。

```text
Problem parsing arguments: not enough arguments
```

うん、<ruby>誤り<rt>エラー</rt></ruby>メッセージが標準出力に出力されています。
このような<ruby>誤り<rt>エラー</rt></ruby>メッセージが標準<ruby>誤り<rt>エラー</rt></ruby>に出力されると、正常に実行されたデータだけがファイルに格納されます。
それを変更します。

### <ruby>誤り<rt>エラー</rt></ruby>を標準<ruby>誤り<rt>エラー</rt></ruby>に出力する

リスト12-24の<ruby>譜面<rt>コード</rt></ruby>を使用して、<ruby>誤り<rt>エラー</rt></ruby>メッセージの出力方法を変更します。
この章の前半で行ったリファクタリングのおかげで、<ruby>誤り<rt>エラー</rt></ruby>メッセージを出力するすべての<ruby>譜面<rt>コード</rt></ruby>が1つの機能`main`ます。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>は標準<ruby>誤り<rt>エラー</rt></ruby>ストリームに出力する`eprintln!`マクロを提供していますので、代わりに`eprintln!`を使用するように`println!`を呼び出す2つの場所を変更してください。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::new(&args).unwrap_or_else(|err| {
        eprintln!("Problem parsing arguments: {}", err);
        process::exit(1);
    });

    if let Err(e) = minigrep::run(config) {
        eprintln!("Application error: {}", e);

        process::exit(1);
    }
}
```

<span class="caption">リスト12-24。 <code>eprintln€</code>を使って標準出力の代わりに標準<ruby>誤り<rt>エラー</rt></ruby>に<ruby>誤り<rt>エラー</rt></ruby>メッセージを書き込む</span>

`println!`を`eprintln!`変更した後、同じ方法で引数を取らずに<ruby>算譜<rt>プログラム</rt></ruby>を再度実行し、`>`標準出力をリダイレクトし`>`。

```text
$ cargo run > output.txt
Problem parsing arguments: not enough arguments
```

<ruby>誤り<rt>エラー</rt></ruby>onscreenと*output.txtに*は何も含まれていません。これは<ruby>命令行<rt>コマンドライン</rt></ruby>算譜で期待される動作です。

<ruby>誤り<rt>エラー</rt></ruby>を起こさない引き続き標準出力をファイルにリダイレクトする引数を指定して<ruby>算譜<rt>プログラム</rt></ruby>を再実行してみましょう。

```text
$ cargo run to poem.txt > output.txt
```

<ruby>端末<rt>ターミナル</rt></ruby>に何も出力されず、*output.txt*には結果が含まれます。

<span class="filename">ファイル名。output.txt</span>

```text
Are you nobody, too?
How dreary to be somebody!
```

これは、出力の正常化のために標準出力を使用し、適切な場合には<ruby>誤り<rt>エラー</rt></ruby>出力の標準<ruby>誤り<rt>エラー</rt></ruby>を使用していることを示しています。

## 概要

この章では、これまでに学習した主な概念のいくつかを取り上げ、Rustで一般的なI/O操作を実行する方法について説明しました。
<ruby>命令行<rt>コマンドライン</rt></ruby>引数、ファイル、環境変数、および`eprintln!`使用して<ruby>誤り<rt>エラー</rt></ruby>を<ruby>印字<rt>プリント</rt></ruby>すると、<ruby>命令行<rt>コマンドライン</rt></ruby>譜体を作成する準備が整いました。
これまでの章の概念を使用することで、<ruby>譜面<rt>コード</rt></ruby>は適切に整理され、適切なデータ構造に効果的にデータを格納し、<ruby>誤り<rt>エラー</rt></ruby>をうまく処理し、十分にテストされます。

次に、関数型言語の影響を受けたRustのいくつかの機能（<ruby>閉包<rt>クロージャー</rt></ruby>と<ruby>反復子<rt>イテレータ</rt></ruby>）について説明します。
