## 付録D。マクロ

この本では`println!`ようなマクロを使用しましたが、マクロが何であるか、そしてマクロがどのように機能しているかを完全には調べていません。
この付録では、マクロについて次のように説明します。

* マクロとはどのようなもので、どのように機能と異なるのか
* メタ演譜を行うための宣言型マクロの定義方法
* 独自の`derive`特性を作成する手続き型マクロを定義する方法

付録のマクロの詳細については、まだRustで進化しているため、詳しく説明しています。
マクロは変更されています。近い将来、Rust 1.0以来、言語と標準譜集の残りの部分よりも速い速度で変更されるため、この章は本書の他の部分よりも古くなる可能性が高くなります。
Rustの安定性保証のため、ここに示す譜面は今後の版でも引き続き動作しますが、本書の発行時点では入手できなかったマクロを書くための追加機能や簡単な方法があります。
あなたがこの付録から何かを実装しようとするとき、それを念頭に置いてください。

### マクロと機能の違い

基本的に、マクロは他の譜面を書き込む譜面を書く方法です。これは*メタ演譜*と呼ばれています。
付録Cでは、さまざまな特性の実装を生成`derive`属性について説明しました。
また、本の中で`println!`と`vec!`マクロを使用しました。
これらのマクロはすべて、手動で記述した譜面よりも多くの譜面を生成するように*拡張*されています。

メタ演譜は、譜面の量を減らすのに役立ちます。これは、機能の役割の1つです。
しかし、マクロには、機能にはないいくつかの追加機能があります。

関数型指示は、その機能が持つパラメータの数と型を宣言しなければなりません。
一方、マクロは、さまざまなパラメータを取ることができます`println!("hello")`を1つの引数で、`println!("hello {}", name)`を2つの引数で呼び出すことができます。
また、マクロは、製譜器が譜面の意味を解釈する前に展開されるため、マクロは、たとえば、特定の型の特性を実装できます。
機能は実行時に呼び出され、製譜時に特性を実装する必要があるため、できません。

機能の代わりにマクロを実装することの欠点は、マクロ定義が機能定義よりも複雑であることです。Rust譜面を記述するRust譜面を記述しているからです。
この間接指定のため、マクロ定義は一般に、機能定義よりも読み込み、理解、および保守がより困難です。

マクロと機能の別の違いは、マクロ定義は機能定義のように役区内で名前空間を持たないということです。
外部通い箱を使用するときに予期しない名前の衝突を防ぐために、`#[macro_use]`注釈を使用して外部通い箱を有効範囲に入れると同時に、マクロを企画の有効範囲に明示的に持ち込まなければなりません。
次の例では、`serde`定義されているすべてのマクロを現在の`serde`の有効範囲に`serde`ます。

```rust,ignore
#[macro_use]
extern crate serde;
```

この明示的な注釈がなくても`extern crate`が自動的にマクロを有効範囲に入れることができれば、同じ名前のマクロを定義した2つの枠を使用することはできません。
実際には、この競合は頻繁には発生しませんが、使用する通い箱が多いほど、可能性が高くなります。

マクロと機能の間には最後に重要な違いが1つあります。ファイルを呼び出す*前に*マクロを定義または指定しなければなりませんが、どこでも機能を定義してどこでも呼び出すことができます。

### 一般的なメタ演譜のための`macro_rules!`持つ宣言的マクロ

Rustの中で最も広く使われているマクロは、*宣言型のマクロ*です。
これらは*、例として*、 *マクロ*、 *マクロ*、または単純な*マクロでマクロ*と呼ばれることもあり*ます*。
彼らのコアでは、宣言型マクロを使用して、Rust `match`式に類似したものを書くことができます。
第6章で説明したように、`match`式は式を取得し、結果の式の値をパターンと比較し、一致するパターンに関連付けられた譜面を実行する制御構造です。
また、マクロは値を、それらに関連付けられた譜面を持つパターンと比較します。
この状況では、値はマクロに渡される直書きルスト原譜であり、パターンはその原譜の構造と比較され、各パターンに関連付けられた譜面は、マクロに渡された譜面を置き換える譜面です。
これはすべて製譜時に発生します。

マクロを定義するには、`macro_rules!`構造を使用します。
`vec!`マクロがどのように定義されているかを見て、`macro_rules!`どのように使用するかを`macro_rules!`う。
第8章では、`vec!`マクロを使用して特定の値を持つ新しいベクトルを作成する方法について説明しました。
たとえば、次のマクロは、内部に3つの整数を持つ新しいベクトルを作成します。

