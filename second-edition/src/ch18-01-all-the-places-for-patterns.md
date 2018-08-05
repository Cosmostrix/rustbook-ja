## すべてのプレイスパターンを使用できます

パターンはRustのいくつかの場所にポップアップし、あなたはそれを実現せずにたくさん使っています！　
この章では、パターンが有効なすべての場所について説明します。

### `match`分岐

第6章で説明したように、`match`式の分岐にパターンを使用します。
形式的には、`match`式は予約語`match`、 `match`する値、パターンとその値がその分岐のパターンと一致する場合に実行される式からなる1つ以上の一致分岐として定義されます。

```text
match VALUE {
    PATTERN => EXPRESSION,
    PATTERN => EXPRESSION,
    PATTERN => EXPRESSION,
}
```

`match`式の要件の1つは、`match`式の値のすべての可能性が考慮されなければならないという意味で*網羅的*である必要があるということです。
すべての可能性をカバーするための1つの方法は、最後の分岐のための<ruby>捕捉<rt>キャッチ</rt></ruby>オールパターンを作ることです。例えば、値にマッチする変数名が失敗することはなく、残りのすべてのケースをカバーします。

特定のパターン`_`は何でも一致しますが、決して変数に束縛されないので、最終的なマッチ・分岐でよく使われます。
`_`パターンは、たとえば、指定されていない値を無視する場合に便利です。
`_`パターンについては、この章の「パターン内の値を無視する」の章で詳しく説明します。

### 条件式`if let`

第6章では、使用方法を検討し`if let`、主の同等書くための短い方法として、式を`match`一つだけの場合に一致します。
必要に応じて、`if let`のパターンが一致しない`if let`対応する`else`<ruby>譜面<rt>コード</rt></ruby>を含む<ruby>譜面<rt>コード</rt></ruby>を実行`if let`ことができます。

リスト18-1は、`if let`、 `else if`、 `else if let`式を混在`if let`ことも可能であることを示しています。
そうすることで、パターンと比較する値を1つしか表現できない`match`式よりも柔軟性が向上します。
また、一連の`if let`、 `else if`、 `else if let`の条件は、互いに関連する必要はありません。

リスト18-1の<ruby>譜面<rt>コード</rt></ruby>は、背景色を決定するいくつかの条件のチェックを示しています。
この例では、実際の<ruby>算譜<rt>プログラム</rt></ruby>が利用者入力から受け取る可能性のあるハード<ruby>譜面<rt>コード</rt></ruby>された値を持つ変数を作成しました。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let favorite_color: Option<&str> = None;
    let is_tuesday = false;
    let age: Result<u8, _> = "34".parse();

    if let Some(color) = favorite_color {
        println!("Using your favorite color, {}, as the background", color);
    } else if is_tuesday {
        println!("Tuesday is green day!");
    } else if let Ok(age) = age {
        if age > 30 {
            println!("Using purple as the background color");
        } else {
            println!("Using orange as the background color");
        }
    } else {
        println!("Using blue as the background color");
    }
}
```

<span class="caption">リスト18-1。 <code>if let</code>混合、 <code>else if</code>は<code>else if let</code> <code>else if</code>は<code>else if let</code> 、 <code>else</code></span>

利用者が好きな色を指定すると、その色が背景色になります。
今日が火曜日の場合、背景色は緑色です。
利用者が年齢を<ruby>文字列<rt>ストリング</rt></ruby>として指定し、数値として正常に解析できる場合、数値は数値の値によって紫色またはオレンジ色になります。
これらの条件のいずれも該当しない場合、背景色は青です。

この条件付き構造は複雑な要件をサポートします。
ここではハード<ruby>譜面<rt>コード</rt></ruby>された値を使用して、この例では`Using purple as the background color`<ruby>印字<rt>プリント</rt></ruby>`Using purple as the background color`ます。

`if let`が、`match`武器と同じ方法で遮蔽変数を導入できる`if let Ok(age) = age`の行は、`Ok`変形の中の値を含む新しい遮蔽化された`age`変数を導入します。
これは、その<ruby>段落<rt>ブロック</rt></ruby>内に`if age > 30`条件を配置する必要があることを意味します。つまり、これらの2つの条件を組み合わせて`if let Ok(age) = age && age > 30`することはできません。
新しい<ruby>有効範囲<rt>スコープ</rt></ruby>が中かっこで始まるまで、30と比較するシャドー`age`は有効ではありません。

`if let`式を使うことの欠点は、<ruby>製譜器<rt>コンパイラー</rt></ruby>が完全性をチェックするのではなく、`match`式を使うことです。
最後の`else`<ruby>段落<rt>ブロック</rt></ruby>を省略していくつかのケースを処理しなかった場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は<ruby>論理<rt>ロジック</rt></ruby>バグを警告しませんでした。

### 条件付きループ`while let`

`if let`と同様の構成で`while let`条件付きループは、パターンが引き続き一致する限り`while`ループを実行`while let`ます。
リスト18-2の例で示し`while let`<ruby>山<rt>スタック</rt></ruby>としてベクターを使用し、それらがプッシュされた逆の順序でベクトルの値を<ruby>印字<rt>プリント</rt></ruby>するループ。

```rust
let mut stack = Vec::new();

