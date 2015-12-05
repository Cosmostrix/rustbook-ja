% 他言語の中に Rust

三番目の企画には、Rust 最大の強みである「実質的に必携譜〈ランタイム〉を必要としない」点を披露できるものを選びます。

<!--For our third project, we’re going to choose something that shows off one of
Rust’s greatest strengths: a lack of a substantial runtime.-->

組織の拡大にともない、それらは大勢の演譜言語たちに頼るようなってきました。
演譜言語によってその得意と苦手には差があり、
言語のデパートはある言語をその得意な面で、別な言語をその苦手な面で使えるようにしてくれます。

<!--As organizations grow, they increasingly rely on a multitude of programming
languages. Different programming languages have different strengths and
weaknesses, and a polyglot stack lets you use a particular language where
its strengths make sense and a different one where it’s weak.-->

多くの演譜言語は譜体の実行時〈ランタイム〉性能に弱点を抱えています。
しばしば、実行が遅く、しかし生産性の高い言語の選択は考える価値のある妥協案です。
そういった言語では失うものを減らす手助けとなるよう、算系を C 言語 (以下 C という)
で書いて、C の譜面を高水準言語で書かれたかのように呼び出せる仕組みを備えています。
これが「外機能内通 (foreign function interface)〈外部関数インタフェース〉」と呼ばれるものです。
よく「FFI」と略されます。

<!--A very common area where many programming languages are weak is in runtime
performance of programs. Often, using a language that is slower, but offers
greater programmer productivity, is a worthwhile trade-off. To help mitigate
this, they provide a way to write some of your system in C and then call
that C code as though it were written in the higher-level language. This is
called a ‘foreign function interface’, often shortened to ‘FFI’.-->

Rust は両方向の FFI に対応しています。C 譜面をかんたんに呼び出して使え、
しかし決定的なのは C と同じくらいかんたんに _Rust を_ 呼び出せるところでしょう。
Rust のごみ収集部非依存や低い実行時要件と組み合わせれば、Rust
はもっとムフフ成分が必要なときに他の言語に埋め込む強い候補となるでしょう。

<!--Rust has support for FFI in both directions: it can call into C code easily,
but crucially, it can also be called _into_ as easily as C. Combined with
Rust’s lack of a garbage collector and low runtime requirements, this makes
Rust a great candidate to embed inside of other languages when you need
that extra oomph.-->

[FFI のためだけの章][ffi]がまるまるひとつあり、この本でもほかの場所で触れていますが、
本章ではこの特別な FFI の利用例について検討していきます。
Ruby、Python、JavaScript の 3 言語を例に挙げましょう。

<!--There is a whole [chapter devoted to FFI][ffi] and its specifics elsewhere in
the book, but in this chapter, we’ll examine this particular use-case of FFI,
with examples in Ruby, Python, and JavaScript.-->

[ffi]: ffi.html

# 問題

<!-- # The problem -->

ここで選べる企画は多種多様ですが、Rust がほかの言語を明らかに上回る、数値計算と多脈化を例にしていきます。

<!--There are many different projects we could choose here, but we’re going to
pick an example where Rust has a clear advantage over many other languages:
numeric computing and threading.-->

多くの言語では一貫性を守るために数値を山〈スタック〉ではなく原〈ヒーブ〉に置いています。
とくに対象指向演譜〈オブジェクト指向プログラミング〉に特化した言語でごみ収集をするものは原置きが普通です。
ときどき最適化によって一部の数値が山に置かれることもありますが、その仕事を最適化器まかせにせず、
確実に対象型〈オブジェクト型〉より基本型〈プリミティブ型〉を使わせるようにしたいときがあります。

<!--Many languages, for the sake of consistency, place numbers on the heap, rather
than on the stack. Especially in languages that focus on object-oriented
programming and use garbage collection, heap allocation is the default. Sometimes
optimizations can stack allocate particular numbers, but rather than relying
on an optimizer to do its job, we may want to ensure that we’re always using
primitive number types rather than some sort of object type.-->

