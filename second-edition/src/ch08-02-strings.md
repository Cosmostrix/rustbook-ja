## UTF-8で符号化された<ruby>文字列<rt>ストリング</rt></ruby>を格納する

第4章で<ruby>文字列<rt>ストリング</rt></ruby>について説明しましたが、ここではそれらをさらに詳しく見ていきます。
新しい屋根裏部屋は、一般的に、可能性のある<ruby>誤り<rt>エラー</rt></ruby>を表示するためのRustの傾向、<ruby>文字列<rt>ストリング</rt></ruby>が多くの<ruby>演譜師<rt>プログラマー</rt></ruby>よりも複雑なデータ構造であること、そしてUTF-8の3つの理由の組み合わせで<ruby>文字列<rt>ストリング</rt></ruby>に突き当たります。
これらの要素は、他の<ruby>演譜<rt>プログラミング</rt></ruby>言語から来ているときには難しいように見えます。

<ruby>文字列<rt>ストリング</rt></ruby>はバイトの集合として実装されているので、<ruby>集まり<rt>コレクション</rt></ruby>の文脈で<ruby>文字列<rt>ストリング</rt></ruby>を議論すると便利です。さらに、これらのバイトがテキストとして解釈されるときに便利な機能を提供するいくつかの<ruby>操作法<rt>メソッド</rt></ruby>があります。
この章では、作成、更新、および読み込みなど、すべての<ruby>集まり<rt>コレクション</rt></ruby>型に含まれる`String`の操作について説明します。
また、`String`が他の<ruby>集まり<rt>コレクション</rt></ruby>と異なる方法、つまり人と<ruby>計算機<rt>コンピューター</rt></ruby>が`String`データをどのように解釈するかの違いによって、`String`への索引付けがどのように複雑になるかについても説明します。

### <ruby>文字列<rt>ストリング</rt></ruby>とは何でしょうか？　

まず、*<ruby>文字列<rt>ストリング</rt></ruby>*という意味を定義し*ます*。
Rustには、コア言語の<ruby>文字列<rt>ストリング</rt></ruby>型が1つしかありません。これは、通常は借用された形式`&str`で表示される<ruby>文字列<rt>ストリング</rt></ruby>slice `str`です。
第4章では、*<ruby>文字列<rt>ストリング</rt></ruby>スライス*について説明しました。これは、他の場所に格納されているUTF-8で符号化された<ruby>文字列<rt>ストリング</rt></ruby>データへの参照です。
たとえば、文字列<ruby>直書き<rt>リテラル</rt></ruby>は、<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>二進譜<rt>バイナリ</rt></ruby>出力に格納されるため、<ruby>文字列<rt>ストリング</rt></ruby>スライスです。

コア言語に<ruby>譜面<rt>コード</rt></ruby>化されるのではなく、Rustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供される`String`型は、拡張可能で変更可能なUTF-8符号化された<ruby>文字列<rt>ストリング</rt></ruby>型です。
ラステーシャンがRustの "strings"を参照するとき、通常、それらの型の1つだけでなく、`String`とstring slice `&str`型を意味します。
この章では主に`String`について説明しますが、どちらの型もRustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>で頻繁に使用されており、`String`とstringスライスの両方がUTF-8で符号化されています。

Rustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>には、`OsString`、 `OsStr`、 `CString`、 `CStr`などの他の多くの<ruby>文字列<rt>ストリング</rt></ruby>型も含まれてい`CStr`。
<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>ひな型<rt>テンプレート</rt></ruby>は、<ruby>文字列<rt>ストリング</rt></ruby>データを格納するためのさらに多くの<ruby>選択肢<rt>オプション</rt></ruby>を提供します。
それらの名前がす​​べて`String`または`Str`でどのように終わるかを見てください。
それらは、以前に見た`String`型や`str`型と同じように、所有し、借用している<ruby>場合値<rt>バリアント</rt></ruby>を参照します。
これらの<ruby>文字列<rt>ストリング</rt></ruby>型は、異なる符号化でテキストを格納したり、異なる方法で記憶に表現することができます。
この章では、他の<ruby>文字列<rt>ストリング</rt></ruby>型については説明しません。
APIの使用方法とそれぞれが適切な場合のAPI開発資料を参照してください。

### 新しい<ruby>文字列<rt>ストリング</rt></ruby>の作成

