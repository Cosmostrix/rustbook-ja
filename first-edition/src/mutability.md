# 可変性

Mutabilityは何かを変更する能力で、Rustでは他の言語とは少し違って動作します。
変更可能性の第1の側面は、自動的にはない状態です。

```rust,ignore
let x = 5;
#//x = 6; // Error!
x = 6; // 誤り！　
```

`mut`予約語でmutabilityを導入することができます。

```rust
let mut x = 5;

#//x = 6; // No problem!
x = 6; // 問題ない！　
```

これは[可変束縛][vb]です。
束縛が変更可能な場合は、束縛が指しているものを変更することが許可されていることを意味します。
上記の例では、`x`の値が変化しているのではなく、束縛が1つの`i32`から別の`i32`に変更されています。

[vb]: variable-bindings.html

また、`&x`を使用して[reference][ref]を作成することもできますが、[reference][ref]を使用して変更する場合は、変更可能な参照が必要です。

```rust
let mut x = 5;
let y = &mut x;
```

[ref]: references-and-borrowing.html

`y`は可変参照への不変の束縛です。つまり、yを他のもの（`y = &mut z`）に束縛することはできませんが、 `y`を使用して`x`を他のもの（`*y = 5`）に束縛することができます。
微妙な違い。

もちろん、両方が必要な場合。

```rust
let mut x = 5;
let mut y = &mut x;
```

`y`は別の値に束縛することができ、参照している値を変更することができます。

`mut`は[pattern][pattern]一部であることに注意することが重要なので、次のようなことができます。

```rust
let (mut x, y) = (5, 6);

fn foo(mut x: i32) {
# }
```

ここでは、`x`は変更可能ですが、`y`は変更できません。

[pattern]: patterns.html

# インテリア対外の相互関係

しかし、Rustに何かが「不変」であると言うとき、それは変更できないということを意味するわけではありません。この場合の「外部の変更可能性」を指しています。
たとえば、[`Arc<T>`][arc]考えてみましょう。

```rust
use std::sync::Arc;

let x = Arc::new(5);
let y = x.clone();
```

[arc]: ../../std/sync/struct.Arc.html

`clone()`を呼び出すと、`Arc<T>`は参照カウントを更新する必要があります。
しかし、ここでは`mut`使用していないので、`x`は不変の束縛であり、`&mut 5`や何も取らなかりました。
だから何を与える？　

これを理解するためには、Rustの指導哲学、記憶の安全性、Rustがそれを保証するしくみ、[ownership][ownership]システム、より具体的には[borrowing][borrowing]の中核に戻る必要があります。

> > あなたはこれら2種類の借用のどちらか一方を持っているかもしれませんが、同時に両方ではありません。
> 
> * >    1つまたは複数の資源への参照（`&T`）
> * >    正確に1つの可変参照（`&mut T`）。

[ownership]: ownership.html
 [borrowing]: references-and-borrowing.html#borrowing


それは、「不変性」の本当の定義です。これは2つの指針を持つのが安全でしょうか？　
`Arc<T>`の場合、はい。変更は構造体自体の内部に完全に含まれています。
ユーザーが直面しているのではありません。
このため、`&T`を`clone()`で渡します。
しかし、`&mut T`渡した場合、それが問題になります。

他の型は、[`std::cell`][stdcell]役区のものと同様に、逆の内部の可変性を持っています。
例えば。

```rust
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
```

[stdcell]: ../../std/cell/index.html

RefCellは、`borrow_mut()`操作法を使用して、内部にあるものへの参照と`&mut`参照を行います。
それは危険ではないでしょうか？　
もしすれば。

```rust,ignore
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
let z = x.borrow_mut();
# (y, z);
```

これは実際には実行時にパニックになります。
`RefCell`はこれを実行します。実行時にRustの借用ルールを強制型変換し、侵害された場合は`panic!`なります。
これにより、Rustの変更可能ルールの別の側面を取り上げることができます。
まずそれについて話しましょう。

## 欄レベルの可変性

mutabilityは、borrow（`&mut`）またはbinding（ `let mut`）のいずれかのプロパティです。
これは、たとえば、いくつかの欄を変更可能なものと変更できないものがある[`struct`][struct]を持つことができないことを意味します。

```rust,ignore
struct Point {
    x: i32,
#//    mut y: i32, // Nope.
    mut y: i32, // いいえ。
}
```

構造体の可変性はその束縛にあります。

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

let mut a = Point { x: 5, y: 6 };

a.x = 10;

let b = Point { x: 5, y: 6 };

#//b.x = 10; // Error: cannot assign to immutable field `b.x`.
b.x = 10; // 誤り。不変欄`bx`代入することはできません。
```

[struct]: structs.html

ただし、[`Cell<T>`][cell]を使用すると、欄レベルの可変性を再現できます。

```rust
use std::cell::Cell;

struct Point {
    x: i32,
    y: Cell<i32>,
}

let point = Point { x: 5, y: Cell::new(6) };

point.y.set(7);

println!("y: {:?}", point.y);
```

[cell]: ../../std/cell/struct.Cell.html

これは`y: Cell { value: 7 }`ます。
`y`を正常に更新しました。