二番目に、多くの言語が持つ「解釈系全体ロック
(global interpreter lock)〈グローバルインタプリタロック〉」(GIL) の存在です。
これは多くの状況で並列性を制限します。
これは安全性の旗の元に行われており、好ましい効果がありますが、
同時に行える仕事の数を制限するため、大きな悪影響があります。

<!--Second, many languages have a ‘global interpreter lock’ (GIL), which limits
concurrency in many situations. This is done in the name of safety, which is
a positive effect, but it limits the amount of work that can be done at the
same time, which is a big negative.-->

この２点を強調するため、これらを激しく使う企画を作ることにします。
問題自体よりも他の言語に Rust を埋め込むことがこの例の焦点ですので、
こんな風にお遊びの例としましょう。

<!--To emphasize these two aspects, we’re going to create a little project that
uses these two aspects heavily. Since the focus of the example is to embed
Rust into other languages, rather than the problem itself, we’ll just use a
toy example:-->

> 10 個の走脈を開始します。各走脈では 1 から 500 万 まで数えます。
> 10 個の脈がすべて走破しきったところで「完了！」と印字します。

<!-- > Start ten threads. Inside each thread, count from one to five million. After
> all ten threads are finished, print out ‘完了！’.-->

500 万という数字は私の計算機で試して選びました。この譜面を Ruby で書くとこうなります。

<!--I chose five million based on my particular computer. Here’s an example of this
code in Ruby:-->

```ruby
threads = []

10.times do
  threads << Thread.new do
    count = 0

    5_000_000.times do
      count += 1
    end

    count
  end
end

threads.each do |t|
  puts "スレッドが終了しました。計数=#{t.value}"
end
puts "完了！"
```

この例を実行してみて、数秒で終わりそうな手頃な数字を指定してください。
持っている計算機の機体〈ハードウエア〉にもよりますが、加減が必要かもしれません。

<!--Try running this example, and choose a number that runs for a few seconds.
Depending on your computer’s hardware, you may have to increase or decrease the
number.-->

私の算系ではこの算譜に `2.156` 秒かかりました。そして、もし `top`
のようなある種の〈プロセス〉監視器を使えば機械のたった１頭〈コア〉しか使われていないと分かります。
GIL が邪魔をしているわけですね。

<!--On my system, running this program takes `2.156` seconds. And, if I use some
sort of process monitoring tool, like `top`, I can see that it only uses one
core on my machine. That’s the GIL kicking in.-->

これがわざとらしい問題であるのは承知ですが、実世界でもこれに近い状況がたくさん考えられます。
私達の目的のため、２〜３の走脈がせわしなく働く様子がある種の並列的で高価な計算を表すとします。

<!--While it’s true that this is a synthetic program, one can imagine many problems
that are similar to this in the real world. For our purposes, spinning up a few
busy threads represents some sort of parallel, expensive computation.-->

# Rust 側の譜集

<!-- # A Rust library -->

この問題を Rust で書き直しましょう。はじめに、Cargo で新しい企画を作りましょう。

<!--Let’s rewrite this problem in Rust. First, let’s make a new project with
Cargo:-->

```bash
$ cargo new embed
$ cd embed
```

Rust だとまあまあ簡単に書けますね。

<!-- This program is fairly easy to write in Rust: -->

```rust
use std::thread;

fn process() {
    let handles: Vec<_> = (0..10).map(|_| {
        thread::spawn(|| {
            let mut x = 0;
            for _ in 0..5_000_000 {
                x += 1
            }
            x
        })
    }).collect();

    for h in handles {
        println!("走脈が終了しました。計数={}",
	    h.join().map_err(|_| "合流に失敗しました！").unwrap());
    }
}
```

前の例から見覚えのある箇所があります。
10 個の走脈を回し、`handles` ベクトルに集め (collect) ています。
各走脈では 500 万回の繰り返しで毎回 `x` に 1 足しています。
最後に各走脈を合流させます。

<!--Some of this should look familiar from previous examples. We spin up ten
threads, collecting them into a `handles` vector. Inside of each thread, we
loop five million times, and add one to `x` each time. Finally, we join on
each thread.-->

