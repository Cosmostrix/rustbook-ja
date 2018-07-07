% 薄切り模式

薄切り (slice)〈スライス〉または配列に対して照合させたいときは、
`&` を `slice_patterns` 機構と一緒に使います。

<!--If you want to match against a slice or array, you can use `&` with the
`slice_patterns` feature:-->

```rust
#![feature(slice_patterns)]

fn main() {
    let v = vec!["これに合致", "1"];

    match &v[..] {
        ["これに合致", second] => println!("二番目の要素は {}", second),
        _ => {},
    }
}
```

`advanced_slice_patterns` 〈ゲート〉は薄切りの模式照合の中で `..`
を使った不定な数の要素を表現を許可します。
この身代わり〈ワイルドカード〉はひとつの配列につき一度のみ使えます。
`..` の直前に識別子があった場合は薄切りの結果がその名前に束縛されます。
これはその一例です。

<!--The `advanced_slice_patterns` gate lets you use `..` to indicate any number of
elements inside a pattern matching a slice. This wildcard can only be used once
for a given array. If there's an identifier before the `..`, the result of the
slice will be bound to that name. For example:-->

```rust
#![feature(advanced_slice_patterns, slice_patterns)]

fn is_symmetric(list: &[u32]) -> bool {
    match list {
        [] | [_] => true,
        [x, inside.., y] if x == y => is_symmetric(inside),
        _ => false
    }
}

fn main() {
    let sym = &[0, 1, 4, 2, 4, 1, 0];
    assert!(is_symmetric(sym));

    let not_sym = &[0, 1, 7, 2, 4, 1, 0];
    assert!(!is_symmetric(not_sym));
}
```
