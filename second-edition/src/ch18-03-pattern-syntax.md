## パターンの構文

この本を通して、多くの種類のパターンの例を見てきました。
この章では、パターンで有効なすべての構文を収集し、それぞれの構文を使用する理由を説明します。

### 照合<ruby>直書き<rt>リテラル</rt></ruby>

第6章で見たように、パターンと<ruby>直書き<rt>リテラル</rt></ruby>を直接照合することができます。
次の<ruby>譜面<rt>コード</rt></ruby>はいくつかの例を示しています。

```rust
let x = 1;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

この<ruby>譜面<rt>コード</rt></ruby>は、`x`の値が`one`ため`one`出力します。この構文は、特定の具体的な値を取得した場合に<ruby>譜面<rt>コード</rt></ruby>が動作を起こさせる場合に便利です。

### 名前付き変数の照合

名前付き変数は任意の値に一致する反駁可能なパターンであり、本で何度も使用しています。
しかし、`match`式で名前付き変数を使用すると、複雑になります。
`match`は新しい<ruby>有効範囲<rt>スコープ</rt></ruby>を開始するので、`match`式の中でパターンの一部として宣言された変数は、すべての変数の場合と同様に、`match`構造の外で同じ名前を持つ変数を遮蔽します。
リスト18-11で、という名前の変数を宣言`x`値を持つ`Some(5)`と、変数`y`値が`10`。
次に、`x`の値に`match`式を作成します。
マッチ分岐のパターンと最後に`println!`見て、この<ruby>譜面<rt>コード</rt></ruby>を実行する前に<ruby>譜面<rt>コード</rt></ruby>が何を出力するかを`println!`か、さらに読むことを試みてください。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) => println!("Got 50"),
        Some(y) => println!("Matched, y = {:?}", y),
        _ => println!("Default case, x = {:?}", x),
    }

    println!("at the end: x = {:?}, y = {:?}", x, y);
}
```

<span class="caption">リスト18-11。遮蔽変数を導入する分岐を持つ<code>match</code>式<code>y</code></span>

`match`式が実行されたときの動作について説明しましょう。
最初のマッチ分岐のパターンが`x`の定義された値と一致しないため、<ruby>譜面<rt>コード</rt></ruby>は続行されます。

2番目のマッチ分岐のパターンは、`Some`という名前の中の任意の値と一致する`y`という名前の新しい変数を導入します。
`match`式の中で新しい<ruby>有効範囲<rt>スコープ</rt></ruby>に入っているので、これは最初に値10で宣言した`y`ではなく、新しい`y`変数です。この新しい`y`束縛は、`Some`内部の値と一致します。`x`。
したがって、この新しい`y`は`Some` in `x`内部値に束縛されます。
その値は`5`なので、その分岐の式が実行され、`Matched, y = 5`ます。

`x`が`Some(5)`ではなく`None`値だった場合、最初の2つの分岐のパターンは一致しないので、値は下線に一致します。
下線分岐のパターンに`x`変数を導入しなかったので、式の`x`はまだ影付きでない外側`x`です。
この仮説的なケースでは、`match`は`Default case, x = None`ます。

`match`式が終了すると、その<ruby>有効範囲<rt>スコープ</rt></ruby>は終了し、内側の`y`<ruby>有効範囲<rt>スコープ</rt></ruby>も終了します。
最後の`println!`は最後に生成さ`at the end: x = Some(5), y = 10`。

影付きの変数を導入するのではなく、外側の`x`と`y`値を比較する`match`式を作成するには、代わりにマッチガード条件を使用する必要があります。
後で「マッチガード付きエクストラコンディション」章でマッチガードについて説明します。

### 複数のパターン

`match`式では、`|`を使用して複数のパターンを一致させることができます`|`
構文、つまり*または*を意味します。
たとえば、次の<ruby>譜面<rt>コード</rt></ruby>では、`x`の値と一致する武器を照合します。その最初の桁には、*または*<ruby>選択肢<rt>オプション</rt></ruby>があります。つまり、`x`の値がその分岐の値のいずれかと一致する場合、その分岐の<ruby>譜面<rt>コード</rt></ruby>が実行されます。

```rust
let x = 1;

match x {
    1 | 2 => println!("one or two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

この<ruby>譜面<rt>コード</rt></ruby>は`one or two`出力します。

### 値の一致する範囲と`...`

`...`構文を使用すると、包括的な値の範囲に一致させることができます。
次の<ruby>譜面<rt>コード</rt></ruby>では、パターンが範囲内の値のいずれかと一致すると、その分岐は次のように実行されます。

```rust
let x = 5;

