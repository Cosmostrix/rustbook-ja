## <ruby>走脈<rt>スレッド</rt></ruby>を使用した<ruby>譜面<rt>コード</rt></ruby>の同時実行

ほとんどの現在の<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>では、実行された<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>は*過程*内で実行され、<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>は複数の過程を一度に管理します。
<ruby>算譜<rt>プログラム</rt></ruby>内では、同時に実行する独立したパーツを使用することもできます。
これらの独立した部分を実行する機能を*<ruby>走脈<rt>スレッド</rt></ruby>*と呼びます。

<ruby>算譜<rt>プログラム</rt></ruby>内の計算を複数の<ruby>走脈<rt>スレッド</rt></ruby>に分割すると、<ruby>算譜<rt>プログラム</rt></ruby>が同時に複数の仕事を実行するためパフォーマンスが向上しますが、複雑さも増します。
<ruby>走脈<rt>スレッド</rt></ruby>は同時に実行できるので、異なる<ruby>走脈<rt>スレッド</rt></ruby>上の<ruby>譜面<rt>コード</rt></ruby>の部分が実行される順番は本質的に保証されていません。
これにより、次のような問題が発生する可能性があります。

* <ruby>走脈<rt>スレッド</rt></ruby>がデータまたは資源に一貫性のない順序でアクセスしている競合条件
* デッドロック.2つの<ruby>走脈<rt>スレッド</rt></ruby>が、互いが他の<ruby>走脈<rt>スレッド</rt></ruby>が持つ資源の使用を終了するのを待っているため、両方の<ruby>走脈<rt>スレッド</rt></ruby>が継続しない
* 特定の状況でのみ発生し、確実に再現して固定するのが難しいバグ

Rustは<ruby>走脈<rt>スレッド</rt></ruby>の使用による悪影響を緩和しようとしますが、<ruby>多脈処理<rt>マルチスレッド</rt></ruby>文脈での<ruby>演譜<rt>プログラミング</rt></ruby>は注意深く考えており、単一<ruby>走脈<rt>スレッド</rt></ruby>で実行されている<ruby>算譜<rt>プログラム</rt></ruby>とは異なる<ruby>譜面<rt>コード</rt></ruby>構造を必要とします。

<ruby>演譜<rt>プログラミング</rt></ruby>言語は、いくつかの異なる方法で<ruby>走脈<rt>スレッド</rt></ruby>を実装します。
多くの<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>では、新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成するためのAPIが提供されています。
言語が<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>APIを呼び出して<ruby>走脈<rt>スレッド</rt></ruby>を作成するこの模型は、時には*1。1*と呼ばれ、1つの言語<ruby>走脈<rt>スレッド</rt></ruby>あたり1つの<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>走脈を意味します。

多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語は、独自の<ruby>走脈<rt>スレッド</rt></ruby>の実装を提供しています。
<ruby>演譜<rt>プログラミング</rt></ruby>言語提供<ruby>走脈<rt>スレッド</rt></ruby>は*緑色*<ruby>走脈<rt>スレッド</rt></ruby>と呼ばれ、これらの緑色<ruby>走脈<rt>スレッド</rt></ruby>を使用する言語は異なる数の<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>走脈の文脈で実行されます。
このため、緑色<ruby>走脈<rt>スレッド</rt></ruby>模型は*M。N*模型と呼ばれ*ます。N* `N`<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>走脈ごとに`M`緑色<ruby>走脈<rt>スレッド</rt></ruby>があります`M`と`N`は必ずしも同じ数ではありません。

各模型には独自の利点と<ruby>相殺取引<rt>トレードオフ</rt></ruby>があり、Rustにとって最も重要な<ruby>相殺取引<rt>トレードオフ</rt></ruby>は実行時サポートです。
*実行時*は混乱する用語であり、異なる文脈で異なる意味を持つことができます。

この文脈では、*実行時に*は、すべての<ruby>二進譜<rt>バイナリ</rt></ruby>に言語によって含まれる<ruby>譜面<rt>コード</rt></ruby>を意味します。
この<ruby>譜面<rt>コード</rt></ruby>は言語に応じて大きくても小さくても構いませんが、すべての非アセンブリ言語にはある程度の実行時<ruby>譜面<rt>コード</rt></ruby>が含まれます。
そのため、言語が「実行時がない」と言い表せば、「実行時が小さい」ことを意味します。実行時が小さくなると機能は少なくなりますが、<ruby>二進譜<rt>バイナリ</rt></ruby>が小さくなる利点があり、言語を他の言語と組み合わせやすくなりますより多くの文脈で。
多くの言語は、より多くの機能と引き換えに実行時サイズを増やしても問題ありませんが、Rustは実行時をほとんど必要とせず、パフォーマンスを維持するためにCを呼び出すことができます。

