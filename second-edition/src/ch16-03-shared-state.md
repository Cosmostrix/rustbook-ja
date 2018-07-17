## 共有状態の同時実行性

メッセージの受け渡しは、並行処理の優れた方法ですが、それだけではありません。
Go言語の開発資料の送出ガンのこの部分をもう一度「共有記憶で共有する」と考えてください。

共有記憶による通信はどのように見えますか？　
さらに、メッセージを伝える愛好家はなぜそれを使用せず、代わりにその逆を行うのでしょうか？　

ある種の演譜言語のチャネルは、一度値をチャネルに転送すると、その値を使用しないようにするため、単一の所有権と似ています。
共有記憶域の同時実行性は、複数の所有権に似ています。複数の走脈が同じ記憶位置に同時にアクセスできます。
第15章で導入したように、スマート指し手によって複数の所有権が可能になった場合、複数の所有者が管理を必要とするため、複数の所有権が複雑になります。
Rustの型の算系と所有権のルールは、この管理を正しく行うのに大いに役立ちます。
例として、共有記憶域のより一般的な並行処理基本型の1つであるmutexを見てみましょう。

### ミューテックスを使用して一度に1つの走脈からデータへのアクセスを許可する

*ミューテックス*は*相互排除の*略語であり、ミューテックスは1つの走脈のみがいつでも何らかのデータにアクセスすることを許す。
ミューテックス内のデータにアクセスするには、走脈は最初にミューテックスの*ロック*を取得するように要求することによってアクセスを希望することを通知する必要があり*ます*。
ロックは、現在データに排他的にアクセスできる利用者を追跡するミューテックスの一部であるデータ構造です。
したがって、ミューテックスは、ロッキング算系を介して保持しているデータを*保護*するものとして説明され*て*います。

ミューテックスは、2つのルールを覚えておく必要があるため、使いにくいという評判を持っています。

* データを使用する前に、ロックの取得を試みる必要があります。
* ミューテックスがガードするデータが終了したら、他の走脈がロックを取得できるようにデータをロック解除する必要があります。

ミューテックスの現実的なメタファについては、1つのマイクロホンだけで会議でのパネルディスカッションを想像してみてください。
パネリストが話すことができる前に、それらはマイクを使用したいと尋ねるか、信号を送る必要があります。
彼らがマイクを手に入れたら、話したい次のパネリストにマイクを渡したいと思っている限り、話すことができます。
パネリストが終了したらマイクをオフにすることを忘れた場合、他の誰も話すことはできません。
共有マイクの管理が間違っていると、パネルは計画どおりに動作しません。

ミューテックスの管理は非常に難しいので、多くの人がチャネルに熱心である理由です。
しかし、Rustの型の算系と所有権のおかげで、ロックとロック解除を間違えることはありません。

#### `Mutex<T>`のAPIは、

