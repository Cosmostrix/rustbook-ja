# マクロ

今では、Rustがコードを抽象化し再利用するために提供する多くのツールについて学びました。
これらのコード再利用の単位は、豊富な意味構造を持っています。
たとえば、関数は型シグネチャを持ち、型パラメータは特性境界を持ち、多重定義関数は特定の特性に属していなければなりません。

この構造は、Rustのコア抽象化が強力なコンパイル時の正しさチェックを持つことを意味します。
しかし、これは柔軟性の低下の代償を払っています。
繰り返されるコードのパターンを視覚的に特定すると、そのパターンをRustのセマンティクスの中でジェネリック関数、特性、またはその他のものとして表現することは困難または面倒です。

マクロを使用すると、構文レベルで抽象化することができます。
マクロ呼び出しは、"拡張された"構文形式の略です。
この展開はコンパイルの初期、静的チェックの前に行われます。
その結果、マクロは、Rustのコア抽象化では不可能な、多くのコード再利用パターンをキャプチャできます。

欠点は、マクロベースのコードを理解するのが難しいということです。なぜなら組み込み規則が少なくて済むからです。
通常の関数と同様に、適切に動作するマクロは実装の理解なしに使用できます。
ただし、正常に動作するマクロを設計するのは難しい場合があります。
さらに、マクロコードのコンパイラエラーは、開発者が使用するソースレベルのフォームではなく、展開されたコードの問題を記述するため、解釈が難しくなります。

これらの欠点は、マクロを「最後の手段」の何かにしている。
それはマクロが悪いと言っているわけではありません。
彼らは時には本当に簡潔で、よく抽象化されたコードのために必要なので、彼らはRustの一部です。
このトレードオフを念頭に置いてください。

# マクロを定義する

任意の数の要素を持つ[vector][vector]を初期化するために使用される`vec!`マクロを見たことがあります。

[vector]: vectors.html

```rust
let x: Vec<u32> = vec![1, 2, 3];
# assert_eq!(x, [1, 2, 3]);
```

任意の数の引数を取るので、これは普通の関数とすることはできません。
しかし、それを構文上の簡略表現として想像することができます

```rust
let x: Vec<u32> = {
    let mut temp_vec = Vec::new();
    temp_vec.push(1);
    temp_vec.push(2);
    temp_vec.push(3);
    temp_vec
};
# assert_eq!(x, [1, 2, 3]);
```

この略式を、マクロを使って実装することができます： [^actual]

[^actual]: The%20actual%20definition%20of%20%60vec!%60%20in%20libcollections%20differs%20from%20the
効率性と再利用性の理由からここに示したものです。

```rust
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
# fn main() {
#     assert_eq!(vec![1,2,3], [1, 2, 3]);
# }
```

うわー、それは新しい構文の多くです！
それを分解しましょう。

```rust,ignore
macro_rules! vec { ... }
```

これは、`fn vec`が`vec`という名前の関数を定義するのと同じように、`vec`という名前のマクロを定義していることを示しています。
散文では、私たちは非公式に感嘆符でマクロの名前を書いています。例えば`vec!`。
感嘆符は、呼び出し構文の一部であり、マクロを通常の関数と区別するのに役立ちます。

## マッチング

マクロは、パターンマッチングのケースである一連のルールによって定義されます。
上記のとおり、

```rust,ignore
( $( $x:expr ),* ) => { ... };
```

これは`match`式のようなものですが、コンパイル時にRust構文ツリーで一致します。
セミコロンは、最後の（ここでは、唯一の）ケースではオプションです。
`=>`左側の「パターン」は「マッチャー」と呼ばれます。
これらは、言語内に[their own little grammar]持っ[their own little grammar]います。

[their own little grammar]: ../../reference/macros.html

正規表現`$x:expr`は任意のRust式にマッチし、その構文木を 'metavariable' `$x`に束縛します。
識別子`expr`は 'フラグメント指定子'です。
完全な可能性がこの章の後半に列挙されています。
マッチャーを`$(...),*`囲むと、0個以上の式がカンマで区切られます。

特別なマッチャーの構文とは別に、マッチャーに表示される任意の錆トークンは正確に一致しなければなりません。
例えば、

