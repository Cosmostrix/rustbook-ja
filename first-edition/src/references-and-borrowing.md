# 参照と借用

これは、Rustの所有システムを提示する3つのセクションのうちの2番目です。
これは、Rustの最も顕著で魅力的な機能の1つで、Rustの開発者はかなり知り合いになるはずです。
所有権とは、Rustが最大の目標であるメモリの安全性を達成する方法です。
いくつかの異なる概念があり、それぞれ独自の章があります。

* [ownership][ownership]、キーコンセプト
* あなたが今読んでいる借り
* [lifetimes][lifetimes]、高度な借入概念

これら3つの章は関連しており、順番に説明されています。
所有権システムを完全に理解するには、3つすべてが必要です。

[ownership]: ownership.html
 [lifetimes]: lifetimes.html


# メタ

詳細を知る前に、オーナーシップシステムに関する2つの重要な注意事項。

錆は安全性とスピードに焦点を当てています。
これは、多くの「ゼロコスト抽象化」によってこれらの目標を達成します。つまり、Rustでは抽象化のコストをできるだけ少なくして機能させることを意味します。
所有権システムは、ゼロコスト抽象化の主要な例です。
このガイド _で説明する_ すべての分析は _、コンパイル時に行われます_ 。
これらの機能のランタイムコストを支払うことはありません。

しかし、このシステムには一定のコストがあります：学習曲線。
Rustの新しいユーザーの多くは、Rustコンパイラが作成者が有効だと思うプログラムをコンパイルすることを拒否する「borrow checkerとの戦い」と呼ばれることを経験しています。
これは、所有者がどのように動作するかについてのプログラマーの精神モデルが、Rustが実装する実際のルールと一致しないためによく発生します。
最初は似たようなことを経験するでしょう。
ただし、経験豊かなRustデベロッパーは、所有システムのルールを一定期間使用すると、借りチェッカーとの競争が少なくなることを報告しています。

それを念頭において、借り入れについて学びましょう。

# 借りる

[ownership][ownership]セクションの最後には、次のような厄介な機能がありました。

```rust
fn foo(v1: Vec<i32>, v2: Vec<i32>) -> (Vec<i32>, Vec<i32>, i32) {
#    // Do stuff with `v1` and `v2`.
    //  `v1`と`v2`ものを使ってください。

#    // Hand back ownership, and the result of our function.
    // 手持ちの所有権と私たちの機能の結果。
    (v1, v2, 42)
}

let v1 = vec![1, 2, 3];
let v2 = vec![1, 2, 3];

let (v1, v2, answer) = foo(v1, v2);
```

しかし、借用を利用していないので、これは慣用的な錆ではありません。
ここでは最初のステップです：

```rust
fn foo(v1: &Vec<i32>, v2: &Vec<i32>) -> i32 {
#    // Do stuff with `v1` and `v2`.
    //  `v1`と`v2`ものを使ってください。

#    // Return the answer.
    // 答えを返します。
    42
}

let v1 = vec![1, 2, 3];
let v2 = vec![1, 2, 3];

let answer = foo(&v1, &v2);

#// We can use `v1` and `v2` here!
// ここで`v1`と`v2`を使うことができます！
```

より具体的な例：

```rust
fn main() {
#    // Don't worry if you don't understand how `fold` works, the point here is that an immutable reference is borrowed.
    //  `fold`仕組みがわからない場合は心配しないでください。ここでのポイントは、不変のリファレンスが借用されていることです。
    fn sum_vec(v: &Vec<i32>) -> i32 {
        v.iter().fold(0, |a, &b| a + b)
    }
#    // Borrow two vectors and sum them.
#    // This kind of borrowing does not allow mutation through the borrowed reference.
    //  2つのベクトルを借りて合計します。このような借り入れは、借用された参照による突然変異を許さない。
    fn foo(v1: &Vec<i32>, v2: &Vec<i32>) -> i32 {
#        // Do stuff with `v1` and `v2`.
        //  `v1`と`v2`ものを使ってください。
        let s1 = sum_vec(v1);
        let s2 = sum_vec(v2);
#        // Return the answer.
        // 答えを返します。
        s1 + s2
    }

    let v1 = vec![1, 2, 3];
    let v2 = vec![4, 5, 6];

    let answer = foo(&v1, &v2);
    println!("{}", answer);
}
```