リスト8-11に示すように、`Vec<T>`利用可能な同じ操作の多くは、<ruby>文字列<rt>ストリング</rt></ruby>を作成する`new`機能から始めて、`String`でも使用できます。

```rust
let mut s = String::new();
```

<span class="caption">リスト8-11。新しい空文字<code>String</code>作成</span>

この行は、`s`という新しい空<ruby>文字列<rt>ストリング</rt></ruby>を作成し、データを読み込むことができます。
多くの場合、<ruby>文字列<rt>ストリング</rt></ruby>を開始する初期データがあります。
そのためには、`to_string`<ruby>操作法<rt>メソッド</rt></ruby>を使用します。これは、文字列<ruby>直書き<rt>リテラル</rt></ruby>のように、`Display`<ruby>特性<rt>トレイト</rt></ruby>を実装するすべての型で使用できます。
リスト8-12に2つの例を示します。

```rust
let data = "initial contents";

let s = data.to_string();

#// the method also works on a literal directly:
// この<ruby>操作法<rt>メソッド</rt></ruby>は<ruby>直書き<rt>リテラル</rt></ruby>でも直接動作します。
let s = "initial contents".to_string();
```

<span class="caption">リスト8-12。 <code>to_string</code>操作法を使って<code>String</code>列<ruby>直書き<rt>リテラル</rt></ruby>から<ruby>文字列<rt>ストリング</rt></ruby>を作成する</span>

この<ruby>譜面<rt>コード</rt></ruby>は、`initial contents`を含む<ruby>文字列<rt>ストリング</rt></ruby>を作成します。

`String::from`機能を使用して、文字列<ruby>直書き<rt>リテラル</rt></ruby>から`String`を作成することもできます。
リスト8-13の<ruby>譜面<rt>コード</rt></ruby>は、`to_string`を使用する<ruby>譜面<rt>コード</rt></ruby>8-12の<ruby>譜面<rt>コード</rt></ruby>に相当します。

```rust
let s = String::from("initial contents");
```

<span class="caption">リスト8-13。 <code>String::from</code>機能を使って<code>String</code>列<ruby>直書き<rt>リテラル</rt></ruby>から<ruby>文字列<rt>ストリング</rt></ruby>を作成する</span>

<ruby>文字列<rt>ストリング</rt></ruby>は非常に多くのものに使用されているため、<ruby>文字列<rt>ストリング</rt></ruby>にはさまざまな汎用APIを使用でき、多くの<ruby>選択肢<rt>オプション</rt></ruby>が用意されています。
それらのいくつかは冗長に見えるかもしれませんが、それらはすべて自分の場所を持っています！　
この場合、`String::from`と`to_string`は同じことを行います。したがって、選択するのは作法の問題です。

<ruby>文字列<rt>ストリング</rt></ruby>はUTF-8で符号化されているので、リスト8-14に示すように、適切に符号化されたデータを符号化することができます。

```rust
let hello = String::from("السلام عليكم");
let hello = String::from("Dobrý den");
let hello = String::from("Hello");
let hello = String::from("שָׁלוֹם");
let hello = String::from("नमस्ते");
let hello = String::from("こんにちは");
let hello = String::from("안녕하세요");
let hello = String::from("你好");
let hello = String::from("Olá");
let hello = String::from("Здравствуйте");
let hello = String::from("Hola");
```

<span class="caption">リスト8-14。<ruby>文字列<rt>ストリング</rt></ruby>内の異なる言語でのグリーティングの保存</span>

これらはすべて有効な`String`値です。

### <ruby>文字列<rt>ストリング</rt></ruby>の更新

`Vec<T>`内容と同じように、`String`サイズが大きくなり、その内容が変更される可能性があります。
さらに、`+`演算子または`format!`マクロを使用すると、`String`値を連結することができます。

#### `push_str`と`push`<ruby>文字列<rt>ストリング</rt></ruby>に`push_str` `push`

リスト8-15に示すように、`push_str`<ruby>操作法<rt>メソッド</rt></ruby>を使用して<ruby>文字列<rt>ストリング</rt></ruby>スライスを追加することによって、`String`を`push_str`できます。

```rust
let mut s = String::from("foo");
s.push_str("bar");
```

<span class="caption">リスト8-15。に<ruby>文字列<rt>ストリング</rt></ruby>スライス追加は<code>String</code>使用して<code>push_str</code>方法を</span>

