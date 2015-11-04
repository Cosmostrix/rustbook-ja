% 演譜言語 Rust

はじめまして！ この本では、[演譜〈プログラミング〉言語 Rust][rust] について学びます。
Rust は三つの目標、安全性・速度・並列処理に焦点を当てて開発されている算系〈システム〉演譜〈プログラミング〉言語です。Rust はこれらの目標をごみ収集部〈ガベージコレクター〉を排して堅持することにより、他の言語の苦手とする数々の用途にも活用できるものになっています。例えば、他の言語への埋め込みや、記憶域と実行時間の制約がある譜体〈プログラム〉、機器駆動書〈デバイスドライバー〉や基本算系〈オペレーティングシステム〉のような低水準(機械寄り)の算譜〈コード〉が書けます。Rust は現在この領域を対象としている他の言語たちを、実行時の犠牲が全くない幾多もの製譜〈コンパイル〉時安全性検査を加えて改善し、さらに、並列処理においては、全ての不協和〈データ競合〉状態を生まれる前に消し去ります。Rust は「無賃〈ゼロコスト〉の抽象化」の実現も目指しています。しかも、それらの抽象化の中には、あたかも高水準言語を使っているかのような使用感を持つものさえあるのです。
その場合にも Rust では低水準言語らしい緻密な制御が可能になっています。

[rust]: https://www.rust-lang.org

『演譜言語 Rust』は８つの章に分かれています。この序文は最初の１章です。残りの章を紹介しましょう。

* [はじめよう、Rust][gs] - Rust 開発に向けて計算機の準備しましょう。
* [Rust を学ぼう][lr] - Rust 演譜を小さな企画を通して学びます。
* [もう何も恐くない][er] - 優れた Rust 算譜を書くための上位概念とは。
* [構文も、意味論も、あるんだよ][ss] - Rust の各部分を、小さなまとまりに噛み砕いて説明します。
* [夢の中で逢った、ような……][nr] - 安定版に入っていない、最先端の機能たち。
* [Rust 用語集][gl] - この本で扱っている術語について。
* [参考文献][bi] - Rust に影響を与えた背景、Rust を扱った論文。

[gs]: getting-started.html
[lr]: learn-rust.html
[er]: effective-rust.html
[ss]: syntax-and-semantics.html
[nr]: nightly-rust.html
[gl]: glossary.html
[bi]: bibliography.html

この序文を読み終えたあとは、好みに応じて「Rust を学ぼう」または「構文も、意味論も、あるんだよ」のどちらかを読み進めたいと思うでしょう。企画から手をつけたい方は前者へ。小さく始めてひとつの概念をきちんと学びきってから次へ移りたい方は後者へどうぞ。
多くの横断リンクが各部分を一つに繋ぎ合わせます。

### 貢献について

この本を生成した原譜〈ソースファイル〉は GitHub 上に置かれています。
[github.com/rust-lang/rust/tree/master/src/doc/trpl](https://github.com/rust-lang/rust/tree/master/src/doc/trpl)

## Rustの簡単な紹介

Rust はあなたの興味を引くに相応しい言語でしょうか？ Rustの強みを垣間見せる算譜の例をすこし挙げて調べてみることにしましょう。

Rust を他にない言語たらしめている主な概念は「所有権」(ownership)と呼ばれています。この短い例を見てください。

```rust
fn main() {
    let mut x = vec!["Hello", "world"];
}
```

この算譜は `x` と命名された[変数束縛][var]を作っています。この束縛の値は `Vec<T>` 「ベクトル」、私達が標準〈ライブラリ〉で定義された[マクロ][macro]を通して作ったものです。
このマクロは `vec` という名前で、マクロは後ろに `!` を付けることで呼び出せます。これは Rust の一般原則、物事はハッキリさせる、に従った表記です。マクロは関数呼び出しに比べてずっと高度で複雑なことができますから、マクロは見るからに別物でなければならないのです。末尾の `!` は構文解析をも簡単にし、補助具を楽に書けるようにしていることもまた重要です。

私達は `x` の前に `mut` を付けて値を変更（上書き）可能にしました。Rust では束縛は何も指示しない限り不変です。
例の中のベクトルはあとで変更します。

型注釈が必要でないことにも注目です。Rust は静的に型付けされていながら、型をわざわざ注記する必要がないのです。Rust が備える型推論は、静的な型付けの威力と型を注記する煩わしさのうまい均衡を取っています。

Rust は〈ヒープ〉割当てより〈スタック〉割当てを好みます。上の `x` は〈スタック〉上に直接置かれます。しかし、`Vec<T>` 型はベクトルの要素が置かれる領域を〈ヒープ〉内に割当てます。この違いがよく分からない人は、今は気にしなくても構いませんし、[「〈スタック〉と〈ヒープ〉」][heap]を読むのも良いでしょう.
算系演譜言語〈システムプログラミング言語〉として、Rust では記憶域の割当て方法を自由自在に決めることができますが、まだまだ最初ですから分からなくても大丈夫です。

[var]: variable-bindings.html
[macro]: macros.html
[heap]: the-stack-and-the-heap.html

さきほど「所有権」が Rust の肝だといいました。Rust 用語で `x` はベクトルを「所有」していると言います。これは、実行位置が `x` の(束縛)有効範囲〈スコープ〉から外れた瞬間に、ベクトルの記憶域割当てが終了するということです。記憶域の開放は Rust 〈コンパイラー〉により確定的に行われ、ごみ収集部〈ガベージコレクター〉のような機構は使用しません。つまり、Rustでは `malloc` や `free` のような機能を私達が呼ぶ必要はありません。〈コンパイラー〉が静的にいつ記憶域の割当開放が必要かを判断してこれらの呼び出しを足してくれます。過ちは人の常、されど〈コンパイラー〉の決して忘れることなし。

先の例に１行足してみましょう。

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = &x[0];
}
```

新しい束縛 `y` を追加しました。この場合、`y` はベクトルの最初の要素への「参照」です。Rust の参照は他の言語の場指し〈ポインター〉に近いものですが、更に？？？〈コンパイル〉時の安全性検査が付いています。
参照と所有権方式とのやり取りは、参照先を所有する代わりに参照先を[「借用」][borrowing]することで行われます。参照の範囲外に出ても元の記憶域を開放しない点が大きなちがいです。もしここで開放してしまうと、二重に開放してしまうことになります。それはまずい！

[borrowing]: references-and-borrowing.html

３行目を付け足しましょう。全く問題なさそうなのに、〈コンパイラー〉は誤りを生じました。

```rust,ignore
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = &x[0];

    x.push("foo");
}
```

`push` はベクトルの操作法〈メソッド〉の一つで、ベクトルの末尾に別の要素を追加します。
この算譜を〈コンパイル〉しようとすると、このような誤りになります。


```text
誤り。 `x` はすでに不変に借用されている為、可変に借用できません。
    x.push("foo");
    ↑
