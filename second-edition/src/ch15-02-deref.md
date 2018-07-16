## `Deref` Traitとの正規の参照のようなスマート指し手の処理

`Deref`特性を実装すると、*逆参照演算子* `*`（乗算またはglob演算子とは対照的に）の動作をカスタマイズできます。
スマート指し手を通常の参照のように扱えるように`Deref`を実装することで、参照で動作する譜面を記述し、スマート指し手でその譜面を使用することができます。

逆参照演算子が正規の参照とどのように機能するかを見てみましょう。
次に、`Box<T>`ような振る舞いをする独自型を定義して、逆参照演算子が新しく定義された型の参照のように動作しない理由を確認します。
`Deref`特性を実装することで、スマート指し手が参照と同様の方法で動作することが可能になります。
次に、Rustの*deref強制型変換*機能と、それが参照やスマート指し手のどちらを*扱う*かについて説明します。

### Dereference演算子を持つ値への指し手に続いて

通常の参照は指し手の型であり、指し手を考える方法の1つは、他の場所に格納された値への矢印のようなものです。
譜面リスト15-6では、`i32`値への参照を作成し、逆参照演算子を使用してデータへの参照を追跡します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

<span class="caption">リスト15-6。逆参照演算子を使って<code>i32</code>値への参照を追跡する</span>

変数`x`は`i32`値`5`保持します。
`y`を`x`参照と等しく設定します。
`x`は`5`等しいと主張することができます。
しかし、`y`の値についてのアサーションを作成したい場合は、それが指す値への参照に従うために`*y`を使用する必要があります（したがって*逆参照*）。
いったん`y`を参照解除すると、整数値`y`アクセスすることができ、`y`は`5`と比較できることを示しています。

`assert_eq!(5, y);`を書こうとすると`assert_eq!(5, y);`
代わりに、この製譜誤りが発生します。

```text
error[E0277]: the trait bound `{integer}: std::cmp::PartialEq<&{integer}>` is
not satisfied
 --> src/main.rs:6:5
  |
6 |     assert_eq!(5, y);
  |     ^^^^^^^^^^^^^^^^^ can't compare `{integer}` with `&{integer}`
  |
  = help: the trait `std::cmp::PartialEq<&{integer}>` is not implemented for
  `{integer}`
```

数値と参照の比較は、異なる型であるため許可されていません。
参照している値への参照に従うには、逆参照演算子を使用する必要があります。

### 参照と同様に`Box<T>`を使う

リスト15-6の譜面を書き換えて、参照の代わりに`Box<T>`使うことができます。
逆参照演算子はリスト15-7のように動作します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

<span class="caption">リスト15-7。 <code>Box&lt;i32&gt;</code>逆参照演算子を使う<code>Box&lt;i32&gt;</code></span>

表15-7および表15-6との間の唯一の違いは、ここでは、設定することである`y`の値を指すボックスの実例であることが`x`よりもむしろの値を指す参照`x`。
最後のアサーションでは、逆参照演算子を使用して、`y`が参照のときと同じ方法でボックスの指し手に従うことができます。
次に、独自のボックス型を定義して参照解除演算子を使用できるようにする`Box<T>`特別な点について検討します。

### 独自のスマート指し手の定義

標準譜集によって提供される`Box<T>`型に似たスマート指し手を構築して、スマート指し手が自動的に参照とは異なる動作をする様子を見てみましょう。
次に、逆参照演算子を使用する機能を追加する方法を見ていきます。

`Box<T>`型は最終的に1つの要素を持つ組構造体として定義されているので、リスト15-8も同じように`MyBox<T>`型を定義しています。
また、`Box<T>`定義された`new`機能と一致する`new`機能を定義します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
```

<span class="caption">リスト15-8。 <code>MyBox&lt;T&gt;</code>型の定義</span>

`MyBox`という名前の構造体を定義し、汎用型のパラメータ`T`を宣言します。これは、型に任意の型の値を保持させるためです。
`MyBox`型は、`T`型の要素を1つ含む組構造体です。
`MyBox::new`機能は、`T`型の1つのパラメータをとり、渡された値を保持する`MyBox`実例を返します。

リスト15-7の`main`機能をリスト15-8に追加し、`Box<T>`代わりに定義した`MyBox<T>`型を使用するように変更してみましょう。
Rustは`MyBox`を逆参照する方法を知らないので、リスト15-9の譜面は製譜されません。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let x = 5;
    let y = MyBox::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

<span class="caption">リスト15-9。 <code>MyBox&lt;T&gt;</code>を参照と同じ方法で使用しようとし、 <code>Box&lt;T&gt;</code></span>

結果として生じる製譜誤りは次のとおりです。

```text
error[E0614]: type `MyBox<{integer}>` cannot be dereferenced
  --> src/main.rs:14:19
   |