stack.push(1);
stack.push(2);
stack.push(3);

while let Some(top) = stack.pop() {
    println!("{}", top);
}
```

<span class="caption">18-2リスト。使用して<code>while let</code>ループは限りの値を<ruby>印字<rt>プリント</rt></ruby>する<code>stack.pop()</code>返す<code>Some</code></span>

この例では3、2、1を出力します`pop`<ruby>操作法<rt>メソッド</rt></ruby>は最後の要素をベクトルから取り出し、`Some(value)`を返します。
ベクトルが空の場合、`pop`は`None`返します。
`while`ループは限り、その<ruby>段落<rt>ブロック</rt></ruby>内の<ruby>譜面<rt>コード</rt></ruby>を実行し続け`pop`返さ`Some`。
`pop`が`None`返すと、ループは停止します。
<ruby>山<rt>スタック</rt></ruby>のすべての要素をポップアップ`while let`使うことができます。

### `for`ループ

第3章では、`for`ループはRust<ruby>譜面<rt>コード</rt></ruby>の中で最も一般的なループ構造であると述べ`for`が`for`テイクのパターンについてはまだ説明していません。
`for`ループでは、パターンは`for`の予約語の直後にある値なので、`for x in y`では`x`がパターンです。

<ruby>譜面<rt>コード</rt></ruby>リスト18-3は`for`ループのパターンを使って、`for`ループの一部として組を分割または分割する方法を示し`for`ます。

```rust
let v = vec!['a', 'b', 'c'];

