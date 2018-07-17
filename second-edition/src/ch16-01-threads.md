## 走脈を使用した譜面の同時実行

ほとんどの現在の基本算系では、実行された算譜の譜面は*過程*内で実行され、基本算系は複数の過程を一度に管理します。
算譜内では、同時に実行する独立したパーツを使用することもできます。
これらの独立した部分を実行する機能を*走脈*と呼びます。

算譜内の計算を複数の走脈に分割すると、算譜が同時に複数の仕事を実行するためパフォーマンスが向上しますが、複雑さも増します。
走脈は同時に実行できるので、異なる走脈上の譜面の部分が実行される順番は本質的に保証されていません。
これにより、次のような問題が発生する可能性があります。

* 走脈がデータまたは資源に一貫性のない順序でアクセスしている競合条件
* デッドロック.2つの走脈が、互いが他の走脈が持つ資源の使用を終了するのを待っているため、両方の走脈が継続しない
* 特定の状況でのみ発生し、確実に再現して固定するのが難しいバグ

Rustは走脈の使用による悪影響を緩和しようとしますが、多脈処理文脈での演譜は注意深く考えており、単一走脈で実行されている算譜とは異なる譜面構造を必要とします。

演譜言語は、いくつかの異なる方法で走脈を実装します。
多くの基本算系では、新しい走脈を作成するためのAPIが提供されています。
言語が基本算系APIを呼び出して走脈を作成するこの模型は、時には*1。1*と呼ばれ、1つの言語走脈あたり1つの基本算系走脈を意味します。

多くの演譜言語は、独自の走脈の実装を提供しています。
演譜言語提供走脈は*緑色*走脈と呼ばれ、これらの緑色走脈を使用する言語は異なる数の基本算系走脈の文脈で実行されます。
このため、緑色走脈模型は*M。N*模型と呼ばれ*ます。N* `N`基本算系走脈ごとに`M`緑色走脈があります`M`と`N`は必ずしも同じ数ではありません。

各模型には独自の利点と相殺取引があり、Rustにとって最も重要な相殺取引は実行時サポートです。
*実行時*は混乱する用語であり、異なる文脈で異なる意味を持つことができます。

この文脈では、*実行時に*は、すべての二進譜に言語によって含まれる譜面を意味します。
この譜面は言語に応じて大きくても小さくても構いませんが、すべての非アセンブリ言語にはある程度の実行時譜面が含まれます。
そのため、言語が「実行時がない」と言い表せば、「実行時が小さい」ことを意味します。実行時が小さくなると機能は少なくなりますが、二進譜が小さくなる利点があり、言語を他の言語と組み合わせやすくなりますより多くの文脈で。
多くの言語は、より多くの機能と引き換えに実行時サイズを増やしても問題ありませんが、Rustは実行時をほとんど必要とせず、パフォーマンスを維持するためにCを呼び出すことができます。

グリーン走脈のM。N模型では、走脈を管理するための言語実行時が必要です。
そのため、Rust標準譜集は1。1走脈の実装のみを提供します。
Rustはそのような低水準言語なので、走脈の実行時間を制御し、文脈切り替えのコストを削減するなどの面でオーバーヘッドを交換する場合は、M。N走脈を実装するひな型があります。

Rustで走脈を定義したので、標準譜集で提供されている走脈関連APIを使用する方法を探そう。

### `spawn`新しい走脈を作成`spawn`

新しい走脈を作成するには、`thread::spawn`機能を呼び出し、新しい走脈で実行したい譜面を含む閉包（第13章の閉包について説明しました）を渡します。
譜面リスト16-1の例は、メイン走脈のテキストと新しい走脈の他のテキストを出力します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

<span class="caption">リスト16-1。メイン走脈が何か他のものを印字している間に1つのものを出力する新しい走脈を作成する</span>

この機能では、実行が終了したかどうかにかかわらず、メイン走脈が終了すると新しい走脈が停止することに注意してください。
この算譜の出力は毎回少しずつ異なるかもしれませんが、次のようになります。

```text
hi number 1 from the main thread!
hi number 1 from the spawned thread!
hi number 2 from the main thread!
hi number 2 from the spawned thread!
hi number 3 from the main thread!
hi number 3 from the spawned thread!
hi number 4 from the main thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
```

