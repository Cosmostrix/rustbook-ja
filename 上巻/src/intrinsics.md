% 原生

> **【注意】** 原生 (intrinsics) の〈インターフェース〉は永久に不安定とされているため、
原生を直接使わずに libcore の安定した〈インターフェース〉を使うことをおすすめします。

<!-- > **Note**: intrinsics will forever have an unstable interface, it is
> recommended to use the stable interfaces of libcore rather than intrinsics
> directly.-->

原生機能はあたかも外機能かのように取り込まれ、特殊な `rust-intrinsic` ABI を持ちます。
例えば、通常の Rust の範囲を超越した独立な立場 (freestanding context) にある何かが、
それでも型の間で `transmute` したり、高効率な場指し計算を行いたいと思った場合に、
それらを可能にする機能を次のような宣言を介して取り込むことになります。

<!--These are imported as if they were FFI functions, with the special
`rust-intrinsic` ABI. For example, if one was in a freestanding
context, but wished to be able to `transmute` between types, and
perform efficient pointer arithmetic, one would import those functions
via a declaration like-->

```rust
#![feature(intrinsics)]
# fn main() {}

extern "rust-intrinsic" {
    fn transmute<T, U>(x: T) -> U;

    fn offset<T>(dst: *const T, offset: isize) -> *const T;
}
```

他の外機能内通の機能と同じように、これらの呼出しは常に `unsafe` です。

<!-- As with any other FFI functions, these are always `unsafe` to call. -->
