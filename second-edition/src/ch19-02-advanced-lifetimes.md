## 高度な寿命

第10章の「寿命を持つ参照の検証」の節では、寿命のパラメータで参照に注釈を付けて、異なる参照の寿命がどのように関連しているかをRustに伝える方法を学習しました。
すべての参照がどのように寿命を持っているかを見ましたが、ほとんどの場合、Rustは寿命を延ばすことができます。
ここではまだ説明していない寿命の3つの高度な機能を見ていきます。

* 寿命下位型化。ある寿命が他の寿命よりも長生きすることを保証する
* 有効期間。汎用型への参照の有効期間を指定します。
* 特性対象の寿命の推論。製譜器は特性対象の寿命を推測することができ、指定が必要な場合

### 1つの寿命が寿命の下位型でもう一方の生存を失うことを保証する

*寿命下位タイピング*は、ある寿命が別の寿命を生き延びるべきであることを指定します。
寿命下位型を調べるには、構文解析器ーを作成したいと考えてください。
解析している文字列への参照を保持する`Context`という構造体を使います。
この文字列を解析して成功または失敗を返す構文解析器ーを作成します。
構文解析器ーは、構文解析を行うために`Context`を借りる必要があります。
譜面リスト19-12はこの構文解析器ー・譜面を実装していますが、譜面には必要な有効期間の注釈がないため、製譜されません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
struct Context(&str);

struct Parser {
    context: &Context,
}

impl Parser {
    fn parse(&self) -> Result<(), &str> {
        Err(&self.context.0[1..])
    }
}
```

<span class="caption">リスト19-12。寿命補注を持たない構文解析器ーの定義</span>

誤りの譜面結果を製譜Rustは文字列のスライスに寿命パラメータを受け取るため`Context`とを参照する`Context`で`Parser`。

簡単にするために、`parse`機能は`Result<(), &str>`返します。
つまり、機能は成功すると何もせず、失敗した場合、正しく解析されなかった文字列スライスの部分を返します。
実際の実装では、より多くの誤り情報が提供され、解析に成功すると構造化データ型が返されます。
これらの詳細については、この例の寿命の一部には関係しないため、説明しません。

この譜面を単純にするために、解析論理を記述しません。
しかし、構文解析論理のどこかで、入力の無効な部分を参照する誤りを返すことで無効な入力を処理する可能性が非常に高いです。
この参照は、譜面例を寿命に関して面白くするものです。
最初のバイトの後に入力が無効であるということを構文解析器ーの論理から推測しましょう。
最初のバイトが有効な文字縛りにない場合、この譜面はパニックになる可能性があることに注意してください。
再び、関係する寿命に焦点を当てるために例を単純化しています。

この譜面を製譜するには、`Context` sliceスライスの有効期間パラメータと`Parser`の`Context`への参照を入力する必要があります。
これを行う最も簡単な方法は、リスト19-13に示すように、すべての寿命同じ名前を使用することです。
`struct Context<'a>`、 `struct Parser<'a>`、および`impl<'a>`が新しい寿命パラメータを宣言していることを第10章の「構造体定義における寿命の注釈」の章から思い出してください。
彼らの名前はすべて同じになりますが、この例で宣言された3つの有効期間パラメータは関連していません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
struct Context<'a>(&'a str);

struct Parser<'a> {
    context: &'a Context<'a>,
}

impl<'a> Parser<'a> {
    fn parse(&self) -> Result<(), &str> {
        Err(&self.context.0[1..])
    }
}
```

<span class="caption">リスト19-13。寿命パラメータを持つ<code>Context</code>と<code>Parser</code>すべての参照に注釈を付ける</span>

この譜面はうまく製譜されます。
それは、`Parser`が寿命`'a`を持つ`Context`への参照を保持し、その`Context`が、`Parser`の`Context`への参照と同じ長さの文字列スライスを保持していることをRustに伝えます。
Rustの製譜器誤りメッセージでは、これらの参照に寿命パラメータが必要であると述べ、寿命パラメータを追加しました。

次に、リスト19-14で、`Context`実例を`Context`、その文脈を解析するために`Parser`を使用し、`parse`が返すものを返す機能を追加します。
この譜面はうまく動作しません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
fn parse_context(context: Context) -> Result<(), &str> {
    Parser { context: &context }.parse()
}
```

<span class="caption">リスト19-14。 <code>Context</code>をとり、 <code>Parser</code>を使用する<code>parse_context</code>機能を追加しようとする試み</span>

`parse_context`機能を追加して譜面を製譜しようとすると、2つの冗長な誤りが発生します。

```text
error[E0597]: borrowed value does not live long enough
  --> src/lib.rs:14:5
   |
