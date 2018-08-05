# 借り入れとAsRef

[`Borrow`][borrow]と[`AsRef`][asref]形質は非常に似ていますが、異なっています。
ここでは、これらの2つの特性が何を意味するかを簡単に再考します。

[borrow]: ../../std/borrow/trait.Borrow.html
 [asref]: ../../std/convert/trait.AsRef.html


# かりて

`Borrow`特性は、データ構造を記述するときに使用され、所有目的または借用目的のいずれかの種類を、ある目的のために同義語として使用する場合に使用します。

たとえば、[`HashMap`][hashmap]は`Borrow`を使用する[`get`メソッドが][get]あります。

```rust,ignore
fn get<Q: ?Sized>(&self, k: &Q) -> Option<&V>
    where K: Borrow<Q>,
          Q: Hash + Eq
```

[hashmap]: ../../std/collections/struct.HashMap.html
 [get]: ../../std/collections/struct.HashMap.html#method.get


この署名はかなり複雑です。
`K`パラメータはここで私たちが興味を持っているものです。
これは、`HashMap`自体のパラメータを参照します。

```rust,ignore
struct HashMap<K, V, S = RandomState> {
```

`K`パラメータは、`HashMap`使用する _キー_ の型です。
だから、`get()`シグネチャを見てみると、キーが`Borrow<Q>`実装しているときに`get()`使う`get()`ができます。
こうすることで、`String`キーを使用する`HashMap`を作成できますが、検索時には`&str`使用します。

```rust
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert("Foo".to_string(), 42);

assert_eq!(map.get("Foo"), Some(&42));
```

これは、標準ライブラリに`impl Borrow<str> for String`が`impl Borrow<str> for String`です。

ほとんどのタイプでは、所有しているタイプまたは借りたタイプを使用したいときは、`&T`で十分です。
しかし、`Borrow`が有効な領域は、複数の種類の借用価値がある場合です。
これは特に参照とスライスに当てはまります。`&T`または`&mut T`両方を持つことができます。
これらの両方のタイプを受け入れる場合は、`Borrow`がそれを`Borrow`します。

```rust
use std::borrow::Borrow;
use std::fmt::Display;

fn foo<T: Borrow<i32> + Display>(a: T) {
    println!("a is borrowed: {}", a);
}

let mut i = 5;

foo(&i);
foo(&mut i);
```

これは`a is borrowed: 5`を印刷します`a is borrowed: 5`回2回。

# AsRef

`AsRef`形質は形質転換形質である。
ジェネリックコードの値を参照に変換するために使用されます。
このような：

```rust
let s = "Hello".to_string();

fn foo<T: AsRef<str>>(s: T) {
    let slice = s.as_ref();
}
```

# どちらを使うべきですか？

どのように同じようになっているかを見ることができます。どちらも、所有しているバージョンと借用しているバージョンの両方を処理します。
しかし、彼らは少し異なっています。

選択`Borrow`したいとき借入の異なる種類の上に抽象的に、またはあなたは、このようなハッシュと比較と同等の方法で所有し、借り値を扱うデータ構造を構築しているとき。

何かを参照に直接変換し、汎用コードを書いている場合は`AsRef`選択します。