グリーン<ruby>走脈<rt>スレッド</rt></ruby>のM。N模型では、<ruby>走脈<rt>スレッド</rt></ruby>を管理するための言語実行時が必要です。
そのため、Rust標準<ruby>譜集<rt>ライブラリー</rt></ruby>は1。1<ruby>走脈<rt>スレッド</rt></ruby>の実装のみを提供します。
Rustはそのような低水準言語なので、<ruby>走脈<rt>スレッド</rt></ruby>の実行時間を制御し、文脈切り替えのコストを削減するなどの面でオーバーヘッドを交換する場合は、M。N<ruby>走脈<rt>スレッド</rt></ruby>を実装する<ruby>ひな型<rt>テンプレート</rt></ruby>があります。

Rustで<ruby>走脈<rt>スレッド</rt></ruby>を定義したので、標準<ruby>譜集<rt>ライブラリー</rt></ruby>で提供されている<ruby>走脈<rt>スレッド</rt></ruby>関連APIを使用する方法を探そう。

### `spawn`新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成`spawn`

新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成するには、`thread::spawn`機能を呼び出し、新しい<ruby>走脈<rt>スレッド</rt></ruby>で実行したい<ruby>譜面<rt>コード</rt></ruby>を含む<ruby>閉包<rt>クロージャー</rt></ruby>（第13章の<ruby>閉包<rt>クロージャー</rt></ruby>について説明しました）を渡します。
<ruby>譜面<rt>コード</rt></ruby>リスト16-1の例は、メイン<ruby>走脈<rt>スレッド</rt></ruby>のテキストと新しい<ruby>走脈<rt>スレッド</rt></ruby>の他のテキストを出力します。

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

<span class="caption">リスト16-1。メイン<ruby>走脈<rt>スレッド</rt></ruby>が何か他のものを<ruby>印字<rt>プリント</rt></ruby>している間に1つのものを出力する新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成する</span>

この機能では、実行が終了したかどうかにかかわらず、メイン<ruby>走脈<rt>スレッド</rt></ruby>が終了すると新しい<ruby>走脈<rt>スレッド</rt></ruby>が停止することに注意してください。
この<ruby>算譜<rt>プログラム</rt></ruby>の出力は毎回少しずつ異なるかもしれませんが、次のようになります。

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

`thread::sleep`への呼び出しは、実行を短期間停止し、別の<ruby>走脈<rt>スレッド</rt></ruby>が実行できるようにします。
<ruby>走脈<rt>スレッド</rt></ruby>はおそらく順番に実行されますが、それは保証されません。<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>が<ruby>走脈<rt>スレッド</rt></ruby>をスケジュールする方法によって異なります。
この実行では、生成された<ruby>走脈<rt>スレッド</rt></ruby>のprint文が<ruby>譜面<rt>コード</rt></ruby>の最初に表示されていても、メイン<ruby>走脈<rt>スレッド</rt></ruby>が最初に<ruby>印字<rt>プリント</rt></ruby>されます。
そして、`i`が9になるまで、生成された<ruby>走脈<rt>スレッド</rt></ruby>に<ruby>印字<rt>プリント</rt></ruby>するように指示したとしても、メイン<ruby>走脈<rt>スレッド</rt></ruby>がシャットダウンする前に5にしか達しませんでした。

この<ruby>譜面<rt>コード</rt></ruby>を実行してメイン<ruby>走脈<rt>スレッド</rt></ruby>の出力のみを表示するか、重複が見られない場合は、範囲内の数値を増やして、<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>が<ruby>走脈<rt>スレッド</rt></ruby>間で切り替える機会を増やしてみてください。

### `join`<ruby>手綱<rt>ハンドル</rt></ruby>を使用してすべての<ruby>走脈<rt>スレッド</rt></ruby>が終了するのを待つ

<ruby>譜面<rt>コード</rt></ruby>リスト16-1の<ruby>譜面<rt>コード</rt></ruby>は、主<ruby>走脈<rt>スレッド</rt></ruby>の終了のために主に生成された<ruby>走脈<rt>スレッド</rt></ruby>を早期に停止するだけでなく、生成された<ruby>走脈<rt>スレッド</rt></ruby>がまったく実行されることを保証することもできません。
その理由は、<ruby>走脈<rt>スレッド</rt></ruby>が実行される順序には保証がないからです！　

`thread::spawn`戻り値を変数に保存することで、`thread::spawn`れた`thread::spawn`が実行されない、または完全に実行されない問題を修正できます。
`thread::spawn`の戻り値の型は`JoinHandle`です。
`JoinHandle`は所有している値で、`join`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すと、その<ruby>走脈<rt>スレッド</rt></ruby>が終了するのを待ちます。
16-2をリストの使用方法を示し`JoinHandle`リスト16-1で作成した<ruby>走脈<rt>スレッド</rt></ruby>のをと呼んで`join`前に必ず生成された<ruby>走脈<rt>スレッド</rt></ruby>が終了を作るために`main`終了します。

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

