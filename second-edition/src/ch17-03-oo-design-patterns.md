## 対象指向設計パターンの実装

*状態パターン*は、対象指向の設計パターンです。
パターンの要点は、ある値にある内部状態があり、それが*状態対象の*集合で表され、その値の振る舞いは内部状態に基づいて変化するということです。
状態対象は機能を共有しています。もちろん、Rustでは対象や継承ではなく構造体と特性を使用します。
各状態対象は、自身の振る舞いと、それが別の状態に変わるべき時を管理する役割を担う。
状態対象を保持する値は、状態の異なる振る舞いや状態の遷移の時期については何も知らない。

状態パターンを使用するとは、算譜のビジネス要件が変わったときに、その状態を保持する値の譜面またはその値を使用する譜面を変更する必要はありません。
状態対象の1つの内部の譜面を更新してルールを変更するか、または状態対象を追加する必要があります。
状態の設計パターンの例と、それをRustで使用する方法を見てみましょう。

ブログ投稿のワークフローを段階的に実装します。
ブログの最終的な機能は次のようになります。

1. ブログ投稿は空のドラフトとして開始されます。
2. ドラフトが完了したら、投稿のレビューが要求されます。
3. 投稿が承認されると、公開されます。
4. 公開されたブログ投稿のみが内容を印字するので、承認されていない投稿を誤って公開することはできません。

投稿に加えられた他の変更は効果がありません。
たとえば、レビューをリクエストする前にブログ投稿の下書きを承認しようとすると、その投稿は未公開のまま残るはずです。

譜面リスト17-11に、このワークフローを譜面形式で示します。これは、譜集crateという名前の`blog`実装するAPIの使用例です。
まだ`blog`通い箱を実装していないので、これはまだ製譜されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate blog;
use blog::Post;

fn main() {
    let mut post = Post::new();

    post.add_text("I ate a salad for lunch today");
    assert_eq!("", post.content());

    post.request_review();
    assert_eq!("", post.content());

    post.approve();
    assert_eq!("I ate a salad for lunch today", post.content());
}
```

<span class="caption">リスト17-11。<code>blog</code>通い箱に必要な動作を示す譜面</span>

`Post::new`使ってブログ投稿の新しいドラフトを作成できるようにしたいと考えています。
次に、ドラフト状態にある間にブログ投稿にテキストを追加できるようにします。
投稿の内容をすぐに取得しようとすると、承認前に投稿がまだ草稿であるため、何も起こらないはずです。
デモンストレーションの目的で`assert_eq!`を譜面に追加しました。
このための優れた単体テストは、ブログ投稿のドラフトが`content`操作法から空の文字列を返すと主張することですが、この例ではテストを書くつもりはありません。

次に、ポストの見直しの要求を有効にしたい、としたい`content`審査を待っている間に空の文字列を返すこと。
投稿が承認されると、投稿が公開されるはずです。つまり、`content`呼び出し時に投稿のテキストが返されます。

通い箱からやり取りしている唯一の型は`Post`型です。
この型は状態パターンを使用し、投稿が草案中であるか、レビューを待っているか、公開されているかを示す3つの状態対象の1つになる値を保持します。
ある状態から別の状態への変更は、`Post`型で内部的に管理されます。
`Post`実例の譜集の利用者から呼び出された操作法に応答してステートが変更されますが、ステートの変更を直接管理する必要はありません。
また、利用者はレビューの前に投稿を公開するなど、州で間違いを犯すことはできません。

### `Post`定義とドラフト状態での新規実例の作成

譜集の実装を開始しましょう！　
リスト17-12に示すように、いくつかの内容を保持するpublic `Post`構造体が必要であることがわかっているので、構造体の定義と`Post`実例を作成する関連するpublic `new`機能から始めます。
また、私有の`State`特性を作ります。
その後、`Post`の特性対象保持する`Box<State>`内部で`Option`という名前の民間分野での`state`。
この`Option`がなぜ必要なのかが分かります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct Post {
    state: Option<Box<State>>,
    content: String,
}

impl Post {
    pub fn new() -> Post {
        Post {
            state: Some(Box::new(Draft {})),
            content: String::new(),
        }
    }
}

trait State {}

struct Draft {}

impl State for Draft {}
```

<span class="caption">定義。リスト17-12 <code>Post</code>構造体と<code>new</code>新しい作成機能<code>Post</code>実例を、 <code>State</code>特性、および<code>Draft</code>構造体を</span>

