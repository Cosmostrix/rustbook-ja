# 並列実行

並行処理と並列処理は、計算機科学において非常に重要な話題であり、今日の業界でも注目されています。
計算機はますます多くのコアを獲得していますが、多くの演譜師はそれらを十分に活用する準備ができていません。

Rustの記憶安全機能は、並行処理の話題にも適用されます。
並行して実行されるRust算譜であっても、データ競合のない記憶安全でなければなりません。
Rustの型システムは仕事に依存しており、製譜時に同時に譜面を推論する強力な方法を提供します。

Rustに付属する並行処理機能について説明する前に、何かを理解することが重要です。Rustは低レベルであり、これの大部分は言語ではなく標準譜集によって提供されます。
つまり、Rustが並行処理を行う方法の一部の側面が気に入らなければ、別のやり方で実装することができます。
[mio](https://github.com/carllerche/mio)は実際のこの原則の実際の例です。

## 背景。 `Send`と`Sync`

並行処理は理にかなっていません。
Rustには、譜面についての理由を理解するのに役立つ強力な静的型システムがあります。
そのため、Rustは、おそらく同時に起こりうる譜面の意味を理解するのに役立つ2つの特性を与えてくれます。

### `Send`
話すつもりの最初の特性は[`Send`](../../std/marker/trait.Send.html)です。
型`T`が`Send`実装するとき、この型のものが所有権を走脈間で安全に転送できることを示します。

これは、特定の制限を実施するために重要です。
たとえば、2つの走脈を接続するチャネルがある場合、チャネルと別の走脈にそれ用のデータを送信できるようにする必要があります。
そのため、その型の`Send`が実装されていること`Send`確認します。

反対に、走脈セーフではない[FFI][ffi]を使用して譜集を包む場合、`Send`を実装したくないので、製譜器は現在の走脈から離れることができないように強制型変換します。

[ffi]: ffi.html

### `Sync`
これらの特性の2番目のものを「 [`Sync`](../../std/marker/trait.Sync.html)と呼びます。
型`T`が`Sync`実装するとき、この型のものは、共有参照を介して複数の走脈から同時に使用されるときに記憶不安定性を招く可能性がないことを示します。
これは、[内部の](mutability.html) `u8`性を持たない型は本質的に`Sync`であり、シンプルな基本型（`u8`）とそれを含む集約型を含みます。

走脈間で参照を共有するために、Rustは`Arc<T>`というの包み型を提供します。
`Arc<T>`実装`Send`と`Sync`している場合にのみあれば`T`実装の両方の`Send`と`Sync`。
たとえば、[`RefCell`](choosing-your-guarantees.html#refcellt)は`Sync`実装していないため、`Arc<RefCell<U>>`型の対象は走脈間で転送できないため、`Arc<RefCell<U>>`は`Send`実装しません。

この2つの特性により、型システムを使用して、並列実行の下で譜面のプロパティを強力に保証することができます。
理由を説明する前に、最初に同時Rust算譜を作成する方法を学ぶ必要があります。

## 走脈

Rustの標準譜集には走脈用の譜集が用意されており、Rust譜面を並列に実行できます。
`std::thread`を使用する基本的な例を次に示し`std::thread`。

```rust
use std::thread;

fn main() {
    thread::spawn(|| {
        println!("Hello from a thread!");
    });
}
```

`thread::spawn()`操作法は、新しい走脈で実行される[closure](closures.html)受け入れます。
走脈への手綱を返します。これは、子走脈が終了してその結果を抽出するのを待つために使用できます。

```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        "Hello from a thread!"
    });

    println!("{}", handle.join().unwrap());
}
```

閉包は環境から変数を取り込むことができるので、他の走脈にそれ用のデータを渡そうとすることもできます。

```rust,ignore
use std::thread;

fn main() {
    let x = 1;
    thread::spawn(|| {
        println!("x is {}", x);
    });
}
```

しかし、これは私たちに誤りを与えます。

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

これは、自動的には変数を参照によってクローズするため、閉包は _`x`へ_ の _参照_ しか保存し _ないから_ です。
これは問題です。走脈が`x`の有効範囲よりも長生きして、ぶら下がり指し手につながる可能性があるからです。

これを修正するには、誤りメッセージで説明したように`move`閉包を使用します。
`move`閉包については[here](closures.html#move-closures)で詳しく説明し[here](closures.html#move-closures)。
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

多くの言語は走脈を実行する能力を持っていますが、それは危険にさらされています。
共有可能な可変状態から発生する誤りを防ぐ方法については、全書籍があります。
Rustは製譜時にデータ競合を防ぐことで、ここでも型システムをサポートします。
実際に走脈間で物事を共有する方法について話しましょう。

## 安全な共有可変状態

Rustの型システムのおかげで、嘘のように思える概念を持っています。
多くの演譜師は、共有可能な可変状態が非常に悪いことに同意します。

誰かがこれを一度言った。

> > 共有される可変状態はすべての悪の根です。
> > ほとんどの言語はこの問題を '変更可能な部分'で処理しようとしますが、Rustは '共有'部分を解決することでそれを処理します。

指し手を誤って使用するのを防ぐのに役立つ同じ[所有権システム](ownership.html)は、最悪の並列実行バグの1つであるデータ競合を排除します。

一例として、多くの言語でデータ競争するRust算譜があります。
それは製譜されません。

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

これは私達に誤りを与えます。

```text
8:17 error: capture of moved value: `data`
        data[0] += i;
        ^~~~
```

Rustはこれが安全ではないことを知っている！　
各走脈の`data`への参照があり、その走脈が参照の所有権を取得している場合、3人の所有者がいます。
`data`は`spawn()`への最初の呼び出しで`main`から移動します。そのため、ループ内の後続の呼び出しはこの変数を使用できません。

だから、値への参照を複数持つことができるような型が必要です。
通常、これには`Rc<T>`を使用します。これは共有所有権を提供する参照カウント型です。
これには、参照の数、つまりその名前の「参照カウント」の部分を追跡する実行時簿記があります。

`Rc<T>` `clone()`を呼び出すと、新しい所有参照が返され、内部参照カウントがバンプされます。
走脈ごとに次のいずれかを作成します。


```rust,ignore
use std::thread;
use std::time::Duration;
use std::rc::Rc;

fn main() {
    let mut data = Rc::new(vec![1, 2, 3]);

    for i in 0..3 {
#        // Create a new owned reference:
        // 新しい所有参照を作成する。
        let data_ref = data.clone();

#        // Use it in a thread:
        // 走脈で使用する。
        thread::spawn(move || {
            data_ref[0] += i;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

しかし、これはうまくいかず、誤りが表示されます。

```text
13:9: 13:22 error: the trait bound `alloc::rc::Rc<collections::vec::Vec<i32>> : core::marker::Send`
            is not satisfied
...
13:9: 13:22 note: `alloc::rc::Rc<collections::vec::Vec<i32>>`
            cannot be sent between threads safely
```

誤りメッセージに記載されているように、`Rc`は走脈間で安全に送信できません。
これは、内部参照カウントが走脈セーフな方法で維持されず、データ競合が発生する可能性があるためです。

これを解決するために、Rustの標準原子基準型である`Arc<T>`使用します。

Atomicの部分は、`Arc<T>`が複数の走脈から安全にアクセスできることを意味します。
これを実行するために、製譜器は、内部カウントの変更がデータ競合を持つことができない分割不可能な操作を使用することを保証します。

本質的に、`Arc<T>`は、 _走脈間_ でデータの所有権を共有できるようにする型です。


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

前回同様、`clone()`を使用して新しい所有手綱を作成します。
この手綱は、新しい走脈に移動されます。

そして...まだ、私たちには誤りがあります。

```text
<anon>:11:24 error: cannot borrow immutable borrowed content as mutable
<anon>:11                    data[0] += i;
                             ^~~~
```

`Arc<T>`は自動的には不変の内容を持っています。
走脈間でデータを _共有する_ ことは可能ですが、変更可能な共有データは安全ではなく、走脈が関与するとデータ競合が発生する可能性があります。


通常は、不変の位置を変更可能にする場合は、実行時チェックやその他の方法で安全な変更を可能にする`Cell<T>`または`RefCell<T>`を使用します（[保証の選択](choosing-your-guarantees.html)も参照してください）。
ただし、`Rc`と同様に、これらは走脈セーフではありません。
これらを使用しようとすると、これらの型が`Sync`ではないという誤りが発生し、譜面が製譜に失敗します。

走脈間で共有された値を安全に変更できるような型が必要なようです。たとえば、一度に1つの走脈しか一度に値を変更することはできません。

そのためには、`Mutex<T>`型を使用することができます！　

ここに作業用の版があります。

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

`i`の値は閉包に束縛（コピー）され、走脈間で共有されないことに注意してください。

ここではmutexを「ロック」しています。
前述のようにmutex（「相互排他」の略）は、一度に1つの走脈のみが値にアクセスできるようにします。
値にアクセスするときは、`lock()`を使用し`lock()`。
これはミューテックスを「ロック」し、完了するまで、他の走脈はそれをロックすることができず（従って、値で何かを行うことはできません）。
走脈が既にロックされているミューテックスをロックしようとすると、他の走脈がロックを解除するまで待機します。

ここでのロック「リリース」は暗黙的です。
ロックの結果（この場合は`data`）が有効範囲外になると、ロックは自動的に解放されます。

[`Mutex`](../../std/sync/struct.Mutex.html) [`lock`](../../std/sync/struct.Mutex.html#method.lock)操作法には次の型指示があります。

```rust,ignore
fn lock(&self) -> LockResult<MutexGuard<T>>
```

`Send`は`MutexGuard<T>`実装されていないため、ガードは走脈の境界を越えることができず、ロックの取得と解放の走脈`MutexGuard<T>`性が保証されます。

走脈の本体をより詳しく調べてみましょう。

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
実際の譜面では、ここでより頑強な誤り処理が行われます。
ロックを持っているので、自由に変更することができます。

最後に、走脈が実行されている間、短いタイマーで待機します。
しかし、これは理想的ではありません。待機するのに妥当な時間を選んでいるかもしれませんが、走脈が実際に計算を完了するのにどれくらい時間がかかっているかによって、必要以上に長い時間待機するか、算譜が実行されます。

タイマーのより正確な代替方法は、走脈を互いに同期させるためにRust標準譜集によって提供されるしくみの1つを使用することです。
そのうちの1つについて話しましょう。チャネル。

## チャネル

特定の時間を待つのではなく、同期のためにチャネルを使用する譜面の版です。

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

`mpsc::channel()`操作法を使用して新しいチャネルを作成します。
`send`、単純な`()`チャネルダウンをした後、戻ってきて、それらの10のを待ちます。

このチャネルは一般的な信号を`Send`していますが、チャネル経由で`Send`することができます。

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

ここでは、数の二乗を計算するために、それぞれを求めて、10個の走脈を作成します（`i`する時に`spawn()`その後、`send()`バックチャネルを介しての答え。


## パニック

`panic!`が実行中の走脈を異常終了させます。
Rustの走脈は、単純な分離機構として使用できます。

```rust
use std::thread;

let handle = thread::spawn(move || {
    panic!("oops!");
});

let result = handle.join();

assert!(result.is_err());
```

`Thread.join()`は`Result` backを返すので、走脈がパニックになっているかどうかを確認することができます。
