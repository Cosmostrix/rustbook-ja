# もしlet

`if let`は、[if][if]文の条件内で一致する[patterns][patterns]許可し[patterns][patterns]。
これにより、特定の種類の[pattern][patterns]マッチのオーバーヘッドを減らし、それらをより便利な方法で表現することができます。

たとえば、ある種の`Option<T>`があるとしましょう。
`Some<T>`の場合は関数を呼び出したいが、`None`場合は何もしない。
それはこのように見えます：

```rust
# let option = Some(5);
# fn foo(x: i32) { }
match option {
    Some(x) => { foo(x) },
    None => {},
}
```

ここで`match`を使用する必要はありません。たとえば、次の`if`使用できます。

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if option.is_some() {
    let x = option.unwrap();
    foo(x);
}
```

これらのオプションのどちらも特に魅力的ではありません。
もっと良い方法で同じことをする`if let`私たちは使うことができます：

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if let Some(x) = option {
    foo(x);
}
```

[pattern][patterns]正常に一致した場合、[pattern][patterns]内の識別子に値の適切な部分をバインドし、その式を評価します。
パターンが一致しない場合、何も起こりません。

パターンが一致しないときに何か他のことをしたいのであれば、`else`を使うことができ`else`：

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
同様の方法で、あるパターンに一致する限り条件付きでループしたいときに`while let`を使うことができます。
これは次のようなコードになります。

```rust
let mut v = vec![1, 3, 5, 7, 11];
loop {
    match v.pop() {
        Some(x) =>  println!("{}", x),
        None => break,
    }
}
```

このようなコードに：

```rust
let mut v = vec![1, 3, 5, 7, 11];
while let Some(x) = v.pop() {
    println!("{}", x);
}
```

[patterns]: patterns.html
 [if]: if.html