`State`特性は、異なる郵便州によって共有される振る舞いを定義し、`Draft`、 `PendingReview`、 `Published`州はすべて`State`特性を実装します。
今のところ、特性には方法がありません。`Draft`状態を定義することから始めることにします。これは、投稿を開始する状態であるためです。

新しい作成するときに`Post`、その設定され`state`に欄を`Some`保持している値`Box`。
この`Box`は`Draft`構造体の新しい実例を指し示します。
これにより、`Post`新しい実例を作成するたびに、ドラフトとして開始されます。
`Post`の`state`欄は内部用なので、他の状態で`Post`を作成する方法はありません！　
`Post::new`機能では、`content`欄を新しい空の`String`ます。

### 投稿内容のテキストの保存

リスト17-11は、`add_text`という名前の`add_text`を呼び出して、`&str`を渡してブログ記事のテキスト内容に追加したいということを示しています。
これを操作法として実装します。これは、`content`欄を`pub`として公開するのではなく、
つまり、`content`欄のデータの読み込み方法を制御する操作法を後で実装することができます。
`add_text`操作法はかなり簡単ですので、リスト17-13の実装を`impl Post`段落に追加しましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     content: String,
# }
#
impl Post {
#    // --snip--
    //  --snip--
    pub fn add_text(&mut self, text: &str) {
        self.content.push_str(text);
    }
}
```

<span class="caption">リスト17-13。投稿の<code>content</code>テキストを追加する<code>add_text</code>実装</span>

`add_text`を呼び出す`Post`実例を変更しているため、`add_text`操作法は`self`への変更可能な参照を取ります。
次に、`content`内の`String` `push_str`を呼び出し、`text`引数を渡して、保存された`content`に追加し`content`。
この動作は、投稿が入っている状態に依存しないため、状態パターンの一部ではありません。
`add_text`操作法は`state`欄と全くやり取りし`add_text`が、サポートしたい動作の一部です。

### ドラフト投稿の内容が空であることを確認する

呼ばれてきた後でも`add_text`と記事にいくつかの内容を追加して、まだしたい`content`リスト17-11の8行目に示すように、ポストは、ドラフト状態のままであるため、空の文字列のスライスを返すようにする方法を。
ここでは、`content`操作法を、この要件を満たす最も簡単なもので実装しましょう。常に空の文字列スライスを返します。
投稿の状態を変更して公開できるようにしたら、これを後で変更します。
これまでの投稿は下書きの状態にしかないので、投稿の内容は常に空でなければなりません。
リスト17-14は、この場所取りの実装を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     content: String,
# }
#
impl Post {
#    // --snip--
    //  --snip--
    pub fn content(&self) -> &str {
        ""
    }
}
```

<span class="caption">リスト17-14。 <code>Post</code>の<code>content</code>操作法の場所取り実装を追加すると、常に空の文字列スライスが返されます</span>

この`content`操作法を追加すると、リスト17-11の8行目までのすべてが意図した通りに機能します。

### 投稿の審査を要求するとその状態が変わる

次に、ポストのレビューをリクエストするための機能を追加する必要があります。ポストの状態を`Draft`から`PendingReview`変更する必要があります。
リスト17-15にこの譜面を示します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     state: Option<Box<State>>,
#     content: String,
# }
#
impl Post {
#    // --snip--
    //  --snip--
    pub fn request_review(&mut self) {
        if let Some(s) = self.state.take() {
            self.state = Some(s.request_review())
        }
    }
}

trait State {
    fn request_review(self: Box<Self>) -> Box<State>;
}

struct Draft {}

impl State for Draft {
    fn request_review(self: Box<Self>) -> Box<State> {
        Box::new(PendingReview {})
    }
}

struct PendingReview {}

