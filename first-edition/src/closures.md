# 閉鎖

時には、より明確で再利用 _できる_ ように、関数と _変数_ をまとめておくと便利です。
使用可能なフリー変数は、囲みスコープから来ており、関数で使用されているときは「クローズ」されています。
これから、「クロージャー」という名前が付けられました。そして、Rustは、それらの本当に素晴らしい実装を提供します。

# 構文

クロージャは次のようになります。

```rust
let plus_one = |x: i32| x + 1;

assert_eq!(2, plus_one(1));
```

バインディング`plus_one`を作成し、クロージャに割り当てます。
クロージャの引数はパイプ（`|`）の間にあり、ボディは式（この場合は`x + 1`です。
`{ }`は式なので、複数行のクロージャーを使用することもできます。

```rust
let plus_two = |x| {
    let mut result: i32 = x;

    result += 1;
    result += 1;

    result
};

assert_eq!(4, plus_two(2));
```

`fn`定義された通常の名前付き関数とは少し違うクロージャについては、いくつか気づくでしょう。
1つ目は、クロージャーが取る引数の型や、それが返す値に注釈を付ける必要がないことです。
私たちはできる：

```rust
let plus_one = |x: i32| -> i32 { x + 1 };

assert_eq!(2, plus_one(1));
```

しかし、私たちはする必要はありません。
どうしてこれなの？
基本的には人間工学的理由から選ばれたものです。
名前付き関数の完全型を指定すると、ドキュメントや型推論などに役立ちますが、クロージャの完全型署名は匿名であるためほとんど記述されません。名前付き関数型を推論することができます。

2つ目は、構文が似ていますが、少し異なります。
ここでは比較を簡単にするためにスペースを追加しました。

```rust
fn  plus_one_v1   (x: i32) -> i32 { x + 1 }
let plus_one_v2 = |x: i32| -> i32 { x + 1 };
let plus_one_v3 = |x: i32|          x + 1  ;
```

小さな違いですが、似ています。

# 閉鎖とその環境

クロージャの環境には、パラメータとローカルバインディングに加えて、囲みスコープからのバインディングを含めることができます。
これは次のようになります。

```rust
let num = 5;
let plus_num = |x: i32| x + num;

assert_eq!(10, plus_num(5));
```

この閉鎖は、`plus_num`を指し、`let`その範囲にバインディング： `num`。
具体的には、バインディングを借用します。
その拘束力と矛盾する何かをすると、私たちは誤りを犯します。
このように：

```rust,ignore
let mut num = 5;
let plus_num = |x: i32| x + num;

let y = &mut num;
```

どのエラーで

```text
error: cannot borrow `num` as mutable because it is also borrowed as immutable
    let y = &mut num;
                 ^~~
note: previous borrow of `num` occurs here due to use in closure; the immutable
  borrow prevents subsequent moves or mutable borrows of `num` until the borrow
  ends
    let plus_num = |x| x + num;
                   ^~~~~~~~~~~
note: previous borrow ends here
fn main() {
    let mut num = 5;
    let plus_num = |x| x + num;

    let y = &mut num;
}
^
```

冗長で役に立つエラーメッセージです！
それが言っているように、クロージャーが既にそれを借りているので、私たちは`num`可変の借りをすることはできません。
クロージャを範囲外にすると、次のことが可能になります。

```rust
let mut num = 5;
{
    let plus_num = |x: i32| x + num;

#//} // `plus_num` goes out of scope; borrow of `num` ends.
} //  `plus_num`は範囲外になります。`num`借りは終了する。

let y = &mut num;
```

しかし、クロージャがそれを必要とする場合、Rustは所有権を取り、代わりに環境を移動します。
これは動作しません：

```rust,ignore
let nums = vec![1, 2, 3];

let takes_nums = || nums;

println!("{:?}", nums);
```

このエラーが発生します：

```text
note: `nums` moved into closure environment here because it has type
  `[closure(()) -> collections::vec::Vec<i32>]`, which is non-copyable
let takes_nums = || nums;
                 ^~~~~~~
```

