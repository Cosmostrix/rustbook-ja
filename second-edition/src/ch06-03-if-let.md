## `if let`簡潔な<ruby>制御構造<rt>コントロールフロー</rt></ruby>

`if let`構文を使用すると、`if`と`let`をあまり控えめに組み合わせ`if`、あるパターンに一致する値を処理し、残りのものは無視することができます。
リスト6-6の<ruby>算譜<rt>プログラム</rt></ruby>を`Option<u8>`値と一致させるが、その値が3の場合にのみ<ruby>譜面<rt>コード</rt></ruby>を実行したいと考えている<ruby>算譜<rt>プログラム</rt></ruby>を考えてみましょう。

```rust
let some_u8_value = Some(0u8);
match some_u8_value {
    Some(3) => println!("three"),
    _ => (),
}
```

<span class="caption">譜面リスト6-6。値が<code>Some(3)</code>ときにのみ<ruby>譜面<rt>コード</rt></ruby>を実行することを気にする<code>match</code></span>

`Some(3)`一致で何かをしたいが、他の`Some<u8>`値または`None`値で何もしない。
`match`式を満たすために、追加する定型<ruby>譜面<rt>コード</rt></ruby>の多くである1つの<ruby>場合値<rt>バリアント</rt></ruby>を処理した後に`_ => ()`を追加する必要があります。

代わりに`if let`を使ってこれをもっと短時間で書くことができます。
次の<ruby>譜面<rt>コード</rt></ruby>は、リスト6-6の`match`と同じように動作します。

```rust
# let some_u8_value = Some(0u8);
if let Some(3) = some_u8_value {
    println!("three");
}
```

構文`if let`は、パターンと式を等号で区切って指定します。
これは同じように動作`match`式をに与えられ、`match`パターンは、その第一の分岐です。

`if let`を使用すると、入力が少なくなり、字下げが少なくなり、定型化された<ruby>譜面<rt>コード</rt></ruby>が少なくなります。
ただし、強制的に強制的にチェックを`match`ことはできません。
`match`と`if let`選択は、特定の状況で何をしているのか、簡潔さを得ることが網羅的なチェックを失うための適切な<ruby>相殺取引<rt>トレードオフ</rt></ruby>であるかによって異なります。

言い換えれば、考えることができます`if let`するための構文糖として`match`値が一つのパターンに一致したときに<ruby>譜面<rt>コード</rt></ruby>を実行して、他のすべての値を無視します。

`if let`使って`else`を含めることができます。
となった<ruby>譜面<rt>コード</rt></ruby>の<ruby>段落<rt>ブロック</rt></ruby>`else`となるだろう<ruby>譜面<rt>コード</rt></ruby>の<ruby>段落<rt>ブロック</rt></ruby>と同じである`_`中の場合`match`と等価である表現`if let`と`else`。
リスト6-4の`Coin`列挙型の定義を思い出してください。ここでは、`Quarter`<ruby>場合値<rt>バリアント</rt></ruby>も`UsState`値を保持して`UsState`ます。
四半期の状態を発表している間に表示された非四半期のコインをすべてカウントしたければ、次のような`match`式でそれを行うことができます。

```rust
# #[derive(Debug)]
# enum UsState {
#    Alabama,
#    Alaska,
# }
#
# enum Coin {
#    Penny,
#    Nickel,
#    Dime,
#    Quarter(UsState),
# }
# let coin = Coin::Penny;
let mut count = 0;
match coin {
    Coin::Quarter(state) => println!("State quarter from {:?}!", state),
    _ => count += 1,
}
```

あるいは、`if let`と`else`ような式を以下のように使うことができます。

```rust
# #[derive(Debug)]
# enum UsState {
#    Alabama,
#    Alaska,
# }
#
# enum Coin {
#    Penny,
#    Nickel,
#    Dime,
#    Quarter(UsState),
# }
# let coin = Coin::Penny;
let mut count = 0;
if let Coin::Quarter(state) = coin {
    println!("State quarter from {:?}!", state);
} else {
    count += 1;
}
```

<ruby>算譜<rt>プログラム</rt></ruby>に、`match`を使って表現するのが冗長すぎる<ruby>論理<rt>ロジック</rt></ruby>がある状況がある`if let`は、`if let`もRustの道具ボックスにあることを忘れないでください。

## 概要

ここでは、enumを使用して列挙値のセットの1つである独自の型を作成する方法について説明しました。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`Option<T>`型が<ruby>誤り<rt>エラー</rt></ruby>を防ぐために型体系をどのように使うのかを示しました。
列挙型の値にデータが含まれている場合、処理する必要があるケースの数に応じて、`match`または`if let`を使用してこれらの値を抽出して使用できます。

あなたのRust<ruby>算譜<rt>プログラム</rt></ruby>は、構造体と列挙型を使用して、特定領域内の概念を表現できるようになりました。
APIで使用する独自の型を作成すると、型の安全性が保証されます。<ruby>製譜器<rt>コンパイラー</rt></ruby>は、各機能が期待する型の値のみを取得するようにします。

利用者に必要なものだけが<ruby>公開<rt>パブリック</rt></ruby>されるように、使いやすいAPIを利用者に提供するために、Rustの<ruby>役区<rt>モジュール</rt></ruby>に目を向けるようにしましょう。
