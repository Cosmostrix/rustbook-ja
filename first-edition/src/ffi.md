# 外部関数インタフェース

# 前書き

このガイドでは、外部コード用のバインディングを作成するための紹介として、[snappy](https://github.com/google/snappy)圧縮/解凍ライブラリを使用します。
Rustは現在のところC ++ライブラリに直接呼び出すことはできませんが、スナッピーにはCインターフェイス（[`snappy-ch`](https://github.com/google/snappy/blob/master/snappy-c.h)記載されています）が含まれています。

## libcについての注意

これらの例の多くは[、`libc` crateを][libc]使用し[て][libc]います[`libc` crateは][libc]、Cタイプなどのさまざまな型定義を提供します。
これらの例を自分で試しているのであれば、`Cargo.toml` `libc`を追加する必要があります：

```toml
[dependencies]
libc = "0.2.0"
```

[libc]: https://crates.io/crates/libc

`extern crate libc;`を追加し`extern crate libc;`
あなたのクレートの根に。

## 外国の関数を呼び出す

以下は、snappyがインストールされている場合にコンパイルする外部関数を呼び出す最小限の例です。

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

`extern`ブロックは、外部ライブラリの関数シグネチャのリストです（この場合、プラットフォームのC ABIが使用されます）。
`#[link(...)]`属性は、シンボルが解決されるようにスナッピーライブラリとリンクするようリンカーに指示するために使用されます。

外部関数は安全ではないと想定されているため、コンパイラに対する約束として`unsafe {}`で`unsafe {}`で`unsafe {}`必要があります。
Cライブラリはスレッドセーフではないインターフェイスを頻繁に公開し、ポインタ引数をとるほとんどすべての関数は、ポインタがぶら下がっている可能性があり、生ポインタがRustの安全メモリモデルの外にあるため、すべての可能な入力に対して有効ではありません。

引数型を外部関数に宣言するとき、Rustコンパイラは宣言が正しいかどうかをチェックすることはできません。したがって、正しく指定することは実行時にバインディングを正しく保持することの一部です。

`extern`ブロックは、スナッピーAPI全体をカバーするように拡張することができます：

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

# 安全なインターフェースを作成する

生のC APIは、メモリの安全性を提供し、ベクトルのようなより高いレベルの概念を利用するためにラップする必要があります。
ライブラリは、安全で高水準のインタフェースだけを公開し、安全ではない内部の詳細を隠すことを選択できます。

バッファを必要とする関数をラップするには、`slice::raw`モジュールを使ってメモリへのポインタとしてのルースベクトルを操作する必要があります。
Rustのベクトルは、連続したメモリブロックであることが保証されています。
長さは現在含まれている要素の数であり、容量は割り当てられたメモリの要素の合計サイズです。
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

上記の`validate_compressed_buffer`ラッパーは`unsafe`ブロックを使用しますが、関数シグニチャーから`unsafe`ままにすることで、すべての入力に対して安全であることを保証します。

`snappy_compress`と`snappy_uncompress`バッファがあまりにも出力を保持するために割り当てられなければならないので機能は、より複雑です。

`snappy_max_compressed_length`関数を使用すると、圧縮出力を保持するために必要な最大容量のベクトルを割り当てることができます。
その後、出力パラメータとして`snappy_compress`関数に渡すことができます。
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

`snappy_uncompressed_length`は圧縮されていないサイズを圧縮フォーマットの一部として格納し、`snappy_uncompressed_length`は必要な正確なバッファサイズを取得するため、圧縮`snappy_uncompressed_length`ます。

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

# デストラクタ

外国の図書館は、しばしば呼び出しコードにリソースの所有権を渡します。
これが発生すると、Rustのデストラクタを使用して安全性を確保し、これらのリソースの解放を保証する必要があります（特にパニックの場合）。

デストラクタの詳細については、[Drop特性を](../../std/ops/trait.Drop.html)参照してください。

# CコードからRust関数へのコールバック

一部の外部ライブラリでは、現在の状態または中間データを呼び出し元に報告するためにコールバックを使用する必要があります。
Rustで定義された関数を外部ライブラリに渡すことは可能です。
このために必要なのは、コールバック関数がCコードから呼び出し可能にする正しい呼び出し規約で`extern`としてマークされていることです。

コールバック関数は、Cライブラリへの登録呼び出しによって送信され、その後、そこから呼び出されます。

基本的な例は次のとおりです。

錆のコード：

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
        trigger_callback(); // コールバックをトリガーします。
    }
}
```

Cコード：

```c
typedef void (*rust_callback)(int32_t);
rust_callback cb;

