## スライス型

所有権を持たない別のデータ型は*スライス*です。
スライスを使用すると、<ruby>集まり<rt>コレクション</rt></ruby>全体ではなく、<ruby>集まり<rt>コレクション</rt></ruby>内の要素の連続した列を参照できます。

小さな<ruby>演譜<rt>プログラミング</rt></ruby>上の問題があります。<ruby>文字列<rt>ストリング</rt></ruby>をとり、その<ruby>文字列<rt>ストリング</rt></ruby>で見つかった最初の単語を返す機能を書く。
機能が<ruby>文字列<rt>ストリング</rt></ruby>内にスペースを見つけられない場合は、<ruby>文字列<rt>ストリング</rt></ruby>全体が1つの単語でなければならないため、<ruby>文字列<rt>ストリング</rt></ruby>全体が返されます。

この機能の型注釈について考えてみましょう。

```rust,ignore
fn first_word(s: &String) -> ?
```

この機能`first_word`は、パラメータとして`&String`を持ちます。
所有権を望まないので、これは問題ありません。
しかし、何を返すべきでしょうか？　
<ruby>文字列<rt>ストリング</rt></ruby>の*一部*について話す方法はありません。
しかし、単語の終わりの<ruby>添字<rt>インデックス</rt></ruby>を返すことができます。
リスト4-7に示すように、これを試してみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn first_word(s: &String) -> usize {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }

    s.len()
}
```

<span class="caption">リスト4-7。 <code>String</code>パラメータにバイト<ruby>添字<rt>インデックス</rt></ruby>値を返す<code>first_word</code>機能</span>

`String`要素を要素単位で調べ、値が空白かどうかをチェックする必要があるため、`as_bytes`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`String`をバイト配列に変換します。

```rust,ignore
let bytes = s.as_bytes();
```

次に、`iter`<ruby>操作法<rt>メソッド</rt></ruby>を使用して、バイト配列の<ruby>反復子<rt>イテレータ</rt></ruby>を作成します。

```rust,ignore
for (i, &item) in bytes.iter().enumerate() {
```

<ruby>反復子<rt>イテレータ</rt></ruby>については、第13章で詳しく説明します`iter`は<ruby>集まり<rt>コレクション</rt></ruby>内の各要素を返す<ruby>操作法<rt>メソッド</rt></ruby>であり、`enumerate`すると`iter`の結果を包み、各要素を組の一部として返す<ruby>操作法<rt>メソッド</rt></ruby>であることがわかります。
`enumerate`から返された組の最初の要素は<ruby>添字<rt>インデックス</rt></ruby>であり、2番目の要素は要素への参照です。
これは、<ruby>添字<rt>インデックス</rt></ruby>を自分で計算するよりも少し便利です。

`enumerate`<ruby>操作法<rt>メソッド</rt></ruby>は組を返すので、Rustの他の場所と同様に、パターンを使用してその組を破棄することができます。
したがって、`for`ループでは、組内の<ruby>添字<rt>インデックス</rt></ruby>の`i`と組内の1バイトの`&item`を持つパターンを指定します。
`.iter().enumerate()`から要素への参照を取得するため、パターン内で`&`を使用します。

`for`ループの内部では、バイト<ruby>直書き<rt>リテラル</rt></ruby>構文を使用してスペースを表すバイトを検索します。
スペースを見つけると、その位置を返します。
それ以外の場合は、`s.len()`を使用して<ruby>文字列<rt>ストリング</rt></ruby>の長さを返します。

```rust,ignore
    if item == b' ' {
        return i;
    }
}

s.len()
```

<ruby>文字列<rt>ストリング</rt></ruby>の最初の単語の終わりの<ruby>添字<rt>インデックス</rt></ruby>を見つける方法がありますが、問題があります。
独自に`usize`を返していますが、`&String`文脈では意味のある数字です。
つまり、`String`とは別の値なので、将来も有効であるという保証はありません。
リスト4-7の`first_word`機能を使用するリスト4-8の<ruby>算譜<rt>プログラム</rt></ruby>を考えてみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# fn first_word(s: &String) -> usize {
#     let bytes = s.as_bytes();
#
#     for (i, &item) in bytes.iter().enumerate() {
#         if item == b' ' {
#             return i;
#         }
#     }
#
#     s.len()
# }
#
fn main() {
    let mut s = String::from("hello world");

#//    let word = first_word(&s); // word will get the value 5
    let word = first_word(&s); // 単語は値5を取得します

#//    s.clear(); // this empties the String, making it equal to ""
    s.clear(); // これは<ruby>文字列<rt>ストリング</rt></ruby>を空にして、それを ""と等しくします

#    // word still has the value 5 here, but there's no more string that
#    // we could meaningfully use the value 5 with. word is now totally invalid!
    // 単語はここでも値5を持っていますが、意味のある値5を使用できる<ruby>文字列<rt>ストリング</rt></ruby>はありません。言葉が完全に無効になりました！　
}
```

