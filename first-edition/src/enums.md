# 列挙型

Rustの`enum`型は、いくつかの可能なバリアントの1つであるデータを表す型です。
`enum`型の各バリアントには、必要に応じて関連するデータがあります。

```rust
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}
```

バリアントを定義するための構文は、構造体を定義するための構文に似ています。データがないバリアント（ユニットのような構造体）、名前付きデータのバリアント、名前のないデータのバリアント（タプル構造体など）を持つことができます。
ただし、別々の構造体定義とは異なり、`enum`型は単一の型です。
列挙型の値は、任意のバリアントに一致することができます。
このため、列挙型は時には「合計型」と呼ばれます。列挙型の可能な値のセットは、各バリアントの可能な値のセットの合計です。

`::` syntaxを使用して、各バリアントの名前を使用します。`enum`は、`enum`自体の名前でスコープされています。
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

どちらの変種も`Move`という名前が付けられていますが、列挙型の名前にスコープされているため、矛盾なく使用できます。

`enum`型の値には、そのバリアントに関連するデータに加えて、そのバリアントに関する情報が含まれます。
データにはどのタイプのものであるかを示す「タグ」が含まれているため、これは「タグ付きユニオン」と呼ばれることがあります。
コンパイラはこの情報を使用して、enum内のデータに安全にアクセスしていることを強制します。
たとえば、値が可能なバリアントの1つであるかのように、単に値を破棄することはできません。

```rust,ignore
fn process_color_change(msg: Message) {
#//    let Message::ChangeColor(r, g, b) = msg; // This causes a compile-time error.
    let Message::ChangeColor(r, g, b) = msg; // これにより、コンパイル時エラーが発生します。
}
```

これらの操作をサポートしていないことは、かなり制限的に思えるかもしれませんが、克服できる限界です。
2つの方法があります：自分自身を平等に実装するか、パターンマッチングバリエーションを[`match`][match]式に[`match`][match]ます。これについては、次のセクションで学習します。
私たちはまだ平等を実現するためにRustについて十分には分かっていませんが、[`traits`][traits]セクションで見つけることができます。

[match]: match.html
 [traits]: traits.html


# 関数としてのコンストラクタ

`enum`コンストラクタも関数のように使用できます。
例えば：

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

これは、私たちにすぐに有用ではないですが、私たちが得るとき[`closures`][closures]、我々は他の関数の引数として関数を渡すことについて話しましょう。
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