`thread::sleep`への呼び出しは、実行を短期間停止し、別の走脈が実行できるようにします。
走脈はおそらく順番に実行されますが、それは保証されません。基本算系が走脈をスケジュールする方法によって異なります。
この実行では、生成された走脈のprint文が譜面の最初に表示されていても、メイン走脈が最初に印字されます。
そして、`i`が9になるまで、生成された走脈に印字するように指示したとしても、メイン走脈がシャットダウンする前に5にしか達しませんでした。

この譜面を実行してメイン走脈の出力のみを表示するか、重複が見られない場合は、範囲内の数値を増やして、基本算系が走脈間で切り替える機会を増やしてみてください。

### `join`手綱を使用してすべての走脈が終了するのを待つ

譜面リスト16-1の譜面は、主走脈の終了のために主に生成された走脈を早期に停止するだけでなく、生成された走脈がまったく実行されることを保証することもできません。
その理由は、走脈が実行される順序には保証がないからです！　

`thread::spawn`戻り値を変数に保存することで、`thread::spawn`れた`thread::spawn`が実行されない、または完全に実行されない問題を修正できます。
`thread::spawn`の戻り値の型は`JoinHandle`です。
`JoinHandle`は所有している値で、`join`操作法を呼び出すと、その走脈が終了するのを待ちます。
16-2をリストの使用方法を示し`JoinHandle`リスト16-1で作成した走脈のをと呼んで`join`前に必ず生成された走脈が終了を作るために`main`終了します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }

    handle.join().unwrap();
}
```

<span class="caption">リスト16-2。 <code>thread::spawn</code>から<code>JoinHandle</code>を保存して、走脈が完了したことを保証する</span>

手綱で`join`を呼び出すと、手綱によって表される走脈が終了するまで現在実行中の走脈が段落されます。
走脈を*段落*すると、走脈が作業を実行したり終了したりすることができなくなります。
メイン走脈の`for`ループの後に`join`呼び出すので、リスト16-2を実行すると次のような出力が生成されます。

```text
hi number 1 from the main thread!
hi number 2 from the main thread!
hi number 1 from the spawned thread!
hi number 3 from the main thread!
hi number 2 from the spawned thread!
hi number 4 from the main thread!
hi number 3 from the spawned thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
hi number 6 from the spawned thread!
hi number 7 from the spawned thread!
hi number 8 from the spawned thread!
hi number 9 from the spawned thread!
```

2つの走脈は交互に継続しますが、メイン走脈は`handle.join()`呼び出しのために待機し、生成された走脈が終了するまで終了しません。

しかし、代わりに移動するときに何が起こるか見てみましょう`handle.join()`する前に`for`にループ`main`のように、。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    handle.join().unwrap();

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

メイン走脈は、生成された走脈が終了してから`for`ループを実行するのを待つため、ここで示すように、出力はもうインターリーブされません。

```text
hi number 1 from the spawned thread!
hi number 2 from the spawned thread!
hi number 3 from the spawned thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
hi number 6 from the spawned thread!
hi number 7 from the spawned thread!
hi number 8 from the spawned thread!
hi number 9 from the spawned thread!
hi number 1 from the main thread!
hi number 2 from the main thread!
hi number 3 from the main thread!
hi number 4 from the main thread!
```

`join`が呼び出される場所などの細かい詳細は、走脈が同時に実行されるかどうかに影響を与えます。

### 走脈での`move`閉包の使用

`move`閉包は、`thread::spawn`と一緒に使用されることがよくあります。これは、別の走脈のある走脈のデータを使用できるように`thread::spawn`ためです。

第13章では、閉包のパラメータリストの前に`move`予約語を使用して、閉包が環境内で使用する値の所有権を持つようにすることを説明しました。
この技法は、値の所有権をある走脈から別の走脈に移すために新しい走脈を作成するときに特に便利です。

譜面リスト16-1で、`thread::spawn`渡す閉包は引数をとりません。生成された走脈の譜面のメイン走脈からのデータは使用していません。
生成された走脈のメイン走脈のデータを使用するには、生成された走脈の閉包が必要な値を取得する必要があります。
譜面リスト16-3は、メイン走脈でベクトルを作成し、それを生成した走脈で使用する試みを示しています。
しかし、これはすぐには分かりませんが、まだ動作しません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(|| {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}
```

<span class="caption">リスト16-3。メイン走脈によって作成されたベクトルを別の走脈で使用しようとする</span>

