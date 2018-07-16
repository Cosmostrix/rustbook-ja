# 文字列

文字列は、演譜師がマスターするための重要な概念です。
Rustの文字列処理システムは、そのシステムの焦点のために、他の言語とは少し異なります。
可変サイズのデータ​​構造を持つたびに、処理が複雑になり、文字列がサイズ変更可能なデータ構造になります。
つまり、Rustの文字列は、Cなどの他のシステム言語とは異なる働きをします。

詳細を掘り下げてみましょう。
'文字列'は、UTF-8バイトのストリームとして符号化されたUnicodeスカラ値のシーケンスです。
すべての文字列は、UTF-8シーケンスの有効な符号化であることが保証されています。
さらに、他のシステム言語とは異なり、文字列はNUL終端ではなく、NULバイトを含むことができます。

Rustには、`&str`と`String` 2つの主要な`&str`あり`&str`。
まず`&str`について話しましょう。
これらは「文字列スライス」と呼ばれます。
文字列スライスは固定サイズであり、変更することはできません。
これは、UTF-8バイトのシーケンスへの参照です。

```rust
#//let greeting = "Hello there."; // greeting: &'static str
let greeting = "Hello there."; // グリーティング。＆ 'static str
```

`"Hello there."` は文字列直書きで、その型は`&'static str`です。
文字列直書きは、静的に割り当てられた文字列スライスです。つまり、製譜された算譜内に保存され、実行中の全期間にわたって存在します。
`greeting`束縛は、この静的に割り当てられた文字列への参照です。
文字列スライスを期待する機能も、文字列直書きを受け入れます。

文字列直書きは複数の行にまたがることができます。
2つの形式があります。
最初の行には改行と先頭のスペースが含まれます。

```rust
let s = "foo
    bar";

assert_eq!("foo\n    bar", s);
```

`\`は空白と改行をトリミングします。

```rust
let s = "foo\
    bar";

assert_eq!("foobar", s);
```

通常、`str`直接アクセスすることはできませんが、`&str`参照を介してのみアクセスでき`&str`。
これは、`str`がサイズ変更されていない型であり、追加の実行時情報を使用する必要があるためです。
詳細は、[サイズ未定義][ut]の章を参照してください。

Rustは`&str`だけではありません。
`String`は、原に割り当てられた文字列です。
この文字列は拡張可能で、UTF-8であることも保証されています。
`String`は、通常、`to_string`操作法を使用して`to_string`から変換することによって作成されます。

```rust
#//let mut s = "Hello".to_string(); // mut s: String
let mut s = "Hello".to_string(); //  mut s。文字列
println!("{}", s);

s.push_str(", world.");
println!("{}", s);
```

`String` sがに強制型変換します`&str`と`&`。

```rust
fn takes_slice(slice: &str) {
    println!("Got: {}", slice);
}

fn main() {
    let s = "Hello".to_string();
    takes_slice(&s);
}
```

この強制型変換は、`&str`の代わりに`&str`の特性の1つを受け入れる機能では起こりません。
たとえば、[`TcpStream::connect`][connect]は`ToSocketAddrs`型のパラメータがあります。
`&str`は大丈夫ですが、`String`を`&*`を使って明示的に変換する必要があります。

```rust,no_run
use std::net::TcpStream;

#//TcpStream::connect("192.168.0.1:3000"); // Parameter is of type &str.
TcpStream::connect("192.168.0.1:3000"); // パラメータの型は＆strです。

let addr_string = "192.168.0.1:3000".to_string();
#//TcpStream::connect(&*addr_string); // Convert `addr_string` to &str.
TcpStream::connect(&*addr_string); //  `addr_string`を＆strに変換します。
```

表示`String`として`&str`安価であるが、変換`&str`に`String`記憶を割り当てることを含みます。
あなたがする必要がない限りそれを行う理由はありません！　

## 添字作成

文字列は有効なUTF-8なので、索引付けはサポートされていません。

```rust,ignore
let s = "hello";

#//println!("The first letter of s is {}", s[0]); // ERROR!!!
println!("The first letter of s is {}", s[0]); // 誤り！　！　！　
```

通常、`[]`ベクトルへのアクセスは非常に高速です。
しかし、UTF-8で符号化された文字列の各文字は複数のバイトになる可能性があるので、文字列のnᵗ文字を見つけるためには文字列の上を移動する必要があります。
これははるかに高価な操作であり、誤解を招きたくありません。
さらに、'文字'はUnicodeで定義されたものではありません。
文字列を個々のバイトとして、または譜面ポイントとして見ることができます。

```rust
let hachiko = "忠犬ハチ公";

for b in hachiko.as_bytes() {
    print!("{}, ", b);
}

println!("");

for c in hachiko.chars() {
    print!("{}, ", c);
}

println!("");
```

これは印字します。

```text
229, 191, 160, 231, 138, 172, 227, 131, 143, 227, 131, 129, 229, 133, 172,
忠, 犬, ハ, チ, 公,
```

ご覧のとおり、`char`よりも多くのバイトがあります。

次のような添字に似たものを得ることができます。

```rust
# let hachiko = "忠犬ハチ公";
#//let dog = hachiko.chars().nth(1); // Kinda like `hachiko[1]`.
let dog = hachiko.chars().nth(1); //  `hachiko[1]`みたいですね。
```

これは、`chars`のリストの始めから歩かなければならないことを強調しています。

## スライス

スライス構文で文字列のスライスを取得できます。

```rust
let dog = "hachiko";
let hachi = &dog[0..5];
```

ただし、これらは _バイト_ オフセットであり、 _文字_ オフセットではありません。
これは実行時に失敗します。

```rust,should_panic
let dog = "忠犬ハチ公";
let hachi = &dog[0..2];
```

この誤りが発生しました。

```text
thread 'main' panicked at 'byte index 2 is not a char boundary; it is inside '忠'
(bytes 0..3) of `忠犬ハチ公`'
```

## 連結

`String`を持っている場合は、`&str`を末尾に連結することができ`&str`。

```rust
let hello = "Hello ".to_string();
let world = "world!";

let hello_world = hello + world;
```

しかし、2つの`String`がある場合は、`&`。

```rust
let hello = "Hello ".to_string();
let world = "world!".to_string();

let hello_world = hello + &world;
```

これは`&String`が`&str`自動的に強制型変換することができるからです。
これは「 [`Deref` coercions][dc] 」と呼ばれる機能です。

[ut]: unsized-types.html
 [dc]: deref-coercions.html
 [connect]: ../../std/net/struct.TcpStream.html#method.connect