```rust
let v: Vec<u32> = vec![1, 2, 3];
```

`vec!`マクロを使って、2つの整数のベクトルまたは5つの文字列スライスのベクトルを作ることもできます。
値の数や型が前もってわからないので、同じことをする機能を使用することはできません。

リストD-1の`vec!`マクロのやや簡略化された定義を見てみましょう。

```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```

<span class="caption">リストD-1。 <code>vec€</code>マクロ定義の簡略化された版</span>

> > 注。標準譜集の`vec!`マクロの実際の定義には、正しい量の記憶を事前に割り当てるための譜面が含まれています。
> > この譜面は、例を簡単にするためにここには含まれていない最適化です。

`#[macro_export]`注釈は、マクロを定義している通い箱を輸入するたびにこのマクロを使用可能にする必要があることを示します。
この注釈がなければ、たとえこの通い箱に依存する人が`#[macro_use]`注釈を使用しても、マクロは有効範囲に入れられません。

次に、マクロ定義を`macro_rules!`開始し、マクロの名前を感嘆符*なしで*定義します。
名前（この場合は`vec`）の後に、マクロ定義の本文を示す中かっこが続きます。

`vec!`本文の構造は、`match`式の構造に似ています。
ここでは、パターン`( $( $x:expr ),* )`あとに`=>`とこのパターンに関連付けられた譜面段落が続く1つの腕があります。
パターンが一致すると、関連付けられた譜面段落が発行されます。
これがこのマクロの唯一のパターンであることを考えれば、一致させる有効な方法は1つだけです。
それ以外の場合は誤りになります。
より複雑なマクロは、複数のアームを持ちます。

マクロ定義の有効なパターン構文は、マクロパターンが値ではなくRustの譜面構造と照合されるため、第18章で説明するパターン構文とは異なります。
リストD-1のパターンの部分が何を意味しているかを見てみましょう。
マクロパターンの完全な構文について[the reference]参照し[the reference]。

[the reference]: ../../reference/macros.html

第1に、カッコの集合はパターン全体を包含します。
次に、ドル記号（`$`）とそれに続くカッコがあり、置換譜面で使用するカッコ内のパターンと一致する値を取得します。
`$()`内には`$x:expr`があり、Rust式に一致し、`$x`という名前の式になります。

`$()`後のカンマは、`$()`取り込まれた譜面と一致する譜面の後に​​直書きカンマ区切り文字が選択肢で現れることを示します。
`*`は、コンマの後に`*`が先行するものの0個以上と一致することを指定します。

このマクロを`vec![1, 2, 3];`と呼ぶと`vec![1, 2, 3];`
、`$x`パターンは3つの式で三回に一致する`1`、 `2`、および`3`。

それでは、このアームに関連する譜面の本体内のパターンを見てみましょう。 `temp_vec.push()`内の譜面`$()*`の部分が一致する部分ごとに生成される`$()`パターンで、0回以上の依存しますパターンの一致回数
`$x`は、一致した各式に置き換えられます。
このマクロを`vec![1, 2, 3];`と呼ぶと`vec![1, 2, 3];`
このマクロ呼び出しを置き換えて生成される譜面は、次のようになります。

```rust,ignore
let mut temp_vec = Vec::new();
temp_vec.push(1);
temp_vec.push(2);
temp_vec.push(3);
temp_vec
```

任意の数の引数を取ることができるマクロを定義し、指定された要素を含むベクトルを作成する譜面を生成できます。

ほとんどのRust演譜師がマクロを*書く*以上にマクロを*使用*することを考えれば、`macro_rules!`についてはこれ以上議論しません。
マクロの作成方法の詳細については、オン行開発資料または[「The Little Book of Rust Macros」][tlborm]などの他の資源を参照してください。

[tlborm]: https://danielkeep.github.io/tlborm/book/index.html

### 独自の用プロシージャ・マクロの`derive`

マクロの第2の形式は、*プロシージャ型*マクロと呼ばれ*ます。*なぜなら、マクロは機能（プロシージャの一種）のようなものですからです。
手続き型マクロは、入力としてRustのさわり譜面を受け入れ、その譜面を操作し、パターンと照合する代わりに出力としてRustのさわり譜面を生成し、宣言的マクロのように譜面を他の譜面に置き換えます。
この執筆時点では、手続き型マクロを定義するだけで、型に型を実装できるようにすることができます。型名を`derive`注釈に指定します。

