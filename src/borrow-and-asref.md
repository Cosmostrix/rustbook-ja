% Borrow と AsRef

[`Borrow`][borrow] 特性と [`AsRef`][asref] 特性は似たもの同士ですが、違いがあります。
ここでは、この 2 つの特性の意味するところについてサクッと復習していきます。

<!--The [`Borrow`][borrow] and [`AsRef`][asref] traits are very similar, but
different. Here’s a quick refresher on what these two traits mean.-->

[borrow]: ../std/borrow/trait.Borrow.html
[asref]: ../std/convert/trait.AsRef.html

# Borrow

`Borrow` 特性は〈データ〉構造を書くときに使うもので、何らかの目的があって
所有された型、または、借用された型のどちらかを使いたい場合に活躍します。

<!--The `Borrow` trait is used when you’re writing a datastructure, and you want to
use either an owned or borrowed type as synonymous for some purpose.-->

例えば、[`HashMap`][hashmap] の持つ [`get` 操作法][get] で `Borrow` が使われています。

<!-- For example, [`HashMap`][hashmap] has a [`get` method][get] which uses `Borrow`: -->

```rust,ignore
fn get<Q: ?Sized>(&self, k: &Q) -> Option<&V>
    where K: Borrow<Q>,
          Q: Hash + Eq
```

[hashmap]: ../std/collections/struct.HashMap.html
[get]: ../std/collections/struct.HashMap.html#method.get

この〈シグネチャ〉はとても入り組んでいます。 私達の興味の対象は〈パラメータ〉`K` です。
それは `HashMap` 自身の〈パラメータ〉を参照しています。

<!--This signature is pretty complicated. The `K` parameter is what we’re interested
in here. It refers to a parameter of the `HashMap` itself:-->

```rust,ignore
struct HashMap<K, V, S = RandomState> {
```

〈パラメータ〉`K` は `HashMap` の _鍵_ (key)〈キー〉の型です。
そういうわけで、`get()` の〈シグネチャ〉をもう一度見ると、鍵が `Borrow<Q>`
を実装していれば `get()` を使えます。 そうすると `String` の鍵を使う `HashMap`
を作ることができ、なんと検索は `&str` で行えます。

<!--The `K` parameter is the type of _key_ the `HashMap` uses. So, looking at
the signature of `get()` again, we can use `get()` when the key implements
`Borrow<Q>`. That way, we can make a `HashMap` which uses `String` keys,
but use `&str`s when we’re searching:-->

```rust
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert("Foo".to_string(), 42);

assert_eq!(map.get("Foo"), Some(&42));
```

その理由は、標準譜集に `impl Borrow<str> for String` が入っているためです。

<!-- This is because the standard library has `impl Borrow<str> for String`. -->

所有・借用された型を 1 つ取りたいとき、ほとんどの型に対しては `&T` で十分です。
ところが `Borrow` が活きてくる場合は、値の借用の種類が複数あるときです。
特に参照と薄切りは `&T` と `&mut T` の両方の値を取れるため、よく当てはまります。
両方の型を受け入れたい場合は `Borrow` の出番です。

<!--For most types, when you want to take an owned or borrowed type, a `&T` is
enough. But one area where `Borrow` is effective is when there’s more than one
kind of borrowed value. This is especially true of references and slices: you
can have both an `&T` or a `&mut T`. If we wanted to accept both of these types,
`Borrow` is up for it:-->

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

これは `a is borrowed: 5` と 2 回印字します。

<!-- This will print out `a is borrowed: 5` twice. -->

# AsRef

`AsRef` 特性は変換を行う特性です。総称的な譜面である値を参照に変えるときに使われます。
こんな感じです。

<!--The `AsRef` trait is a conversion trait. It’s used for converting some value to
a reference in generic code. Like this:-->

```rust
let s = "Hello".to_string();

fn foo<T: AsRef<str>>(s: T) {
    let slice = s.as_ref();
}
```

# どちらを使えば良いですか？ {#which-should-i-use}

<!-- # Which should I use? -->

2 つの特性がどう共通しているかは分かりました。どちらもある型の所有版・借用版を扱うものです。
しかし、微妙な違いもあります。

<!--We can see how they’re kind of the same: they both deal with owned and borrowed
versions of some type. However, they’re a bit different.-->

`Borrow` を選ぶときは、切り混ぜ〈ハッシュ化〉や大小比較を行うなど、
異なる種類の借用をまとめて抽象化したい、あるいは〈データ〉構造を組み上げる中で
所有・借用された値をどちらも同じ手段で扱いたいときです。

<!--Choose `Borrow` when you want to abstract over different kinds of borrowing, or
when you’re building a datastructure that treats owned and borrowed values in
equivalent ways, such as hashing and comparison.-->

`AsRef` を選ぶときは、何かを直接、参照に変えたいときと総称的な譜面を書いているときです。

<!--Choose `AsRef` when you want to convert something to a reference directly, and
you’re writing generic code.-->
