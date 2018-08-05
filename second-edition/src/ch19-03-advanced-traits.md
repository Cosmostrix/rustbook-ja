## 発展的な<ruby>特性<rt>トレイト</rt></ruby>

第10章の「<ruby>特性<rt>トレイト</rt></ruby>。共有行動の定義」の章で最初に<ruby>特性<rt>トレイト</rt></ruby>を説明しましたが、寿命と同様に、より発展的な詳細については説明しませんでした。
Rustについてもっと知った今、素敵なものになることができます。

### 関連型の<ruby>特性<rt>トレイト</rt></ruby>定義における<ruby>場所取り<rt>プレースホルダ</rt></ruby>型の指定

*関連する型は、*特性<ruby>操作法<rt>メソッド</rt></ruby>の定義は、それらの型注釈これらの<ruby>場所取り<rt>プレースホルダ</rt></ruby>の型を使用することができるように<ruby>特性<rt>トレイト</rt></ruby>と型<ruby>場所取り<rt>プレースホルダ</rt></ruby>を接続します。
<ruby>特性<rt>トレイト</rt></ruby>の実装者は、特定の実装に対してこの型の場所で使用される具体的な型を指定します。
このようにして、<ruby>特性<rt>トレイト</rt></ruby>が導入されるまでこれらの型が何であるかを正確に知る必要なしに、いくつかの型を使用する<ruby>特性<rt>トレイト</rt></ruby>を定義することができます。

この章の発展的な機能のほとんどは、まれに必要とされるものであると説明しました。
関連付けられた型は、本の中で説明されている機能よりもめったに使用されませんが、この章で説明する他の機能の多くよりも一般的に使用されています。

関連する型を持つ<ruby>特性<rt>トレイト</rt></ruby>の一例は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>が提供する`Iterator`<ruby>特性<rt>トレイト</rt></ruby>です。
関連する型は`Item`と名付けられ、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装する型が反復処理される値の型を表します。
第13章の「 `Iterator`<ruby>特性<rt>トレイト</rt></ruby>と`next`<ruby>操作法<rt>メソッド</rt></ruby>」の章では、`Iterator`<ruby>特性<rt>トレイト</rt></ruby>の定義がリスト19-20に示されていると述べました。

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}
```

<span class="caption">リスト19-20。関連した型<code>Item</code>を持つ<code>Iterator</code>型の<code>Item</code></span>

`Item`型は<ruby>場所取り<rt>プレースホルダ</rt></ruby>型であり、`next`<ruby>操作法<rt>メソッド</rt></ruby>の定義は、`Option<Self::Item>`型の値を返すことを示しています。
`Iterator`<ruby>特性<rt>トレイト</rt></ruby>の実装者は、`Item`の具体的な型を指定し、`next`<ruby>操作法<rt>メソッド</rt></ruby>は、その具体的な型の値を含む`Option`を返します。

関連型は、総称化と同様の概念のように見えるかもしれません。後者は、処理できる型を指定せずに機能を定義することができます。
だから関連する型を使うのはなぜでしょうか？　

`Counter`構造体の`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装する第13章の例を使って、2つの概念の違いを調べてみましょう。
<ruby>譜面<rt>コード</rt></ruby>リスト13-21では、`Item`型が`u32`。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
#        // --snip--
        //  --snip--
```

この構文は、総称化の構文に匹敵するようです。
リスト19-21に示すように、総称化で`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を定義するだけではどうでしょうか？　

```rust
pub trait Iterator<T> {
    fn next(&mut self) -> Option<T>;
}
```

<span class="caption">リスト19-21。総称化を使った<code>Iterator</code>特性の仮説的定義</span>

違いは、リスト19-21のように総称化を使用する場合は、各実装で型に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があります。
`Iterator<String> for Counter`やその他の型の`Iterator<String> for Counter`実装することもできるため、`Counter`用`Iterator`実装は複数ある可能性があります。
言い換えれば、<ruby>特性<rt>トレイト</rt></ruby>に汎用パラメータがある場合、その型ごとに汎用型パラメータの具体的な型を変更して、型ごとに複数回実装することができます。
`Counter`で`next`<ruby>操作法<rt>メソッド</rt></ruby>を使用する場合は、使用する`Iterator`実装を示すために型注釈を提供する必要があります。

