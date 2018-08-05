## グレースフルシャットダウンと後始末

<ruby>譜面<rt>コード</rt></ruby>リスト20-21の<ruby>譜面<rt>コード</rt></ruby>は、意図したとおり、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を使用して非同期的に要求に応答しています。
何かをきれいにしていないことを思い出させる直接的な方法で使用していない`workers`、 `id`、 `thread`<ruby>欄<rt>フィールド</rt></ruby>についていくつかの警告を出します。
それほど洗練されていない<span class="keystroke">ctrl-c</span>操作法を使用してメイン<ruby>走脈<rt>スレッド</rt></ruby>を停止すると、他のすべての<ruby>走脈<rt>スレッド</rt></ruby>は要求の処理中であってもすぐに停止します。

ここで、`Drop`<ruby>特性<rt>トレイト</rt></ruby>を実装して、貯留庫内の各<ruby>走脈<rt>スレッド</rt></ruby>で`join`を呼び出して、クローズする前に作業している要求を完了できるようにします。
次に、<ruby>走脈<rt>スレッド</rt></ruby>が新しい要求の受け入れを停止してシャットダウンするように指示する方法を実装します。
この<ruby>譜面<rt>コード</rt></ruby>が実際に動作するように、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を正常にシャットダウンする前に、2つの要求だけを受け入れるように<ruby>提供器<rt>サーバー</rt></ruby>を修正します。

### `ThreadPool`の`Drop`<ruby>特性<rt>トレイト</rt></ruby>の実装

<ruby>走脈<rt>スレッド</rt></ruby>貯留庫で`Drop`を実装することから始めましょう。
貯留庫が削除されると、<ruby>走脈<rt>スレッド</rt></ruby>がすべて終了して作業が完了するようにします。
リスト20-23は、`Drop`実装の最初の試みを示しています。
この<ruby>譜面<rt>コード</rt></ruby>はまだ動作しません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Drop for ThreadPool {
    fn drop(&mut self) {
        for worker in &mut self.workers {
            println!("Shutting down worker {}", worker.id);

            worker.thread.join().unwrap();
        }
    }
}
```

<span class="caption">リスト20-23。<ruby>走脈<rt>スレッド</rt></ruby>貯留庫が<ruby>有効範囲<rt>スコープ</rt></ruby>から外れたときに各<ruby>走脈<rt>スレッド</rt></ruby>に参加する</span>

まず、各<ruby>走脈<rt>スレッド</rt></ruby>貯留庫`workers`をループします。
`&mut`を使用します。なぜなら、`self`は可変参照であり、`worker`変更も可能でなければならないからです。
各ワーカーに対して、この特定のワーカーがシャットダウンしていることを示すメッセージを出力し、そのワーカーの<ruby>走脈<rt>スレッド</rt></ruby>に対して`join`を呼び出します。
`join`への呼び出しに失敗した場合は、`unwrap`を使用してRustパニックを起こし、悲惨なシャットダウンに入ります。

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>するときの<ruby>誤り<rt>エラー</rt></ruby>は次のとおりです。

```text
error[E0507]: cannot move out of borrowed content
  --> src/lib.rs:65:13
   |
65 |             worker.thread.join().unwrap();
   |             ^^^^^^ cannot move out of borrowed content
```

この<ruby>誤り<rt>エラー</rt></ruby>は、各`worker`可変的な借用しか持たず、`join`がその引数の所有権を取るため、`join`を呼び出すことができないことを示しています。
この問題を解決するには、<ruby>走脈<rt>スレッド</rt></ruby>を所有する`Worker`<ruby>実例<rt>インスタンス</rt></ruby>から<ruby>走脈<rt>スレッド</rt></ruby>を移動して、<ruby>走脈<rt>スレッド</rt></ruby>が`thread`を消費するように`join`があります。
リスト17-15でこれをやった次の場合`Worker`保持している`Option<thread::JoinHandle<()>`の代わりに、呼び出すことができ`take`の方法`Option`外の値を移動するには`Some`<ruby>場合値<rt>バリアント</rt></ruby>と残し`None`で<ruby>場合値<rt>バリアント</rt></ruby>をその場所。
言い換えれば、`Worker`実行している必要があります`Some`中に<ruby>場合値<rt>バリアント</rt></ruby>`thread`、後始末する際に`Worker`、交換してくださいよ`Some`と`None`ように、`Worker`実行する<ruby>走脈<rt>スレッド</rt></ruby>を持っていません。

そこで、`Worker`の定義を次のように更新したいと考えています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# use std::thread;
struct Worker {
    id: usize,
    thread: Option<thread::JoinHandle<()>>,
}
```