この2行の後、`s`含まれています`foobar`。
`push_str`<ruby>操作法<rt>メソッド</rt></ruby>は、必ずしもパラメータの所有権を取得する必要がないため、<ruby>文字列<rt>ストリング</rt></ruby>スライスを使用します。
例えば、リスト8-16の<ruby>譜面<rt>コード</rt></ruby>は、`s1`内容を追加した後に`s2`を使用できなかった場合、残念であることを示しています。

```rust
let mut s1 = String::from("foo");
let s2 = "bar";
s1.push_str(s2);
println!("s2 is {}", s2);
```

<span class="caption">リスト8-16。にその内容を付加した後、<ruby>文字列<rt>ストリング</rt></ruby>のスライスを使用して<code>String</code></span>

`push_str`<ruby>操作法<rt>メソッド</rt></ruby>が`s2`所有権を取得した場合、最後の行にその値を出力することはできません。
しかし、この<ruby>譜面<rt>コード</rt></ruby>は期待どおりに動作します！　

`push`<ruby>操作法<rt>メソッド</rt></ruby>は、パラメータとして単一の文字を取り、それを`String`追加します。
リスト8-17は`push`<ruby>操作法<rt>メソッド</rt></ruby>を使って文字*l*を`String`追加する<ruby>譜面<rt>コード</rt></ruby>を示しています。

```rust
let mut s = String::from("lo");
s.push('l');
```

<span class="caption">リスト8-17。 <code>push</code>を使って<code>String</code>値に文字を1つ追加する</span>

この<ruby>譜面<rt>コード</rt></ruby>の結果、`s`には`lol`が含まれます。

#### `+`演算子または`format!`マクロとの連結

しばしば、2つの既存の<ruby>文字列<rt>ストリング</rt></ruby>を結合したいと思うでしょう。
1つの方法は、リスト8-18に示すように、`+`演算子を使用することです。

```rust
let s1 = String::from("Hello, ");
let s2 = String::from("world!");
#//let s3 = s1 + &s2; // note s1 has been moved here and can no longer be used
let s3 = s1 + &s2; //  note s1はここに移動されており、使用できなくなりました
```

<span class="caption">リスト8-18。 <code>+</code>演算子を使って2つの<code>String</code>値を新しい<code>String</code>値に結合する</span>

<ruby>文字列<rt>ストリング</rt></ruby>`s3`は、この<ruby>譜面<rt>コード</rt></ruby>の結果として`Hello, world!`が含まれます。
理由は、`s1`が加算の後にもはや有効でなく、`s2`への参照を使用した理由が、`+`演算子を使用したときに呼び出される<ruby>操作法<rt>メソッド</rt></ruby>の型注釈と関係があるためです。
`+`演算子は`add`<ruby>操作法<rt>メソッド</rt></ruby>を使用します。その署名は次のようになります。

```rust,ignore
fn add(self, s: &str) -> String {
```

これは標準<ruby>譜集<rt>ライブラリー</rt></ruby>にある正確な署名ではありません。標準<ruby>譜集<rt>ライブラリー</rt></ruby>では、`add`は総称化を使って定義されています。
ここでは、genericの代わりに具体的な型`add`持つ`add`の型注釈を見ています。これは、この<ruby>操作法<rt>メソッド</rt></ruby>を`String`値で呼び出すときに起こります。
第10章で総称化について説明します。この型注釈は、`+`演算子のトリッキーなビットを理解するために必要な手がかりを与えます。

まず、`s2`持っている`&`最初の<ruby>文字列<rt>ストリング</rt></ruby>に2番目の<ruby>文字列<rt>ストリング</rt></ruby>の*参照*追加していることを意味し、`s`中のパラメータ`add`機能を。我々だけ追加することができます`&str`に`String`。
2つの`String`値を一緒に追加することはできません。
しかし、待って-の型`&s2`ある`&String`ではない、`&str`ための2番目のパラメータで指定されているように、`add`。
なぜ、リスト8-18は<ruby>製譜<rt>コンパイル</rt></ruby>されますか？　

