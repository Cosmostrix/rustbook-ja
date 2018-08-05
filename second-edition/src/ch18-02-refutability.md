## Refutability。パターンが一致しないかどうか

パターンには、2つの形式があります。refutableとrefrefutableです。
渡される可能性のある値と一致するパターンは*反駁不可能*です。
例は、`let x = 5;`文の`x`となり`let x = 5;`
`x`何にもマッチするので、一致することができないからです。
可能な値と一致しないパターンは*再現*可能です。
例は次のようになり`Some(x)`式中の`if let Some(x) = a_value`の値場合ため`a_value`変数はありません`None`ではなく、`Some`、 `Some(x)`パターンが一致しません。

機能のパラメータ、`let`文、`for`ループは反駁不能なパターンしか受け付けることができません。なぜなら、値が不一致のときに<ruby>算譜<rt>プログラム</rt></ruby>が何か意味のあることを行うことができないからです。
`if let`および`while let`式は、定義可能なパターンのみを受け入れます。なぜなら、定義によって、失敗の可能性を処理することを意図しているからです。条件の機能は、成功または失敗に応じて異なる実行能力にあります。

一般的に、反駁可能なパターンと反駁できないパターンとの区別について心配する必要はありません。
ただし、<ruby>誤り<rt>エラー</rt></ruby>メッセージに表示されたときに対応できるように、再互換性の概念に精通している必要があります。
そのような場合は、意図した<ruby>譜面<rt>コード</rt></ruby>の動作に応じて、パターンを使用しているパターンまたは構造を変更する必要があります。

Rustが反駁不可能なパターンを必要とし、逆もまた同様である反駁可能なパターンを使用しようとするとどうなるかの例を見てみましょう。
リスト18-8は`let`文を示していますが、`Some(x)`指定したパターンに対しては、改変可能なパターンです。
期待どおり、この<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。

```rust,ignore
let Some(x) = some_option_value;
```

<span class="caption">リスト18-8。 <code>let</code>改ざん可能なパターンを使用しようとしています</span>

`some_option_value`が`None`値だった場合、パターン`Some(x)`と一致しないことになります。これはパターンが`some_option_value`であることを意味します。
ただし、`let`文は、<ruby>譜面<rt>コード</rt></ruby>が`None`値で実行できる有効なものがないため、反駁可能なパターンのみを受け入れることができます。
<ruby>製譜<rt>コンパイル</rt></ruby>時に、Rustは反駁可能なパターンが必要な場合には、再利用可能なパターンを使用しようとしていると不平を言うでしょう。

```text
error[E0005]: refutable pattern in local binding: `None` not covered
 -->
  |
3 | let Some(x) = some_option_value;
  |     ^^^^^^^ pattern `None` not covered
```

パターン`Some(x)`ですべての有効な値をカバーしなかったので、Rustは正しく<ruby>製譜<rt>コンパイル</rt></ruby>誤りを生成します。

反駁可能なパターンが必要な修正可能なパターンを持つ問題を修正するには、パターンを使用する<ruby>譜面<rt>コード</rt></ruby>を変更することができます。letを使用する代わりに`let`を使用`if let`ことができます。
パターンが一致しない場合、<ruby>譜面<rt>コード</rt></ruby>は中かっこで<ruby>譜面<rt>コード</rt></ruby>をスキップし、有効に続行する方法を与えます。
<ruby>譜面<rt>コード</rt></ruby>リスト18-9は<ruby>譜面<rt>コード</rt></ruby>リスト18-8の<ruby>譜面<rt>コード</rt></ruby>を修正する方法を示しています。

```rust
# let some_option_value: Option<i32> = None;
if let Some(x) = some_option_value {
    println!("{}", x);
}
```

<span class="caption">リスト18-9。 <code>if let</code>と<code>let</code>代わりにrefutableのパターンを持つ<ruby>段落<rt>ブロック</rt></ruby>を使う</span>

<ruby>譜面<rt>コード</rt></ruby>を出しました！　
この<ruby>譜面<rt>コード</rt></ruby>は完全に有効ですが、<ruby>誤り<rt>エラー</rt></ruby>を受け取らずに反駁可能なパターンを使用することはできません。
リスト18-10に示すように、`x`など、常に一致するパターンを指定した`if let`そのパターンは<ruby>製譜<rt>コンパイル</rt></ruby>されません。

```rust,ignore
if let x = 5 {
    println!("{}", x);
};
```

<span class="caption">リスト18-10。 <code>if let</code> ifreflectableパターンを使用しようとした<code>if let</code></span>

Rustは、反駁できないパターンで`if let`を使うと意味をなさないと訴える。

```text
error[E0162]: irrefutable if-let pattern
 --> <anon>:2:8
  |
2 | if let x = 5 {
  |        ^ irrefutable pattern
```

このため、マッチ分岐は最後の分岐を除いて、リフレクタブルパターンを使用しなければなりません。残りの値は反駁できないパターンと一致するはずです。
Rustでは、1つの分岐との`match`で反駁不能なパターンを使用することができますが、この構文は特に有用ではなく、より簡単な`let`文で置き換えることができます。

パターンを使用する場所と、改ざん可能なパターンと反駁できないパターンの違いを知ったので、パターンを作成するために使用できるすべての構文について説明しましょう。