<span class="caption">リスト4-8。結果を<code>first_word</code>機能を呼び出してから格納してから<code>String</code>内容を変更する</span>

この<ruby>算譜<rt>プログラム</rt></ruby>は<ruby>誤り<rt>エラー</rt></ruby>なしで<ruby>製譜<rt>コンパイル</rt></ruby>され、`s.clear()`呼び出した後に`word`を使用した場合も同様です。
`word`は`s`の状態に全く接続されていないので、`word`には値`5`が含まれています。
その値`5`を変数`s`と一緒に使用して最初の単語を抽出しようとしましたが、`word` `5`を保存してから`s`の内容が変更されたため、バグになります。

`word`の索引が`s`のデータと同期しなくなることを心配することは面倒で<ruby>誤り<rt>エラー</rt></ruby>が起こりやすい！　
`second_word`機能を書くと、これらの<ruby>添字<rt>インデックス</rt></ruby>を管理することはさらに脆弱です。
その署名は次のようになります。

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

現在、開始<ruby>添字<rt>インデックス</rt></ruby>*と*終了<ruby>添字<rt>インデックス</rt></ruby>を追跡しており、特定の状態のデータから計算された値はさらに多くなりますが、その状態にはまったく結び付けられていません。
3つの無関係な変数を浮動させて、同期させておく必要があります。

幸運にも、Rustにはこの問題の解決策があります。<ruby>文字列<rt>ストリング</rt></ruby>スライス。

### <ruby>文字列<rt>ストリング</rt></ruby>スライス

*<ruby>文字列<rt>ストリング</rt></ruby>スライス*は`String`一部への参照で、次のようになります。

```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world = &s[6..11];
```

これは、`String`全体を参照するのと同様ですが、余分な`[0..5]`ビットを使用します。
`String`全体の参照ではなく、`String`一部への参照です。
`start..end`構文は、開始時に`start`し、`end`継続する範囲です。

`[starting_index..ending_index]`指定することで、かっこ内の範囲を使用してスライスを作成できます。ここで、`starting_index`はスライスの最初の位置で、`ending_index`はスライスの最後の位置よりも1つ多くなります。
内部的には、スライスデータ構造に対応する開始位置とスライスの長さ、格納`ending_index`マイナス`starting_index`。
したがって、`let world = &s[6..11];`場合は`let world = &s[6..11];`
、`world`は、5の長さの値を持つ`s` 7番目のバイトへの<ruby>指し手<rt>ポインタ</rt></ruby>を含むスライスになります。

図4-6に、これを図で示します。

<img src="img/trpl04-06.svg" alt="Stringの6番目のバイトへの<ruby>指し手<rt>ポインタ</rt></ruby>と長さ5" class="center" />
<span class="caption">図4-6。<ruby>文字列<rt>ストリング</rt></ruby>スライスの一部を参照する<code>String</code></span>

Rustのでは`..`最初の<ruby>添字<rt>インデックス</rt></ruby>（ゼロ）で開始したい場合は、範囲の構文、次の2つの期間の前に値を<ruby>脱落<rt>ドロップ</rt></ruby>することができます。
換言すれば、これらは等しい。

```rust
let s = String::from("hello");

let slice = &s[0..2];
let slice = &s[..2];
```

同じ字句によって、スライスに`String`最後のバイトが含まれている場合は、末尾の数値を削除できます。
これは、これらが等しいことを意味します。

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