<span class="caption">リスト16-2。 <code>thread::spawn</code>から<code>JoinHandle</code>を保存して、<ruby>走脈<rt>スレッド</rt></ruby>が完了したことを保証する</span>

<ruby>手綱<rt>ハンドル</rt></ruby>で`join`を呼び出すと、<ruby>手綱<rt>ハンドル</rt></ruby>によって表される<ruby>走脈<rt>スレッド</rt></ruby>が終了するまで現在実行中の<ruby>走脈<rt>スレッド</rt></ruby>が<ruby>段落<rt>ブロック</rt></ruby>されます。
<ruby>走脈<rt>スレッド</rt></ruby>を*<ruby>段落<rt>ブロック</rt></ruby>*すると、<ruby>走脈<rt>スレッド</rt></ruby>が作業を実行したり終了したりすることができなくなります。
メイン<ruby>走脈<rt>スレッド</rt></ruby>の`for`ループの後に`join`呼び出すので、リスト16-2を実行すると次のような出力が生成されます。

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

2つの<ruby>走脈<rt>スレッド</rt></ruby>は交互に継続しますが、メイン<ruby>走脈<rt>スレッド</rt></ruby>は`handle.join()`呼び出しのために待機し、生成された<ruby>走脈<rt>スレッド</rt></ruby>が終了するまで終了しません。

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

メイン<ruby>走脈<rt>スレッド</rt></ruby>は、生成された<ruby>走脈<rt>スレッド</rt></ruby>が終了してから`for`ループを実行するのを待つため、ここで示すように、出力はもうインターリーブされません。

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

`join`が呼び出される場所などの細かい詳細は、<ruby>走脈<rt>スレッド</rt></ruby>が同時に実行されるかどうかに影響を与えます。

### <ruby>走脈<rt>スレッド</rt></ruby>での`move`<ruby>閉包<rt>クロージャー</rt></ruby>の使用

`move`<ruby>閉包<rt>クロージャー</rt></ruby>は、`thread::spawn`と一緒に使用されることがよくあります。これは、別の<ruby>走脈<rt>スレッド</rt></ruby>のある<ruby>走脈<rt>スレッド</rt></ruby>のデータを使用できるように`thread::spawn`ためです。

第13章では、<ruby>閉包<rt>クロージャー</rt></ruby>のパラメータリストの前に`move`予約語を使用して、<ruby>閉包<rt>クロージャー</rt></ruby>が環境内で使用する値の所有権を持つようにすることを説明しました。
この技法は、値の所有権をある<ruby>走脈<rt>スレッド</rt></ruby>から別の<ruby>走脈<rt>スレッド</rt></ruby>に移すために新しい<ruby>走脈<rt>スレッド</rt></ruby>を作成するときに特に便利です。

<ruby>譜面<rt>コード</rt></ruby>リスト16-1で、`thread::spawn`渡す<ruby>閉包<rt>クロージャー</rt></ruby>は引数をとりません。生成された<ruby>走脈<rt>スレッド</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>のメイン<ruby>走脈<rt>スレッド</rt></ruby>からのデータは使用していません。
生成された<ruby>走脈<rt>スレッド</rt></ruby>のメイン<ruby>走脈<rt>スレッド</rt></ruby>のデータを使用するには、生成された<ruby>走脈<rt>スレッド</rt></ruby>の<ruby>閉包<rt>クロージャー</rt></ruby>が必要な値を取得する必要があります。
<ruby>譜面<rt>コード</rt></ruby>リスト16-3は、メイン<ruby>走脈<rt>スレッド</rt></ruby>でベクトルを作成し、それを生成した<ruby>走脈<rt>スレッド</rt></ruby>で使用する試みを示しています。
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

<span class="caption">リスト16-3。メイン<ruby>走脈<rt>スレッド</rt></ruby>によって作成されたベクトルを別の<ruby>走脈<rt>スレッド</rt></ruby>で使用しようとする</span>

<ruby>閉包<rt>クロージャー</rt></ruby>は使用しています`v`、それが捕獲されます`v`、その<ruby>閉包<rt>クロージャー</rt></ruby>の環境の一部にします。
`thread::spawn`は新しい<ruby>走脈<rt>スレッド</rt></ruby>でこの<ruby>閉包<rt>クロージャー</rt></ruby>を実行`thread::spawn`ので、その新しい<ruby>走脈<rt>スレッド</rt></ruby>の中で`v`にアクセスできるはずです。
しかし、この例を<ruby>製譜<rt>コンパイル</rt></ruby>すると、次の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

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