match x {
    1 ... 5 => println!("one through five"),
    _ => println!("something else"),
}
```

`x`が1,2,3,4または5の場合、最初の分岐が一致します。
この構文は、`|`
同じアイデアを表現するための演算子。
`1 ... 5`ではなく、`1 ... 5` `1 | 2 | 3 | 4 | 5` `1 ... 5`を指定する必要があります`1 | 2 | 3 | 4 | 5`
`1 | 2 | 3 | 4 | 5` `1 | 2 | 3 | 4 | 5`使用している場合`|`
。
範囲を指定するのははるかに短く、特に1から1,000までの任意の数に一致させたい場合は特にそうです！　

<ruby>製譜<rt>コンパイル</rt></ruby>時に範囲が空でないことを<ruby>製譜器<rt>コンパイラー</rt></ruby>がチェックするため、範囲には数値または`char`値しか使用できません。
範囲が空であるかどうかをRustが判別できる唯一の型は、`char`と数値です。

次に、`char`値の範囲を使用する例を示します。

```rust
let x = 'c';

match x {
    'a' ... 'j' => println!("early ASCII letter"),
    'k' ... 'z' => println!("late ASCII letter"),
    _ => println!("something else"),
}
```

Rustは、`c`が最初のパターンの範囲内にあり、`early ASCII letter`を出力することが分かります。

### 離れた値を破るための破壊

パターンを使用して、構造体、列挙型、組、および参照を破棄し、これらの値の異なる部分を使用することもできます。
それぞれの価値観を歩みましょう。

#### 構造物の破壊

リスト18-12は、2つの<ruby>欄<rt>フィールド</rt></ruby>`x`と`y`を持つ`Point`構造体を示しています。これは、`let`文でパターンを使用して分割できます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    let Point { x: a, y: b } = p;
    assert_eq!(0, a);
    assert_eq!(7, b);
}
```

<span class="caption">リスト18-12。構造体の<ruby>欄<rt>フィールド</rt></ruby>を別々の変数に分解する</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`p`変数の`x`および`y`<ruby>欄<rt>フィールド</rt></ruby>の値と一致する変数`a`および`b`を作成します。
この例は、パターン内の変数の名前が構造体の<ruby>欄<rt>フィールド</rt></ruby>名と一致する必要はないことを示しています。
しかし、どの変数がどの<ruby>欄<rt>フィールド</rt></ruby>から来たのかを覚えやすくするために、変数名を<ruby>欄<rt>フィールド</rt></ruby>名と一致させるのが一般的です。

変数名が<ruby>欄<rt>フィールド</rt></ruby>に一致するのは一般的で、`let Point { x: x, y: y } = p;`書くため`let Point { x: x, y: y } = p;`
構造体<ruby>欄<rt>フィールド</rt></ruby>と一致するパターンの略語があります。構造体<ruby>欄<rt>フィールド</rt></ruby>の名前をリストするだけで、パターンから作成された変数は同じ名前になります。
リスト18-13は、<ruby>譜面<rt>コード</rt></ruby>リスト18-12の<ruby>譜面<rt>コード</rt></ruby>と同じように動作する<ruby>譜面<rt>コード</rt></ruby>を示していますが、`let`パターンで作成された変数は`a`と`b`ではなく`x`と`y`です。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };

    let Point { x, y } = p;
    assert_eq!(0, x);
    assert_eq!(7, y);
}
```

<span class="caption">リスト18-13。構造体<ruby>欄<rt>フィールド</rt></ruby>の構造体を使って構造体<ruby>欄<rt>フィールド</rt></ruby>を破壊する</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`p`変数の`x`および`y`<ruby>欄<rt>フィールド</rt></ruby>に一致する変数`x`および`y`を作成します。
結果は、変数`x`と`y`に`p`構造体の値が含まれていることです。

また、すべての<ruby>欄<rt>フィールド</rt></ruby>の変数を作成するのではなく、構造体パターンの一部として<ruby>直書き<rt>リテラル</rt></ruby>値を使用して構造化することもできます。
そうすることで、特定の値の<ruby>欄<rt>フィールド</rt></ruby>の一部をテストし、他の<ruby>欄<rt>フィールド</rt></ruby>を分解する変数を作成することができます。

<ruby>譜面<rt>コード</rt></ruby>リスト18-14は、`Point`値を3つのケースに分ける`match`式を示しています。ポイントは、`x`軸に直接（`y = 0`場合は真）、`y`軸（`x = 0`）、またはどちらでもありません。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# struct Point {
#     x: i32,
#     y: i32,
# }
#
fn main() {
    let p = Point { x: 0, y: 7 };

    match p {
        Point { x, y: 0 } => println!("On the x axis at {}", x),
        Point { x: 0, y } => println!("On the y axis at {}", y),
        Point { x, y } => println!("On neither axis: ({}, {})", x, y),
    }
}
```

