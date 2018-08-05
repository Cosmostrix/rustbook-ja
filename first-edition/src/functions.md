# 機能

すべてのRustプログラムには、少なくとも1つの関数`main`関数があります。

```rust
fn main() {
}
```

これは、可能な限り単純な関数宣言です。
前に述べたように、`fn`は 'this is a function'と名前の後にいくつかのカッコがあり、この関数は引数をとりません。
`foo`という名前の関数があります：

```rust
fn foo() {
}
```

それで、議論をするのはどうですか？
数値を出力する関数は次のとおりです。

```rust
fn print_number(x: i32) {
    println!("x is: {}", x);
}
```

`print_number`を使用する完全なプログラムを`print_number`ます。

```rust
fn main() {
    print_number(5);
}

fn print_number(x: i32) {
    println!("x is: {}", x);
}
```

ご覧のとおり、関数の引数は`let`宣言と非常によく似ています。引数名にコロンの後に型を追加します。

ここでは、2つの数字を一緒に追加して印刷する完全なプログラムがあります：

```rust
fn main() {
    print_sum(5, 6);
}

fn print_sum(x: i32, y: i32) {
    println!("sum is: {}", x + y);
}
```

関数を呼び出すときも、宣言するときも、引数をカンマで区切ります。

`let`とは異なり、関数の引数の型を宣言する _必要_ が _あり_ ます。
これは動作しません：

```rust,ignore
fn print_sum(x, y) {
    println!("sum is: {}", x + y);
}
```

あなたはこのエラーを受け取ります：

```text
expected one of `!`, `:`, or `@`, found `)`
fn print_sum(x, y) {
```

これは意図的な設計上の決定です。
フルプログラム推論が可能ですが、Haskellのように、あなたの型を明示的に文書化することがベストプラクティスであることをしばしば示唆しています。
関数本体の内部で推論を可能にしながら関数を型宣言することは、完全な推論と推論なしの間のすばらしい場所です。

値を返すのはどうですか？
1つを整数に追加する関数は次のとおりです。

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}
```

Rust関数はちょうど1つの値を返し、ダッシュ（`-`）の後に大なり記号（ `>`）が続く '矢'の後に型を宣言します。
関数の最後の行は、関数が返すものを決定します。
ここでセミコロンがないことに気づくでしょう。
それを追加した場合：

```rust,ignore
fn add_one(x: i32) -> i32 {
    x + 1;
}
```

エラーが発生する：

```text
error: not all control paths return a value
fn add_one(x: i32) -> i32 {
     x + 1;
}

help: consider removing this semicolon:
     x + 1;
          ^
```

これは、Rustに関する2つの面白いことを示しています。表現ベースの言語であり、セミコロンはセミコロンとは異なる中括弧とセミコロンの言語では異なります。
これらの2つのことは関連しています。

## 式とステートメント

錆は、主に表現ベースの言語です。
ステートメントは2種類しかありません。その他はすべて式です。

違いは何ですか？
式は値を返し、ステートメントは値を返しません。
そのため、ここでは、すべての制御パスが値を返すわけではありません`x + 1;`ステートメント`x + 1;`
値を返しません。
Rustには、「宣言文」と「表現文」の2種類の文があります。
他のすべては表現です。
最初に宣言文について説明しましょう。

言語によっては、変数バインディングを文ではなく式として書くことができます。
Rubyのように：

```ruby
x = y = 5
```

しかし、Rustでは`let`を使ってバインディングを導入することは表現ではあり _ません_ 。
以下は、コンパイル時エラーを生成します：

```rust,ignore
#//let x = (let y = 5); // Expected identifier, found keyword `let`.
let x = (let y = 5); // 予想される識別子、found keyword `let`。
```

コンパイラは、式の始まりを見て期待していたことを、ここで私たちに語っている、と`let`唯一の文ではなく、式を開始することができます。

既にバインドされた変数（例えば`y = 5`）に代入することはまだ式であるが、その値は特に有用ではないことに留意されたい。
代入が割り当てられた値（たとえば前の例では`5`に評価される他の言語とは異なり、代入の値は空のタプル`()`です。割り当てられた値に[所有者](ownership.html)が[1人しかなく](ownership.html)、他の戻り値はあまりにも驚くべきこと：

```rust
let mut y = 5;

#//let x = (y = 6);  // `x` has the value `()`, not `6`.
let x = (y = 6);  //  `x`は`6`ではなく、値`()`持ちます。
```

Rustの2番目の種類の文は*式文*です。
その目的は、任意の式をステートメントに変換することです。
実際の言葉で言えば、Rustの文法は、ステートメントが他のステートメントに従うことを期待しています。
つまり、セミコロンを使用して式を互いに区切ります。
これは、Rustは、すべての行の最後にセミコロンを使用する必要がある他の多くの言語とよく似ていることを意味し、Rustコードのほぼすべての行の最後にセミコロンが表示されます。

この例外は、私たちを「ほとんど」と言いますか？
あなたはすでにこのコードでそれを見た：

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}
```

私たちの関数は`i32`を返すと主張していますが、セミコロンでは代わりに`()`が返されます。
Rustはこれがおそらく私たちが望むものではないことを認識し、前に見たエラーのセミコロンを削除することを提案します。

## 早期返品

しかし早期返品はどうですか？
錆は、そのためのキーワードを持っている、`return`：

