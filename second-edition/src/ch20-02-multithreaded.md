## 単一走脈<ruby>提供器<rt>サーバー</rt></ruby>を<ruby>多脈処理<rt>マルチスレッド</rt></ruby>提供器にする

今、<ruby>提供器<rt>サーバー</rt></ruby>は各要求を順番に処理します。つまり、最初の処理が完了するまで2番目の接続を処理しません。
<ruby>提供器<rt>サーバー</rt></ruby>がますます多くのリクエストを受信した場合、このシリアル実行は、それほど最適ではありません。
<ruby>提供器<rt>サーバー</rt></ruby>が処理に時間がかかる要求を受信した場合、新しい要求を迅速に処理できる場合でも、後続の要求は長い要求が完了するまで待機する必要があります。
これを修正する必要がありますが、最初に実際の問題を見ていきます。

### 現在の<ruby>提供器<rt>サーバー</rt></ruby>実装で低速要求をシミュレートする

処理の遅いリクエストが、現在の<ruby>提供器<rt>サーバー</rt></ruby>実装に対する他のリクエストにどのように影響するかを見ていきます。
リスト20-10は、*/* sleptへのリクエストの処理をシミュレートした低速レスポンスで実装しています。これにより、<ruby>提供器<rt>サーバー</rt></ruby>は応答する前に5秒間スリープします。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::time::Duration;
# use std::io::prelude::*;
# use std::net::TcpStream;
# use std::fs::File;
#// --snip--
//  --snip--

fn handle_connection(mut stream: TcpStream) {
#     let mut buffer = [0; 512];
#     stream.read(&mut buffer).unwrap();
#    // --snip--
    //  --snip--

    let get = b"GET/HTTP/1.1\r\n";
    let sleep = b"GET /sleep HTTP/1.1\r\n";

    let (status_line, filename) = if buffer.starts_with(get) {
        ("HTTP/1.1 200 OK\r\n\r\n", "hello.html")
    } else if buffer.starts_with(sleep) {
        thread::sleep(Duration::from_secs(5));
        ("HTTP/1.1 200 OK\r\n\r\n", "hello.html")
    } else {
        ("HTTP/1.1 404 NOT FOUND\r\n\r\n", "404.html")
    };

#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト20-10。5秒間の認識と<em>スリープ</em>と<em>スリープ</em>による低速要求のシミュレーション</span>

この<ruby>譜面<rt>コード</rt></ruby>はちょっと面倒ですが、シミュレーション目的で十分です。
<ruby>提供器<rt>サーバー</rt></ruby>が認識するデータを持つ2番目のリクエスト`sleep`を作成しました。
`if`<ruby>段落<rt>ブロック</rt></ruby>の後に`else if`を追加して、*/ sleep*へのリクエストを確認しました。
その要求を受け取ると、<ruby>提供器<rt>サーバー</rt></ruby>は5秒間スリープしてからHTMLページが正常に表示されます。

<ruby>提供器<rt>サーバー</rt></ruby>はどれほど基本型なのかを見ることができます。実際の<ruby>譜集<rt>ライブラリー</rt></ruby>は、あまり冗長ではない複数のリクエストの認識を処理します！　

使用して<ruby>提供器<rt>サーバー</rt></ruby>を起動し`cargo run`。
次に、2つのブラウザ窓を開き*ます*.1つは*http://127.0.0.1:7878/*、もう1つは*http://127.0.0.1:7878/sleep*です。
以前と同じように*/* URIを数回入力すると、すぐに応答することがわかります。
*/スリープ*してから読み込み*/を*入力した場合しかし、まで待機*/*ことがわかります`sleep`読み込みする前にその完全な5秒間眠っています。

遅い要求の後ろにもっと多くの要求が戻ってくることを避けるためにWeb<ruby>提供器<rt>サーバー</rt></ruby>の仕組みを変更する方法はいくつかあります。
実装するのは<ruby>走脈<rt>スレッド</rt></ruby>貯留庫です。

### <ruby>走脈<rt>スレッド</rt></ruby>貯留庫によるスループットの向上

*<ruby>走脈<rt>スレッド</rt></ruby>貯留庫*は、待機中で仕事を処理する準備ができている、生成された<ruby>走脈<rt>スレッド</rt></ruby>のグループです。
<ruby>算譜<rt>プログラム</rt></ruby>は新しい仕事を受け取ると、貯留庫内の<ruby>走脈<rt>スレッド</rt></ruby>の1つを仕事に割り当て、その<ruby>走脈<rt>スレッド</rt></ruby>がその仕事を処理します。
貯留庫内の残りの<ruby>走脈<rt>スレッド</rt></ruby>は、最初の<ruby>走脈<rt>スレッド</rt></ruby>が処理中に入ってくる他の仕事を処理するために使用できます。
最初の<ruby>走脈<rt>スレッド</rt></ruby>がその仕事の処理を完了すると、<ruby>走脈<rt>スレッド</rt></ruby>はアイドル状態の<ruby>走脈<rt>スレッド</rt></ruby>の貯留庫に戻され、新しい仕事を処理できる状態になります。
<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を使用すると、接続を同時に処理できるため、<ruby>提供器<rt>サーバー</rt></ruby>のスループットが向上します。

<ruby>役務<rt>サービス</rt></ruby>拒否（DoS）攻撃から私たちを守るために、貯留庫内の<ruby>走脈<rt>スレッド</rt></ruby>の数を少数に制限します。
<ruby>算譜<rt>プログラム</rt></ruby>が入ってくるごとにリクエストごとに新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成した場合、<ruby>提供器<rt>サーバー</rt></ruby>に1000万回のリクエストを行う人は、<ruby>提供器<rt>サーバー</rt></ruby>のすべての資源を使い切り、要求の処理を中断することによって混乱を招く可能性があります。

無限の<ruby>走脈<rt>スレッド</rt></ruby>を生成するのではなく、貯留庫内で一定数の<ruby>走脈<rt>スレッド</rt></ruby>を待機させます。
リクエストが入ると、リクエストが貯留庫に送られて処理されます。
貯留庫は着信要求のキューを維持します。
貯留庫内の各<ruby>走脈<rt>スレッド</rt></ruby>は、このキューからの要求をポップアウトし、要求を処理してから、キューに別の要求を要求します。
この設計では、`N`要求を同時に処理することができます。ここで、`N`は<ruby>走脈<rt>スレッド</rt></ruby>の数です。
各<ruby>走脈<rt>スレッド</rt></ruby>が長時間実行している要求に応答していれば、それ以降の要求はキューにバックアップされますが、その時点までに処理できる長時間実行される要求の数が増えました。

この手法は、Web<ruby>提供器<rt>サーバー</rt></ruby>のスループットを改善する多くの方法の1つに過ぎません。
探索できるその他の<ruby>選択肢<rt>オプション</rt></ruby>は、フォーク/結合模型と単一<ruby>走脈<rt>スレッド</rt></ruby>非同期I/O模型です。
この話題に興味がある場合は、他のソリューションの詳細を読んで、Rustでそれらを実装しようとすることができます。
Rustのような低水準の言語では、これらの<ruby>選択肢<rt>オプション</rt></ruby>はすべて可能です。

<ruby>走脈<rt>スレッド</rt></ruby>貯留庫の実装を開始する前に、貯留庫の使用方法について説明しましょう。
<ruby>譜面<rt>コード</rt></ruby>を設計しようとするときは、最初にクライアント<ruby>接点<rt>インターフェース</rt></ruby>を記述することで、設計を手助けすることができます。
<ruby>譜面<rt>コード</rt></ruby>のAPIを記述して、それを呼び出したい方法で構造化します。
機能を実装して<ruby>公開<rt>パブリック</rt></ruby>APIを設計するのではなく、その構造内の機能を実装します。

第12章の企画でテスト駆動型開発を使用したのと同様に、ここでは<ruby>製譜器<rt>コンパイラー</rt></ruby>主導の開発を使用します。
望む機能を呼び出す<ruby>譜面<rt>コード</rt></ruby>を書いてから、<ruby>製譜器<rt>コンパイラー</rt></ruby>からの<ruby>誤り<rt>エラー</rt></ruby>を見て、<ruby>譜面<rt>コード</rt></ruby>を動作させるために次に変更すべきものを決定します。

#### リクエストごとに<ruby>走脈<rt>スレッド</rt></ruby>を生成できる場合の<ruby>譜面<rt>コード</rt></ruby>構造

まず、すべての接続に対して新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成した場合の<ruby>譜面<rt>コード</rt></ruby>の外観を調べてみましょう。
前述したように、<ruby>走脈<rt>スレッド</rt></ruby>の数に制限はありませんが、これは最終的な計画ではありませんが、これは出発点です。
リスト20-11は、`for`ループ内の各ストリームを処理するための新しい<ruby>走脈<rt>スレッド</rt></ruby>を生成するための、`main`への変更を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,no_run
# use std::thread;
# use std::io::prelude::*;
# use std::net::TcpListener;
# use std::net::TcpStream;
#
fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        thread::spawn(|| {
            handle_connection(stream);
        });
    }
}
# fn handle_connection(mut stream: TcpStream) {}
```

<span class="caption">リスト20-11。ストリームごとに新しい<ruby>走脈<rt>スレッド</rt></ruby>を生成する</span>

第16章で学んだように、`thread::spawn`は新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成し、新しい<ruby>走脈<rt>スレッド</rt></ruby>の<ruby>閉包<rt>クロージャー</rt></ruby>で<ruby>譜面<rt>コード</rt></ruby>を実行します。
お使いのブラウザでこの<ruby>譜面<rt>コード</rt></ruby>と読み込み*/スリープを*実行すると*、/* 2以上のブラウザのタブで、確かに*/*へのリクエストが終了するのを*/スリープ*待つ必要がないことがわかります。
しかし、言及したように、これは最終的にシステムを圧倒するでしょう。なぜなら何の制限もなく新しい<ruby>走脈<rt>スレッド</rt></ruby>を作るからです。

