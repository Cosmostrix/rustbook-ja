## 寿命による参照の検証

第4章の「参考資料と貸出」の章で説明していない1つの詳細は、Rust内のすべての参照は、その参照が有効な範囲である*寿命を*有することです。
ほとんどの場合、寿命は暗黙的に推論され、ほとんどの場合と同様に型が推論されます。
複数の型が可能な場合、型に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があります。
同様の方法で、参照の存続期間がいくつかの異なる方法で関連する可能性がある場合、寿命に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があります。
Rustでは、実行時に使用される実際の参照が確実に有効であることを保証するために、一般的な有効期間パラメータを使用して関係に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があります。

寿命の概念は、他の<ruby>演譜<rt>プログラミング</rt></ruby>言語の道具とは多少異なります。間違いなく、Rustの最も特徴的な機能です。
この章では、寿命全体については触れませんが、寿命の構文に遭遇する可能性のある一般的な方法について説明し、概念に慣れることができます。
詳細については、第19章の「発展的な寿命」の項を参照してください。

### 寿命を参照する行方不明のの防止

生存時間の主な目的は、参照することを意図したデータ以外のデータを<ruby>算譜<rt>プログラム</rt></ruby>が参照させる行方不明の参照を防止することです。
外側<ruby>有効範囲<rt>スコープ</rt></ruby>と内側<ruby>有効範囲<rt>スコープ</rt></ruby>を持つリスト10-17の<ruby>算譜<rt>プログラム</rt></ruby>を考えてみましょう。

```rust,ignore
{
    let r;

    {
        let x = 5;
        r = &x;
    }

    println!("r: {}", r);
}
```

<span class="caption">リスト10-17。値が<ruby>有効範囲<rt>スコープ</rt></ruby>外にある参照を使用しようとした</span>

> > 注。リスト10-17,10-18、および10-24の例では、変数に初期値を指定せずに変数を宣言しているため、変数名は外部<ruby>有効範囲<rt>スコープ</rt></ruby>に存在します。
> > 一見すると、この値はヌル値を持たないRustと競合しているように見えるかもしれません。
> > しかし、変数に値を渡す前に変数を使用しようとすると、<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が発生します。これは、Rustが実際にnull値を許可しないことを示しています。

外側<ruby>有効範囲<rt>スコープ</rt></ruby>は`r`という名前の変数を初期値なしで宣言し、内側<ruby>有効範囲<rt>スコープ</rt></ruby>は`x`という名前の変数を初期値5で宣言します。内側<ruby>有効範囲<rt>スコープ</rt></ruby>内で、`r`の値を`x`への参照として設定しようとします。
内側の<ruby>有効範囲<rt>スコープ</rt></ruby>は終了し、`r`値を出力しようとします。
値`r`が参照を参照しているため、この<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。使用する前に<ruby>有効範囲<rt>スコープ</rt></ruby>外になっています。
<ruby>誤り<rt>エラー</rt></ruby>メッセージは次のとおりです。

```text
error[E0597]: `x` does not live long enough
  --> src/main.rs:7:5
   |
6  |         r = &x;
   |              - borrow occurs here
7  |     }
   |     ^ `x` dropped here while still borrowed
...
10 | }
   | - borrowed value needs to live until here
```

変数`x`は "十分に長く生きていません"。なぜなら、内部<ruby>有効範囲<rt>スコープ</rt></ruby>が7行目で終了すると、`x`は<ruby>有効範囲<rt>スコープ</rt></ruby>から外れるからです。しかし、`r`はまだ外側<ruby>有効範囲<rt>スコープ</rt></ruby>に対して有効です。
その範囲が大きいのでRustはこの<ruby>譜面<rt>コード</rt></ruby>が動作するように許可されている場合、それが「長く住んでいます。」と言い、`r`時に割り当て解除された記憶参照されるだろう`x`<ruby>有効範囲<rt>スコープ</rt></ruby>外に行ってきましたが、して実行しようとしました何も`r`動作しません正しく
では、Rustはこの<ruby>譜面<rt>コード</rt></ruby>が無効であるとどのように判断しますか？　
それは借用検査器を使用します。

### 借用検査器

Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>には、<ruby>有効範囲<rt>スコープ</rt></ruby>を比較してすべての借用が有効かどうかを判断する*借用検査器*があります。
<ruby>譜面<rt>コード</rt></ruby>リスト10-18は、<ruby>譜面<rt>コード</rt></ruby>リスト10-17と同じ<ruby>譜面<rt>コード</rt></ruby>を示していますが、<ruby>注釈<rt>コメント</rt></ruby>には変数の存続期間が表示されています。

```rust,ignore
{
#//    let r;                // ---------+-- 'a
#                          //          |
    let r;                //  ---------+ -'a |
#//    {                     //          |
    {                     //  |
#//        let x = 5;        // -+-- 'b  |
        let x = 5;        //  -+ -'b |
#//        r = &x;           //  |       |
        r = &x;           //  | |
#//    }                     // -+       |
#                          //          |
    }                     //  -+ | |
#//    println!("r: {}", r); //          |
    println!("r: {}", r); //  |
#//}                         // ---------+
}                         //  ---------+
```

