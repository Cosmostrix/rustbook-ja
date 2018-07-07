% if let

`if let` によって `if` と `let` を組み合わせて模式照合におけるある種の〈オーバーヘッド〉を
削減します。

<!--`if let` allows you to combine `if` and `let` together to reduce the overhead
of certain kinds of pattern matches.-->

例えば、どこからかやってきた `Option<T>` 型の値があったとしましょう。
その中身が `Some<T>` なら何か仕事をし、`None` なら何もしない処理にしたいです。
それはこのように書けます。

<!--For example, let’s say we have some sort of `Option<T>`. We want to call a function
on it if it’s `Some<T>`, but do nothing if it’s `None`. That looks like this:-->

```rust
# let option = Some(5);
# fn foo(x: i32) { }
match option {
    Some(x) => { foo(x) },
    None => {},
}
```

`match` はここで絶対必要というわけではありません。
例えば、`if` を使うとこう書けるでしょう。

<!-- We don’t have to use `match` here, for example, we could use `if`: -->

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if option.is_some() {
    let x = option.unwrap();
    foo(x);
}
```

どちらもあまり魅力的ではありませんね。
`if let` を使えば同じことをよりきれいに実現できます。

<!--Neither of these options is particularly appealing. We can use `if let` to
do the same thing in a nicer way:-->

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if let Some(x) = option {
    foo(x);
}
```

[模式][patterns]がうまく照合できた場合は、値の適切な部分を模式中の識別子に束縛したのち、
その式を評価します。 模式の照合に失敗した場合はなにも起きません。

<!--If a [pattern][patterns] matches successfully, it binds any appropriate parts of
the value to the identifiers in the pattern, then evaluates the expression. If
the pattern doesn’t match, nothing happens.-->

照合失敗のときも何かしたい場合は `else` を使います。

<!--If you want to do something else when the pattern does not match, you can
use `else`:-->

```rust
# let option = Some(5);
# fn foo(x: i32) { }
# fn bar() { }
if let Some(x) = option {
    foo(x);
} else {
    bar();
}
```

## `while let`

同じような感覚で `while let`
もある値が特定の模式に照合し続けている間だけ繰り返したい場合に使えます。
次のような譜面があったとすると、それを……

<!--In a similar fashion, `while let` can be used when you want to conditionally
loop  as long as a value matches a certain pattern. It turns code like this:-->

```rust
let mut v = vec![1, 3, 5, 7, 11];
loop {
    match v.pop() {
        Some(x) =>  println!("{}", x),
        None => break,
    }
}
```

……こうします。

<!-- Into code like this: -->

```rust
let mut v = vec![1, 3, 5, 7, 11];
while let Some(x) = v.pop() {
    println!("{}", x);
}
```

[patterns]: patterns.html