<span class="caption">リスト18-14。1つのパターンで<ruby>直書き<rt>リテラル</rt></ruby>値を分解して一致させる</span>

最初の分岐は、その値が<ruby>直書き<rt>リテラル</rt></ruby>`0`一致する場合に`y`<ruby>欄<rt>フィールド</rt></ruby>が一致することを指定することによって、`x`軸上の任意の点に一致します。
パターンは、この分岐の<ruby>譜面<rt>コード</rt></ruby>で使用できる`x`変数を作成します。

同様に、第2の分岐は、その値が`0`場合に`x`<ruby>欄<rt>フィールド</rt></ruby>が一致することを指定することによって`y`軸上の任意の点に一致し、`y`<ruby>欄<rt>フィールド</rt></ruby>の値に対する変数`y`を作成します。
3番目の分岐は<ruby>直書き<rt>リテラル</rt></ruby>を指定しないので、他の`Point`と一致し、`x`と`y`両方の<ruby>欄<rt>フィールド</rt></ruby>の変数を作成します。

この例では、値`p`は0を含む`x`によって2番目の分岐に一致するため、この<ruby>譜面<rt>コード</rt></ruby>は`On the y axis at 7`ます。

#### 列挙型の破壊

たとえば、リスト6-5の`Option<i32>`が第6章で破棄されたときなど、この本の前半のenumを破壊しました.1つの詳細について言及していない1つの詳細は、列挙型を破棄するパターンは、enum内に格納されたデータが定義されます。
たとえば、リスト18-15では、リスト6-2の`Message` enumを使用して、各内部値を分解するパターンで`match`を書き込みます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn main() {
    let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => {
            println!("The Quit <ruby>場合値<rt>バリアント</rt></ruby> has no data to destructure.")
        },
        Message::Move { x, y } => {
            println!(
                "Move in the x direction {} and in the y direction {}",
                x,
                y
            );
        }
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => {
            println!(
                "Change the color to red {}, green {}, and blue {}",
                r,
                g,
                b
            )
        }
    }
}
```

<span class="caption">リスト18-15。異なる種類の値を保持する列挙型の変形</span>

この<ruby>譜面<rt>コード</rt></ruby>は`Change the color to red 0, green 160, and blue 255`ます。
`msg`の値を変更して、他の分岐の<ruby>譜面<rt>コード</rt></ruby>を確認してみてください。

`Message::Quit`ような、データを持たない列挙型の場合、それ以上値を破棄することはできません。
<ruby>直書き<rt>リテラル</rt></ruby>`Message::Quit`値だけを照合することができ、そのパターンに変数はありません。

`Message::Move`ような構造体のような列挙型の場合、構造体と一致するように指定したパターンに似たパターンを使用できます。
<ruby>場合値<rt>バリアント</rt></ruby>名の後に、中かっこを配置して変数を使用して<ruby>欄<rt>フィールド</rt></ruby>をリストするので、この分岐の<ruby>譜面<rt>コード</rt></ruby>で使用する部分を分割します。
ここではリスト18-13のように省略形を使用します。

1つの要素を持つ組を保持する`Message::Write`や3つの要素を持つ組を保持する`Message::ChangeColor`ような組のような列挙型の場合、パターンは組に一致するように指定したパターンと似ています。
パターン内の変数の数は、一致する<ruby>場合値<rt>バリアント</rt></ruby>内の要素の数と一致する必要があります。

#### 参照の破棄

パターンと一致する値に参照が含まれている場合は、その値から参照を削除する必要があります。これはパターンに`&`を指定することで可能です。
そうすることで、参照を保持する変数を取得するのではなく、参照が参照する値を保持する変数を取得できます。
この技法は、参照を反復処理する<ruby>反復子<rt>イテレータ</rt></ruby>がある<ruby>閉包<rt>クロージャー</rt></ruby>では特に便利ですが、参照ではなく<ruby>閉包<rt>クロージャー</rt></ruby>の値を使用したいと考えています。

<ruby>譜面<rt>コード</rt></ruby>リスト18-16の例は、Vector内の`Point`<ruby>実例<rt>インスタンス</rt></ruby>への参照を繰り返し、参照と構造体を破壊して、`x`と`y`値を簡単に計算できます。

```rust
# struct Point {
#     x: i32,
#     y: i32,
# }
#
let points = vec![
    Point { x: 0, y: 0 },
    Point { x: 1, y: 5 },
    Point { x: 10, y: -3 },
];