14 |     assert_eq!(5, *y);
   |                   ^^
```

`MyBox<T>`型は、その型に対してその能力を実装していないため、逆参照できません。
`*`演算子で参照解除を有効にするには、`Deref`特性を実装します。

### `Deref`特性を実装して参照型の型を扱う

第10章で説明したように、特性を実装するためには、特性の必須操作法の実装を提供する必要があります。
標準譜集によって提供される`Deref`特性は、`deref`という名前の操作法を実装する必要があります`deref`は`self`を借りて内部データへの参照を返します。
15-10のリストの実装が含まれ`Deref`定義に追加する`MyBox`。

<span class="filename">ファイル名。src / main.rs</span>

```rust
use std::ops::Deref;

# struct MyBox<T>(T);
impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}
```

<span class="caption">15-10リスト。実装<code>Deref</code>の<code>MyBox&lt;T&gt;</code></span>

`type Target = T;`
構文は、`Deref`特性が使用する関連型を定義します。
関連する型は、総称化パラメータを宣言する方法が少し異なりますが、今のところそれらについて心配する必要はありません。
第19章で詳しく説明します。

`deref`操作法の本体を`&self.0`ので、`deref`は`*`演算子でアクセスしたい値への参照を返します。
リスト15-9の`main`機能は、`MyBox<T>`値で`*`を呼び出すようになり、アサーションが成功するようになりました！　

`Deref`特性がなければ、製譜器は参照`&`参照のみを参照できます。
`deref`方法は、製譜器に実装する任意の型の値取る能力与え`Deref`して呼び出す`deref`取得する方法を`&`それがどのように間接参照に知っているの参照を。

リスト15-9の`*y`を入力したとき、Rustは実際にこの譜面を実行しました。

```rust,ignore
*(y.deref())
```

Rustは`*`演算子を`deref`操作法の呼び出しで置き換えてから、単純な逆参照を行うため、`deref`操作法を呼び出す必要があるかどうかについて考える必要はありません。
このRust（Rust）機能を使用すると、通常の参照を持っていようと、`Deref`を実装する型を持っていても、同じように機能する譜面を書くことができます。

`deref`操作法が値への参照を返し、`*(y.deref())`かっこ以外の単純な参照が依然として必要である`*(y.deref())`は、所有権システムです。
`deref`操作法が値への参照ではなく値を直接返す場合、値は`self`から移動されます。
この場合`MyBox<T>`内の内部値の所有権や、参照解除演算子を使用するほとんどの場合、所有権を取得したくありません。

`*`演算子は`deref`操作法への呼び出しに置き換えられ、`*`演算子への呼び出しは譜面で`*`を使うたびに一度だけ呼び出されることに注意してください。
`*`演算子の代入は無限に`assert_eq!`、リスト15-9の`assert_eq!`の`5`に一致する型`i32`データになります。

### 機能と操作法を使った暗黙的なDeref強制型変換

*Derefの強制型変換*は、Rustが機能と操作法の引数に実行する便利な機能です。
DEREF強制型変換を実装する型への参照に変換`Deref`型への参照に`Deref`に元の型を変換することができます。
特定の型の値への参照を、機能または操作法定義のパラメータ型と一致しない機能または操作法の引数として渡すと、Deref強制型変換が自動的に発生します。
`deref`操作法への一連の呼び出しは、指定した型をパラメータが必要とする型に変換します。

機能と操作法呼び出しを書く演譜師が`&`と`*`使って多くの明示的な参照と逆参照を追加する必要がないように、Deref強制型変換がRustに追加されました。
deref強制型変換機能では、参照やスマート指し手のどちらでも動作する譜面を書くことができます。

動作でDEREF強制型変換を確認するには、のは、使用してみましょう`MyBox<T>`型を、リスト15-8で定義されているだけでなく、実装の`Deref`リスト15-10で追加されていること。
リスト15-11は、文字列sliceパラメータを持つ機能の定義を示しています。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn hello(name: &str) {
    println!("Hello, {}!", name);
}
```

<span class="caption">リスト15-11。 <code>&amp;str</code>型のパラメータ<code>name</code>を持つ<code>hello</code>機能</span>