現時点では Rust 譜集でしかないので C から呼べる形のものは外に出していません。
このままの状態で別の言語につなげようとしてもそう上手くはいきません。
２カ所だけちょっと直せばいいんですけどね。ひとつは譜面の冒頭部分を変更し、

<!--Right now, however, this is a Rust library, and it doesn’t expose anything
that’s callable from C. If we tried to hook this up to another language right
now, it wouldn’t work. We only need to make two small changes to fix this,
though. The first is to modify the beginning of our code:-->

```rust,ignore
#[no_mangle]
pub extern fn process() {
```

とします。新しい属性 `no_mangle` を加えなければなりません。
Rust 譜集を作ったとき、製譜済みの出力では機能名が変更されてしまっています。
なぜそうなるのかはこの指南書の対象外ですが、他の言語があの機能を呼ぶ方法を知っておくためには、
変更はできません。
この属性はその振る舞いをなくします。

<!--We have to add a new attribute, `no_mangle`. When you create a Rust library, it
changes the name of the function in the compiled output. The reasons for this
are outside the scope of this tutorial, but in order for other languages to
know how to call the function, we can’t do that. This attribute turns
that behavior off.-->

もうひとつは `pub extern` の変更です。
`pub` はこの機能がこの役区 (module)〈モジュール〉の外部から呼び出し可能であるという意味で、
`extern` は C から呼出し可能であるべきだと言っています。
これだけです！ 変更だらけでなくて良かった。

<!--The other change is the `pub extern`. The `pub` means that this function should
be callable from outside of this module, and the `extern` says that it should
be able to be called from C. That’s it! Not a whole lot of change.-->

二番目にすべきことは `Cargo.toml` での設定の変更です。
一番下にこれを追加してください。

<!--The second thing we need to do is to change a setting in our `Cargo.toml`. Add
this at the bottom:-->

```toml
[lib]
name = "embed"
crate-type = ["dylib"]
```

いまの譜集を標準的な動的譜集〈ダイナミックライブラリ〉に製譜したいと Rust に伝えています。
通常は Rust 専用形式の「rlib」に製譜されます。

<!--This tells Rust that we want to compile our library into a standard dynamic
library. By default, Rust compiles an ‘rlib’, a Rust-specific format.-->

ここで企画を組み上げましょう。

<!-- Let’s build the project now: -->

```bash
$ cargo build --release
   Compiling embed v0.1.0 (file:///home/steve/src/embed)
```

`cargo build --release` を選んで、最適化をありにして組み上げます。
できるだけ高速に動いてもらいたいものです！
できた譜集は `target/release` 以下に見つかります。

<!--We’ve chosen `cargo build --release`, which builds with optimizations on. We
want this to be as fast as possible! You can find the output of the library in
`target/release`:-->

```bash
$ ls target/release/
build  deps  examples  libembed.so  native
```

上の `libembed.so` が「共有対象〈シェアードオブジェクト〉」譜集です。
この〈ファイル〉は C で書かれた共用対象譜集とまったく同じに使えます！
余談ですが名前は土台環境により `embed.dll` (Microsoft Windows) または
`libembed.dylib` (Mac OS X) と変わります。

<!--That `libembed.so` is our ‘shared object’ library. We can use this file
just like any shared object library written in C! As an aside, this may be
`embed.dll` (Microsoft Windows) or `libembed.dylib` (Mac OS X), depending on 
your operating system.-->

Rust 譜集が組めたので早速 Ruby から使ってみましょう。

<!-- Now that we’ve got our Rust library built, let’s use it from our Ruby. -->

# Ruby
<!-- # Ruby -->

企画階層で `embed.rb` 台譜を開き、こうします。

<!-- Open up an `embed.rb` file inside of our project, and do this: -->

```ruby
require 'ffi'

module Hello
  extend FFI::Library
  ffi_lib 'target/release/libembed.so'
  attach_function :process, [], :void
end

Hello.process

puts '完了！'
```

実行できるようになる前に `ffi` ジェム (gem) の導入が必要です。

<!-- Before we can run this, we need to install the `ffi` gem: -->

