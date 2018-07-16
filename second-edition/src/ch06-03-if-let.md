## `if let`簡潔な制御の流れ

`if let`構文を使用すると、`if`と`let`をあまり控えめに組み合わせ`if`、あるパターンに一致する値を処理し、残りのものは無視することができます。
リスト6-6の算譜を`Option<u8>`値と一致させるが、その値が3の場合にのみ譜面を実行したいと考えている算譜を考えてみましょう。

```rust
let some_u8_value = Some(0u8);
match some_u8_value {
    Some(3) => println!("three"),
    _ => (),
}
```

<span class="caption">譜面リスト6-6。値が<code>Some(3)</code>ときにのみ譜面を実行することを気にする<code>match</code></span>

`Some(3)`一致で何かをしたいが、他の`Some<u8>`値または`None`値で何もしない。
`match`式を満たすために、追加する定型譜面の多くである1つの場合値を処理した後に`_ => ()`を追加する必要があります。

代わりに`if let`を使ってこれをもっと短時間で書くことができます。
次の譜面は、リスト6-6の`match`と同じように動作します。

```rust
# let some_u8_value = Some(0u8);
if let Some(3) = some_u8_value {
    println!("three");
}
```

構文`if let`は、パターンと式を等号で区切って指定します。
これは同じように動作`match`式をに与えられ、`match`パターンは、その第一のアームです。

`if let`を使用すると、入力が少なくなり、字下げが少なくなり、定型化された譜面が少なくなります。
ただし、強制的に強制的にチェックを`match`ことはできません。
`match`と`if let`選択は、特定の状況で何をしているのか、簡潔さを得ることが網羅的なチェックを失うための適切な相殺取引であるかによって異なります。

言い換えれば、あなたは考えることができます`if let`するための構文糖として`match`値が一つのパターンに一致したときに譜面を実行して、他のすべての値を無視します。

`if let`使って`else`を含めることができます。
となった譜面の段落`else`となるだろう譜面の段落と同じである`_`中の場合`match`と等価である式`if let`と`else`。
リスト6-4の`Coin`列挙型の定義を思い出してください。ここでは、`Quarter`変種も`UsState`値を保持して`UsState`ます。
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

あなたの算譜に、`match`を使って式するのが冗長すぎるロジックがある状況がある`if let`は、`if let`もあなたのRustの道具ボックスにあることを忘れないでください。

## 概要

ここでは、enumを使用して列挙値のセットの1つである独自の型を作成する方法について説明しました。
標準譜集の`Option<T>`型が誤りを防ぐために型システムをどのように使うのかを示しました。
列挙型の値にデータが含まれている場合、処理する必要があるケースの数に応じて、`match`または`if let`を使用してこれらの値を抽出して使用できます。

あなたのRust算譜は、構造体と列挙型を使用して、ドメイン内の概念を式できるようになりました。
APIで使用する独自型を作成すると、型の安全性が保証されます。製譜器は、各機能が期待する型の値のみを取得するようにします。

ユーザーに必要なものだけが公開されるように、使いやすいAPIをユーザーに提供するために、Rustの役区に目を向けるようにしましょう。
