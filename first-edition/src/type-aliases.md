# タイプエイリアス

`type`キーワードを使用すると、別のタイプのエイリアスを宣言できます。

```rust
type Name = String;
```

この型は、実際の型のように使用できます。

```rust
type Name = String;

let x: Name = "Hello".to_string();
```

ただし、これは _エイリアス_ であり、新しいタイプではありません。
つまり、Rustは強く型付けされているため、2つの異なる型の比較が失敗すると予想されます。

```rust,ignore
let x: i32 = 5;
let y: i64 = 5;

if x == y {
#   // ...
   // ...
}
```

これは与える

```text
error: mismatched types:
 expected `i32`,
    found `i64`
(expected i32,
    found i64) [E0308]
     if x == y {
             ^
```

しかし、エイリアスがあれば：

```rust
type Num = i32;

let x: i32 = 5;
let y: Num = 5;

if x == y {
#   // ...
   // ...
}
```

これはエラーなしでコンパイルされます。
`Num`型の値は、すべての点で、型`i32`値と同じです。
あなたは本当に新しい型を取得するために[tuple struct]を使用することができます。

[tuple struct]: structs.html#tuple-structs

ジェネリックでタイプエイリアスを使用することもできます：

```rust
use std::result;

enum ConcreteError {
    Foo,
    Bar,
}

type Result<T> = result::Result<T, ConcreteError>;
```

これにより`Result`型の特殊バージョンが作成され、`Result<T, E>` `E`部分に常に`ConcreteError`があります。
これは、各サブセクションのカスタムエラーを作成するために標準ライブラリでよく使用されます。
たとえば、[io::Result][ioresult]です。

[ioresult]: ../../std/io/type.Result.html