<span class="caption">リスト10-18。それぞれ<code>'b</code>と<code>'b</code>という名前<code>'a</code> <code>r</code>と<code>x</code>生存時間の注釈</span>

ここでは、`r`の寿命に`'b`と`'b` `x`の寿命`'a`と<ruby>注釈<rt>コメント</rt></ruby>をつけた。
見ることができるように、内側の`'b`<ruby>段落<rt>ブロック</rt></ruby>`'a`外側`'a`<ruby>段落<rt>ブロック</rt></ruby>`'a`よりもはるかに小さいです。
<ruby>製譜<rt>コンパイル</rt></ruby>時に、Rustは2つの寿命のサイズを比較し、`r`の寿命が`'a`が、それは`'b`寿命を持つ記憶を参照することを確認します。
ので、<ruby>算譜<rt>プログラム</rt></ruby>が拒否される`'b`より短い`'a`。参照の主題は限り基準に住んでいません。

<ruby>譜面<rt>コード</rt></ruby>リスト10-19は<ruby>譜面<rt>コード</rt></ruby>を修正して、ダグリング参照がなく、<ruby>誤り<rt>エラー</rt></ruby>なく<ruby>製譜<rt>コンパイル</rt></ruby>します。

```rust
{
#//    let x = 5;            // ----------+-- 'b
#                          //           |
    let x = 5;            //  ----------+ -'b |
#//    let r = &x;           // --+-- 'a  |
#                          //   |       |
    let r = &x;           //  -+ -'a | | |
#//    println!("r: {}", r); //   |       |
#                          // --+       |
    println!("r: {}", r); //  | | -+ |
#//}                         // ----------+
}                         //  ----------+
```

<span class="caption">譜面リスト10-19。データの参照寿命より長いため、有効な参照</span>

ここで、`x`寿命有する`'b`この場合、より大きく、`'a`。
これは、`r`参照できる`x`Rustがで参照することを知っているので`r`一方で常に有効になり`x`有効です。

参照の存続期間と、Rustが寿命をどのように分析して参照が常に有効になるかを知ったので、機能の文脈でパラメータと戻り値の一般的な寿命を調べてみましょう。

### 機能の一般的な寿命

2つの<ruby>文字列<rt>ストリング</rt></ruby>スライスのうち長い方を返す機能を記述しましょう。
この機能は、2つの<ruby>文字列<rt>ストリング</rt></ruby>スライスを取り、<ruby>文字列<rt>ストリング</rt></ruby>スライスを返します。
`longest`機能を実装した後、<ruby>譜面<rt>コード</rt></ruby>リスト10-20の<ruby>譜面<rt>コード</rt></ruby>で`The longest string is abcd`です。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let string1 = String::from("abcd");
    let string2 = "xyz";

    let result = longest(string1.as_str(), string2);
    println!("The longest string is {}", result);
}
```

<span class="caption">リスト10-20。2つの<ruby>文字列<rt>ストリング</rt></ruby>スライスのうち<code>longest</code>ものを見つけるために<code>longest</code>機能を呼び出す<code>main</code>機能</span>

`longest`機能がそのパラメータの所有権を奪うことは望ましくないので、機能は参照である<ruby>文字列<rt>ストリング</rt></ruby>スライスを取ることを望むことに注意してください。
`String`列<ruby>直書き<rt>リテラル</rt></ruby>（変数`string2`含まれるもの）だけでなく、<ruby>文字列<rt>ストリング</rt></ruby>（変数`string1`格納されている型）のスライスを受け入れる機能を許可したい。

リスト10-20で使用するパラメータがなぜ必要なのかについては、第4章の「パラメータとしての<ruby>文字列<rt>ストリング</rt></ruby>スライス」を参照してください。

リスト10-21に示すように`longest`機能を実装しようとすると、<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

<span class="caption">リスト10-21。長い2つの<ruby>文字列<rt>ストリング</rt></ruby>スライスを返しますが、まだ<ruby>製譜<rt>コンパイル</rt></ruby>していない<code>longest</code>機能の実装</span>

代わりに、寿命について語る以下の<ruby>誤り<rt>エラー</rt></ruby>を受け取ります。

```text
error[E0106]: missing lifetime specifier
 --> src/main.rs:1:33
  |
