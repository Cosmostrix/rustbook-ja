# ジェネリックス

時には、関数やデータ型を書くときに、複数の型の引数を扱うことが必要な場合があります。
Rustでは、ジェネリックでこれを行うことができます。
型理論では、パラメトリック多形性と呼ばれ、与えられたパラメータ（パラメトリック）に対して複数の型（'ポリ'は複数、'morph'はフォーム）を持つ型または関数であることを意味します。

とにかく、十分な型理論、いくつかの一般的なコードを調べてみましょう。
Rustの標準ライブラリは、汎用の`Option<T>`型を提供します：

```rust
enum Option<T> {
    Some(T),
    None,
}
```

数回前に見た`<T>`部分は、これが汎用データ型であることを示しています。
`enum`型の宣言の中で、`T`どこにあっても、汎用型で使われているのと同じ型をその型に置き換えます。
`Option<T>`使用例といくつかの余分な型の注釈があります：

```rust
let x: Option<i32> = Some(5);
```

型宣言では、`Option<i32>`と言います。
これは`Option<T>`と似ています。
したがって、この特定の`Option`、 `T`の値は`i32`です。
バインディングの右側で、`Some(T)`を作成します`T`は`5`です。
それは`i32`、両面が一致し、Rustは満足しています。
一致しなかった場合、エラーが発生します。

```rust,ignore
let x: Option<f64> = Some(5);
#// error: mismatched types: expected `core::option::Option<f64>`,
#// found `core::option::Option<_>` (expected f64 but found integral variable)
// エラー：タイプが一致しません：期待される`core::option::Option<f64>`、 `core::option::Option<_>`見つけました。`core::option::Option<_>`（期待されるf64ですが、
```

つまり、`f64`を保持する`Option<T>`作ることはできません！
彼らは一致する必要があります：

```rust
let x: Option<i32> = Some(5);
let y: Option<f64> = Some(5.0f64);
```

これは大丈夫です。
1つの定義、複数の用途。

ジェネリックスは、1つのタイプに対して汎用的である必要はありません。
Rustの標準ライブラリの別の型である`Result<T, E>`考えてみましょう：

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

このタイプは、`T`と`E`  _2つの_ タイプより一般的です。
ところで、大文字は好きな文字にすることができます。
`Result<T, E>`を次のように定義することができます。

```rust
enum Result<A, Z> {
    Ok(A),
    Err(Z),
}
```

私たちが望むならば。
条約では、最初のジェネリックパラメータは 'type'の場合は`T`、 'error'の場合は`E`を使用する必要があります。
しかし、錆は気にしない。

`Result<T, E>`型は、計算の結果を返し、うまくいかなかった場合にエラーを返すためのものです。

## 汎用関数

同様の構文を持つジェネリック型を取る関数を書くことができます：

```rust
fn takes_anything<T>(x: T) {
#    // Do something with `x`.
    //  `x`何かする
}
```

構文は、2つの部分があります。`<T>` 「この関数は1種類、オーバー総称であると言う`T`、および」 `x: T` 「xは型があると言う`T`。」

複数の引数は同じジェネリック型を持つことができます：

```rust
fn takes_two_of_the_same_things<T>(x: T, y: T) {
#    // ...
    // ...
}
```

複数の型を取るバージョンを書くことができます：

```rust
fn takes_two_things<T, U>(x: T, y: U) {
#    // ...
    // ...
}
```

## 一般的な構造体

`struct`ジェネリック型を格納することもできます：

```rust
struct Point<T> {
    x: T,
    y: T,
}

let int_origin = Point { x: 0, y: 0 };
let float_origin = Point { x: 0.0, y: 0.0 };
```

関数と同様に、`<T>`は汎用パラメータを宣言するところであり、型宣言では`x: T`使用します。

ジェネリック`struct`実装を追加する場合は、`impl`後にtypeパラメータを宣言します。

```rust
# struct Point<T> {
#     x: T,
#     y: T,
# }
#
impl<T> Point<T> {
    fn swap(&mut self) {
        std::mem::swap(&mut self.x, &mut self.y);
    }
}
```

これまでのところ、どのようなタイプのものでもジェネリックスを見てきました。
これらは多くの場合に便利です：あなたは既に`Option<T>`見てきましたが、後で[`Vec<T>`][Vec]ような普遍的なコンテナのタイプを満たすでしょう。
一方、表現力を高めるために柔軟性を交換することがしばしばあります。
なぜ、どのようにするかについては、[trait bounds][traits]について読むこと。

## あいまいさの解決

ジェネリックが関与しているほとんどの場合、コンパイラはジェネリックパラメータを自動的に推論できます。

```rust
#// v must be a Vec<T> but we don't know what T is yet
//  vはVecでなければならない Tが何であるかは分かりません
let mut v = Vec::new();
#// v just got a bool value, so T must be bool!
//  vはちょうどbool値を持っているので、Tはboolでなければならない！
v.push(true);
#// Debug-print v
// デバッグ印刷v
println!("{:?}", v);
```

しかし時には、コンパイラは少し助けが必要です。
たとえば、最後の行を省略した場合、コンパイルエラーが発生します。

```rust,ignore
let v = Vec::new();
#//      ^^^^^^^^ cannot infer type for `T`
//  ^^^^^^^^ `T`は推論できない
//
#// note: type annotations or generic parameter binding required
// 注釈：型注釈またはジェネリックパラメータバインディングが必要
println!("{:?}", v);
```

型の注釈を使用するか、

```rust
let v: Vec<bool> = Vec::new();
println!("{:?}", v);
```

またはいわゆる['turbofish'][turbofish] `::<>`構文を介して汎用パラメータ`T`を束縛することによって、

```rust
let v = Vec::<bool>::new();
println!("{:?}", v);
```

2番目のアプローチは、結果を変数にバインドしたくない状況で便利です。
また、関数またはメソッドで汎用パラメーターをバインドするためにも使用できます。
例については、「 [反復子](iterators.html#consumers) 」を参照してください。

[traits]: traits.html
 [Vec]: ../../std/vec/struct.Vec.html
 [turbofish]: ../../std/iter/trait.Iterator.html#method.collect