関連する型では、型に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありません。型に対して何度も型を実装できないからです。
リスト19-20では、関連付けられた型を使用する定義を使用して`impl Iterator for Counter` 1つの`impl Iterator for Counter`しか`impl Iterator for Counter`ことができないため、`Item`の型を1回だけ選択できます。
`Counter` `next`に呼び出すすべての`u32`値の<ruby>反復子<rt>イテレータ</rt></ruby>を必要とすることを指定する必要はありません。

### <ruby>黙用<rt>デフォルト</rt></ruby>の汎用型のパラメータと演算子の多重定義

総称型パラメータを使用するときは、総称型の<ruby>黙用<rt>デフォルト</rt></ruby>コンクリート型を指定できます。
これにより、<ruby>黙用<rt>デフォルト</rt></ruby>型が動作する場合に、具体的な型を指定するために、<ruby>特性<rt>トレイト</rt></ruby>の実装者が必要なくなります。
総称型を宣言するときは、総称型の既定の型を指定する構文は`<PlaceholderType=ConcreteType>`です。

この技法が有用な状況の大きな例は、演算子の多重定義にあります。
*演算子の多重定義*は、特定の状況で演算子（`+`など）の動作をカスタマイズすることです。

Rustでは、独自の演算子を作成したり、任意の演算子を多重定義することはできません。
しかし、演算子に関連する<ruby>特性<rt>トレイト</rt></ruby>を実装することで、`std::ops`リストされている演算とそれに対応する<ruby>特性<rt>トレイト</rt></ruby>を多重定義することができます。
たとえば、リスト19-22では`+`演算子を多重定義して2つの`Point`<ruby>実例<rt>インスタンス</rt></ruby>を一緒に追加します。
これを行うには、`Point`構造体に`Add`<ruby>特性<rt>トレイト</rt></ruby>を実装します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::ops::Add;

#[derive(Debug, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    assert_eq!(Point { x: 1, y: 0 } + Point { x: 2, y: 3 },
               Point { x: 3, y: 3 });
}
```

<span class="caption">リスト19-22。 <code>Point</code>実例の<code>+</code>演算子を多重定義する<code>Add</code>特性の実装</span>

`add`方法は、追加`x` 2つの値`Point`<ruby>実例<rt>インスタンス</rt></ruby>と`y` 2つの値`Point`新しい作成するために、<ruby>実例<rt>インスタンス</rt></ruby>を`Point`。
`Add`<ruby>特性<rt>トレイト</rt></ruby>は、`add`<ruby>操作法<rt>メソッド</rt></ruby>から返される型を決定する`Output`という名前の関連する型を持ちます。

この<ruby>譜面<rt>コード</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>総称型は、`Add` trait内にあります。
ここにその定義があります。

```rust
trait Add<RHS=Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}
```

この<ruby>譜面<rt>コード</rt></ruby>は一般的によく知られているはずです。一つの<ruby>操作法<rt>メソッド</rt></ruby>とそれに関連する型を持つものです。
新しい部分は`RHS=Self`です。この構文は*<ruby>黙用<rt>デフォルト</rt></ruby>の型パラメータ*と呼ばれ*ます*。
`RHS`総称型パラメータ（「右辺」の略）は、`add`<ruby>操作法<rt>メソッド</rt></ruby>の`rhs`パラメータの型を定義します。
`Add`<ruby>特性<rt>トレイト</rt></ruby>を実装するときに`RHS`具体的な型を指定しなければ、`RHS`の型は自動的に`Self`になります。これは`Add`を実装する型になります。

`Add` for `Point`を実装したとき、2つの`Point`<ruby>実例<rt>インスタンス</rt></ruby>を追加したいので、`RHS`の<ruby>黙用<rt>デフォルト</rt></ruby>を使用しました。
<ruby>黙用<rt>デフォルト</rt></ruby>を使用するのではなく、`RHS`型をカスタマイズする`Add`<ruby>特性<rt>トレイト</rt></ruby>を実装する例を見てみましょう。

`Millimeters`と`Meters` 2つの構造体があり、それぞれ異なる単位で値が保持されています。
ミリメートル単位の値をメートル単位の値に`Add`し、「 `Add`の実装で変換を正しく実行する必要があります。
リスト19-23に示すように、`RHS`として「 `Meters`を持つ`Add` for `Millimeters` 」を実装できます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
use std::ops::Add;

struct Millimeters(u32);
struct Meters(u32);

impl Add<Meters> for Millimeters {
    type Output = Millimeters;

    fn add(self, other: Meters) -> Millimeters {
        Millimeters(self.0 + (other.0 * 1000))
    }
}
```