1 | fn longest(x: &str, y: &str) -> &str {
  |                                 ^ expected lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but the
signature does not say whether it is borrowed from `x` or `y`
```

手引きテキストは、返された参照が`x`または`y`を参照しているかどうかをRustが知ることができないため、戻り値の型に汎用の寿命パラメータが必要であることを示しています。
実際には、この機能の本体の`if`<ruby>段落<rt>ブロック</rt></ruby>は`x`への参照を返し、`else`<ruby>段落<rt>ブロック</rt></ruby>は`y`への参照を返すので、どちらも知らない。

この機能を定義するとき、この機能に渡す具体的な値はわからないので、`if` caseか`else` caseが実行されるかどうかはわかりません。
また、渡される参照の具体的な存続期間もわからないため、リスト10-18および10-19で行ったように<ruby>有効範囲<rt>スコープ</rt></ruby>を見ることができず、返す参照が常に有効かどうかが判断されます。
`x`と`y`の存続期間が返り値の存続期間にどのように関係しているか分からないため、借用検査器はこれを判別することができません。
この<ruby>誤り<rt>エラー</rt></ruby>を修正するために、借用検査器が分析を実行できるように、参照間の関係を定義する一般的な有効期間パラメーターを追加します。

### 寿命の<ruby>注釈<rt>コメント</rt></ruby>構文

寿命の<ruby>注釈<rt>コメント</rt></ruby>は参照の存続期間を変更しません。
型注釈が総称型パラメータを指定するときに機能が任意の型を受け入れるのと同じように、機能は総称化な寿命パラメータを指定することで、任意の寿命の参照を受け入れることができます。
寿命<ruby>補注<rt>アノテーション</rt></ruby>は、寿命に影響を与えることなく、複数の参照の寿命の相互関係を記述します。

寿命の<ruby>注釈<rt>コメント</rt></ruby>には少し珍しい構文があります。寿命パラメータの名前はアポストロフィ（`'`）で始まり、通常は総称型のように小文字で非常に短いものです。
ほとんどの人は`'a`。
参照の型から<ruby>注釈<rt>コメント</rt></ruby>を区切るためのスペースを使用して、参照の`&`の後に寿命パラメータ<ruby>注釈<rt>コメント</rt></ruby>を置きます。

ここではいくつかの例です。への参照`i32`寿命パラメータなしで、参照`i32`という名前の寿命パラメータを持っている`'a`とに変更可能な参照`i32`も寿命があります`'a`。

```rust,ignore
#//&i32        // a reference
&i32        // 参照
#//&'a i32     // a reference with an explicit lifetime
&'a i32     // 明示的な存続期間を持つ参照
#//&'a mut i32 // a mutable reference with an explicit lifetime
&'a mut i32 // 明示的な存続期間を持つ変更可能な参照
```

Rustに、複数の参照の一般的な有効期間パラメータが互いにどのように関連しているかを示すために、1つの寿命<ruby>注釈<rt>コメント</rt></ruby>だけでは意味がありません。
たとえば、寿命が`'a` `i32`への参照であるパラメータ`first`を持つ機能があるとします。
また、この機能には`second`という名前の別のパラメータがあります。このパラメータは、寿命`'a`持つ`i32`別の参照です。
寿命の<ruby>注釈<rt>コメント</rt></ruby>は、`first`および`second`の参照がその一般的な寿命の両方で存続しなければならないことを示しています。

### 関数型注釈の寿命<ruby>補注<rt>アノテーション</rt></ruby>

次に、`longest`機能の文脈で寿命の<ruby>注釈<rt>コメント</rt></ruby>を調べてみましょう。
総称型パラメータの場合と同様に、機能名とパラメータリストの間に角かっこで囲んだ総称化寿命パラメータを宣言する必要があります。
この型注釈で表現したい制約は、パラメータ内のすべての参照と戻り値の寿命が同じでなければならないということです。
リスト10-22に示すように、ライフ・タイムに`'a`名前をつけ、それを各参照に追加します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

<span class="caption">リスト10-22。署名のすべての参照が同じ寿命を持つ必要があることを指定する<code>longest</code>機能定義<code>'a</code></span>

この<ruby>譜面<rt>コード</rt></ruby>は、リスト10-20の`main`機能で使用するときに、必要な結果を<ruby>製譜<rt>コンパイル</rt></ruby>して生成する必要があります。

関数型注釈`'a`、生存時間`'a`に対して、機能は2つのパラメータをとります。どちらも少なくとも寿命`'a`長さと同じ長さの<ruby>文字列<rt>ストリング</rt></ruby>スライスです。
機能の型注釈は、機能から返された<ruby>文字列<rt>ストリング</rt></ruby>スライスが少なくとも寿命`'a`長さで存続することをRustに伝えます。
これらの制約は、Rustに要求しているものです。
この関数型注釈で寿命パラメータを指定するとき、渡された値または返された値の有効期間は変更されません。
むしろ、借用検査器がこれらの制約に従わない値を拒否するように指定しています。
`longest`機能は、`x`と`y`がどのくらい長く生きるかを正確に知る必要はなく、この型注釈を満たす`'a`代わりにいくつかの<ruby>有効範囲<rt>スコープ</rt></ruby>しか使えないことに注意してください。

機能の生存時間に<ruby>注釈<rt>コメント</rt></ruby>を付けるとき、<ruby>注釈<rt>コメント</rt></ruby>は機能の本体ではなく機能の型注釈に入ります。
Rustは、助けを借用ずに機能内の<ruby>譜面<rt>コード</rt></ruby>を分析することができます。
しかし、ある機能がその機能の外にある<ruby>譜面<rt>コード</rt></ruby>を参照したり、その機能の外にある<ruby>譜面<rt>コード</rt></ruby>から参照を受け取ったりすると、Rustはパラメータの存続期間や独自の戻り値を把握することがほとんど不可能になります。
機能が呼び出されるたびに寿命が異なる場合があります。
このため、寿命に手動で<ruby>注釈<rt>コメント</rt></ruby>を付ける必要があります。

具体的な参照を`longest`渡すと、`'a`と置き換えられる具体的な存続期間は、`y`の範囲と重なる`x`の範囲の一部です。
言い換えれば、一般的な寿命が`'a`の寿命の小さい方に等しい具体的な寿命を取得します`x`と`y`。
返された参照に同じ寿命パラメータ`'a`ので、返された参照も`x`と`y`寿命のうち小さい方の長さに対して有効になります。

寿命の<ruby>注釈<rt>コメント</rt></ruby>が、異なる具体的な寿命を持つ参照を渡すことによって、`longest`機能を制限する方法を見てみましょう。
リスト10-23は簡単な例です。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
#     if x.len() > y.len() {
#         x
#     } else {
#         y
#     }
# }
#
fn main() {
    let string1 = String::from("long string is long");

    {
        let string2 = String::from("xyz");
        let result = longest(string1.as_str(), string2.as_str());
        println!("The longest string is {}", result);
    }
}
```

<span class="caption">リスト10-23。 <code>longest</code>機能を使用して、具体的な寿命が異なる<code>String</code>値への参照</span>

この例では、`string1`は外側の<ruby>有効範囲<rt>スコープ</rt></ruby>の終わりまで有効であり、`string2`は内側の<ruby>有効範囲<rt>スコープ</rt></ruby>の終わりまで有効であり、`result`は内側の<ruby>有効範囲<rt>スコープ</rt></ruby>の終わりまで有効なものを参照します。
この<ruby>譜面<rt>コード</rt></ruby>を実行すると、借用検査器がこの<ruby>譜面<rt>コード</rt></ruby>を承認していることがわかります。
<ruby>製譜<rt>コンパイル</rt></ruby>して<ruby>印字<rt>プリント</rt></ruby>します`The longest string is long string is long`。

次に、`result`内の参照の存続期間が2つの引数のうちのより小さい有効期間でなければならないことを示す例を試してみましょう。
`result`変数の宣言を内部<ruby>有効範囲<rt>スコープ</rt></ruby>の外側に移動しますが、<ruby>有効範囲<rt>スコープ</rt></ruby>内の`result`変数に`string2`という値を代入し`string2`。
次に、内部<ruby>有効範囲<rt>スコープ</rt></ruby>が終了した後に、`result`内部<ruby>有効範囲<rt>スコープ</rt></ruby>外で使用する`println!`移動します。
リスト10-24の<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let string1 = String::from("long string is long");
    let result;
    {
        let string2 = String::from("xyz");
        result = longest(string1.as_str(), string2.as_str());
    }
    println!("The longest string is {}", result);
}
```

<span class="caption">リスト10-24。使用しようとすると<code>result</code>後に<code>string2</code>有効範囲の外に行ってきました</span>

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、次の<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
error[E0597]: `string2` does not live long enough
  --> src/main.rs:15:5
   |
14 |         result = longest(string1.as_str(), string2.as_str());
   |                                            ------- borrow occurs here
15 |     }
   |     ^ `string2` dropped here while still borrowed