let sum_of_squares: i32 = points
    .iter()
    .map(|&Point { x, y }| x * x + y * y)
    .sum();
```

<span class="caption">リスト18-16。構造体への参照を破壊する構造体の<ruby>欄<rt>フィールド</rt></ruby>値</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`x`値と`y`値を二乗してそれらを`points`し、`points`ベクトル内の各`Point`の結果を加算して1つの数値を得る結果の値135を保持する変数`sum_of_squares`ます。

含まれていなかった場合は`&`で`&Point { x, y }`ので、型の不一致<ruby>誤り<rt>エラー</rt></ruby>を取得したい`iter`、その後、ベクターではなく、実際の値で項目への参照を反復処理します。
<ruby>誤り<rt>エラー</rt></ruby>は次のようになります。

```text
error[E0308]: mismatched types
  -->
   |
14 |         .map(|Point { x, y }| x * x + y * y)
   |               ^^^^^^^^^^^^ expected &Point, found struct `Point`
   |
   = note: expected type `&Point`
              found type `Point`
```

この<ruby>誤り<rt>エラー</rt></ruby>は、Rustが<ruby>閉包<rt>クロージャー</rt></ruby>が`&Point`と一致すると予想していたが、`Point`への参照ではなく`Point`値に直接一致させようとしたことを示しています。

#### 構造体と組の破壊

より複雑な方法で、非構造化パターンを混在、一致、および入れ子にすることができます。
次の例は、構造体と組を組内にネストし、すべての基本型値を破棄する複雑な構造を示しています。

```rust
# struct Point {
#     x: i32,
#     y: i32,
# }
#
let ((feet, inches), Point {x, y}) = ((3, 10), Point { x: 3, y: -10 });
```

この<ruby>譜面<rt>コード</rt></ruby>では、複雑な型を部品の部分に分割して、別々の値を使用できます。

パターンを使った破壊は、構造体の各<ruby>欄<rt>フィールド</rt></ruby>の値など、値の断片を別々に使う便利な方法です。

### パターン内の値を無視する

それが、このような最後の分岐のように、パターン内の値、無視すると便利な場合がありますことを見てきた`match`、実際に何かをするが、残りのすべての可能な値のアカウントをしていない<ruby>捕捉<rt>キャッチ</rt></ruby>オールを得るために、。
`_`パターン（見たことがある）を使用するか、別のパターン内の`_`パターンを使用するか、下線で始まる名前を使用するか、`..`を使用して、パターン内の値全体または値の一部を無視する方法はいくつかあり`..`値の残りの部分を無視します。
どうやってこれらのパターンを使うのかを探そう。

#### `_`完全な値を無視する

下線（`_`）はワイルドカードパターンとして使用されていますが、値には一致しますが値には束縛されません。
下線`_`パターンは、`match`式の最後の分岐として特に便利ですが、リスト18-17に示すように、機能パラメータを含むどのパターンでも使用できます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn foo(_: i32, y: i32) {
    println!("This code only uses the y parameter: {}", y);
}

fn main() {
    foo(3, 4);
}
```

<span class="caption">リスト18-17。関数型注釈で<code>_</code>を使う</span>

この<ruby>譜面<rt>コード</rt></ruby>は、最初の引数`3`として渡された値を完全に無視して出力します。`This code only uses the y parameter: 4`。

ほとんどの場合、特定の機能パラメータが不要になったときに、未使用のパラメータが含まれないように型注釈を変更します。
機能パラメータを無視すると、特定の型型注釈が必要なときに<ruby>特性<rt>トレイト</rt></ruby>を実装する場合など、実装の機能本体にパラメータの1つが必要ない場合など、いくつかの場合に特に便利です。
<ruby>製譜器<rt>コンパイラー</rt></ruby>は、代わりに名前を使用した場合と同様に、未使用の機能パラメータについて警告しません。

#### 入れ子になった`_`を持つ値の部分を無視する

たとえば、値の一部だけをテストしたいが、実行したい<ruby>譜面<rt>コード</rt></ruby>の他の部分には使用しないなど、別のパターンの中で`_`を使って値の一部を無視することもできます。
リスト18-18は、設定の値を管理する<ruby>譜面<rt>コード</rt></ruby>を示しています。
ビジネス要件は、利用者が設定の既存のカスタマイズを上書きすることを許可されるべきではなく、設定を解除することができ、現在設定されていない場合に設定に値を与えることができるということです。

```rust
let mut setting_value = Some(5);
let new_setting_value = Some(10);

match (setting_value, new_setting_value) {
    (Some(_), Some(_)) => {
        println!("Can't overwrite an existing customized value");
    }
    _ => {
        setting_value = new_setting_value;
    }
}

println!("setting is {:?}", setting_value);
```

