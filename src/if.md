% if

Rust における `if` の解釈はとくに難しいものではありませんが、
従来の算系演譜言語よりも動的型付け言語みられる `if` にずっと近いものです。
なのでここではその話をして微妙な差異を確実に理解できるようにしましょう。

<!--Rust’s take on `if` is not particularly complex, but it’s much more like the
`if` you’ll find in a dynamically typed language than in a more traditional
systems language. So let’s talk about it, to make sure you grasp the nuances.-->

`if` はより一般的な概念である「分岐 (branch)」の特別な場合です。
この名前は木の枝から取られたものです。
決定点があり、選択によっていくつもの道が選ばれることがあります。

<!--`if` is a specific form of a more general concept, the ‘branch’. The name comes
from a branch in a tree: a decision point, where depending on a choice,
multiple paths can be taken.-->

`if` の場合は 2 つの道に分かれる 1 つの選択があります。

<!--In the case of `if`, there is one choice that leads down two paths:-->

```rust
let x = 5;

if x == 5 {
    println!("x は五です！");
}
```

仮に `x` の値を何か違うものに変えたとすると、この行は印字されないでしょう。
より正確には、`if` の直後にある式が真 (`true`) に評価されたときこの段落が実行されます。
偽 (`false`) だったときは実行されません。

<!--If we changed the value of `x` to something else, this line would not print.
More specifically, if the expression after the `if` evaluates to `true`, then
the block is executed. If it’s `false`, then it is not.-->

偽 (`false`) の場合に何か起きてほしい場合は `else` を使います。

<!-- If you want something to happen in the `false` case, use an `else`: -->

```rust
let x = 5;

if x == 5 {
    println!("x は五です！");
} else {
    println!("x は五以外です :(");
}
```

場合分けがひとつでないのなら、`else if` を使います。

<!-- If there is more than one case, use an `else if`: -->

```rust
let x = 5;

if x == 5 {
    println!("x は五です！");
} else if x == 6 {
    println!("x は六です！");
} else {
    println!("x は五でも六でもありません :(");
}
```

どれもありふれた形式です。しかし、こんなこともできます。

<!-- This is all pretty standard. However, you can also do this: -->

```rust
let x = 5;

let y = if x == 5 {
    10
} else {
    15
}; // y: i32
```

上は次のようにも書けます（多分こう書くべきです）。

<!-- Which we can (and probably should) write like this: -->

```rust
let x = 5;

let y = if x == 5 { 10 } else { 15 }; // y: i32
```

これが動作するのは `if` が式であるためです。
式の値は選ばれた分岐のどれかで最後に実行された式の値です。
`else` を欠いた `if` の値は常に `()` に固定されます。

<!--This works because `if` is an expression. The value of the expression is the
value of the last expression in whichever branch was chosen. An `if` without an
`else` always results in `()` as the value.-->
