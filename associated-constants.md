% 付属定数

付属定数 (`associated_consts`) 機構により、定数をこのように定義できます。

```rust
#![feature(associated_consts)]

trait Foo {
    const ID: i32;
}

impl Foo for i32 {
    const ID: i32 = 1;
}

fn main() {
    assert_eq!(1, i32::ID);
}
```

`Foo` の実装側は `ID` の定義を求められるようになります。定義が無かった場合、

```rust,ignore
#![feature(associated_consts)]

trait Foo {
    const ID: i32;
}

impl Foo for i32 {
}
```

は、

```text
誤り。 特性項目の全てが実装されておらず、 `ID` を欠いています。 [E0046]
     impl Foo for i32 {
     }
```

```text
error: not all trait items implemented, missing: `ID` [E0046]
     impl Foo for i32 {
     }
```

を与えます。
さらに、黙用値〈デフォルト値〉も定義できます。

```rust
#![feature(associated_consts)]

trait Foo {
    const ID: i32 = 1;
}

impl Foo for i32 {
}

impl Foo for i64 {
    const ID: i32 = 5;
}

fn main() {
    assert_eq!(1, i32::ID);
    assert_eq!(5, i64::ID);
}
```

この通り、`Foo` の実装時には `i32` に対する実装のように実装を省略できます。
その場合には黙用値が使われますが、`i64` のように独自の定義を行うこともできます。

付属定数は特性以外にも付けられます。構造体 (`struct`) 用の `impl` 段落〈ブロック〉でも機能します。

```rust
#![feature(associated_consts)]

struct Foo;

impl Foo {
    pub const FOO: u32 = 3;
}
```