<span class="caption">リスト19-23。 <code>Millimeters</code>を<code>Meters</code>に追加するための<code>Millimeters</code>の<code>Add</code>特性の実装</span>

`Millimeters`と`Meters`を追加するには、<ruby>黙用<rt>デフォルト</rt></ruby>の`Self`を使用する代わりに、`RHS`型のパラメータの値を設定するために、`impl Add<Meters>`を指定します。

<ruby>黙用<rt>デフォルト</rt></ruby>の型パラメータは、主に2つの方法で使用されます。

* 既存の<ruby>譜面<rt>コード</rt></ruby>を壊さずに型を拡張するには
* 特定のケースでカスタマイズを可能にするために、ほとんどの利用者は

標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`Add` traitは2番目の目的の例です。通常、2つの型を追加しますが、`Add`<ruby>特性<rt>トレイト</rt></ruby>はそれを超えてカスタマイズする機能を提供します。
「<ruby>特性<rt>トレイト</rt></ruby>の`Add`定義で<ruby>黙用<rt>デフォルト</rt></ruby>の型・パラメーターを使用すると、ほとんどの場合、余分なパラメーターを指定する必要はありません。
言い換えれば、少年実装の定型文は必要ないので、その<ruby>特性<rt>トレイト</rt></ruby>を使いやすくします。

第1の目的は、第2の目的と似ていますが、既存の<ruby>特性<rt>トレイト</rt></ruby>に型パラメータを追加する場合は、既存の実装<ruby>譜面<rt>コード</rt></ruby>を破ることなく、<ruby>特性<rt>トレイト</rt></ruby>の機能拡張を可能にする<ruby>黙用<rt>デフォルト</rt></ruby>を与えることができます。

### 曖昧さ回避のための完全修飾構文。同じ名前の<ruby>操作法<rt>メソッド</rt></ruby>の呼び出し

Rustの何も、<ruby>特性<rt>トレイト</rt></ruby>が別の<ruby>特性<rt>トレイト</rt></ruby>の<ruby>操作法<rt>メソッド</rt></ruby>と同じ名前の<ruby>操作法<rt>メソッド</rt></ruby>を持つのを防ぎません。また、Rustは、両方の型を1つの型に実装することもできません。
また、<ruby>操作法<rt>メソッド</rt></ruby>の型と同じ名前の型に直接<ruby>操作法<rt>メソッド</rt></ruby>を実装することも可能です。

同じ名前の<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すときは、使用したい<ruby>操作法<rt>メソッド</rt></ruby>をRustに伝える必要があります。
リスト19-24の<ruby>譜面<rt>コード</rt></ruby>で、`Pilot`と`Wizard` 2つの<ruby>特性<rt>トレイト</rt></ruby>を定義していますが、どちらも`fly`と呼ばれる<ruby>操作法<rt>メソッド</rt></ruby>を持ってい`fly`。
すでに、`fly`という名前の<ruby>操作法<rt>メソッド</rt></ruby>`fly`実装されている型`Human`両方の型を実装します。
各`fly`<ruby>操作法<rt>メソッド</rt></ruby>は、何か違うことをします。

<span class="filename">ファイル名。src/main.rs</span>

```rust
trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}
```

<span class="caption">リスト19-24。2つの<ruby>特性<rt>トレイト</rt></ruby>は、 <code>fly</code>操作法を持つように定義され、 <code>Human</code>型で実装され、 <code>fly</code>操作法は<code>Human</code>直接実装されます</span>