ミューテックスを使用する方法の例として、リスト16-12に示すように、単一走脈・文脈でミューテックスを使用します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);

    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }

    println!("m = {:?}", m);
}
```

<span class="caption">リスト16-12。簡単にするために、単一走脈の文脈で<code>Mutex&lt;T&gt;</code> APIを探る</span>

多くの型と同様に、関連する機能`new`を使用して`Mutex<T>`を作成します。
ミューテックス内のデータにアクセスするには、`lock`操作法を使用して`lock`を取得します。
この呼び出しは現在の走脈を段落し、ロックを行うまでは何もできません。

`lock`を保持している別の走脈がパニックに陥った場合、`lock`の呼び出しは失敗し`lock`。
その場合、誰もロックを取得することはできませんので、その状況にある場合には、この走脈のパニックを`unwrap`ことにしました。

ロックを取得した後、`num`という名前の戻り値を内部のデータへの変更可能な参照として扱うことができます。
型算系は、の値を使用する前にロックを取得することを保証`m`。 `Mutex<i32>`ない`i32`ので、使用できるようにロックを取得*しなければならない* `i32`値。
忘れることができません。
型算系は、それ以外の場合は内部の`i32`アクセスさせません。

疑うように、`Mutex<T>`はスマートな指し手です。
より正確には、`lock`の呼び出しは`MutexGuard`というスマート指し手を*返します*。
このスマート指し手は、`Deref`をインナーデータを指すように実装します。
スマート指し手には、`MutexGuard`が範囲外になったときに自動的にロックを解除する`Drop`実装もあります（リスト16-12の内部有効範囲の終わりで発生します）。
その結果、ロックの解放を忘れて、ロックの解放が自動的に行われるため、他の走脈によってミューテックスが使用されるのを防ぐことができます。

ロックを解除した後、mutexの値を出力し、内側の`i32`を6に変更できたことを確認できます。

#### 複数の走脈間の`Mutex<T>`共有

では、`Mutex<T>`を使用して複数の走脈間で値を共有しようとします。
10個の走脈をスピンアップし、カウンタの値を1ずつ増分するので、カウンタは0から10になります。次のいくつかの例では製譜器誤りが発生します。これらの誤りを使用して、`Mutex<T>`とそれが正しく使用するのにRustがどのように役立つかを説明します。
リスト16-13に、最初の例を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::sync::Mutex;
use std::thread;

fn main() {
    let counter = Mutex::new(0);
    let mut handles = vec![];

    for _ in 0..10 {
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

<span class="caption">リスト16-13。 <code>Mutex&lt;T&gt;</code>によって保護されたカウンタを増分する10個の走脈</span>

リスト16-12のように、`Mutex<T>`内に`i32`を保持する`counter`変数を作成します。
次に、一連の数値を反復して10の走脈を作成します。
`thread::spawn`を使用して、すべての走脈に同じ閉包を与え、カウンタを走脈に移動させ、`lock`操作法を呼び出して`Mutex<T>`ロックを取得してから、mutexの値に1を加算します。
走脈が閉包を実行し終えると、`num`は有効範囲から外れてロックを解放し、別の走脈がロックを獲得できるようにします。

メイン走脈では、すべての結合手綱を収集します。
リスト16-2で行ったよう`join`、各手綱に対して`join`を呼び出して、すべての走脈が終了していることを確認します。
その時点で、メイン走脈はロックを取得し、この算譜の結果を出力します。

この例は製譜されないことを暗示しました。
今、なぜそれを見つけよう！　

```text
error[E0382]: capture of moved value: `counter`
  --> src/main.rs:10:27
   |