16 |     println!("The longest string is {}", result);
17 | }
   | - borrowed value needs to live until here
```

<ruby>誤り<rt>エラー</rt></ruby>は、`result`が`println!`文に対して有効である`result`を示しています`string2`は、外側<ruby>有効範囲<rt>スコープ</rt></ruby>の終わりまで有効である必要があります。
Rustはこれを知っています。なぜなら、同じ寿命パラメーター`'a`を使用して機能パラメーターと戻り値の有効期間に<ruby>注釈<rt>コメント</rt></ruby>を付けたからです。

人間は、この<ruby>譜面<rt>コード</rt></ruby>を見れば、`string1`が`string2`よりも長いことがあります。その`result`、 `string1`への参照が含まれます。
`string1`はまだ<ruby>有効範囲<rt>スコープ</rt></ruby>外になっていないので、`string1`への参照は`println!`文に対して有効です。
ただし、<ruby>製譜器<rt>コンパイラー</rt></ruby>はこの場合参照が有効であることを認識できません。
`longest`機能によって返される参照の有効期間は、渡された参照の有効期間のうちの小さいものと同じであることをRustに伝えました。したがって、借用検査器は、リスト10-24の<ruby>譜面<rt>コード</rt></ruby>が無効な参照を持つ可能性があると判断しません。