`Human`<ruby>実例<rt>インスタンス</rt></ruby>に対して`fly`を呼び出すと、<ruby>製譜器<rt>コンパイラー</rt></ruby>は自動的に、型に直接実装されている<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すようにします（<ruby>譜面<rt>コード</rt></ruby>リスト19-25を参照）。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# trait Pilot {
#     fn fly(&self);
# }
#
# trait Wizard {
#     fn fly(&self);
# }
#
# struct Human;
#
# impl Pilot for Human {
#     fn fly(&self) {
#         println!("This is your captain speaking.");
#     }
# }
#
# impl Wizard for Human {
#     fn fly(&self) {
#         println!("Up!");
#     }
# }
#
# impl Human {
#     fn fly(&self) {
#         println!("*waving arms furiously*");
#     }
# }
#
fn main() {
    let person = Human;
    person.fly();
}
```

<span class="caption">リスト19-25。 <code>Human</code>実例で<code>fly</code>を呼び出す</span>

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、`*waving arms furiously*`、 `Human`直接実装された`fly`<ruby>操作法<rt>メソッド</rt></ruby>と呼ばれるRustを表示します。

`Pilot`<ruby>特性<rt>トレイト</rt></ruby>または`Wizard`<ruby>特性<rt>トレイト</rt></ruby>のいずれかから`fly`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すには、より明示的な構文を使用して、どの`fly`<ruby>操作法<rt>メソッド</rt></ruby>を指定する必要があります。
リスト19-26は、この構文を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# trait Pilot {
#     fn fly(&self);
# }
#
# trait Wizard {
#     fn fly(&self);
# }
#
# struct Human;
#
# impl Pilot for Human {
#     fn fly(&self) {
#         println!("This is your captain speaking.");
#     }
# }
#
# impl Wizard for Human {
#     fn fly(&self) {
#         println!("Up!");
#     }
# }
#
# impl Human {
#     fn fly(&self) {
#         println!("*waving arms furiously*");
#     }
# }
#
fn main() {
    let person = Human;
    Pilot::fly(&person);
    Wizard::fly(&person);
    person.fly();
}
```

<span class="caption">リスト19-26。呼び出すtraitの<code>fly</code>操作法を指定する</span>

<ruby>操作法<rt>メソッド</rt></ruby>名の前に<ruby>特性<rt>トレイト</rt></ruby>名を指定すると、呼び出したい`fly`実装をRustに明確にします。
また、リスト19-26で使用した`person.fly()`と同等の`Human::fly(&person)`を記述することもできますが、曖昧さを除去する必要がない場合は、書き込むのに少し時間が`person.fly()`ます。

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、以下が出力されます。

```text
This is your captain speaking.
Up!
*waving arms furiously*
```

`fly`<ruby>操作法<rt>メソッド</rt></ruby>は`self`パラメータを取るので、両方とも1つの*<ruby>特性<rt>トレイト</rt></ruby>を*実装する2つの*型が*ある場合、Rustは`self`の型に基づいて使用する<ruby>特性<rt>トレイト</rt></ruby>の実装を把握することができます。

しかし、<ruby>特性<rt>トレイト</rt></ruby>の一部である関連する機能には、`self`パラメータはありません。
同じ<ruby>有効範囲<rt>スコープ</rt></ruby>内の2つの型がその<ruby>特性<rt>トレイト</rt></ruby>を実装するとき、Rustは*完全修飾構文*を使用しない限り、どの型を意味するのか把握できません。
たとえば、リスト19-27の`Animal`<ruby>特性<rt>トレイト</rt></ruby>には、関連する機能`baby_name`、構造体`Dog` `Animal`の実装、`Dog`直接定義された関連する機能`baby_name`ます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
trait Animal {
    fn baby_name() -> String;
}

struct Dog;

impl Dog {
    fn baby_name() -> String {
        String::from("Spot")
    }
}

impl Animal for Dog {
    fn baby_name() -> String {
        String::from("puppy")
    }
}