`Vec<i32>`引数として取るのではなく、`&Vec<i32>`参照します。
そして、`v1`と`v2`直接渡す代わりに、`&v1`と`&v2`を渡します。
`&T`タイプは「参照」と呼ばれ、リソースを所有するのではなく、所有権を借りています。
何かを借りるバインディングは、リソースが範囲外になったときにリソースの割り当てを解除しません。
これは、`foo()`呼び出しの後、元のバインディングを再度使用できることを意味します。

参照はバインドのように不変です。
つまり、`foo()`内部では、ベクトルをまったく変更することはできません。

```rust,ignore
fn foo(v: &Vec<i32>) {
     v.push(5);
}

let v = vec![];

foo(&v);
```

私たちにこのエラーを与えるでしょう：

```text
error: cannot borrow immutable borrowed content `*v` as mutable
v.push(5);
^
```

値を押すとベクトルが変化するので、それを行うことはできません。

# mutリファレンス（＆M）

2番目の種類の参照： `&mut T`ます。
'mutable reference'は、あなたが借りているリソースを突然変異させることを可能にします。
例えば：

```rust
let mut x = 5;
{
    let y = &mut x;
    *y += 1;
}
println!("{}", x);
```

これにより、`6`が印刷されます。
`y`を`x`変更可能な参照とし、`y`点に追加する。
あなたは`x`も`mut`とマークされなければならないことに気付くでしょう。
もしそうでなければ、不変の価値に変更可能な借り入れをすることができませんでした。

あなたはまた、我々はアスタリスク（追加気付くでしょう`*`目の前に）`y`それ作り、`*y`ためである、`y`ある`&mut`参照。
参照の内容にもアスタリスクを使用する必要があります。

それ以外の場合、`&mut`リファレンスは同じ参照です。
2、およびそれらがどのようにかかわらず、対話の間には大きな違いが _あり_ ます。
上記の例では、`{`と`}`で余分なスコープが必要なので、何かが怪しいと言うことができます。
削除した場合、エラーが発生します：

```text
error: cannot borrow `x` as immutable because it is also borrowed as mutable
    println!("{}", x);
                   ^
note: previous borrow of `x` occurs here; the mutable borrow prevents
subsequent moves, borrows, or modification of `x` until the borrow ends
        let y = &mut x;
                     ^
note: previous borrow ends here
fn main() {

}
^
```

それが判明したので、規則があります。

# ルール

Rustで借りるための規則は次のとおりです。

まず、借り入れは所有者の範囲を超えない範囲で継続する必要があります。
第二に、これらの2種類の借用のどちらか一方を持つことができますが、同時に両方を使うことはできません。

* 1つまたは複数のリソースへの参照（`&T`）
* 正確に1つの可変参照（`&mut T`）。


これは、データレースの定義とまったく同じではありませんが、これと非常によく似ています。

> > 2つ以上のポインタが同じメモリ位置に同時にアクセスするときに、それらのうちの少なくとも1つが書き込みを行っており、その動作が同期されていない場合、「データ競合」が存在する。

参考文献では、どれもあなたが好きなだけ書くことはできません。
しかし、一度に1つの`&mut`しか持つことができないため、データ競争は不可能です。
これは、Rustがコンパイル時にデータ競合を防止する方法です。規則を破るとエラーが発生します。

これを念頭に置いて、例をもう一度考えてみましょう。

## スコープで考える

コードは次のとおりです：

```rust,ignore
fn main() {
    let mut x = 5;
    let y = &mut x;

    *y += 1;

    println!("{}", x);
}
```

このコードは私たちにこのエラーを与えます：

```text
error: cannot borrow `x` as immutable because it is also borrowed as mutable
    println!("{}", x);
                   ^
```

これは、我々がルールに違反したためです： `x`指している`&mut T`があるため、`&T`を作成することはできません。
それはどちらか一方です。
ノートは、この問題についてどのように考えるべきかを示唆しています。

```text
note: previous borrow ends here
fn main() {

}
^
```

言い換えれば、変更可能な借り入れは、残りの例を介して保持されます。
私たちが望むのは、リソースが所有者`x`返されるように、`y`が終了する可変の借用です。
`x`は`println!`不変の借用を提供することができます。
Rustでは、借り入れは借用が有効な範囲に縛られています。
スコープは次のようになります。

