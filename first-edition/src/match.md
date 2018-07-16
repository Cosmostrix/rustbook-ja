# 一致

多くの場合、2つ以上の選択肢があるため、単純な[`if`][if] / `else`では不十分です。
また、条件はかなり複雑になる可能性があります。
Rustには予約語、`match`、複雑な`if` / `else`グループをより強力なものに置き換えることができます。
見てみな。

```rust
let x = 5;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    4 => println!("four"),
    5 => println!("five"),
    _ => println!("something else"),
}
```

[if]: if.html

`match`は式をとり、その値に基づいて分岐します。
枝の各「腕」は、`val => expression`形式です。
値が一致すると、その腕の式が評価されます。
それは呼ばれています`match`ので用語「模式照合」の`match`の実装です。
ここで可能なすべてのパターンをカバー[するパターン][patterns]についての[別の章][patterns]があります。

[patterns]: patterns.html

`match`の多くの利点の1つは、「徹底的なチェック」を実施することです。
たとえば、下線`_`ついた最後の腕を削除した場合、製譜器は誤りを返します。

```text
error: non-exhaustive patterns: `_` not covered
```

Rustは、価値を忘れてしまったことを伝えています。
製譜器は、`x`から任意の32ビット整数値を取り出すことができます。
例えば、-2,147,483,648〜2,147,483,647であます。
`_`は 'catch-all'として機能し、`match`腕に指定され*ていない*すべての値を捕捉します。
前の例で分かるように、整数1〜5の`match`アームを提供します`x`が6または他の値の場合、`_`によって捕捉されます。

`match`は式でもあります。つまり、`let`束縛の右側で、または式が使用されている場所で直接使用できます。

```rust
let x = 5;

let number = match x {
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    _ => "something else",
};
```

時には、ある型から別の型に何かを変換する素晴らしい方法です。
この例では、整数は`String`変換されます。

# 列挙型の照合

`match`予約語の別の重要な使い方は、enumの可能な変形を処理することです。

```rust
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}

fn quit() { /* ... */ }
fn change_color(r: i32, g: i32, b: i32) { /* ... */ }
fn move_cursor(x: i32, y: i32) { /* ... */ }

fn process_message(msg: Message) {
    match msg {
        Message::Quit => quit(),
        Message::ChangeColor(r, g, b) => change_color(r, g, b),
        Message::Move { x, y: new_name_for_y } => move_cursor(x, new_name_for_y),
        Message::Write(s) => println!("{}", s),
    };
}
```

繰り返しになりますが、Rust製譜器は完全性をチェックするので、列挙型のすべての変形に対してマッチ・アームが必要です。
1つをオフにすると、`_`を使用したり、可能なすべてのアームを提供しない限り、製譜時誤りが発生します。

これまでの`match`使用とは異なり、通常の`if`文を使用することはできません。
[`if let`][if-let]文を使用することができます。これは、`match`省略形として見ることができます。

[if-let]: if-let.html
