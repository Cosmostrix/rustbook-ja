# 外部機能接点

# 前書き

このガイドでは、外部譜面用の束縛を作成するための導入として、[snappy](https://github.com/google/snappy)圧縮/解凍譜集を使用します。
Rustは現在のところC ++譜集に直接呼び出すことはできませんが、スナッピーにはC接点（[`snappy-ch`](https://github.com/google/snappy/blob/master/snappy-c.h)記載されています）が含まれています。

## libcについての注意

これらの例の多くは[、`libc` crateを][libc]使用し[て][libc]います[`libc` crateは][libc]、C型などのさまざまな型定義を提供します。
これらの例を自分で試しているのであれば、`Cargo.toml` `libc`を追加する必要があります。

```toml
[dependencies]
libc = "0.2.0"
```

[libc]: https://crates.io/crates/libc

`extern crate libc;`を追加し`extern crate libc;`
あなたの通い箱の根に。

## 外部の機能を呼び出す

以下は、snappyが導入されている場合に製譜する外部機能を呼び出す最小限の例です。

```rust,ignore
extern crate libc;
use libc::size_t;

#[link(name = "snappy")]
extern {
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
}

fn main() {
    let x = unsafe { snappy_max_compressed_length(100) };
    println!("max compressed length of a 100 byte buffer: {}", x);
}
```

`extern`段落は、外部譜集の機能型指示のリストです（この場合、基盤環境のC ABIが使用されます）。
`#[link(...)]`属性は、シンボルが解決されるようにスナッピー譜集と結合するよう結合器に指示するために使用されます。

外部機能は安全ではないと想定されているため、製譜器に対する約束として`unsafe {}`で`unsafe {}`で`unsafe {}`必要があります。
C譜集は走脈セーフではない接点を頻繁に公開し、指し手引数をとるほとんどすべての機能は、指し手がぶら下がっている可能性があり、生指し手がRustの安全記憶模型の外にあるため、すべての可能な入力に対して有効ではありません。

引数型を外部機能に宣言するとき、Rust製譜器は宣言が正しいかどうかをチェックすることはできません。したがって、正しく指定することは実行時に束縛を正しく保持することの一部です。

`extern`段落は、スナッピーAPI全体をカバーするように拡張することができます。

```rust,ignore
extern crate libc;
use libc::{c_int, size_t};

#[link(name = "snappy")]
extern {
    fn snappy_compress(input: *const u8,
                       input_length: size_t,
                       compressed: *mut u8,
                       compressed_length: *mut size_t) -> c_int;
    fn snappy_uncompress(compressed: *const u8,
                         compressed_length: size_t,
                         uncompressed: *mut u8,
                         uncompressed_length: *mut size_t) -> c_int;
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
    fn snappy_uncompressed_length(compressed: *const u8,
                                  compressed_length: size_t,
                                  result: *mut size_t) -> c_int;
    fn snappy_validate_compressed_buffer(compressed: *const u8,
                                         compressed_length: size_t) -> c_int;
}
# fn main() {}
```

# 安全な接点を作成する

生のC APIは、記憶域の安全性を提供し、ベクトルのようなより高いレベルの概念を利用するために包む必要があります。
譜集は、安全で高水準の接点だけを公開し、安全ではない内部の詳細を隠すことを選択できます。

バッファを必要とする機能を包むには、`slice::raw`役区を使って記憶への指し手としてのルースベクトルを操作する必要があります。
Rustのベクトルは、連続した記憶段落であることが保証されています。
長さは現在含まれている要素の数であり、容量は割り当てられた記憶域の要素の和サイズです。
長さは容量以下です。

```rust,ignore
# extern crate libc;
# use libc::{c_int, size_t};
# unsafe fn snappy_validate_compressed_buffer(_: *const u8, _: size_t) -> c_int { 0 }
# fn main() {}
pub fn validate_compressed_buffer(src: &[u8]) -> bool {
    unsafe {
        snappy_validate_compressed_buffer(src.as_ptr(), src.len() as size_t) == 0
    }
}
```

上記の`validate_compressed_buffer`の包みは`unsafe`段落を使用しますが、機能シグニチャーから`unsafe`ままにすることで、すべての入力に対して安全であることを保証します。

`snappy_compress`と`snappy_uncompress`バッファがあまりにも出力を保持するために割り当てられなければならないので機能は、より複雑です。

`snappy_max_compressed_length`機能を使用すると、圧縮出力を保持するために必要な最大容量のベクトルを割り当てることができます。
その後、出力パラメータとして`snappy_compress`機能に渡すことができます。
長さを設定するために圧縮後に真の長さを取り出すために、出力パラメータも渡されます。

```rust,ignore
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_compress(a: *const u8, b: size_t, c: *mut u8,
#                           d: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_max_compressed_length(a: size_t) -> size_t { a }
# fn main() {}
pub fn compress(src: &[u8]) -> Vec<u8> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen = snappy_max_compressed_length(srclen);
        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        snappy_compress(psrc, srclen, pdst, &mut dstlen);
        dst.set_len(dstlen as usize);
        dst
    }
}
```

`snappy_uncompressed_length`は圧縮されていないサイズを圧縮形式の一部として格納し、`snappy_uncompressed_length`は必要な正確なバッファサイズを取得するため、圧縮`snappy_uncompressed_length`ます。

```rust,ignore
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_uncompress(compressed: *const u8,
#                             compressed_length: size_t,
#                             uncompressed: *mut u8,
#                             uncompressed_length: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_uncompressed_length(compressed: *const u8,
#                                      compressed_length: size_t,
#                                      result: *mut size_t) -> c_int { 0 }
# fn main() {}
pub fn uncompress(src: &[u8]) -> Option<Vec<u8>> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen: size_t = 0;
        snappy_uncompressed_length(psrc, srclen, &mut dstlen);

        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        if snappy_uncompress(psrc, srclen, pdst, &mut dstlen) == 0 {
            dst.set_len(dstlen as usize);
            Some(dst)
        } else {
#//            None // SNAPPY_INVALID_INPUT
            None //  SNAPPY_INVALID_INPUT
        }
    }
}
```

次に、それらを使用する方法を示すいくつかのテストを追加することができます。

```rust,ignore
# extern crate libc;
# use libc::{c_int, size_t};
# unsafe fn snappy_compress(input: *const u8,
#                           input_length: size_t,
#                           compressed: *mut u8,
#                           compressed_length: *mut size_t)
#                           -> c_int { 0 }
# unsafe fn snappy_uncompress(compressed: *const u8,
#                             compressed_length: size_t,
#                             uncompressed: *mut u8,
#                             uncompressed_length: *mut size_t)
#                             -> c_int { 0 }
# unsafe fn snappy_max_compressed_length(source_length: size_t) -> size_t { 0 }
# unsafe fn snappy_uncompressed_length(compressed: *const u8,
#                                      compressed_length: size_t,
#                                      result: *mut size_t)
#                                      -> c_int { 0 }
# unsafe fn snappy_validate_compressed_buffer(compressed: *const u8,
#                                             compressed_length: size_t)
#                                             -> c_int { 0 }
# fn main() { }

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn valid() {
        let d = vec![0xde, 0xad, 0xd0, 0x0d];
        let c: &[u8] = &compress(&d);
        assert!(validate_compressed_buffer(c));
        assert!(uncompress(c) == Some(d));
    }

    #[test]
    fn invalid() {
        let d = vec![0, 0, 0, 0];
        assert!(!validate_compressed_buffer(&d));
        assert!(uncompress(&d).is_none());
    }

    #[test]
    fn empty() {
        let d = vec![];
        assert!(!validate_compressed_buffer(&d));
        assert!(uncompress(&d).is_none());
        let c = compress(&d);
        assert!(validate_compressed_buffer(&c));
        assert!(uncompress(&c) == Some(d));
    }
}
```

# 破棄子

外部の譜集は、しばしば呼び出し譜面に資源の所有権を渡します。
これが発生すると、Rustの破棄子を使用して安全性を確保し、これらの資源の解放を保証する必要があります（特にパニックの場合）。

破棄子の詳細については、[Drop特性を](../../std/ops/trait.Drop.html)参照してください。

# C譜面からRust機能への呼び戻し

一部の外部譜集では、現在の状態または中間データを呼び出し元に報告するために呼び戻しを使用する必要があります。
Rustで定義された機能を外部譜集に渡すことは可能です。
このために必要なのは、呼び戻し機能がC譜面から呼び出し可能にする正しい呼び出し規約で`extern`としてマークされていることです。

呼び戻し機能は、C譜集への登録呼び出しによって送信され、その後、そこから呼び出されます。

基本的な例は次のとおりです。

Rustの譜面。

```rust,no_run
extern fn callback(a: i32) {
    println!("I'm called from C with value {0}", a);
}

#[link(name = "extlib")]
extern {
   fn register_callback(cb: extern fn(i32)) -> i32;
   fn trigger_callback();
}

fn main() {
    unsafe {
        register_callback(callback);
#//        trigger_callback(); // Triggers the callback.
        trigger_callback(); // 呼び戻しをトリガーします。
    }
}
```

C譜面。

```c
typedef void (*rust_callback)(int32_t);
rust_callback cb;

int32_t register_callback(rust_callback callback) {
    cb = callback;
    return 1;
}

void trigger_callback() {
#//  cb(7); // Will call callback(7) in Rust.
  cb(7); //  Rustの呼び戻し（7）を呼び出します。
}
```

この例では、Rustの`main()`はCで`trigger_callback()`を呼び出し、Rustの`callback()`に呼び戻しし`callback()`。


## Rust対象への呼び戻しの目標設定

前者の例では、C譜面から全体機能を呼び出す方法を示しました。
しかし、しばしば呼び戻しが特別なRust対象を対象とすることが望まれます。
これは、それぞれのC対象のの包みを表す対象である可能性があります。

これは、対象への生指し手をC譜集に渡すことで実現できます。
C譜集は、通知内のRust対象への指し手を含めることができます。
これにより呼び戻しは参照されているRust対象に安全にアクセスできなくなります。

Rustの譜面。

```rust,no_run
#[repr(C)]
struct RustObject {
    a: i32,
#    // Other members...
    // 他の要素...
}

extern "C" fn callback(target: *mut RustObject, a: i32) {
    println!("I'm called from C with value {0}", a);
    unsafe {
#        // Update the value in RustObject with the value received from the callback:
        //  RustObjectの値を呼び戻しから受け取った値で更新します。
        (*target).a = a;
    }
}

#[link(name = "extlib")]
extern {
   fn register_callback(target: *mut RustObject,
                        cb: extern fn(*mut RustObject, i32)) -> i32;
   fn trigger_callback();
}

fn main() {
#    // Create the object that will be referenced in the callback:
    // 呼び戻しで参照される対象を作成します。
    let mut rust_object = Box::new(RustObject { a: 5 });

    unsafe {
        register_callback(&mut *rust_object, callback);
        trigger_callback();
    }
}
```

C譜面。

```c
typedef void (*rust_callback)(void*, int32_t);
void* cb_target;
rust_callback cb;

int32_t register_callback(void* callback_target, rust_callback callback) {
    cb_target = callback_target;
    cb = callback;
    return 1;
}

void trigger_callback() {
#//  cb(cb_target, 7); // Will call callback(&rustObject, 7) in Rust.
  cb(cb_target, 7); //  Rustの呼び戻し（＆rustObject、7）を呼び出します。
}
```

## 非同期呼び戻し

前述の例では、呼び戻しは外部C譜集への機能呼び出しへの直接的な反応として呼び出されます。
現在の走脈に対する制御は、呼び戻しの実行のためにRustからCへRustに切り替えられますが、呼び戻しは、呼び戻しをトリガーした機能を呼び出した走脈と同じ走脈で実行されます。

外部譜集が独自の走脈を生成し、そこから呼び戻しを呼び出すと、状況はより複雑になります。
これらの場合、呼び戻し内のRustデータ構造へのアクセスは特に安全ではなく、適切な同期しくみを使用する必要があります。
mutexのような古典的な同期しくみの他に、Rustの1つの可能性は、チャネルを使って（`std::sync::mpsc`）呼び戻しを呼び出したC走脈からRust走脈にデータを転送することです。

非同期呼び戻しがRust番地空間の特別な対象を目標にしている場合は、それぞれのRust対象が破棄された後に、C譜集がこれ以上呼び戻しを実行しないことも絶対必要です。
これは、対象の破棄子で呼び戻しの登録を解除し、登録解除後に呼び戻しが実行されないように譜集を設計することで実現できます。

# 結合する

`extern`段落の`link`属性は、ネイティブ譜集へのリンク方法をrustcに指示するための基本的な組み上げ段落を提供します。
今日、リンク属性には2つの形式があります。

* `#[link(name = "foo")]`
* `#[link(name = "foo", kind = "bar")]`

どちらの場合も、`foo`はリンク先のネイティブ譜集の名前です。2番目の例では、`bar`は、製譜器がリンクしているネイティブ譜集の型です。
現在、3つの型のネイティブ譜集があります。

* 動的 -`#[link(name = "readline")]`
* 静的 -`#[link(name = "my_build_dependency", kind = "static")]`
* Framework -`#[link(name = "CoreFoundation", kind = "framework")]`

FrameworkはmacOS目標でのみ利用可能であることに注意してください。

異なる`kind`値は、ネイティブ譜集が結合することにどのように関与するかを区別するためのものです。
結合することの観点から、Rust製譜器は、部分（rlib / staticlib）と最終（dylib / binary）という2つのアーティファクトのフレーバを作成します。
静的譜集は後続の成果物に直接統合されるため、ネイティブの動的譜集とFrameworkの依存関係は最終的な成果物の縛りに伝播され、静的譜集の依存関係はまったく伝播されません。

この模型の使用方法の例をいくつか示します。

* ネイティブ組み上げの依存関係。
   いくつかのC / C ++グルーがRustのさわり譜面を書くときに必要になることがありますが、C / C ++譜面を譜集形式で配布することは負担です。
   この場合、譜面は`libfoo.a`に収納され、Rustの`libfoo.a` `#[link(name = "foo", kind = "static")]`介して依存関係を宣言します。

通い箱の出力のフレーバにかかわらず、ネイティブの静的譜集が出力に含まれます。つまり、ネイティブの静的譜集の配布は不要です。

* 通常の動的依存関係。
   一般的なシステム譜集（`readline`）は多数のシステムで利用可能で、しばしばこれらの譜集の静的なコピーが見つかりません。
   この依存関係がRust通い箱に含まれていると、部分目標（rlibなど）は譜集にリンクされませんが、最終目標（二進譜など）に含まれると、ネイティブ譜集がリンクされます。

macOSでは、Frameworkは動的譜集と同じ意味論で動作します。

# 安全でない段落

生指し手や安全でないとマークされた機能を参照解除するような操作は、安全でない段落の中でのみ許可されます。
安全でない段落は安全でないものを分離し、安全ではない段落から漏れないことを製譜器ーに約束します。

一方、安全でない機能は、それを世界に宣伝します。
安全でない機能は次のように書かれています。

```rust
unsafe fn kaboom(ptr: *const i32) -> i32 { *ptr }
```

この機能は、`unsafe`段落または別の`unsafe`機能からのみ呼び出すことができます。

# 海外の全体にアクセスする

外部APIは、しばしば全体状態を追跡するような何かをする可能性のある全体変数を輸出します。
これらの変数にアクセスするには、`static`予約語を使用して`extern`段落で宣言します。

```rust,ignore
extern crate libc;

#[link(name = "readline")]
extern {
    static rl_readline_version: libc::c_int;
}

fn main() {
    println!("You have readline version {} installed.",
             unsafe { rl_readline_version as i32 });
}
```

あるいは、外部接点によって提供される全体状態を変更する必要があるかもしれません。
これを行うには、静的`mut`を`mut`で宣言して、それらを変更させることができます。

```rust,ignore
extern crate libc;

use std::ffi::CString;
use std::ptr;

#[link(name = "readline")]
extern {
    static mut rl_prompt: *const libc::c_char;
}

fn main() {
    let prompt = CString::new("[my-awesome-shell] $").unwrap();
    unsafe {
        rl_prompt = prompt.as_ptr();

        println!("{:?}", rl_prompt);

        rl_prompt = ptr::null();
    }
}
```

`static mut`とのやりとりはすべて、読み書きの両方が安全でないことに注意してください。
全体な可変状態を扱うには、大きな注意が必要です。

# 外部の呼び出し規約

ほとんどの外部譜面はC ABIを公開し、Rustは外部機能を呼び出すときに自動的に基盤環境のC呼び出し規約を使用します。
一部の外部機能、特にWindows APIは、他の呼び出し規約を使用しています。
Rustは製譜器にどのような規約を使用するかを伝える方法を提供します。

```rust,ignore
extern crate libc;

#[cfg(all(target_os = "win32", target_arch = "x86"))]
#[link(name = "kernel32")]
#[allow(non_snake_case)]
extern "stdcall" {
    fn SetEnvironmentVariableA(n: *const u8, v: *const u8) -> libc::c_int;
}
# fn main() { }
```

これは`extern`段落全体に適用されます。
サポートされているABI制約のリストは次のとおりです。

* `stdcall`
* `aapcs`
* `cdecl`
* `fastcall`
* `vectorcall`
これは現在、`abi_vectorcall`ゲートの裏に隠されており、変更される可能性があります。
* `Rust` * `rust-intrinsic` * `system` * `C` * `win64` * `sysv64`

このリストのABIのほとんどは自明であるが、`system` ABIはちょっと奇妙に思えるかもしれない。
この制約は、目標の譜集と相互運用するための適切なABIが何であれ選択します。
たとえば、x86アーキテクチャのwin32では、これは使用されるABIが`stdcall`ことを意味します。
しかし、x86_64では、窓は`C`呼び出し規約を使用しているため、`C`が使用されます。
つまり、前の例では、`extern "system" { ... }`を使用して、x86システムだけでなく、すべてのWindowsシステム用の段落を定義することができました。

# 外部譜面との相互運用性

Rustは、`#[repr(C)]`属性が適用されている場合に限り、`struct`の配置がC言語での基盤環境の式と互換性があることを保証します。
`#[repr(C, packed)]`は`#[repr(C, packed)]`詰めものなしで構造体要素を配置するために使用できます。
`#[repr(C)]`はenumにも適用できます。

Rustの所有ボックス（`Box<T>`）は、含まれている対象を指す手綱としてnullableではない指し手を使用します。
ただし、内部の割当譜によって管理されるため、手動で作成するべきではありません。
参照は、その型に直接的にnull値ではない指し手であると見なすことができます。
しかし、借用検査または変更可能ルールを破ることは安全であるとは保証されていないため、製譜器はそれらについて多くの仮定を行うことができないため、必要な場合は生指し手（`*`）を使用することをお勧めします。

ベクトルと文字列は同じ基本的な記憶配置を共有し、C APIを扱うための`vec`と`str`役区でユーティリティが利用できます。
ただし、文字列は`\0`終了しません。
Cとの相互運用性のためにNULで終了する文字列が必要な場合は、`std::ffi`役区で`CString`型を使用する必要があります。

[crates.io][libc]の[`libc` crateに][libc]は、`libc`役区のC標準譜集の型別名と機能定義、および自動的に`libc`と`libm`に対するRustリンクが含まれています。

# 場合値機能

Cでは、機能は可変的な数の引数を受け入れることを意味する 'variadic'にすることができます。
これは、外部機能宣言の引数リスト内で`...`を指定することで、Rustで実現できます。

```rust,no_run
extern {
    fn foo(x: i32, ...);
}

fn main() {
    unsafe {
        foo(10, 20, 30, 40, 50);
    }
}
```

通常のRust機能は可変ではあり*ませ*ん。

```rust,ignore
#// This will not compile
// これは製譜されません

fn foo(x: i32, ...) { }
```

# 「nullあり指し手最適化」は、

特定のRust型は、決して`null`にならないように定義されてい`null`。
これには、参照（`&T`、 `&mut T`）、ボックス（ `Box<T>`）、および機能指し手（ `extern "abi" fn()`）が含まれます。
C言語との接点では、`null`可能性がある指し手が頻繁に使用されるため、Rust型への変換やRust型からの変換を処理するために、乱雑な`transmute`や安全でない譜面が必要になるようです。
ただし、この言語は回避策を提供します。

特別なケースとして、`enum`型に2つの場合値が含まれていて、そのうちの1つにデータが含まれておらず、もう1つには上記のnullなしな型の欄が含まれている場合、"nullable pointer optimization"の対象となります。
これは、判別式に余分なスペースが必要ないことを意味します。
むしろ、空の場合値は、`null`値をnullなし欄に入れることによって表されます。
これは「最適化」と呼ばれますが、他の最適化とは異なり、対象となる型に適用されることが保証されています。

nullありな指し手の最適化を利用する最も一般的な型は`Option<T>`です。ここで`None`は`null`対応し`null`。
したがって、`Option<extern "C" fn(c_int) -> c_int>`は、C ABI（Cの型`int (*)(int)`対応）を使用してnullありな機能指し手を表す正しい方法です。

ここには工夫した例があります。
ある種の状況で呼び出される呼び戻しを登録する機能をC譜集が持っているとしましょう。
呼び戻しには機能指し手と整数が渡され、その整数をパラメータとして実行することになっています。
したがって、FFI境界をまたがって両方向に飛ぶ機能指し手があります。

```rust,ignore
extern crate libc;
use libc::c_int;

# #[cfg(hidden)]
extern "C" {
#//    /// Registers the callback.
    /// 呼び戻しを登録します。
    fn register(cb: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>, c_int) -> c_int>);
}
# unsafe fn register(_: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>,
#                                            c_int) -> c_int>)
# {}

#///// This fairly useless function receives a function pointer and an integer
/// この無駄な機能は機能指し手と整数を受け取ります
#///// from C, and returns the result of calling the function with the integer.
///  Cから取り出し、その機能を整数で呼び出した結果を返します。
#///// In case no function is provided, it squares the integer by default.
/// 機能が提供されていない場合は、自動的に整数に2乗されます。
extern "C" fn apply(process: Option<extern "C" fn(c_int) -> c_int>, int: c_int) -> c_int {
    match process {
        Some(f) => f(int),
        None    => int * int
    }
}

fn main() {
    unsafe {
        register(Some(apply));
    }
}
```

C側の譜面は次のようになります。

```c
void register(void (*f)(void (*)(int), int)) {
    ...
}
```

`transmute`不要！　

# CからRust​​の譜面を呼び出す

Rust譜面をCから呼び出せるように製譜することもできます。これはかなり簡単ですが、いくつか必要です。

```rust
#[no_mangle]
pub extern fn hello_rust() -> *const u8 {
    "Hello, world!\0".as_ptr()
}
# fn main() {}
```

`extern`は、上記の「 [外部呼び出し規約](ffi.html#foreign-calling-conventions) 」で説明したように、この機能をC呼び出し規約に従わせます。
`no_mangle`属性はRustの名前の変更を無効にします。結合する方が簡単です。

# FFIとパニック

FFIと一緒に働くときは、`panic!`に気をつけることが重要です。
FFI境界を横切る`panic!`は未定義の動作です。
パニックに陥るかもしれない譜面を書いているなら、[`catch_unwind`]て閉包で実行するべき[`catch_unwind`]。

```rust
use std::panic::catch_unwind;

#[no_mangle]
pub extern fn oh_no() -> i32 {
    let result = catch_unwind(|| {
        panic!("Oops!");
    });
    match result {
        Ok(_) => 0,
        Err(_) => 1,
    }
}

fn main() {}
```

[`catch_unwind`]は過程を中止する人ではなく、巻き戻すパニックを[`catch_unwind`]するだけであることに注意してください。
詳細は[`catch_unwind`]の開発資料を参照してください。

[`catch_unwind`]: ../../std/panic/fn.catch_unwind.html

# 目隠しな構造体を式する

時々、C譜集は何かへの指し手を提供したいが、あなたが望むものの内部の詳細を知らせない。
最も簡単な方法は`void *`引数を使うことです。

```c
void foo(void *arg);
void bar(void *arg);
```

これを`c_void`で表すことができます。

```rust,ignore
extern crate libc;

extern "C" {
    pub fn foo(arg: *mut libc::c_void);
    pub fn bar(arg: *mut libc::c_void);
}
# fn main() {}
```

これは状況を処理するための完全に有効な方法です。
しかし、少し上手くいくことができます。
これを解決するために、C譜集の中には`struct`を作成するものがあります。`struct`の詳細と記憶配置はprivateです。
これにより、ある程度の型の安全性が得られます。
これらの構造は「目隠し」と呼ばれます。
ここではCの例を示します。

```c
struct Foo; /* Foo is a structure, but its contents are not part of the public interface */
struct Bar;
void foo(struct Foo *arg);
void bar(struct Bar *arg);
```

Rustでこれを行うには、独自の目隠しな型を作成しましょう。

```rust
#[repr(C)] pub struct Foo { private: [u8; 0] }
#[repr(C)] pub struct Bar { private: [u8; 0] }

extern "C" {
    pub fn foo(arg: *mut Foo);
    pub fn bar(arg: *mut Bar);
}
# fn main() {}
```

内部用欄と構築子を含まないことで、この役区の外部で実例化できない目隠しな型を作成します。
空の配列はサイズがゼロで、`#[repr(C)]`と互換性があります。
しかし、`Foo`と`Bar`型が異なるため、2つの型の間で型の安全性が確保されるため、`Foo`への指し手を`bar()`渡すことはできません。