```rust,ignore
fn main() {
    let mut x = 5;

#//    let y = &mut x;    // -+ &mut borrow of `x` starts here.
#                       //  |
    let y = &mut x;    // ここでは`x` +＆mut borrowが始まります。|
#//    *y += 1;           //  |
#                       //  |
    *y += 1;           //  | |
#//    println!("{}", x); // -+ - Try to borrow `x` here.
    println!("{}", x); //  -+ -ここで`x`を借りてみてください。
#//}                      // -+ &mut borrow of `x` ends here.
}                      //  -+＆mutの`x`借用はここで終わります。
                       
```

スコープの競合： `y`がスコープ内にある`&x`を作ることはできません。

したがって、中括弧を追加すると：

```rust
let mut x = 5;

{
#//    let y = &mut x; // -+ &mut borrow starts here.
    let y = &mut x; //  -+＆mut borrowはここから始まります。
#//    *y += 1;        //  |
    *y += 1;        //  |
#//}                   // -+ ... and ends here.
}                   //  -+...ここで終わります。

#//println!("{}", x);  // <- Try to borrow `x` here.
println!("{}", x);  //  < -ここで`x`を借りてみてください。
```

何も問題ない。
不変のものを作る前に、私たちの可変的な借りは範囲外になります。
スコープは、借りがどれくらい持続するかを見るための鍵です。

## 借入問題は防止する

なぜこれらの制限的な規則はありますか？
さて、われわれが指摘したように、これらのルールはデータ競合を防ぎます。
データ競争の原因となる問題は何ですか？
ここにいくつかあります。

### イテレータの無効化

1つの例は 'iterator invalidation'です。反復処理中のコレクションを変更しようとすると発生します。
Rustの借用チェッカーがこれを防ぐ：

```rust
let mut v = vec![1, 2, 3];

for i in &v {
    println!("{}", i);
}
```

これは1から3までを印刷します。
ベクトルを反復処理するとき、要素への参照のみが与えられます。
そして、`v`自体は不変として借用されています。つまり、反復処理中に変更することはできません。

```rust,ignore
let mut v = vec![1, 2, 3];

for i in &v {
    println!("{}", i);
    v.push(34);
}
```

ここにエラーがあります：

```text
error: cannot borrow `v` as mutable because it is also borrowed as immutable
    v.push(34);
    ^
note: previous borrow of `v` occurs here; the immutable borrow prevents
subsequent moves or mutable borrows of `v` until the borrow ends
for i in &v {
          ^
note: previous borrow ends here
for i in &v {
    println!(“{}”, i);
    v.push(34);
}
^
```

`v`がループによって借用されているため、`v`変更することはできません。

### 無料で使用する

参照は参照するリソースより長く生きてはならない。
Rustはあなたの参照のスコープをチェックして、これが正しいことを確認します。

Rustがこのプロパティをチェックしなかった場合、誤って無効な参照を使用する可能性があります。
例えば：

```rust,ignore
let y: &i32;
{
    let x = 5;
    y = &x;
}

println!("{}", y);
```

このエラーが発生します：

```text
error: `x` does not live long enough
    y = &x;
         ^
note: reference must be valid for the block suffix following statement 0 at
2:16...
let y: &i32;
{
    let x = 5;
    y = &x;
}

note: ...but borrowed value is only valid for the block suffix following
statement 0 at 4:18
    let x = 5;
    y = &x;
}
```

つまり、`y`は`x`が存在するスコープに対してのみ有効です。
`x`がなくなると、それを参照するのが無効になります。
そのようなエラーは、借りている時間が適切ではないため、「十分に長く生きていない」と言います。

同じ問題は、変数が参照さ _れる前に_ 参照が宣言されている場合に発生します。
これは、同じスコープ内のリソースが宣言された順序と反対の順序で解放されるためです。

```rust,ignore
let y: &i32;
let x = 5;
y = &x;

println!("{}", y);
```

このエラーが発生します：

```text
error: `x` does not live long enough
y = &x;
     ^
note: reference must be valid for the block suffix following statement 0 at
2:16...
    let y: &i32;
    let x = 5;
    y = &x;

    println!("{}", y);
}

note: ...but borrowed value is only valid for the block suffix following
statement 1 at 3:14
    let x = 5;
    y = &x;

    println!("{}", y);
}
```

上記の例では、`y`は`x`前に宣言されています。つまり、`y`は`x`よりも長く存続しますが、これは許可されません。
