## グレースフルシャットダウンと後始末

譜面リスト20-21の譜面は、意図したとおり、走脈貯留庫を使用して非同期的に要求に応答しています。
何かをきれいにしていないことを思い出させる直接的な方法で使用していない`workers`、 `id`、 `thread`欄についていくつかの警告を出します。
それほど洗練されていない<span class="keystroke">ctrl-c</span>操作法を使用してメイン走脈を停止すると、他のすべての走脈は要求の処理中であってもすぐに停止します。

ここで、`Drop`特性を実装して、貯留庫内の各走脈で`join`を呼び出して、クローズする前に作業している要求を完了できるようにします。
次に、走脈が新しい要求の受け入れを停止してシャットダウンするように指示する方法を実装します。
この譜面が実際に動作するように、走脈貯留庫を正常にシャットダウンする前に、2つの要求だけを受け入れるようにサーバーを修正します。

### `ThreadPool`の`Drop`特性の実装

走脈貯留庫で`Drop`を実装することから始めましょう。
貯留庫が削除されると、走脈がすべて終了して作業が完了するようにします。
リスト20-23は、`Drop`実装の最初の試みを示しています。
この譜面はまだ動作しません。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト20-23。走脈貯留庫が有効範囲から外れたときに各走脈に参加する</span>

まず、各走脈貯留庫`workers`をループします。
`&mut`を使用します。なぜなら、`self`は可変参照であり、`worker`変更も可能でなければならないからです。
各ワーカーに対して、この特定のワーカーがシャットダウンしていることを示すメッセージを出力し、そのワーカーの走脈に対して`join`を呼び出します。
`join`への呼び出しに失敗した場合は、`unwrap`を使用してRustパニックを起こし、悲惨なシャットダウンに入ります。

この譜面を製譜するときの誤りは次のとおりです。

```text
error[E0507]: cannot move out of borrowed content
  --> src/lib.rs:65:13
   |
65 |             worker.thread.join().unwrap();
   |             ^^^^^^ cannot move out of borrowed content
```

この誤りは、各`worker`可変的な借用しか持たず、`join`がその引数の所有権を取るため、`join`を呼び出すことができないことを示しています。
この問題を解決するには、走脈を所有する`Worker`実例から走脈を移動して、走脈が`thread`を消費するように`join`があります。
リスト17-15でこれをやった次の場合`Worker`保持している`Option<thread::JoinHandle<()>`の代わりに、呼び出すことができ`take`の方法`Option`外の値を移動するには`Some`変種と残し`None`で場合値をその場所。
言い換えれば、`Worker`実行している必要があります`Some`中に場合値`thread`、後始末する際に`Worker`、交換してくださいよ`Some`と`None`ように、`Worker`実行する走脈を持っていません。

そこで、`Worker`の定義を次のように更新したいと考えています。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# use std::thread;
struct Worker {
    id: usize,
    thread: Option<thread::JoinHandle<()>>,
}
```

次に、変更する必要がある他の場所を見つけるために製譜器を手放しましょう。
この譜面を確認すると、2つの誤りが発生します。

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
   |             help: try using a variant of the expected type: `Some(thread)`
   |
   = note: expected type `std::option::Option<std::thread::JoinHandle<()>>`
              found type `std::thread::JoinHandle<_>`
```

`Worker::new`最後の譜面を指す2番目の誤りを解決しましょう。
新しい`Worker`を作成するときに、`Some`に`thread`値を包む必要があります。
この誤りを修正するには、次の変更を行います。

<span class="filename">ファイル名。src / lib.rs</span>

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

最初の誤りは`Drop`実装です。
先に、`thread`を`worker`から移動させるために`Option`値を`take`ことを意図したと述べました。
次の変更がこれを行います。

<span class="filename">ファイル名。src / lib.rs</span>

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

第17章で説明した`take`、 `Option`の`take`操作法は、`Some` variantを取り出し、`None`をそのまま残します。
`Some`を破壊して走脈を手に入れよ`if let`とする`if let`使っています。
走脈上で`join`を呼び出します。
ワーカーの走脈が既に`None`の場合、ワーカーは既に走脈を後始末していることがわかっているので、その場合は何も起こりません。

### ジョブのリッスンを停止するための走脈へのシグナリング

行ったすべての変更により、譜面は警告なしで製譜されます。
しかし、悪い知らせは、この譜面はまだ望むように機能しないということです。
キーは、`Worker`実例の走脈によって実行される閉包のロジックです。現時点では`join`を呼び出します`join`、走脈を永久に`loop`ため、走脈をシャットダウンしません。
現在の`drop`実装で`ThreadPool`を削除しようとすると、メイン走脈は最初の走脈が終了するのを永久に段落します。

