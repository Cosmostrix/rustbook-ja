# 閉包

時には、より明確で再利用 _できる_ ように、機能と _変数_ をまとめておくと便利です。
使用可能な自由変数は、外側の有効範囲から来ており、機能で使用されているときは「閉じ込め」されています。
これから、「閉包」という名前が付けられました。そして、Rustは、それらの本当に素晴らしい実装を提供します。

# 構文

閉包は次のようになります。

```rust
let plus_one = |x: i32| x + 1;

assert_eq!(2, plus_one(1));
```

束縛`plus_one`を作成し、閉包に割り当てます。
閉包の引数はパイプ（`|`）の間にあり、本体は式（この場合は`x + 1`です。
`{ }`は式なので、複数行の閉包を使用することもできます。

```rust
let plus_two = |x| {
    let mut result: i32 = x;

    result += 1;
    result += 1;

    result
};

assert_eq!(4, plus_two(2));
```

`fn`定義された通常の名前付き機能とは少し違う閉包については、いくつか気づくでしょう。
1つ目は、閉包が取る引数の型や、それが返す値に注釈を付ける必要がないことです。
できる。

```rust
let plus_one = |x: i32| -> i32 { x + 1 };

assert_eq!(2, plus_one(1));
```

しかし、する必要はありません。
どうしてこうなっているのでしょう？　
基本的には使い勝手の理由から選ばれたものです。
名前付き機能の完全型を指定すると、開発資料や型推論などに役立ちますが、閉包の完全型署名は無名であるためほとんど記述されません。名前付き機能型を推論することができます。

2つ目は、構文が似ていますが、少し異なります。
ここでは比較を簡単にするためにスペースを追加しました。

```rust
fn  plus_one_v1   (x: i32) -> i32 { x + 1 }
let plus_one_v2 = |x: i32| -> i32 { x + 1 };
let plus_one_v3 = |x: i32|          x + 1  ;
```

小さな違いですが、似ています。

# 閉包とその環境

閉包の環境には、パラメータとローカル束縛に加えて、外側の有効範囲からの束縛を含めることができます。
これは次のようになります。

```rust
let num = 5;
let plus_num = |x: i32| x + num;

assert_eq!(10, plus_num(5));
```

この閉包は、`plus_num`を指し、`let`その範囲に束縛。 `num`。
具体的には、束縛を借用します。
その拘束力と矛盾する何かをすると、誤りを犯します。
このように。

```rust,ignore
let mut num = 5;
let plus_num = |x: i32| x + num;

let y = &mut num;
```

どの誤りで

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

冗長で役に立つ誤りメッセージです！　
それが言っているように、閉包が既にそれを借りているので、`num`可変の借用をすることはできません。
閉包を範囲外にすると、次のことが可能になります。

```rust
let mut num = 5;
{
    let plus_num = |x: i32| x + num;

#//} // `plus_num` goes out of scope; borrow of `num` ends.
} //  `plus_num`は範囲外になります。`num`借用は終了します。

let y = &mut num;
```

しかし、閉包がそれを必要とする場合、Rustは所有権を取り、代わりに環境を移動します。
これは動作しません。

```rust,ignore
let nums = vec![1, 2, 3];

let takes_nums = || nums;

println!("{:?}", nums);
```

この誤りが発生します。

```text
note: `nums` moved into closure environment here because it has type
  `[closure(()) -> collections::vec::Vec<i32>]`, which is non-copyable
let takes_nums = || nums;
                 ^~~~~~~
```

`Vec<T>`はその内容よりも所有権があるため、終了時に参照するときは`nums`所有権を取得する必要があります。
それは、所有権を取得した機能に`nums`を渡した場合と同じです。

## 閉包を`move`する

`move`予約語を使用して、閉包を強制的に環境の所有権にすることができます。

```rust
let num = 5;

let owns_num = move |x: i32| x + num;
```

現在、予約語が`move`であっても、変数は通常の移動意味論に従います。
この場合、`5`は`Copy`実装するため、`owns_num`は`num`コピーの所有権を取得します。
違いは何でしょうか？　

```rust
let mut num = 5;

{
    let mut add_num = |x: i32| num += x;

    add_num(5);
}

assert_eq!(10, num);
```

だから、このケースでは、閉包が`num`への参照を変更し、`add_num`、元の値に変更が`add_num`。
また、環境を変更しているので、`add_num`も`mut`として宣言する必要がありました。

`move`閉包に変更した場合、それは異なります。

```rust
let mut num = 5;

{
    let mut add_num = move |x: i32| num += x;

    add_num(5);
}

assert_eq!(5, num);
```

`5`を得ます。
`num`変更可能な借用を取るのではなく、コピーの所有権を取りました。