Rust *は* `v`を捕獲する方法を*推測*し、`println!`は`v`への参照のみを必要とするため、<ruby>閉包<rt>クロージャー</rt></ruby>は`v`を借用ようとします。
しかし、問題があります。Rustは生成された<ruby>走脈<rt>スレッド</rt></ruby>がどれくらい実行されるかを知ることができないので、`v`への参照が常に有効かどうかはわかりません。

<ruby>譜面<rt>コード</rt></ruby>リスト16-4は、有効でない`v`への参照を持つ可能性の高い場合を示しています。

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

<span class="caption">リスト16-4。参照捕獲しようと<ruby>閉包<rt>クロージャー</rt></ruby>との走脈<code>v</code>低下メイン<ruby>走脈<rt>スレッド</rt></ruby>から<code>v</code></span>

この<ruby>譜面<rt>コード</rt></ruby>を実行することが許可された場合、生成された<ruby>走脈<rt>スレッド</rt></ruby>は、まったく実行せずにすぐに背景に置かれる可能性があります。
生成された<ruby>走脈<rt>スレッド</rt></ruby>は`v`内部参照を持ちますが、第15章で説明した`drop`機能を使用して、メイン<ruby>走脈<rt>スレッド</rt></ruby>は直ちに`v`を`drop`ます。次に、生成された<ruby>走脈<rt>スレッド</rt></ruby>が実行を開始すると`v`は無効になるので、無効です。
あらいやだ！　

リスト16-3の<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りを修正するために、<ruby>誤り<rt>エラー</rt></ruby>メッセージのアドバイスを使用できます。

```text
help: to force the closure to take ownership of `v` (and any other referenced
variables), use the `move` keyword
  |
6 |     let handle = thread::spawn(move || {
  |                                ^^^^^^^
```

<ruby>閉包<rt>クロージャー</rt></ruby>の前に`move`予約語を追加する`move`で、クロストは値を借りるべきであるとRustが推測するのではなく、<ruby>閉包<rt>クロージャー</rt></ruby>が使用している値の所有権を持つように強制型変換します。
リスト16-5のリスト16-3の変更は、意図したとおりに<ruby>製譜<rt>コンパイル</rt></ruby>され、実行されます。

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

<span class="caption">リスト16-5。 <code>move</code>予約語を使って<ruby>閉包<rt>クロージャー</rt></ruby>が使用する値の所有権を持つようにする</span>

<ruby>譜面<rt>コード</rt></ruby>リスト16-4の<ruby>譜面<rt>コード</rt></ruby>には、`move`<ruby>閉包<rt>クロージャー</rt></ruby>を使用した場合にメイン<ruby>走脈<rt>スレッド</rt></ruby>が`drop`と呼ばれる部分はどう`move`ますか？　
う`move`その場合を修正？　
残念だけど違う;
リスト16-4で実行しようとしている処理が異なる理由で許可されていないため、別の<ruby>誤り<rt>エラー</rt></ruby>が発生します。
<ruby>閉包<rt>クロージャー</rt></ruby>に`move`を追加`move`と、`v`を<ruby>閉包<rt>クロージャー</rt></ruby>の環境に移動し、メイン<ruby>走脈<rt>スレッド</rt></ruby>でも`v`を`drop`することはできません。
代わりに、この<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。

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
Rustは控えめで、<ruby>走脈<rt>スレッド</rt></ruby>に対して`v`を借用しているだけなので、リスト16-3の<ruby>譜面<rt>コード</rt></ruby>から<ruby>誤り<rt>エラー</rt></ruby>が発生しました。これは、主<ruby>走脈<rt>スレッド</rt></ruby>が理論的に生成された<ruby>走脈<rt>スレッド</rt></ruby>の参照を無効にできることを意味します。
Rustに`v`所有権をspawnされた<ruby>走脈<rt>スレッド</rt></ruby>に移すように指示することで、メイン<ruby>走脈<rt>スレッド</rt></ruby>はもはや`v`使用しないことをRustに保証します。
同じ方法でリスト16-4を変更した場合、主<ruby>走脈<rt>スレッド</rt></ruby>で`v`を使用しようとすると所有権の規則に違反します。
`move`予約語は、Rustの控えめな<ruby>黙用<rt>デフォルト</rt></ruby>の借用を上書きします。
所有権のルールに違反することは許されません。

<ruby>走脈<rt>スレッド</rt></ruby>と<ruby>走脈<rt>スレッド</rt></ruby>APIの基本を理解して、<ruby>走脈<rt>スレッド</rt></ruby>で*何*ができるかを見てみましょう。