impl State for PendingReview {
    fn request_review(self: Box<Self>) -> Box<State> {
        self
    }
}
```

<span class="caption">リスト17-15。 <code>Post</code>と<code>State</code>特性に対する<code>request_review</code>操作法の実装</span>

`Post` `request_review`という公開操作法を与えます。公開操作法は`self`への参照を変更します。
次に、`Post`の現在の状態について内部`request_review`操作法を呼び出します。この2番目の`request_review`操作法は現在の状態を消費し、新しい状態を返します。

`State`特性に`request_review`操作法を追加しました。
特性を実装するすべての型は、`request_review`操作法を実装する必要があります。
操作法の最初のパラメータとして`self`、 `&self`、または`&mut self`を持つのではなく、`self: Box<Self>`を持つことに注意してください。
この構文は、その型を保持する`Box`上で呼び出されたときにのみ操作法が有効であることを意味します。
この構文は、`Box<Self>`所有権を取り、古い状態を無効にして、`Post`状態値が新しい状態に変換できるようにします。

古い状態を消費するには、`request_review`操作法が状態値の所有権を取得する必要があります。
これはどこにある`Option`で`state`の欄`Post`に来る。呼んで`take`取る方法を`Some`の外の値を`state`欄と残さない`None`Rustは構造体で未実装の欄を持って聞かせていないため、その場所に。
これにより、`state`値を借用するのではなく、`Post`から移動することができます。
次に、この操作の結果にポストの`state`値を設定します。

`self.state = self.state.request_review();`ような譜面で直接設定するのではなく、`state`を`None`一時的に設定する必要があり`self.state = self.state.request_review();`
`state`値の所有権を取得します。
これにより、`Post`は新しい状態に変換した後に古い`state`値を使用できなくなります。

`Draft`の`request_review`操作法は、新しい`PendingReview`構造体の新しいボックス化された実例を返す必要があります。これは、投稿がレビューを待っているときの状態を表します。
`PendingReview`構造体も`request_review`操作法を実装し`request_review`が、変換は一切行いません。
すでにポストに審査を要求したときのでむしろ、それは、自分自身を返し`PendingReview`状態、それが中にとどまるべき`PendingReview`状態。

今、状態パターンの利点を見始めることができます。`request_review`上の操作法`Post`関係なく、その同じではない`state`値です。
各州はそれぞれ独自のルールを担当しています。

`content`操作法を`Post`ままにして、空の文字列スライスを返します。
今持っていることができます`Post`に`PendingReview`状態などで`Draft`状態が、中に同じ動作たい`PendingReview`状態を。
リスト17-11は現在11行目まで動作します！　

### `content`の動作を変更`approve`操作法の追加

`approve`操作法は`request_review`操作法に似てい`request_review`。リスト17-16に示すように、現在の状態がその状態が承認されたときに持つべき値を`state`に設定します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     state: Option<Box<State>>,
#     content: String,
# }
#
impl Post {
#    // --snip--
    //  --snip--
    pub fn approve(&mut self) {
        if let Some(s) = self.state.take() {
            self.state = Some(s.approve())
        }
    }
}

trait State {
    fn request_review(self: Box<Self>) -> Box<State>;
    fn approve(self: Box<Self>) -> Box<State>;
}

struct Draft {}

impl State for Draft {
#     fn request_review(self: Box<Self>) -> Box<State> {
#         Box::new(PendingReview {})
#     }
#
#    // --snip--
    //  --snip--
    fn approve(self: Box<Self>) -> Box<State> {
        self
    }
}

struct PendingReview {}

impl State for PendingReview {
#     fn request_review(self: Box<Self>) -> Box<State> {
#         self
#     }
#
#    // --snip--
    //  --snip--
    fn approve(self: Box<Self>) -> Box<State> {
        Box::new(Published {})
    }
}

struct Published {}

impl State for Published {
    fn request_review(self: Box<Self>) -> Box<State> {
        self
    }

    fn approve(self: Box<Self>) -> Box<State> {
        self
    }
}
```

<span class="caption">リスト17-16。 <code>Post</code>と<code>State</code>特性に対する<code>approve</code>操作法の実装</span>

追加`approve`に操作法を`State`特性と実装する新しい構造体追加`State`、 `Published`状態を。

`request_review`と同様に、`Draft`で`approve`操作法を呼び出すと、`self`を返すため、何も効果がありません。
呼び出すと`approve`に`PendingReview`、それは新しい、通い箱入り実例を返し`Published`構造体を。
`Published`構造体は`State`特性を実装し、`request_review`操作法と`approve`操作法の両方で、ポストはそのような場合に`Published`状態を維持する必要があるため、自身を返します。