`add`の呼び出しで`&s2`を使用できる理由は、<ruby>製譜器<rt>コンパイラー</rt></ruby>が`&String`引数を`&str` *強制型変換*することができるためです。
`add`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すと、Rustは*deref強制型変換を*使用し`&s2[..]`ここで`&s2`は`&s2[..]`ます。
ので、第15章で詳しく被参照強制型変換を説明します`add`所有取らない`s`パラメータを、`s2`まだ有効になります`String`この操作の後。

次に、型注釈では、`add`は`self`所有権があることがわかります。`self`は`&`が*ない*ためです。
これは、リスト8-18の`s1`が`add`呼び出しに移動され、その後は有効ではなくなることを意味します。
だから`let s3 = s1 + &s2;`
両方の<ruby>文字列<rt>ストリング</rt></ruby>をコピーして新しいものを作成するように見えますが、この文は実際に`s1`所有権を持ち、`s2`の内容のコピーを追加してから、結果の所有権を返します。
言い換えれば、それはコピーをたくさん作っているように見えますが、そうではありません。
実装はコピーよりも効率的です。

複数の<ruby>文字列<rt>ストリング</rt></ruby>を連結する必要がある場合、`+`演算子の動作は扱いにくくなります。

```rust
let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");

let s = s1 + "-" + &s2 + "-" + &s3;
```

この時点で、`s`は`tic-tac-toe`ます。
すべてに`+`と`"`の文字、それは何が起こっているかを見ることは困難だより複雑な<ruby>文字列<rt>ストリング</rt></ruby>を組み合わせることについて、使用することができます。`format!`マクロを。

```rust
let s1 = String::from("tic");
let s2 = String::from("tac");
let s3 = String::from("toe");

let s = format!("{}-{}-{}", s1, s2, s3);
```

この<ruby>譜面<rt>コード</rt></ruby>では、`s`を`tic-tac-toe`ます。
`format!`マクロは`println!`と同じように動作しますが、出力を画面に出力するのではなく、内容を含む`String`を返します。
`format!`を使用した<ruby>譜面<rt>コード</rt></ruby>の版は読みやすく、そのパラメータの所有権を取得しません。

### <ruby>文字列<rt>ストリング</rt></ruby>への索引付け

他の多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語では、<ruby>文字列<rt>ストリング</rt></ruby>内の個々の文字に<ruby>添字<rt>インデックス</rt></ruby>で参照してアクセスすることは、有効かつ一般的な操作です。
ただし、Rustの<ruby>添字<rt>インデックス</rt></ruby>構文を使用して`String`一部にアクセスしようとすると、<ruby>誤り<rt>エラー</rt></ruby>が発生します。
リスト8-19の無効な<ruby>譜面<rt>コード</rt></ruby>を考えてみましょう。

```rust,ignore
let s1 = String::from("hello");
let h = s1[0];
```

<span class="caption">譜面リスト8-19。<ruby>文字列<rt>ストリング</rt></ruby>で<ruby>添字<rt>インデックス</rt></ruby>構文を使用しようとする</span>

この<ruby>譜面<rt>コード</rt></ruby>では、次の<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0277]: the trait bound `std::string::String: std::ops::Index<{integer}>` is not satisfied
 -->
  |
3 |     let h = s1[0];
  |             ^^^^^ the type `std::string::String` cannot be indexed by `{integer}`
  |
  = help: the trait `std::ops::Index<{integer}>` is not implemented for `std::string::String`