次に、変更する必要がある他の場所を見つけるために<ruby>製譜器<rt>コンパイラー</rt></ruby>を手放しましょう。
この<ruby>譜面<rt>コード</rt></ruby>を確認すると、2つの<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0599]: no method named `join` found for type
`std::option::Option<std::thread::JoinHandle<()>>` in the current scope
  --> src/lib.rs:65:27
   |
65 |             worker.thread.join().unwrap();
   |                           ^^^^

error[E0308]: mismatched types
  --> src/lib.rs:89:13
   |
89 |             thread,
   |             ^^^^^^
   |             |
   |             expected enum `std::option::Option`, found struct
   `std::thread::JoinHandle`
   |             help: try using a <ruby>場合値<rt>バリアント</rt></ruby> of the expected type: `Some(thread)`
   |
   = note: expected type `std::option::Option<std::thread::JoinHandle<()>>`
              found type `std::thread::JoinHandle<_>`
```

`Worker::new`最後の<ruby>譜面<rt>コード</rt></ruby>を指す2番目の<ruby>誤り<rt>エラー</rt></ruby>を解決しましょう。
新しい`Worker`を作成するときに、`Some`に`thread`値を包む必要があります。
この<ruby>誤り<rt>エラー</rt></ruby>を修正するには、次の変更を行います。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Job>>>) -> Worker {
#        // --snip--
        //  --snip--

        Worker {
            id,
            thread: Some(thread),
        }
    }
}
```

最初の<ruby>誤り<rt>エラー</rt></ruby>は`Drop`実装です。
先に、`thread`を`worker`から移動させるために`Option`値を`take`ことを意図したと述べました。
次の変更がこれを行います。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Drop for ThreadPool {
    fn drop(&mut self) {
        for worker in &mut self.workers {
            println!("Shutting down worker {}", worker.id);

            if let Some(thread) = worker.thread.take() {
                thread.join().unwrap();
            }
        }
    }
}
```

第17章で説明した`take`、 `Option`の`take`<ruby>操作法<rt>メソッド</rt></ruby>は、`Some` <ruby>場合値<rt>バリアント</rt></ruby>を取り出し、`None`をそのまま残します。
`Some`を破壊して<ruby>走脈<rt>スレッド</rt></ruby>を手に入れよ`if let`とする`if let`使っています。
<ruby>走脈<rt>スレッド</rt></ruby>上で`join`を呼び出します。
ワーカーの<ruby>走脈<rt>スレッド</rt></ruby>が既に`None`の場合、ワーカーは既に<ruby>走脈<rt>スレッド</rt></ruby>を後始末していることがわかっているので、その場合は何も起こりません。

### ジョブのリッスンを停止するための<ruby>走脈<rt>スレッド</rt></ruby>へのシグナリング

行ったすべての変更により、<ruby>譜面<rt>コード</rt></ruby>は警告なしで<ruby>製譜<rt>コンパイル</rt></ruby>されます。
しかし、悪い知らせは、この<ruby>譜面<rt>コード</rt></ruby>はまだ望むように機能しないということです。
キーは、`Worker`<ruby>実例<rt>インスタンス</rt></ruby>の<ruby>走脈<rt>スレッド</rt></ruby>によって実行される<ruby>閉包<rt>クロージャー</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>です。現時点では`join`を呼び出します`join`、<ruby>走脈<rt>スレッド</rt></ruby>を永久に`loop`ため、<ruby>走脈<rt>スレッド</rt></ruby>をシャットダウンしません。
現在の`drop`実装で`ThreadPool`を削除しようとすると、メイン<ruby>走脈<rt>スレッド</rt></ruby>は最初の<ruby>走脈<rt>スレッド</rt></ruby>が終了するのを永久に<ruby>段落<rt>ブロック</rt></ruby>します。

それらはどちらかのために聞くように、この問題を解決するために、<ruby>走脈<rt>スレッド</rt></ruby>を修正します`Job`を実行したり、彼らが聞いて停止し、無限ループを終了しなければならない信号。
`Job`<ruby>実例<rt>インスタンス</rt></ruby>の代わりに、チャネルはこれら2つの列挙型の1つを送信します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# struct Job;
enum Message {
    NewJob(Job),
    Terminate,
}
```