int32_t register_callback(rust_callback callback) {
    cb = callback;
    return 1;
}

void trigger_callback() {
#//  cb(7); // Will call callback(7) in Rust.
  cb(7); //  Rustのコールバック（7）を呼び出します。
}
```

この例では、Rustの`main()`はCで`trigger_callback()`を呼び出し、Rustの`callback()`にコールバックし`callback()`。


## Rustオブジェクトへのコールバックのターゲット設定

前者の例では、Cコードからグローバル関数を呼び出す方法を示しました。
しかし、しばしばコールバックが特別なRustオブジェクトを対象とすることが望まれます。
これは、それぞれのCオブジェクトのラッパーを表すオブジェクトである可能性があります。

これは、オブジェクトへの生ポインタをCライブラリに渡すことで実現できます。
Cライブラリは、通知内のRustオブジェクトへのポインタを含めることができます。
これによりコールバックは参照されているRustオブジェクトに安全にアクセスできなくなります。

錆のコード：

```rust,no_run
#[repr(C)]
struct RustObject {
    a: i32,
#    // Other members...
    // 他のメンバー...
}

extern "C" fn callback(target: *mut RustObject, a: i32) {
    println!("I'm called from C with value {0}", a);
    unsafe {
#        // Update the value in RustObject with the value received from the callback:
        //  RustObjectの値をコールバックから受け取った値で更新します。
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
    // コールバックで参照されるオブジェクトを作成します。
    let mut rust_object = Box::new(RustObject { a: 5 });

    unsafe {
        register_callback(&mut *rust_object, callback);
        trigger_callback();
    }
}
```

Cコード：

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
  cb(cb_target, 7); //  Rustのコールバック（＆rustObject、7）を呼び出します。
}
```

## 非同期コールバック

前述の例では、コールバックは外部Cライブラリへの関数呼び出しへの直接的な反応として呼び出されます。
現在のスレッドに対する制御は、コールバックの実行のためにRustからCへRustに切り替えられますが、コールバックは、コールバックをトリガした関数を呼び出したスレッドと同じスレッドで実行されます。

外部ライブラリが独自のスレッドを生成し、そこからコールバックを呼び出すと、状況はより複雑になります。
これらの場合、コールバック内のRustデータ構造へのアクセスは特に安全ではなく、適切な同期メカニズムを使用する必要があります。
mutexのような古典的な同期メカニズムの他に、Rustの1つの可能性は、チャネルを使って（`std::sync::mpsc`）コールバックを呼び出したCスレッドからRustスレッドにデータを転送することです。

非同期コールバックがRustアドレス空間の特別なオブジェクトをターゲットにしている場合は、それぞれのRustオブジェクトが破棄された後に、Cライブラリがこれ以上コールバックを実行しないことも絶対必要です。
これは、オブジェクトのデストラクタでコールバックの登録を解除し、登録解除後にコールバックが実行されないようにライブラリを設計することで実現できます。

# リンクする

`extern`ブロックの`link`属性は、ネイティブライブラリへのリンク方法をrustcに指示するための基本的なビルディングブロックを提供します。
今日、リンク属性には2つの形式があります。

* `#[link(name = "foo")]`
* `#[link(name = "foo", kind = "bar")]`

どちらの場合も、`foo`はリンク先のネイティブライブラリの名前です.2番目の例では、`bar`は、コンパイラがリンクしているネイティブライブラリのタイプです。
現在、3つのタイプのネイティブライブラリがあります。

* 動的 -`#[link(name = "readline")]`
* 静的 -`#[link(name = "my_build_dependency", kind = "static")]`
* フレームワーク -`#[link(name = "CoreFoundation", kind = "framework")]`

フレームワークはmacOSターゲットでのみ利用可能であることに注意してください。

異なる`kind`値は、ネイティブライブラリがリンケージにどのように関与するかを区別するためのものです。
リンケージの観点から、Rustコンパイラは、部分（rlib / staticlib）と最終（dylib / binary）という2つのアーティファクトのフレーバを作成します。
静的ライブラリは後続の成果物に直接統合されるため、ネイティブの動的ライブラリとフレームワークの依存関係は最終的な成果物の境界に伝播され、静的ライブラリの依存関係はまったく伝播されません。

このモデルの使用方法の例をいくつか示します。

* ネイティブビルドの依存関係。
   いくつかのC / C ++グルーがいくつかの錆コードを書くときに必要になることがありますが、C / C ++コードをライブラリ形式で配布することは負担です。
   この場合、コードは`libfoo.a`にアーカイブされ、Rustの`libfoo.a` `#[link(name = "foo", kind = "static")]`介して依存関係を宣言します。

クレートの出力のフレーバにかかわらず、ネイティブのスタティックライブラリが出力に含まれます。つまり、ネイティブのスタティックライブラリの配布は不要です。

* 通常の動的依存関係。
   一般的なシステムライブラリ（`readline`）は多数のシステムで利用可能で、しばしばこれらのライブラリの静的なコピーが見つかりません。
   この依存関係がRustクレートに含まれていると、部分ターゲット（rlibなど）はライブラリにリンクされませんが、最終ターゲット（バイナリなど）に含まれると、ネイティブライブラリがリンクされます。

macOSでは、フレームワークはダイナミックライブラリと同じセマンティクスで動作します。

# 安全でないブロック

生ポインタや安全でないとマークされた関数を参照解除するような操作は、安全でないブロックの中でのみ許可されます。
安全でないブロックは安全でないものを分離し、安全ではないブロックから漏れないことをコンパイラーに約束します。

一方、安全でない関数は、それを世界に宣伝します。
安全でない関数は次のように書かれています：

```rust
unsafe fn kaboom(ptr: *const i32) -> i32 { *ptr }
```

この関数は、`unsafe`ブロックまたは別の`unsafe`関数からのみ呼び出すことができます。

# 海外のグローバルにアクセスする

外部APIは、しばしばグローバル状態を追跡するような何かをする可能性のあるグローバル変数をエクスポートします。
これらの変数にアクセスするには、`static`キーワードを使用して`extern`ブロックで宣言します。

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

あるいは、外部インタフェースによって提供されるグローバル状態を変更する必要があるかもしれません。
これを行うには、静的`mut`を`mut`で宣言して、それらを突然変異させることができます。

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
グローバルな可変状態を扱うには、大きな注意が必要です。

# 外国の呼び出し規約

ほとんどの外部コードはC ABIを公開し、Rustは外部関数を呼び出すときにデフォルトでプラットフォームのC呼び出し規約を使用します。
一部の外部関数、特にWindows APIは、他の呼び出し規約を使用しています。
Rustはコンパイラにどのような規約を使用するかを伝える方法を提供します：

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

これは`extern`ブロック全体に適用されます。
サポートされているABI制約のリストは次のとおりです。

* `stdcall`
* `aapcs`
* `cdecl`
* `fastcall`
* `vectorcall`
これは現在、`abi_vectorcall`ゲートの裏に隠されており、変更される可能性があります。
* `Rust` * `rust-intrinsic` * `system` * `C` * `win64` * `sysv64`

このリストのABIのほとんどは自明であるが、`system` ABIはちょっと奇妙に思えるかもしれない。
この制約は、ターゲットのライブラリと相互運用するための適切なABIが何であれ選択します。
たとえば、x86アーキテクチャのwin32では、これは使用されるABIが`stdcall`ことを意味します。
しかし、x86_64では、ウィンドウは`C`呼び出し規約を使用しているため、`C`が使用されます。
つまり、前の例では、`extern "system" { ... }`を使用して、x86システムだけでなく、すべてのWindowsシステム用のブロックを定義することができました。

# 外部コードとの相互運用性

Rustは、`#[repr(C)]`属性が適用されている場合に限り、`struct`のレイアウトがC言語でのプラットフォームの表現と互換性があることを保証します。
`#[repr(C, packed)]`は`#[repr(C, packed)]`パディングなしで構造体メンバをレイアウトするために使用できます。
`#[repr(C)]`はenumにも適用できます。

Rustの所有ボックス（`Box<T>`）は、含まれているオブジェクトを指すハンドルとしてnullableではないポインタを使用します。
ただし、内部のアロケータによって管理されるため、手動で作成するべきではありません。
参照は、その型に直接的にnull値ではないポインタであると見なすことができます。
しかし、借用検査または変更可能ルールを破ることは安全であるとは保証されていないため、コンパイラはそれらについて多くの仮定を行うことができないため、必要な場合は生ポインタ（`*`）を使用することをお勧めします。

ベクトルと文字列は同じ基本的なメモリレイアウトを共有し、C APIを扱うための`vec`と`str`モジュールでユーティリティが利用できます。
ただし、文字列は`\0`終了しません。
Cとの相互運用性のためにNULで終了する文字列が必要な場合は、`std::ffi`モジュールで`CString`型を使用する必要があります。

[crates.io][libc]の[`libc` crateに][libc]は、`libc`モジュールのC標準ライブラリのタイプ別名と関数定義、およびデフォルトで`libc`と`libm`に対するRustリンクが含まれています。

# バリアント関数

Cでは、関数は可変的な数の引数を受け入れることを意味する 'variadic'にすることができます。
これは、外部関数宣言の引数リスト内で`...`を指定することで、Rustで実現できます。

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

通常の錆関数は可変ではあり*ませ*ん：

```rust,ignore
#// This will not compile
// これはコンパイルされません

fn foo(x: i32, ...) { }
```

# 「ヌル可能ポインタ最適化」は、

特定の錆タイプは、決して`null`にならないように定義されてい`null`。
これには、参照（`&T`、 `&mut T`）、ボックス（ `Box<T>`）、および関数ポインタ（ `extern "abi" fn()`）が含まれます。
C言語とのインタフェースでは、`null`可能性があるポインタが頻繁に使用されるため、Rust型への変換やRust型からの変換を処理するために、乱雑な`transmute`や安全でないコードが必要になるようです。
ただし、この言語は回避策を提供します。

特別なケースとして、`enum`型に2つのバリアントが含まれていて、そのうちの1つにデータが含まれておらず、もう1つには上記のnull不可能な型のフィールドが含まれている場合、"nullable pointer optimization"の対象となります。
これは、判別式に余分なスペースが必要ないことを意味します。
むしろ、空のバリアントは、`null`値を非ヌル可能フィールドに入れることによって表される。
これは「最適化」と呼ばれますが、他の最適化とは異なり、対象となるタイプに適用されることが保証されています。

null可能なポインタの最適化を利用する最も一般的な型は`Option<T>`です。ここで`None`は`null`対応し`null`。
したがって、`Option<extern "C" fn(c_int) -> c_int>`は、C ABI（Cの型`int (*)(int)`対応）を使用してnull可能な関数ポインタを表す正しい方法です。

ここには工夫した例があります。
ある種の状況で呼び出されるコールバックを登録する機能をCライブラリが持っているとしましょう。
コールバックには関数ポインタと整数が渡され、その整数をパラメータとして実行することになっています。
したがって、FFI境界をまたがって両方向に飛ぶ関数ポインタがあります。

```rust,ignore
extern crate libc;
use libc::c_int;

# #[cfg(hidden)]
extern "C" {
#//    /// Registers the callback.
    /// コールバックを登録します。
    fn register(cb: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>, c_int) -> c_int>);
}
# unsafe fn register(_: Option<extern "C" fn(Option<extern "C" fn(c_int) -> c_int>,
#                                            c_int) -> c_int>)
# {}

#///// This fairly useless function receives a function pointer and an integer
/// この無駄な関数は関数ポインタと整数を受け取ります
#///// from C, and returns the result of calling the function with the integer.
///  Cから取り出し、その関数を整数で呼び出した結果を返します。
#///// In case no function is provided, it squares the integer by default.
/// 関数が提供されていない場合は、デフォルトで整数に2乗されます。
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

C側のコードは次のようになります。

```c
void register(void (*f)(void (*)(int), int)) {
    ...
}
```

`transmute`不要！

# Cから錆​​のコードを呼び出す

RustコードをCから呼び出せるようにコンパイルすることもできます。これはかなり簡単ですが、いくつか必要です。

```rust
#[no_mangle]
pub extern fn hello_rust() -> *const u8 {
    "Hello, world!\0".as_ptr()
}
# fn main() {}
```

`extern`は、上記の「 [外部呼び出し規約](ffi.html#foreign-calling-conventions) 」で説明したように、この関数をC呼び出し規約に従わせます。
`no_mangle`属性はRustの名前の変更を無効にします。リンクする方が簡単です。

# FFIとパニック

FFIと一緒に働くときは、`panic!`に気をつけることが重要です。
FFI境界を横切る`panic!`は未定義の動作です。
パニックに陥るかもしれないコードを書いているなら、[`catch_unwind`]てクロージャーで実行するべき[`catch_unwind`]：

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

[`catch_unwind`]はプロセスを中止する人ではなく、巻き戻すパニックを[`catch_unwind`]するだけであることに注意してください。
詳細は[`catch_unwind`]のドキュメントを参照してください。

[`catch_unwind`]: ../../std/panic/fn.catch_unwind.html

# 不透明な構造体を表現する

時々、Cライブラリは何かへのポインタを提供したいが、あなたが望むものの内部の詳細を知らせない。
最も簡単な方法は`void *`引数を使うことです：

```c
void foo(void *arg);
void bar(void *arg);
```

これを`c_void`で表すことができます：

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
これを解決するために、Cライブラリの中には`struct`を作成するものがあります。`struct`の詳細とメモリレイアウトはprivateです。
これにより、ある程度の型の安全性が得られます。
これらの構造は「不透明」と呼ばれます。
ここではCの例を示します：

```c
struct Foo; /* Foo is a structure, but its contents are not part of the public interface */
struct Bar;
void foo(struct Foo *arg);
void bar(struct Bar *arg);
```

Rustでこれを行うには、独自の不透明な型を作成しましょう：

```rust
#[repr(C)] pub struct Foo { private: [u8; 0] }
#[repr(C)] pub struct Bar { private: [u8; 0] }

extern "C" {
    pub fn foo(arg: *mut Foo);
    pub fn bar(arg: *mut Bar);
}
# fn main() {}
```

プライベートフィールドとコンストラクタを含まないことで、このモジュールの外部でインスタンス化できない不透明な型を作成します。
空の配列はサイズがゼロで、`#[repr(C)]`と互換性があります。
しかし、`Foo`と`Bar`型が異なるため、2つの型の間で型の安全性が確保されるため、`Foo`へのポインタを`bar()`渡すことはできません。