```rust
fn foo(x: i32) -> i32 {
    return x;

#    // We never run this code!
    // 私たちは決してこのコードを実行しません！
    x + 1
}
```

関数の最後の行として`return`を使用するが、貧弱なスタイルとみなされます：

```rust
fn foo(x: i32) -> i32 {
    return x + 1;
}
```

これまでの表現ベースの言語で作業していない場合、前の定義は`return`なしには少し奇妙に見えるかもしれませんが、時間の経過と共に直感的になります。

## 機能の分散

Rustには、'diverging functions'のための特別な構文があります。これは返さない関数です：

```rust
fn diverges() -> ! {
    panic!("This function never returns!");
}
```

`panic!`はすでに見た`println!()`と同様のマクロです。
`println!()`とは異なり、`panic!()`は現在の実行スレッドを指定のメッセージでクラッシュさせます。
この関数はクラッシュを引き起こすので、それは決して戻ってこないので、' `!` 'は 'diverges'と読み込まれます。

`diverges()`を呼び出すmain関数を追加して実行すると、次のような出力が得られます：

```text
thread ‘main’ panicked at ‘This function never returns!’, hello.rs:2
```

さらに詳しい情報が必要な場合は、`RUST_BACKTRACE`環境変数を設定してバックトレースを取得することができます。

```text
$ RUST_BACKTRACE=1 ./diverges
thread 'main' panicked at 'This function never returns!', hello.rs:2
Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
stack backtrace:
  hello::diverges
        at ./hello.rs:2
  hello::main
        at ./hello.rs:6
```

完全なバックトレースとファイル名が必要な場合：

```text
$ RUST_BACKTRACE=full ./diverges
thread 'main' panicked at 'This function never returns!', hello.rs:2
stack backtrace:
   1:     0x7f402773a829 - sys::backtrace::write::h0942de78b6c02817K8r
   2:     0x7f402773d7fc - panicking::on_panic::h3f23f9d0b5f4c91bu9w
   3:     0x7f402773960e - rt::unwind::begin_unwind_inner::h2844b8c5e81e79558Bw
   4:     0x7f4027738893 - rt::unwind::begin_unwind::h4375279447423903650
   5:     0x7f4027738809 - diverges::h2266b4c4b850236beaa
   6:     0x7f40277389e5 - main::h19bb1149c2f00ecfBaa
   7:     0x7f402773f514 - rt::unwind::try::try_fn::h13186883479104382231
   8:     0x7f402773d1d8 - __rust_try
   9:     0x7f402773f201 - rt::lang_start::ha172a3ce74bb453aK5w
  10:     0x7f4027738a19 - main
  11:     0x7f402694ab44 - __libc_start_main
  12:     0x7f40277386c8 - <unknown>
  13:                0x0 - <unknown>
```

すでに設定されている`RUST_BACKTRACE`を上書きする必要がある場合は、変数を設定解除できない場合はバックトレースを取得しないように`0`に設定します。
その他の値（値がまったくない場合）は、バックトレースをオンにします。

```text
$ export RUST_BACKTRACE=1
...
$ RUST_BACKTRACE=0 ./diverges 
thread 'main' panicked at 'This function never returns!', hello.rs:2
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

`RUST_BACKTRACE`は、Cargoの`run`コマンドでも動作し`run`。

```text
$ RUST_BACKTRACE=full cargo run
     Running `target/debug/diverges`
thread 'main' panicked at 'This function never returns!', hello.rs:2
stack backtrace:
   1:     0x7f402773a829 - sys::backtrace::write::h0942de78b6c02817K8r
   2:     0x7f402773d7fc - panicking::on_panic::h3f23f9d0b5f4c91bu9w
   3:     0x7f402773960e - rt::unwind::begin_unwind_inner::h2844b8c5e81e79558Bw
   4:     0x7f4027738893 - rt::unwind::begin_unwind::h4375279447423903650
   5:     0x7f4027738809 - diverges::h2266b4c4b850236beaa
   6:     0x7f40277389e5 - main::h19bb1149c2f00ecfBaa
   7:     0x7f402773f514 - rt::unwind::try::try_fn::h13186883479104382231
   8:     0x7f402773d1d8 - __rust_try
   9:     0x7f402773f201 - rt::lang_start::ha172a3ce74bb453aK5w
  10:     0x7f4027738a19 - main
  11:     0x7f402694ab44 - __libc_start_main
  12:     0x7f40277386c8 - <unknown>
  13:                0x0 - <unknown>
```

分岐関数は、任意の型として使用できます。

```rust,should_panic
# fn diverges() -> ! {
#    panic!("This function never returns!");
# }
let x: i32 = diverges();
let x: String = diverges();
```

## 関数ポインタ

関数を指す変数バインディングを作成することもできます。

```rust
let f: fn(i32) -> i32;
```

`f`かかる機能を指す結合可変である`i32`引数として戻る`i32`。
例えば：

```rust
fn plus_one(i: i32) -> i32 {
    i + 1
}

#// Without type inference:
// 型推論なし：
let f: fn(i32) -> i32 = plus_one;

#// With type inference:
// 型推論の場合：
let f = plus_one;
```

`f`を使って`f`を呼び出すことができます：

```rust
# fn plus_one(i: i32) -> i32 { i + 1 }
# let f = plus_one;
let six = f(5);
```