この`Message` enumは、<ruby>走脈<rt>スレッド</rt></ruby>が実行する`Job`を保持する`NewJob`<ruby>場合値<rt>バリアント</rt></ruby>か、<ruby>走脈<rt>スレッド</rt></ruby>がループを終了して停止する`Terminate`<ruby>場合値<rt>バリアント</rt></ruby>になります。

リスト20-24に示すように、`Job`型を入力するのではなく、`Message`型の値を使用するようにチャネルを調整する必要があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub struct ThreadPool {
    workers: Vec<Worker>,
    sender: mpsc::Sender<Message>,
}

#// --snip--
//  --snip--

impl ThreadPool {
#    // --snip--
    //  --snip--

    pub fn execute<F>(&self, f: F)
        where
            F: FnOnce() + Send + 'static
    {
        let job = Box::new(f);

        self.sender.send(Message::NewJob(job)).unwrap();
    }
}

#// --snip--
//  --snip--

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Message>>>) ->
        Worker {

        let thread = thread::spawn(move ||{
            loop {
                let message = receiver.lock().unwrap().recv().unwrap();

                match message {
                    Message::NewJob(job) => {
                        println!("Worker {} got a job; executing.", id);

                        job.call_box();
                    },
                    Message::Terminate => {
                        println!("Worker {} was told to terminate.", id);

                        break;
                    },
                }
            }
        });

        Worker {
            id,
            thread: Some(thread),
        }
    }
}
```

<span class="caption">リスト20-24。 <code>Message</code>値を送受信すると、 <code>Worker</code> <code>Message::Terminate</code>を受け取った場合にループを<code>Message::Terminate</code></span>

`Message` enumを組み込むには、`ThreadPool`の定義と`Worker::new`署名の2つの場所で`Job`から`Message`に変更する必要があります。
`ThreadPool`の`execute`<ruby>操作法<rt>メソッド</rt></ruby>は、`Message::NewJob`<ruby>場合値<rt>バリアント</rt></ruby>に包まれたジョブを送信する必要があります。
次に、`Worker::new`でチャネルから`Message`を受信すると、`NewJob`<ruby>場合値<rt>バリアント</rt></ruby>が受信された場合にジョブが処理され、`Terminate`<ruby>場合値<rt>バリアント</rt></ruby>が受信された場合に<ruby>走脈<rt>スレッド</rt></ruby>からループが抜けます。

これらの変更により、<ruby>譜面<rt>コード</rt></ruby>は<ruby>譜面<rt>コード</rt></ruby>リスト20-21の場合と同じ方法で<ruby>製譜<rt>コンパイル</rt></ruby>され、機能し続けます。
しかし、`Terminate`種類のメッセージを作成していないため、警告が表示されます。
リスト20-25のように`Drop`実装を変更して、この警告を修正しましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Drop for ThreadPool {
    fn drop(&mut self) {
        println!("Sending terminate message to all workers.");

        for _ in &mut self.workers {
            self.sender.send(Message::Terminate).unwrap();
        }

        println!("Shutting down all workers.");

        for worker in &mut self.workers {
            println!("Shutting down worker {}", worker.id);

            if let Some(thread) = worker.thread.take() {
                thread.join().unwrap();
            }
        }
    }
}
```

<span class="caption">リスト20-25。 <code>Message::Terminate</code>送信する<code>Message::Terminate</code>各ワーカー<ruby>走脈<rt>スレッド</rt></ruby>で<code>join</code>を呼び出す前にworkerを<code>Message::Terminate</code>する</span>

従業員ごとに1回`Terminate`メッセージを送信し、各ワーカーの<ruby>走脈<rt>スレッド</rt></ruby>で1回`join`を呼び出すよう`join`ました。
メッセージを送信してすぐに同じループで`join`しようと`join`と、現行反復のワーカーがチャネルからメッセージを受け取ることが保証されませんでした。

2つの別々のループが必要な理由をよりよく理解するには、2人の作業者がいる場合を想像してみてください。
各ワーカーを反復処理する単一のループを使用した場合、最初の反復で終わるメッセージはチャネルをダウン送信されますと、`join`最初のワーカーの<ruby>走脈<rt>スレッド</rt></ruby>で呼び出さ。
その最初のワーカーがその時点で要求を処理するのに忙しかった場合、2番目のワーカーはそのチャネルから終了メッセージを取り出してシャットダウンします。
最初のワーカーがシャットダウンするのを待つままにしておきますが、2番目の<ruby>走脈<rt>スレッド</rt></ruby>が終了メッセージを受け取ったために決して実行されません。
デッドロック！　

