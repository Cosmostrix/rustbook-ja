## メッセージの受け渡しを使用して走脈間でデータを転送する

安全な並列実行を確保するために普及しているアプローチの1つは、走脈またはアクターが互いにデータを含むメッセージを送信して通信する*メッセージの受け渡し*です。
[Go言語の開発資料の](http://golang.org/doc/effective_go.html)送出ガンには[、次](http://golang.org/doc/effective_go.html)のような考えがあり[ます](http://golang.org/doc/effective_go.html)。「記憶を共有して通信しないでください。
代わりに、通信によって記憶を共有してください。

Rustがメッセージ送信の並行処理を実現するための主要な道具の1つは、Rustの標準譜集が実装を提供する演譜概念である*チャネル*です。
番組のチャネルは、川や川などの水路のようなものであると想像することができます。
ラバーダックやボートのようなものをストリームに入れると、ストリームは下流の水路まで移動します。

演譜のチャネルには、トランスミッタとレシーバの2つの半分があります。
トランスミッターの半分は、ラバーアヒルを川に入れる上流の場所であり、レシーバーの半分はラバーダックが下流に終わるところです。
譜面の1つの部分は、送信したいデータを持つトランスミッタの操作法を呼び出し、別の部分は到着するメッセージの受信側をチェックします。
送信機または受信機の半分が落とさ*れた*場合、チャネルは*閉じられた*と言われます。

ここでは、値を生成してチャネルに送る1つの走脈と、値を受け取り、それらを出力する走脈を持つ算譜を扱います。
機能を説明するためにチャネルを使って走脈間で簡単な値を送信します。
この技法に精通したら、チャネルを使用してチャット算系や、多くの走脈が計算の一部を実行し、その結果を集約する1つの走脈にそのパーツを送信する算系を実装できます。

まず、リスト16-6では、チャネルを作成しますが、何もしません。
これはまだ製譜されません。なぜなら、Rustはチャネルを通じて送信したい値の型を知ることができないからです。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();
#     tx.send(()).unwrap();
}
```

<span class="caption">リスト16-6。チャネルを作成し、2つの半分を<code>tx</code>と<code>rx</code>割り当てる</span>

`mpsc::channel`機能を使用して新しいチャネルを作成します。
`mpsc`は、*複数のプロデューサ、単一のコンシューマを*表します。
要するに、Rustの標準譜集がチャネルを実装する方法は、チャネルが値を生成する複数の*送信側*を持つことができ、それらの値を消費する*受信*側は1つだけであることを意味します。
複数の川がひとつの大きな川に流れ込んでいることを想像してください。ストリームのいずれかを下って送られてくるものはすべて、最後の1つの川で終わるでしょう。
ここでは1つのプロデューサーから始めますが、この例が有効になったら複数のプロデューサーを追加します。


`mpsc::channel`機能は組を返します。最初の要素は送信側で、2番目の要素は受信側です。
略語`tx`と`rx`は従来*トランスミッタ*と*レシーバの*多くの欄で使用されています。したがって、各エンドを示すように変数を指定します。
`let`文に組を破棄するパターンを使用しています。
`let`文とdestructuringのパターンの使用については第18章で説明します。このように`let`文を使うと、`mpsc::channel`返す組の断片を抽出する便利な方法です。

リスト16-7に示すように、送信側を生成された走脈に移動し、生成された走脈がメイン走脈と通信するように1つの文字列を送信します。
これは上流の川にゴム製の鴨を入れたり、ある走脈から別の走脈にチャットメッセージを送信するようなものです。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
}
```

<span class="caption">リスト16-7。 <code>tx</code>を生成された走脈に移動し、 &quot;hi&quot;</span>

ここでも、`thread::spawn`を使って新しい走脈を作成し、`move`を使って`tx`を閉包に移動し、生成された走脈が`tx`所有するようにしています。
生成された走脈は、チャネルを介してメッセージを送信できるようにチャネルの送信側を所有する必要があります。

送信側には、`send`たい値をとる`send`操作法があります。
`send`操作法は`Result<T, E>`型を返します。したがって、受信側が既に破棄されていて、値を送信する場所がない場合、送信操作は誤りを返します。
この例では、誤りが発生した場合に`unwrap`をパニックに呼びます。
しかし、実際の譜体では、適切に処理します。第9章に戻って、適切な誤り処理の戦略を見直してください。

リスト16-8では、メイン走脈のチャネルの受信側から値を取得します。
これは、川の端にある水からゴム製の鴨を回収するか、チャットメッセージを受け取るようなものです。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

<span class="caption">リスト16-8。メイン走脈で値 &quot;hi&quot;を受け取って印字する</span>

チャネルの受信側には、`recv`と`try_recv` 2つの便利な操作法があり`try_recv`。
`recv`を使用しています。これは*receiveの*略で、メイン走脈の実行を段落し、チャネルに値が送信されるまで待機します。
値が送られると、`recv`はそれを`Result<T, E>`返します。
チャネルの送信側が終了すると、`recv`はそれ以上の値が来ないことを知らせる誤りを返します。

`try_recv`操作法は段落されませんが`Result<T, E>`すぐに`Result<T, E>`返されます。メッセージが存在する場合はそれを保持する`Ok`値、今回はメッセージがない場合は`Err`値です。
使用`try_recv`メッセージを待っている間、この走脈が実行する他の仕事を持っている場合に便利です。呼び出すループ書くことができ`try_recv` 1が利用可能であり、そうでない場合は、再びチェックするまで、しばらくの間、他の作業を行う場合はそう頻繁ごとに、メッセージを処理します。

