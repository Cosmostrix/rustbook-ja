## 単一走脈サーバをマルチ走脈サーバにする

今、サーバーは各要求を順番に処理します。つまり、最初の処理が完了するまで2番目の接続を処理しません。
サーバがますます多くのリクエストを受信した場合、このシリアル実行は、それほど最適ではありません。
サーバーが処理に時間がかかる要求を受信した場合、新しい要求を迅速に処理できる場合でも、後続の要求は長い要求が完了するまで待機する必要があります。
これを修正する必要がありますが、最初に実際の問題を見ていきます。

### 現在のサーバー実装で低速要求をシミュレートする

処理の遅いリクエストが、現在のサーバー実装に対する他のリクエストにどのように影響するかを見ていきます。
リスト20-10は、*/* sleptへのリクエストの処理をシミュレートした低速レスポンスで実装しています。これにより、サーバーは応答する前に5秒間スリープします。

<span class="filename">ファイル名。src / main.rs</span>

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

    let get = b"GET / HTTP/1.1\r\n";
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

この譜面はちょっと面倒ですが、シミュレーション目的で十分です。
サーバが認識するデータを持つ2番目のリクエスト`sleep`を作成しました。
`if`段落の後に`else if`を追加して、*/ sleep*へのリクエストを確認しました。
その要求を受け取ると、サーバーは5秒間スリープしてからHTMLページが正常に表示されます。

サーバはどれほど基本型なのかを見ることができます。実際の譜集は、あまり冗長ではない複数のリクエストの認識を処理します！　

使用してサーバを起動し`cargo run`。
次に、2つのブラウザ窓を開き*ます*.1つは*http://127.0.0.1:7878/*、もう1つは*http://127.0.0.1:7878/sleep*です。
以前と同じように*/* URIを数回入力すると、すぐに応答することがわかります。
あなたが*/スリープ*してから読み込み*/を*入力した場合しかし、あなたはまで待機*/*ことがわかります`sleep`読み込みする前にその完全な5秒間眠っています。

遅い要求の後ろにもっと多くの要求が戻ってくることを避けるためにWebサーバーの仕組みを変更する方法はいくつかあります。
実装するのは走脈貯留庫です。

### 走脈貯留庫によるスループットの向上

*走脈貯留庫*は、待機中で仕事を処理する準備ができている、生成された走脈のグループです。
算譜は新しい仕事を受け取ると、貯留庫内の走脈の1つを仕事に割り当て、その走脈がその仕事を処理します。
貯留庫内の残りの走脈は、最初の走脈が処理中に入ってくる他の仕事を処理するために使用できます。
最初の走脈がその仕事の処理を完了すると、走脈はアイドル状態の走脈の貯留庫に戻され、新しい仕事を処理できる状態になります。
走脈貯留庫を使用すると、接続を同時に処理できるため、サーバーのスループットが向上します。

サービス拒否（DoS）攻撃から私たちを守るために、貯留庫内の走脈の数を少数に制限します。
算譜が入ってくるごとにリクエストごとに新しい走脈を作成した場合、サーバーに1000万回のリクエストを行う人は、サーバーのすべての資源を使い切り、要求の処理を中断することによって混乱を招く可能性があります。

無限の走脈を生成するのではなく、貯留庫内で一定数の走脈を待機させます。
リクエストが入ると、リクエストが貯留庫に送られて処理されます。
貯留庫は着信要求のキューを維持します。
貯留庫内の各走脈は、このキューからの要求をポップアウトし、要求を処理してから、キューに別の要求を要求します。
この設計では、`N`要求を同時に処理することができます。ここで、`N`は走脈の数です。
各走脈が長時間実行している要求に応答していれば、それ以降の要求はキューにバックアップされますが、その時点までに処理できる長時間実行される要求の数が増えました。

この手法は、Webサーバーのスループットを改善する多くの方法の1つに過ぎません。
探索できるその他の選択肢は、フォーク/結合模型と単一走脈非同期I / O模型です。
この話題に興味がある場合は、他のソリューションの詳細を読んで、Rustでそれらを実装しようとすることができます。
Rustのような低レベルの言語では、これらの選択肢はすべて可能です。

走脈貯留庫の実装を開始する前に、貯留庫の使用方法について説明しましょう。
譜面を設計しようとするときは、最初にクライアント接点を記述することで、設計を手助けすることができます。
譜面のAPIを記述して、それを呼び出したい方法で構造化します。
機能を実装して公開APIを設計するのではなく、その構造内の機能を実装します。

第12章の企画でテスト駆動型開発を使用したのと同様に、ここでは製譜器主導の開発を使用します。
望む機能を呼び出す譜面を書いてから、製譜器からの誤りを見て、譜面を動作させるために次に変更すべきものを決定します。

#### リクエストごとに走脈を生成できる場合の譜面構造

まず、すべての接続に対して新しい走脈を作成した場合の譜面の外観を調べてみましょう。
前述したように、走脈の数に制限はありませんが、これは最終的な計画ではありませんが、これは出発点です。
リスト20-11は、`for`ループ内の各ストリームを処理するための新しい走脈を生成するための、`main`への変更を示しています。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト20-11。ストリームごとに新しい走脈を生成する</span>

第16章で学んだように、`thread::spawn`は新しい走脈を作成し、新しい走脈の閉包で譜面を実行します。
あなたがお使いのブラウザでこの譜面と読み込み*/スリープを*実行すると*、/* 2以上のブラウザのタブで、あなたは確かに*/*へのリクエストが終了するのを*/スリープ*待つ必要がないことがわかります。
しかし、言及したように、これは最終的にシステムを圧倒するでしょう。なぜならあなたは何の制限もなく新しい走脈を作るからです。