#### 有限数の<ruby>走脈<rt>スレッド</rt></ruby>のための類似の<ruby>接点<rt>インターフェース</rt></ruby>の作成

<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を<ruby>走脈<rt>スレッド</rt></ruby>貯留庫に切り替えるために、APIを使用する<ruby>譜面<rt>コード</rt></ruby>を大幅に変更する必要はありません。
リスト20-12は、`thread::spawn`代わりに使用したい`ThreadPool`構造体の仮説的<ruby>接点<rt>インターフェース</rt></ruby>を示してい`thread::spawn`。

<span class="filename">ファイル名。src/main.rs</span>

```rust,no_run
# use std::thread;
# use std::io::prelude::*;
# use std::net::TcpListener;
# use std::net::TcpStream;
# struct ThreadPool;
# impl ThreadPool {
#    fn new(size: u32) -> ThreadPool { ThreadPool }
#    fn execute<F>(&self, f: F)
#        where F: FnOnce() + Send + 'static {}
# }
#
fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();
    let pool = ThreadPool::new(4);

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        pool.execute(|| {
            handle_connection(stream);
        });
    }
}
# fn handle_connection(mut stream: TcpStream) {}
```

<span class="caption">リスト20-12。理想的な<code>ThreadPool</code>接点</span>

`ThreadPool::new`を使用して、設定可能な<ruby>走脈<rt>スレッド</rt></ruby>数（この場合は4）の新しい<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を作成します。
次に、`for`ループで`pool.execute`は、貯留庫が各ストリームに対して実行する<ruby>閉包<rt>クロージャー</rt></ruby>をとる点で、`thread::spawn`と同様の<ruby>接点<rt>インターフェース</rt></ruby>があります。
`pool.execute`を実装する必要があり`pool.execute`ので、<ruby>閉包<rt>クロージャー</rt></ruby>を実行して貯留庫の<ruby>走脈<rt>スレッド</rt></ruby>に渡して実行します。
この<ruby>譜面<rt>コード</rt></ruby>はまだ<ruby>製譜<rt>コンパイル</rt></ruby>されませんが、<ruby>製譜器<rt>コンパイラー</rt></ruby>がどのように修正するかを案内することができます。

#### <ruby>製譜器<rt>コンパイラー</rt></ruby>駆動型開発を使用した`ThreadPool`構造体の構築

*<ruby>譜面<rt>コード</rt></ruby>*リスト20-12を*src/main.rs*に変更してから、`cargo check`<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りを使って開発を進めましょう。
ここで最初に犯す<ruby>誤り<rt>エラー</rt></ruby>です。

```text
$ cargo check
   Compiling hello v0.1.0 (file:///projects/hello)
error[E0433]: failed to resolve. Use of undeclared type or module `ThreadPool`
  --> src\main.rs:10:16
   |
10 |     let pool = ThreadPool::new(4);
   |                ^^^^^^^^^^^^^^^ Use of undeclared type or module
   `ThreadPool`

error: aborting due to previous error
```

すばらしいです！　
この<ruby>誤り<rt>エラー</rt></ruby>は、`ThreadPool`型または<ruby>役区<rt>モジュール</rt></ruby>が必要であることを示しているので、ここで構築します。
`ThreadPool`実装は、Web<ruby>提供器<rt>サーバー</rt></ruby>がやっている仕事の種類から独立しています。
だから、`hello`<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱から譜集<ruby>通い箱<rt>クレート</rt></ruby>に切り替えて、`ThreadPool`実装を保持しましょう。
<ruby>譜集<rt>ライブラリー</rt></ruby>・ボックスに変更した後は、Webリクエストを処理するだけでなく、<ruby>走脈<rt>スレッド</rt></ruby>・貯留庫を使用して作業を行うために別の<ruby>走脈<rt>スレッド</rt></ruby>・貯留庫・<ruby>譜集<rt>ライブラリー</rt></ruby>を使用することもできます。

