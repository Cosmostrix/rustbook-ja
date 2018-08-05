## 構造体を使用したサンプル<ruby>算譜<rt>プログラム</rt></ruby>

構造体をいつ使用するのかを理解するために、四角形の面積を計算する<ruby>算譜<rt>プログラム</rt></ruby>を作成してみましょう。
単一の変数から始めて、代わりに構造体を使用するまで<ruby>算譜<rt>プログラム</rt></ruby>をリファクタリングします。

カーゴは、ピクセル単位で指定された長方形の幅と高さを取ると、長方形の面積を計算します*長方形を*呼ばれるとのは、新しい<ruby>二進譜<rt>バイナリ</rt></ruby>企画を作ってみましょう。
リスト5-8は、企画の*src/main.rsに*ある短い<ruby>算譜<rt>プログラム</rt></ruby>を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let width1 = 30;
    let height1 = 50;

    println!(
        "The area of the rectangle is {} square pixels.",
        area(width1, height1)
    );
}

fn area(width: u32, height: u32) -> u32 {
    width * height
}
```

<span class="caption">リスト5-8。別々の幅と高さの変数で指定された長方形の面積を計算する</span>

今度は、この<ruby>算譜<rt>プログラム</rt></ruby>を`cargo run`を使って`cargo run`ください。

```text
The area of the rectangle is 1500 square pixels.
```

リスト5-8が機能し、各次元で`area`機能を呼び出すことによって長方形の`area`計算しても、より良い結果が得られます。
幅と高さは、それらが一緒に1つの長方形を記述しているため、互いに関連しています。

この<ruby>譜面<rt>コード</rt></ruby>の問題は、`area`の署名で明らかです。

```rust,ignore
fn area(width: u32, height: u32) -> u32 {
```

`area`機能は1つの長方形の面積を計算することになっていますが、書いた機能は2つのパラメータを持っています。
パラメータは関連していますが、<ruby>算譜<rt>プログラム</rt></ruby>のどこにも表示されません。
幅と高さをグループ化すると、読みやすく、管理しやすくなります。
第3章の「組型」の項で組を使用してこれを行う方法の1つについて既に説明しました。

### 組によるリファクタリング

リスト5-9に、組を使用する別の版の<ruby>算譜<rt>プログラム</rt></ruby>を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let rect1 = (30, 50);

    println!(
        "The area of the rectangle is {} square pixels.",
        area(rect1)
    );
}

fn area(dimensions: (u32, u32)) -> u32 {
    dimensions.0 * dimensions.1
}
```

<span class="caption">リスト5-9。組で長方形の幅と高さを指定する</span>

一つの方法では、この<ruby>算譜<rt>プログラム</rt></ruby>はより良いです。
組は構造体を少し追加しましたが、今では引数を1つだけ渡しています。
しかし、別の方法では、この版はあまり明確ではありません。組はその要素の名前を指定しないので、組の部分に<ruby>添字<rt>インデックス</rt></ruby>を付ける必要があるため、計算が複雑になります。

面積計算に幅と高さを混ぜても問題はありませんが、画面上に長方形を描きたい場合は問題になります。
`width`は組<ruby>添字<rt>インデックス</rt></ruby>`0`、 `height`は組<ruby>添字<rt>インデックス</rt></ruby>`1`です。
他の誰かがこの<ruby>譜面<rt>コード</rt></ruby>で作業した場合、これを把握しておく必要があります。
これらの値を忘れたり、混乱させたり、<ruby>誤り<rt>エラー</rt></ruby>を引き起こしたりするのは簡単でしょう。<ruby>譜面<rt>コード</rt></ruby>の中でデータの意味を伝えていないからです。

### 構造体によるリファクタリング。意味の追加

構造体を使用して、データにラベルを付けることによって意味を追加します。
リスト5-10に示すように、使用している組を、パーツの名前と名前の両方を持つデータ型に変換することができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!(
        "The area of the rectangle is {} square pixels.",
        area(&rect1)
    );
}

fn area(rectangle: &Rectangle) -> u32 {
    rectangle.width * rectangle.height
}
```

<span class="caption">リスト5-10。 <code>Rectangle</code>構造体の定義</span>

ここでは、構造体を定義して`Rectangle`という名前を付けました。
中かっこの中では、<ruby>欄<rt>フィールド</rt></ruby>の`width`と`height`を定義しました。どちらも`u32`型です。
次に、`main`では幅30と高さ50の特定の`Rectangle`<ruby>実例<rt>インスタンス</rt></ruby>を作成しました。

`area`機能は、`rectangle`という名前の1つのパラメータで定義されています。その型は、struct `Rectangle`<ruby>実例<rt>インスタンス</rt></ruby>の不変の借用です。
第4章で述べたように、構造体の所有権を取るのではなく、構造体を借りたいと考えています。
こうすることで、`main`は所有権を保持し、`rect1`を使用し続けることができ`rect1`。これは、関数型注釈で`&`を使用し、機能を呼び出す理由です。

`area`機能は、`Rectangle`<ruby>実例<rt>インスタンス</rt></ruby>の`width`および`height`<ruby>欄<rt>フィールド</rt></ruby>にアクセスします。
`area`関数型注釈は、正確には次のようになります。`width`と`height`<ruby>欄<rt>フィールド</rt></ruby>を使用して`Rectangle`の面積を計算します。
これは、幅と高さが互いに関連していることを伝え、`0`と`1`組<ruby>添字<rt>インデックス</rt></ruby>値を使用するのではなく、値にわかりやすい名前を付けます。
これは分かりやすくするための勝利です。

### 導出した<ruby>特性<rt>トレイト</rt></ruby>に便利な機能を追加する

<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>虫取り<rt>デバッグ</rt></ruby>している間に、`Rectangle`<ruby>実例<rt>インスタンス</rt></ruby>を<ruby>印字<rt>プリント</rt></ruby>して、すべての<ruby>欄<rt>フィールド</rt></ruby>の値を見ることができればいいと思います。
リスト5-11は、前の章で使ったように`println!`マクロを使って試行しています。
しかし、これはうまくいきません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {}", rect1);
}
```