<span class="caption">リスト18-18。一致するパターン内に下線を使用する場合<code>Some</code>場合値の<code>Some</code>値を使用する必要がない場合</span>

この<ruby>譜面<rt>コード</rt></ruby>は`Can't overwrite an existing customized value`を`Can't overwrite an existing customized value`し、`setting is Some(5)`です。
最初のマッチでは、どちら`Some`<ruby>場合値<rt>バリアント</rt></ruby>の`Some`値をマッチさせたり使用したりする必要はありませんが、`setting_value`と`new_setting_value`が`Some`<ruby>場合値<rt>バリアント</rt></ruby>である場合をテストする必要があります。
その場合、なぜ`setting_value`変更していないのかを`setting_value`、変更されません。

それ以外の場合（2番目の分岐の`_`パターンで表される`setting_value`または`new_setting_value`が`None`）は、 `new_setting_value`を`new_setting_value`する必要があります。

あるパターン内の複数の場所で下線を使用して、特定の値を無視することもできます。
リスト18-19は、5つの項目からなる組の2番目と4番目の値を無視する例を示しています。

```rust
let numbers = (2, 4, 8, 16, 32);

match numbers {
    (first, _, third, _, fifth) => {
        println!("Some numbers: {}, {}, {}", first, third, fifth)
    },
}
```

<span class="caption">リスト18-19。組の複数の部分を無視する</span>

この<ruby>譜面<rt>コード</rt></ruby>は`Some numbers: 2, 8, 32`を<ruby>印字<rt>プリント</rt></ruby>し`Some numbers: 2, 8, 32`、値4と16は無視されます。

#### 使用していない変数を無視する`_`

変数を作成してどこにも使用しない場合、Rustは通常はバグかもしれないので警告を出します。
しかし、プロト型や企画の開始時など、まだ使用しない変数を作成すると便利なことがあります。
この状況では、変数の名前を下線で始めることによって、未使用変数について警告しないようRustに指示できます。
リスト18-20では、2つの未使用変数を作成しますが、この<ruby>譜面<rt>コード</rt></ruby>を実行するときには、そのうちの1つについてのみ警告を出す必要があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let _x = 5;
    let y = 10;
}
```

<span class="caption">リスト18-20。未使用の変数警告を避けるために、変数名を下線で開始する</span>

ここでは、変数`y`を使用しないという警告が表示されますが、下線の前に変数を使用しないことに関する警告は表示されません。

`_`だけを使用する場合と下線で始まる名前を使用する場合には微妙な違いがあることに注意してください。
構文`_x`は値を変数に束縛しますが、`_`はまったく束縛しません。
この区別が重要な場合を示すために、リスト18-21は<ruby>誤り<rt>エラー</rt></ruby>を表示します。

```rust,ignore
let s = Some(String::from("Hello!"));

if let Some(_s) = s {
    println!("found a string");
}

println!("{:?}", s);
```

<span class="caption">リスト18-21。下線で始まる未使用の変数は引き続き値を束縛します。</span>

`s`値が`_s`に移動されるため、<ruby>誤り<rt>エラー</rt></ruby>が返されます。これにより、`s`再度使用することができなくなります。
しかし、下線自体を使用しても値に束縛されることはありません。
リスト18-22は、`s`が`_`に移動しないため、<ruby>誤り<rt>エラー</rt></ruby>なしで<ruby>製譜<rt>コンパイル</rt></ruby>されます。

```rust
let s = Some(String::from("Hello!"));

if let Some(_) = s {
    println!("found a string");
}

println!("{:?}", s);
```

<span class="caption">リスト18-22。下線を使用しても値は束縛されません</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`s`を何も束縛しないのでうまく動作します。
それは動かされません。

#### 値の残りの部分を無視します`..`

多くの部分を持つ値では、`..`構文を使用していくつかの部分のみを使用し、残りの部分は無視して、無視された値ごとに下線をリストする必要はありません。
`..`パターンは、残りのパターンで明示的にマッチしていない値の部分を無視します。
リスト18-23には、3次元空間内の座標を保持する`Point`構造体があります。
`match`式では、`x`座標のみで操作し、`y`と`z`<ruby>欄<rt>フィールド</rt></ruby>の値は無視します。

```rust
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

let origin = Point { x: 0, y: 0, z: 0 };

