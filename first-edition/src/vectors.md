# ベクトル

「ベクトル」は、標準的な譜集型[`Vec<T>`][vec]として実装された動的または拡張可能な配列です。
`T`は任意の型のベクトルを持つことができることを意味します（詳細については、[generics][generic]の章を参照してください）。
ベクトルは常にそのデータを原に割り当てます。
あなたは`vec!`マクロでそれらを作成することができます。

```rust
#//let v = vec![1, 2, 3, 4, 5]; // v: Vec<i32>
let v = vec![1, 2, 3, 4, 5]; //  v。Vec
```

（過去に使用した`println!`マクロとは異なり、`vec!`マクロで大かっこ`[]`を使用しています。どちらの場合でもRustではこれを使用できます。

初期値を繰り返すための別の形式の`vec!`があります。

```rust
#//let v = vec![0; 10]; // A vector of ten zeroes.
let v = vec![0; 10]; //  10個のゼロのベクトル。
```

ベクトルはその内容を原上に連続した`T`配列として格納します。
つまり、製譜時に`T`のサイズ（つまり、`T`を格納するために必要なバイト数）を知ることができなければなりません。
製譜時にはいくつかのサイズを知ることはできません。
これらのためには、そのことへの指し手を格納する必要があります。ありがたいことに、[`Box`][box]型はこれに対して完全に機能します。

## 要素へのアクセス

ベクトルの特定の添字の値を取得するには、`[]` s。

```rust
let v = vec![1, 2, 3, 4, 5];

println!("The third element of v is {}", v[2]);
```

添字は`0`から数えられるため、3番目の要素は`v[2]`です。

また、`usize`型で添字を作成する必要があることに注意することも重要です。

```rust,ignore
let v = vec![1, 2, 3, 4, 5];

let i: usize = 0;
let j: i32 = 0;

#// Works:
// 作品。
v[i];

#// Doesn’t:
// しない。
v[j];
```

非`usize`型の索引付けでは、次のような誤りが発生します。

```text
error: the trait bound `collections::vec::Vec<_> : core::ops::Index<i32>`
is not satisfied [E0277]
v[j];
^~~~
note: the type `collections::vec::Vec<_>` cannot be indexed by `i32`
error: aborting due to previous error
```

そのメッセージには多くの句読点がありますが、その核心は意味があります`i32`索引付けすることはできません。

## 範囲外アクセス

存在しない添字にアクセスしようとすると。

```rust,ignore
let v = vec![1, 2, 3];
println!("Item 7 is {}", v[7]);
```

現在の走脈は次のようなメッセージで[panic]ます。

```text
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 7'
```

パニックを起こさずに範囲外の誤りを処理したい場合は、無効な添字が与えられたときに`None`を返す[`get`][get]や[`get_mut`][get_mut]ような操作法を使うことができます。

```rust
let v = vec![1, 2, 3];
match v.get(7) {
    Some(x) => println!("Item 7 is {}", x),
    None => println!("Sorry, this vector is too short.")
}
```

## 反復

いったんベクトルがあれば、`for`使ってその要素を反復することができます。
3つの版があります。

```rust
let mut v = vec![1, 2, 3, 4, 5];

for i in &v {
    println!("A reference to {}", i);
}

for i in &mut v {
    println!("A mutable reference to {}", i);
}

for i in v {
    println!("Take ownership of the vector and its element {}", i);
}
```

注。ベクターの所有権を取得して反復処理を行った後は、ベクターを再度使用することはできません。
反復しながらベクトルへの参照を取ることによって、ベクトルを複数回反復することができます。
たとえば、次の譜面は製譜されません。

```rust,ignore
let v = vec![1, 2, 3, 4, 5];

for i in v {
    println!("Take ownership of the vector and its element {}", i);
}

for i in v {
    println!("Take ownership of the vector and its element {}", i);
}
```

以下は完全に動作しますが、

```rust
let v = vec![1, 2, 3, 4, 5];

for i in &v {
    println!("This is a reference to {}", i);
}

for i in &v {
    println!("This is a reference to {}", i);
}
```

ベクターにはもっと便利な操作法があります[。APIの開発資料][vec]で読むことができ[ます][vec]。

[vec]: ../../std/vec/index.html
 [box]: ../../std/boxed/index.html
 [generic]: generics.html
 [panic]: concurrency.html#panics
 [get]: ../../std/vec/struct.Vec.html#method.get
 [get_mut]: ../../std/vec/struct.Vec.html#method.get_mut