`longest`機能に渡された参照の値と有効期間、および返された参照がどのように使用されるかを変更するより多くの実験を設計してみてください。
<ruby>製譜<rt>コンパイル</rt></ruby>する前に実験が借用検査器を通過するかどうかについて仮説を立てます。
あなたが正しいかどうかを確認してください！　

### 寿命を考える

寿命パラメータを指定する必要がある方法は、機能が何をしているかによって異なります。
たとえば、`longest`機能の実装を、最長の<ruby>文字列<rt>ストリング</rt></ruby>スライスではなく最初のパラメータを常に返すように変更した場合、`y`パラメータに有効期間を指定する必要はありません。
以下の<ruby>譜面<rt>コード</rt></ruby>が<ruby>製譜<rt>コンパイル</rt></ruby>されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn longest<'a>(x: &'a str, y: &str) -> &'a str {
    x
}
```

この例では、パラメータ`x`と戻り値の型に対しては寿命パラメータ`'a`を指定しましたが、`y`の有効期間は`x`の有効期間または返り値とは関係がないため、パラメータ`y`では指定しませんでした。

機能から参照を返すときは、戻り値の型の有効期間パラメータは、いずれかのパラメータの有効期間パラメータと一致する必要があります。
返された参照がパラメータのいずれかを参照してい*ない*場合は、この機能内で作成された値を参照する必要があります。これは、機能の最後に値が範囲外になるためです。
<ruby>製譜<rt>コンパイル</rt></ruby>されない`longest`機能のこの試行された実装を考えてみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn longest<'a>(x: &str, y: &str) -> &'a str {
    let result = String::from("really long string");
    result.as_str()
}
```

ここでは、戻り値の型に寿命パラメータ`'a`を指定したにもかかわらず、戻り値の有効期間がパラメータの存続期間にまったく関係しないため、この実装は<ruby>製譜<rt>コンパイル</rt></ruby>に失敗します。
ここに受け取る<ruby>誤り<rt>エラー</rt></ruby>メッセージがあります。

```text
error[E0597]: `result` does not live long enough
 --> src/main.rs:3:5
  |
3 |     result.as_str()
  |     ^^^^^^ does not live long enough
4 | }
  | - borrowed value only lives until here
  |
note: borrowed value must be valid for the lifetime 'a as defined on the
function body at 1:1...
 --> src/main.rs:1:1
  |
1 |/fn longest<'a>(x: &str, y: &str) -> &'a str {
2 | |     let result = String::from("really long string");
3 | |     result.as_str()
4 | | }
  | |_^
```

問題は、`result`が範囲外になり、`longest`機能の最後に`result`が後始末されることです。
また、機能の`result`への参照を返そうとしています。
行方不明の参照を変更する寿命パラメータを指定する方法はありません.Rustは行方不明の参照を作成させません。
この場合、最も良い解決策は、参照ではなく所有されたデータ型を返すことであり、呼び出し側の機能が値を整理することになります。

最終的に、寿命構文は、さまざまなパラメータの寿命と機能の戻り値を結びつけることです。
それらが接続されると、Rustは、記憶セーフな操作を許可し、<ruby>指し手<rt>ポインタ</rt></ruby>がつぶれたり、<ruby>記憶域<rt>メモリー</rt></ruby>の安全性に違反する操作を禁止するのに十分な情報を持っています。

### 構造定義における寿命の<ruby>注釈<rt>コメント</rt></ruby>

