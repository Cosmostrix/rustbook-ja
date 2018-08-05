## 共有状態の同時実行性

メッセージの受け渡しは、並行処理の優れた方法ですが、それだけではありません。
Go言語の開発資料の<ruby>送出<rt>スロー</rt></ruby>ガンのこの部分をもう一度「共有記憶で共有する」と考えてください。

共有記憶による通信はどのように見えますか？　
さらに、メッセージを伝える愛好家はなぜそれを使用せず、代わりにその逆を行うのでしょうか？　

ある種の<ruby>演譜<rt>プログラミング</rt></ruby>言語のチャネルは、一度値をチャネルに転送すると、その値を使用しないようにするため、単一の所有権と似ています。
共有<ruby>記憶域<rt>メモリー</rt></ruby>の同時実行性は、複数の所有権に似ています。複数の<ruby>走脈<rt>スレッド</rt></ruby>が同じ記憶位置に同時にアクセスできます。
第15章で導入したように、スマート<ruby>指し手<rt>ポインタ</rt></ruby>によって複数の所有権が可能になった場合、複数の所有者が管理を必要とするため、複数の所有権が複雑になります。
Rustの型体系と所有権のルールは、この管理を正しく行うのに大いに役立ちます。
例として、共有<ruby>記憶域<rt>メモリー</rt></ruby>のより一般的な並行処理基本型の1つであるmutexを見てみましょう。

### ミューテックスを使用して一度に1つの<ruby>走脈<rt>スレッド</rt></ruby>からデータへのアクセスを許可する

*ミューテックス*は*相互排除の*略語であり、ミューテックスは1つの<ruby>走脈<rt>スレッド</rt></ruby>のみがいつでも何らかのデータにアクセスすることを許す。
ミューテックス内のデータにアクセスするには、<ruby>走脈<rt>スレッド</rt></ruby>は最初にミューテックスの*ロック*を取得するように要求することによってアクセスを希望することを通知する必要があり*ます*。
ロックは、現在データに排他的にアクセスできる利用者を追跡するミューテックスの一部であるデータ構造です。
したがって、ミューテックスは、ロッキングシステムを介して保持しているデータを*保護*するものとして説明され*て*います。

ミューテックスは、2つのルールを覚えておく必要があるため、使いにくいという評判を持っています。

* データを使用する前に、ロックの取得を試みる必要があります。
* ミューテックスがガードするデータが終了したら、他の<ruby>走脈<rt>スレッド</rt></ruby>がロックを取得できるようにデータをロック解除する必要があります。

ミューテックスの現実的なメタファについては、1つのマイクロホンだけで会議でのパネルディスカッションを想像してみてください。
パネリストが話すことができる前に、それらはマイクを使用したいと尋ねるか、信号を送る必要があります。
彼らがマイクを手に入れたら、話したい次のパネリストにマイクを渡したいと思っている限り、話すことができます。
パネリストが終了したらマイクをオフにすることを忘れた場合、他の誰も話すことはできません。
共有マイクの管理が間違っていると、パネルは計画どおりに動作しません。

ミューテックスの管理は非常に難しいので、多くの人がチャネルに熱心である理由です。
しかし、Rustの型体系と所有権のおかげで、ロックとロック解除を間違えることはありません。

#### `Mutex<T>`のAPIは、

ミューテックスを使用する方法の例として、リスト16-12に示すように、単一<ruby>走脈<rt>スレッド</rt></ruby>・文脈でミューテックスを使用します。

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

<span class="caption">リスト16-12。簡単にするために、単一<ruby>走脈<rt>スレッド</rt></ruby>の文脈で<code>Mutex&lt;T&gt;</code> APIを探る</span>

多くの型と同様に、関連する機能`new`を使用して`Mutex<T>`を作成します。
ミューテックス内のデータにアクセスするには、`lock`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`lock`を取得します。
この呼び出しは現在の<ruby>走脈<rt>スレッド</rt></ruby>を<ruby>段落<rt>ブロック</rt></ruby>し、ロックを行うまでは何もできません。

`lock`を保持している別の<ruby>走脈<rt>スレッド</rt></ruby>がパニックに陥った場合、`lock`の呼び出しは失敗し`lock`。
その場合、誰もロックを取得することはできませんので、その状況にある場合には、この<ruby>走脈<rt>スレッド</rt></ruby>のパニックを`unwrap`ことにしました。