#### 有限数の走脈のための類似の接点の作成

走脈貯留庫を走脈貯留庫に切り替えるために、APIを使用する譜面を大幅に変更する必要はありません。
リスト20-12は、`thread::spawn`代わりに使用したい`ThreadPool`構造体の仮説的接点を示してい`thread::spawn`。

<span class="filename">ファイル名。src / main.rs</span>

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

`ThreadPool::new`を使用して、設定可能な走脈数（この場合は4）の新しい走脈貯留庫を作成します。
次に、`for`ループで`pool.execute`は、貯留庫が各ストリームに対して実行する閉包をとる点で、`thread::spawn`と同様の接点があります。
`pool.execute`を実装する必要があり`pool.execute`ので、閉包を実行して貯留庫の走脈に渡して実行します。
この譜面はまだ製譜されませんが、製譜器がどのように修正するかを案内することができます。

#### 製譜器駆動型開発を使用した`ThreadPool`構造体の構築

*譜面*リスト20-12を*src / main.rs*に変更してから、`cargo check`製譜器誤りを使って開発を進めましょう。
ここで最初に犯す誤りです。

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
この誤りは、`ThreadPool`型または役区が必要であることを示しているので、ここで構築します。
`ThreadPool`実装は、Webサーバがやっている仕事の種類から独立しています。
だから、`hello`通い箱を二進譜通い箱から譜集通い箱に切り替えて、`ThreadPool`実装を保持しましょう。
譜集・ボックスに変更した後は、Webリクエストを処理するだけでなく、走脈・貯留庫を使用して作業を行うために別の走脈・貯留庫・譜集を使用することもできます。