通い箱という名前の作成します`hello_macro`という名前の特性定義`HelloMacro`という名前の関連する機能を`hello_macro`。
通い箱のユーザーにそれぞれの型の`HelloMacro`特性を実装させるのではなく、手続き型マクロを用意し、`#[derive(HelloMacro)]`注釈を付けて`hello_macro`機能の黙用実装を得ることが`hello_macro`ます。
黙用実装は`Hello, Macro! My name is TypeName!`を出力します`Hello, Macro! My name is TypeName!`ここで、`TypeName`は、この特性が定義されている型の名前です。
言い換えれば、別の演譜師が通い箱を使ってリストD-2のような譜面を書くことを可能にする通い箱を書くでしょう。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
extern crate hello_macro;
#[macro_use]
extern crate hello_macro_derive;

use hello_macro::HelloMacro;

#[derive(HelloMacro)]
struct Pancakes;

fn main() {
    Pancakes::hello_macro();
}
```

<span class="caption">リストD-2。手続き型マクロを使用しているときに、crateのユーザが書き込むことができる譜面</span>

この譜面は`Hello, Macro! My name is Pancakes!`を印字します。終わっ`Hello, Macro! My name is Pancakes!`。
最初のステップは、次のように新しい譜集の通い箱を作ることです。

```text
$ cargo new hello_macro --lib
```

次に、`HelloMacro`特性とそれに関連する機能を定義します。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
pub trait HelloMacro {
    fn hello_macro();
}
```

特性とその機能を持っています。
この時点で、通い箱ユーザーは、以下のように、目的の機能を実現するために特性を実装することができます。

```rust,ignore
extern crate hello_macro;

use hello_macro::HelloMacro;

struct Pancakes;

impl HelloMacro for Pancakes {
    fn hello_macro() {
        println!("Hello, Macro! My name is Pancakes!");
    }
}

fn main() {
    Pancakes::hello_macro();
}
```

ただし、`hello_macro`使用したいそれぞれの型の実装段落を記述する必要があります。
彼らがこの仕事をしなくて済むようにしたいと思っています。

さらに、特性が実装されている型の名前を表示する`hello_macro`機能の黙用実装をまだ提供することはできません`hello_macro`は`hello_macro`機能を持たないため、実行時に型名をルックアップすることはできません。
製譜時に譜面を生成するにはマクロが必要です。

次の手順では手続き型マクロを定義します。
この記事の執筆時点では、手続き型マクロは独自の枠組みに入れる必要があります。
最終的には、この制限が解除される可能性があります。
次のように構造化通い箱やマクロ通い箱のための規則は次のとおりです。名前の通い箱のため`foo`、独自の手続きマクロ通い箱が呼び出される導出`foo_derive`。
`hello_macro`企画の中に`hello_macro_derive`という新しい通い箱を`hello_macro_derive`ましょう。

```text
$ cargo new hello_macro_derive --lib
```

2つの通い箱は密接に関連しているので、`hello_macro`通い箱のディレクトリ内に手順マクロ通い箱を作成します。
特性定義を変更した場合`hello_macro`、中に手続きマクロの実装に変更する必要があります`hello_macro_derive`同様。
2つのひな型は別々に公開する必要があり、これらのひな型を使用する演譜師は、両方を依存関係として追加し、それらの両方を有効範囲に入れる必要があります。
代わりに、`hello_macro`依存関係として`hello_macro_derive`を使用させ、手続き型マクロ譜面を再`hello_macro_derive`することができます。
しかし、企画を構造化したやり方によって、演譜師は、たとえそれが`derive`機能を望まないとしても、`hello_macro`を使うことができます。

`hello_macro_derive`枠を手続きマクロ枠として宣言する必要があります。
また、`syn`と`quote`通い箱の機能が必要になり`quote`すぐにわかるように、それらを依存関係として追加する必要があります。
用*Cargo.tomlファイル*に次の行を追加します`hello_macro_derive`。

<span class="filename">ファイル名。hello_macro_derive / Cargo.toml</span>

```toml
[lib]
proc-macro = true

[dependencies]
syn = "0.11.11"
quote = "0.3.15"
```

