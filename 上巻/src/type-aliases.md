% 型の別名

予約語 `type` によって他の型の 別名 (alias)〈エイリアス〉を宣言できます。

<!-- The `type` keyword lets you declare an alias of another type: -->

```rust
type Name = String;
```

この型は、あたかも実際の型であるかのように使えます。

<!-- You can then use this type as if it were a real type: -->

```rust
type Name = String;

let x: Name = "Hello".to_string();
```

しかし、注意が必要なのはこの型があくまで _別名_ なのであって全く新しい型ではないという点です。
言い換えると、Rust は強く型付けする言語であり、通常 2 つの異なる型の比較は失敗すると期待できます。

<!--Note, however, that this is an _alias_, not a new type entirely. In other
words, because Rust is strongly typed, you’d expect a comparison between two
different types to fail:-->

```rust,ignore
let x: i32 = 5;
let y: i64 = 5;

if x == y {
   // ...
}
```

上記を与えると、

<!-- this gives -->

```text
error: mismatched types:
 expected `i32`,
    found `i64`
(expected i32,
    found i64) [E0308]
     if x == y {
             ^
```

と返されます。
ところが、別名に対しては、

<!-- But, if we had an alias: -->

```rust
type Num = i32;

let x: i32 = 5;
let y: Num = 5;

if x == y {
   // ...
}
```

これが問題なく製譜されます。実際、`Num` 型の値は型 `i32` の値と完全に同一です。
本当に新しい型は[組構造体][tuple struct]を使うと得られます。

<!--This compiles without error. Values of a `Num` type are the same as a value of
type `i32`, in every way. You can use [tuple struct] to really get a new type.-->

[tuple struct]: structs.html#tuple-structs

総称型と型別名を組み合わせて使うことも可能です。

<!-- You can also use type aliases with generics: -->

```rust
use std::result;

enum ConcreteError {
    Foo,
    Bar,
}

type Result<T> = result::Result<T, ConcreteError>;
```

ここでは `Result` 型のより狭義な版を作っています。
`Result<T, E>` の `E` の部分がいつも `ConcreteError` になるように定義しています。
この手法は標準譜集の下位のまとまりで独自の誤りを定義するときによく使われています。
例えば、[io::Result][ioresult] がそうです。

<!--This creates a specialized version of the `Result` type, which always has a
`ConcreteError` for the `E` part of `Result<T, E>`. This is commonly used
in the standard library to create custom errors for each subsection. For
example, [io::Result][ioresult].-->

[ioresult]: ../std/io/type.Result.html