match origin {
    Point { x, .. } => println!("x is {}", x),
}
```

<span class="caption">リスト18-23。 <code>..</code>を使って、 <code>x</code>を除く<code>Point</code>すべての<ruby>欄<rt>フィールド</rt></ruby>を無視する</span>

`x`値を列挙し、`..`パターンだけを含め`..`。
1つまたは2つの<ruby>欄<rt>フィールド</rt></ruby>のみが関連する状況で多くの<ruby>欄<rt>フィールド</rt></ruby>を持つ構造体を扱っている場合は特に、`y: _`と`z: _`をリストする必要があります。

構文`..`は必要なだけ多くの値に展開されます。
リスト18-24は、組で`..`を使用する方法を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let numbers = (2, 4, 8, 16, 32);

    match numbers {
        (first, .., last) => {
            println!("Some numbers: {}, {}", first, last);
        },
    }
}
```

<span class="caption">リスト18-24。組の最初と最後の値だけを一致させ、他のすべての値を無視する</span>

この<ruby>譜面<rt>コード</rt></ruby>では、最初と最後の値が`first`と`last`一致します。
`..`は真ん中のすべてを無視して一致させます。

しかし`..`を使用することはあいまいでなければなりません。
どの値が照合の<ruby>対象<rt>オブジェクト</rt></ruby>か、無視されるべきかが不明な場合、Rustは<ruby>誤り<rt>エラー</rt></ruby>を返します。
18-25のリストの使用例を示します`..`曖昧なので、それが<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let numbers = (2, 4, 8, 16, 32);

    match numbers {
        (.., second, ..) => {
            println!("Some numbers: {}", second)
        },
    }
}
```

<span class="caption">リスト18-25。あいまいな方法で<code>..</code>を使う試み</span>

この例を<ruby>製譜<rt>コンパイル</rt></ruby>すると、次の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error: `..` can only be used once per tuple or tuple struct pattern
 --> src/main.rs:5:22
  |
5 |         (.., second, ..) => {
  |                      ^^
```

Rustでは、値を`second`値と一致させる前に無視する組内の値の数を決定し、その後無視する値を何個追加するかを決定することは不可能です。
この<ruby>譜面<rt>コード</rt></ruby>は、無視することを意味する可能性がある`2`、束縛`second`に`4`無視し、その後、および`8`、 `16`、および`32`、
または`2`と`4`を無視し、`2` `second`を`8`に束縛してから、`16`と`32`を無視したいということです。
等々。
変数名`second`はRustにとって特別なものではないので、このように2つの場所で`..`を使用するとあいまいであるため、<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生し`..`。

### `ref`と`ref mut`使ってパターン内の参照を作成する

`ref`を作成して値の所有権をパターン内の変数に移動させないように`ref`を使ってみましょう。
通常、パターンとマッチすると、パターンによって導入された変数は値に束縛されます。
Rustの所有権ルールは、値が`match`またはパターンを使用している場所に移動されることを意味します。
18-26のリストの例を示す`match`全体値の次に変数と使用のパターン有する`println!`後、後の文を`match`。
この<ruby>譜面<rt>コード</rt></ruby>は、`robot_name`値の一部の所有権が最初の`match`分岐のパターンで`name`変数に転送されるため、<ruby>製譜<rt>コンパイル</rt></ruby>に失敗します。

```rust,ignore
let robot_name = Some(String::from("Bors"));

match robot_name {
    Some(name) => println!("Found a name: {}", name),
    None => (),
}

println!("robot_name is: {:?}", robot_name);
```

<span class="caption">リスト18-26。 <code>match</code>分岐パターンで変数を作成すると、値の所有権が得られます</span>

`robot_name`の一部の所有権は`name`に移動されているため、`robot_name`は所有権を持たないため、`match`後に`println!` `robot_name`を使用することはできません。

この<ruby>譜面<rt>コード</rt></ruby>を修正するために、`Some(name)`パターンを所有権を取得するのではなく、`robot_name`その部分を*借用*したいと考えています。
パターンの外で値を借りる方法は、`&`を使用して参照を作成することです。そのため、ソリューションが`Some(name)`を`Some(&name)`変更して`Some(name)`と思うかもしれません。

ただし、「値を分割するための<ruby>破棄子<rt>デストラクター</rt></ruby>リング」の章で見たように、`&` inパターンの構文は参照を*作成*せず、値の既存の参照と*一致*します。
ので`&`すでにパターンでその意味を持って、使用できません`&`パターンで参照を作成します。

代わりに、パターンで参照を作成するには、リスト18-27に示すように、新しい変数の前に`ref`予約語を使用します。

```rust
let robot_name = Some(String::from("Bors"));

match robot_name {
    Some(ref name) => println!("Found a name: {}", name),
    None => (),
}

println!("robot_name is: {:?}", robot_name);
```

<span class="caption">リスト18-27。パターン変数が値の所有権を取得しないように参照を作成する</span>