手続きマクロの定義を開始するには、あなたのため*のsrc / lib.rsファイル*にリストD-3の譜面を配置`hello_macro_derive`通い箱。
この譜面は、`impl_hello_macro`機能の定義を追加するまで製譜されません。

<span class="filename">ファイル名。hello_macro_derive / src / lib.rs</span>

```rust,ignore
extern crate proc_macro;
extern crate syn;
#[macro_use]
extern crate quote;

use proc_macro::TokenStream;

#[proc_macro_derive(HelloMacro)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
#    // Construct a string representation of the type definition
    // 型定義の文字列式を構築します。
    let s = input.to_string();

#    // Parse the string representation
    // 文字列式を解析する
    let ast = syn::parse_derive_input(&s).unwrap();

#    // Build the impl
    // 実装を構築する
    let gen = impl_hello_macro(&ast);

#    // Return the generated impl
    // 生成されたimplを返す
    gen.parse().unwrap()
}
```

<span class="caption">リストD-3。Rust譜面を処理するために、ほとんどの手続き型マクロクラートで必要となる譜面</span>

D-3で機能を分割した方法に注目してください。
手続き型マクロの作成がより便利になるため、表示または作成するほとんどすべての手続き型マクロ通い箱で同じ結果になります。
`impl_hello_macro`機能が呼び出される場所で行うことは、手続き型マクロの目的によって異なります。

。3つの新しい通い箱を導入しました`proc_macro`、 [`syn`]、および[`quote`]。
`proc_macro`通い箱にはRustが付いているので、*Cargo.toml*の依存関係に追加する必要はありません*でした*。
`proc_macro`、Rust譜面をそのRust譜面を含む文字列に変換することができます。
`syn`通い箱は、上の操作を行うことができ、データ構造に文字列からRust譜面を解析します。
`quote`通い箱は`syn`データ構造を取り、それをRust譜面に戻します。
これらの通い箱は、処理したいあらゆる種類のRust譜面を解析するのがはるかに簡単になります。Rust譜面の完全な構文解析器ーを書くことは簡単な作業ではありません。

[`syn`]: https://crates.io/crates/syn
 [`quote`]: https://crates.io/crates/quote


`hello_macro_derive`機能は、譜集のユーザがある型に対して`#[derive(HelloMacro)]`を指定したときに呼び出されます。
その理由は、注釈を付けたことである`hello_macro_derive`とここに機能を`proc_macro_derive`、名前、指定`HelloMacro`当社の特性名と一致します;
それはほとんどの手続き型マクロが従う規約です。

この機能は、最初の変換`input`から`TokenStream`に`String`呼び出すことにより、`to_string`。
この`String`は、`HelloMacro`を導出させているRust譜面の文字列式です。
リストD-2の例では、`s`は`String`値`struct Pancakes;`を持ち`struct Pancakes;`
これは`#[derive(HelloMacro)]`注釈を追加したRust譜面です。

> > 注意。この執筆時点では、`TokenStream`を文字列に変換することしかできません。
> > 将来、豊富なAPIが存在するでしょう。

次に、Rust譜面`String`を解析して操作を実行できるデータ構造に解析する必要があります。
これが`syn`が出場する場所です。
`syn`の`parse_derive_input`機能は`String`をとり、解析されたRust譜面を表す`DeriveInput`構造体を返します。
次の譜面は、`struct Pancakes;`という文字列を解析して得られる`DeriveInput`構造体の関連部分を示しています`struct Pancakes;`
。

```rust,ignore
DeriveInput {
#    // --snip--
    //  --snip--

    ident: Ident(
        "Pancakes"
    ),
    body: Struct(
        Unit
    )
}
```

この構造体の欄は、解析したRust譜面が`Pancakes`の`ident`（識別子、名前を意味する）を持つ単位構造体であることを示しています。
この構造体には、あらゆる種類のRust譜面を記述する欄があります。
詳細については[、`DeriveInput`][syn-docs]の[`syn`開発資料を`DeriveInput`][syn-docs]してください。

[syn-docs]: https://docs.rs/syn/0.11.11/syn/struct.DeriveInput.html

この時点では、`impl_hello_macro`機能を定義していません。これは、インクルードしたい新しいRust譜面を作成するところです。
前にしかし、これの最後の部分に注意`hello_macro_derive`機能が使用する`parse`から機能を`quote`の出力オンにする通い箱`impl_hello_macro`バックに機能を`TokenStream`。
返された`TokenStream`は、通い箱ユーザーが書き込む譜面に追加されるので、通い箱を製譜すると、追加機能が提供されます。