fn main() {
    println!("A baby dog is called a {}", Dog::baby_name());
}
```

<span class="caption">リスト19-27。関連する機能と同じ名前の関連する機能を持ち、その<ruby>特性<rt>トレイト</rt></ruby>も実装している型</span>

この<ruby>譜面<rt>コード</rt></ruby>は`Dog`定義されている`baby_name`関連の機能に実装されているすべての子犬Spotの名前を付ける動物避難所の<ruby>譜面<rt>コード</rt></ruby>です。
`Dog`型はまた、すべての動物が持つ<ruby>特性<rt>トレイト</rt></ruby>を記述する<ruby>特性<rt>トレイト</rt></ruby>`Animal`実装します。
赤ちゃんの犬は子犬と呼ばれ、そのはの実装で表現された`Animal`の<ruby>特性<rt>トレイト</rt></ruby>の`Dog`で`baby_name`に関連した機能`Animal`<ruby>特性<rt>トレイト</rt></ruby>。

`main`では、`Dog::baby_name`機能を呼び出します。これは、`Dog`定義された関連機能を直接呼び出します。
この<ruby>譜面<rt>コード</rt></ruby>は、以下を出力します。

```text
A baby dog is called a Spot
```

この出力は望むものではありません。
`Dog`に実装した`Animal`<ruby>特性<rt>トレイト</rt></ruby>の一部である`baby_name`機能を呼び出したいので、<ruby>譜面<rt>コード</rt></ruby>が出力します`A baby dog is called a puppy`ます。
リスト19-26で使用した<ruby>特性<rt>トレイト</rt></ruby>名を指定する方法は、ここでは役に立ちません。
リスト19-28の<ruby>譜面<rt>コード</rt></ruby>に`main`を変更すると、<ruby>製譜<rt>コンパイル</rt></ruby>誤りが発生します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    println!("A baby dog is called a {}", Animal::baby_name());
}
```

<span class="caption">リスト19-28。 <code>Animal</code>特性から<code>baby_name</code>機能を呼び出そうとしましたが、Rustは使用する実装を知らない</span>

`Animal::baby_name`は<ruby>操作法<rt>メソッド</rt></ruby>ではなく関連する機能であるため、`self`パラメータを持たないため、Rustは`Animal::baby_name`実装が必要なのか把握できません。
この<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。

```text
error[E0283]: type annotations required: cannot resolve `_: Animal`
  --> src/main.rs:20:43
   |
20 |     println!("A baby dog is called a {}", Animal::baby_name());
   |                                           ^^^^^^^^^^^^^^^^^
   |
   = note: required by `Animal::baby_name`
```