次のものを含む*src / lib.rs*を作成します。これは、今のところできる`ThreadPool`構造体の最も単純な定義です。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
pub struct ThreadPool;
```

次に、新しいディレクトリ*src / binを*作成し、*src / main.rs*をルートとする二進譜・通い箱を*src / bin / main.rsに移動し*ます。
そうすることで、譜集は*hello*ディレクトリの一次通い箱になります。
`cargo run`を使用して*src / bin / main.rs*内の二進譜を実行することはでき`cargo run`。
*main.rs*ファイルを移動した後、*src / bin / main.rsの*先頭に次の譜面を追加して、譜集*crateを*入れて`ThreadPool`を有効範囲にします。

<span class="filename">ファイル名。src / bin / main.rs</span>

```rust,ignore
extern crate hello;
use hello::ThreadPool;
```

この譜面はまだ機能しませんが、もう一度チェックして次の誤りを解決しましょう。

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

この誤りは、次に`ThreadPool` `new`という名前の関連する機能を作成する必要があることを示します。
また、ことを知って`new`ニーズが受け入れることができる一つのパラメータ持つように`4`引数として返す必要がありますし、`ThreadPool`実例を。
これらの特性を持つ最も単純な`new`機能を実装しましょう。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
pub struct ThreadPool;

impl ThreadPool {
    pub fn new(size: usize) -> ThreadPool {
        ThreadPool
    }
}
```

負の数の走脈が意味をなさないことがわかっているので、`usize`を`size`パラメータの型として選択し`usize`。
また、何である走脈の集まり内の要素の数として、この4を使用します知っている`usize`第3章の「整数型」の項で説明したように、型がためです。

譜面をもう一度見てみましょう。

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

今警告と誤りを得ます。
警告を無視して、`ThreadPool` `execute`操作法がないために誤りが発生します。
「有限数の走脈のための同様の接点の作成」の章から、走脈貯留庫は`thread::spawn`似た接点を持つべきだと思いました。
さらに、`execute`機能を実装して、与えられた閉包を受け取り、`execute`貯留庫内のアイドル状態の走脈に渡します。

`ThreadPool`の`execute`操作法を定義して、閉包をパラメータとして使用します。
第13章の「汎用パラメータと`Fn`特性を使用した閉包の格納」の章から、`Fn`、 `FnMut`、および`FnOnce` 3つの異なる特性を持つパラメータとして閉包を使用できることを`FnOnce`。
ここで使用する閉包の種類を決定する必要があります。
標準の譜集`thread::spawn`実装に似た何かをすることになることを知っているので、`thread::spawn`型指示がそのパラメータにどのような縛りを持つかを見ることができます。
開発資料集は私たちに以下を示します。

```rust,ignore
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
    where
        F: FnOnce() -> T + Send + 'static,
        T: Send + 'static
```

`F`型パラメータは、ここで考慮するパラメータです。
`T`型パラメータは戻り値に関連しており、それに関心がない。
`spawn`が`F`束縛された特性として`FnOnce`を使用`spawn`ことを見ることができます。
最終的に取得引数渡しますので、これは、同様に欲しいものはおそらくあり`execute`する`spawn`。
`FnOnce`は、リクエストを実行する走脈が`FnOnce`の`Once`に一致するリクエストの閉包を1回だけ実行するため、`FnOnce`が使用したい特性であることをさらに確信できます。

`F`型パラメータもトレイト結合した`Send`され、結合寿命`'static`状況において有用である、。必要`Send`別の走脈からの閉包を転送する`'static`どのくらいの走脈がするかわからないので、実行します。
`ThreadPool` `execute`操作法を作成して、これらの縛りで`F`型の汎用パラメータを取得しましょう。

<span class="filename">ファイル名。src / lib.rs</span>

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

まだ使用して`()`した後`FnOnce`このため`FnOnce`パラメータを取らず、値を返さない閉包を表します。
機能の定義と同じように、戻り値の型は型指示から省略することができますが、パラメータがなくてもかっこが必要です。

繰り返しますが、これは`execute`操作法の最も単純な実装です。何もしませんが、譜面を製譜するだけです。
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

警告のみを受け取ります。つまり、製譜されています！　
しかし、`cargo run`してブラウザでリクエストを行うと、章の冒頭で見たブラウザに誤りが表示されることに注意してください。
譜集は実際には閉包を渡して`execute`まだ`execute`呼びかけていません！　

