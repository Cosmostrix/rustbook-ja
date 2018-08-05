# ドロップ

ここでは、特性について説明したので、Rust標準ライブラリ[`Drop`][drop]によって提供される特定の特性について説明しましょう。
`Drop`特性は、値が有効範囲外になったときにコードを実行する方法を提供します。
例えば：

[drop]: ../../std/ops/trait.Drop.html

```rust
struct HasDrop;

impl Drop for HasDrop {
    fn drop(&mut self) {
        println!("Dropping!");
    }
}

fn main() {
    let x = HasDrop;

#    // Do stuff.
    // ものをする。

#//} // `x` goes out of scope here.
} //  `x`はここで範囲外になります。
```

`x`が`main()`最後にスコープから外れると、`Drop`のコードが実行されます。
`Drop`は`drop()`と呼ばれる1つのメソッドがあります。
それは`self`への変更可能な参照を取ります。

それでおしまい！
`Drop`の仕組みはとてもシンプルですが、いくつかの微妙な点があります。
たとえば、値は宣言された順序と逆の順序でドロップされます。
別の例があります：

```rust
struct Firework {
    strength: i32,
}

impl Drop for Firework {
    fn drop(&mut self) {
        println!("BOOM times {}!!!", self.strength);
    }
}

fn main() {
    let firecracker = Firework { strength: 1 };
    let tnt = Firework { strength: 100 };
}
```

これは出力されます：

```text
BOOM times 100!!!
BOOM times 1!!!
```

それは後に宣言されたので、`firecracker`がする前に`tnt`は消えます。
最初のうちの最後の。

では、`Drop`は何のために良いのですか？
一般に、`Drop`は、`struct`関連付けられたリソースをクリーンアップするために使用されます。
たとえば、[`Arc<T>`型][arc]は参照カウント型です。
`Drop`が呼び出されると、参照カウントがデクリメントされ、参照の総数がゼロの場合、基になる値がクリーンアップされます。

[arc]: ../../std/sync/struct.Arc.html