の実装を使用したいRust明確と言うと`Animal`のための`Dog`、完全修飾された構文を使用する必要があります。
リスト19-29は、完全修飾構文を使用する方法を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# trait Animal {
#     fn baby_name() -> String;
# }
#
# struct Dog;
#
# impl Dog {
#     fn baby_name() -> String {
#         String::from("Spot")
#     }
# }
#
# impl Animal for Dog {
#     fn baby_name() -> String {
#         String::from("puppy")
#     }
# }
#
fn main() {
    println!("A baby dog is called a {}", <Dog as Animal>::baby_name());
}
```

<span class="caption">リスト19-29。 <code>Dog</code>実装されている<code>Animal</code>特性から<code>baby_name</code>機能を呼び出すように完全修飾構文を使用する</span>

この機能呼び出しの`Animal`として`Dog`型を扱いたいと言って、`Dog`実装されている`Animal`<ruby>特性<rt>トレイト</rt></ruby>から`baby_name`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことを示す、角かっこ内の型注釈をRustに提供しています。
この<ruby>譜面<rt>コード</rt></ruby>は今望むものを<ruby>印字<rt>プリント</rt></ruby>します。

```text
A baby dog is called a puppy
```

一般に、完全修飾構文は次のように定義されます。

```rust,ignore
<Type as Trait>::function(receiver_if_method, next_arg, ...);
```

関連する機能については、`receiver`は存在しません。他の引数のリストのみが存在します。
機能や<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すときは、どこでも完全修飾構文を使用できます。
しかし、この構文の中で、Rustが<ruby>算譜<rt>プログラム</rt></ruby>の他の情報から把握できる部分を省略することは許されています。
同じ名前を使用する複数の実装があり、Rustが呼び出す実装を識別するのに役立つ必要がある場合は、このより冗長な構文を使用する必要があります。

### Supertraitsを使用して別の<ruby>特性<rt>トレイト</rt></ruby>内にある<ruby>特性<rt>トレイト</rt></ruby>の機能を要求する

場合によっては、別の<ruby>特性<rt>トレイト</rt></ruby>の機能を使用するために、ある<ruby>特性<rt>トレイト</rt></ruby>を必要とするかもしれません。
この場合、依存する<ruby>特性<rt>トレイト</rt></ruby>が実装されていることに依存する必要があります。
依存している<ruby>特性<rt>トレイト</rt></ruby>は、実施している<ruby>特性<rt>トレイト</rt></ruby>の*スーパートライト*です。

たとえば、アスタリスクで囲まれた値を出力する`outline_print`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`OutlinePrint`<ruby>特性<rt>トレイト</rt></ruby>を作成したいとします。
つまり、`Display`を実装する`Point`構造体が`(x, y)`になる場合、`x`が`1`、 `y` `3` `Point`<ruby>実例<rt>インスタンス</rt></ruby>で`outline_print`を呼び出すと、次のように出力されます。

```text
**********
*        *
* (1, 3) *
*        *
**********
```

`outline_print`の実装では、`Display`<ruby>特性<rt>トレイト</rt></ruby>の機能を使用したいと考えています。
したがって、`OutlinePrint`<ruby>特性<rt>トレイト</rt></ruby>は、`Display`を実装し、`OutlinePrint`が必要とする機能を提供する型に対してのみ機能するように`OutlinePrint`する必要があります。
`OutlinePrint: Display`指定することで、<ruby>特性<rt>トレイト</rt></ruby>定義でこれを行うことができます。
この技法は、<ruby>特性<rt>トレイト</rt></ruby>に結合した<ruby>特性<rt>トレイト</rt></ruby>を加えることと同様であます。
リスト19-30に、`OutlinePrint`<ruby>特性<rt>トレイト</rt></ruby>の実装を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::fmt;

trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}
```

<span class="caption">リスト19-30。 <code>Display</code>からの機能を必要とする<code>OutlinePrint</code>特性の実装</span>

いることを指定したので`OutlinePrint`必要と`Display`<ruby>特性<rt>トレイト</rt></ruby>を、使用することができます`to_string`、自動的に実装する任意の型のために実装された機能`Display`。
コロンを追加せずに`to_string`を使用して<ruby>特性<rt>トレイト</rt></ruby>名の後に`Display`<ruby>特性<rt>トレイト</rt></ruby>を指定しようとすると、現在の<ruby>有効範囲<rt>スコープ</rt></ruby>内の`&Self`型の`to_string`という名前の`to_string`が見つかりませんでした。

`Point`構造体など、`Display`実装しない型で`OutlinePrint`を実装しようとしたときにどうなるかを見てみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# trait OutlinePrint {}
struct Point {
    x: i32,
    y: i32,
}

impl OutlinePrint for Point {}
```

`Display`が必須であるが実装されていないという<ruby>誤り<rt>エラー</rt></ruby>が`Display`される。

```text
error[E0277]: the trait bound `Point: std::fmt::Display` is not satisfied
  --> src/main.rs:20:6
   |
20 | impl OutlinePrint for Point {}
   |      ^^^^^^^^^^^^ `Point` cannot be formatted with the default formatter;
try using `:?` instead if you are using a format string
   |
   = help: the trait `std::fmt::Display` is not implemented for `Point`
```

これを修正するために、`Display` on `Point`を実装し、`OutlinePrint`必要な制約を満たすようにします。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# struct Point {
#     x: i32,
#     y: i32,
# }
#
use std::fmt;

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
```