```

<ruby>誤り<rt>エラー</rt></ruby>とノートはストーリーに伝えます。Rust<ruby>文字列<rt>ストリング</rt></ruby>は<ruby>添字<rt>インデックス</rt></ruby>作成をサポートしていません。
しかし、どうしてでしょうか？　
その質問に答えるために、Rustが<ruby>文字列<rt>ストリング</rt></ruby>を記憶にどのように格納するかについて議論する必要があります。

#### 内部表現

`String`は、`Vec<u8>`上のの包みです。
リスト8-14の適切に符号化されたUTF-8のサンプル・<ruby>文字列<rt>ストリング</rt></ruby>のいくつかを見てみましょう。
まず、この1つ。

```rust
let len = String::from("Hola").len();
```

この場合、`len`は4になります。これは、<ruby>文字列<rt>ストリング</rt></ruby> "Hola"を格納するベクトルが4バイト長であることを意味します。
これらの文字のそれぞれは、UTF-8で符号化されたときに1バイトをとります。
しかし、次の行はどうでしょうか？　
（この<ruby>文字列<rt>ストリング</rt></ruby>は、アラビア数字3ではなく、キリル文字Zeで始まることに注意してください。）

```rust
let len = String::from("Здравствуйте").len();
```

しかし、Rustの答えは24です。これは、Unicodeの各スカラー値が2バイトの<ruby>記憶域<rt>メモリー</rt></ruby>を必要とするため、UTF-8で符号化するのに必要なバイト数です。
したがって、<ruby>文字列<rt>ストリング</rt></ruby>のバイトへの<ruby>添字<rt>インデックス</rt></ruby>は、有効なUnicodeスカラー値と必ずしも相関しません。
実証するために、この無効なRustの<ruby>譜面<rt>コード</rt></ruby>を考えてみましょう。

```rust,ignore
let hello = "Здравствуйте";
let answer = &hello[0];
```

`answer`の価値はどうあるべきでしょうか？　
それがあるべき`З`、最初の文字？　
UTF-8で符号化されている場合、`З`の最初のバイトは`208`で、2番目のバイトは`151`なので、`answer`は実際には`208`でなければなりませんが、`208`はそれ自体で有効な文字ではありません。
`208`返すことは、利用者がこの<ruby>文字列<rt>ストリング</rt></ruby>の最初の文字を尋ねた場合、利用者が望むものではない可能性があります。
しかし、これはRustがバイト<ruby>添字<rt>インデックス</rt></ruby>0で持つ唯一のデータです。<ruby>文字列<rt>ストリング</rt></ruby>にラテン文字のみが含まれていても、利用者は一般的に返されるバイト値を望ましくありません。 `&"hello"[0]`がバイト値を返す有効な<ruby>譜面<rt>コード</rt></ruby>それは`h`ではなく`104`を返します。
予期しない値を返さず、直ちに発見されない可能性のあるバグを引き起こさないように、Rustはこの<ruby>譜面<rt>コード</rt></ruby>をまったく<ruby>製譜<rt>コンパイル</rt></ruby>せず、開発過程の初期段階で誤解を防止します。

#### バイトとスカラの値とグレーフェームクラスタ！　
UTF-8についてのもう一つの点は、実際には、Rustの観点から<ruby>文字列<rt>ストリング</rt></ruby>をバイト、スカラー値、および<ruby>文字列<rt>ストリング</rt></ruby>クラスター（*文字*と呼んで*いる*ものに最も近いもの）として見るための3つの関連する方法があるということです。

Devanagari<ruby>台譜<rt>スクリプト</rt></ruby>で書かれたヒンディー語の "नमस्ते"を見ると、次のような`u8`値のベクトルとして格納されます。

```text
[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164,
224, 165, 135]
```

これは18バイトで、<ruby>計算機<rt>コンピューター</rt></ruby>が最終的にこのデータをどのように格納するかです。
Rustの`char`型であるUnicodeのスカラー値として見れば、これらのバイトは次のようになります。

```text
['न', 'म', 'स', '्', 'त', 'े']
```

ここには6つの`char`値がありますが、4番目と6番目の文字は文字ではありません。それは独自の意味を持たない発音区別記号です。
最後に、それらを書記官クラスターとして見ると、ヒンディー語を構成する4つの文字を人が何と呼ぶか​​を知ることができます。

```text
["न", "म", "स्", "ते"]
```

Rustは、データがどのような人間言語であっても、各<ruby>算譜<rt>プログラム</rt></ruby>が必要とする解釈を選択できるように、<ruby>計算機<rt>コンピューター</rt></ruby>が格納する生の<ruby>文字列<rt>ストリング</rt></ruby>データを解釈するさまざまな方法を提供します。

Rustが`String`を取得するために文字`String`に<ruby>添字<rt>インデックス</rt></ruby>を付けることができないという最終的な理由は、<ruby>添字<rt>インデックス</rt></ruby>処理が常に一定の時間（O（1））を取ることが予想されることです。
しかし、`String`でそのパフォーマンスを保証することはできません。なぜなら、有効な文字がいくつあるのかを判断するために、Rustは最初から最後まで内容を調べなければならないからです。

### スライシング<ruby>文字列<rt>ストリング</rt></ruby>

<ruby>文字列<rt>ストリング</rt></ruby>インデクシング操作の戻り値の型は、バイト値、文字、グラフェンクラスター、または<ruby>文字列<rt>ストリング</rt></ruby>スライスのどれであるべきかが明確でないため、<ruby>文字列<rt>ストリング</rt></ruby>への<ruby>添字<rt>インデックス</rt></ruby>付けはしばしば悪い考えです。
したがって、実際に<ruby>添字<rt>インデックス</rt></ruby>を使用して<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成する必要がある場合、Rustはより具体的になるように指示します。
より具体的に<ruby>添字<rt>インデックス</rt></ruby>を作成し、<ruby>文字列<rt>ストリング</rt></ruby>スライスが必要であることを示すには、`[]`を単一の数字で<ruby>添字<rt>インデックス</rt></ruby>するのではなく、`[]`で範囲を指定して特定のバイトを含む<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成します。

```rust
let hello = "Здравствуйте";