> > 注。HaskellやRustのような厳密な製譜器を使用している言語については、「譜面が製譜されても機能する」と聞くかもしれませんが、この言葉は普遍的ではありません。
> > 企画は製譜されますが、絶対に何もしません！　
> > 本当の、完全な企画を構築していたら、譜面が製譜され*、*望む振る舞いを持っているかどうかをチェックする単体テストを書くのはいい時期です。

#### `new`走脈の数の検証

`new`パラメータと`execute`パラメータを何もしていないので、警告を受け取り続けます。
望むふるまいでこれらの機能の本体を実装しましょう。
まず、`new`考えましょう。
以前は、負の数の走脈を持つ貯留庫は意味をなさないため、`size`パラメータには符号なしの型を選択しました。
しかし、走脈がゼロの貯留庫も意味をなさないが、ゼロは完全に有効な`usize`。
リスト20-13に示すように、`ThreadPool`実例を返す前に`size`がゼロより大きいかどうかを確認する譜面を追加し、`assert!`マクロを使用してゼロを受け取った場合に算譜パニックを起こします。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# pub struct ThreadPool;
impl ThreadPool {
#//    /// Create a new ThreadPool.
    /// 新しいThreadPoolを作成します。
    ///
#//    /// The size is the number of threads in the pool.
    /// サイズは、貯留庫内の走脈の数です。
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

`ThreadPool`開発資料集コメント付きの開発資料をいくつか追加しました。
第14章で説明したように実行してみてください、私達は私達の機能がパニックすることができている状況を呼び出し章を追加することによって、良い開発資料の慣行に従っていることに注意してください`cargo doc --open`し、クリック`ThreadPool`のため何を生成した開発資料を参照する構造体を`new`外観を好き！　

ここで行ったように`assert!`マクロを追加する代わりに、リスト12-9のI / O企画で`Config::new`と同じように`new` `Result`返すことができます。
しかし、この場合、走脈なしで走脈貯留庫を作成しようとすると、回復不可能な誤りになるはずです。
あなたが野心的だと感じたら、両方の版を比較するために、次の型指示で`new`版を作成してみてください。

```rust,ignore
pub fn new(size: usize) -> Result<ThreadPool, PoolCreationError> {
```

#### 走脈を格納する領域の作成

貯留庫に格納する走脈の有効な数がわかっているので、それらの走脈を作成し、`ThreadPool`構造体に格納してから返すことができます。
しかし、走脈を「保存」するにはどうすればよいでしょうか？　
`thread::spawn`型指示をもう一度見てみましょう。

```rust,ignore
pub fn spawn<F, T>(f: F) -> JoinHandle<T>
    where
        F: FnOnce() -> T + Send + 'static,
        T: Send + 'static
```

`spawn`機能は`JoinHandle<T>`返します。ここで、`T`は閉包が返す型です。
`JoinHandle`も試して`JoinHandle`て、何が起こるか見てみましょう。
場合、走脈貯留庫に渡す閉包は接続を処理し、何も返さないので、`T`はユニット型`()`ます。

譜面リスト20-14の譜面は製譜されますが、まだ走脈は作成されません。
`thread::JoinHandle<()>`実例のベクトルを保持し、`size`容量でベクトルを初期化し、走脈を作成するための譜面を実行する`for`ループを設定し、`thread::JoinHandle<()>`ように`ThreadPool`の定義を変更しました。それらを含む`ThreadPool`実例

<span class="filename">ファイル名。src / lib.rs</span>

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
            // いくつかの走脈を作成してベクトルに格納する
        }

        ThreadPool {
            threads
        }
    }

#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト20-14。 <code>ThreadPool</code>が走脈を保持するためのベクトルを作成する</span>

`ThreadPool`のベクトルの項目の型として`thread::JoinHandle`を使用しているので、譜集・通い箱の有効範囲に`std::thread`を持ってきました。