この場合を防ぐために、最初にすべての`Terminate`メッセージを1つのループでチャネルに配置します。
別のループのすべての<ruby>走脈<rt>スレッド</rt></ruby>に参加します。
各作業者は、終了メッセージを受信すると、チャネル上で要求の受信を停止します。
したがって、ワーカーが存在するのと同じ数の終了メッセージを送信すると、各ワーカーはその<ruby>走脈<rt>スレッド</rt></ruby>で`join`が呼び出される前`join`終了メッセージを受け取ることができます。

この<ruby>譜面<rt>コード</rt></ruby>を実行するには、リスト20-26に示すように、<ruby>提供器<rt>サーバー</rt></ruby>を正常にシャットダウンする前に、`main`を変更して2つの要求のみを受け入れるようにしましょう。

<span class="filename">ファイル名。src/bin/main.rs</span>

```rust,ignore
fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();
    let pool = ThreadPool::new(4);

    for stream in listener.incoming().take(2) {
        let stream = stream.unwrap();

        pool.execute(|| {
            handle_connection(stream);
        });
    }

    println!("Shutting down.");
}
```

<span class="caption">リスト20-26。ループを終了して2つのリクエストを処理した後に<ruby>提供器<rt>サーバー</rt></ruby>をシャットダウンする</span>

2つの要求のみを処理した後、現実のWeb<ruby>提供器<rt>サーバー</rt></ruby>をシャットダウンする必要はありません。
この<ruby>譜面<rt>コード</rt></ruby>は、正常なシャットダウンと後始末が正常に動作していることを示しています。

`take`<ruby>操作法<rt>メソッド</rt></ruby>は`Iterator`<ruby>特性<rt>トレイト</rt></ruby>で定義され、反復を多くても最初の2つの項目に制限します。
`ThreadPool`は`main`の最後に<ruby>有効範囲<rt>スコープ</rt></ruby>から外れ、`drop`実装が実行されます。

`cargo run`で<ruby>提供器<rt>サーバー</rt></ruby>を始動し、3つの要求をします。
3番目のリクエストに<ruby>誤り<rt>エラー</rt></ruby>があり、<ruby>端末<rt>ターミナル</rt></ruby>に次のような出力が表示されます。

```text
$ cargo run
   Compiling hello v0.1.0 (file:///projects/hello)
    Finished dev [unoptimized + debuginfo] target(s) in 1.0 secs
     Running `target/debug/hello`
Worker 0 got a job; executing.
Worker 3 got a job; executing.
Shutting down.
Sending terminate message to all workers.
Shutting down all workers.
Shutting down worker 0
Worker 1 was told to terminate.
Worker 2 was told to terminate.
Worker 0 was told to terminate.
Worker 3 was told to terminate.
Shutting down worker 1
Shutting down worker 2
Shutting down worker 3
```

作業員とメッセージの順序が異なることがあります。
この<ruby>譜面<rt>コード</rt></ruby>がメッセージからどのように機能するかを見ることができます。ワーカー0と3が最初の2つの要求を受け取り、3番目の要求では、<ruby>提供器<rt>サーバー</rt></ruby>は接続の受け入れを停止しました。
`ThreadPool`が`main`の終わりに<ruby>有効範囲<rt>スコープ</rt></ruby>から外れると、その`Drop`実装が起動し、貯留庫はすべてのワーカーに終了を指示します。
ワーカーはそれぞれ、終了メッセージが表示されたときにメッセージを出力し、<ruby>走脈<rt>スレッド</rt></ruby>貯留庫は`join`を呼び出して各ワーカー<ruby>走脈<rt>スレッド</rt></ruby>をシャットダウンします。

この特定の実行の興味深い点の1つに注目してください`ThreadPool`はチャネルの終端メッセージを送信し、ワーカーがメッセージを受け取る前にワーカー0に参加しようとしました。ワーカー0はまだ終了メッセージを受信して​​いないので、作業者0が終了します。
その間、各作業員は終了メッセージを受信した。
作業者0が終了すると、メイン<ruby>走脈<rt>スレッド</rt></ruby>は残りの作業者が終了するのを待っていました。
その時点で、それらはすべて終了メッセージを受信して​​シャットダウンすることができました。