```bash
$ gem install ffi # 頭に「sudo 」が必要かもしれません
Fetching: ffi-1.9.8.gem (100%)
Building native extensions.  This could take a while...
Successfully installed ffi-1.9.8
Parsing documentation for ffi-1.9.8
Installing ri documentation for ffi-1.9.8
Done installing documentation for ffi after 0 seconds
1 gem installed
```

そしてようやく、実行して試せるようになりました。

<!-- And finally, we can try running it: -->

```bash
$ ruby embed.rb
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
走脈が終了しました。計数=5000000
完了！
完了！
$
```

アッー、なんと早いッ！
私の算系では純 Ruby 版で 2 秒かかっていたものが `0.086` 秒になりました。
それではこの Ruby 譜面をひも解いていきましょう。

<!--Whoa, that was fast! On my system, this took `0.086` seconds, rather than
the two seconds the pure Ruby version took. Let’s break down this Ruby
code:-->

```ruby
require 'ffi'
```

まず最初に `ffi` ジェムを要求 (require) しなければなりません。
これは Rust 譜集を C と同じように仲介をしてくれる役目を持ちます。

<!--We first need to require the `ffi` gem. This lets us interface with our
Rust library like a C library.-->

```ruby
module Hello
  extend FFI::Library
  ffi_lib 'target/release/libembed.so'
```

`Hello` 役区は共有譜集から〈ネイティブ〉機能を〈アタッチ〉するために使われます。
内部では必要な `FFI::Library` 役区を拡張 (`extend`) し、それから `ffi_lib`
を呼んで共有対象譜集を積載します。
ただ作った譜集が置かれた場所をそれに渡しますが、場所は前に見た通り
`target/release/libembed.so` です。

<!-- The `Hello` module is used to attach the native functions from the shared
library. Inside, we `extend` the necessary `FFI::Library` module and then call
`ffi_lib` to load up our shared object library. We just pass it the path that
our library is stored, which, as we saw before, is
`target/release/libembed.so`. -->

```ruby
attach_function :process, [], :void
```

The `attach_function` method is provided by the FFI gem. It’s what
connects our `process()` function in Rust to a Ruby function of the
same name. Since `process()` takes no arguments, the second parameter
is an empty array, and since it returns nothing, we pass `:void` as
the final argument.

```ruby
Hello.process
```

This is the actual call into Rust. The combination of our `module`
and the call to `attach_function` sets this all up. It looks like
a Ruby function but is actually Rust!

```ruby
puts '完了！'
```

Finally, as per our project’s requirements, we print out `完了！`.

That’s it! As we’ve seen, bridging between the two languages is really easy,
and buys us a lot of performance.

Next, let’s try Python!

# Python

Create an `embed.py` file in this directory, and put this in it:

```python
from ctypes import cdll

lib = cdll.LoadLibrary("target/release/libembed.so")

lib.process()

print("完了！")
```

Even easier! We use `cdll` from the `ctypes` module. A quick call
to `LoadLibrary` later, and we can call `process()`.

On my system, this takes `0.017` seconds. Speedy!

# Node.js

Node isn’t a language, but it’s currently the dominant implementation of
server-side JavaScript.

In order to do FFI with Node, we first need to install the library:

```bash
$ npm install ffi
```

After that installs, we can use it:

```javascript
var ffi = require('ffi');

var lib = ffi.Library('target/release/libembed', {
  'process': ['void', []]
});

lib.process();

console.log("完了！");
```

It looks more like the Ruby example than the Python example. We use
the `ffi` module to get access to `ffi.Library()`, which loads up
our shared object. We need to annotate the return type and argument
types of the function, which are `void` for return and an empty
array to signify no arguments. From there, we just call it and
print the result.

私の算系では、たったの `0.092` 秒でした。

<!-- On my system, this takes a quick `0.092` seconds. -->

# 結び

<!-- # Conclusion -->

ご覧の通り、外機能内通の基本は _とっても_ 簡単です。
もちろん、できることは以上の例に限らずたくさんあります。
詳しくは[外機能内通][ffi]の章に当たってみてください。

<!--As you can see, the basics of doing this are _very_ easy. Of course,
there's a lot more that we could do here. Check out the [FFI][ffi]
chapter for more details.-->