閉包は使用しています`v`、それが捕獲されます`v`、その閉包の環境の一部にします。
`thread::spawn`は新しい走脈でこの閉包を実行`thread::spawn`ので、その新しい走脈の中で`v`にアクセスできるはずです。
しかし、この例を製譜すると、次の誤りが発生します。

```text
error[E0373]: closure may outlive the current function, but it borrows `v`,
which is owned by the current function
 --> src/main.rs:6:32
  |
6 |     let handle = thread::spawn(|| {
  |                                ^^ may outlive borrowed value `v`
7 |         println!("Here's a vector: {:?}", v);
  |                                           - `v` is borrowed here
  |
help: to force the closure to take ownership of `v` (and any other referenced
variables), use the `move` keyword
  |
6 |     let handle = thread::spawn(move || {
  |                                ^^^^^^^
```

Rust *は* `v`を捕獲する方法を*推測*し、`println!`は`v`への参照のみを必要とするため、閉包は`v`を借用ようとします。
しかし、問題があります。Rustは生成された走脈がどれくらい実行されるかを知ることができないので、`v`への参照が常に有効かどうかはわかりません。

譜面リスト16-4は、有効でない`v`への参照を持つ可能性の高い場合を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(|| {
        println!("Here's a vector: {:?}", v);
    });

#//    drop(v); // oh no!
    drop(v); // あらいやだ！　

    handle.join().unwrap();
}
```

<span class="caption">リスト16-4。参照捕獲しようと閉包との走脈<code>v</code>低下メイン走脈から<code>v</code></span>

この譜面を実行することが許可された場合、生成された走脈は、まったく実行せずにすぐに背景に置かれる可能性があります。
生成された走脈は`v`内部参照を持ちますが、第15章で説明した`drop`機能を使用して、メイン走脈は直ちに`v`を`drop`ます。次に、生成された走脈が実行を開始すると`v`は無効になるので、無効です。
あらいやだ！　

リスト16-3の製譜器誤りを修正するために、誤りメッセージのアドバイスを使用できます。

```text
help: to force the closure to take ownership of `v` (and any other referenced
variables), use the `move` keyword
  |
6 |     let handle = thread::spawn(move || {
  |                                ^^^^^^^
```

閉包の前に`move`予約語を追加する`move`で、クロストは値を借りるべきであるとRustが推測するのではなく、閉包が使用している値の所有権を持つように強制型変換します。
リスト16-5のリスト16-3の変更は、意図したとおりに製譜され、実行されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}
```

<span class="caption">リスト16-5。 <code>move</code>予約語を使って閉包が使用する値の所有権を持つようにする</span>

譜面リスト16-4の譜面には、`move`閉包を使用した場合にメイン走脈が`drop`と呼ばれる部分はどう`move`ますか？　
う`move`その場合を修正？　
残念だけど違う;
リスト16-4で実行しようとしている処理が異なる理由で許可されていないため、別の誤りが発生します。
閉包に`move`を追加`move`と、`v`を閉包の環境に移動し、メイン走脈でも`v`を`drop`することはできません。
代わりに、この製譜器誤りが発生します。

```text
error[E0382]: use of moved value: `v`
  --> src/main.rs:10:10
   |
6  |     let handle = thread::spawn(move || {
   |                                ------- value moved (into closure) here
...
#//10 |     drop(v); // oh no!
10 |     drop(v); // あらいやだ！　
   |          ^ value used here after move
   |
   = note: move occurs because `v` has type `std::vec::Vec<i32>`, which does
   not implement the `Copy` trait
```

Rustの所有権ルールは私たちをもう一度救った！　
Rustは控えめで、走脈に対して`v`を借用しているだけなので、リスト16-3の譜面から誤りが発生しました。これは、主走脈が理論的に生成された走脈の参照を無効にできることを意味します。
Rustに`v`所有権をspawnされた走脈に移すように指示することで、メイン走脈はもはや`v`使用しないことをRustに保証します。
同じ方法でリスト16-4を変更した場合、主走脈で`v`を使用しようとすると所有権の規則に違反します。
`move`予約語は、Rustの控えめな黙用の借用を上書きします。
所有権のルールに違反することは許されません。

走脈と走脈APIの基本を理解して、走脈で*何*ができるかを見てみましょう。