`move`閉包について考えるもう一つの方法は、閉包に独自の山積み枠を与えます。
`move`なければ、閉包はそれを作成した山積み枠に結びつけられ、`move`閉包は自己完結型です。
つまり、一般的に、機能から非`move`閉包を返すことはできません。

しかし、閉包を受け取り、返すことについて話す前に、閉包が実装される方法についてもう少し話してください。
システム言語として、Rustは譜面が行うことを何トンも制御し、閉包も変わりません。

# 閉包の実装

Rustの閉包の実装は、他の言語とは少し異なります。
それらは事実上、特性のための略記法です。
あなたは読み持っていることを確認したいと思う[traits][traits]この1の前の章を、だけでなく、上の章[trait objects][trait-objects]。

[traits]: traits.html
 [trait-objects]: trait-objects.html


すべては？　
良い。

フックで閉包がどのように動作するかを理解するための鍵はちょっと変わったことです。Using `()`を使って`foo()`ような機能を呼び出すことは、多重定義可能な演算子です。
これ以降、他のすべてがぴったりと収まります。
Rustでは、特性システムを使用して演算子を多重定義にします。
機能の呼び出しも変わりません。
私たちには3つの異なる特性があります。

* `Fn`
* `FnMut`
* `FnOnce`

これらの特徴にはいくつかの違いがありますが、大きなものは`self`です。 `Fn`は`&self`、 `FnMut`は`&mut self`、 `FnOnce`は`self`取ります。
これは、通常の操作法呼び出し構文を使って、3種類の`self`すべてをカバーします。
しかし、1つのものを持つよりも、3つの特性に分割しました。
これにより、どのような種類の閉包を取ることができるかを大量に制御することができます。

`|| {}`
閉包のための`|| {}`構文は、これらの3つの特性のための略記法です。
Rustは環境の構造体を生成し、適切な特性を`impl`使用します。

# 閉包を引数として取る

閉包が特性であることを知ったので、閉包を受け入れて返す方法は既に知っています。他の特性と同じです！　

これは、静的対動的指名も選択できることを意味します。
まず、呼び出し可能なものをとり、呼び出して結果を返す機能を記述しましょう。

```rust
fn call_with_one<F>(some_closure: F) -> i32
    where F: Fn(i32) -> i32 {

    some_closure(1)
}

let answer = call_with_one(|x| x + 2);

assert_eq!(3, answer);
```

閉包を渡します、`|x| x + 2`
`|x| x + 2`で、`call_with_one`ます。
それは、それが示唆していることを行います。それは引数として`1`を与える閉包を呼び出します。

`call_with_one`の型指示をさらに詳しく調べてみましょう。

```rust
fn call_with_one<F>(some_closure: F) -> i32
#    where F: Fn(i32) -> i32 {
#    some_closure(1) }
```

1つのパラメータを取り、型`F`持ちます。
`i32`も返します。
この部分は興味深いものではありません。
次の部分は次のとおりです。

```rust
# fn call_with_one<F>(some_closure: F) -> i32
    where F: Fn(i32) -> i32 {
#   some_closure(1) }
```

`Fn`は特性なので、総称型の縛りとして使うことができます。
この場合、閉包がかかる`i32`引数としてと返し`i32`、そして使用するので、一般的な束縛がある`Fn(i32) -> i32`。

もう1つの重要な点があります。特性を持つ総称化を囲んでいるため、これは単体化されるため、閉包に静的な指名を行います。
それはかなりきれいです。
多くの言語では、閉包は本質的に原に割り当てられ、常に動的指名を伴います。
Rustでは、閉包環境を山して静的に呼び出すことができます。
これは反復子とそのアダプタで頻繁に起こります。これは引数として閉包を使用することがよくあります。

もちろん、動的指名が必要な場合は、それを取得することもできます。
trait対象は、通常どおりこのケースを処理します。

```rust
fn call_with_one(some_closure: &Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

let answer = call_with_one(&|x| x + 2);

assert_eq!(3, answer);
```

今度は、`&Fn`という特性対象を取り`&Fn`。
`call_with_one`に渡すときに閉包の参照をする`call_with_one`があるので、`&||`を使用します。
。

明示的な存続期間を使用する閉包についての簡単なメモ。
場合によっては、次のような参照をとる閉包を使用することがあります。

```rust
fn call_with_ref<F>(some_closure:F) -> i32
    where F: Fn(&i32) -> i32 {

    let value = 0;
    some_closure(&value)
}
```

通常、閉包に対するパラメータの有効期間を指定することができます。
機能宣言に注釈を付けることができます。

```rust,ignore
fn call_with_ref<'a, F>(some_closure:F) -> i32
    where F: Fn(&'a i32) -> i32 {
```