ロックを取得した後、`num`という名前の戻り値を内部のデータへの変更可能な参照として扱うことができます。
型体系は、の値を使用する前にロックを取得することを保証`m`。 `Mutex<i32>`ない`i32`ので、使用できるようにロックを取得*しなければならない* `i32`値。
忘れることができません。
型体系は、それ以外の場合は内部の`i32`アクセスさせません。

疑うように、`Mutex<T>`はスマートな<ruby>指し手<rt>ポインタ</rt></ruby>です。
より正確には、`lock`の呼び出しは`MutexGuard`というスマート<ruby>指し手<rt>ポインタ</rt></ruby>を*返します*。
このスマート<ruby>指し手<rt>ポインタ</rt></ruby>は、`Deref`をインナーデータを指すように実装します。
スマート<ruby>指し手<rt>ポインタ</rt></ruby>には、`MutexGuard`が範囲外になったときに自動的にロックを解除する`Drop`実装もあります（リスト16-12の内部<ruby>有効範囲<rt>スコープ</rt></ruby>の終わりで発生します）。
その結果、ロックの解放を忘れて、ロックの解放が自動的に行われるため、他の<ruby>走脈<rt>スレッド</rt></ruby>によってミューテックスが使用されるのを防ぐことができます。

ロックを解除した後、mutexの値を出力し、内側の`i32`を6に変更できたことを確認できます。

#### 複数の<ruby>走脈<rt>スレッド</rt></ruby>間の`Mutex<T>`共有

では、`Mutex<T>`を使用して複数の<ruby>走脈<rt>スレッド</rt></ruby>間で値を共有しようとします。
10個の<ruby>走脈<rt>スレッド</rt></ruby>をスピンアップし、カウンタの値を1ずつ増分するので、カウンタは0から10になります。次のいくつかの例では<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。これらの<ruby>誤り<rt>エラー</rt></ruby>を使用して、`Mutex<T>`とそれが正しく使用するのにRustがどのように役立つかを説明します。
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
次に、一連の数値を反復して10の<ruby>走脈<rt>スレッド</rt></ruby>を作成します。
`thread::spawn`を使用して、すべての<ruby>走脈<rt>スレッド</rt></ruby>に同じ<ruby>閉包<rt>クロージャー</rt></ruby>を与え、カウンタを<ruby>走脈<rt>スレッド</rt></ruby>に移動させ、`lock`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出して`Mutex<T>`ロックを取得してから、mutexの値に1を加算します。
<ruby>走脈<rt>スレッド</rt></ruby>が<ruby>閉包<rt>クロージャー</rt></ruby>を実行し終えると、`num`は<ruby>有効範囲<rt>スコープ</rt></ruby>から外れてロックを解放し、別の<ruby>走脈<rt>スレッド</rt></ruby>がロックを獲得できるようにします。

メイン<ruby>走脈<rt>スレッド</rt></ruby>では、すべての結合<ruby>手綱<rt>ハンドル</rt></ruby>を収集します。
リスト16-2で行ったよう`join`、各<ruby>手綱<rt>ハンドル</rt></ruby>に対して`join`を呼び出して、すべての<ruby>走脈<rt>スレッド</rt></ruby>が終了していることを確認します。
その時点で、メイン<ruby>走脈<rt>スレッド</rt></ruby>はロックを取得し、この<ruby>算譜<rt>プログラム</rt></ruby>の結果を出力します。

この例は<ruby>製譜<rt>コンパイル</rt></ruby>されないことを暗示しました。
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

<ruby>誤り<rt>エラー</rt></ruby>メッセージは、`counter`値が<ruby>閉包<rt>クロージャー</rt></ruby>に移動され、`lock`を呼び出すと捕獲されることを示し`lock`。
その説明は望むように聞こえるが、許可されていない！　

<ruby>算譜<rt>プログラム</rt></ruby>を単純化することでこれを理解しよう。
`for`ループで10個の<ruby>走脈<rt>スレッド</rt></ruby>を作成するのではなく、ループのない2つの<ruby>走脈<rt>スレッド</rt></ruby>を作成し、何が起こるかを見てみましょう。
<ruby>譜面<rt>コード</rt></ruby>リスト16-13の最初の`for`ループを代わりにこの<ruby>譜面<rt>コード</rt></ruby>に置き換えます。

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

