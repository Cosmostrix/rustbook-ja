% 用語集

Rustacean の皆がみな算系演譜や計算機科学の経験をお持ちというわけではないので、
なじみのないかもしれない術語の説明を足しておきました。

<!--Not every Rustacean has a background in systems programming, nor in computer
science, so we've added explanations of terms that might be unfamiliar.-->

### 抽象構文木 (AST; Abstract Syntax Tree) {#abstract-syntax-tree}

<!-- ### Abstract Syntax Tree -->

製譜器が算譜を製譜するとき、様々な行程が関わってきます。
そのうちのひとつが、算譜の文字の並びを抽象構文木 (AST) に変換することです。
この木は算譜の構造を表したもので、例えば、`2 + 3` は次のような木に変換されます。

<!--When a compiler is compiling your program, it does a number of different things.
One of the things that it does is turn the text of your program into an
‘abstract syntax tree’, or ‘AST’. This tree is a representation of the structure
of your program. For example, `2 + 3` can be turned into a tree:-->

```text
  +
 / \
2   3
```

そして、`2 + (3 * 4)` はこうなります。

<!-- And `2 + (3 * 4)` would look like this: -->

```text
  +
 / \
2   *
   / \
  3   4
```

### 項数 (Arity, アリティ) {#arity}

<!-- ### Arity -->

項数とは機能や演算子が取る引数の数のことです。

<!-- Arity refers to the number of arguments a function or operation takes. -->

```rust
let x = (2, 3);
let y = (4, 6);
let z = (8, 2, 6);
```

上の例で `x` と `y` は項数 2 を持ちます。 `z` は 3 ですね。

<!-- In the example above `x` and `y` have arity 2. `z` has arity 3. -->

### 縛り (Bounds) {#bounds}

<!-- ### Bounds -->

縛りとは型または[特性][traits]にかかる制約のことです。
例えば、ある縛りが機能の取る引数上に課されていた場合、
その機能に渡される型は指示された制約を守ったものでなければなりません。

<!-- Bounds are constraints on a type or [trait][traits]. For example, if a bound
is placed on the argument a function takes, types passed to that function
must abide by that constraint. -->

[traits]: traits.html


### 動的変幅型 (DST; Dynamically Sized Type) {#dst-dynamically-sized-type}

<!-- ### DST (Dynamically Sized Type) -->

静的に決まった大きさや整列幅〈アライメント〉がない型のことです。([詳しくはこちら][link])

<!-- A type without a statically known size or alignment. ([more info][link]) -->

[link]: ../nomicon/exotic-sizes.html#dynamically-sized-types-dsts

### 式 (Expression) {#expression}

<!-- ### Expression -->

計算機演譜では、式は値、定数、変数、１つの値へと評価される演算子と機能の組み合わせから成っています。
たとえば、`2 + (3 * 4)` は 値 14 を返す式です。
式が副作用を持てることも特筆すべきでしょう。
つまり、式に含まれた機能は単に１つの値を返す以外の作用を引き起こすことができます。

<!--In computer programming, an expression is a combination of values, constants,
variables, operators and functions that evaluate to a single value. For example,
`2 + (3 * 4)` is an expression that returns the value 14. It is worth noting
that expressions can have side-effects. For example, a function included in an
expression might perform actions other than simply returning a value.-->

### 式指向言語 (Expression-Oriented Language) {#expression-oriented-language}

<!-- ### Expression-Oriented Language -->

初期の演譜言語では、[式][expression]と[文][statement]は明瞭に分かれた構文上の分類でした。
式は１つの値を持ち、文は何かを行うものでした。
しかし、後年の言語ではその区別があいまいになり、式が何かを起こしたり文が値を持つようになりました。
式指向の言語では (ほぼ) 全ての文が式であり、それゆえ値を返します。
その結果、こういった式文はそれ自身をより大きな式の一部とすることができます。

<!--In early programming languages, [expressions][expression] and
[statements][statement] were two separate syntactic categories: expressions had
a value and statements did things. However, later languages blurred this
distinction, allowing expressions to do things and statements to have a value.
In an expression-oriented language, (nearly) every statement is an expression
and therefore returns a value. Consequently, these expression statements can
themselves form part of larger expressions.-->

[expression]: glossary.html#expression
[statement]: glossary.html#statement

### 文 (Statement) {#statement}

<!-- ### Statement -->

計算機演譜では、文は演譜言語の独立した要素のうち最も小さいもので、計算機に行動を命じます。

<!--In computer programming, a statement is the smallest standalone element of a
programming language that commands a computer to perform an action.-->
