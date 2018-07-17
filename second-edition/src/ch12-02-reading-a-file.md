## ファイルを読む

次に、`filename`命令行引数で指定された`filename`を読み込む機能を追加します。
最初に、テストするためのサンプルファイルが必要です。`minigrep`が動作することを確認するために使用する最良の種類のファイルは、複数の行にわたるテキストの量が少なく、何度か繰り返される単語です。
リスト12-3にはうまくいくEmily Dickinsonの詩があります。
企画のルート側で*poem.txt*というファイルを作成し、「I'm Nobody！　」という詩を入力します。
あなたは誰？　"

<span class="filename">ファイル名。poem.txt</span>

```text
I'm nobody! Who are you?
Are you nobody, too?
Then there's a pair of us - don't tell!
They'd banish us, you know.

How dreary to be somebody!
How public, like a frog
To tell your name the livelong day
To an admiring bog!
```

<span class="caption">リスト12-3。Emily Dickinsonの詩が良いテストケースを作る</span>

テキストを*そのまま*使用して、*src/main.rs*を編集し、ファイルを開く譜面を追加します（リスト12-4を参照）。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
use std::env;
use std::fs::File;
use std::io::prelude::*;

fn main() {
#     let args: Vec<String> = env::args().collect();
#
#     let query = &args[1];
#     let filename = &args[2];
#
#     println!("Searching for {}", query);
#    // --snip--
    //  --snip--
    println!("In file {}", filename);

    let mut f = File::open(filename).expect("file not found");

    let mut contents = String::new();
    f.read_to_string(&mut contents)
        .expect("something went wrong reading the file");

    println!("With text:\n{}", contents);
}
```

<span class="caption">リスト12-4。2番目の引数で指定されたファイルの内容を読み込む</span>

最初に、標準譜集の関連部分を取り込むためにいくつかの`use`文を追加します。 `std::fs::File`を扱う必要があり、`std::io::prelude::*`はI/O（ファイルI/Oを含む）。
Rustには特定の型と機能を自動的に有効範囲に入れる一般的なプレリュードがあるのと同じように、`std::io`役区にはI/Oを扱う際に必要な一般的な型と機能の序文があります。
黙用のプレリュードとは異なり、`std::io`からprelude用の`use`文を明示的に追加する必要があります。

`main`では、次の3つの文を追加しました。まず、`File::open`機能を呼び出して`filename`変数の値を渡して、ファイルへの変更可能な手綱を取得します。
次に、`contents`という変数を作成し、それを可変で空の`String`ます。
これは、ファイルを読み込んだ後でファイルの内容を保持します。第3に、ファイル手綱`read_to_string`を呼び出し、`contents`変更可能な参照を引数として渡します。

これらの行の後に、ファイルが読み込まれた後に`contents`の値を出力する一時的な`println!`文をもう一度追加しました。算譜がそれまでに動作していることを確認できます。

この譜面を最初の命令行引数として（まだ検索部分を実装していないため）任意の文字列と*poem.txt*ファイルを2番目の引数として実行しましょう。

```text
$ cargo run the poem.txt
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep the poem.txt`
Searching for the
In file poem.txt
With text:
I'm nobody! Who are you?
Are you nobody, too?
Then there's a pair of us - don't tell!
They'd banish us, you know.

How dreary to be somebody!
How public, like a frog
To tell your name the livelong day
To an admiring bog!
```

すばらしいです！　
譜面は、ファイルの内容を読み込んで印字しました。
しかし、この譜面にはいくつかの欠陥があります。
`main`機能には複数の責任があります。一般的に、各機能が1つのアイデアのみを担当する場合、機能はより明確で維持しやすくなります。
もう1つの問題は、誤りを処理しているだけでなく、できることです。
算譜はまだ小さいので、これらの欠陥は大きな問題ではありませんが、算譜が成長するにつれて、それらをきれいに修正することは難しくなります。
算譜を開発するときに早期にリファクタリングを開始することをお勧めします。これは、譜面の量を少なくすることがずっと簡単であるためです。
次にそれを行います。