`recv`やすくするために、この例では`recv`を使用しています。
メイン走脈がメッセージを待つ以外の作業を行うための他の作業がないため、メイン走脈を段落することが適切です。

リスト16-8の譜面を実行すると、メイン走脈から出力された値が表示されます。

```text
Got: hi
```

完璧！　

### チャネルと所有権移転

所有ルールは、安全で並行した譜面を書くのに役立つため、メッセージ送信に不可欠な役割を果たします。
並行演譜の誤りを防ぐことは、Rust算譜全体の所有権について考えることの利点です。
問題を防ぐためにチャネルと所有権がどのように連携しているかを示すための実験を行いましょう。生成した走脈をチャネルに送り込んだ*後に* `val`値を使用しようとします。
リスト16-9の譜面を製譜して、この譜面が許可されていない理由を調べてください。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
        println!("val is {}", val);
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

<span class="caption">リスト16-9。 <code>val</code>をchannelの下に送信した後で<code>val</code>を使用しようとしています</span>

ここでは、`val`を`tx.send`経由でチャネルに送った後に`val`を表示しようとしています。
これを許すことは悪い考えです。いったん値が別の走脈に送られると、値を再び使用する前にその走脈が変更または削除する可能性があります。
潜在的に、他の走脈の変更は、一貫性のないデータや存在しないデータのために誤りや予期しない結果を引き起こす可能性があります。
しかし、リスト16-9の譜面を製譜しようとすると、Rustは誤りを返します。

```text
error[E0382]: use of moved value: `val`
  --> src/main.rs:10:31
   |
9  |         tx.send(val).unwrap();
   |                 --- value moved here
10 |         println!("val is {}", val);
   |                               ^^^ value used here after move
   |
   = note: move occurs because `val` has type `std::string::String`, which does
not implement the `Copy` trait
```

同時実行間違いは、製譜時に誤りを引き起こしました。
`send`機能はパラメータの所有権を持ち、値が移動されると、受信者はそのパラメータの所有権を取得します。
これにより、送信後に誤って値を再使用することがなくなります。
所有権算系はすべてが正常であることをチェックします。

### 複数の値を送信し、受信側が待機中であることを確認する

リスト16-8の譜面は製譜されて実行されましたが、2つの別々の走脈がチャネル上でお互いに話していたことが明確に示されていませんでした。
リスト16-10では、リスト16-8の譜面が同時に実行されていることを証明するいくつかの変更を行いました。生成された走脈は複数のメッセージを送信し、各メッセージ間で1秒間ポーズします。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::sync::mpsc;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }
}
```

<span class="caption">リスト16-10。複数のメッセージを送信し、それぞれの間で一時停止する</span>

今回、生成された走脈には、メイン走脈に送信したい文字列のベクトルがあります。
それぞれを個別に送信し、`thread::sleep`機能を呼び出して`Duration`値を1秒にして、それぞれを一時停止し`thread::sleep`。

メイン走脈では、`recv`機能を明示的に呼び出すことはもうありません。代わりに、`rx`を反復子として扱います。
受け取った値ごとに印字しています。
チャネルが閉じられると、繰り返しが終了します。

譜面リスト10-10の譜面を実行すると、各行の間に1秒の休止時間を持つ次の出力が表示されます。

```text
Got: hi
Got: from
Got: the
Got: thread
```

メイン走脈の`for`ループで中断または遅延する譜面がないため、メイン走脈が生成された走脈から値を受け取るのを待っていることがわかります。

### トランスミッタのクローニングによる複数のプロデューサの作成

以前は、`mpsc`は*複数のプロデューサー、単一の消費者の*頭字語であると述べました。
リスト16-10の譜面を`mpsc`に使用して展開し、すべて同じ走脈に値を送る複数の走脈を作成しましょう。
譜面リスト16-11に示すように、チャネルの送信側の半分を複製することで、これを行うことができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::sync::mpsc;
# use std::time::Duration;
#
# fn main() {
#// --snip--
//  --snip--

let (tx, rx) = mpsc::channel();

let tx1 = mpsc::Sender::clone(&tx);
thread::spawn(move || {
    let vals = vec![
        String::from("hi"),
        String::from("from"),
        String::from("the"),
        String::from("thread"),
    ];

    for val in vals {
        tx1.send(val).unwrap();
        thread::sleep(Duration::from_secs(1));
    }
});

thread::spawn(move || {
    let vals = vec![
        String::from("more"),
        String::from("messages"),
        String::from("for"),
        String::from("you"),
    ];

    for val in vals {
        tx.send(val).unwrap();
        thread::sleep(Duration::from_secs(1));
    }
});

for received in rx {
    println!("Got: {}", received);
}

#// --snip--
//  --snip--
# }
```

<span class="caption">リスト16-11。複数のプロデューサから複数のメッセージを送信する</span>

今回は、最初に生成された走脈を作成する前に、チャネルの送信側で`clone`を呼び出します。
これにより、最初に生成された走脈に渡すことができる新しい送信手綱が得られます。
チャネルの最初の送信側を2番目の生成走脈に渡します。
これにより、2つの走脈が生成され、それぞれが異なるメッセージをチャネルの受信側に送信します。

譜面を実行すると、出力は次のようになります。

```text
Got: hi
Got: more
Got: from
Got: messages
Got: for
Got: the
Got: thread
Got: you
```

別の順序で値が表示されることがあります。
それは算系によって異なります。
これは並列実行を面白く、難しくする要因です。
`thread::sleep`を試して、別の走脈でさまざまな値を与えると、それぞれの実行は非決定論的になり、毎回異なる出力を生成します。

チャネルの仕組みを見てきたので、並列実行の別の方法を見てみましょう。
