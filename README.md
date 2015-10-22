% 演譜言語 Rust

はじめまして！ この本では、[演譜〈プログラミング〉言語 Rust][rust] について学びます。
Rust は三つの目標、安全性・速度・並列処理に焦点を当てて開発されている算系〈システム〉演譜〈プログラミング〉言語です。Rust はこれらの目標をごみ収集部〈ガベージコレクター〉なしで堅持することにより、他の言語の苦手とする数々の用途にも活用できるものになっています。例えば、他の言語への埋め込みや、記憶域と実行時間の制約がある譜体〈プログラム〉、機器駆動書〈デバイスドライバー〉や基本算系〈オペレーティングシステム〉のような低水準な算譜〈コード〉等が書けます。Rust はこの領域を対象としている現在の言語たちを実行時のムダが全くない幾多の？？？〈コンパイル〉時安全性検査により改善し、さらに全ての読み書き衝突〈データ競合〉を生まれる前に消し去ります。Rust は「無賃〈ゼロコスト〉の抽象化」を実現することも目指しています。しかも、それらの内のいくつかはあたかも高水準言語を使っているかのような使用感を持つのです。
その場合にも Rust では低水準言語らしい緻密な制御が可能になっています。

[rust]: https://www.rust-lang.org

『演譜言語 Rust』は８つの章に分かれています。この序文は最初の１章です。残りの章を紹介しましょう。

* [おはよう、Rust][gs] - Rust 開発に向けて計算機の準備しましょう。
* [それはとっても嬉しいなって][lr] - Rust 演譜を小さな企画を通して学びます。
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

この序文を読み終えたあとは、好みに応じて「それはとっても嬉しいなって」または「構文も、意味論も、あるんだよ」のどちらかを読み進めたいと思うでしょう。企画から手をつけたい方は前者へ。小さく始めてひとつの概念をきちんと学びきってから次へ移りたい方は後者へどうぞ。
多くの横断リンクが部分の全体を一つに繋ぎ合わせます。

### 貢献について

この本を生成した原譜〈ソースファイル〉は GitHub 上に置かれています。
[github.com/rust-lang/rust/tree/master/src/doc/trpl](https://github.com/rust-lang/rust/tree/master/src/doc/trpl)

## Rustの簡単な紹介

Rust はあなたの興味を引くに相応しい言語なのでしょうか？ Rustの強みの一部が見える算譜の例をすこし挙げて調べてみることにしましょう。

Rust を他にない言語たらしめている主な概念は「所有権」と呼ばれています。 この短い例を見てください。

```rust
fn main() {
    let mut x = vec!["Hello", "world"];
}
```

この算譜は `x` と命名された[変数束縛][var]を作っています。この束縛の値は `Vec<T>` 「ベクトル」、私達が標準ライブラリで定義された[マクロ][macro]を通して作ったものです。
このマクロは `vec` という名前で、マクロは後ろに `!` を付けることで呼び出せます。これは Rust の一般原則、物事はハッキリさせる、に従った表記です。マクロは関数呼び出しに比べてずっと高度で複雑なことができますから、マクロは見るからに別物でなければならないのです。末尾の `!` は構文解析をも簡単にし、補助道具を楽に書けるようにしていることもまた重要です。

私達は `x` の前に `mut` を付けて値を変更（上書き）可能にしました。Rust では束縛は何も指示しない限り不変です。
例の中のベクトルはあとで変更します。

型注釈が必要でないことにも注目です。Rust
は静的に型付けされていながら、型をわざわざ注記する必要がないのです。Rust has
type inference to balance out the power of static typing with the verbosity of
annotating types.

Rust prefers stack allocation to heap allocation: `x` is placed directly on the
stack. However, the `Vec<T>` type allocates space for the elements of the vector
on the heap. If you’re not familiar with this distinction, you can ignore it for
now, or check out [‘The Stack and the Heap’][heap]. As a systems programming
language, Rust gives us the ability to control how our memory is allocated, but
when we’re getting started, it’s less of a big deal.

[var]: variable-bindings.html
[macro]: macros.html
[heap]: the-stack-and-the-heap.html

Earlier, we mentioned that ‘ownership’ is the key new concept in Rust. In Rust
parlance, `x` is said to ‘own’ the vector. This means that when `x` goes out of
scope, the vector’s memory will be de-allocated. This is done deterministically
by the Rust compiler, rather than through a mechanism such as a garbage
collector. In other words, in Rust, we don’t call functions like `malloc` and
`free` ourselves: the compiler statically determines when we need to allocate or
deallocate memory, and inserts those calls itself. To err is to be human, but
compilers never forget.

Let’s add another line to our example:

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = &x[0];
}
```

We’ve introduced another binding, `y`. In this case, `y` is a ‘reference’ to the
first element of the vector. Rust’s references are similar to pointers in other
languages, but with additional compile-time safety checks. References interact
with the ownership system by [‘borrowing’][borrowing] what they point to, rather
than owning it. The difference is, when the reference goes out of scope, it
won't deallocate the underlying memory. If it did, we’d de-allocate twice, which
is bad!

[borrowing]: references-and-borrowing.html

Let’s add a third line. It looks innocent enough, but causes a compiler error:

```rust,ignore
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = &x[0];

    x.push("foo");
}
```

`push` is a method on vectors that appends another element to the end of the
vector. When we try to compile this program, we get an error:

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

Whew! The Rust compiler gives quite detailed errors at times, and this is one
of those times. As the error explains, while we made our binding mutable, we
still can't call `push`. This is because we already have a reference to an
element of the vector, `y`. Mutating something while another reference exists
is dangerous, because we may invalidate the reference. In this specific case,
when we create the vector, we may have only allocated space for two elements.
Adding a third would mean allocating a new chunk of memory for all those elements,
copying the old values over, and updating the internal pointer to that memory.
That all works just fine. The problem is that `y` wouldn’t get updated, and so
we’d have a ‘dangling pointer’. That’s bad. Any use of `y` would be an error in
this case, and so the compiler has caught this for us.

So how do we solve this problem? There are two approaches we can take. The first
is making a copy rather than using a reference:

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    let y = x[0].clone();

    x.push("foo");
}
```

Rust has [move semantics][move] by default, so if we want to make a copy of some
data, we call the `clone()` method. In this example, `y` is no longer a reference
to the vector stored in `x`, but a copy of its first element, `"Hello"`. Now
that we don’t have a reference, our `push()` works just fine.

[move]: ownership.html#move-semantics

If we truly want a reference, we need the other option: ensure that our reference
goes out of scope before we try to do the mutation. That looks like this:

```rust
fn main() {
    let mut x = vec!["Hello", "world"];

    {
        let y = &x[0];
    }

    x.push("foo");
}
```

We created an inner scope with an additional set of curly braces. `y` will go out of
scope before we call `push()`, and so we’re all good.

This concept of ownership isn’t just good for preventing dangling pointers, but an
entire set of related problems, like iterator invalidation, concurrency, and more.