有効なサイズが受け取られると、`ThreadPool`は`size`項目を保持できる新しいベクトルを作成します。
本書では`with_capacity`機能を使用していませんが、これは`Vec::new`と同じ仕事を実行しますが、重要な違いがあります。ベクトルにスペースをあらかじめ割り当てています。
ベクトルに`size`要素を格納する必要があることが分かっているので、この割り当てを前面に`Vec::new`ことは、`Vec::new`を使うよりも若干効率的です。

再び`cargo check`を実行`cargo check`と、さらに警告が表示されますが、成功するはずです。

#### `ThreadPool`から走脈へ譜面を送信する`Worker`構造体

走脈の作成に関して、リスト20-14の`for`ループにコメントを残しました。
ここでは、実際に走脈を作成する方法を見ていきます。
標準譜集は`thread::spawn`を作成する方法として`thread::spawn`を提供し、`thread::spawn`は走脈が作成されるとすぐに走脈が実行する譜面を取得`thread::spawn`ことを想定しています。
しかし、場合、走脈を作成して、後で送信する譜面を*待た*せる必要があります。
標準譜集の走脈の実装には、これを行う方法は含まれていません。
手動で実装する必要があります。

この動作は、`ThreadPool`とこの新しい動作を管理する走脈との間に新しいデータ構造を導入することで実装されます。
このデータ構造を`Worker`と呼んでいます。これは、実装を貯留庫する際の共通の用語です。
レストランで台所で働いている人々を考えてみましょう。労働者は注文が顧客から来るまで待ってから、その注文を受け取り、それらを満たす責任があります。

`JoinHandle<()>`実例のベクトルを走脈貯留庫に格納する代わりに、`Worker`構造体の実例を格納します。
各`Worker`は1つの`JoinHandle<()>`実例を格納します。
次に、実行する譜面を閉じて実行中の走脈に送信して実行する操作法を`Worker`実装します。
また、動作記録や虫取り時に貯留庫内の異なるワーカーを区別できるように、各ワーカーに`id`与えます。

`ThreadPool`を作成するときに起こることに以下の変更を加えましょう。
このように`Worker`設定した後、閉包を走脈に送信する譜面を実装します。

1. `id`と`JoinHandle<()>`を保持する`Worker`構造体を定義します。
2. `Worker`実例のベクトルを保持する`ThreadPool`を変更します。
3. 定義`Worker::new`とる機能`id`番号を返しますし、`Worker`保持している実例`id`と空の閉包で生成された走脈を。
4. `ThreadPool::new`、使用`for`生成するために、ループカウンタを`id`、新たに作成する`Worker`それと`id`、およびベクター中の労働者を保存します。

課題がある場合は、リスト20-15の譜面を調べる前に、これらの変更を自分で実装してみてください。

準備？　
リスト20-15に、前の変更を行う1つの方法を示します。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト20-15。走脈を直接保持するのではなく、 <code>Worker</code>実例を保持する<code>ThreadPool</code>変更</span>

上の欄の名前を変更した`ThreadPool`から`threads`へ`workers`、それが今持っているため`Worker`の代わりに、実例`JoinHandle<()>`の実例を。
`for`ループのカウンタを`Worker::new`引数として使用し、`Worker::new`各`Worker`を`workers`という名前のベクトルに格納します。

外部譜面（*src / bin / main.rsの*サーバのような）は、`ThreadPool`内の`Worker`構造体の使用に関する実装の詳細を知る必要はないので、`Worker`構造体とその`new`機能をprivateにします。
`Worker::new`機能は、与えられた`id`を使用し、空の閉包を使用して新しい走脈を生成することによって作成された`JoinHandle<()>`実例を格納します。

この譜面は、`ThreadPool::new`への引数として指定した`Worker`実例の数を製譜して格納します。
しかし、*まだ*得る閉包処理していない`execute`。
それを次に行う方法を見てみましょう。