両方の値を<ruby>脱落<rt>ドロップ</rt></ruby>して、<ruby>文字列<rt>ストリング</rt></ruby>全体をスライスすることもできます。
したがって、これらは等しいです。

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> > 注意。<ruby>文字列<rt>ストリング</rt></ruby>スライス範囲の<ruby>添字<rt>インデックス</rt></ruby>は、有効なUTF-8文字縛りで指定する必要があります。
> > マルチバイト文字の途中で<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成しようとすると、<ruby>算譜<rt>プログラム</rt></ruby>は<ruby>誤り<rt>エラー</rt></ruby>で終了します。
> > <ruby>文字列<rt>ストリング</rt></ruby>スライスを導入する目的で、この章でのみASCIIを仮定しています。
> > UTF-8処理の詳細については、第8章の「<ruby>文字列<rt>ストリング</rt></ruby>を使用したUTF-8符号化テキストの保存」を参照してください。

このすべての情報を念頭に置いて、`first_word`を書き換えてスライスを返しましょう。
"string slice"を表す型は`&str`。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

リスト4-7と同じ方法で、単語の終わりの<ruby>添字<rt>インデックス</rt></ruby>を取得します。スペースの最初のオカレンスを探します。
スペースを見つけると、<ruby>文字列<rt>ストリング</rt></ruby>の始まりとスペースの<ruby>添字<rt>インデックス</rt></ruby>を開始と終了の<ruby>添字<rt>インデックス</rt></ruby>として使用して<ruby>文字列<rt>ストリング</rt></ruby>スライスを返します。

今、`first_word`を呼び出すと、基礎となるデータに結びついた単一の値が返されます。
値は、スライスの開始点への参照とスライス内の要素の数で構成されます。

スライスを返すことは、`second_word`機能でも機能します。

```rust,ignore
fn second_word(s: &String) -> &str {
```

<ruby>製譜器<rt>コンパイラー</rt></ruby>は、`String`への参照が有効であることを保証するので、今や簡単なAPIを使いこなすことができます。
リスト4-8の<ruby>算譜<rt>プログラム</rt></ruby>のバグを覚えておいてください。最初の単語の終わりまで<ruby>添字<rt>インデックス</rt></ruby>を取得した後、<ruby>添字<rt>インデックス</rt></ruby>を無効にするために<ruby>文字列<rt>ストリング</rt></ruby>をクリアした場合はどうでしょうか？　
その<ruby>譜面<rt>コード</rt></ruby>は<ruby>論理<rt>ロジック</rt></ruby>的に間違っていましたが、即時の<ruby>誤り<rt>エラー</rt></ruby>は表示されませんでした。
Emptied<ruby>文字列<rt>ストリング</rt></ruby>で最初の単語<ruby>添字<rt>インデックス</rt></ruby>を使用しようとした場合、問題が後で表示されます。
スライスはこのバグを不可能にし、私たちに<ruby>譜面<rt>コード</rt></ruby>の問題がはるかに早いことを知らせます。
`first_word`のスライス版を使用すると、<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が<ruby>送出<rt>スロー</rt></ruby>されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s);

#//    s.clear(); // error!
    s.clear(); // <ruby>誤り<rt>エラー</rt></ruby>！　
}
```

<ruby>製譜器<rt>コンパイラー</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>は次のとおりです。

```text
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
 --> src/main.rs:6:5
  |
4 |     let word = first_word(&s);
  |                            - immutable borrow occurs here
5 |
#//6 |     s.clear(); // error!
6 |     s.clear(); // <ruby>誤り<rt>エラー</rt></ruby>！　
  |     ^ mutable borrow occurs here
7 | }
  | - immutable borrow ends here