しかしながら、これは場合に問題を提示します。
ある機能に明示的な存続時間パラメータがある場合、その存続時間は、少なくともその機能への呼び出し*全体の*長さと同じでなければなりません。
借用検査器は、機能本体内で宣言された後にのみ有効範囲内にあるため、`value`が十分長く存続しないと不満を`value`。

必要とするのは、外部機能の有効範囲ではなく、独自の呼び出し有効範囲に対してのみ引数を借りることができる閉包です。
それを言うには、`for<...>`構文でHigher-Rank Trait Boundsを使うことができます。

```ignore
fn call_with_ref<F>(some_closure:F) -> i32
    where F: for<'a> Fn(&'a i32) -> i32 {
```

これにより、Rust製譜器は、閉包を呼び出し、借用検査器のルールを満たすための最小有効期間を見つけることができます。
機能は、製譜し、期待通りに実行します。

```rust
fn call_with_ref<F>(some_closure:F) -> i32
    where F: for<'a> Fn(&'a i32) -> i32 {

    let value = 0;
    some_closure(&value)
}
```

# 機能指し手と閉包

機能指し手は、環境を持たない閉包のようなものです。
したがって、閉包引数を期待する機能に機能指し手を渡すことができます。

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

この例では、厳密に中間変数`f`必要とせず、機能の名前もうまくいきます。

```rust,ignore
let answer = call_with_one(&add_one);
```

# 閉包を返す

機能スタイルの譜面では、さまざまな状況で閉包を返すのが一般的です。
閉包を返そうとすると、誤りが発生する可能性があります。
最初は奇妙に見えるかもしれませんが、わかります。
おそらく、機能から閉包を返そうとすると、次のようになります。

```rust,ignore
fn factory() -> (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

これにより、これらの長くて関連した誤りが発生します。

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

機能から何かを返すために、Rustは戻り値の型がどれくらいのサイズかを知る必要があります。
しかし、`Fn`は特性であるため、さまざまなサイズのさまざまなものがあり`Fn`。多くの異なる型が`Fn`を実装でき`Fn`。
参照用のサイズが既知であるため、サイズを指定する簡単な方法は、参照を行うことです。
だからこれを書くだろう。

```rust,ignore
fn factory() -> &(Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

しかし、別の誤りが発生します。

```text
error: missing lifetime specifier [E0106]
fn factory() -> &(Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~~
```

右。
参照を持っているので、それを寿命与える必要があります。
しかし、`factory()`機能は引数を取らないので、[elision](lifetimes.html#lifetime-elision)はここでは[elision](lifetimes.html#lifetime-elision)しません。
それから、どんな選択肢がありますか？　
`'static`試してください。

```rust,ignore
fn factory() -> &'static (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

しかし、別の誤りが発生します。

```text
error: mismatched types:
 expected `&'static core::ops::Fn(i32) -> i32`,
    found `[closure@<anon>:7:9: 7:20]`
(expected &-ptr,
    found closure) [E0308]
         |x| x + num
         ^~~~~~~~~~~

```

この誤りは、私たちに`&'static Fn(i32) -> i32`がないことを知らせるものです。`[closure@<anon>:7:9: 7:20]`を持っています。
待って、何？　

各閉包は`Fn`やフレンドの独自の環境`struct`と実装を生成するため、これらの型は無名です。
それらはこの閉包のためだけに存在します。
そこで、Rustは自動生成された名前ではなく、`closure@<anon>`として表示します。

この誤りは、戻り値の型が参照であると予想されていることも指摘していますが、返す値は返されません。
さらに、対象に`'static`寿命を直接割り当てることはできません。
だから`Fn` `Box`使って別のアプローチを取って 'trait object'を返し`Fn`。
これは _ほとんど_ 動作します。

```rust,ignore
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(|x| x + num)
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

最後の問題は1つだけです。

```text
error: closure may outlive the current function, but it borrows `num`,
which is owned by the current function [E0373]
Box::new(|x| x + num)
         ^~~~~~~~~~~
```

さて、前に議論したように、閉包は環境を借ります。
この場合、環境は、変数`num`束縛された山割り当て`5`に基づいています。
したがって、借用には山積み枠の寿命があります。
したがって、この閉包を返すと、機能呼び出しが終了し、山積み枠がなくなり、閉包がゴミ記憶域の環境を捕獲しています！　
1つの最後の修正で、この作業を行うことができます。

```rust
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(move |x| x + num)
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

内側の閉包を`move Fn`にすることで、閉包用の新しい山積み枠を作成します。
`Box`アップすることで、山積み枠から脱出できるように、既知のサイズを与えました。