<span class="caption">リスト5-11。 <code>Rectangle</code>実例を<ruby>印字<rt>プリント</rt></ruby>しようとしています</span>

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、このコアメッセージに<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0277]: the trait bound `Rectangle: std::fmt::Display` is not satisfied
```

`println!`マクロは多くの種類の書式設定を行うことができ、自動的には、中かっこは`println!`に、`Display`。出力と呼ばれる書式を使用するように指示します。
これまでに実装見てきた基本型`Display`表示したいと思います唯一の方法がありますので、自動的には`1`利用者またはその他の基本型が。
しかし、構造体では、`println!`が出力を形式する方法は、より多くの表示可能性があるためあまり明確ではありません。カンマを使用するかどうかを指定しますか？　
中かっこを<ruby>印字<rt>プリント</rt></ruby>しますか？　
すべての<ruby>欄<rt>フィールド</rt></ruby>を表示する必要がありますか？　
このあいまいさのために、Rustは望むものを推測しようとせず、構造体には`Display`実装が提供されていません。

引き続き<ruby>誤り<rt>エラー</rt></ruby>を読んでいれば、この有益なメモを見つけることができます。

```text
`Rectangle` cannot be formatted with the default formatter; try using
`:?` instead if you are using a format string
```

試してみよう！　
`println!`マクロ呼び出しは、`println!("rect1 is {:?}", rect1);`
。
指定子を置く`:?`
中かっこの中には`println!`、 `Debug`という出力形式を使用したいと考えています。
`Debug`<ruby>特性<rt>トレイト</rt></ruby>は、開発者にとって有用な方法で構造体を<ruby>印字<rt>プリント</rt></ruby>することができるので、<ruby>譜面<rt>コード</rt></ruby>を<ruby>虫取り<rt>デバッグ</rt></ruby>する際にその価値を確認できます。

この変更で<ruby>譜面<rt>コード</rt></ruby>を実行します。
Drat！　
まだ<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0277]: the trait bound `Rectangle: std::fmt::Debug` is not satisfied
```

しかし、やはり<ruby>製譜器<rt>コンパイラー</rt></ruby>は私たちに役立つメモを与えます。

```text
`Rectangle` cannot be formatted using `:?`; if it is defined in your
crate, add `#[derive(Debug)]` or manually implement it
```

Rustに*は*<ruby>虫取り<rt>デバッグ</rt></ruby>情報を出力する機能*が*含まれていますが、構造体にその機能を利用できるように明示的にオプトインする必要があります。
そうするために、リスト5-12に示すように、構造体定義の直前に<ruby>注釈<rt>コメント</rt></ruby>`#[derive(Debug)]`を追加します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {:?}", rect1);
}
```

<span class="caption">リスト5-12。<ruby>補注<rt>アノテーション</rt></ruby>を追加して<code>Debug</code>特性を導出し、<ruby>虫取り<rt>デバッグ</rt></ruby>書式を使用して<code>Rectangle</code>実例を<ruby>印字<rt>プリント</rt></ruby>する</span>

ここで<ruby>算譜<rt>プログラム</rt></ruby>を実行すると、<ruby>誤り<rt>エラー</rt></ruby>は発生せず、次の出力が表示されます。

```text
rect1 is Rectangle { width: 30, height: 50 }
```

ナイス！　
これはもっともきれいな出力ではありませんが、この<ruby>実例<rt>インスタンス</rt></ruby>のすべての<ruby>欄<rt>フィールド</rt></ruby>の値を表示します。これは、<ruby>虫取り<rt>デバッグ</rt></ruby>時には間違いなく役立ちます。
より大きな構造体がある場合、読みやすいように出力するのが便利です。
そのような場合は、`println!`<ruby>文字列<rt>ストリング</rt></ruby>の`{:?}`代わりに`{:?}` `{:#?}`使用できます。
この例で`{:#?}`作法を使用すると、出力は次のようになります。

```text
rect1 is Rectangle {
    width: 30,
    height: 50
}
```

一緒に使用するためにRustが特徴の数を提供してきました`derive`当社の独自の型に便利な動作を追加することができます<ruby>注釈<rt>コメント</rt></ruby>。
これらの<ruby>特性<rt>トレイト</rt></ruby>とその振る舞いについては、付録Cを参照してください。これらの<ruby>特性<rt>トレイト</rt></ruby>を独自の動作で実装する方法と、第10章で独自の<ruby>特性<rt>トレイト</rt></ruby>を作成する方法について説明します。

`area`機能は非常に特殊です。それは長方形の領域だけを計算します。
この振る舞いを`Rectangle`構造体にもっと密接に結びつけることは、他の型では機能しないので便利です。
`area`機能を`Rectangle`型で定義された`area` *<ruby>操作法<rt>メソッド</rt></ruby>に*変換することによって、この<ruby>譜面<rt>コード</rt></ruby>をどのようにリファクタリングすることができるかを見てみましょう。