14 |     Parser { context: &context }.parse()
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ does not live long enough
15 | }
   | - temporary value only lives until here
   |
note: borrowed value must be valid for the anonymous lifetime #1 defined on the function body at 13:1...
  --> src/lib.rs:13:1
   |
13 |/fn parse_context(context: Context) -> Result<(), &str> {
14 | |     Parser { context: &context }.parse()
15 | | }
   | |_^

error[E0597]: `context` does not live long enough
  --> src/lib.rs:14:24
   |
14 |     Parser { context: &context }.parse()
   |                        ^^^^^^^ does not live long enough
15 | }
   | - borrowed value only lives until here
   |
note: borrowed value must be valid for the anonymous lifetime #1 defined on the function body at 13:1...
  --> src/lib.rs:13:1
   |
13 |/fn parse_context(context: Context) -> Result<(), &str> {
14 | |     Parser { context: &context }.parse()
15 | | }
   | |_^
```

これらの誤りは、作成された`Parser`実例と`context`パラメータは、`parse_context`機能が終了するまでのみ存在することを`parse_context`ます。
しかし、それらはその機能の寿命にわたって生きる必要があります。

言い換えれば、`Parser`および`context`、この譜面内のすべての参照が常に有効であるために、それが終了した後に機能が起動するだけでなく、前に全体の機能を*より長生き*して有効にする必要があります。
`parse_context`は`context`所有権を取るため、作成している`Parser`と`context`パラメータは、機能の最後で範囲外になり`context`。

これらの誤りが発生する理由を理解するために、リスト19-13の定義を再度見てみましょう。具体的には、`parse`操作法の型指示内の参照です。

```rust,ignore
    fn parse(&self) -> Result<(), &str> {
```

エリージョンルールを覚えていますか？　
参照の寿命に注釈を付けるのではなく、注釈を付けると、その署名は次のようになります。

```rust,ignore
    fn parse<'a>(&'a self) -> Result<(), &'a str> {
```

つまり、`parse`の戻り値の誤り部分は、`Parser`実例（`parse`操作法の型指示では`&self`）の存続期間に関連付けられた存続期間を持ちます。
それは理にかなっています。返された文字列スライスは、`Parser`保持する`Context`実例の文字列sliceを参照し、`Parser`構造体の定義は、`Context`への参照の有効期間と`Context`が保持する文字列スライスの有効期間を同じ。

問題は、`parse_context`機能が`parse`から返された値を返すことです。そのため、`parse_context`の戻り値の`parse_context`期間は、`Parser`の存続期間にも関連付けられます。
しかし、`parse_context`機能で作成された`Parser`実例は、機能の最後を過ぎても`parse_context`ません（一時的です）。機能の終わりに`context`が有効範囲から外れます（`parse_context`はその所有権を`parse_context`ます）。

Rustは、すべての生存時間に同じ寿命パラメータで注釈を付けたので、機能の終わりに範囲外になる値への参照を返そうとしていると考えています。
この注釈は、`Context`が保持する文字列スライスの有効期間は、`Parser`が保持する`Context`への参照の存続期間と同じであるとRustに語りました。

`parse_context`機能は、`parse`機能内で返される文字列sliceが`Context`および`Parser`よりも長くなり、参照`parse_context` returnsが`Context`または`Parser`ではなく文字列sliceを参照することを`parse_context`できません。

`parse`の実装が何をするかを知ることで、`parse`の戻り値が`Parser`実例に結びついている唯一の理由は、`Parser`実例の`Context`（文字列sliceを参照している）を参照しているということです。
したがって、実際には、`parse_context`が気にする必要がある文字列スライスの寿命です。
`Context`の文字列スライスと`Parser`の`Context`への参照には異なる寿命があり、`parse_context`の戻り値は`Context` stringスライスの存続時間に結びついているとRustに伝える必要があります。

まず、リスト19-15に示すように、`Parser`と`Context`異なる寿命パラメータを与えることを試みます。
`'s`と`'c`を寿命のパラメータ名として使用して、`Context`内の文字列スライスの存続期間と、`Parser` `Context`への参照となる寿命を明確にします。
このソリューションは問題を完全に解決するわけではありませんが、これが始まりです。
製譜しようとすると、なぜこの修正が十分でないのかを見ていきます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
struct Context<'s>(&'s str);

struct Parser<'c, 's> {
    context: &'c Context<'s>,
}

impl<'c, 's> Parser<'c, 's> {
    fn parse(&self) -> Result<(), &'s str> {
        Err(&self.context.0[1..])
    }
}

fn parse_context(context: Context) -> Result<(), &str> {
    Parser { context: &context }.parse()
}
```