`Vec<T>`はその内容よりも所有権があるため、終了時に参照するときは`nums`所有権を取得する必要があります。
それは、私たちが所有権を取得した関数に`nums`を渡した場合と同じです。

## クロージャを`move`する

`move`キーワードを使用して、閉鎖を強制的に環境の所有権にすることができます。

```rust
let num = 5;

let owns_num = move |x: i32| x + num;
```

現在、キーワードが`move`であっても、変数は通常の移動セマンティクスに従います。
この場合、`5`は`Copy`実装するため、`owns_num`は`num`コピーの所有権を取得します。
違いは何ですか？

```rust
let mut num = 5;

{
    let mut add_num = |x: i32| num += x;

    add_num(5);
}

assert_eq!(10, num);
```

だから、このケースでは、クロージャが`num`への参照を変更し、`add_num`、元の値に突然変異が`add_num`。
また、環境を変更しているので、`add_num`も`mut`として宣言する必要がありました。

`move`クロージャに変更した場合、それは異なります。

```rust
let mut num = 5;

{
    let mut add_num = move |x: i32| num += x;

    add_num(5);
}

assert_eq!(5, num);
```

我々は`5`を得る。
私たちの`num`変更可能な借用を取るのではなく、コピーの所有権を取った。

`move`クロージャについて考えるもう一つの方法は、クロージャに独自のスタックフレームを与えます。
`move`なければ、クロージャはそれを作成したスタックフレームに結びつけられ、`move`クロージャは自己完結型です。
つまり、一般的に、関数から非`move`クロージャを返すことはできません。

しかし、クロージャを受け取り、返すことについて話す前に、クロージャが実装される方法についてもう少し話してください。
システムの言語として、Rustはコードが行うことを何トンも制御し、クロージャも変わりません。

# 閉鎖の実装

Rustのクロージャの実装は、他の言語とは少し異なります。
彼らは事実上、形質のためのシンタックスシュガーです。
あなたは読み持っていることを確認したいと思う[traits][traits]この1の前のセクションを、だけでなく、上のセクション[trait objects][trait-objects]。

[traits]: traits.html
 [trait-objects]: trait-objects.html


すべては？
良い。

フックでクロージャがどのように動作するかを理解するための鍵はちょっと変わったことです：Using `()`を使って`foo()`ような関数を呼び出すことは、オーバーロード可能な演算子です。
これ以降、他のすべてがクリックされます。
Rustでは、特性システムを使用してオペレータを過負荷にします。
関数の呼び出しも変わりません。
私たちには3つの異なる特性があります。

* `Fn`
* `FnMut`
* `FnOnce`

これらの特徴にはいくつかの違いがありますが、大きなものは`self`です： `Fn`は`&self`、 `FnMut`は`&mut self`、 `FnOnce`は`self`取ります。
これは、通常のメソッド呼び出し構文を使って、3種類の`self`すべてをカバーします。
しかし、私たちは1つのものを持つよりも、3つの特性に分割しました。
これにより、どのような種類の閉鎖を取ることができるかを大量に制御することができます。

`|| {}`
クロージャーのための`|| {}`構文は、これらの3つの特性のための砂糖です。
Rustは環境の構造体を生成し、適切な特性を`impl`使用します。

# クロージャを引数として取る

クロージャーが特色であることを知ったので、クロージャを受け入れて返す方法は既に知っています。他の特性と同じです！

これは、静的対動的ディスパッチも選択できることを意味します。
まず、呼び出し可能なものをとり、呼び出して結果を返す関数を記述しましょう：

```rust
fn call_with_one<F>(some_closure: F) -> i32
    where F: Fn(i32) -> i32 {

    some_closure(1)
}

let answer = call_with_one(|x| x + 2);

assert_eq!(3, answer);
```

私たちは閉包を渡します、`|x| x + 2`
`|x| x + 2`で、`call_with_one`ます。
それは、それが示唆していることを行います：それは引数として`1`を与えるクロージャを呼び出します。