let s = &hello[0..4];
```

ここで、`s`は`&str`の最初の4バイトを含む`&str`になります。
以前は、これらの文字のそれぞれが2バイトであることを述べ`Зд`。これは、 `s`が`Зд`であることを意味します。

`&hello[0..1]`を使用するとどうなりますか？　
答え。ベクトルで無効な<ruby>添字<rt>インデックス</rt></ruby>がアクセスされたのと同じ方法で、実行時にRustがパニックに陥る。

```text
thread 'main' panicked at 'byte index 1 is not a char boundary; it is inside 'З' (bytes 0..2) of `Здравствуйте`', src/libcore/str/mod.rs:2188:4
```

<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成するには、<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>異常終了<rt>クラッシュ</rt></ruby>させる可能性があるため、範囲を使用して慎重に<ruby>文字列<rt>ストリング</rt></ruby>スライスを作成する必要があります。

### オーバー<ruby>文字列<rt>ストリング</rt></ruby>反復法

幸い、<ruby>文字列<rt>ストリング</rt></ruby>内の要素には他の方法でアクセスできます。

個々のUnicodeスカラ値に対して操作を実行する必要がある場合は、`chars`<ruby>操作法<rt>メソッド</rt></ruby>を使用するのが最善の方法です。
"नमस्ते"の`chars`を呼び出すと、`char`型の6つの値が返され、結果を繰り返して各要素にアクセスできます。

```rust
for c in "नमस्ते".chars() {
    println!("{}", c);
}
```

この<ruby>譜面<rt>コード</rt></ruby>は以下を出力します。

```text
न
म
स
्
त
े
```

`bytes`<ruby>操作法<rt>メソッド</rt></ruby>は、生の各`bytes`を返します。これは、特定領域に適しています。

```rust
for b in "नमस्ते".bytes() {
    println!("{}", b);
}
```

この<ruby>譜面<rt>コード</rt></ruby>は、この`String`を構成する18バイトを出力します。

```text
224
164
#// --snip--
//  --snip--
165
135
```

しかし、有効なUnicodeスカラ値は1バイト以上で構成されることを覚えておいてください。

<ruby>文字列<rt>ストリング</rt></ruby>から書記素クラスタを得ることは複雑なので、この機能は標準<ruby>譜集<rt>ライブラリー</rt></ruby>では提供されていません。
これが必要とする機能性のものであれば、[crates.io](https://crates.io) Cratesを利用できます。

### <ruby>文字列<rt>ストリング</rt></ruby>は単純ではありません

まとめると、<ruby>文字列<rt>ストリング</rt></ruby>は複雑です。
異なる<ruby>演譜<rt>プログラミング</rt></ruby>言語は、この複雑さをどのように<ruby>演譜師<rt>プログラマー</rt></ruby>に提示するかについて異なる選択をします。
Rustは、すべてのRust<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>の動作である`String`データの正しい処理を行うことを選択しました。これは、<ruby>演譜師<rt>プログラマー</rt></ruby>がUTF-8データを先に処理することをもっと考慮する必要があることを意味します。
この<ruby>相殺取引<rt>トレードオフ</rt></ruby>は、他の<ruby>演譜<rt>プログラミング</rt></ruby>言語よりも複雑な<ruby>文字列<rt>ストリング</rt></ruby>を提供しますが、開発ライフ円環の後半で非ASCII文字を含む<ruby>誤り<rt>エラー</rt></ruby>を処理する必要がなくなります。

ちょっと複雑ではないものに切り替えることができます。ハッシュマップ！　