#### チャネル経由での走脈へのリクエストの送信

今度は、`thread::spawn`与えられた閉包が全く何もしないという問題に取り組みます。
現在、`execute`操作法で実行したい閉包を取得します。
しかし`ThreadPool`作成中に各`Worker`を作成するときに実行する閉包を`thread::spawn`に与える必要があります。

作成した`Worker`構造体が、`ThreadPool`保持されているキューから実行する譜面をフェッチし、その譜面をその走脈に送信して実行するようにします。

第16章では、2つの走脈間で通信する簡単な方法である*チャネル*について学習しました。この使用例には最適です。
チャネルをジョブの待ち行列として機能させ、`execute`は`ThreadPool`から`Worker`実例にジョブを送信し、その走脈にジョブを送ります。
ここに計画があります。

1. `ThreadPool`はチャネルを作成し、チャネルの送信側を保持します。
2. 各`Worker`は、チャネルの受信側を保持します。
3. チャネルを送信したい閉包を保持する新しい`Job`構造体を作成します。
4. `execute`操作法は、チャネルの送信側で実行したいジョブを送信します。
5. 走脈では、`Worker`はチャネルの受信側をループし、受け取ったジョブの閉包を実行します。

まず、`ThreadPool::new`チャネルを作成し、送信側を`ThreadPool`実例に保持してみましょう（リスト20-16を参照）。
`Job`構造体には現在何も保持されていませんが、チャネルを送信する項目の型になります。

<span class="filename">ファイル名。src / lib.rs</span>

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
これは正常に製譜され、それでも警告が表示されます。

走脈貯留庫がチャネルを作成するときに、チャネルの受信側を各ワーカーに渡してみましょう。
ワーカーが走脈を生成する走脈で受信側を使用したいので、閉包の`receiver`パラメータを参照します。
譜面リスト20-17の譜面はまだ製譜されません。

<span class="filename">ファイル名。src / lib.rs</span>

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

いくつかの簡単で小さな変更を加えました。チャネルの受信側を`Worker::new`に渡してから、閉包内で使用します。

この譜面をチェックしようとすると、次の誤りが表示されます。

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

譜面は、`receiver`を複数の`Worker`実例に渡そうとしています。
これはうまくいきません.16章から思い出してください.Rustが提供するチャネルの実装は、複数の*プロデューサー*、単一の*コンシューマー*です。
つまり、この譜面を修正するためにチャネルの消費側をクローンするだけでは意味がありません。
たとえできたとしても、それは使いたい技術ではありません。
代わりに、すべてのワーカー間で単一の`receiver`者を共有することによって、走脈間でジョブを分散したいと考えています。

また、チャネルキューから仕事を取ることは変更が含ま`receiver`、その走脈が共有し、変更する安全な方法を必要とする`receiver`。
さもなければ、競争条件を得るかもしれない（第16章で説明した通り）。

第16章で説明した走脈セーフなスマート指し手を思い出してください。複数の走脈間で所有権を共有し、走脈が値を変更できるようにするには、`Arc<Mutex<T>>`を使用する必要があります。
`Arc`型は複数の作業者が受信機を所有できるようにし、`Mutex`は一度に1人の作業者だけが受信機から仕事を得ることを保証します。
リスト20-18は、変更が必要であることを示しています。

<span class="filename">ファイル名。src / lib.rs</span>

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

これらの変更により、譜面は製譜されます。
そこに着きます！　

#### `execute`操作法の実装

最後に、`ThreadPool` `execute`操作法を実装しましょう。
また、構造体から受信を`execute`閉包の型を保持する特性対象の型別名に`Job`を変更します。
第19章の「型別名を持つ型シノニムを作成する」で説明したように、型の別名を使用すると、long型を短くすることができます。
リスト20-19を見てください。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト20-19。各閉包を保持している<code>Box</code> <code>Job</code>型別名を作成し、そのジョブをチャネルの下に送る</span>

