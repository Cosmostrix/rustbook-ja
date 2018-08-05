# h1
h1text

## h2

h2text

- 第1レベル
  * セカンドレベル

```lang
code
#  // block
#  // block `is!` ok
  // ブロックブロック`is!` OKです
code {
  indent {
#//    preserved; // comment
    preserved; // コメント
  }
}

^ newline
```

> > `try!`

> > 長い見積もり

段落

[id]: href

[id]: href
[`txt`](href) [txt][id] [オブジェクトを処理する](../href) `code` ``code2`` *emph1*  _emph2_  **strong1**  __strong2__  str nextline


<span class="filename">ファイル名：src / main.rs</span><span class="keystroke">ctrl-c</span>
<img src="img/trpl04-01.svg" alt="メモリ内の文字列" class="center" /> <span class="caption">図4-1： <code>s1</code>バインドされた値<code>&quot;hello&quot;</code>保持する<code>String</code>メモリ内の表現</span><span class="caption">リスト4-1：変数とその有効範囲</span>

```rust
fn main() {
#//    let s = String::from("hello");  // s comes into scope
    let s = String::from("hello");  //  sは範囲に入る

#//    takes_ownership(s);             // s's value moves into the function...
#                                    // ... and so is no longer valid here
    takes_ownership(s);             //  sの値が関数に移ります......そして、もはやここでは有効ではありません

#//    let x = 5;                      // x comes into scope
    let x = 5;                      //  xが範囲に入る

#//    makes_copy(x);                  // x would move into the function,
#                                    // but i32 is Copy, so it’s okay to still
#                                    // use x afterward
    makes_copy(x);                  //  xは関数に移りますが、i32はコピーなので、後でxを使うのは大丈夫です

#//} // Here, x goes out of scope, then s. But because s's value was moved, nothing
#  // special happens.
} // ここで、xは範囲外になり、次にs。しかし、sの価値が動かされたので、特別なことは起こりません。

#//fn takes_ownership(some_string: String) { // some_string comes into scope
fn takes_ownership(some_string: String) { //  some_stringが範囲に入る
    println!("{}", some_string);
#//} // Here, some_string goes out of scope and `drop` is called. The backing
#  // memory is freed.
} // ここで、some_stringは範囲外になり、`drop`が呼び出されます。バッキングメモリが解放されます。

#//fn makes_copy(some_integer: i32) { // some_integer comes into scope
fn makes_copy(some_integer: i32) { //  some_integerが範囲に入る
    println!("{}", some_integer);
#//} // Here, some_integer goes out of scope. Nothing special happens.
} // ここで、some_integerは範囲外になります。何も特別なことは起こりません。
```
