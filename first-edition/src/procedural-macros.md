# 手続き型マクロ（および独自の生成）

本書の他の部分で見てきたように、Rustは「導出」と呼ばれるしくみを提供しています。これにより、容易に特性を実装できます。
例えば、

```rust
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}
```

より簡単です

```rust
struct Point {
    x: i32,
    y: i32,
}

use std::fmt;

impl fmt::Debug for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Point {{ x: {}, y: {} }}", self.x, self.y)
    }
}
```

Rustにはいくつかの特性がありますが、独自のものを定義することもできます。
この作業は、「手続き型マクロ」と呼ばれるRustの機能によって実現できます。
最終的には、手続き型マクロはRustのあらゆる高度なメタ演譜を可能にしますが、今日は独自の導出のためだけです。

非常に単純な特性を構築して、それを導出させて導出させましょう。

## こんにちは世界

だから最初にやるべきことは、企画のために新しい通い箱を始めることです。

```bash
$ cargo new --bin hello-world
```

導出型に対して`hello_world()`を呼び出すだけです。
このようなもの。

```rust,ignore
#[derive(HelloWorld)]
struct Pancakes;

fn main() {
    Pancakes::hello_world();
}
```

`Hello, World! My name is Pancakes.`ような素敵な出力で`Hello, World! My name is Pancakes.`
。

マクロがユーザーの視点から見えるものを書き留めておきましょう。
`src/main.rs`に次のように記述します。

```rust,ignore
#[macro_use]
extern crate hello_world_derive;

trait HelloWorld {
    fn hello_world();
}

#[derive(HelloWorld)]
struct FrenchToast;

#[derive(HelloWorld)]
struct Waffles;

fn main() {
    FrenchToast::hello_world();
    Waffles::hello_world();
}
```

すばらしいです。
これで、手続き型マクロを実際に書くだけです。
現時点では、手続き型マクロは独自の枠組みに入れる必要があります。
最終的には、この制限が解除される可能性がありますが、今のところそれが必要です。
このように、規約があります。
`foo`という名前の通い箱の場合、独自の導出手続きマクロは`foo-derive`と呼ばれ`foo-derive`。
`hello-world`企画の中で新しい`hello-world-derive`作り出しましょう。

```bash
$ cargo new hello-world-derive
```

ことを確認する`hello-world`通い箱は、作成したこの新しい通い箱を見つけることができ、tomlにそれを追加します。

```toml
[dependencies]
hello-world-derive = { path = "hello-world-derive" }
```

`hello-world-derive`通い箱の源については、ここに例があります。

```rust,ignore
extern crate proc_macro;
extern crate syn;
#[macro_use]
extern crate quote;

use proc_macro::TokenStream;

#[proc_macro_derive(HelloWorld)]
pub fn hello_world(input: TokenStream) -> TokenStream {
#    // Construct a string representation of the type definition
    // 型定義の文字列式を構築します。
    let s = input.to_string();
    
#    // Parse the string representation
    // 文字列式を解析する
    let ast = syn::parse_derive_input(&s).unwrap();

#    // Build the impl
    // 実装を構築する
    let gen = impl_hello_world(&ast);
    
#    // Return the generated impl
    // 生成されたimplを返す
    gen.parse().unwrap()
}
```

だからここにはたくさんのことがあります。
[`syn`]と[`quote`] 2つの新しい通い箱を導入し[`quote`]。
`input: TokenSteam`ように、`input: TokenSteam`はすぐに`String`に変換されます。
この`String`は、`HelloWorld`を導出させているRust譜面の文字列式です。
現時点では、`TokenStream`行うことができるのは文字列に変換することだけです。
将来、豊富なAPIが存在するでしょう。

だから本当に必要とするのは、Rust譜面を利用可能なものに _解析_ できることです。
これは`syn`が再生する場所です。
`syn`は、Rust譜面を解析するための通い箱です。
導入したもう一つの通い箱は`quote`です。
これは本質的に`syn`のデュアルですので、Rust譜面を生成するのは簡単です。
このようなものは私たち自身で書くことができますが、これらの譜集を使う方がはるかに簡単です。
Rust譜面の完全な構文解析器を書くことは簡単なことではありません。

[`syn`]: https://crates.io/crates/syn
 [`quote`]: https://crates.io/crates/quote


このコメントは、全体的な戦略の良いアイデアを与えるように思われます。
取るしようとしている`String`、導出されている型のRust譜面のを使用してそれを解析`syn`、実装の構築`hello_world`（使用`quote`）、その後、バックRust製譜器に渡します。

最後のひとつ。 `unwrap()`いくつか見えます。
手続き型マクロに誤りを指定する場合は、誤りメッセージとともに`panic!`を`panic!`なければなりません。
この場合、できるだけシンプルにしています。

