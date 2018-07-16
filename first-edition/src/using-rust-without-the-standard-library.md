# 標準譜集なしのRustの使用

Rustの標準譜集は多くの便利な機能を提供しますが、ホストシステムのさまざまな機能（走脈、ネットワーク、原割り当てなど）のサポートを前提としています。
しかし、これらの機能を持たないシステムもありますし、Rustもこれらの機能を持つことができます！　
そうするために、Rustに、`#![no_std]`という属性を使って標準譜集を使用したくないと伝えます。

> > 注。この機能は技術的に安定ですが、多少の注意点があります。
> > 1つは、 _二進譜で_ はなく、安定した`#![no_std]`  _譜集_ を構築することです。
> > 標準譜集のない二進譜の詳細については、[「lang items」の夜間の章を][unstable%20book%20lang%20items]参照してください。

`#![no_std]`を使用するには、あなたの通い箱ルートに追加してください。

```rust,ignore
#![no_std]

fn plus_one(x: i32) -> i32 {
    x + 1
}
```

標準譜集に公開されている機能の多くは、[`core`通い箱を](../../core/index.html)介して利用することもできます。
標準譜集を使用しているとき、Rustは自動的に`std`を有効範囲に持ち込み、明示的に輸入することなくその機能を使用できるようにします。
同様に、`#![no_std]`を使用すると、Rustは`core`と[its prelude](../../core/prelude/v1/index.html)を有効範囲に入れます。
これは、多くの譜面がJust Workになることを意味します。

```rust,ignore
#![no_std]

fn may_fail(failure: bool) -> Result<(), &'static str> {
    if failure {
        Err("this didn’t work!")
    } else {
        Ok(())
    }
}
```

[unstable book lang items]: ../../unstable-book/language-features/lang-items.html#using-libc