`call_with_one`のシグネチャをさらに詳しく調べてみましょう。

```rust
fn call_with_one<F>(some_closure: F) -> i32
#    where F: Fn(i32) -> i32 {
#    some_closure(1) }
```

1つのパラメータを取り、タイプ`F`持ちます。
私たちは`i32`も返します。
この部分は興味深いものではありません。
次の部分は次のとおりです。

```rust
# fn call_with_one<F>(some_closure: F) -> i32
    where F: Fn(i32) -> i32 {
#   some_closure(1) }
```

`Fn`は形質なので、ジェネリック型の境界として使うことができます。
この場合、私たちの閉鎖がかかる`i32`引数としてと返し`i32`、そして私たちが使用するので、一般的な束縛がある`Fn(i32) -> i32`。

もう1つの重要な点があります：特性を持つジェネリックを囲んでいるため、これは単体化されるため、クロージャに静的なディスパッチを行います。
それはかなりきれいです。
多くの言語では、クロージャは本質的にヒープに割り当てられ、常に動的ディスパッチを伴います。
Rustでは、クロージャ環境をスタックして静的に呼び出すことができます。
これはイテレータとそのアダプタで頻繁に起こります。これは引数としてクロージャを使用することがよくあります。

もちろん、動的ディスパッチが必要な場合は、それを取得することもできます。
traitオブジェクトは、通常どおりこのケースを処理します。

```rust
fn call_with_one(some_closure: &Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

let answer = call_with_one(&|x| x + 2);

assert_eq!(3, answer);
```

今度は、`&Fn`という特性オブジェクトを取り`&Fn`。
`call_with_one`に渡すときにクロージャの参照をする`call_with_one`があるので、`&||`を使用します。
。

明示的な存続期間を使用するクロージャについての簡単なメモ。
場合によっては、次のような参照をとるクロージャーを使用することがあります。

```rust
fn call_with_ref<F>(some_closure:F) -> i32
    where F: Fn(&i32) -> i32 {

    let value = 0;
    some_closure(&value)
}
```

通常、クロージャに対するパラメータの有効期間を指定することができます。
関数宣言に注釈を付けることができます：

```rust,ignore
fn call_with_ref<'a, F>(some_closure:F) -> i32
    where F: Fn(&'a i32) -> i32 {
```

しかしながら、これは我々の場合に問題を提示する。
ある関数に明示的な存続時間パラメータがある場合、その存続時間は、少なくともその関数への呼び出し*全体の*長さと同じでなければなりません。
貸借チェッカーは、関数本体内で宣言された後にのみスコープ内にあるため、`value`が十分長く存続しないと不満を`value`。

私たちが必要とするのは、外部関数のスコープではなく、独自の呼び出しスコープに対してのみ引数を借りることができるクロージャです。
それを言うには、`for<...>`構文でHigher-Rank Trait Boundsを使うことができます：

```ignore
fn call_with_ref<F>(some_closure:F) -> i32
    where F: for<'a> Fn(&'a i32) -> i32 {
```

これにより、Rustコンパイラは、クロージャを呼び出し、借用チェッカーのルールを満たすための最小有効期間を見つけることができます。
私たちの機能は、コンパイルし、期待通りに実行します。

```rust
fn call_with_ref<F>(some_closure:F) -> i32
    where F: for<'a> Fn(&'a i32) -> i32 {

    let value = 0;
    some_closure(&value)
}
```

# 関数ポインタとクロージャ

関数ポインタは、環境を持たないクロージャのようなものです。
したがって、クロージャ引数を期待する関数に関数ポインタを渡すことができます。

```rust
fn call_with_one(some_closure: &Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

fn add_one(i: i32) -> i32 {
    i + 1
}

let f = add_one;

let answer = call_with_one(&f);

assert_eq!(2, answer);
```

この例では、厳密に中間変数`f`必要とせず、関数の名前もうまくいきます：