ここで、`Post`の`content`操作法を更新する必要があります。状態が`Published`の場合は、投稿の`content`欄に値を返します。
それ以外の場合は、リスト17-17に示すように空の文字列スライスを返します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# trait State {
#     fn content<'a>(&self, post: &'a Post) -> &'a str;
# }
# pub struct Post {
#     state: Option<Box<State>>,
#     content: String,
# }
#
impl Post {
#    // --snip--
    //  --snip--
    pub fn content(&self) -> &str {
        self.state.as_ref().unwrap().content(&self)
    }
#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト17-17。更新<code>content</code>に操作法を<code>Post</code>に委任する<code>content</code>の操作法<code>State</code></span>

目的は`State`を実装する構造体の中にこれらのルールをすべて保持することですので、`state`の値に対して`content`操作法を呼び出し、ポスト実例（つまり`self`）を引数として渡します。
次に、`content`操作法を使って返された値を`state`値に返します。

`Option` `as_ref`操作法は、値の所有権ではなく、`Option`中の値への参照を必要とするため、`Option`呼び出しを行います。
`state`は`Option<Box<State>>` `as_ref`、 `as_ref`を呼び出すと、`Option<&Box<State>>`が返されます。
`as_ref`を呼び出さなかった場合、機能パラメータの借用された`&self`から`state`移動できないため、誤りが発生します。

`Post`の操作法が`state`が常にそれらの操作法が完了したときに`Some`値を含むことを保証していることを知っているので、`unwrap`操作法を呼び出します。
これは、たとえ製譜器がそれを理解できないとしても、`None`値が決して不可能であることがわかっているときに、第9章の「製譜器より多くの情報がある場合のケース」の章で述べたケースの1つです。

この時点で、呼ぶとき`content`の`&Box<State>`、DEREF強制型変換は上有効になります`&`および`Box`ので、`content`方法は、最終的に実装する型で呼び出される`State`特性を。
これは、`State`特性定義に`content`を追加する必要があることを意味します。リスト17-18に示すように、状態に応じて内容を返す論理を配置します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     content: String
# }
trait State {
#    // --snip--
    //  --snip--
    fn content<'a>(&self, post: &'a Post) -> &'a str {
        ""
    }
}

#// --snip--
//  --snip--
struct Published {}

impl State for Published {
#    // --snip--
    //  --snip--
    fn content<'a>(&self, post: &'a Post) -> &'a str {
        &post.content
    }
}
```

<span class="caption">リスト17-18。 <code>State</code>操作法への<code>content</code>操作法の追加</span>

空の文字列スライスを返す`content`操作法の既定の実装を追加します。
つまり、`Draft`および`PendingReview`構造体に`content`を実装`content`必要はありません。
`Published`構造体は`content`操作法を上書きし、`post.content`の値を`post.content`ます。

第10章で説明したように、この操作法では寿命補注が必要であることに注意してください。引数として`post`を参照し、その`post`一部への参照を返すので、返される参照の存続期間は`post`議論の寿命。

これで完了です。リスト17-11のすべてが現在機能しています！　
ブログポストワークフローのルールで州のパターンを実装しました。
ルールに関連する論理は、`Post`全体に散在するのではなく、状態対象に存在します。

### 状態パターンの相殺取引

Rustは、対象指向の状態パターンを実装して、各状態で投稿が持つべきさまざまな種類の動作をカプセル化できることを示しました。
`Post`の操作法は、さまざまな動作について何も知らない。
実装。譜面を整理方法は、公表ポストが振る舞うことができるさまざまな方法を知るための唯一の場所で見ている`State`での特性`Published`構造体を。

状態パターンを使用しない代替実装を作成する場合は、`Post`の操作法で`match`式を使用するか、`main`譜面内で`match`式を使用して、ポストの状態をチェックし、それらの場所の動作を変更することがあります。
それは、出版された州での投稿の意味を理解するためには、いくつかの場所を見る必要があるということです。
これにより、追加した状態が増えるだけです。それぞれの`match`式に別の腕が必要です。

状態パターンでは、`Post`操作法と`Post`が使用する場所は`match`式を必要`match`せず、新しい状態を追加するために、新しい構造体を追加し、その構造体にtrait操作法を実装するだけで済みます。

状態パターンを使用した実装は、機能を追加するために拡張が容易です。
状態パターンを使用する譜面のメンテナンスの簡素化を確認するには、次のようないくつかの提案を試してください。

* 投稿の状態を`PendingReview`から`Draft`戻す`reject`操作法を追加します。
* 状態を[ `Published`に変更`approve`には、`approve`するために2回の呼び出しが必要です。
* 投稿が`Draft`状態の場合にのみ、テキスト内容を追加できるようにします。
   ヒント。状態対象は内容について何が変わる可能性があるのか​​責任を負いませんが、`Post`を変更する責任はありません。

状態パターンの1つの欠点は、状態が状態間の遷移を実装するので、状態のいくつかは互いに結合されることであます。
間、別の状態を追加する場合`PendingReview`や`Published`など、`Scheduled`、中に譜面を変更する必要があります`PendingReview`への移行を`Scheduled`代わりに。
`PendingReview`が新しい状態の追加で変更する必要はないが、それは別の設計パターンに切り替えることを意味します。

もう一つの欠点は、いくつかの論理を複製したことです。
重複のいくつかを排除するために、`request_review`黙用の実装を行い、`self`を返す`State`操作法を`approve`しようとします。
しかし、これは、対象の安全性に違反します。なぜなら、その特性は、具体的な`self`が正確に何であるかを知らないからです。
`State`を特性対象として使用できるようにするためには、その操作法が対象化安全である必要があります。

他の複製には、`Post` `request_review`操作法と`approve`操作法の同様の実装が含まれます。
両方の方法は、の値に同じ操作法の実装に委任`state`の欄`Option`との新たな値に設定`state`結果に欄を。
`Post`でこのパターンに従った操作法がたくさんある場合は、マクロを定義してその繰り返しを排除することを検討することもできます（マクロの詳細は付録Dを参照してください）。

対象指向言語用に定義されているように状態パターンを正確に実装することで、Rustの強みを十分に活用することはできません。
無効な状態や製譜時の誤りへの移行を引き起こす可能性のある`blog`ボックスに加えることができるいくつかの変更を見てみましょう。

#### 型としての状態と振る舞いの符号化

状態パターンを再考して、異なる相殺取引を得る方法を導入します。
ステートとトランジションを完全にカプセル化するのではなく、外部の譜面がそれらを認識していないので、ステートを異なる型に符号化します。
したがって、Rustの型チェック算系は、製譜誤りを出すことによって、公開された投稿のみが許可されている下書き投稿を使用しようとする試みを防ぎます。

リスト17-11の`main`の最初の部分について考えてみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let mut post = Post::new();

    post.add_text("I ate a salad for lunch today");
    assert_eq!("", post.content());
}
```