```rust,ignore
macro_rules! foo {
    (x => $e:expr) => (println!("mode X: {}", $e));
    (y => $e:expr) => (println!("mode Y: {}", $e));
}

fn main() {
    foo!(y => 3);
}
```

印刷する

```text
mode Y: 3
```

と

```rust,ignore
foo!(z => 3);
```

コンパイラエラーが発生する

```text
error: no rules expected the token `z`
```

## 拡張

マクロルールの右側は、ほとんどの場合、普通のRust構文です。
しかし、マッチャーによって捕捉された構文のビットでスプライスすることができます。
元の例から：

```rust,ignore
$(
    temp_vec.push($x);
)*
```

一致した各式`$x`は、マクロ展開で単一の`push`文を生成します。
展開の繰り返しは、マッチャーの繰り返しで「ロックステップ」に進みます（詳細はこちら）。

`$x`はすでに式にマッチすると宣言されているので、繰り返しはしません`:expr`右側は`:expr`です。
また、繰り返し演算子の一部としてコンマを区切ることもありません。
代わりに、繰り返しブロック内にセミコロンを終端します。

もう1つの詳細： `vec!`マクロには、右側に*2*組のカッコがあります。
それらはしばしば以下のように組み合わされます：

```rust,ignore
macro_rules! foo {
    () => {{
        ...
    }}
}
```

外側の中カッコは、`macro_rules!`構文の`macro_rules!`。
実際には、代わりに`()`または`[]`使用できます。
彼らは単に右側全体を区切ります。

内括弧は拡張構文の一部です。
`vec!`マクロは式のコンテキストで使用されることを覚えておいてください。
`let` -bindingsを含む複数のステートメントで式を書くには、ブロックを使います。
あなたのマクロが単一の式に展開されている場合、この追加の中括弧は必要ありません。

マクロが式を生成する*と宣言*したことはありません。
実際、これは式としてマクロを使用するまで決定されません。
注意して、いくつかのコンテキストで拡張が機能するマクロを書くことができます。
たとえば、データ型の省略形は、式またはパターンのいずれかとして有効です。

## 繰り返し

繰り返し演算子は、2つの主要な規則に従います。

1. `$(...)*`は、反復の1つの「レイヤー」を通ります。そのレイヤーに含まれる`$name`のすべてについて、ロックステップで
2. それぞれの`$name`は、少なくとも一致した`$(...)*` s以下でなければなりません。
    それ以上の場合は、必要に応じて複製されます。

このバロックマクロは、外部繰り返しレベルからの変数の重複を示しています。

```rust
macro_rules! o_O {
    (
        $(
            $x:expr; [ $( $y:expr ),* ]
        );*
    ) => {
        &[ $($( $x + $y ),*),* ]
    }
}

fn main() {
    let a: &[i32]
        = o_O!(10; [1, 2, 3];
               20; [4, 5, 6]);

    assert_eq!(a, [11, 12, 13, 24, 25, 26]);
}
```

それはマッチャーの構文の大部分です。
これらの例では、`$(...)*`使用してい`$(...)*`これは、「0以上の」一致です。
あるいは、「1つ以上の」一致に対して`$(...)+`を書くことができます。
両方の書式には、セパレータがオプションで含まれています。セパレータには、`+`または`*`以外のトークンを使用できます