これまでは、所有している型を保持する構造体しか定義していませんでした。
構造体が参照を保持することは可能ですが、その場合は構造体の定義内のすべての参照に寿命の<ruby>注釈<rt>コメント</rt></ruby>を追加する必要があります。
リスト10-25には、<ruby>文字列<rt>ストリング</rt></ruby>sliceを保持する`ImportantExcerpt`という名前の構造体があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.')
        .next()
        .expect("Could not find a '.'");
    let i = ImportantExcerpt { part: first_sentence };
}
```

<span class="caption">リスト10-25。参照を保持する構造体なので、その定義には寿命の<ruby>注釈<rt>コメント</rt></ruby>が必要です</span>

この構造体には、参照用の<ruby>文字列<rt>ストリング</rt></ruby>スライスを保持する1つの<ruby>欄<rt>フィールド</rt></ruby>`part`があります。
一般的なデータ型と同様に、構造体の名前の後ろに<ruby>山<rt>スタック</rt></ruby>形かっこの中にある一般的な寿命パラメータの名前を宣言して、構造体定義の本体でlifetimeパラメータを使用することができます。
この<ruby>注釈<rt>コメント</rt></ruby>は、`ImportantExcerpt`<ruby>実例<rt>インスタンス</rt></ruby>が、その`part`<ruby>欄<rt>フィールド</rt></ruby>に保持されている参照を保持できないことを意味します。

`main`機能は、変数`novel`が所有する`String`最初の文への参照を保持する、`ImportantExcerpt`構造体の<ruby>実例<rt>インスタンス</rt></ruby>を作成します。
`novel`のデータは、`ImportantExcerpt`<ruby>実例<rt>インスタンス</rt></ruby>が作成される前に存在します。
また、`novel`後までの範囲の外に出ていない`ImportantExcerpt`<ruby>有効範囲<rt>スコープ</rt></ruby>外になる、そうで参照`ImportantExcerpt`<ruby>実例<rt>インスタンス</rt></ruby>が有効です。

### 寿命省略

すべての参照には寿命があり、参照を使用する機能や構造体の有効期間パラメータを指定する必要があることがわかりました。
しかし、第4章ではリスト4-9の機能がありました。これはリスト10-26にもあり、寿命の<ruby>注釈<rt>コメント</rt></ruby>なしで<ruby>製譜<rt>コンパイル</rt></ruby>されています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

<span class="caption">リスト10-26。リスト4-9で定義した機能で、たとえパラメータと戻り値の型が参照であっても、寿命の<ruby>注釈<rt>コメント</rt></ruby>なしで<ruby>製譜<rt>コンパイル</rt></ruby>された機能</span>

この機能が寿命<ruby>補注<rt>アノテーション</rt></ruby>なしで<ruby>製譜<rt>コンパイル</rt></ruby>される理由は歴史的です。Rustの初期版（1.0より前）では、すべての参照で明示的な存続期間が必要だったため、この<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されませんでした。
その時、関数型注釈は次のように書かれています。

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

多くのRust<ruby>譜面<rt>コード</rt></ruby>を書いた後、Rustチームは、Rust<ruby>演譜師<rt>プログラマー</rt></ruby>が特定の状況で何度も同じ寿命<ruby>補注<rt>アノテーション</rt></ruby>を何度も繰り返していたことを発見しました。
これらの状況は予測可能であり、いくつかの決定論的パターンに従りました。
開発者はこれらのパターンを<ruby>製譜器<rt>コンパイラー</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>に<ruby>算譜<rt>プログラム</rt></ruby>したので、借用検査器はこのような状況で寿命を推論でき、明示的な<ruby>注釈<rt>コメント</rt></ruby>は必要ありません。

このRust履歴の部分は、より決定論的なパターンが出現し、<ruby>製譜器<rt>コンパイラー</rt></ruby>に追加される可能性があるため、関連性があります。
将来的には寿命の<ruby>注釈<rt>コメント</rt></ruby>が必要になることもあります。

Rustの参考文献の分析に<ruby>算譜<rt>プログラム</rt></ruby>されたパターンは、*寿命エリシエーションルール*と呼ばれ*ます*。
これは<ruby>演譜師<rt>プログラマー</rt></ruby>が従うべきルールではありません。
<ruby>製譜器<rt>コンパイラー</rt></ruby>が考慮する一連の特殊なケースであり、<ruby>譜面<rt>コード</rt></ruby>がこれらのケースに適合する場合は、明示的に寿命を書く必要はありません。

エリシオンルールは完全な推論を提供しません。
Rustが規則を決定論的に適用するが、参照がどのような存続期間にあるかについてのあいまいさが残っている場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は残りの参照の存続期間を推測しません。
この場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は、推測の代わりに、参照が互いにどのように関係しているかを指定する寿命<ruby>補注<rt>アノテーション</rt></ruby>を追加することで解決できる<ruby>誤り<rt>エラー</rt></ruby>を表示します。

機能または<ruby>操作法<rt>メソッド</rt></ruby>のパラメータの*寿命*は*入力寿命*と呼ばれ、戻り値の*寿命*は*出力寿命*と呼ばれ*ます*。

<ruby>製譜器<rt>コンパイラー</rt></ruby>は、3つのルールを使用して、明示的な<ruby>補注<rt>アノテーション</rt></ruby>がない場合に参照される寿命を把握します。
第1のルールは入力寿命に適用され、第2および第3のルールは出力寿命に適用されます。
<ruby>製譜器<rt>コンパイラー</rt></ruby>が3つのルールの終わりに達し、まだ寿命がわからない参照がある場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>は<ruby>誤り<rt>エラー</rt></ruby>で停止します。

最初のルールは、参照である各パラメータが独自の有効期間パラメータを取得することです。
言い換えると、1つのパラメータを持つ機能は、1つの有効期間パラメータを取得します`fn foo<'a>(x: &'a i32)`;
2つのパラメータを持つ機能は、`fn foo<'a, 'b>(x: &'a i32, y: &'b i32)`;という2つの別々の有効期間パラメータを取得します。
等々。

第2の規則は、正確に1つの入力有効期間パラメータが存在する場合、その有効期間はすべての出力有効期間パラメータに割り当てられます`fn foo<'a>(x: &'a i32) -> &'a i32`。