`impl_hello_world(&ast)`書いてみましょう。

```rust,ignore
fn impl_hello_world(ast: &syn::DeriveInput) -> quote::Tokens {
    let name = &ast.ident;
    quote! {
        impl HelloWorld for #name {
            fn hello_world() {
                println!("Hello, World! My name is {}", stringify!(#name));
            }
        }
    }
}
```

これは引用符が入るところです`ast`引数は、型（`struct`または`enum`型のいずれか）を表す`struct`です。
[docs](https://docs.rs/syn/0.11.11/syn/struct.DeriveInput.html)チェックすると、そこに有益な情報があります。
`ast.ident`を使って型の名前を得ることができます。
`quote!`マクロを使用すると、返却したいRustの譜面を書き込んで、`Tokens`変換することができます。
`quote!`では、本当にクールなひな型機構を使用できます。
`#name`と`quote!`書くと、変数`name`置き換えられ`name`。
あなたは、通常のマクロ作業と同様にいくつかの繰り返しを行うことさえできます。
あなたは良い導入については、[docs](https://docs.rs/quote)をチェックアウトする必要があります。

だから私はそうだと思う。
ああ、`hello-world-derive` `Cargo.toml`ために`Cargo.toml` `syn`と`quote`依存関係を追加する必要があり`hello-world-derive`。

```toml
[dependencies]
syn = "0.11.11"
quote = "0.3.15"
```

それがそれであるはずです。
`hello-world`を製譜しようとしましょう。

```bash
error: the `#[proc_macro_derive]` attribute is only usable with crates of the `proc-macro` crate type
 --> hello-world-derive/src/lib.rs:8:3
  |
8 | #[proc_macro_derive(HelloWorld)]
  |   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

ああ、それでは、われわれ`hello-world-derive`通い箱は、`proc-macro`通い箱型であると宣言する必要があるようです。
これをどうやってやるの？　
このような。

```toml
[lib]
proc-macro = true
```

さて、今、`hello-world`製譜しましょう。
`cargo run`ようになります。

```bash
Hello, World! My name is FrenchToast
Hello, World! My name is Waffles
```

それをやった！　

## 独自属性

場合によっては、ユーザーに何らかの構成を許可することが理にかなっている場合があります。
たとえば、`hello_world()`操作法で出力された名前を上書きすることができます。

独自属性でこれを実現できます。

```rust,ignore
#[derive(HelloWorld)]
#[HelloWorldName = "the best Pancakes"]
struct Pancakes;

fn main() {
    Pancakes::hello_world();
}
```

製譜しようとすると、製譜器は誤りで応答します。

```bash
error: The attribute `HelloWorldName` is currently unknown to the compiler and may have meaning added to it in the future (see issue #29642)
```

製譜器はこの属性を処理していることを知り、誤りで応答しないようにする必要があります。
これは、`proc_macro_derive`属性に`attributes`を追加`attributes`ことによって、`hello-world-derive` `proc_macro_derive`ます。

```rust,ignore
#[proc_macro_derive(HelloWorld, attributes(HelloWorldName))]
pub fn hello_world(input: TokenStream) -> TokenStream 
```

複数の属性をそのように指定できます。

## 誤りの発生

列挙型を独自の導出操作法の入力として受け入れたくないと仮定しましょう。

この条件は`syn`の助けを借りて簡単に確認できます。
しかし、enumを受け入れないことをユーザーにどのように伝えますか？　
手続き型マクロの誤りを報告する慣用的な方法は、パニックに陥ることです。

```rust,ignore
fn impl_hello_world(ast: &syn::DeriveInput) -> quote::Tokens {
    let name = &ast.ident;
#    // Check if derive(HelloWorld) was specified for a struct
    //  structに導出（HelloWorld）が指定されているかどうかを確認する
    if let syn::Body::Struct(_) = ast.body {
#        // Yes, this is a struct
        // はい、これは構造体です
        quote! {
            impl HelloWorld for #name {
                fn hello_world() {
                    println!("Hello, World! My name is {}", stringify!(#name));
                }
            }
        }
    } else {
#        // Nope. This is an Enum. We cannot handle these!
        // いいえ。これは列挙型です。これらを扱うことができません！　
        panic!("#[derive(HelloWorld)] is only defined for structs, not for enums!");
    }
}
```

ユーザーが列挙から`HelloWorld`を導出させようとすると、次のように歓迎されるでしょう。

```bash
error: custom derive attribute panicked
  --> src/main.rs
   |
   | #[derive(HelloWorld)]
   |          ^^^^^^^^^^
   |
   = help: message: #[derive(HelloWorld)] is only defined for structs, not for enums!
```