```

借用のルールから、何かへの不変な参照があれば、変更可能な参照を取ることができないことを思い出してください。
`clear`は`String`を切り捨てる必要があるため、変更可能な参照を取得しようとしますが、失敗します。
RustはAPIを使いやすくしただけでなく、<ruby>製譜<rt>コンパイル</rt></ruby>時にクラス全体の<ruby>誤り<rt>エラー</rt></ruby>をなくしました！　

#### 文字列<ruby>直書き<rt>リテラル</rt></ruby>はスライスです

<ruby>二進譜<rt>バイナリ</rt></ruby>の内部に格納されている文字列<ruby>直書き<rt>リテラル</rt></ruby>について話したことを思い出してください。
スライスについて知ったので、文字列<ruby>直書き<rt>リテラル</rt></ruby>を正しく理解することができます。

```rust
let s = "Hello, world!";
```

型`s`、ここでは、 `&str`。それは<ruby>二進譜<rt>バイナリ</rt></ruby>の特定のポイントを指し示すスライスです。
これは、文字列<ruby>直書き<rt>リテラル</rt></ruby>が不変である理由です。
`&str`は不変の参照です。

#### パラメータとしての<ruby>文字列<rt>ストリング</rt></ruby>スライス

<ruby>直書き<rt>リテラル</rt></ruby>と`String`値を`first_word`ことができることを知っていると、`first_word`改善が`first_word` 1つあります。それはその署名です。

```rust,ignore
fn first_word(s: &String) -> &str {
```

より経験豊富なRustaceanは、リスト4-9に示すような署名を書くのではなく、`String`値と`&str`値の両方で同じ機能を使うことができるからです。

```rust,ignore
fn first_word(s: &str) -> &str {
```

<span class="caption">リスト4-9。 <code>s</code>パラメータの型に<ruby>文字列<rt>ストリング</rt></ruby>スライスを使用して<code>first_word</code>機能を改善する</span>

<ruby>文字列<rt>ストリング</rt></ruby>スライスがある場合は、それを直接渡すことができます。
持っている場合は`String`、全体のスライス渡すことができます`String`。
`String`への参照の代わりに<ruby>文字列<rt>ストリング</rt></ruby>スライスを取る機能を定義することにより、APIは機能を失うことなくより一般的かつ有用になります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# fn first_word(s: &str) -> &str {
#     let bytes = s.as_bytes();
#
#     for (i, &item) in bytes.iter().enumerate() {
#         if item == b' ' {
#             return &s[0..i];
#         }
#     }
#
#     &s[..]
# }
fn main() {
    let my_string = String::from("hello world");

#    // first_word works on slices of `String`s
    //  first_wordは`String`のスライスで機能します
    let word = first_word(&my_string[..]);

    let my_string_literal = "hello world";

#    // first_word works on slices of string literals
    //  first_wordは文字列<ruby>直書き<rt>リテラル</rt></ruby>のスライスで機能します
    let word = first_word(&my_string_literal[..]);

#    // Because string literals *are* string slices already,
#    // this works too, without the slice syntax!
    // 文字列<ruby>直書き<rt>リテラル</rt></ruby>*は*すでに<ruby>文字列<rt>ストリング</rt></ruby>スライスなので、これもスライス構文なしで動作します！　
    let word = first_word(my_string_literal);
}
```

### その他のスライス

想像の通り、<ruby>文字列<rt>ストリング</rt></ruby>スライスは<ruby>文字列<rt>ストリング</rt></ruby>に固有のものです。
しかし、より一般的なスライス型もあります。
この配列を考えてみましょう。

```rust
let a = [1, 2, 3, 4, 5];
```

<ruby>文字列<rt>ストリング</rt></ruby>の一部を参照したいのと同じように、配列の一部を参照することもできます。
これを次のようにします。

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];
```

このスライスは`&[i32]`型です。
これは、最初の要素と長さへの参照を格納することによって、<ruby>文字列<rt>ストリング</rt></ruby>スライスと同じように動作します。
この種のスライスを、あらゆる種類の他の<ruby>集まり<rt>コレクション</rt></ruby>に使用します。
これらの<ruby>集まり<rt>コレクション</rt></ruby>については、第8章のベクトルについて説明します。

## 概要

所有権、借用、およびスライスの概念は、<ruby>製譜<rt>コンパイル</rt></ruby>時にRust<ruby>算譜<rt>プログラム</rt></ruby>における<ruby>記憶域<rt>メモリー</rt></ruby>の安全性を保証します。
Rust言語は、他のシステム<ruby>演譜<rt>プログラミング</rt></ruby>言語と同じ方法で記憶使用量を制御できますが、所有者が範囲外になったときにデータ所有者がデータを自動的に後始末するということは、追加<ruby>譜面<rt>コード</rt></ruby>を記述したり<ruby>虫取り<rt>デバッグ</rt></ruby>する必要がないこの制御を得ます。

所有権は、Rustの他の部分のどれくらいが影響を受けるのかに影響を及ぼします。そのため、これらの概念については、残りの部分でさらに詳しく説明します。
第5章に進み、`struct`内のデータをまとめてグループ化しましょう。