それらはどちらかのために聞くように、この問題を解決するために、走脈を修正します`Job`を実行したり、彼らが聞いて停止し、無限ループを終了しなければならない信号。
`Job`実例の代わりに、チャネルはこれら2つの列挙型の1つを送信します。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
# struct Job;
enum Message {
    NewJob(Job),
    Terminate,
}
```

この`Message` enumは、走脈が実行する`Job`を保持する`NewJob`場合値か、走脈がループを終了して停止する`Terminate`場合値になります。

リスト20-24に示すように、`Job`型を入力するのではなく、`Message`型の値を使用するようにチャネルを調整する必要があります。

<span class="filename">ファイル名。src / lib.rs</span>

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
`ThreadPool`の`execute`操作法は、`Message::NewJob`場合値に包まれたジョブを送信する必要があります。
次に、`Worker::new`でチャネルから`Message`を受信すると、`NewJob`場合値が受信された場合にジョブが処理され、`Terminate`場合値が受信された場合に走脈からループが抜けます。

これらの変更により、譜面は譜面リスト20-21の場合と同じ方法で製譜され、機能し続けます。
しかし、`Terminate`種類のメッセージを作成していないため、警告が表示されます。
リスト20-25のように`Drop`実装を変更して、この警告を修正しましょう。

<span class="filename">ファイル名。src / lib.rs</span>

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

<span class="caption">リスト20-25。 <code>Message::Terminate</code>送信する<code>Message::Terminate</code>各ワーカー走脈で<code>join</code>を呼び出す前にworkerを<code>Message::Terminate</code>する</span>

従業員ごとに1回`Terminate`メッセージを送信し、各ワーカーの走脈で1回`join`を呼び出すよう`join`ました。
メッセージを送信してすぐに同じループで`join`しようと`join`と、現行反復のワーカーがチャネルからメッセージを受け取ることが保証されませんでした。

2つの別々のループが必要な理由をよりよく理解するには、2人の作業者がいる場合を想像してみてください。
各ワーカーを反復処理する単一のループを使用した場合、最初の反復で終わるメッセージはチャネルをダウン送信されますと、`join`最初のワーカーの走脈で呼び出さ。
その最初のワーカーがその時点で要求を処理するのに忙しかった場合、2番目のワーカーはそのチャネルから終了メッセージを取り出してシャットダウンします。
最初のワーカーがシャットダウンするのを待つままにしておきますが、2番目の走脈が終了メッセージを受け取ったために決して実行されません。
デッドロック！　

この場合を防ぐために、最初にすべての`Terminate`メッセージを1つのループでチャネルに配置します。
別のループのすべての走脈に参加します。
各作業者は、終了メッセージを受信すると、チャネル上で要求の受信を停止します。
したがって、ワーカーが存在するのと同じ数の終了メッセージを送信すると、各ワーカーはその走脈で`join`が呼び出される前`join`終了メッセージを受け取ることができます。

この譜面を実行するには、リスト20-26に示すように、サーバーを正常にシャットダウンする前に、`main`を変更して2つの要求のみを受け入れるようにしましょう。

<span class="filename">ファイル名。src / bin / main.rs</span>

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

<span class="caption">リスト20-26。ループを終了して2つのリクエストを処理した後にサーバをシャットダウンする</span>

2つの要求のみを処理した後、現実のWebサーバーをシャットダウンする必要はありません。
この譜面は、正常なシャットダウンと後始末が正常に動作していることを示しています。

`take`操作法は`Iterator`特性で定義され、反復を多くても最初の2つの項目に制限します。
`ThreadPool`は`main`の最後に有効範囲から外れ、`drop`実装が実行されます。

`cargo run`でサーバーを始動し、3つの要求をします。
3番目のリクエストに誤りがあり、端末に次のような出力が表示されます。

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
この譜面がメッセージからどのように機能するかを見ることができます。ワーカー0と3が最初の2つの要求を受け取り、3番目の要求では、サーバーは接続の受け入れを停止しました。
`ThreadPool`が`main`の終わりに有効範囲から外れると、その`Drop`実装が起動し、貯留庫はすべてのワーカーに終了を指示します。
ワーカーはそれぞれ、終了メッセージが表示されたときにメッセージを出力し、走脈貯留庫は`join`を呼び出して各ワーカー走脈をシャットダウンします。

この特定の実行の興味深い点の1つに注目してください`ThreadPool`はチャネルの終端メッセージを送信し、ワーカーがメッセージを受け取る前にワーカー0に参加しようとしました。ワーカー0はまだ終了メッセージを受信して​​いないので、作業者0が終了します。
その間、各作業員は終了メッセージを受信した。
作業者0が終了すると、メイン走脈は残りの作業者が終了するのを待っていました。
その時点で、それらはすべて終了メッセージを受信して​​シャットダウンすることができました。

おめでとう！　
これで企画が完了しました。
非同期に応答するために走脈貯留庫を使用する基本的なWebサーバーがあります。
サーバを正常にシャットダウンすることができ、貯留庫内のすべての走脈が後始末されます。

参考までに完全な譜面は次のとおりです。

<span class="filename">ファイル名。src / bin / main.rs</span>

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

     let mut file = File::open(filename).unwrap();
     let mut contents = String::new();

     file.read_to_string(&mut contents).unwrap();

     let response = format!("{}{}", status_line, contents);

     stream.write(response.as_bytes()).unwrap();
     stream.flush().unwrap();
}
```

<span class="filename">ファイル名。src / lib.rs</span>

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
    /// サイズは、貯留庫内の走脈の数です。
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

* `ThreadPool`とその公開操作法にさらに開発資料を追加してください。
* 譜集の機能のテストを追加します。
* `unwrap`する呼び出しをより堅牢な誤り処理に変更します。
* Web要求を処理する以外の仕事を実行するには、`ThreadPool`を使用します。
* *https://crates.io/で*走脈貯留庫の枠を見つけて、代わりに通い箱を使用して同様のWebサーバーを実装して*ください*。
   その後、APIと堅牢性を実装した走脈貯留庫と比較します。

## 概要

よくやった！　
あなたは本の終わりまでそれを作った！　
このRustのツアーに参加してくれてありがとう。
これであなた自身のRust企画を実装し、他の人々の企画に協力する準備が整いました。
あなたのRustびた旅で遭遇するあらゆる挑戦をお手伝いしたいと思う他のRustびた人の歓迎するコミュニティがあることに留意してください。