`Post::new`と投稿の内容にテキストを追加する機能を使用して、ドラフト状態で新しい投稿を作成できるようにします。
しかし、空の文字列を返すドラフトポストに`content`操作法を持たせる代わりに、ドラフト投稿に`content`操作法がまったくないようにします。
そうすれば、草稿の内容を取得しようとすると、操作法が存在しないことを示す製譜器誤りが発生します。
その結果、譜面が製譜されなくなるため、偶発的に草稿内容を本番で表示することは不可能になります。
リスト17-19に、`Post`構造体と`DraftPost`構造体の定義と、それぞれの操作法を示します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct Post {
    content: String,
}

pub struct DraftPost {
    content: String,
}

impl Post {
    pub fn new() -> DraftPost {
        DraftPost {
            content: String::new(),
        }
    }

    pub fn content(&self) -> &str {
        &self.content
    }
}

impl DraftPost {
    pub fn add_text(&mut self, text: &str) {
        self.content.push_str(text);
    }
}
```

<span class="caption">リスト17-19。 <code>content</code>操作法と<code>DraftPost</code>持たず、 <code>content</code>操作法を持たない<code>Post</code></span>

`Post`および`DraftPost`構造体には、ブログ投稿テキストを格納する内部用`content`欄があります。
構造体は、`state`の符号化を構造体の型に移しているので、もはや`state`欄を持ちません。
`Post`構造体には、公開の投稿を表します、そしてそれが持っている`content`を返す操作法`content`。

まだ持っている`Post::new`機能を、代わりの実例を返すの`Post`、それがの実例を返し`DraftPost`。
`content`は内部用であり、`Post`を返す機能はないので、今すぐ`Post`実例を作成することはできません。

`DraftPost`構造体には`add_text`操作法があるので、以前と同じように`content`にテキストを追加できますが、`DraftPost`は`content`操作法が定義されていないことに注意してください。
今では、すべての投稿が草稿として開始され、ドラフト投稿には表示可能な内容がありません。
これらの制約を回避しようとすると、製譜器ー・誤りが発生します。

#### 異なる型への変換としてのトランジションの実装

では、どのように公開された投稿を入手するのでしょうか？　
草案草案を公表する前にレビューと承認を行わなければならないという規則を施行したいと考えています。
保留中のレビュー状態の投稿にはまだ内容が表示されません。
のは、別の構造体を追加することによって、これらの制約を実装してみましょう`PendingReviewPost`、定義`request_review`上の方法を`DraftPost`返すように`PendingReviewPost`、と定義する`approve`の操作法を`PendingReviewPost`返すために`Post`リスト17-20で示されるように、。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct Post {
#     content: String,
# }
#
# pub struct DraftPost {
#     content: String,
# }
#
impl DraftPost {
#    // --snip--
    //  --snip--

    pub fn request_review(self) -> PendingReviewPost {
        PendingReviewPost {
            content: self.content,
        }
    }
}

pub struct PendingReviewPost {
    content: String,
}

impl PendingReviewPost {
    pub fn approve(self) -> Post {
        Post {
            content: self.content,
        }
    }
}
```