`parse_derive_input`機能または`parse`機能の呼び出しがここで失敗した場合、`unwrap`をパニックに呼んでいることに気づいたかもしれません。
proc_macro_derive機能は手続き型マクロAPIに準拠するために`Result`ではなく`TokenStream`返さなければならないため、手続き型マクロ譜面では誤りを`proc_macro_derive`する必要があります。
`unwrap`を使用してこの例を単純化することを選択しました。
生産譜面で、あなたが使用して何が悪かったのかについて、より具体的な誤りメッセージが提供しなければならない`panic!`や`expect`。

注釈付きRust譜面を`TokenStream`から`String`および`DeriveInput`実例に`DeriveInput`する譜面があるので、`HelloMacro`特性を実装する譜面を注釈付き型に生成してみましょう。

<span class="filename">ファイル名。hello_macro_derive / src / lib.rs</span>

```rust,ignore
fn impl_hello_macro(ast: &syn::DeriveInput) -> quote::Tokens {
    let name = &ast.ident;
    quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}", stringify!(#name));
            }
        }
    }
}
```

`ast.ident`を使用して注釈付き型の名前（識別子）を含む`Ident`構造体実例を取得します。
リストD-2の譜面は、`name`が`Ident("Pancakes")`ます。

`quote!`マクロを使用すると、返されたいRustの譜面を書き、`quote::Tokens`変換することができ`quote::Tokens`。
このマクロはまた、非常にクールなひな型機構を提供します。
`#name`を書くことができ、`quote!`はそれを`name`という`name`の変数の値で置き換えます。
あなたは、通常のマクロが動作するのと同様の繰り返しを行うことさえできます。
[`quote`通い箱の][quote-docs]徹底的なご導入を[ご覧][quote-docs]ください。

[quote-docs]: https://docs.rs/quote

手続き型マクロは、`HelloMacro`を使用して取得できる、ユーザーが注釈した型の`HelloMacro`特性の実装を生成し`#name`。
特性の実装には、`hello_macro` 1つの機能があります。この機能の本体には、提供したい機能が含まれています。 `hello_macro` `Hello, Macro! My name is`、そして注釈付きの名前です。

ここで使用される`stringify!`マクロは、Rustに組み込まれています。
それは`1 + 2`ようなRust式をとり、製譜時に式を`"1 + 2"`ような文字列直書きに変換します。
これは、式を評価して結果を`String` `format!`または`println!`とは異なり`format!`。
そこている可能性である`#name`入力は文字通り印字する式かもしれませんが、使う`stringify!`。
使用して`stringify!`も変換することによって、割り当てを保存`#name`製譜時に直書き文字列に。

この時点で、`cargo build`は`hello_macro`と`hello_macro_derive`両方で正常に完了`cargo build`はず`hello_macro_derive`。
これらの通い箱をリストD-2の譜面にリンクして、手続き型マクロの実際の動作を見てみましょう！　
`cargo new --bin pancakes`を使用して*企画*ディレクトリに新しい二進譜企画を作成します。
追加する必要があり`hello_macro`と`hello_macro_derive`中に依存関係として`pancakes`通い箱の*Cargo.toml。*
`hello_macro`と`hello_macro_derive`版を*https://crates.io/*に公開しているのであれば、定期的な依存関係になります。
そうでない場合は、次のように`path`依存関係として指定できます。

```toml
[dependencies]
hello_macro = { path = "../hello_macro" }
hello_macro_derive = { path = "../hello_macro/hello_macro_derive" }
```

*SRC / main.rs*にリストD-2からの譜面を入れて、実行`cargo run`。それは印字する必要があります`Hello, Macro! My name is Pancakes!`の実装`HelloMacro`手続きマクロからの特性をせずに含まれていた`pancakes`に必要通い箱それを実装します。
`#[derive(HelloMacro)]`は特性の実装を追加しました。

### マクロの未来

将来、Rustは宣言型マクロとプロシージャ型マクロを拡張します。
Rustは`macro`予約語でより良い宣言的なマクロシステムを使用し、より強力な仕事のためにより多くの型の手続き型マクロを追加し`derive`。
これらのシステムは、この刊行時点ではまだ開発中です。
最新の情報については、Rustのオン行説明書を参照してください。