`execute`れた閉包を使用して新しい`Job`実例を作成した後、そのジョブをチャネルの送信側に送ります。
送信が失敗した場合、`send`で`unwrap`を呼び出しています。
これは、たとえば、受信側が新しいメッセージの受信を停止したことを意味する走脈の実行をすべて停止する場合に発生します。
現時点では、走脈の実行を停止することはできません。貯留庫が存在する限り、走脈は実行を継続します。
`unwrap`を使う理由は、失敗事例は起こらないが、製譜器はそれを知りません。

しかし、まだ完了していません！　
作業者では、closureが`thread::spawn`に渡されても、チャネルの受信側のみが*参照され*ます。
代わりに、閉包を永遠にループし、チャネルの受信側にジョブを要求し、ジョブが取得されたときにジョブを実行する必要があります。
リスト20-20に示す変更を`Worker::new`ましょう。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト20-20。ワーカの走脈でジョブを受け取って実行する</span>

ここでは、最初に`receiver` `lock`を呼び出してミューテックスを取得し、誤りが発生した場合に`unwrap`をパニックにします。
ミューテックスが*被毒*状態にある場合、ロックを取得することは失敗する可能性があります。これは、ロックを解放するのではなく、ロックを保持している間に他の走脈がパニックになった場合に発生します。
この状況では、`unwrap`を呼び出してこの走脈パニックが発生するのは正しい処置です。
この`unwrap`を`expect`に変更`expect`て、意味のある誤りメッセージを表示してください。

mutexのロックを取得したら、`recv`を呼び出してチャネルから`Job`を受け取ります。
受信側がシャットダウンした場合に`send`操作法が`Err`返す方法と同様に、チャネルの送信側を保持する走脈がシャットダウンした場合に発生する可能性がある、ここでのすべての誤りを最終的な`unwrap`します。

`recv`の呼び出しは段落されるので、まだジョブがない場合、現在の走脈はジョブが利用可能になるまで待機します。
`Mutex<T>`は、一度に1つの`Worker`走脈だけがジョブを要求しようとしていることを保証します。

理論的には、この譜面は製譜する必要があります。
残念ながら、Rust製譜器は完璧ではありません。この誤りが発生します。

```text
error[E0161]: cannot move a value of type std::ops::FnOnce() +
std::marker::Send: the size of std::ops::FnOnce() + std::marker::Send cannot be
statically determined
  --> src/lib.rs:63:17
   |
63 |                 (*job)();
   |                 ^^^^^^
```

この問題はかなり謎めいているので、この誤りはかなり謎めいています。
呼び出すには`FnOnce`中に保存されている閉包`Box<T>`私達の何である`Job`型の別名がある）を、閉包の*外に*自分自身を移動する必要がある`Box<T>`の閉包がの所有権がかかるため`self`、それを呼び出すとき。
一般的には、Rustは、外の値を移動することはできません`Box<T>`Rustが内部値どのように大きな認識していないので、`Box<T>`次のようになります。使用し、第15章でリ呼び出し`Box<T>`正確には、既知のサイズの値を取得するために`Box<T>`に格納したい未知のサイズのものがあったからです。

リスト17-15で見たように、`self: Box<Self>`という構文を使用する操作法を記述することができます。これにより、操作法は`Box<T>`格納されている`Self`値の所有権を取得できます。
これはまさにここでやりたいことですが、残念ながらRustは私たちに言いません。クロストが呼び出されたときの動作を実装するRustの部分は、`self: Box<Self>`を使って実装されていません。
だから、Rustはまだ`self: Box<Self>`使うことができるということを理解していません。この状況では、`self: Box<Self>`はClosureの所有権を持ち、Closureを`Box<T>`から移動することができます。

