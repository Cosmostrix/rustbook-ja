% 言語建材

> **注意** 言語建材は Rust 頒布物に付属のわく箱によって提供されていることが多いですが、
> 言語建材自身が安定した〈インターフェース〉を持っていないため、
> 言語建材を独自に定義する前に公式に頒布されているわく箱を使うことをおすすめします。

<!-- > **Note**: lang items are often provided by crates in the Rust distribution,
> and lang items themselves have an unstable interface. It is recommended to use
> officially distributed crates instead of defining your own lang items.-->

`rustc` 製譜器にはある種の着脱可能な操作があり、それは言語で決め打ちされていない機能性で、
製譜器にその存在を知らせる特別な印のついた譜集内に実装されています。
その印は属性 `#[lang = "..."]` で `...` には様々な値が入り、「言語建材」と呼ばれています。

<!--The `rustc` compiler has certain pluggable operations, that is,
functionality that isn't hard-coded into the language, but is
implemented in libraries, with a special marker to tell the compiler
it exists. The marker is the attribute `#[lang = "..."]` and there are
various different values of `...`, i.e. various different 'lang
items'.-->

例えば、`Box` 場指しは２つの言語建材を必要とします。ひとつは割り当て用で、もうひとつは開放用です。
以下は、支えなしに立っている算譜で `malloc` と `free` による動的割り当てのために `Box` 糖を使う例です。

<!--For example, `Box` pointers require two lang items, one for allocation
and one for deallocation. A freestanding program that uses the `Box`
sugar for dynamic allocations via `malloc` and `free`:-->

```rust
#![feature(lang_items, box_syntax, start, no_std, libc)]
#![no_std]

extern crate libc;

extern {
    fn abort() -> !;
}

#[lang = "owned_box"]
pub struct Box<T>(*mut T);

#[lang = "exchange_malloc"]
unsafe fn allocate(size: usize, _align: usize) -> *mut u8 {
    let p = libc::malloc(size as libc::size_t) as *mut u8;

    // malloc 失敗
    if p as usize == 0 {
        abort();
    }

    p
}
#[lang = "exchange_free"]
unsafe fn deallocate(ptr: *mut u8, _size: usize, _align: usize) {
    libc::free(ptr as *mut libc::c_void)
}

#[start]
fn main(argc: isize, argv: *const *const u8) -> isize {
    let x = box 1;

    0
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
# #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
```

`abort` の使い方に注意しましょう。
`exchange_malloc` 言語建材は正しい場指しを返すことが前提になっているので、内部でその確認が必要です。

<!--Note the use of `abort`: the `exchange_malloc` lang item is assumed to
return a valid pointer, and so needs to do the check internally.-->

言語建材が与えるその他の機構には次のようなものがあります。

<!-- Other features provided by lang items include: -->

- 特性を通じた演算子の多重化〈オーバーロード〉。`==`, `<`, dereferencing (`*`) と `+` ほかの演算子に対応する特性はすべて言語建材の印が付いています。この例ではそれぞれ `eq`、`ord`、`deref`、`add` に相当。
- 山戻し (stack unwinding) と全般的な失敗。`eh_personality`、`fail`、`fail_bounds_checks` 言語建材。
- 様々な種類の型を示すために使われている `std::marker` 内の特性。言語建材 `send`、`sync`、`copy`。
- `std::marker` 内にある目印型とvariance indicators。言語建材 `covariant_type`、`contravariant_lifetime` 等。

<!--- overloadable operators via traits: the traits corresponding to the
  `==`, `<`, dereferencing (`*`) and `+` (etc.) operators are all
  marked with lang items; those specific four are `eq`, `ord`,
  `deref`, and `add` respectively.
- stack unwinding and general failure; the `eh_personality`, `fail`
  and `fail_bounds_checks` lang items.
- the traits in `std::marker` used to indicate types of
  various kinds; lang items `send`, `sync` and `copy`.
- the marker types and variance indicators found in
  `std::marker`; lang items `covariant_type`,
  `contravariant_lifetime`, etc.-->

言語建材は製譜器によって遅延読み込みされます。例えば、`Box` が一度も使われなかった場合は
`exchange_malloc` と `exchange_free` のための機能を定義する必要はありません。
`rustc` は言語建材が必要かつ現在のわく箱や依存しているわく箱に入っていなかった場合に誤りを発します。

<!--Lang items are loaded lazily by the compiler; e.g. if one never uses
`Box` then there is no need to define functions for `exchange_malloc`
and `exchange_free`. `rustc` will emit an error when an item is needed
but not found in the current crate or any that it depends on.-->