第3のルールは、複数の入力有効期間パラメータがある場合ですが、その1つは`&self`または`&mut self`です。これは<ruby>操作法<rt>メソッド</rt></ruby>なので、`self`の有効期間はすべての出力有効期間パラメータに割り当てられます。
この第3のルールは、より少ないシンボルが必要であるため、<ruby>操作法<rt>メソッド</rt></ruby>を読み書きするのがはるかに優れています。

<ruby>製譜器<rt>コンパイラー</rt></ruby>であるとふりましょう。
これらのルールを適用して、リスト10-26の`first_word`機能の型注釈内の参照の存続期間を`first_word`ます。
署名は、参照に関連する寿命なしで開始されます。

```rust,ignore
fn first_word(s: &str) -> &str {
```

<ruby>製譜器<rt>コンパイラー</rt></ruby>は最初のルールを適用します。このルールは、各パラメータが独自の有効期間を取得するように指定します。
それを呼ぶよ`'a`いつものように、今署名はこれです。

```rust,ignore
fn first_word<'a>(s: &'a str) -> &str {
```

正確に1つの入力寿命が存在するため、2番目のルールが適用されます。
2番目のルールは、1つの入力パラメータの存続期間が出力有効期間に割り当てられるように指定しているので、今度は署名がこれになります。

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

この関数型注釈の中のすべての参照は寿命を持ち、<ruby>製譜器<rt>コンパイラー</rt></ruby>はこの関数型注釈の寿命に<ruby>注釈<rt>コメント</rt></ruby>を付けることなく<ruby>演譜師<rt>プログラマー</rt></ruby>が分析を続けることができます。

別の例を見てみましょう。今回は、リスト10-21で作業を開始したときに寿命パラメータを持たない`longest`機能を使用します。

```rust,ignore
fn longest(x: &str, y: &str) -> &str {
```

最初のルールを適用してみましょう。各パラメータは独自の有効期間を取得します。
今回は、1つではなく2つのパラメータがあるため、2つの寿命があります。

```rust,ignore
fn longest<'a, 'b>(x: &'a str, y: &'b str) -> &str {
```

入力寿命が複数あるため、2番目のルールは適用されないことがわかります。
第3のルールはどちらも適用されません。`longest`は<ruby>操作法<rt>メソッド</rt></ruby>ではなく機能なので、パラメータのいずれも`self`ではありません。
3つのルールをすべて実行した後も、戻り型の寿命はまだわかりません。
このため、<ruby>譜面<rt>コード</rt></ruby>リスト10-21の<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとしたときに<ruby>誤り<rt>エラー</rt></ruby>が発生しました。<ruby>製譜器<rt>コンパイラー</rt></ruby>は寿命・省略・ルールを処理しましたが、型注釈内の参照の存続期間をすべて把握できませんでした。

3番目のルールは実際に<ruby>操作法<rt>メソッド</rt></ruby>型注釈にのみ適用されるため、次にその文脈の寿命を見て、3番目のルールで<ruby>操作法<rt>メソッド</rt></ruby>型注釈のライフ円環に非常に頻繁に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要がないことを確認します。

### <ruby>操作法<rt>メソッド</rt></ruby>定義における寿命<ruby>補注<rt>アノテーション</rt></ruby>

長寿命の構造体に<ruby>操作法<rt>メソッド</rt></ruby>を実装するときは、リスト10-11に示す総称型のパラメータと同じ構文を使用します。
宣言して寿命パラメータを使用する場所は、構造体<ruby>欄<rt>フィールド</rt></ruby>、<ruby>操作法<rt>メソッド</rt></ruby>のパラメータ、および戻り値に関連しているかどうかによって異なります。

構造体<ruby>欄<rt>フィールド</rt></ruby>の寿命名前は、常に`impl`予約語の後に​​宣言し、構造体の型の一部であるため、構造体の名前の後に使用する必要があります。

`impl`<ruby>段落<rt>ブロック</rt></ruby>内の<ruby>操作法<rt>メソッド</rt></ruby>型注釈では、参照は構造体の<ruby>欄<rt>フィールド</rt></ruby>内の参照の存続期間に関連付けられているか、独立している可能性があります。
さらに、寿命エリシエーションルールでは、寿命の<ruby>注釈<rt>コメント</rt></ruby>が<ruby>操作法<rt>メソッド</rt></ruby>型注釈に必要ないようにすることがよくあります。
リスト10-25で定義した`ImportantExcerpt`という名前の構造体を使用したいくつかの例を見てみましょう。

最初に、`level`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を使用します。この<ruby>操作法<rt>メソッド</rt></ruby>のパラメータは`self`への参照であり、戻り値は`i32`。これは何も参照しません。

```rust
# struct ImportantExcerpt<'a> {
#     part: &'a str,
# }
#
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```

型名の後の`impl`とuseの後の寿命パラメータ宣言は必須ですが、最初のelution規則のために`self`への参照の有効期間に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありません。