2つの<ruby>走脈<rt>スレッド</rt></ruby>を作成し、2番目の<ruby>走脈<rt>スレッド</rt></ruby>で使用する変数名を`handle2`と`num2`変更します。
今回<ruby>譜面<rt>コード</rt></ruby>を実行すると、<ruby>製譜<rt>コンパイル</rt></ruby>によって次のようになります。

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
最初の<ruby>誤り<rt>エラー</rt></ruby>メッセージは、`counter`が`handle`関連付けられた<ruby>走脈<rt>スレッド</rt></ruby>の<ruby>閉包<rt>クロージャー</rt></ruby>に移動されたことを示します。
その動きは、`lock`を呼び出して2番目の<ruby>走脈<rt>スレッド</rt></ruby>の`num2`に結果を格納しようとすると、`counter`を捕獲できなくなります。
そこでRustは、`counter`所有権を複数の<ruby>走脈<rt>スレッド</rt></ruby>に移動することはできないと伝えています。
<ruby>走脈<rt>スレッド</rt></ruby>がループしていて、ループの異なる反復で異なる<ruby>走脈<rt>スレッド</rt></ruby>を指し示すことができないため、以前はこれを見るのが難しかったです。
第15章で説明した多重所有方法を使って<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りを修正しましょう。

#### 複数の<ruby>走脈<rt>スレッド</rt></ruby>を持つ複数の所有権

第15章では、スマート<ruby>指し手<rt>ポインタ</rt></ruby>`Rc<T>`を使用して複数の所有者に値を渡し、参照カウント値を作成しました。
ここでも同じことをして、何が起こるか見てみましょう。
リスト16-14の`Rc<T>`に`Mutex<T>`包み、所有権を<ruby>走脈<rt>スレッド</rt></ruby>に移す前に`Rc<T>`をクローンします。
この<ruby>誤り<rt>エラー</rt></ruby>を見たので、`for`ループの使用に戻って、`move`予約語を<ruby>閉包<rt>クロージャー</rt></ruby>で保持します。

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

<span class="caption">リスト16-14。複数の<ruby>走脈<rt>スレッド</rt></ruby>が<code>Mutex&lt;T&gt;</code>を所有できるように<code>Rc&lt;T&gt;</code>を使用しようとすると、</span>

もう一度、<ruby>製譜<rt>コンパイル</rt></ruby>して...違う<ruby>誤り<rt>エラー</rt></ruby>が出ます！　
<ruby>製譜器<rt>コンパイラー</rt></ruby>は私たちに多くのことを教えています。

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

うわー、その<ruby>誤り<rt>エラー</rt></ruby>メッセージは非常に言葉です！　
最初の行内<ruby>誤り<rt>エラー</rt></ruby>は、```std::rc::Rc<std::sync::Mutex<i32>>` cannot be sent between threads safely``。
その理由は次の重要な部分であり、<ruby>誤り<rt>エラー</rt></ruby>メッセージです。
蒸留された<ruby>誤り<rt>エラー</rt></ruby>メッセージは``the trait bound `Send` is not satisfied``。
次の章で`Send`について説明します。これは、<ruby>走脈<rt>スレッド</rt></ruby>で使用する型が同時の状況で使用されることを保証する<ruby>特性<rt>トレイト</rt></ruby>の1つです。

残念ながら、`Rc<T>`は<ruby>走脈<rt>スレッド</rt></ruby>間で共有することは安全ではありません。
`Rc<T>`が参照カウントを管理するとき、それは`clone`する各呼び出しのカウントに加算し、各複製が<ruby>脱落<rt>ドロップ</rt></ruby>したときのカウントから減算します。
しかし、カウントの変更が別の<ruby>走脈<rt>スレッド</rt></ruby>によって中断されないことを確認するために並行処理基本型を使用することはありません。
これは間違ったカウントにつながる可能性があります。微妙なバグは、記憶リークや値を落としてしまい、終了する前に終了する可能性があります。
必要とするのは、`Rc<T>`全く同じ型ですが、<ruby>走脈<rt>スレッド</rt></ruby>セーフな方法で参照カウントを変更するものです。

#### `Arc<T>`による原子参照カウント