次のものを含む*src/lib.rs*を作成します。これは、今のところできる`ThreadPool`構造体の最も単純な定義です。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct ThreadPool;
```

次に、新しいディレクトリ*src/binを*作成し、*src/main.rs*をルートとする<ruby>二進譜<rt>バイナリ</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>を*src/bin/main.rsに移動し*ます。
そうすることで、<ruby>譜集<rt>ライブラリー</rt></ruby>は*hello*ディレクトリの一次<ruby>通い箱<rt>クレート</rt></ruby>になります。
`cargo run`を使用して*src/bin/main.rs*内の<ruby>二進譜<rt>バイナリ</rt></ruby>を実行することはでき`cargo run`。
*main.rs*ファイルを移動した後、*src/bin/main.rsの*先頭に次の<ruby>譜面<rt>コード</rt></ruby>を追加して、<ruby>譜集<rt>ライブラリー</rt></ruby>*crateを*入れて`ThreadPool`を<ruby>有効範囲<rt>スコープ</rt></ruby>にします。

<span class="filename">ファイル名。src/bin/main.rs</span>

```rust,ignore
extern crate hello;
use hello::ThreadPool;
```

この<ruby>譜面<rt>コード</rt></ruby>はまだ機能しませんが、もう一度チェックして次の<ruby>誤り<rt>エラー</rt></ruby>を解決しましょう。

```text
$ cargo check
   Compiling hello v0.1.0 (file:///projects/hello)
error[E0599]: no function or associated item named `new` found for type
`hello::ThreadPool` in the current scope
 --> src/bin/main.rs:13:16
   |
13 |     let pool = ThreadPool::new(4);
   |                ^^^^^^^^^^^^^^^ function or associated item not found in
   `hello::ThreadPool`
```

この<ruby>誤り<rt>エラー</rt></ruby>は、次に`ThreadPool` `new`という名前の関連する機能を作成する必要があることを示します。
また、ことを知って`new`ニーズが受け入れることができる一つのパラメータ持つように`4`引数として返す必要がありますし、`ThreadPool`<ruby>実例<rt>インスタンス</rt></ruby>を。
これらの<ruby>特性<rt>トレイト</rt></ruby>を持つ最も単純な`new`機能を実装しましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct ThreadPool;

impl ThreadPool {
    pub fn new(size: usize) -> ThreadPool {
        ThreadPool
    }
}
```

負の数の<ruby>走脈<rt>スレッド</rt></ruby>が意味をなさないことがわかっているので、`usize`を`size`パラメータの型として選択し`usize`。
また、何である<ruby>走脈<rt>スレッド</rt></ruby>の<ruby>集まり<rt>コレクション</rt></ruby>内の要素の数として、この4を使用します知っている`usize`第3章の「整数型」の項で説明したように、型がためです。

<ruby>譜面<rt>コード</rt></ruby>をもう一度見てみましょう。

```text
$ cargo check
   Compiling hello v0.1.0 (file:///projects/hello)
warning: unused variable: `size`
 --> src/lib.rs:4:16
  |
4 |     pub fn new(size: usize) -> ThreadPool {
  |                ^^^^
  |
  = note: #[warn(unused_variables)] on by default
  = note: to avoid this warning, consider using `_size` instead

error[E0599]: no method named `execute` found for type `hello::ThreadPool` in the current scope
  --> src/bin/main.rs:18:14
   |
18 |         pool.execute(|| {
   |              ^^^^^^^
```

今警告と<ruby>誤り<rt>エラー</rt></ruby>を得ます。
警告を無視して、`ThreadPool` `execute`<ruby>操作法<rt>メソッド</rt></ruby>がないために<ruby>誤り<rt>エラー</rt></ruby>が発生します。
「有限数の<ruby>走脈<rt>スレッド</rt></ruby>のための同様の<ruby>接点<rt>インターフェース</rt></ruby>の作成」の章から、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫は`thread::spawn`似た<ruby>接点<rt>インターフェース</rt></ruby>を持つべきだと思いました。
さらに、`execute`機能を実装して、与えられた<ruby>閉包<rt>クロージャー</rt></ruby>を受け取り、`execute`貯留庫内のアイドル状態の<ruby>走脈<rt>スレッド</rt></ruby>に渡します。

`ThreadPool`の`execute`<ruby>操作法<rt>メソッド</rt></ruby>を定義して、<ruby>閉包<rt>クロージャー</rt></ruby>をパラメータとして使用します。
第13章の「汎用パラメータと`Fn`<ruby>特性<rt>トレイト</rt></ruby>を使用した<ruby>閉包<rt>クロージャー</rt></ruby>の格納」の章から、`Fn`、 `FnMut`、および`FnOnce` 3つの異なる<ruby>特性<rt>トレイト</rt></ruby>を持つパラメータとして<ruby>閉包<rt>クロージャー</rt></ruby>を使用できることを`FnOnce`。
ここで使用する<ruby>閉包<rt>クロージャー</rt></ruby>の種類を決定する必要があります。
標準の<ruby>譜集<rt>ライブラリー</rt></ruby>`thread::spawn`実装に似た何かをすることになることを知っているので、`thread::spawn`型注釈がそのパラメータにどのような縛りを持つかを見ることができます。
開発資料集は私たちに以下を示します。

```rust,ignore
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
    where
        F: FnOnce() -> T + Send + 'static,
        T: Send + 'static
```

`F`型パラメータは、ここで考慮するパラメータです。
`T`型パラメータは戻り値に関連しており、それに関心がない。
`spawn`が`F`束縛された<ruby>特性<rt>トレイト</rt></ruby>として`FnOnce`を使用`spawn`ことを見ることができます。
最終的に取得引数渡しますので、これは、同様に欲しいものはおそらくあり`execute`する`spawn`。
`FnOnce`は、リクエストを実行する<ruby>走脈<rt>スレッド</rt></ruby>が`FnOnce`の`Once`に一致するリクエストの<ruby>閉包<rt>クロージャー</rt></ruby>を1回だけ実行するため、`FnOnce`が使用したい<ruby>特性<rt>トレイト</rt></ruby>であることをさらに確信できます。

`F`型パラメータもトレイト結合した`Send`され、結合寿命`'static`状況において有用である、。必要`Send`別の<ruby>走脈<rt>スレッド</rt></ruby>からの<ruby>閉包<rt>クロージャー</rt></ruby>を転送する`'static`どのくらいの<ruby>走脈<rt>スレッド</rt></ruby>がするかわからないので、実行します。
`ThreadPool` `execute`<ruby>操作法<rt>メソッド</rt></ruby>を作成して、これらの縛りで`F`型の汎用パラメータを取得しましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct ThreadPool;
impl ThreadPool {
#    // --snip--
    //  --snip--

    pub fn execute<F>(&self, f: F)
        where
            F: FnOnce() + Send + 'static
    {

    }
}
```

まだ使用して`()`した後`FnOnce`このため`FnOnce`パラメータを取らず、値を返さない<ruby>閉包<rt>クロージャー</rt></ruby>を表します。
機能の定義と同じように、戻り値の型は型注釈から省略することができますが、パラメータがなくてもかっこが必要です。

繰り返しますが、これは`execute`<ruby>操作法<rt>メソッド</rt></ruby>の最も単純な実装です。何もしませんが、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>するだけです。
それをもう一度見てみましょう。

```text
$ cargo check
   Compiling hello v0.1.0 (file:///projects/hello)
warning: unused variable: `size`
 --> src/lib.rs:4:16
  |
4 |     pub fn new(size: usize) -> ThreadPool {
  |                ^^^^
  |
  = note: #[warn(unused_variables)] on by default
  = note: to avoid this warning, consider using `_size` instead

warning: unused variable: `f`
 --> src/lib.rs:8:30
  |
8 |     pub fn execute<F>(&self, f: F)
  |                              ^
  |
  = note: to avoid this warning, consider using `_f` instead
```

警告のみを受け取ります。つまり、<ruby>製譜<rt>コンパイル</rt></ruby>されています！　
しかし、`cargo run`してブラウザでリクエストを行うと、章の冒頭で見たブラウザに<ruby>誤り<rt>エラー</rt></ruby>が表示されることに注意してください。
<ruby>譜集<rt>ライブラリー</rt></ruby>は実際には<ruby>閉包<rt>クロージャー</rt></ruby>を渡して`execute`まだ`execute`呼びかけていません！　

> > 注。HaskellやRustのような厳密な<ruby>製譜器<rt>コンパイラー</rt></ruby>を使用している言語については、「<ruby>譜面<rt>コード</rt></ruby>が<ruby>製譜<rt>コンパイル</rt></ruby>されても機能する」と聞くかもしれませんが、この言葉は普遍的ではありません。
> > 企画は<ruby>製譜<rt>コンパイル</rt></ruby>されますが、絶対に何もしません！　
> > 本当の、完全な企画を構築していたら、<ruby>譜面<rt>コード</rt></ruby>が<ruby>製譜<rt>コンパイル</rt></ruby>され*、*望む振る舞いを持っているかどうかをチェックする単体テストを書くのはいい時期です。

#### `new`<ruby>走脈<rt>スレッド</rt></ruby>の数の検証

`new`パラメータと`execute`パラメータを何もしていないので、警告を受け取り続けます。
望むふるまいでこれらの機能の本体を実装しましょう。
まず、`new`考えましょう。
以前は、負の数の<ruby>走脈<rt>スレッド</rt></ruby>を持つ貯留庫は意味をなさないため、`size`パラメータには符号なしの型を選択しました。
しかし、<ruby>走脈<rt>スレッド</rt></ruby>がゼロの貯留庫も意味をなさないが、ゼロは完全に有効な`usize`。
リスト20-13に示すように、`ThreadPool`<ruby>実例<rt>インスタンス</rt></ruby>を返す前に`size`がゼロより大きいかどうかを確認する<ruby>譜面<rt>コード</rt></ruby>を追加し、`assert!`マクロを使用してゼロを受け取った場合に<ruby>算譜<rt>プログラム</rt></ruby>パニックを起こします。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct ThreadPool;
impl ThreadPool {
#//    /// Create a new ThreadPool.
    /// 新しいThreadPoolを作成します。
    ///
#//    /// The size is the number of threads in the pool.
    /// サイズは、貯留庫内の<ruby>走脈<rt>スレッド</rt></ruby>の数です。
    ///
#//    /// # Panics
    ///  ＃パニック
    ///
#//    /// The `new` function will panic if the size is zero.
    /// サイズがゼロの場合、`new`機能はパニックに陥ります。
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        ThreadPool
    }

#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト20-13。 <code>size</code>が0の場合、 <code>ThreadPool::new</code>をパニックに実装する</span>

`ThreadPool`開発資料集<ruby>注釈<rt>コメント</rt></ruby>付きの開発資料をいくつか追加しました。
第14章で説明したように実行してみてください、私達は私達の機能がパニックすることができている状況を呼び出し章を追加することによって、良い開発資料の慣行に従っていることに注意してください`cargo doc --open`し、クリック`ThreadPool`のため何を生成した開発資料を参照する構造体を`new`外観を好き！　

ここで行ったように`assert!`マクロを追加する代わりに、リスト12-9のI/O企画で`Config::new`と同じように`new` `Result`返すことができます。
しかし、この場合、<ruby>走脈<rt>スレッド</rt></ruby>なしで<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を作成しようとすると、回復不可能な<ruby>誤り<rt>エラー</rt></ruby>になるはずです。
野心的だと感じたら、両方の版を比較するために、次の型注釈で`new`版を作成してみてください。

```rust,ignore
pub fn new(size: usize) -> Result<ThreadPool, PoolCreationError> {
```

#### <ruby>走脈<rt>スレッド</rt></ruby>を格納する領域の作成

貯留庫に格納する<ruby>走脈<rt>スレッド</rt></ruby>の有効な数がわかっているので、それらの<ruby>走脈<rt>スレッド</rt></ruby>を作成し、`ThreadPool`構造体に格納してから返すことができます。
しかし、<ruby>走脈<rt>スレッド</rt></ruby>を「保存」するにはどうすればよいでしょうか？　
`thread::spawn`型注釈をもう一度見てみましょう。

```rust,ignore
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
    where
        F: FnOnce() -> T + Send + 'static,
        T: Send + 'static
```

`spawn`機能は`JoinHandle<T>`返します。ここで、`T`は<ruby>閉包<rt>クロージャー</rt></ruby>が返す型です。
`JoinHandle`も試して`JoinHandle`て、何が起こるか見てみましょう。
場合、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫に渡す<ruby>閉包<rt>クロージャー</rt></ruby>は接続を処理し、何も返さないので、`T`はユニット型`()`ます。

<ruby>譜面<rt>コード</rt></ruby>リスト20-14の<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されますが、まだ<ruby>走脈<rt>スレッド</rt></ruby>は作成されません。
`thread::JoinHandle<()>`<ruby>実例<rt>インスタンス</rt></ruby>のベクトルを保持し、`size`容量でベクトルを初期化し、<ruby>走脈<rt>スレッド</rt></ruby>を作成するための<ruby>譜面<rt>コード</rt></ruby>を実行する`for`ループを設定し、`thread::JoinHandle<()>`ように`ThreadPool`の定義を変更しました。それらを含む`ThreadPool`<ruby>実例<rt>インスタンス</rt></ruby>

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
use std::thread;

pub struct ThreadPool {
    threads: Vec<thread::JoinHandle<()>>,
}

impl ThreadPool {
#    // --snip--
    //  --snip--
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        let mut threads = Vec::with_capacity(size);

        for _ in 0..size {
#            // create some threads and store them in the vector
            // いくつかの<ruby>走脈<rt>スレッド</rt></ruby>を作成してベクトルに格納する
        }

        ThreadPool {
            threads
        }
    }

#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト20-14。 <code>ThreadPool</code>が<ruby>走脈<rt>スレッド</rt></ruby>を保持するためのベクトルを作成する</span>

`ThreadPool`のベクトルの項目の型として`thread::JoinHandle`を使用しているので、<ruby>譜集<rt>ライブラリー</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>有効範囲<rt>スコープ</rt></ruby>に`std::thread`を持ってきました。

有効なサイズが受け取られると、`ThreadPool`は`size`項目を保持できる新しいベクトルを作成します。
本書では`with_capacity`機能を使用していませんが、これは`Vec::new`と同じ仕事を実行しますが、重要な違いがあります。ベクトルにスペースをあらかじめ割り当てています。
ベクトルに`size`要素を格納する必要があることが分かっているので、この割り当てを前面に`Vec::new`ことは、`Vec::new`を使うよりも若干効率的です。

再び`cargo check`を実行`cargo check`と、さらに警告が表示されますが、成功するはずです。

#### `ThreadPool`から<ruby>走脈<rt>スレッド</rt></ruby>へ<ruby>譜面<rt>コード</rt></ruby>を送信する`Worker`構造体

<ruby>走脈<rt>スレッド</rt></ruby>の作成に関して、リスト20-14の`for`ループに<ruby>注釈<rt>コメント</rt></ruby>を残しました。
ここでは、実際に<ruby>走脈<rt>スレッド</rt></ruby>を作成する方法を見ていきます。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>は`thread::spawn`を作成する方法として`thread::spawn`を提供し、`thread::spawn`は<ruby>走脈<rt>スレッド</rt></ruby>が作成されるとすぐに<ruby>走脈<rt>スレッド</rt></ruby>が実行する<ruby>譜面<rt>コード</rt></ruby>を取得`thread::spawn`ことを想定しています。
しかし、場合、<ruby>走脈<rt>スレッド</rt></ruby>を作成して、後で送信する<ruby>譜面<rt>コード</rt></ruby>を*待た*せる必要があります。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>走脈<rt>スレッド</rt></ruby>の実装には、これを行う方法は含まれていません。
手動で実装する必要があります。

この動作は、`ThreadPool`とこの新しい動作を管理する<ruby>走脈<rt>スレッド</rt></ruby>との間に新しいデータ構造を導入することで実装されます。
このデータ構造を`Worker`と呼んでいます。これは、実装を貯留庫する際の共通の用語です。
レストランで台所で働いている人々を考えてみましょう。労働者は注文が顧客から来るまで待ってから、その注文を受け取り、それらを満たす責任があります。

`JoinHandle<()>`<ruby>実例<rt>インスタンス</rt></ruby>のベクトルを<ruby>走脈<rt>スレッド</rt></ruby>貯留庫に格納する代わりに、`Worker`構造体の<ruby>実例<rt>インスタンス</rt></ruby>を格納します。
各`Worker`は1つの`JoinHandle<()>`<ruby>実例<rt>インスタンス</rt></ruby>を格納します。
次に、実行する<ruby>譜面<rt>コード</rt></ruby>を閉じて実行中の<ruby>走脈<rt>スレッド</rt></ruby>に送信して実行する<ruby>操作法<rt>メソッド</rt></ruby>を`Worker`実装します。
また、動作記録や<ruby>虫取り<rt>デバッグ</rt></ruby>時に貯留庫内の異なるワーカーを区別できるように、各ワーカーに`id`与えます。

`ThreadPool`を作成するときに起こることに以下の変更を加えましょう。
このように`Worker`設定した後、<ruby>閉包<rt>クロージャー</rt></ruby>を<ruby>走脈<rt>スレッド</rt></ruby>に送信する<ruby>譜面<rt>コード</rt></ruby>を実装します。

1. `id`と`JoinHandle<()>`を保持する`Worker`構造体を定義します。
2. `Worker`<ruby>実例<rt>インスタンス</rt></ruby>のベクトルを保持する`ThreadPool`を変更します。
3. 定義`Worker::new`とる機能`id`番号を返しますし、`Worker`保持している<ruby>実例<rt>インスタンス</rt></ruby>`id`と空の<ruby>閉包<rt>クロージャー</rt></ruby>で生成された<ruby>走脈<rt>スレッド</rt></ruby>を。
4. `ThreadPool::new`、使用`for`生成するために、ループカウンタを`id`、新たに作成する`Worker`それと`id`、およびベクター中の労働者を保存します。

課題がある場合は、リスト20-15の<ruby>譜面<rt>コード</rt></ruby>を調べる前に、これらの変更を自分で実装してみてください。

準備？　
リスト20-15に、前の変更を行う1つの方法を示します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
use std::thread;

pub struct ThreadPool {
    workers: Vec<Worker>,
}

impl ThreadPool {
#    // --snip--
    //  --snip--
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        let mut workers = Vec::with_capacity(size);

        for id in 0..size {
            workers.push(Worker::new(id));
        }

        ThreadPool {
            workers
        }
    }
#    // --snip--
    //  --snip--
}

struct Worker {
    id: usize,
    thread: thread::JoinHandle<()>,
}

impl Worker {
    fn new(id: usize) -> Worker {
        let thread = thread::spawn(|| {});

        Worker {
            id,
            thread,
        }
    }
}
```

<span class="caption">リスト20-15。<ruby>走脈<rt>スレッド</rt></ruby>を直接保持するのではなく、 <code>Worker</code>実例を保持する<code>ThreadPool</code>変更</span>

上の<ruby>欄<rt>フィールド</rt></ruby>の名前を変更した`ThreadPool`から`threads`へ`workers`、それが今持っているため`Worker`の代わりに、<ruby>実例<rt>インスタンス</rt></ruby>`JoinHandle<()>`の<ruby>実例<rt>インスタンス</rt></ruby>を。
`for`ループのカウンタを`Worker::new`引数として使用し、`Worker::new`各`Worker`を`workers`という名前のベクトルに格納します。

外部<ruby>譜面<rt>コード</rt></ruby>（*src/bin/main.rsの*<ruby>提供器<rt>サーバー</rt></ruby>のような）は、`ThreadPool`内の`Worker`構造体の使用に関する実装の詳細を知る必要はないので、`Worker`構造体とその`new`機能をprivateにします。
`Worker::new`機能は、与えられた`id`を使用し、空の<ruby>閉包<rt>クロージャー</rt></ruby>を使用して新しい<ruby>走脈<rt>スレッド</rt></ruby>を生成することによって作成された`JoinHandle<()>`<ruby>実例<rt>インスタンス</rt></ruby>を格納します。

この<ruby>譜面<rt>コード</rt></ruby>は、`ThreadPool::new`への引数として指定した`Worker`<ruby>実例<rt>インスタンス</rt></ruby>の数を<ruby>製譜<rt>コンパイル</rt></ruby>して格納します。
しかし、*まだ*得る<ruby>閉包<rt>クロージャー</rt></ruby>処理していない`execute`。
それを次に行う方法を見てみましょう。

#### チャネル経由での<ruby>走脈<rt>スレッド</rt></ruby>へのリクエストの送信

今度は、`thread::spawn`与えられた<ruby>閉包<rt>クロージャー</rt></ruby>が全く何もしないという問題に取り組みます。
現在、`execute`<ruby>操作法<rt>メソッド</rt></ruby>で実行したい<ruby>閉包<rt>クロージャー</rt></ruby>を取得します。
しかし`ThreadPool`作成中に各`Worker`を作成するときに実行する<ruby>閉包<rt>クロージャー</rt></ruby>を`thread::spawn`に与える必要があります。

作成した`Worker`構造体が、`ThreadPool`保持されているキューから実行する<ruby>譜面<rt>コード</rt></ruby>をフェッチし、その<ruby>譜面<rt>コード</rt></ruby>をその<ruby>走脈<rt>スレッド</rt></ruby>に送信して実行するようにします。

第16章では、2つの<ruby>走脈<rt>スレッド</rt></ruby>間で通信する簡単な方法である*チャネル*について学習しました。この使用例には最適です。
チャネルをジョブの待ち行列として機能させ、`execute`は`ThreadPool`から`Worker`<ruby>実例<rt>インスタンス</rt></ruby>にジョブを送信し、その<ruby>走脈<rt>スレッド</rt></ruby>にジョブを送ります。
ここに計画があります。

1. `ThreadPool`はチャネルを作成し、チャネルの送信側を保持します。
2. 各`Worker`は、チャネルの受信側を保持します。
3. チャネルを送信したい<ruby>閉包<rt>クロージャー</rt></ruby>を保持する新しい`Job`構造体を作成します。
4. `execute`<ruby>操作法<rt>メソッド</rt></ruby>は、チャネルの送信側で実行したいジョブを送信します。
5. <ruby>走脈<rt>スレッド</rt></ruby>では、`Worker`はチャネルの受信側をループし、受け取ったジョブの<ruby>閉包<rt>クロージャー</rt></ruby>を実行します。

まず、`ThreadPool::new`チャネルを作成し、送信側を`ThreadPool`<ruby>実例<rt>インスタンス</rt></ruby>に保持してみましょう（リスト20-16を参照）。
`Job`構造体には現在何も保持されていませんが、チャネルを送信する項目の型になります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# use std::thread;
#// --snip--
//  --snip--
use std::sync::mpsc;

pub struct ThreadPool {
    workers: Vec<Worker>,
    sender: mpsc::Sender<Job>,
}

struct Job;

impl ThreadPool {
#    // --snip--
    //  --snip--
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        let (sender, receiver) = mpsc::channel();

        let mut workers = Vec::with_capacity(size);

        for id in 0..size {
            workers.push(Worker::new(id));
        }

        ThreadPool {
            workers,
            sender,
        }
    }
#    // --snip--
    //  --snip--
}
#
# struct Worker {
#     id: usize,
#     thread: thread::JoinHandle<()>,
# }
#
# impl Worker {
#     fn new(id: usize) -> Worker {
#         let thread = thread::spawn(|| {});
#
#         Worker {
#             id,
#             thread,
#         }
#     }
# }
```

<span class="caption">20-16リスト。変更<code>ThreadPool</code>送信チャネルの送信側格納する<code>Job</code>実例を</span>

`ThreadPool::new`では、新しいチャネルを作成し、貯留庫に送信側を保持させます。
これは正常に<ruby>製譜<rt>コンパイル</rt></ruby>され、それでも警告が表示されます。

<ruby>走脈<rt>スレッド</rt></ruby>貯留庫がチャネルを作成するときに、チャネルの受信側を各ワーカーに渡してみましょう。
ワーカーが<ruby>走脈<rt>スレッド</rt></ruby>を生成する<ruby>走脈<rt>スレッド</rt></ruby>で受信側を使用したいので、<ruby>閉包<rt>クロージャー</rt></ruby>の`receiver`パラメータを参照します。
<ruby>譜面<rt>コード</rt></ruby>リスト20-17の<ruby>譜面<rt>コード</rt></ruby>はまだ<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl ThreadPool {
#    // --snip--
    //  --snip--
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        let (sender, receiver) = mpsc::channel();

        let mut workers = Vec::with_capacity(size);

        for id in 0..size {
            workers.push(Worker::new(id, receiver));
        }

        ThreadPool {
            workers,
            sender,
        }
    }
#    // --snip--
    //  --snip--
}

#// --snip--
//  --snip--

impl Worker {
    fn new(id: usize, receiver: mpsc::Receiver<Job>) -> Worker {
        let thread = thread::spawn(|| {
            receiver;
        });

        Worker {
            id,
            thread,
        }
    }
}
```

<span class="caption">リスト20-17。チャネルの受信側をワーカーに渡す</span>

いくつかの簡単で小さな変更を加えました。チャネルの受信側を`Worker::new`に渡してから、<ruby>閉包<rt>クロージャー</rt></ruby>内で使用します。

この<ruby>譜面<rt>コード</rt></ruby>をチェックしようとすると、次の<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
$ cargo check
   Compiling hello v0.1.0 (file:///projects/hello)
error[E0382]: use of moved value: `receiver`
  --> src/lib.rs:27:42
   |
27 |             workers.push(Worker::new(id, receiver));
   |                                          ^^^^^^^^ value moved here in
   previous iteration of loop
   |
   = note: move occurs because `receiver` has type
   `std::sync::mpsc::Receiver<Job>`, which does not implement the `Copy` trait
```

<ruby>譜面<rt>コード</rt></ruby>は、`receiver`を複数の`Worker`<ruby>実例<rt>インスタンス</rt></ruby>に渡そうとしています。
これはうまくいきません.16章から思い出してください.Rustが提供するチャネルの実装は、複数の*プロデューサー*、単一の*コンシューマー*です。
つまり、この<ruby>譜面<rt>コード</rt></ruby>を修正するためにチャネルの消費側をクローンするだけでは意味がありません。
たとえできたとしても、それは使いたい技術ではありません。
代わりに、すべてのワーカー間で単一の`receiver`者を共有することによって、<ruby>走脈<rt>スレッド</rt></ruby>間でジョブを分散したいと考えています。

また、チャネルキューから仕事を取ることは変更が含ま`receiver`、その<ruby>走脈<rt>スレッド</rt></ruby>が共有し、変更する安全な方法を必要とする`receiver`。
さもなければ、競争条件を得るかもしれない（第16章で説明した通り）。

第16章で説明した<ruby>走脈<rt>スレッド</rt></ruby>セーフなスマート<ruby>指し手<rt>ポインタ</rt></ruby>を思い出してください。複数の<ruby>走脈<rt>スレッド</rt></ruby>間で所有権を共有し、<ruby>走脈<rt>スレッド</rt></ruby>が値を変更できるようにするには、`Arc<Mutex<T>>`を使用する必要があります。
`Arc`型は複数の作業者が受信機を所有できるようにし、`Mutex`は一度に1人の作業者だけが受信機から仕事を得ることを保証します。
リスト20-18は、変更が必要であることを示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# use std::thread;
# use std::sync::mpsc;
use std::sync::Arc;
use std::sync::Mutex;
#// --snip--
//  --snip--

# pub struct ThreadPool {
#     workers: Vec<Worker>,
#     sender: mpsc::Sender<Job>,
# }
# struct Job;
#
impl ThreadPool {
#    // --snip--
    //  --snip--
    pub fn new(size: usize) -> ThreadPool {
        assert!(size > 0);

        let (sender, receiver) = mpsc::channel();

        let receiver = Arc::new(Mutex::new(receiver));

        let mut workers = Vec::with_capacity(size);

        for id in 0..size {
            workers.push(Worker::new(id, Arc::clone(&receiver)));
        }

        ThreadPool {
            workers,
            sender,
        }
    }

#    // --snip--
    //  --snip--
}

# struct Worker {
#     id: usize,
#     thread: thread::JoinHandle<()>,
# }
#
impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
#        // --snip--
        //  --snip--
#         let thread = thread::spawn(|| {
#            receiver;
#         });
#
#         Worker {
#             id,
#             thread,
#         }
    }
}
```

<span class="caption">リスト20-18。 <code>Arc</code>と<code>Mutex</code>を使って作業者の間でチャネルの受信側を共有する</span>

`ThreadPool::new`では、チャネルの受信側を`Arc`と`Mutex`に置きます。
新しい作業者ごとに`Arc`をクローンして参照カウントをバンプし、作業者が受信側の所有権を共有できるようにします。

これらの変更により、<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されます。
そこに着きます！　

#### `execute`<ruby>操作法<rt>メソッド</rt></ruby>の実装

最後に、`ThreadPool` `execute`<ruby>操作法<rt>メソッド</rt></ruby>を実装しましょう。
また、構造体から受信を`execute`<ruby>閉包<rt>クロージャー</rt></ruby>の型を保持する<ruby>特性<rt>トレイト</rt></ruby>対象の型<ruby>別名<rt>エイリアス</rt></ruby>に`Job`を変更します。
第19章の「型<ruby>別名<rt>エイリアス</rt></ruby>を持つ型シノニムを作成する」で説明したように、型の<ruby>別名<rt>エイリアス</rt></ruby>を使用すると、long型を短くすることができます。
リスト20-19を見てください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#// --snip--
//  --snip--
# pub struct ThreadPool {
#     workers: Vec<Worker>,
#     sender: mpsc::Sender<Job>,
# }
# use std::sync::mpsc;
# struct Worker {}

type Job = Box<FnOnce() + Send + 'static>;

impl ThreadPool {
#    // --snip--
    //  --snip--

    pub fn execute<F>(&self, f: F)
        where
            F: FnOnce() + Send + 'static
    {
        let job = Box::new(f);

        self.sender.send(job).unwrap();
    }
}

#// --snip--
//  --snip--
```

<span class="caption">リスト20-19。各<ruby>閉包<rt>クロージャー</rt></ruby>を保持している<code>Box</code> <code>Job</code>型<ruby>別名<rt>エイリアス</rt></ruby>を作成し、そのジョブをチャネルの下に送る</span>

`execute`れた<ruby>閉包<rt>クロージャー</rt></ruby>を使用して新しい`Job`<ruby>実例<rt>インスタンス</rt></ruby>を作成した後、そのジョブをチャネルの送信側に送ります。
送信が失敗した場合、`send`で`unwrap`を呼び出しています。
これは、たとえば、受信側が新しいメッセージの受信を停止したことを意味する<ruby>走脈<rt>スレッド</rt></ruby>の実行をすべて停止する場合に発生します。
現時点では、<ruby>走脈<rt>スレッド</rt></ruby>の実行を停止することはできません。貯留庫が存在する限り、<ruby>走脈<rt>スレッド</rt></ruby>は実行を継続します。
`unwrap`を使う理由は、失敗事例は起こらないが、<ruby>製譜器<rt>コンパイラー</rt></ruby>はそれを知りません。

しかし、まだ完了していません！　
作業者では、closureが`thread::spawn`に渡されても、チャネルの受信側のみが*参照され*ます。
代わりに、<ruby>閉包<rt>クロージャー</rt></ruby>を永遠にループし、チャネルの受信側にジョブを要求し、ジョブが取得されたときにジョブを実行する必要があります。
リスト20-20に示す変更を`Worker::new`ましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
#// --snip--
//  --snip--

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
        let thread = thread::spawn(move || {
            loop {
                let job = receiver.lock().unwrap().recv().unwrap();

                println!("Worker {} got a job; executing.", id);

                (*job)();
            }
        });

        Worker {
            id,
            thread,
        }
    }
}
```

<span class="caption">リスト20-20。ワーカの<ruby>走脈<rt>スレッド</rt></ruby>でジョブを受け取って実行する</span>

ここでは、最初に`receiver` `lock`を呼び出してミューテックスを取得し、<ruby>誤り<rt>エラー</rt></ruby>が発生した場合に`unwrap`をパニックにします。
ミューテックスが*被毒*状態にある場合、ロックを取得することは失敗する可能性があります。これは、ロックを解放するのではなく、ロックを保持している間に他の<ruby>走脈<rt>スレッド</rt></ruby>がパニックになった場合に発生します。
この状況では、`unwrap`を呼び出してこの<ruby>走脈<rt>スレッド</rt></ruby>パニックが発生するのは正しい処置です。
この`unwrap`を`expect`に変更`expect`て、意味のある<ruby>誤り<rt>エラー</rt></ruby>メッセージを表示してください。

mutexのロックを取得したら、`recv`を呼び出してチャネルから`Job`を受け取ります。
受信側がシャットダウンした場合に`send`<ruby>操作法<rt>メソッド</rt></ruby>が`Err`返す方法と同様に、チャネルの送信側を保持する<ruby>走脈<rt>スレッド</rt></ruby>がシャットダウンした場合に発生する可能性がある、ここでのすべての<ruby>誤り<rt>エラー</rt></ruby>を最終的な`unwrap`します。

`recv`の呼び出しは<ruby>段落<rt>ブロック</rt></ruby>されるので、まだジョブがない場合、現在の<ruby>走脈<rt>スレッド</rt></ruby>はジョブが利用可能になるまで待機します。
`Mutex<T>`は、一度に1つの`Worker`<ruby>走脈<rt>スレッド</rt></ruby>だけがジョブを要求しようとしていることを保証します。

理論的には、この<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>する必要があります。
残念ながら、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>は完璧ではありません。この<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0161]: cannot move a value of type std::ops::FnOnce() +
std::marker::Send: the size of std::ops::FnOnce() + std::marker::Send cannot be
statically determined
  --> src/lib.rs:63:17
   |
63 |                 (*job)();
   |                 ^^^^^^
```

この問題はかなり謎めいているので、この<ruby>誤り<rt>エラー</rt></ruby>はかなり謎めいています。
呼び出すには`FnOnce`中に保存されている<ruby>閉包<rt>クロージャー</rt></ruby>`Box<T>`私達の何である`Job`型の<ruby>別名<rt>エイリアス</rt></ruby>がある）を、<ruby>閉包<rt>クロージャー</rt></ruby>の*外に*自分自身を移動する必要がある`Box<T>`の<ruby>閉包<rt>クロージャー</rt></ruby>がの所有権がかかるため`self`、それを呼び出すとき。
一般的には、Rustは、外の値を移動することはできません`Box<T>`Rustが内部値どのように大きな認識していないので、`Box<T>`次のようになります。使用し、第15章でリ呼び出し`Box<T>`正確には、既知のサイズの値を取得するために`Box<T>`に格納したい未知のサイズのものがあったからです。

リスト17-15で見たように、`self: Box<Self>`という構文を使用する<ruby>操作法<rt>メソッド</rt></ruby>を記述することができます。これにより、<ruby>操作法<rt>メソッド</rt></ruby>は`Box<T>`格納されている`Self`値の所有権を取得できます。
これはまさにここでやりたいことですが、残念ながらRustは私たちに言いません。クロストが呼び出されたときの動作を実装するRustの部分は、`self: Box<Self>`を使って実装されていません。
だから、Rustはまだ`self: Box<Self>`使うことができるということを理解していません。この状況では、`self: Box<Self>`はClosureの所有権を持ち、Closureを`Box<T>`から移動することができます。

Rustはまだ<ruby>製譜器<rt>コンパイラー</rt></ruby>が改良される場所で進行中の作業ですが、将来はリスト20-20の<ruby>譜面<rt>コード</rt></ruby>はうまくいくはずです。
あなたと同じような人々は、この問題やその他の問題を解決するために取り組んでいます！　
この本を終えた後、参加するのが大好きです。

しかし、今のところ、この問題を回避するために便利な技法を使って作業しましょう。
この場合、`Box<T>`内の値の所有権を`self: Box<Self>`を使って取得することができることをRustに明示することができます`self: Box<Self>`;
その後、<ruby>閉包<rt>クロージャー</rt></ruby>の所有権があれば、それを呼び出すことができます。
これは、`FnOnce()`を実装する任意の型に対して`FnBox`を定義し、新しい型を使用するために型名を変更し、使用する`Worker`を変更するために、`self: Box<Self>`を使用する`call_box`<ruby>操作法<rt>メソッド</rt></ruby>で新しい<ruby>特性<rt>トレイト</rt></ruby>`FnBox`を定義することを含む`call_box`<ruby>操作法<rt>メソッド</rt></ruby>。
これらの変更をリスト20-21に示します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
trait FnBox {
    fn call_box(self: Box<Self>);
}

impl<F: FnOnce()> FnBox for F {
    fn call_box(self: Box<F>) {
        (*self)()
    }
}

type Job = Box<FnBox + Send + 'static>;

#// --snip--
//  --snip--

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
        let thread = thread::spawn(move || {
            loop {
                let job = receiver.lock().unwrap().recv().unwrap();

                println!("Worker {} got a job; executing.", id);

                job.call_box();
            }
        });

        Worker {
            id,
            thread,
        }
    }
}
```

<span class="caption">リスト20-21。 <code>Box&lt;FnOnce()&gt;</code>現在の制限を回避するための新しいtrait <code>FnBox</code>追加</span>

まず、`FnBox`という名前の新しい<ruby>特性<rt>トレイト</rt></ruby>を作成します。
この<ruby>特性<rt>トレイト</rt></ruby>は`call_box`という1つの<ruby>操作法<rt>メソッド</rt></ruby>を`call_box`。これは、他の`Fn*`<ruby>特性<rt>トレイト</rt></ruby>の`call`<ruby>操作法<rt>メソッド</rt></ruby>に似てい`call`、それは`self: Box<Self>`取ります`self: Box<Self>`は、`self`所有権を持ち、`Box<T>`から値を移動します。

次に、`FnOnce()`<ruby>特性<rt>トレイト</rt></ruby>を実装する任意の型`F` `FnBox`<ruby>特性<rt>トレイト</rt></ruby>を実装します。
効果的には、これはすべての`FnOnce()`<ruby>閉包<rt>クロージャー</rt></ruby>が`call_box`<ruby>操作法<rt>メソッド</rt></ruby>を使用できることを意味します。
`call_box`の実装は、`(*self)()`を使用して`Box<T>`から<ruby>閉包<rt>クロージャー</rt></ruby>を移動し、<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出します。

今、新しい`FnBox`を実装するものの`Box`となるように、`Job`型<ruby>別名<rt>エイリアス</rt></ruby>が必要`FnBox`。
これにより、<ruby>閉包<rt>クロージャー</rt></ruby>を直接呼び出すのではなく、`Job`値を取得したときに`Worker` `call_box`を使用することができます。
任意の`FnOnce()`<ruby>閉包<rt>クロージャー</rt></ruby>の`FnBox`<ruby>特性<rt>トレイト</rt></ruby>を実装することは、チャネルを送信する実際の値について何も変更する必要がないことを意味します。
今、Rustはしたいことがうまくいくことを認識することができます。

このトリックは非常に卑劣で複雑です。
完璧な意味合いがないのであれば心配しないでください。
いつかは、まったく必要ないでしょう。

このトリックの実装では、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫は動作状態にあります！　
それに`cargo run`を与え、いくつかの要求をする。

```text
$ cargo run
   Compiling hello v0.1.0 (file:///projects/hello)
warning: field is never used: `workers`
 --> src/lib.rs:7:5
  |
7 |     workers: Vec<Worker>,
  |     ^^^^^^^^^^^^^^^^^^^^
  |
  = note: #[warn(dead_code)] on by default

warning: field is never used: `id`
  --> src/lib.rs:61:5
   |
61 |     id: usize,
   |     ^^^^^^^^^
   |
   = note: #[warn(dead_code)] on by default

warning: field is never used: `thread`
  --> src/lib.rs:62:5
   |
62 |     thread: thread::JoinHandle<()>,
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   |
   = note: #[warn(dead_code)] on by default

    Finished dev [unoptimized + debuginfo] target(s) in 0.99 secs
     Running `target/debug/hello`
Worker 0 got a job; executing.
Worker 2 got a job; executing.
Worker 1 got a job; executing.
Worker 3 got a job; executing.
Worker 0 got a job; executing.
Worker 2 got a job; executing.
Worker 1 got a job; executing.
Worker 3 got a job; executing.
Worker 0 got a job; executing.
Worker 2 got a job; executing.
```

成功！　
非同期に接続を実行する<ruby>走脈<rt>スレッド</rt></ruby>貯留庫が用意されました。
決して4つ以上の<ruby>走脈<rt>スレッド</rt></ruby>が作成されることはありません。そのため、<ruby>提供器<rt>サーバー</rt></ruby>が多くの要求を受け取ると、システムが多重定義になることはありません。
*/ sleepを*要求すると、<ruby>提供器<rt>サーバー</rt></ruby>は別の<ruby>走脈<rt>スレッド</rt></ruby>に別の<ruby>走脈<rt>スレッド</rt></ruby>を実行させることで、他の要求を提供することができます。

第18章でwhileループ`while let`学習した後、リスト20-22に示すようにワーカー<ruby>走脈<rt>スレッド</rt></ruby>譜面を記述しなかった理由が不思議に思えるかもしれません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
#// --snip--
//  --snip--

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
        let thread = thread::spawn(move || {
            while let Ok(job) = receiver.lock().unwrap().recv() {
                println!("Worker {} got a job; executing.", id);

                job.call_box();
            }
        });

        Worker {
            id,
            thread,
        }
    }
}
```

<span class="caption">リスト20-22。 <code>while let</code>を使用<code>while let</code> <code>Worker::new</code>の別の実装を使用<code>while let</code></span>

この<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>され実行されますが、望ましい<ruby>走脈<rt>スレッド</rt></ruby>動作が行われません。低速の要求でも、他の要求が処理されるのを待ちます。
`unlock`の所有権は、`lock`<ruby>操作法<rt>メソッド</rt></ruby>が返す`LockResult<MutexGuard<T>>`内の`MutexGuard<T>`存続期間に基づいているため、`Mutex`構造体には<ruby>公開<rt>パブリック</rt></ruby>`unlock`<ruby>操作法<rt>メソッド</rt></ruby>がありません。
<ruby>製譜<rt>コンパイル</rt></ruby>時に、borrow検査器は、ロックを保持しない限り、`Mutex`によって保護されている資源にアクセスできないという規則を適用することができます。
しかし、この実装は、`MutexGuard<T>`存続期間を注意深く考えないと、ロックが意図したより長く保持される可能性もあります。
`while`式の値は<ruby>段落<rt>ブロック</rt></ruby>の持続時間の範囲内にとどまるため、ロックは`job.call_box()`呼び出しの間保持されたままであり、他のワーカーがジョブを受け取ることができないことを意味します。

代わりに`loop`を使用して、ロックとそれ以外の<ruby>段落<rt>ブロック</rt></ruby>内のジョブを取得することで、`lock`<ruby>操作法<rt>メソッド</rt></ruby>から返された`MutexGuard`は、`let job`文が終了するとすぐに削除されます。
これにより、`recv`の呼び出し中にロックが保持されますが、`job.call_box()`呼び出す前にロックが解除され、複数の要求を同時に処理できるようになります。