Rustはまだ製譜器が改良される場所で進行中の作業ですが、将来はリスト20-20の譜面はうまくいくはずです。
あなたと同じような人々は、この問題やその他の問題を解決するために取り組んでいます！　
あなたがこの本を終えた後、あなたが参加するのが大好きです。

しかし、今のところ、この問題を回避するために便利なテクニックを使って作業しましょう。
この場合、`Box<T>`内の値の所有権を`self: Box<Self>`を使って取得することができることをRustに明示することができます`self: Box<Self>`;
その後、閉包の所有権があれば、それを呼び出すことができます。
これは、`FnOnce()`を実装する任意の型に対して`FnBox`を定義し、新しい型を使用するために型名を変更し、使用する`Worker`を変更するために、`self: Box<Self>`を使用する`call_box`操作法で新しい特性`FnBox`を定義することを含む`call_box`操作法。
これらの変更をリスト20-21に示します。

<span class="filename">ファイル名。src / lib.rs</span>

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

まず、`FnBox`という名前の新しい特性を作成します。
この特性は`call_box`という1つの操作法を`call_box`。これは、他の`Fn*`特性の`call`操作法に似てい`call`、それは`self: Box<Self>`取ります`self: Box<Self>`は、`self`所有権を持ち、`Box<T>`から値を移動します。

次に、`FnOnce()`特性を実装する任意の型`F` `FnBox`特性を実装します。
効果的には、これはすべての`FnOnce()`閉包が`call_box`操作法を使用できることを意味します。
`call_box`の実装は、`(*self)()`を使用して`Box<T>`から閉包を移動し、閉包を呼び出します。

今、新しい`FnBox`を実装するものの`Box`となるように、`Job`型別名が必要`FnBox`。
これにより、閉包を直接呼び出すのではなく、`Job`値を取得したときに`Worker` `call_box`を使用することができます。
任意の`FnOnce()`閉包の`FnBox`特性を実装することは、チャネルを送信する実際の値について何も変更する必要がないことを意味します。
今、Rustはしたいことがうまくいくことを認識することができます。

このトリックは非常に卑劣で複雑です。
完璧な意味合いがないのであれば心配しないでください。
いつかは、まったく必要ないでしょう。

このトリックの実装では、走脈貯留庫は動作状態にあります！　
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
非同期に接続を実行する走脈貯留庫が用意されました。
決して4つ以上の走脈が作成されることはありません。そのため、サーバーが多くの要求を受け取ると、システムが多重定義になることはありません。
*/ sleepを*要求すると、サーバーは別の走脈に別の走脈を実行させることで、他の要求を提供することができます。

第18章でwhileループ`while let`学習した後、リスト20-22に示すようにワーカー走脈譜面を記述しなかった理由が不思議に思えるかもしれません。

<span class="filename">ファイル名。src / lib.rs</span>

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

この譜面は製譜され実行されますが、望ましい走脈動作が行われません。低速の要求でも、他の要求が処理されるのを待ちます。
`unlock`の所有権は、`lock`操作法が返す`LockResult<MutexGuard<T>>`内の`MutexGuard<T>`存続期間に基づいているため、`Mutex`構造体には公開`unlock`操作法がありません。
製譜時に、borrow検査器は、ロックを保持しない限り、`Mutex`によって保護されている資源にアクセスできないという規則を適用することができます。
しかし、この実装は、`MutexGuard<T>`存続期間を注意深く考えないと、ロックが意図したより長く保持される可能性もあります。
`while`式の値は段落の持続時間の範囲内にとどまるため、ロックは`job.call_box()`呼び出しの間保持されたままであり、他のワーカーがジョブを受け取ることができないことを意味します。

代わりに`loop`を使用して、ロックとそれ以外の段落内のジョブを取得することで、`lock`操作法から返された`MutexGuard`は、`let job`文が終了するとすぐに削除されます。
これにより、`recv`の呼び出し中にロックが保持されますが、`job.call_box()`呼び出す前にロックが解除され、複数の要求を同時に処理できるようになります。