この例は、`robot_name`の`Some` <ruby>場合値<rt>バリアント</rt></ruby>の値が`match`移動されないため<ruby>製譜<rt>コンパイル</rt></ruby>されます。
この`match`では、`robot_name`移動するのではなく、そのデータを参照するだけでした。

mutable参照を作成してパターンにマッチした値を変更できるようにするには、`&mut`代わりに`ref mut`を使用します。
その理由は、やはりパターンでは、後者は既存の可変参照を照合するためであり、新しい参照を作成するのではないからです。
リスト18-28は、可変参照を作成するパターンの例を示しています。

```rust
let mut robot_name = Some(String::from("Bors"));

match robot_name {
    Some(ref mut name) => *name = String::from("Another name"),
    None => (),
}

println!("robot_name is: {:?}", robot_name);
```

<span class="caption">リスト18-28。 <code>ref mut</code>を使ってパターンの一部として値への可変参照を作成する</span>

この例では、`robot_name is: Some("Another name")`<ruby>製譜<rt>コンパイル</rt></ruby>され、表示されます`robot_name is: Some("Another name")`。
`name`は可変参照であるため、値を変更するには`*`演算子を使用してマッチ・分岐・<ruby>譜面<rt>コード</rt></ruby>内の参照を解除する必要があります。

### マッチガードを持つエクストラコンディション

*マッチガード*は、`match`分岐内のパターンの後に指定された追加の`if`条件であり、<ruby>模式<rt>パターン</rt></ruby>照合とともにその分岐を選択する必要があります。
マッチガードは、パターンだけで可能なものより複雑なアイデアを表現するのに便利です。

この条件では、パターンで作成された変数を使用できます。
18-29をリスト示し`match`第一分岐のパターンを有する`Some(x)`ともの一致ガード有する`if x < 5`。

```rust
let num = Some(4);

match num {
    Some(x) if x < 5 => println!("less than five: {}", x),
    Some(x) => println!("{}", x),
    None => (),
}
```

<span class="caption">リスト18-29。マッチガードをパターンに追加する</span>

この例では`less than five: 4`を出力します。
`num`最初の分岐のパターンと比較すると、`Some(4)` `Some(x)`一致するため、`num`と一致します。
その後、マッチガードは、`x`の値が`5`より小さいかどうかをチェックし、そうであるため、最初の分岐が選択されます。

もし`num`が`Some(10)`だったら、10が5以上であるので、最初の分岐のマッチガードは偽になるでしょう。Rustは2番目の分岐に行きます。2番目の分岐にはしたがって、`Some`変形にマッチします。

パターン内で`if x < 5`条件を表現する方法はないので、マッチガードはこの<ruby>論理<rt>ロジック</rt></ruby>を表現する能力を与えます。

リスト18-11では、マッチガードを使用してパターンシャドーイングの問題を解決できると述べました。
`match`以外の変数を使用する代わりに、`match`式のパターン内に新しい変数が作成されたことを思い出してください。
その新しい変数は、外部変数の値に対してテストできないことを意味しました。
リスト18-30に、この問題を解決するためにマッチガードを使用する方法を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) => println!("Got 50"),
        Some(n) if n == y => println!("Matched, n = {:?}", n),
        _ => println!("Default case, x = {:?}", x),
    }

    println!("at the end: x = {:?}, y = {:?}", x, y);
}
```

<span class="caption">リスト18-30。マッチガードを使って外部変数との等価性をテストする</span>

この<ruby>譜面<rt>コード</rt></ruby>では`Default case, x = Some(5)`。
2番目のマッチ分岐のパターンは外側の`y`を遮蔽する新しい変数`y`を導入しないので、マッチガードの外側`y`を使用することができます。
パターンを`Some(y)`として指定する代わりに、外側の`y`をシャドーにして、`Some(n)`を指定します。
これは、`match`外側に`n`変数がないため、何も陰をつけない新しい変数`n`を作成します。

`if n == y`のマッチガードはパターンではないので、新しい変数を導入しません。
この`y`、外*である* `y`ではなく、新たな影のより`y`、と外と同じ値を持つ値を探すことができ`y`比較することにより、`n`する`y`。

*または*演算子`|`使用することもできます`|`
マッチガードで複数のパターンを指定します。
マッチガード条件はすべてのパターンに適用されます。
リスト18-31に、マッチガードと`|`を使用するパターンを組み合わせた場合の優先順位を示します`|`
。
この例の重要な部分は、ということである`if y`マッチガードが適用される`4`、 `5`、 *及び* `6`それはのように見える場合でも、`if y`のみに適用されます`6`。

```rust
let x = 4;
let y = false;