9  |         let handle = thread::spawn(move || {
   |                                    ------- value moved (into closure) here
10 |             let mut num = counter.lock().unwrap();
   |                           ^^^^^^^ value captured here after move
   |
   = note: move occurs because `counter` has type `std::sync::Mutex<i32>`,
   which does not implement the `Copy` trait

error[E0382]: use of moved value: `counter`
  --> src/main.rs:21:29
   |
9  |         let handle = thread::spawn(move || {
   |                                    ------- value moved (into closure) here
...
21 |     println!("Result: {}", *counter.lock().unwrap());
   |                             ^^^^^^^ value used here after move
   |
   = note: move occurs because `counter` has type `std::sync::Mutex<i32>`,
   which does not implement the `Copy` trait

error: aborting due to 2 previous errors
```

誤りメッセージは、`counter`値が閉包に移動され、`lock`を呼び出すと捕獲されることを示し`lock`。
その説明は望むように聞こえるが、許可されていない！　

算譜を単純化することでこれを理解しよう。
`for`ループで10個の走脈を作成するのではなく、ループのない2つの走脈を作成し、何が起こるかを見てみましょう。
譜面リスト16-13の最初の`for`ループを代わりにこの譜面に置き換えます。

```rust,ignore
use std::sync::Mutex;
use std::thread;

fn main() {
    let counter = Mutex::new(0);
    let mut handles = vec![];

    let handle = thread::spawn(move || {
        let mut num = counter.lock().unwrap();

        *num += 1;
    });
    handles.push(handle);

    let handle2 = thread::spawn(move || {
        let mut num2 = counter.lock().unwrap();

        *num2 += 1;
    });
    handles.push(handle2);

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

2つの走脈を作成し、2番目の走脈で使用する変数名を`handle2`と`num2`変更します。
今回譜面を実行すると、製譜によって次のようになります。

```text
error[E0382]: capture of moved value: `counter`
  --> src/main.rs:16:24
   |
8  |     let handle = thread::spawn(move || {
   |                                ------- value moved (into closure) here
...
16 |         let mut num2 = counter.lock().unwrap();
   |                        ^^^^^^^ value captured here after move
   |
   = note: move occurs because `counter` has type `std::sync::Mutex<i32>`,
   which does not implement the `Copy` trait

error[E0382]: use of moved value: `counter`
  --> src/main.rs:26:29
   |
8  |     let handle = thread::spawn(move || {
   |                                ------- value moved (into closure) here
...
26 |     println!("Result: {}", *counter.lock().unwrap());
   |                             ^^^^^^^ value used here after move
   |
   = note: move occurs because `counter` has type `std::sync::Mutex<i32>`,
   which does not implement the `Copy` trait

error: aborting due to 2 previous errors
```

ああ！　
最初の誤りメッセージは、`counter`が`handle`関連付けられた走脈の閉包に移動されたことを示します。
その動きは、`lock`を呼び出して2番目の走脈の`num2`に結果を格納しようとすると、`counter`を捕獲できなくなります。
そこでRustは、`counter`所有権を複数の走脈に移動することはできないと伝えています。
走脈がループしていて、ループの異なる反復で異なる走脈を指し示すことができないため、以前はこれを見るのが難しかったです。
第15章で説明した多重所有方法を使って製譜器誤りを修正しましょう。

#### 複数の走脈を持つ複数の所有権

第15章では、スマート指し手`Rc<T>`を使用して複数の所有者に値を渡し、参照カウント値を作成しました。
ここでも同じことをして、何が起こるか見てみましょう。
リスト16-14の`Rc<T>`に`Mutex<T>`包み、所有権を走脈に移す前に`Rc<T>`をクローンします。
この誤りを見たので、`for`ループの使用に戻って、`move`予約語を閉包で保持します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::rc::Rc;
use std::sync::Mutex;
use std::thread;

fn main() {
    let counter = Rc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Rc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

<span class="caption">リスト16-14。複数の走脈が<code>Mutex&lt;T&gt;</code>を所有できるように<code>Rc&lt;T&gt;</code>を使用しようとすると、</span>

もう一度、製譜して...違う誤りが出ます！　
製譜器は私たちに多くのことを教えています。

```text
error[E0277]: the trait bound `std::rc::Rc<std::sync::Mutex<i32>>:
std::marker::Send` is not satisfied in `[closure@src/main.rs:11:36:
15:10 counter:std::rc::Rc<std::sync::Mutex<i32>>]`
  --> src/main.rs:11:22
   |
11 |         let handle = thread::spawn(move || {
   |                      ^^^^^^^^^^^^^ `std::rc::Rc<std::sync::Mutex<i32>>`
cannot be sent between threads safely
   |
   = help: within `[closure@src/main.rs:11:36: 15:10
counter:std::rc::Rc<std::sync::Mutex<i32>>]`, the trait `std::marker::Send` is
not implemented for `std::rc::Rc<std::sync::Mutex<i32>>`
   = note: required because it appears within the type
`[closure@src/main.rs:11:36: 15:10 counter:std::rc::Rc<std::sync::Mutex<i32>>]`
   = note: required by `std::thread::spawn`
```

うわー、その誤りメッセージは非常に言葉です！　
最初のイン行誤りは、```std::rc::Rc<std::sync::Mutex<i32>>` cannot be sent between threads safely``。
その理由は次の重要な部分であり、誤りメッセージです。
蒸留された誤りメッセージは``the trait bound `Send` is not satisfied``。
次の章で`Send`について説明します。これは、走脈で使用する型が同時の状況で使用されることを保証する特性の1つです。

残念ながら、`Rc<T>`は走脈間で共有することは安全ではありません。
`Rc<T>`が参照カウントを管理するとき、それは`clone`する各呼び出しのカウントに加算し、各複製が脱落したときのカウントから減算します。
しかし、カウントの変更が別の走脈によって中断されないことを確認するために並行処理基本型を使用することはありません。
これは間違ったカウントにつながる可能性があります。微妙なバグは、記憶リークや値を落としてしまい、終了する前に終了する可能性があります。
必要とするのは、`Rc<T>`全く同じ型ですが、走脈セーフな方法で参照カウントを変更するものです。

#### `Arc<T>`による原子参照カウント

幸運なことに、`Arc<T>` *は* `Rc<T>`ような型で、同時の状況でも安全に使用できます。
*a*は*原子を*表し、*原子* *的に参照カウントされる*型を意味します。
Atomicsは、並行処理基本型の追加の種類です。詳細については、`std::sync::atomic`の標準譜集の開発資料を参照してください。
この時点で、アトミックは基本型のように機能するが、走脈間で共有することは安全であることを知る必要があります。

なぜ、すべての基本型がアトミックでないのか、標準譜集型が`Arc<T>`を自動的に使用するように実装されていないのはなぜだろうか。
理由は、走脈の安全性には、本当に必要なときに支払うだけのパフォーマンスペナルティが伴うからです。
単一の走脈内の値に対して操作を実行しているだけの場合、アトミックが提供する保証を強制型変換する必要がない場合、譜面はより高速に実行できます。

`Arc<T>`と`Rc<T>`には同じAPIがありますので、`use`行、`new`への呼び出し、`clone`への呼び出しを変更して算譜を修正します。
譜面リスト16-15の譜面が最終的に製譜され、実行されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::sync::{Mutex, Arc};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();

            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```

<span class="caption">リスト16-15。 <code>Mutex&lt;T&gt;</code>を包みて複数の走脈間で所有権を共有できるようにするために、 <code>Arc&lt;T&gt;</code>を使用する</span>

この譜面は以下を出力します。

```text
Result: 10
```

やった！　
0から10までカウントしましたが、これはあまり印象的ではないかもしれませんが、`Mutex<T>`と走脈の安全性について多くのことを教えてくれました。
また、この算譜の構造を使用して、カウンタを増分するだけの複雑な操作を行うこともできます。
この戦略を使用すると、計算を独立した部分に分割し、それらの部分を走脈間で分割し、`Mutex<T>`を使用して各走脈が最終結果をその部分で更新するようにすることができます。

### `RefCell<T>`/`Rc<T>`と`Mutex<T>`/`Arc<T>` `Mutex<T>`との間の類似性は、

その`counter`が不変であることに気づいたかもしれませんが、内部の値を変更可能な参照を得ることができます。
これは、`Mutex<T>`が`Cell`ファミリのように内部の可変性を提供することを意味します。
第15章で`RefCell<T>`を使って`Rc<T>`内の内容を変更するのと同じ方法で、`Mutex<T>`を使用して`Arc<T>`内の内容を変更します。

注意すべきもう一つの細部は、`Mutex<T>`を使用すると、Rustはあらゆる種類の論理誤りからあなたを守ることができないということです。
第15章で`Rc<T>`を使用すると、2つの`Rc<T>`値が互いに参照して記憶リークを引き起こす参照円環を作成するリスクがあることを思い出してください。
同様に、`Mutex<T>`は*デッドロック*を生成する危険性があります。
これらは、操作が2つの資源をロックする必要があり、2つの走脈がそれぞれロックの1つを取得し、互いを永遠に待つときに発生します。
デッドロックに興味がある場合は、デッドロックのあるRust算譜を作成してみてください。
mutexのためのデッドロック軽減戦略をあらゆる言語で研究し、Rustでそれらを実装することに行きます。
`Mutex<T>`および`MutexGuard`の標準譜集API開発資料は、有用な情報を提供します。

この章では、`Send`と`Sync`特性について説明し、それらを独自の型で使用する方法について説明します。