for (index, value) in v.iter().enumerate() {
    println!("{} is at index {}", value, index);
}
```

<span class="caption">リスト18-3。 <code>for</code>ループのパターンを使って組を構造化する</span>

<ruby>譜面<rt>コード</rt></ruby>リスト18-3の<ruby>譜面<rt>コード</rt></ruby>は次のように表示されます。

```text
a is at index 0
b is at index 1
c is at index 2
```

`enumerate`<ruby>操作法<rt>メソッド</rt></ruby>を使用して<ruby>反復子<rt>イテレータ</rt></ruby>を適用して値を生成し、<ruby>反復子<rt>イテレータ</rt></ruby>内のその値の<ruby>添字<rt>インデックス</rt></ruby>を組に配置します。
`enumerate`最初の呼び出しは、組`(0, 'a')`ます。
この値がパターン`(index, value)`に一致すると、`index`は`0`なり、`value`は`'a'`になり、出力の最初の行が出力されます。

### 文を`let`

この章の前には、`match`と`if let`でパターンを使用することについてのみ明示的に議論しましたが、実際には`let`文を含む他の場所でもパターンを使用しています。
たとえば、`let`使ってこのような簡単な変数代入を考えて`let`。

```rust
let x = 5;
```

この本を通して、使用してきました`let`回のこの数百のように、そしてあなたがそれを実現していないかもしれないが、あなたはパターンを使用していました！　
より正式には、`let`文は次のようになります。

```text
let PATTERN = EXPRESSION;
```

`let x = 5;`ような文では`let x = 5;`
`PATTERN`スロットに変数名を付けると、変数名は単なるパターンの単純な形式に過ぎません。
Rustは式とパターンを比較し、見つかった名前を割り当てます。
だから`let x = 5;`
たとえば、`x`意味のパターンである「変数にここに合致するものを結合し`x`。」名前なので`x`、全体のパターンで、このパターンは、実質的に「変数にすべてを束縛する意味`x`値が何であれ、。」

`let`<ruby>模式<rt>パターン</rt></ruby>照合の側面をより明確に見るために、リスト18-4を考えて`let`。これは`let`パターンを使って組を分解します。

```rust
let (x, y, z) = (1, 2, 3);
```

<span class="caption">リスト18-4。パターンを使って組を分解し、一度に3つの変数を作成する</span>

ここでは、組とパターンを照合します。
Rustは値`(1, 2, 3)`をパターン`(x, y, z)`と比較し、その値がパターンと一致することを確認するので、Rustは`1`を`x`、 `2`を`y`に、`3`を`z`束縛します。
この組パターンは、内部に3つの個別の変数パターンをネストしていると考えることができます。

パターンの要素の数が組の要素の数と一致しない場合は、全体の型が一致せず、<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。
たとえば、リスト18-5は、3つの要素を持つ組を2つの変数に分解しようとしていますが、これはうまくいきません。

```rust,ignore
let (x, y) = (1, 2, 3);
```

<span class="caption">リスト18-5。変数が組の要素の数と一致しないパターンを間違って構築する</span>

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、次のような<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0308]: mismatched types
 --> src/main.rs:2:9
  |
2 |     let (x, y) = (1, 2, 3);
  |         ^^^^^^ expected a tuple with 3 elements, found one with 2 elements
  |
  = note: expected type `({integer}, {integer}, {integer})`
             found type `(_, _)`
```

組の中の1つ以上の値を無視したい場合は、「パターンの値を無視する」で説明するように`_`または`..`使用できます。
パターンに変数が多すぎる問題がある場合は、変数の数が組の要素の数と等しくなるように変数を削除して型を一致させることです。

### 機能のパラメータ

機能パラメータはパターンであってもよい。
名前の機能を宣言し、リスト18-6の<ruby>譜面<rt>コード</rt></ruby>、`foo`名前の一つのパラメータとる`x`型の`i32`、今ではおなじみのはずです。

```rust
fn foo(x: i32) {
#    // code goes here
    // <ruby>譜面<rt>コード</rt></ruby>はここに行く
}
```

<span class="caption">リスト18-6。関数型注釈は、パラメータのパターンを使用します。</span>

`x`部分はパターンです！　
`let`で行ったように、機能の引数の組をパターンにマッチ`let`ことができます。
リスト18-7は、組の値を機能に渡す際に値を分割します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn print_coordinates(&(x, y): &(i32, i32)) {
    println!("Current location: ({}, {})", x, y);
}

fn main() {
    let point = (3, 5);
    print_coordinates(&point);
}
```

<span class="caption">リスト18-7。組をデストラクションするパラメータを持つ機能</span>

この<ruby>譜面<rt>コード</rt></ruby>は`Current location: (3, 5)`ます。
値`&(3, 5)`はパターン`&(x, y)`と一致するので、`x`は値`3`、 `y`は値`5`です。

第13章で説明したように、<ruby>閉包<rt>クロージャー</rt></ruby>は機能と似ているので、機能パラメータリストと同じ方法で<ruby>閉包<rt>クロージャー</rt></ruby>パラメータリストのパターンを使用することもできます。

この時点で、パターンを使用するいくつかの方法を見てきましたが、使用できるすべての場所でパターンが同じように機能しません。
いくつかの場所では、パターンは反駁不可能でなければならない。
他の状況では、それらは改訂することができます。
次に、これらの2つの概念について説明します。