match x {
    4 | 5 | 6 if y => println!("yes"),
    _ => println!("no"),
}
```

<span class="caption">リスト18-31。複数のパターンをマッチガードと組み合わせる</span>

一致条件は、分岐のみの値場合に一致していることを述べて`x`に等しい`4`、 `5`、または`6`場合*に* `y`ある`true`。
この<ruby>譜面<rt>コード</rt></ruby>が実行されると、`x`が`4`であるため、最初の分岐のパターンが一致しますが、`if y`がfalseの`if y`はマッチガードが起きるため、最初の分岐は選択されません。
<ruby>譜面<rt>コード</rt></ruby>は一致する第2の分岐に移動し、この<ruby>算譜<rt>プログラム</rt></ruby>は`no`出力します。
理由は、`if`条件がパターン全体に適用されるためです`4 | 5 | 6`
`4 | 5 | 6` `4 | 5 | 6`だけでなく、最後の値`6`。
言い換えれば、パターンに関連したマッチガードの優先順位は、次のようになります。

```text
(4 | 5 | 6) if y => ...
```

これよりむしろ。

```text
4 | 5 | (6 if y) => ...
```

<ruby>譜面<rt>コード</rt></ruby>を実行した後、優先順位の動作が明白です。マッチガードが、`|`値を使用して指定された値のリストの最終値にのみ適用された場合、
分岐は一致し、<ruby>算譜<rt>プログラム</rt></ruby>は`yes`と表示され`yes`。

### `@`束縛

*at*演算子（`@`）を使用すると、パターンに一致するかどうかを調べるときにその値をテストすると同時に値を保持する変数を作成できます。
リスト18-32は、`Message::Hello` `id`<ruby>欄<rt>フィールド</rt></ruby>が`3...7`範囲内にあることをテストするサンプルを示してい`3...7`。
しかし、値を変数`id_variable`に束縛して、分岐に関連付けられた<ruby>譜面<rt>コード</rt></ruby>でその値を使用することもできます。
この変数`id`には<ruby>欄<rt>フィールド</rt></ruby>と同じ名前を付けることができますが、この例では別の名前を使用します。

```rust
enum Message {
    Hello { id: i32 },
}

let msg = Message::Hello { id: 5 };

match msg {
    Message::Hello { id: id_variable @ 3...7 } => {
        println!("Found an id in range: {}", id_variable)
    },
    Message::Hello { id: 10...12 } => {
        println!("Found an id in another range")
    },
    Message::Hello { id } => {
        println!("Found some other id: {}", id)
    },
}
```

<span class="caption">リスト18-32。 <code>@</code>を使ってパターン内の値に束縛し、それをテストする</span>

この例では`Found an id in range: 5`ます。
指定することにより、`id_variable @`範囲の前に`3...7`、また、値が範囲のパターンと一致したことをテストしながら範囲をマッチしたどのような値獲得しています。

パターンに指定された範囲のみを持つ第2の分岐では、分岐に関連付けられた<ruby>譜面<rt>コード</rt></ruby>に`id`<ruby>欄<rt>フィールド</rt></ruby>の実際の値を含む変数はありません。
`id`<ruby>欄<rt>フィールド</rt></ruby>の値は10,11、または12であった可能性がありますが、そのパターンに含まれる<ruby>譜面<rt>コード</rt></ruby>は、その<ruby>譜面<rt>コード</rt></ruby>がどれであるかわかりません。
変数に`id`値を保存していないため、パターン<ruby>譜面<rt>コード</rt></ruby>は`id`<ruby>欄<rt>フィールド</rt></ruby>の値を使用できません。

最後の分岐では、範囲を持たない変数を指定していますが、分岐の<ruby>譜面<rt>コード</rt></ruby>で`id`という名前の変数で使用できる値があります。
その理由は、構造体<ruby>欄<rt>フィールド</rt></ruby>の短縮形構文を使用したためです。
しかし、最初の2つの分岐で行ったように、この分岐の`id`<ruby>欄<rt>フィールド</rt></ruby>の値にはテストを適用していません。

`@`使用すると、値をテストして1つのパターン内の変数に保存できます。

## 概要

Rustのパターンは、さまざまな種類のデータを区別するのに役立ちます。
`match`式で使用する`match`、Rustはパターンがすべての可能な値をカバーすることを保証します。そうしないと、<ruby>算譜<rt>プログラム</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。
`let`文と機能パラメータのパターンは`let`これらの構文をより便利にし、変数への代入と同時に小さな部分への値の破壊を可能にします。
ニーズに合ったシンプルまたは複雑なパターンを作成できます。

次に、本の最後から2番目の章について、さまざまなRustの機能のいくつかの発展的な側面を見ていきます。
