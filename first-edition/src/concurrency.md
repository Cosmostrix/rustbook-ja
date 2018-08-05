# 並行性

並行処理と並列処理は、コンピュータサイエンスにおいて非常に重要なトピックであり、今日の業界でも注目されています。
コンピュータはますます多くのコアを獲得していますが、多くのプログラマはそれらを十分に活用する準備ができていません。

Rustのメモリ安全機能は、並行処理の話題にも適用されます。
並行して実行されるRustプログラムであっても、データ競合のないメモリ安全でなければなりません。
Rustの型システムはタスクに依存しており、コンパイル時に同時にコードを推論する強力な方法を提供します。

Rustに付属する並行処理機能について説明する前に、何かを理解することが重要です。Rustは低レベルであり、これの大部分は言語ではなく標準ライブラリによって提供されます。
つまり、Rustが並行処理を行う方法のいくつかの側面が気に入らなければ、別のやり方で実装することができます。
[mio](https://github.com/carllerche/mio)は実際のこの原則の実際の例です。

## 背景： `Send`と`Sync`

並行処理は理にかなっていません。
Rustには、コードについての理由を理解するのに役立つ強力な静的型システムがあります。
そのため、Rustは、おそらく同時に起こりうるコードの意味を理解するのに役立つ2つの特性を与えてくれます。

### `Send`
話すつもりの最初の特性は[`Send`](../../std/marker/trait.Send.html)です。
タイプ`T`が`Send`実装するとき、このタイプのものが所有権をスレッド間で安全に転送できることを示します。

これは、特定の制限を実施するために重要です。
たとえば、2つのスレッドを接続するチャネルがある場合、チャネルと別のスレッドにいくつかのデータを送信できるようにする必要があります。
そのため、そのタイプの`Send`が実装されていること`Send`確認します。

反対に、スレッドセーフではない[FFI][ffi]を使用してライブラリをラップする場合、`Send`を実装したくないので、コンパイラは現在のスレッドから離れることができないように強制します。

[ffi]: ffi.html

### `Sync`
これらの特性の2番目のものを「 [`Sync`](../../std/marker/trait.Sync.html)と呼びます。
タイプ`T`が`Sync`実装するとき、このタイプのものは、共有参照を介して複数のスレッドから同時に使用されるときにメモリ不安定性を招く可能性がないことを示します。
これは、[内部の](mutability.html) `u8`性を持たない型は本質的に`Sync`であり、シンプルなプリミティブ型（`u8`）とそれを含む集約型を含みます。

スレッド間で参照を共有するために、Rustは`Arc<T>`というラッパー型を提供します。
`Arc<T>`実装`Send`と`Sync`している場合にのみあれば`T`実装の両方の`Send`と`Sync`。
たとえば、[`RefCell`](choosing-your-guarantees.html#refcellt)は`Sync`実装していないため、`Arc<RefCell<U>>`型のオブジェクトはスレッド間で転送できないため、`Arc<RefCell<U>>`は`Send`実装しません。

この2つの特性により、型システムを使用して、並行性の下でコードのプロパティを強力に保証することができます。
理由を説明する前に、最初に同時Rustプログラムを作成する方法を学ぶ必要があります。

## スレッド

Rustの標準ライブラリにはスレッド用のライブラリが用意されており、Rustコードを並列に実行できます。
`std::thread`を使用する基本的な例を次に示し`std::thread`。

```rust
use std::thread;

fn main() {
    thread::spawn(|| {
        println!("Hello from a thread!");
    });
}
```

`thread::spawn()`メソッドは、新しいスレッドで実行される[closure](closures.html)受け入れます。
スレッドへのハンドルを返します。これは、子スレッドが終了してその結果を抽出するのを待つために使用できます。

```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        "Hello from a thread!"
    });

    println!("{}", handle.join().unwrap());
}
```

クロージャは環境から変数を取り込むことができるので、他のスレッドにいくつかのデータを渡そうとすることもできます：

```rust,ignore
use std::thread;

fn main() {
    let x = 1;
    thread::spawn(|| {
        println!("x is {}", x);
    });
}
```

しかし、これは私たちにエラーを与えます：

```text
5:19: 7:6 error: closure may outlive the current function, but it
                 borrows `x`, which is owned by the current function
...
5:19: 7:6 help: to force the closure to take ownership of `x` (and any other referenced variables),
          use the `move` keyword, as shown:
      thread::spawn(move || {
          println!("x is {}", x);
      });
```

これは、デフォルトでは変数を参照によってクローズするため、クロージャーは _`x`へ_ の _参照_ しかキャプチャし _ないから_ です。
これは問題です。スレッドが`x`のスコープよりも長生きして、ぶら下がりポインタにつながる可能性があるからです。

これを修正するには、エラーメッセージで説明したように`move`クロージャを使用します。
`move`クロージャについては[here](closures.html#move-closures)で詳しく説明し[here](closures.html#move-closures)。
基本的には変数を環境から自分自身に移します。

```rust
use std::thread;

fn main() {
    let x = 1;
    thread::spawn(move || {
        println!("x is {}", x);
    });
}
```

多くの言語はスレッドを実行する能力を持っていますが、それは危険にさらされています。
共有可能な可変状態から発生するエラーを防ぐ方法については、全書籍があります。
錆はコンパイル時にデータ競合を防ぐことで、ここでも型システムをサポートします。
実際にスレッド間で物事を共有する方法について話しましょう。

## 安全な共有可変状態

Rustのタイプシステムのおかげで、私たちは嘘のように思えるコンセプトを持っています。
多くのプログラマーは、共有可能な可変状態が非常に悪いことに同意します。

誰かがこれを一度言った：

> > 共有される可変状態はすべての悪の根です。
> > ほとんどの言語はこの問題を '変更可能な部分'で処理しようとしますが、Rustは '共有'部分を解決することでそれを処理します。

ポインタを誤って使用するのを防ぐのに役立つ同じ[所有権システム](ownership.html)は、最悪の並行性バグの1つであるデータ競合を排除します。

一例として、多くの言語でデータ競争するRustプログラムがあります。
それはコンパイルされません：

```rust,ignore
use std::thread;
use std::time::Duration;

fn main() {
    let mut data = vec![1, 2, 3];

    for i in 0..3 {
        thread::spawn(move || {
            data[0] += i;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

これは私達にエラーを与えます：

```text
8:17 error: capture of moved value: `data`
        data[0] += i;
        ^~~~
```

錆はこれが安全ではないことを知っている！
各スレッドの`data`への参照があり、そのスレッドが参照の所有権を取得している場合、3人の所有者がいます。
`data`は`spawn()`への最初の呼び出しで`main`から移動します。そのため、ループ内の後続の呼び出しはこの変数を使用できません。

だから、値への参照を複数持つことができるような型が必要です。
通常、これには`Rc<T>`を使用します。これは共有所有権を提供する参照カウント型です。
これには、参照の数、つまりその名前の「参照カウント」の部分を追跡する実行時簿記があります。

`Rc<T>` `clone()`を呼び出すと、新しい所有参照が返され、内部参照カウントがバンプされます。
スレッドごとに次のいずれかを作成します。


```rust,ignore
use std::thread;
use std::time::Duration;
use std::rc::Rc;

fn main() {
    let mut data = Rc::new(vec![1, 2, 3]);

    for i in 0..3 {
#        // Create a new owned reference:
        // 新しい所有参照を作成する：
        let data_ref = data.clone();

#        // Use it in a thread:
        // スレッドで使用する：
        thread::spawn(move || {
            data_ref[0] += i;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

しかし、これはうまくいかず、エラーが表示されます：

```text
13:9: 13:22 error: the trait bound `alloc::rc::Rc<collections::vec::Vec<i32>> : core::marker::Send`
            is not satisfied
...
13:9: 13:22 note: `alloc::rc::Rc<collections::vec::Vec<i32>>`
            cannot be sent between threads safely
```

エラーメッセージに記載されているように、`Rc`はスレッド間で安全に送信できません。
これは、内部参照カウントがスレッドセーフな方法で維持されず、データ競合が発生する可能性があるためです。

これを解決するために、Rustの標準原子基準型である`Arc<T>`使用します。

Atomicの部分は、`Arc<T>`が複数のスレッドから安全にアクセスできることを意味します。
これを実行するために、コンパイラは、内部カウントの突然変異がデータ競合を持つことができない分割不可能な操作を使用することを保証します。

本質的に、`Arc<T>`は、 _スレッド間_ でデータの所有権を共有できるようにする型です。


```rust,ignore
use std::thread;
use std::sync::Arc;
use std::time::Duration;

fn main() {
    let mut data = Arc::new(vec![1, 2, 3]);

    for i in 0..3 {
        let data = data.clone();
        thread::spawn(move || {
            data[0] += i;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

前回同様、`clone()`を使用して新しい所有ハンドルを作成します。
このハンドルは、新しいスレッドに移動されます。

そして...まだ、私たちには誤りがあります。

```text
<anon>:11:24 error: cannot borrow immutable borrowed content as mutable
<anon>:11                    data[0] += i;
                             ^~~~
```

`Arc<T>`はデフォルトでは不変の内容を持っています。
スレッド間でデータを _共有する_ ことは可能ですが、変更可能な共有データは安全ではなく、スレッドが関与するとデータ競合が発生する可能性があります。


通常は、不変の位置を変更可能にする場合は、ランタイムチェックやその他の方法で安全な突然変異を可能にする`Cell<T>`または`RefCell<T>`を使用します（[保証の選択](choosing-your-guarantees.html)も参照してください）。
ただし、`Rc`と同様に、これらはスレッドセーフではありません。
これらを使用しようとすると、これらのタイプが`Sync`ではないというエラーが発生し、コードがコンパイルに失敗します。

スレッド間で共有された値を安全に変更できるような型が必要なようです。たとえば、一度に1つのスレッドしか一度に値を変更することはできません。

そのためには、`Mutex<T>`型を使用することができます！

ここに作業用のバージョンがあります：

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    let data = Arc::new(Mutex::new(vec![1, 2, 3]));

    for i in 0..3 {
        let data = data.clone();
        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            data[0] += i;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

`i`の値はクロージャにバインド（コピー）され、スレッド間で共有されないことに注意してください。

ここではmutexを「ロック」しています。
前述のようにmutex（「相互排他」の略）は、一度に1つのスレッドのみが値にアクセスできるようにします。
値にアクセスするときは、`lock()`を使用し`lock()`。
これはミューテックスを「ロック」し、完了するまで、他のスレッドはそれをロックすることができず（従って、値で何かを行うことはできません）。
スレッドが既にロックされているミューテックスをロックしようとすると、他のスレッドがロックを解除するまで待機します。

ここでのロック「リリース」は暗黙的です。
ロックの結果（この場合は`data`）が有効範囲外になると、ロックは自動的に解放されます。

[`Mutex`](../../std/sync/struct.Mutex.html) [`lock`](../../std/sync/struct.Mutex.html#method.lock)メソッドには次のシグネチャがあります。

```rust,ignore
fn lock(&self) -> LockResult<MutexGuard<T>>
```

`Send`は`MutexGuard<T>`実装されていないため、ガードはスレッドの境界を越えることができず、ロックの取得と解放のスレッド`MutexGuard<T>`性が保証されます。

スレッドの本体をより詳しく調べてみましょう。

```rust
# use std::sync::{Arc, Mutex};
# use std::thread;
# use std::time::Duration;
# fn main() {
#     let data = Arc::new(Mutex::new(vec![1, 2, 3]));
#     for i in 0..3 {
#         let data = data.clone();
thread::spawn(move || {
    let mut data = data.lock().unwrap();
    data[0] += i;
});
#     }
#     thread::sleep(Duration::from_millis(50));
# }
```

まず、mutexのロックを取得する`lock()`を呼び出します。
これは失敗する可能性があるため、`Result<T, E>`返します。これは単なる例であるため、データへの参照を取得するために`unwrap()`します。
実際のコードでは、ここでより頑強なエラー処理が行われます。
私たちはロックを持っているので、自由に変更することができます。

最後に、スレッドが実行されている間、短いタイマーで待機します。
しかし、これは理想的ではありません。待機するのに妥当な時間を選んでいるかもしれませんが、スレッドが実際に計算を完了するのにどれくらい時間がかかっているかによって、必要以上に長い時間待機するか、プログラムが実行されます。

タイマーのより正確な代替方法は、スレッドを互いに同期させるためにRust標準ライブラリによって提供されるメカニズムの1つを使用することです。
そのうちの1つについて話しましょう：チャンネル。

## チャンネル

特定の時間を待つのではなく、同期のためにチャネルを使用するコードのバージョンです：

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::sync::mpsc;

fn main() {
    let data = Arc::new(Mutex::new(0));

#    // `tx` is the "transmitter" or "sender".
#    // `rx` is the "receiver".
    //  `tx`は「送信者」または「送信者」です。`rx`は「受信者」です。
    let (tx, rx) = mpsc::channel();

    for _ in 0..10 {
        let (data, tx) = (data.clone(), tx.clone());

        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            *data += 1;

            tx.send(()).unwrap();
        });
    }

    for _ in 0..10 {
        rx.recv().unwrap();
    }
}
```

`mpsc::channel()`メソッドを使用して新しいチャンネルを作成します。
私たちは、`send`、単純な`()`チャンネルダウンをした後、戻ってきて、それらの10のを待ちます。

このチャンネルは一般的な信号を`Send`していますが、チャンネル経由で`Send`することができます。

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    for i in 0..10 {
        let tx = tx.clone();

        thread::spawn(move || {
            let answer = i * i;

            tx.send(answer).unwrap();
        });
    }

    for _ in 0..10 {
        println!("{}", rx.recv().unwrap());
    }
}
```

ここでは、数の二乗を計算するために、それぞれを求めて、10個のスレッドを作成します（`i`する時に`spawn()`その後、`send()`バックチャネルを介しての答え。


## パニック

`panic!`が実行中のスレッドをクラッシュさせます。
Rustのスレッドは、単純な分離機構として使用できます。

```rust
use std::thread;

let handle = thread::spawn(move || {
    panic!("oops!");
});

let result = handle.join();

assert!(result.is_err());
```

`Thread.join()`は`Result` backを返すので、スレッドがパニックになっているかどうかを確認することができます。