`hello("Rust");`ように、文字列sliceを引数として`hello`機能を呼び出すことができます`hello("Rust");`
例えば。
Deref強制型変換は、リスト15-12に示すように、`MyBox<String>`型の値への参照で`hello`を呼び出すことができます。

<span class="filename">ファイル名。src / main.rs</span>

```rust
# use std::ops::Deref;
#
# struct MyBox<T>(T);
#
# impl<T> MyBox<T> {
#     fn new(x: T) -> MyBox<T> {
#         MyBox(x)
#     }
# }
#
# impl<T> Deref for MyBox<T> {
#     type Target = T;
#
#     fn deref(&self) -> &T {
#         &self.0
#     }
# }
#
# fn hello(name: &str) {
#     println!("Hello, {}!", name);
# }
#
fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

<span class="caption">リスト15-12。deref強制型変換のために動作する<code>MyBox&lt;String&gt;</code>値への参照で<code>hello</code>を呼び出す</span>

ここでは、`MyBox<String>`値への参照である引数`&m`して`hello`機能を呼び出しています。
実装されているので`Deref`上の特性を`MyBox<T>`リスト15-10で、Rustを変えることができます`&MyBox<String>`に`&String`を呼び出すことによって`deref`。
標準譜集は文字列スライスを返す`Deref` on `String`実装を提供しています。これは`Deref` API開発資料にあります。
Rustは`deref`再度呼び出して、`&String`を`&str`に変換し`&str`。これは`hello`機能の定義に一致します。

Rustが逆参照を実装していない場合は、リスト15-12の譜面の代わりにリスト15-13の譜面を記述して、`&MyBox<String>`型の値で`hello`を呼び出す必要があります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
# use std::ops::Deref;
#
# struct MyBox<T>(T);
#
# impl<T> MyBox<T> {
#     fn new(x: T) -> MyBox<T> {
#         MyBox(x)
#     }
# }
#
# impl<T> Deref for MyBox<T> {
#     type Target = T;
#
#     fn deref(&self) -> &T {
#         &self.0
#     }
# }
#
# fn hello(name: &str) {
#     println!("Hello, {}!", name);
# }
#
fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&(*m)[..]);
}
```

<span class="caption">リスト15-13。Rustが逆参照を持たない場合に書くべき譜面</span>

`(*m)`逆参照`MyBox<String>`に`String`。
次に、`&`と`[..]`は、`hello`の型指示と一致する文字列全体に等しい`String`文字列スライスを取ります。
参照元変換を持たない譜面は、これらのシンボルがすべて読み込まれ、記述され、理解するのが困難です。
Derefの強制型変換はRustにこれらの変換を自動的に処理させます。

関係する型に対して`Deref`特性が定義されている場合、Rustは型を解析し、`Deref::deref`を必要なだけ何度も使用して、パラメータの型に一致する参照を取得します。
`Deref::deref`を挿入する必要がある回数は製譜時に解決されるため、逆変換を利用するための実行時のペナルティはありません。

### Deref強制型変換とMutabilityとの相互作用

あなたが使用する方法と同様に`Deref`上書きする特性を`*`不変の参照の演算子を、あなたが使用することができ`DerefMut`上書きする特性を`*`変更可能な参照の演算子を。

Rustは3つのケースで型と特性の実装を見つけたときには逆変換を行います。

* `T: Deref<Target=U>`ときに`&T`から`&U`まで
* `T: DerefMut<Target=U>`とき、`&mut T`から`&mut U`へ
* `T: Deref<Target=U>`とき、`&mut T`から`&U`へ

最初の2つのケースは、変更可能性を除いて同じです。
最初のケースでは、`&T`があり、`T`が`Deref`をある種の`U`実装すると、`&U`透過的に得ることができると述べています。
2番目のケースでは、可変参照のために同じ逆変換が行われると述べています。

3番目のケースは扱いにくいです。Rustは不変のものへの変更可能な参照を強制型変換します。
しかし、その逆は*できません*。不変参照は決して変更可能な参照を強制型変換しません。
借用ルールのために、変更可能な参照がある場合、その変更可能な参照はそのデータへの唯一の参照でなければなりません（そうでなければ、算譜は製譜されません）。
1つの可変参照を1つの不変参照に変換することは、借用ルールを破ることはありません。
不変参照を変更可能な参照に変換するには、そのデータへの不変参照が1つしかないことが必要であり、借用規則はそれを保証するものではありません。
したがって、Rustは不変参照を可変参照に変換することは可能であると仮定することはできません。