<span class="caption">リスト19-15。文字列sliceと<code>Context</code>への参照のための異なる有効期間パラメータの指定</span>

リスト19-13で注釈したのと同じ場所に、参照の存続期間を注釈しました。
しかし、今回は参照が文字列スライスか`Context`かに応じて異なるパラメータを使用しました。
また、文字列スライス部分に、`parse`の戻り値の注釈を追加して、`Context`内の文字列スライスの存続期間に入ることを示しました。

今製譜しようとすると、次の誤りが発生します。

```text
error[E0491]: in type `&'c Context<'s>`, reference has a longer lifetime than the data it references
 --> src/lib.rs:4:5
  |
4 |     context: &'c Context<'s>,
  |     ^^^^^^^^^^^^^^^^^^^^^^^^
  |
note: the pointer is valid for the lifetime 'c as defined on the struct at 3:1
 --> src/lib.rs:3:1
  |
3 |/struct Parser<'c, 's> {
4 | |     context: &'c Context<'s>,
5 | | }
  | |_^
note: but the referenced data is only valid for the lifetime 's as defined on the struct at 3:1
 --> src/lib.rs:3:1
  |
3 |/struct Parser<'c, 's> {
4 | |     context: &'c Context<'s>,
5 | | }
  | |_^
```

Rustは`'c`と`'s`関係を知らない。
有効な、参照されるデータであるために`Context`寿命を持つ`'s`、それは長い寿命を持つ基準より存在していることを保証するように制限する必要が`'c`。
`'s`が`'c`より長くない場合は、`Context`への参照が有効でない可能性があります。

ここでは、この章のポイントについて説明します。Rust機能の*寿命下位型で*は、1つの有効期間パラメータが少なくとも別の有効期間パラメータと同じ長さであることが指定されています。
一生のパラメータを宣言角かっこでは、寿命を宣言することができます`'a`いつものように、寿命を宣言`'b`、少なくとも限り、住ん`'a`宣言することにより、`'b`の構文を使用して`'b: 'a`。

当社の定義では`Parser`、と言うこと`'s`（文字列スライスの寿命）は、少なくとも限り生きることが保証されて`'c`（参照の寿命`Context`）、このように見えるように寿命の宣言を変更します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# struct Context<'a>(&'a str);
#
struct Parser<'c, 's: 'c> {
    context: &'c Context<'s>,
}
```

今を参照する`Context`で`Parser`との文字列のスライスを参照する`Context`異なる寿命を有します。
文字列スライスの存続期間が`Context`への参照よりも長くなるようにしました。

それは非常に長年にわたる例でしたが、この章の冒頭で述べたように、Rustの高度な機能は非常に特殊です。
この例で説明した構文はしばしば必要ではありませんが、そのような状況では、何かを参照して必要な寿命を与える方法を知っています。

### 一般的な型への参照における永続的な縛り

第10章の「Trait Bounds」章では、総称型の特性縛りの使用について説明しました。
また、寿命パラメータを総称型の制約として追加することもできます。
これらは*寿命の縛り*と呼ばれ*ます*。
寿命の縛りは、Rustが総称型の参照が、参照しているデータよりも長く残らないことを確認します。

例として、参照の上にの包みである型を考えてみましょう。
思い出して`RefCell<T>` 「から型を`RefCell<T>`第15章及びインテリア可変性パターン」章。その`borrow`と`borrow_mut`方法は種類戻り`Ref`及び`RefMut`それぞれ。
これらの型は、実行時に借用ルールを追跡する参照の上のの包みです。
`Ref`構造体の定義は、リスト19-16に示されていますが、現在は寿命の縛りはありません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
struct Ref<'a, T>(&'a T);
```

<span class="caption">リスト19-16。寿命の縛りを持たない総称型への参照を包む構造体の定義</span>

明示的に総称化パラメータ`T`に関連して生存時間`'a`制約することなく、総称型`T`がどれくらい長く存続するかを知らないため、Rustは誤りになります。

