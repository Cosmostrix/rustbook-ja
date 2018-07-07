% Drop

特性について議論できたところで、Rust 標準譜集が提供する特別な特性 [`Drop`][drop] について話しましょう。
`Drop` 特性は値が範囲外に抜けた瞬間に任意の譜面を実行できる手段を提供します。
例えば、

<!--Now that we’ve discussed traits, let’s talk about a particular trait provided
by the Rust standard library, [`Drop`][drop]. The `Drop` trait provides a way
to run some code when a value goes out of scope. For example:-->

[drop]: ../std/ops/trait.Drop.html

```rust
struct HasDrop;

impl Drop for HasDrop {
    fn drop(&mut self) {
        println!("Dropping!");
    }
}

fn main() {
    let x = HasDrop;

    // 何かする

} // x はここで範囲外に抜ける
```

`x` が `main()` の終わりで範囲外になったとき、`Drop` の譜面が実行されます。
`Drop` は操作法をひとつ持ち、その名前は `drop()` と言い、
`self` への可変な参照をとります。

<!--When `x` goes out of scope at the end of `main()`, the code for `Drop` will
run. `Drop` has one method, which is also called `drop()`. It takes a mutable
reference to `self`.-->

それだけです！ `Drop` の仕組みはとても単純ですが、やや巧妙な点があります。
例えば、値は宣言と逆の順番で脱落していきます。
こちらはもうひとつの例です。

<!--That’s it! The mechanics of `Drop` are very simple, but there are some
subtleties. For example, values are dropped in the opposite order they are
declared. Here’s another example:-->

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

実行結果は、

<!--This will output:-->

```text
BOOM times 100!!!
BOOM times 1!!!
```

TNT が爆竹 (firecracker) より先に爆発しているのは、より後に宣言されたからです。
後入れ先出し (Last in, first out) です。

<!--The TNT goes off before the firecracker does, because it was declared
afterwards. Last in, first out.-->

だから `Drop` の何がよいのでしょう？ 一般的には、`Drop` は `struct` とひも付く資源の後始末をするために使われています。
例えば、[`Arc<T>` 型][arc]は参照計数型です。
`Drop` が呼ばれたときに参照数を減らしていき、合計が 0 になった瞬間に内部の値を掃除します。

<!--So what is `Drop` good for? Generally, `Drop` is used to clean up any resources
associated with a `struct`. For example, the [`Arc<T>` type][arc] is a
reference-counted type. When `Drop` is called, it will decrement the reference
count, and if the total number of references is zero, will clean up the
underlying value.-->

[arc]: ../std/sync/struct.Arc.html