```rust,ignore
let answer = call_with_one(&add_one);
```

# クロージャを返す

ファンクションスタイルのコードでは、さまざまな状況でクロージャを返すのが一般的です。
クロージャを返そうとすると、エラーが発生する可能性があります。
最初は奇妙に見えるかもしれませんが、わかります。
おそらく、関数からクロージャを返そうとすると、次のようになります。

```rust,ignore
fn factory() -> (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

これにより、これらの長くて関連したエラーが発生します。

```text
error: the trait bound `core::ops::Fn(i32) -> i32 : core::marker::Sized` is not satisfied [E0277]
fn factory() -> (Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~
note: `core::ops::Fn(i32) -> i32` does not have a constant size known at compile-time
fn factory() -> (Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~
error: the trait bound `core::ops::Fn(i32) -> i32 : core::marker::Sized` is not satisfied [E0277]
let f = factory();
    ^
note: `core::ops::Fn(i32) -> i32` does not have a constant size known at compile-time
let f = factory();
    ^
```

関数から何かを返すために、Rustは戻り値の型がどれくらいのサイズかを知る必要があります。
しかし、`Fn`は特性であるため、さまざまなサイズのさまざまなものがあり`Fn`。多くの異なるタイプが`Fn`を実装でき`Fn`。
参照用のサイズが既知であるため、サイズを指定する簡単な方法は、参照を行うことです。
だから我々はこれを書くだろう：

```rust,ignore
fn factory() -> &(Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

しかし、別のエラーが発生します。

```text
error: missing lifetime specifier [E0106]
fn factory() -> &(Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~~
```

右。
私たちは参照を持っているので、それを生涯与える必要があります。
しかし、私たちの`factory()`関数は引数を取らないので、[elision](lifetimes.html#lifetime-elision)はここでは[elision](lifetimes.html#lifetime-elision)しません。
それから、どんな選択肢がありますか？
`'static`試してください：

```rust,ignore
fn factory() -> &'static (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

しかし、別のエラーが発生します。

```text
error: mismatched types:
 expected `&'static core::ops::Fn(i32) -> i32`,
    found `[closure@<anon>:7:9: 7:20]`
(expected &-ptr,
    found closure) [E0308]
         |x| x + num
         ^~~~~~~~~~~

```

このエラーは、私たちに`&'static Fn(i32) -> i32`がないことを知らせるものです。私たちは`[closure@<anon>:7:9: 7:20]`を持っています。
待って、何？

各クロージャは`Fn`やフレンドの独自の環境`struct`と実装を生成するため、これらのタイプは匿名です。
彼らはこの閉鎖のためだけに存在します。
そこで、Rustは自動生成された名前ではなく、`closure@<anon>`として表示します。

このエラーは、戻り値の型が参照であると予想されていることも指摘していますが、返す値は返されません。
さらに、オブジェクトに`'static`寿命を直接割り当てることはできません。
だから私たちは`Fn` `Box`使って別のアプローチを取って 'trait object'を返し`Fn`。
これは _ほとんど_ 動作します：

```rust,ignore
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(|x| x + num)
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

最後の問題は1つだけです：

```text
error: closure may outlive the current function, but it borrows `num`,
which is owned by the current function [E0373]
Box::new(|x| x + num)
         ^~~~~~~~~~~
```

さて、前に議論したように、閉鎖は環境を借りる。
この場合、私たちの環境は、変数`num`バインドされたスタック割り当て`5`に基づいています。
したがって、借用にはスタックフレームの寿命があります。
したがって、このクロージャを返すと、関数呼び出しが終了し、スタックフレームがなくなり、クロージャがゴミメモリの環境をキャプチャしています！
1つの最後の修正で、この作業を行うことができます：

```rust
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(move |x| x + num)
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

内側のクロージャを`move Fn`にすることで、クロージャ用の新しいスタックフレームを作成します。
`Box`アップすることで、スタックフレームから脱出できるように、既知のサイズを与えました。
