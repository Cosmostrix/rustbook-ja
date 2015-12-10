% ベクトル

「ベクトル」は動的、すなわち「伸長可能な」配列であり、標準譜集の型 [`Vec<T>`][vec] として実装されています。
`T` はどのような型のベクトルでも作れるという意味です (詳しくは[総称型][generic]の章をご覧ください)。
ベクトルの要素は常に原に割り付けられます。
ベクトルは次のように `vec!` マクロを使って作成できます。

<!--A ‘vector’ is a dynamic or ‘growable’ array, implemented as the standard
library type [`Vec<T>`][vec]. The `T` means that we can have vectors
of any type (see the chapter on [generics][generic] for more).
Vectors always allocate their data on the heap.
You can create them with the `vec!` macro:-->

```rust
let v = vec![1, 2, 3, 4, 5]; // v: Vec<i32>
```

(以前使った `println!` マクロとは異なり、`vec!` マクロでは大かっこ (角かっこ) `[]`
を使っているところに注目しましょう。
Rust は両方の記号をどちらの状況でも使うことを認めています。 この書き分けはただの慣習です。)

<!--(Notice that unlike the `println!` macro we’ve used in the past, we use square
brackets `[]` with `vec!` macro. Rust allows you to use either in either situation,
this is just convention.)-->

`vec!` には別の形式があり、 1 個の初期値で全要素を埋めることができます。

<!--There’s an alternate form of `vec!` for repeating an initial value:-->

```rust
let v = vec![0; 10];  // 0 が 10 個
```

## 要素を取り出す {#accessing-elements}

<!-- ## Accessing elements -->

ベクトルの決まった添字 (index)〈インデックス〉の位置にある値を得るには、`[]` を使い

<!-- To get the value at a particular index in the vector, we use `[]`s: -->

```rust
let v = vec![1, 2, 3, 4, 5];

println!("v の三番目の要素は {} です", v[2]);
# println!("The third element of v is {}", v[2]);
```

添字は `0` から数えはじめるため、3 番目の要素は `v[2]` となります。

<!-- The indices count from `0`, so the third element is `v[2]`. -->

添字のもつ型は `usize` でなければならない点もまた重要です。

<!-- It’s also important to note that you must index with the `usize` type: -->

```ignore
let v = vec![1, 2, 3, 4, 5];

let i: usize = 0;
let j: i32 = 0;

// 動く
# // works
v[i];

// 動かない
# // doesn’t
v[j];
```

`usize` でない型を添字の位置に使った場合はこのような誤りを返されます。

<!-- Indexing with a non-`usize` type gives an error that looks like this: -->

```text
誤り。 特性 `core::ops::Index<i32>` は
 型 `collections::vec::Vec<_>` に対しては実装されていません [E0277]
v[j];
↑~~~
注。 型 `collections::vec::Vec<_>` は `i32` で添字づけられる型ではありません
誤り。 前述の誤りにより中止します
```

```text
error: the trait `core::ops::Index<i32>` is not implemented for the type
`collections::vec::Vec<_>` [E0277]
v[j];
^~~~
note: the type `collections::vec::Vec<_>` cannot be indexed by `i32`
error: aborting due to previous error
```

記号がたくさん並んでいますが、要は `i32` を添え字に使えないということです。

<!--There’s a lot of punctuation in that message, but the core of it makes sense:
you cannot index with an `i32`.-->

## 反復する {#iterating}

<!-- ## Iterating -->

ベクトルを一度作ってしまえば、その要素全体を `for` で反復していけます。
これには 3 つの書き方があります。

<!--Once you have a vector, you can iterate through its elements with `for`. There
are three versions:-->

```rust
let mut v = vec![1, 2, 3, 4, 5];

for i in &v {
    println!("{} への参照", i);
#    println!("A reference to {}", i);
}

for i in &mut v {
    println!("{} への可変な参照", i);
#    println!("A mutable reference to {}", i);
}

for i in v {
    println!("{} は所有権を取得したベクトルの要素", i);
#    println!("Take ownership of the vector and its element {}", i);
}
```

ベクトルにはさらに多くの有用な操作法が定義されています。
それらの操作法については [ベクトルの API 資料集][vec] をご覧ください。

<!--Vectors have many more useful methods, which you can read about in [their
API documentation][vec].-->

[vec]: ../std/vec/index.html
[generic]: generics.html