第3回寿命ルールが適用される例を次に示します。

```rust
# struct ImportantExcerpt<'a> {
#     part: &'a str,
# }
#
impl<'a> ImportantExcerpt<'a> {
    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {}", announcement);
        self.part
    }
}
```

入力寿命には2つの要素があるため、Rustは最初の有効期間ルールを適用し、`&self`と`announcement`両方に独自の寿命を与えます。
次に、パラメータの1つが`&self`であるため、戻り値の型は`&self`の有効期間を取得し、すべての有効期間が考慮されます。

### 静的な寿命

議論する必要がある特別な寿命の1つは`'static`であり、それは<ruby>算譜<rt>プログラム</rt></ruby>の全期間を意味します。
すべての文字列<ruby>直書き<rt>リテラル</rt></ruby>には`'static`有効期間（`'static` lifetime）があり`'static`。これを次のように<ruby>注釈<rt>コメント</rt></ruby>することができます。

```rust
let s: &'static str = "I have a static lifetime.";
```

この<ruby>文字列<rt>ストリング</rt></ruby>のテキストは、<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>二進譜<rt>バイナリ</rt></ruby>に直接格納されます。この<ruby>二進譜<rt>バイナリ</rt></ruby>は、常に利用可能です。
したがって、すべての文字列<ruby>直書き<rt>リテラル</rt></ruby>の有効期間は`'static`です。

<ruby>誤り<rt>エラー</rt></ruby>メッセージで`'static`寿命`'static`を使用することをおすすめします。
しかし、参照の寿命として`'static`指定する前に、実際に参照が<ruby>算譜<rt>プログラム</rt></ruby>の寿命にわたって生きているかどうかを考えてください。
可能な場合であっても、それを長く生きたいかどうかを検討するかもしれません。
ほとんどの場合、問題は、利用可能な寿命の不一致または不一致を作成しようとした場合に発生します。
このような場合、解決策は`'static`寿命を指定するのではなく、これらの問題を修正することです。

## 総称型パラメータ、<ruby>特性<rt>トレイト</rt></ruby>縛り、および寿命のまとめ

総称型パラメータ、<ruby>特性<rt>トレイト</rt></ruby>縛り、およびすべての機能を1つの機能で指定する構文を簡単に見てみましょう。

```rust
use std::fmt::Display;

fn longest_with_an_announcement<'a, T>(x: &'a str, y: &'a str, ann: T) -> &'a str
    where T: Display
{
    println!("Announcement! {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

これは、リスト10-22の`longest`機能であり、2つの<ruby>文字列<rt>ストリング</rt></ruby>スライスのうち長いものを返します。
しかし、これには、総称型`T` `ann`という追加のパラメータがあります。これは、`where`句で指定された`Display`<ruby>特性<rt>トレイト</rt></ruby>を実装する任意の型で埋め込むことができます。
機能が<ruby>文字列<rt>ストリング</rt></ruby>スライスの長さを比較する前に、この余分なパラメータが表示されます。これは、`Display`<ruby>特性<rt>トレイト</rt></ruby>の縛りが必要な理由です。
寿命は一種の総称型なので、寿命パラメータ`'a`と総称型パラメータ`T`の宣言は、機能名の後に角かっこの中の同じリストに入ります。

## 概要

この章で多くをカバーしました！　
総称型のパラメータ、<ruby>特性<rt>トレイト</rt></ruby>と<ruby>特性<rt>トレイト</rt></ruby>の縛り、および一般的な有効期間のパラメータについて知ったので、さまざまな状況で動作する繰り返しなしで<ruby>譜面<rt>コード</rt></ruby>を書く準備が整いました。
汎用型のパラメータを使用すると、さまざまな型に<ruby>譜面<rt>コード</rt></ruby>を適用できます。
<ruby>特性<rt>トレイト</rt></ruby>と<ruby>特性<rt>トレイト</rt></ruby>縛りは、型が汎用であっても、<ruby>譜面<rt>コード</rt></ruby>が必要とする動作を保証します。
寿命の<ruby>注釈<rt>コメント</rt></ruby>を使用して、この柔軟な<ruby>譜面<rt>コード</rt></ruby>に行方不明の参照がないようにする方法を学びました。
この分析はすべて<ruby>製譜<rt>コンパイル</rt></ruby>時に実行されますが、実行時のパフォーマンスには影響しません。

それを信じてもいなくても、この章で説明した話題でもっと学ぶべきことがあります。第17章では、<ruby>特性<rt>トレイト</rt></ruby>を使用する別の方法である<ruby>特性<rt>トレイト</rt></ruby>対象について説明します。
第19章では、寿命の<ruby>注釈<rt>コメント</rt></ruby>を含むより複雑な場合や、いくつかの発展的な型体系機能について説明します。
しかし、次に、Rustでテストを書く方法を学ぶので、<ruby>譜面<rt>コード</rt></ruby>が確実に動作するようにすることができます。