このシステムは、「 [Macro-by-Example](https://www.cs.indiana.edu/ftp/techreports/TR206.pdf) 」（PDFリンク）に基づいています。

# 衛生

いくつかの言語は、単純なテキスト置換を使用してマクロを実装するため、さまざまな問題が発生します。
たとえば、このCプログラムは、予想される`25`代わりに`13`を出力します。

```text
#define FIVE_TIMES(x) 5 * x

int main() {
    printf("%d\n", FIVE_TIMES(2 + 3));
    return 0;
}
```

展開後、`5 * 2 + 3`となり、乗算は加算より優先されます。
Cマクロをたくさん使ったことがあるなら、おそらくこの問題を回避するための標準的なイディオムと、5つまたは6つの他のものを知っているでしょう。
Rustでは、心配する必要はありません。

```rust
macro_rules! five_times {
    ($x:expr) => (5 * $x);
}

fn main() {
    assert_eq!(25, five_times!(2 + 3));
}
```

メタ変数`$x`は単一の式ノードとして解析され、置換後も構文木にその場所を保持します。

マクロシステムにおけるもう一つの共通の問題は、「変数キャプチャ」です。
以下は、複数のステートメントを含むブロックを使用するCマクロです。

```text
#define LOG(msg) do { \
    int state = get_log_state(); \
    if (state > 0) { \
        printf("log(%d): %s\n", state, msg); \
    } \
} while (0)
```

ひどく間違っている単純なユースケースがあります：

```text
const char *state = "reticulating splines";
LOG(state);
```

これは

```text
const char *state = "reticulating splines";
do {
    int state = get_log_state();
    if (state > 0) {
        printf("log(%d): %s\n", state, state);
    }
} while (0);
```

`state`という名前の2番目の変数は、最初の変数をシャドウします。
これは、print文が両方を参照する必要があるため、問題です。

同等のRustマクロは、望ましい動作をします。

```rust
# fn get_log_state() -> i32 { 3 }
macro_rules! log {
    ($msg:expr) => {{
        let state: i32 = get_log_state();
        if state > 0 {
            println!("log({}): {}", state, $msg);
        }
    }};
}

fn main() {
    let state: &str = "reticulating splines";
    log!(state);
}
```

これは、Rustが[hygienic macro system]持っているために[hygienic macro system]ます。
それぞれのマクロ展開は別々の「構文コンテキスト」で行われ、各変数にはその構文コンテキストがタグ付けされています。
変数かのようです`state`内部の`main`変数と異なる「色」塗られている`state`マクロ内で、そのため彼らは競合しません。

[hygienic macro system]: https://en.wikipedia.org/wiki/Hygienic_macro

これはまた、呼び出しサイトで新しいバインディングを導入するマクロの機能を制限します。
次のようなコードは機能しません。

```rust,ignore
macro_rules! foo {
    () => (let x = 3;);
}

fn main() {
    foo!();
    println!("{}", x);
}
```

代わりに、変数名を呼び出しに渡す必要があります。そのため、正しい構文コンテキストでタグ付けされます。

```rust
macro_rules! foo {
    ($v:ident) => (let $v = 3;);
}

fn main() {
    foo!(x);
    println!("{}", x);
}
```

`let`バインディングとループラベルは保持`let`ますが、[items][items]は保持されません。
したがって、次のコードはコンパイルされます。

```rust
macro_rules! foo {
    () => (fn x() { });
}

fn main() {
    foo!();
    x();
}
```

[items]: ../../reference/items.html

# 再帰マクロ

マクロの展開には、同じマクロの呼び出しを拡張するなど、より多くのマクロ呼び出しを含めることができます。
これらの再帰マクロは、ツリー構造の入力を処理するのに便利です。

```rust
# #![allow(unused_must_use)]
macro_rules! write_html {
    ($w:expr, ) => (());

    ($w:expr, $e:tt) => (write!($w, "{}", $e));

    ($w:expr, $tag:ident [ $($inner:tt)* ] $($rest:tt)*) => {{
        write!($w, "<{}>", stringify!($tag));
        write_html!($w, $($inner)*);
        write!($w, "</{}>", stringify!($tag));
        write_html!($w, $($rest)*);
    }};
}

fn main() {
#//#   // FIXME(#21826)
#   //  FIXME（＃21826）
    use std::fmt::Write;
    let mut out = String::new();

    write_html!(&mut out,
        html[
            head[title["Macros guide"]]
            body[h1["Macros are the best!"]]
        ]);

    assert_eq!(out,
        "<html><head><title>Macros guide</title></head>\
         <body><h1>Macros are the best!</h1></body></html>");
}
```

# マクロコードのデバッグ

マクロを展開した結果を見るには、`rustc --pretty expanded`実行します。
出力はクレート全体を表しているので、元のコンパイルよりも優れたエラーメッセージを生成する`rustc`フィードバックすることもできます。
同じ名前の複数の変数（構文コンテキストは異なる）が同じスコープ内で動作している場合、--`--pretty expanded`出力は異なる意味を持つことに注意してください。
この場合、--`--pretty expanded,hygiene`は構文コンテキストについて教えてくれます。

`rustc`は、マクロデバッグに役立つ2つの構文拡張を提供します。
今のところ、それらは不安定であり、機能ゲートが必要です。

* `log_syntax!(...)`はコンパイル時に引数を標準出力に出力し、何も展開しません。

* `trace_macros!(true)`は、マクロが展開されるたびにコンパイラのメッセージを有効にします。
   後で展開時に`trace_macros!(false)`使用してオフにします。

# 構文上の要件

Rustコードに展開されていないマクロが含まれていても、完全な[構文ツリー][ast]として解析できます。
このプロパティは、コードを処理するエディタやその他のツールに非常に便利です。
また、Rustのマクロシステムの設計にはいくつかの影響があります。

[ast]: glossary.html#abstract-syntax-tree

1つの結果として、Rustは、マクロの呼び出しを解析するときに、マクロが

* ゼロ個以上のアイテム、
* ゼロ個以上のメソッド、
* 表現、
* ステートメント、または
* パターン。

ブロック内でのマクロ呼び出しは、いくつかの項目や式/ステートメントを表す可能性があります。
錆はこのあいまいさを解決するために単純なルールを使用します。
項目を表すマクロ呼び出しは、

* 中括弧で区切られたもの、例えば`foo! { ... }`、または
* セミコロンで終わる、例えば`foo!(...);`

拡張前解析の別の結果は、マクロ呼び出しが有効な錆トークンで構成されていなければならないということです。
さらに、かっこ、角かっこ、および中かっこは、マクロ呼び出し内でバランスをとる必要があります。
たとえば、`foo!([)`は禁止されています。
これにより、Rustはマクロの呼び出しがどこで終了するかを知ることができます。

より正式には、マクロ呼び出し本体は一連の 'トークンツリー'でなければなりません。
トークンツリーは再帰的に

* matching `()`、 `[]`、または`{}`で囲まれた一連のトークンツリー、または
* 他の単一のトークン。

マッチャー内では、各メタ変数には、それが一致する構文形式を識別する「フラグメント指定子」があります。

* `ident`：識別子。
   例： `x`;
   `foo`。
* `path`：修飾された名前。
   例： `T::SpecialA`。
* `expr`：式。
   例： `2 + 2`;
   `if true { 1 } else { 2 }`;
   `f(42)`。
* `ty`：タイプ。
   例： `i32`;
   `Vec<(char, String)>`;
   `&T`。
* `pat`：パターン。
   例： `Some(t)`;
   `(17, 'a')`;
   `_`。
* `stmt`：単一のステートメント。
   例： `let x = 3`。
* `block`：中括弧で区切られた一連のステートメントとオプションで式。
   例： `{ log(error, "hi"); return 12; }`
`{ log(error, "hi"); return 12; }` `{ log(error, "hi"); return 12; }`。
* `item`： [item][item]。
   例： `fn foo() { }`;
`struct Bar;` 。
* `meta`：属性にある「メタアイテム」。
   例： `cfg(target_os = "windows")`。
* `tt`：単一のトークンツリー。

メタ変数の後の次のトークンに関する追加の規則があります。

* `expr`および`stmt`変数の後には、`=> , ;` `stmt`
* `ty`と`path`変数の後には、`=> , = | ; : > [ { as where`
`=> , = | ; : > [ { as where`
* `pat`変数の後には、次のいずれかが続くことがあります。`=> , = | if in`
`=> , = | if in`
* 他の変数には任意のトークンを続けることができます。

これらのルールは、Rustの構文が既存のマクロを壊さずに進化するための柔軟性を提供します。

マクロシステムは解析のあいまいさをまったく扱っていません。
たとえば、文法`$($i:ident)* $e:expr`は、構文解析に失敗します。なぜなら、構文解析プログラムは`$i`解析と`$e`解析のどちらかを選択する必要があるからです。
特有のトークンを前に置くように呼び出し構文を変更することで、問題を解決できます。
この場合、`$(I $i:ident)* E $e:expr`書くことができます。

[item]: ../../reference/items.html

# スコーピングとマクロのインポート/エクスポート

マクロは名前解決の前に、コンパイルの初期段階で展開されます。
1つの欠点は、言語の他の構文と比較して、マクロのスコープが異なることです。

マクロの定義と拡張の両方は、クレートのソースの深さ優先、字句順トラバーサルで行われます。
そのため、モジュールスコープで定義されたマクロは、後続の子`mod`アイテムのボディを含む同じモジュール内の後続のコードから見えます。
別のモジュールで定義されているマクロを使用する場合は、マクロを使用する*前に* `macro_use`属性を使用する必要があります。
私たちのマクロはモジュール`macros`定義されており、モジュール`client`内で使用したいとしましょう。
これは必須のモジュール定義順序です：

```rust
#[macro_use]
mod macros;
mod client;
```

逆の順序でコンパイルに失敗します。

```rust
mod client;
#[macro_use]
mod macros;
```

```bash
error: cannot find macro `my_macro!` in this scope
```

単一の`fn`ボディー内に定義されたマクロ、またはモジュールスコープではない他の場所にあるマクロは、その項目内でのみ表示されます。

モジュールがある場合は`macro_use`属性を、そのマクロは、子の後に親モジュールにも表示されている`mod`のアイテム。
親にも`macro_use`場合、マクロは親の`mod`項目の後に祖父母で表示されます。

`macro_use`属性は、`extern crate` `macro_use`にも表示されます。
このコンテキストでは、外部クレートからロードされるマクロを制御します。

```rust,ignore
#[macro_use(foo, bar)]
extern crate baz;
```

属性に`#[macro_use]`と指定した場合、すべてのマクロがロードされます。
`#[macro_use]`属性がない場合、マクロはロードされません。
`#[macro_export]`属性で定義されたマクロだけが読み込まれます。

クレートのマクロを出力にリンクせずに読み込むには`#[no_link]`も使用します。

例：

```rust
macro_rules! m1 { () => (()) }

#// Visible here: `m1`.
// ここに表示されます： `m1`。

mod foo {
#    // Visible here: `m1`.
    // ここに表示されます： `m1`。

    #[macro_export]
    macro_rules! m2 { () => (()) }

#    // Visible here: `m1`, `m2`.
    // ここに表示されます： `m1`、 `m2`。
}

#// Visible here: `m1`.
// ここに表示されます： `m1`。

macro_rules! m3 { () => (()) }

#// Visible here: `m1`, `m3`.
// ここに表示されます： `m1`、 `m3`。

#[macro_use]
mod bar {
#    // Visible here: `m1`, `m3`.
    // ここに表示されます： `m1`、 `m3`。

    macro_rules! m4 { () => (()) }

#    // Visible here: `m1`, `m3`, `m4`.
    // ここに表示されます： `m1`、 `m3`、 `m4`。
}

#// Visible here: `m1`, `m3`, `m4`.
// ここに表示されます： `m1`、 `m3`、 `m4`。
# fn main() { }
```

このライブラリに`#[macro_use] extern crate`がロードされると、`m2`だけがインポートされます。

Rust Referenceには、[マクロ関連の属性のリストがあります](../../reference/attributes.html#macro-related-attributes)。

# 変数`$crate`

マクロが複数のクレートで使用される場合、さらに難しい問題が発生します。
`mylib`定義すると言う

```rust
pub fn increment(x: u32) -> u32 {
    x + 1
}

#[macro_export]
macro_rules! inc_a {
    ($x:expr) => ( ::increment($x) )
}

#[macro_export]
macro_rules! inc_b {
    ($x:expr) => ( ::mylib::increment($x) )
}
# fn main() { }
```

`inc_a`内でのみ動作します`mylib`ながら、`inc_b`唯一のライブラリーの外に動作します。
さらに、ユーザーが別の名前で`mylib`をインポートすると、`inc_b`が壊れます。

錆は、（まだ）箱の参照のための衛生システムを持っていませんが、この問題の簡単な回避策を提供しています。
`foo`という名前の木枠からインポートされたマクロ内で、特別なマクロ変数`$crate`は`::foo`展開されます。
対照的に、マクロが定義され、同じ枠で使用されると、`$crate`は何も展開しません。
これは、

```rust
#[macro_export]
macro_rules! inc {
    ($x:expr) => ( $crate::increment($x) )
}
# fn main() { }
```

私たちのライブラリの内部と外部の両方で動作する単一のマクロを定義します。
関数名は`::increment`または`::mylib::increment`展開され`::mylib::increment`。

このシステムをシンプルで正確に保つために、`#[macro_use] extern crate ...`はあなたのクレートのルートにのみ表示され、`mod`では表示されません。

# 深い終わり

入門の章では再帰マクロについて述べましたが、それは完全な話を与えませんでした。
再帰マクロは別の理由で便利です：再帰呼び出しのたびに、マクロの引数にパターンマッチする別の機会が与えられます。

極端な例として、Rustのマクロシステム内で[Bitwise Cyclic Tag](https://esolangs.org/wiki/Bitwise_Cyclic_Tag)オートマトンを実装することは、ほとんどお勧めできませんが、可能です。

```rust
macro_rules! bct {
#    // cmd 0:  d ... => ...
    //  cmd 0：d... =>...
    (0, $($ps:tt),* ; $_d:tt)
        => (bct!($($ps),*, 0 ; ));
    (0, $($ps:tt),* ; $_d:tt, $($ds:tt),*)
        => (bct!($($ps),*, 0 ; $($ds),*));

#    // cmd 1p:  1 ... => 1 ... p
    //  cmd 1p：1... => 1... p
    (1, $p:tt, $($ps:tt),* ; 1)
        => (bct!($($ps),*, 1, $p ; 1, $p));
    (1, $p:tt, $($ps:tt),* ; 1, $($ds:tt),*)
        => (bct!($($ps),*, 1, $p ; 1, $($ds),*, $p));

#    // cmd 1p:  0 ... => 0 ...
    //  cmd 1p：0... => 0...
    (1, $p:tt, $($ps:tt),* ; $($ds:tt),*)
        => (bct!($($ps),*, 1, $p ; $($ds),*));

#    // Halt on empty data string:
    // 空のデータ文字列で停止：
    ( $($ps:tt),* ; )
        => (());
}
```

エクササイズ：マクロを使用して、上記の`bct!`マクロの定義における重複を減らします。

# 一般的なマクロ

Rustコードで表示される一般的なマクロをいくつか紹介します。

## パニック！

このマクロは、現在のスレッドにパニックを引き起こします。
あなたはそれにパニックにメッセージを与えることができます：

```rust,should_panic
panic!("oh no!");
```

## vec！

`vec!`マクロは本の中で使われているので、すでに見たことがあります。
`Vec<T>`を簡単に作成します。

```rust
let v = vec![1, 2, 3, 4, 5];
```

繰り返し値を持つベクトルを作成することもできます。
たとえば、100個のゼロ：

```rust
let v = vec![0; 100];
```

## アサート！
これらの2つのマクロはテストで使用されます。
`assert!`はブール値を取る。
`assert_eq!`は2つの値をとり、それらが等しいかどうかをチェックします。
`true`パス、`false` `panic!`。
このような：

```rust,should_panic
#// A-ok!
// いいよ！

assert!(true);
assert_eq!(5, 3 + 2);

#// Nope :(
// いいえ:(

assert!(5 < 3);
assert_eq!(5, 3);
```

## 試してみて！

エラー処理のために`try!`が使用されています。
`Result<T, E>`返すことができ、`Ok<T>`の場合は`T`を`return`、それが`Err(E)`場合はsを`return`ます。
このような：

```rust,no_run
use std::fs::File;

fn foo() -> std::io::Result<()> {
    let f = try!(File::create("foo.txt"));

    Ok(())
}
```

これはこれを行うよりもきれいです：

```rust,no_run
use std::fs::File;

fn foo() -> std::io::Result<()> {
    let f = File::create("foo.txt");

    let f = match f {
        Ok(t) => t,
        Err(e) => return Err(e),
    };

    Ok(())
}
```

## 到達不能！

このマクロは、コードを決して実行しないと思うときに使用されます：

```rust
if false {
    unreachable!();
}
```

時には、コンパイラはあなたが決して実行することのない別のブランチを持つようにするかもしれません。
このような場合は、このマクロを使用してください。間違ってしまうと、そのマクロについて`panic!`ことがあります。

```rust
let x: Option<i32> = None;

match x {
    Some(_) => unreachable!(),
    None => println!("I know x is None!"),
}
```

## 実装されていない！

`unimplemented!`されていないマクロは、関数の型チェックをしようとしているときに使用することができます。また、関数本体の書き出しを心配する必要もありません。
この状況の1つの例は、一度に1つずつ取り組む必要のある、複数の必須メソッドを持つ特性を実装することです。
作成する準備が整うまで、他のものを`unimplemented!`れていないものとして定義します。