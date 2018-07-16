# 条件付き製譜

Rustには`#[cfg]`という特殊な属性があり、製譜器に渡されるフラグに基づいて譜面を製譜できます。
これには2つの形式があります。

```rust
#[cfg(foo)]
# fn foo() {}

#[cfg(bar = "baz")]
# fn bar() {}
```

それらはまた、いくつかの補助譜を持っています。

```rust
#[cfg(any(unix, windows))]
# fn foo() {}

#[cfg(all(unix, target_pointer_width = "32"))]
# fn bar() {}

#[cfg(not(foo))]
# fn not_foo() {}
```

これらは任意にネストすることができます。

```rust
#[cfg(any(not(unix), all(target_os="macos", target_arch = "powerpc")))]
# fn foo() {}
```

これらのスイッチを有効または無効にする方法については、Cargoを使用している場合は、`Cargo.toml` [`[features]`章][features]で設定します。

[features]: http://doc.crates.io/manifest.html#the-features-section

```toml
[features]
# no features by default
default = []

# Add feature "foo" here, then you can use it. 
# Our "foo" feature depends on nothing else.
foo = []
```

これを行うと、カーゴは`rustc`た旗に沿って`rustc`ます。

```text
--cfg feature="${feature_name}"
```

これらの`cfg`フラグの和は、どの`cfg`フラグがアクティブになるかを決定し、したがってどの譜面が製譜されるかを決定します。
この譜面を見てみましょう。

```rust
#[cfg(feature = "foo")]
mod foo {
}
```

`cargo build --features "foo"`で製譜すると、--`--cfg feature="foo"`フラグが`rustc`、出力には`mod foo`が入ります。
通常の`cargo build`で製譜すると、余分なフラグは渡されないので、`foo`役区は存在しません。

# cfg_attr

`cfg_attr`を使用して`cfg`変数に基づいて別の属性を設定することもできます。

```rust
#[cfg_attr(a, b)]
# fn foo() {}
```

`cfg`属性で`a`が設定されている場合`a` `#[b]`と同じになり、そうでない場合は`#[b]`となります。

# cfg！　

`cfg!`マクロを使うと、譜面内の他の場所でも次のようなフラグを使うことができます。

```rust
if cfg!(target_os = "macos") || cfg!(target_os = "ios") {
    println!("Think Different!");
}
```

これらは、構成設定に応じて、製譜時に`true`または`false`置き換えられます。