おめでとう！　
これで企画が完了しました。
非同期に応答するために<ruby>走脈<rt>スレッド</rt></ruby>貯留庫を使用する基本的なWeb<ruby>提供器<rt>サーバー</rt></ruby>があります。
<ruby>提供器<rt>サーバー</rt></ruby>を正常にシャットダウンすることができ、貯留庫内のすべての<ruby>走脈<rt>スレッド</rt></ruby>が後始末されます。

参考までに完全な<ruby>譜面<rt>コード</rt></ruby>は次のとおりです。

<span class="filename">ファイル名。src/bin/main.rs</span>

```rust,ignore
extern crate hello;
use hello::ThreadPool;

use std::io::prelude::*;
use std::net::TcpListener;
use std::net::TcpStream;
use std::fs::File;
use std::thread;
use std::time::Duration;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();
    let pool = ThreadPool::new(4);

    for stream in listener.incoming().take(2) {
        let stream = stream.unwrap();

        pool.execute(|| {
            handle_connection(stream);
        });
    }

    println!("Shutting down.");
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();

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

     let mut file = File::open(filename).unwrap();
     let mut contents = String::new();

     file.read_to_string(&mut contents).unwrap();

     let response = format!("{}{}", status_line, contents);

     stream.write(response.as_bytes()).unwrap();
     stream.flush().unwrap();
}
```

<span class="filename">ファイル名。src/lib.rs</span>

```rust
use std::thread;
use std::sync::mpsc;
use std::sync::Arc;
use std::sync::Mutex;

enum Message {
    NewJob(Job),
    Terminate,
}

pub struct ThreadPool {
    workers: Vec<Worker>,
    sender: mpsc::Sender<Message>,
}

trait FnBox {
    fn call_box(self: Box<Self>);
}

impl<F: FnOnce()> FnBox for F {
    fn call_box(self: Box<F>) {
        (*self)()
    }
}

type Job = Box<FnBox + Send + 'static>;

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

    pub fn execute<F>(&self, f: F)
        where
            F: FnOnce() + Send + 'static
    {
        let job = Box::new(f);

        self.sender.send(Message::NewJob(job)).unwrap();
    }
}

impl Drop for ThreadPool {
    fn drop(&mut self) {
        println!("Sending terminate message to all workers.");

        for _ in &mut self.workers {
            self.sender.send(Message::Terminate).unwrap();
        }

        println!("Shutting down all workers.");

        for worker in &mut self.workers {
            println!("Shutting down worker {}", worker.id);

            if let Some(thread) = worker.thread.take() {
                thread.join().unwrap();
            }
        }
    }
}

struct Worker {
    id: usize,
    thread: Option<thread::JoinHandle<()>>,
}

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Message>>>) ->
        Worker {

        let thread = thread::spawn(move ||{
            loop {
                let message = receiver.lock().unwrap().recv().unwrap();

                match message {
                    Message::NewJob(job) => {
                        println!("Worker {} got a job; executing.", id);

                        job.call_box();
                    },
                    Message::Terminate => {
                        println!("Worker {} was told to terminate.", id);

                        break;
                    },
                }
            }
        });

        Worker {
            id,
            thread: Some(thread),
        }
    }
}
```

もっともっとここでやることができます！　
この企画の改善を継続したい場合は、以下のアイデアを参考にしてください。

* `ThreadPool`とその公開<ruby>操作法<rt>メソッド</rt></ruby>にさらに開発資料を追加してください。
* <ruby>譜集<rt>ライブラリー</rt></ruby>の機能のテストを追加します。
* `unwrap`する呼び出しをより堅牢な<ruby>誤り<rt>エラー</rt></ruby>処理に変更します。
* Web要求を処理する以外の仕事を実行するには、`ThreadPool`を使用します。
* *https://crates.io/で*<ruby>走脈<rt>スレッド</rt></ruby>貯留庫の枠を見つけて、代わりに<ruby>通い箱<rt>クレート</rt></ruby>を使用して同様のWeb<ruby>提供器<rt>サーバー</rt></ruby>を実装して*ください*。
   その後、APIと堅牢性を実装した<ruby>走脈<rt>スレッド</rt></ruby>貯留庫と比較します。

## 概要

よくやった！　
あなたは本の終わりまでそれを作った！　
このRustのツアーに参加してくれてありがとう。
これであなた自身のRust企画を実装し、他の人々の企画に協力する準備が整いました。
Rustびた旅で遭遇するあらゆる挑戦をお手伝いしたいと思う他のRustびた人の歓迎するコミュニティがあることに留意してください。