次に、`Point`上で`OutlinePrint`<ruby>特性<rt>トレイト</rt></ruby>を実装すると、正常に<ruby>製譜<rt>コンパイル</rt></ruby>され、`Point`<ruby>実例<rt>インスタンス</rt></ruby>に対して`outline_print`を呼び出して、アスタリスクのアウトライン内に表示することができます。

### 外部型に外部型を実装するためのNewtypeパターンの使用

第10章の「型の型の実装」の章では、型または型が<ruby>通い箱<rt>クレート</rt></ruby>のローカルである限り、型に対して型を実装することを許可されている孤児のルールについて述べました。
*newtypeパターン*を使用してこの制限を回避することができ*ます*。これには、組構造体に新しい型を作成することが含まれます。
（組構造体については、第5章の「名前付き<ruby>欄<rt>フィールド</rt></ruby>を持たない組構造体を使用して異なる型を作成する」章を参照してください。）組構造体は、1つの<ruby>欄<rt>フィールド</rt></ruby>を持ち、<ruby>特性<rt>トレイト</rt></ruby>を実装する型の周りに薄いの包みになります。
次に、の包み型は<ruby>通い箱<rt>クレート</rt></ruby>に局所的であり、の包みにその<ruby>特性<rt>トレイト</rt></ruby>を実装することができます。
*Newtype*は、Haskell<ruby>演譜<rt>プログラミング</rt></ruby>言語に由来する用語です。
このパターンの使用には、実行時のパフォーマンス上のペナルティはなく、の包み・型は<ruby>製譜<rt>コンパイル</rt></ruby>時に省略されます。

一例として、`Display` traitと`Vec<T>`型が枠の外で定義されているため、Orphanルールが直接行うことを妨げる`Display` on `Vec<T>`を実装したいとしましょう。
`Vec<T>`<ruby>実例<rt>インスタンス</rt></ruby>を保持する`Wrapper`構造体を作ることができます。
リスト19-31に示すように、`Display` on `Wrapper`を実装して`Vec<T>`値を使用することができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::fmt;

struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

fn main() {
    let w = Wrapper(vec![String::from("hello"), String::from("world")]);
    println!("w = {}", w);
}
```

<span class="caption">リスト19-31。 <code>Display</code>を実装する<code>Vec&lt;String&gt;</code>周りに<code>Wrapper</code>型を作成する</span>

`Wrapper`は組構造体であり、`Vec<T>`は組内の<ruby>添字<rt>インデックス</rt></ruby>0の項目であるため、`Display`の実装では内部`Vec<T>`にアクセスするために`self.0`が使用`self.0`れます。
次に、`Wrapper` `Display`型の機能を使用することができます。

この手法を使用することの欠点は、`Wrapper`は新しい型なので、それが保持している値の<ruby>操作法<rt>メソッド</rt></ruby>はありません。
`Vec<T>`すべての<ruby>操作法<rt>メソッド</rt></ruby>を`Wrapper`直接実装する必要があり、<ruby>操作法<rt>メソッド</rt></ruby>が`self.0`に委譲されるため、`Wrapper` `Vec<T>`ように扱うことができます。
実装し、内側の型が持っているすべての<ruby>操作法<rt>メソッド</rt></ruby>を持っている新しい型のを望んでいた場合は`Deref`<ruby>特性<rt>トレイト</rt></ruby>を（「との定期的な参考資料のようなスマート<ruby>指し手<rt>ポインタ</rt></ruby>治療に15章で説明`Deref`の章<ruby>特性<rt>トレイト</rt></ruby>」）を`Wrapper`インナー型は次のようになり返すように解決策。
`Wrapper`型に内部型のすべての<ruby>操作法<rt>メソッド</rt></ruby>を持たせたくない場合（例えば、`Wrapper`型の振る舞いを制限する場合）、手動で行う<ruby>操作法<rt>メソッド</rt></ruby>を実装する必要があります。

今では、newtypeパターンがどのように<ruby>特性<rt>トレイト</rt></ruby>に関連して使われているかを知っています。
それは、<ruby>特性<rt>トレイト</rt></ruby>が関与していなくても有用なパターンです。
Rustの型体系と対話するためのいくつかの発展的な方法を見てみましょう。