<span class="caption">リスト17-20。 <code>PendingReviewPost</code>呼び出すことによって作成される<code>request_review</code>上<code>DraftPost</code>し、 <code>approve</code>変わる方法<code>PendingReviewPost</code>公表へ<code>Post</code></span>

`request_review`操作法と`approve`操作法は`self`所有権を取得し、`DraftPost`実例と`PendingReviewPost`実例を消費し、それらをそれぞれ`PendingReviewPost`と公開された`Post`に変換します。
このように、`request_review`を呼び出した後に、残っている`DraftPost`実例を保持しません。
`PendingReviewPost`構造体には`content`操作法が定義されていないため、`content`を読み取ろうとすると、`DraftPost`ように製譜器ー・誤りが発生します。
公表され得る唯一の方法なので`Post`持っている実例`content`定義された操作法を呼び出すことで`approve`の方法`PendingReviewPost`、および取得する唯一の方法`PendingReviewPost`呼び出すことです`request_review`上の方法を`DraftPost`今符号化されてきました、ブログは型算系へのワークフローをポストします。

しかし、また、`main`いくつかの小さな変更を加える必要があります。
`request_review`操作法と`approve`操作法は、呼び出された構造体を変更するのではなく、新しい実例を返します。したがって、返された実例を保存するために、`let post =` shadowing代入を追加する必要があります。
ドラフトや保留中のレビューポストの内容が空の文字列である必要はなく、それらの状態のポストの内容を使用しようとする譜面を製譜することはできません。
リスト17-21に、`main`の更新された譜面を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate blog;
use blog::Post;

fn main() {
    let mut post = Post::new();

    post.add_text("I ate a salad for lunch today");

    let post = post.request_review();

    let post = post.approve();

    assert_eq!("I ate a salad for lunch today", post.content());
}
```

<span class="caption">リスト17-21。blog post workflowの新しい実装を使用する<code>main</code>への変更</span>

`post`を再割り当てするために`main`に変更する必要があったのは、この実装が対象指向の状態パターンに従わなくなったことです。つまり、状態間の変換は`Post`実装内に完全にカプセル化されなくなりました。
しかし、利益は、型算系と製譜時に発生する型チェックのために無効な状態が不可能になったことです！　
これにより、未発表の投稿の内容を表示するなどの特定のバグが発見されてから運用されるようになります。

この章の最初に言及した追加要件のために提案された仕事試し`blog`、それはあなたがこの譜面の版の設計について考えるものを見るためにリスト17-20の後にあるよう通い箱を。
この設計では、仕事のいくつかがすでに完了している可能性があることに注意してください。

Rustは対象指向の設計パターンを実装することができますが、型算系に状態を​​符号化するなどの他のパタ​​ーンもRustで利用可能です。
これらのパターンには異なる相殺取引があります。
対象指向のパターンに精通しているかもしれませんが、Rustの機能を利用するために問題を再考すると、製譜時にいくつかのバグを防ぐなどの利点があります。
対象指向のパターンは、対象指向言語にはない所有権などの特定の機能のために、常にRustの最良の解決策ではありません。

## 概要

この章を読んだあと、Rustが対象指向言語であると考えるかどうかに関わらず、Rustでは特性対象を使用して対象指向の機能を利用できることが分かりました。
動的指名は、少しの実行時パフォーマンスと引き換えに譜面に柔軟性を与えます。
この柔軟性を使用して、譜面の保守性に役立つ対象指向のパターンを実装できます。
Rustには、対象指向言語にはない所有権のような他の機能もあります。
対象指向のパターンは、Rustの強みを利用する最良の方法ではありませんが、利用可能な選択肢です。

次に、パターンを見ていきます。パターンは、柔軟性を可能にするRustの特徴の1つです。
本の中でそれらを簡単に見てきましたが、まだ完全な能力を見ていませんでした。
行こう！　