注。 前回の `x` の借用はここです。不変な借用が借用の終わりまで後続の譲渡や `x` の可変な借用を防いでいます。
    let y = &x[0];
             ↑
注。 前回の借用の終わりはここです。
fn main() {

}
↑
```

実際はこのように表示されます。

```text
error: cannot borrow `x` as mutable because it is also borrowed as immutable
    x.push("foo");
    ^
note: previous borrow of `x` occurs here; the immutable borrow prevents
subsequent moves or mutable borrows of `x` until the borrow ends
    let y = &x[0];
             ^
note: previous borrow ends here
fn main() {

}
^
```

おお〜っと！ Rust 〈コンパイラー〉は時々すばらしくきめ細かに誤りを教えてくれますが、今回は当たりでした。
誤りの示す通り、束縛を可変(mutable)にしていたとしても `push` を呼ぶことはできません。なぜなら、
ベクトルの要素への参照 `y` がもうあるからです。他の参照が生きている間に一部を変更することは大変危険です。
それは、その参照を破壊してしまえるからです。今の場合、最初にベクトルを作ったときに要素２つ分の領域だけを割り当てていたかもしれません。
３つ目を追加するということは、全ての値が入る新しい記憶域の塊を割り当てて、古い値をまるっと写して開放し、
内部の場指し〈ポインター〉を新しい記憶域に指すように更新することを意味しているかもしれません。
これで何もかもが上手くいきます。問題は `y` が更新されていないことで、「中ぶらの場指し」が残ることです。
これはまずいですね！この場合 `y` をどのように使おうが誤りになる可能性があります。
だから〈コンパイラー〉は私達のためにこれを捕らえてくれたのです。

それで、どうすれば解決できるのでしょうか？２つの方法があります。１つ目は参照の代わりに複製を作る方法です。

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = x[0].clone();

    x.push("foo");
}
```

Rust は通常 [譲渡の意味論][move] を選択するので、あるものの複製を作りたいならば `clone()` 操作法を呼ぶ必要があります。
この例では、`y` はもう `x` に格納されたベクトルへの参照ではなく、最初の要素 `"Hello"` の写しです。
もはや参照は存在しないため `push()` は正しく動きます。

[move]: ownership.html#move-semantics

もし本当の参照と向き合いたいなら、他の選択肢が必要ですね。参照の有効範囲が確実に終わってから改変を試みるようにします。
すると、こんな感じになります。

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    {
        let y = &x[0];
    }

    x.push("foo");
}
```

中括弧の組を増やして閉じた有効範囲を作りました。`y` は `push()` を呼ぶ前に範囲外になり、めでたしめでたしです。

この所有権の概念は中ぶら場指しを防ぐのみならず、〈イテレーター〉無効化や並行処理などのような関連する問題全体にも効きます。