幸運なことに、`Arc<T>` *は* `Rc<T>`ような型で、同時の状況でも安全に使用できます。
*a*は*原子を*表し、*原子* *的に参照カウントされる*型を意味します。
Atomicsは、並行処理基本型の追加の種類です。詳細については、`std::sync::atomic`の標準<ruby>譜集<rt>ライブラリー</rt></ruby>の開発資料を参照してください。
この時点で、アトミックは基本型のように機能するが、<ruby>走脈<rt>スレッド</rt></ruby>間で共有することは安全であることを知る必要があります。

なぜ、すべての基本型がアトミックでないのか、標準<ruby>譜集<rt>ライブラリー</rt></ruby>型が`Arc<T>`を自動的に使用するように実装されていないのはなぜだろうか。
理由は、<ruby>走脈<rt>スレッド</rt></ruby>の安全性には、本当に必要なときに支払うだけのパフォーマンスペナルティが伴うからです。
単一の<ruby>走脈<rt>スレッド</rt></ruby>内の値に対して操作を実行しているだけの場合、アトミックが提供する保証を強制型変換する必要がない場合、<ruby>譜面<rt>コード</rt></ruby>はより高速に実行できます。

`Arc<T>`と`Rc<T>`には同じAPIがありますので、`use`行、`new`への呼び出し、`clone`への呼び出しを変更して<ruby>算譜<rt>プログラム</rt></ruby>を修正します。
<ruby>譜面<rt>コード</rt></ruby>リスト16-15の<ruby>譜面<rt>コード</rt></ruby>が最終的に<ruby>製譜<rt>コンパイル</rt></ruby>され、実行されます。

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

<span class="caption">リスト16-15。 <code>Mutex&lt;T&gt;</code>を包みて複数の<ruby>走脈<rt>スレッド</rt></ruby>間で所有権を共有できるようにするために、 <code>Arc&lt;T&gt;</code>を使用する</span>

この<ruby>譜面<rt>コード</rt></ruby>は以下を出力します。

```text
Result: 10
```

やった！　
0から10までカウントしましたが、これはあまり印象的ではないかもしれませんが、`Mutex<T>`と<ruby>走脈<rt>スレッド</rt></ruby>の安全性について多くのことを教えてくれました。
また、この<ruby>算譜<rt>プログラム</rt></ruby>の構造を使用して、カウンタを増分するだけの複雑な操作を行うこともできます。
この戦略を使用すると、計算を独立した部分に分割し、それらの部分を<ruby>走脈<rt>スレッド</rt></ruby>間で分割し、`Mutex<T>`を使用して各<ruby>走脈<rt>スレッド</rt></ruby>が最終結果をその部分で更新するようにすることができます。

### `RefCell<T>`/`Rc<T>`と`Mutex<T>`/`Arc<T>` `Mutex<T>`との間の類似性は、

その`counter`が不変であることに気づいたかもしれませんが、内部の値を変更可能な参照を得ることができます。
これは、`Mutex<T>`が`Cell`ファミリのように内部の可変性を提供することを意味します。
第15章で`RefCell<T>`を使って`Rc<T>`内の内容を変更するのと同じ方法で、`Mutex<T>`を使用して`Arc<T>`内の内容を変更します。

注意すべきもう一つの細部は、`Mutex<T>`を使用すると、Rustはあらゆる種類の<ruby>論理<rt>ロジック</rt></ruby>誤りからあなたを守ることができないということです。
第15章で`Rc<T>`を使用すると、2つの`Rc<T>`値が互いに参照して記憶リークを引き起こす参照円環を作成するリスクがあることを思い出してください。
同様に、`Mutex<T>`は*デッドロック*を生成する危険性があります。
これらは、操作が2つの資源をロックする必要があり、2つの<ruby>走脈<rt>スレッド</rt></ruby>がそれぞれロックの1つを取得し、互いを永遠に待つときに発生します。
デッドロックに興味がある場合は、デッドロックのあるRust<ruby>算譜<rt>プログラム</rt></ruby>を作成してみてください。
mutexのためのデッドロック軽減戦略をあらゆる言語で研究し、Rustでそれらを実装することに行きます。
`Mutex<T>`および`MutexGuard`の標準<ruby>譜集<rt>ライブラリー</rt></ruby>API開発資料は、有用な情報を提供します。

この章では、`Send`と`Sync`<ruby>特性<rt>トレイト</rt></ruby>について説明し、それらを独自の型で使用する方法について説明します。
