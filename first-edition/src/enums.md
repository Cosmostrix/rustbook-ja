# 列挙型

Rustの`enum`型は、いくつかの可能な場合値の1つであるデータを表す型です。
`enum`型の各場合値には、必要に応じて関連するデータがあります。

```rust
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}
```

場合値を定義するための構文は、構造体を定義するための構文に似ています。データがない場合値（ユニットのような構造体）、名前付きデータの場合値、名前のないデータの場合値（組構造体など）を持つことができます。
ただし、別々の構造体定義とは異なり、`enum`型は単一の型です。
列挙型の値は、任意の場合値に一致することができます。
このため、列挙型は時には「和型」と呼ばれます。列挙型の可能な値のセットは、各場合値の可能な値のセットの和です。

`::` syntaxを使用して、各場合値の名前を使用します。`enum`は、`enum`自体の名前で有効範囲されています。
これにより、これらの両方を動作させることができます。

```rust
# enum Message {
#     Move { x: i32, y: i32 },
# }
let x: Message = Message::Move { x: 3, y: 4 };

enum BoardGameTurn {
    Move { squares: i32 },
    Pass,
}

let y: BoardGameTurn = BoardGameTurn::Move { squares: 1 };
```

どちらの変種も`Move`という名前が付けられていますが、列挙型の名前に有効範囲されているため、矛盾なく使用できます。

`enum`型の値には、その場合値に関連するデータに加えて、その場合値に関する情報が含まれます。
データにはどの型のものであるかを示す「タグ」が含まれているため、これは「タグ付きユニオン」と呼ばれることがあります。
製譜器はこの情報を使用して、enum内のデータに安全にアクセスしていることを強制型変換します。
たとえば、値が可能な場合値の1つであるかのように、単に値を破棄することはできません。

```rust,ignore
fn process_color_change(msg: Message) {
#//    let Message::ChangeColor(r, g, b) = msg; // This causes a compile-time error.
    let Message::ChangeColor(r, g, b) = msg; // これにより、製譜時誤りが発生します。
}
```

これらの操作をサポートしていないことは、かなり制限的に思えるかもしれませんが、克服できる限界です。
2つの方法があります。自分自身を平等に実装するか、模式照合バリエーションを[`match`][match]式に[`match`][match]ます。これについては、次の章で学習します。
まだ平等を実現するためにRustについて十分には分かっていませんが、[`traits`][traits]章で見つけることができます。

[match]: match.html
 [traits]: traits.html


# 機能としての構築子

`enum`構築子も機能のように使用できます。
例えば。

```rust
# enum Message {
# Write(String),
# }
let m = Message::Write("Hello, world".to_string());
```

〜と同じです

```rust
# enum Message {
# Write(String),
# }
fn foo(x: String) -> Message {
    Message::Write(x)
}

let x = foo("Hello, world".to_string());
```

これは、私たちにすぐに有用ではないですが、得るとき[`closures`][closures]、他の機能の引数として機能を渡すことについて話しましょう。
たとえば、[`iterators`][iterators]を使用すると、`String`のベクトルを`Message::Write`のベクトルに変換することができます。

```rust
# enum Message {
# Write(String),
# }

let v = vec!["Hello".to_string(), "World".to_string()];

let v1: Vec<Message> = v.into_iter().map(Message::Write).collect();
```

[closures]: closures.html
 [iterators]: iterators.html

