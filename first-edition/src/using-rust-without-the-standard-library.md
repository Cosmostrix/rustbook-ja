# 標準ライブラリなしの錆の使用

Rustの標準ライブラリは多くの便利な機能を提供しますが、ホストシステムのさまざまな機能（スレッド、ネットワーク、ヒープ割り当てなど）のサポートを前提としています。
しかし、これらの機能を持たないシステムもありますし、Rustもこれらの機能を持つことができます！
そうするために、Rustに、`#![no_std]`という属性を使って標準ライブラリを使用したくないと伝えます。

> > 注：この機能は技術的に安定ですが、いくつかの注意点があります。
> > 1つは、 _バイナリで_ はなく、安定した`#![no_std]`  _ライブラリ_ を構築することです。
> > 標準ライブラリのないバイナリの詳細については、[「lang items」の夜間の章を][unstable%20book%20lang%20items]参照してください。

`#![no_std]`を使用するには、あなたのクレートルートに追加してください：

```rust,ignore
#![no_std]

fn plus_one(x: i32) -> i32 {
    x + 1
}
```

標準ライブラリに公開されている機能の多くは、[`core`クレートを](../../core/index.html)介して利用することもできます。
標準ライブラリを使用しているとき、Rustは自動的に`std`をスコープに持ち込み、明示的にインポートすることなくその機能を使用できるようにします。
同様に、`#![no_std]`を使用すると、Rustは`core`と[its prelude](../../core/prelude/v1/index.html)をスコープに入れます。
これは、多くのコードがJust Workになることを意味します。

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
