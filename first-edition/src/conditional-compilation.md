# 条件付きコンパイル

Rustには`#[cfg]`という特殊な属性があり、コンパイラに渡されるフラグに基づいてコードをコンパイルできます。
これには2つの形式があります。

```rust
#[cfg(foo)]
# fn foo() {}

#[cfg(bar = "baz")]
# fn bar() {}
```

彼らはまた、いくつかのヘルパーを持っています：

```rust
#[cfg(any(unix, windows))]
# fn foo() {}

#[cfg(all(unix, target_pointer_width = "32"))]
# fn bar() {}

#[cfg(not(foo))]
# fn not_foo() {}
```

これらは任意にネストすることができます：

```rust
#[cfg(any(not(unix), all(target_os="macos", target_arch = "powerpc")))]
# fn foo() {}
```

これらのスイッチを有効または無効にする方法については、Cargoを使用している場合は、`Cargo.toml` [`[features]`セクション][features]で設定します。

[features]: http://doc.crates.io/manifest.html#the-features-section

```toml
[features]
# no features by default
default = []

# Add feature "foo" here, then you can use it. 
# Our "foo" feature depends on nothing else.
foo = []
```

これを行うと、貨物は`rustc`た旗に沿って`rustc`ます：

```text
--cfg feature="${feature_name}"
```

これらの`cfg`フラグの合計は、どの`cfg`フラグがアクティブになるかを決定し、したがってどのコードがコンパイルされるかを決定します。
このコードを見てみましょう：

```rust
#[cfg(feature = "foo")]
mod foo {
}
```

`cargo build --features "foo"`でコンパイルすると、--`--cfg feature="foo"`フラグが`rustc`、出力には`mod foo`が入ります。
通常の`cargo build`でコンパイルすると、余分なフラグは渡されないので、`foo`モジュールは存在しません。

# cfg_attr

`cfg_attr`を使用して`cfg`変数に基づいて別の属性を設定することもできます。

```rust
#[cfg_attr(a, b)]
# fn foo() {}
```

`cfg`属性で`a`が設定されている場合`a` `#[b]`と同じになり、そうでない場合は`#[b]`となります。

# cfg！

`cfg!`マクロを使うと、コード内の他の場所でも次のようなフラグを使うことができます：

```rust
if cfg!(target_os = "macos") || cfg!(target_os = "ios") {
    println!("Think Different!");
}
```

これらは、構成設定に応じて、コンパイル時に`true`または`false`置き換えられます。