```text
error[E0309]: the parameter type `T` may not live long enough
 --> src/lib.rs:1:19
  |
1 | struct Ref<'a, T>(&'a T);
  |                   ^^^^^^
  |
  = help: consider adding an explicit lifetime bound `T: 'a`...
note: ...so that the reference type `&'a T` does not outlive the data it points at
 --> src/lib.rs:1:19
  |
1 | struct Ref<'a, T>(&'a T);
  |                   ^^^^^^
```

`T`は任意の型であることができるので、`T`は参照または1つ以上の参照を保持する型であり、それぞれが独自の寿命を持つことができます。
Rustは、`T`が`'a`ように生き続けることを確信することはできません。

幸いにも、この誤りは、この場合に寿命を指定する方法に関する有用なアドバイスを提供します。

```text
consider adding an explicit lifetime bound `T: 'a` so that the reference type
`&'a T` does not outlive the data it points at
```

リスト19-17は、総称化・型`T`を宣言したときに存続時間を指定することによって、このアドバイスを適用する方法を示しています。

```rust
struct Ref<'a, T: 'a>(&'a T);
```

<span class="caption">リスト19-17。 <code>T</code>に寿命の縛りを追加して、 <code>T</code>内のすべての参照が少なくとも<code>'a</code></span>

この譜面は製譜されるようになりました。なぜなら、`T: 'a`構文では`T`は任意の型であることが指定されていますが、参照が含まれていれば、参照は少なくとも`'a`。

リスト19-18の`StaticRef`構造体の定義で示されているように、`T`束縛された`'static`有効期間を追加することで、この問題を別の方法で解決できます。
つまり、`T`に参照が含まれている場合は、`'static`有効期間が必要です。

```rust
struct StaticRef<T: 'static>(&'static T);
```

<span class="caption">リスト19-18。 <code>'static</code> <code>T</code>に束縛された<code>'static</code>有効期間を追加して、 <code>T</code>を<code>'static</code>参照のみを持つ型または参照を持たない型に制約する</span>

`'static`意味は、算譜全体の長さである必要があります。参照が含まれていない型は、参照番号がないため、すべての参照の基準を満たしています。
十分な長さの生存参照に関するボロー検査器については、参照を持たない型と、永遠に生存する参照を持つ型との間には実質的な区別はない。参照が何よりも寿命が短いかどうかを判定するために同じであるそれは参照してください。

### 特性対象の寿命の推論

第17章「異なる型の値を可能にする特性対象の使用」の項では、動的指名を使用できるようにする、参照の後ろの特性からなる特性対象について説明しました。
特性対象の特性を実装する型がそれ自身の存続期間を有する場合に、何が起こるかについてまだ議論していない。
リスト19-19を考えてみましょう。ここでは、特性`Red`と構造`Ball`ます。
`Ball`構造体は参照を保持する（したがって寿命パラメータを持つ）とともに、特性`Red`実装します。
特性対象`Box<Red>`として`Ball`実例を使用したいと考えています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
trait Red { }

struct Ball<'a> {
    diameter: &'a i32,
}

impl<'a> Red for Ball<'a> { }

fn main() {
    let num = 5;

    let obj = Box::new(Ball { diameter: &num }) as Box<Red>;
}
```

<span class="caption">リスト19-19。寿命対象と型対象を持つ型の使用</span>

この譜面は、`obj`関係する寿命に明示的に注釈を付けていないとしても、誤りなしで製譜されます。
この譜面は、寿命と特性対象を扱うためのルールがあるため機能します。

* 特性対象の黙用の有効期間は`'static`です。
* `&'a Trait` or `&'a mut Trait` traitを使うと、trait対象の黙用の有効期間は`'a`ます。
* 1つの`T: 'a`句では、trait対象の黙用の有効期間は`'a`です。
* `T: 'a`ような複数の句では、黙用の有効期間はありません。
   明示的でなければならない。

明示的にする必要がある場合、`Box<Red>`ようなTrait対象に生存時間を追加するには、`Box<Red + 'static>`または`Box<Red + 'a>`構文を使用します。か否か。
他の縛りと同様に、寿命の縛りを追加する構文は、その型の中の参照を持つ`Red`型の実装者は、それらの参照と同じ型の対象縛りで指定された同じ寿命を持たなければならないことを意味します。

次に、特性を管理するその他の高度な機能を見てみましょう。
