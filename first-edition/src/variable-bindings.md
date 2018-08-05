# 変数バインディング

事実上、「Hello World」以外のすべてのプログラムでは、*可変バインディングが*使用され*ます*。
彼らは名前にある値をバインドするので、後で使用することができます。
`let`は以下のようにバインディングを導入するために使用されます：

```rust
fn main() {
    let x = 5;
}
```

`fn main() {`置くのはちょっと面倒なので、私たちは将来それを残しておきます。
あなたがフォローしている場合は、`main()`関数を編集してください。
そうしないと、エラーが発生します。

# パターン

多くの言語では、可変バインディングは変数と呼ばれ*ます*が、ラストの可変バインディングは、その袖の上にいくつかのトリックがあります。
たとえば、`let`文の左側は変数名ではなく ' [pattern][pattern] 'です。
つまり、次のようなことができます。

```rust
let (x, y) = (1, 2);
```

このステートメントが評価されると、`x`は1になり、`y`は2になります。
パターンは本当に強力で、本に[独自のセクション][pattern]があります。
私たちは今はそのような機能を必要としないので、私たちが前進していくうちに、これを私たちの心の中に残しておきます。

[pattern]: patterns.html

# アノテーションを入力

錆は静的に型指定された言語です。つまり、型を前もって指定し、コンパイル時にチェックします。
では、最初の例はなぜコンパイルされますか？
まあ、錆は、このタイプの推論と呼ばれるものを持っています。
何かのタイプが何であるかを知ることができれば、明示的にそれをタイプする必要はありません。

しかし、もし私たちが望むのであれば、そのタイプを追加することができます。
タイプは、コロンの後に来ます（`:`）：

```rust
let x: i32 = 5;
```

私があなたにこれを授業の残りの部分に朗読するように頼んだら、「 `x`はタイプ`i32`と値`5`との拘束です」と言うでしょう。

この例では、`x`を32ビット符号付き整数として表現することを選択しました。
Rustには多くの異なるプリミティブ型があります。
符号付き整数の場合は`i`で始まり、符号なし整数の場合は`u`で始まります。
可能な整数サイズは、8,16,32、および64ビットです。

将来の例では、コメントに型を注釈することができます。
例は次のようになります。

```rust
fn main() {
#//    let x = 5; // x: i32
    let x = 5; //  x：i32
}
```

この注釈と`let`使用する構文との類似点に注意してください。
このような種類のコメントを含めることは、慣用的な錆ではありませんが、錆が推論するタイプが何であるかを理解するのに役立つ場合があります。

# 変異性

デフォルトでは、バインディングは*不変*です。
このコードはコンパイルされません：

```rust,ignore
let x = 5;
x = 10;
```

それはあなたにこのエラーを与えるでしょう：

```text
error: re-assignment of immutable variable `x`
     x = 10;
     ^~~~~~~
```

バインディングを変更可能にするには、`mut`を使用します。

```rust
#//let mut x = 5; // mut x: i32
let mut x = 5; //  mut x：i32
x = 10;
```

バインディングがデフォルトで不変であるという単一の理由はありませんが、Rustの主な焦点である安全性の1つによって考えることができます。
あなたが`mut`を言うのを忘れた場合、コンパイラはそれをキャッチし、あなたが変異させようとしなかったかもしれない何かを突然変異させたことを知らせます。
バインディングがデフォルトで変更可能な場合、コンパイラはこれを伝えることができません。
あなた _が_ 突然変異を意図して _いた_ なら、その解決法は非常に簡単です： `mut`追加してください。

可能であれば、可変状態を避ける他の理由がありますが、このガイドの範囲外です。
一般に、明示的な突然変異を避けることができることが多いので、Rustでは好ましい。
それは時々、突然変異が必要なものだと言われているので、禁止されていません。

# バインディングの初期化

Rust変数バインディングには、他の言語とは異なるもう1つの側面があります。バインディングは、使用を許可される前に値で初期化する必要があります。

それを試してみましょう。
`src/main.rs`ファイルを次のように変更します。

```rust
fn main() {
    let x: i32;

    println!("Hello world!");
}
```

コマンドラインで`cargo build`を使用して`cargo build`ことができます。
警告が表示されますが、それでも "Hello、world！"と表示されます：

```text
   Compiling hello_world v0.0.1 (file:///home/you/projects/hello_world)
src/main.rs:2:9: 2:10 warning: unused variable: `x`, #[warn(unused_variables)]
   on by default
src/main.rs:2     let x: i32;
                      ^
```

Rustは可変バインディングを決して使用しないことを警告しますが、決して使用しないので、害もなく、ファウルもありません。
しかし、実際にこの`x`使用しようとすると、ものが変わります。
そうしよう。
プログラムを次のように変更します。

```rust,ignore
fn main() {
    let x: i32;

    println!("The value of x is: {}", x);
}
```

それを構築しようとする。
エラーが表示されます：

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/you/projects/hello_world)
src/main.rs:4:39: 4:40 error: use of possibly uninitialized variable: `x`
src/main.rs:4     println!("The value of x is: {}", x);
                                                    ^
note: in expansion of format_args!
<std macros>:2:23: 2:77 note: expansion site
<std macros>:1:1: 3:2 note: in expansion of println!
src/main.rs:4:5: 4:42 note: expansion site
error: aborting due to previous error
Could not compile `hello_world`.
```

錆は私たちに初期化されていない値を使用させません。

私たちが`println!`追加したこのことについて話をしましょう。

あなたの文字列に2つの中括弧（`{}`、それらにmustachesと呼ぶもの）を入れると、Rustはこれをある種の値を補間する要求として解釈します。
*文字列補間*は、"文字列の真ん中に固執する"ことを意味するコンピュータサイエンス用語です。
カンマと`x`を加えて、`x`を補間したい値にしたいことを示します。
カンマは、複数の関数を渡している場合は、関数とマクロに渡す引数を区切るために使用されます。

中括弧を使用すると、Rustはその型をチェックアウトすることによって意味のある方法で値を表示しようとします。
フォーマットをより詳細に指定する場合は、[利用可能なオプションが多数あります][format]。
現時点では、デフォルト値に固執します。整数は印刷するのがあまり複雑ではありません。

[format]: ../../std/fmt/index.html

# スコープとシャドーイング

バインディングに戻りましょう。
変数バインディングにはスコープがあり、定義されたブロック内に存在するように制約されています。ブロックは`{`と`}`囲まれたステートメントの集合です。
関数定義もブロックです！
次の例では、異なるブロックに存在する2つの変数バインディング`x`と`y`を定義しています。
`x`は`fn main() {}`ブロックの内側からアクセスできますが、`y`は内部ブロックからのみアクセスできます。

```rust,ignore
fn main() {
    let x: i32 = 17;
    {
        let y: i32 = 3;
        println!("The value of x is {} and value of y is {}", x, y);
    }
#//    println!("The value of x is {} and value of y is {}", x, y); // This won't work.
    println!("The value of x is {} and value of y is {}", x, y); // これは動作しません。
}
```

最初の`println!`は "xの値は17でyの値は3"ですが、この例は正常にコンパイルできません。これは、2番目の`println!`がスコープ内にもうないので、`y`の値にアクセスできないためです。
代わりにこのエラーが発生します。

```bash
$ cargo build
   Compiling hello v0.1.0 (file:///home/you/projects/hello_world)
main.rs:7:62: 7:63 error: unresolved name `y`. Did you mean `x`? [E0425]
#//main.rs:7     println!("The value of x is {} and value of y is {}", x, y); // This won't work.
main.rs:7     println!("The value of x is {} and value of y is {}", x, y); // これは動作しません。
                                                                       ^
note: in expansion of format_args!
<std macros>:2:25: 2:56 note: expansion site
<std macros>:1:1: 2:62 note: in expansion of print!
<std macros>:3:1: 3:54 note: expansion site
<std macros>:1:1: 3:58 note: in expansion of println!
main.rs:7:5: 7:65 note: expansion site
main.rs:7:62: 7:63 help: run `rustc --explain E0425` to see a detailed explanation
error: aborting due to previous error
Could not compile `hello`.

To learn more, run the command again with --verbose.
```

さらに、可変バインディングをシャドーイングすることもできます。
これは、現在スコープ内にある別のバインディングと同じ名前の後の変数バインディングが、以前のバインドをオーバーライドすることを意味します。

```rust
let x: i32 = 8;
{
#//    println!("{}", x); // Prints "8".
    println!("{}", x); //  "8"を印刷します。
    let x = 12;
#//    println!("{}", x); // Prints "12".
    println!("{}", x); //  「12」を印刷します。
}
#//println!("{}", x); // Prints "8".
println!("{}", x); //  "8"を印刷します。
let x =  42;
#//println!("{}", x); // Prints "42".
println!("{}", x); //  "42"を印刷します。
```

シャドーイングと変更可能なバインディングは、同じコインの2つの側面として表示されることがありますが、必ずしも同じ意味で使われるわけではない2つの異なる概念です。
1つは、シャドウイングにより、名前を異なるタイプの値に再バインドすることができます。
バインディングの変更可能性を変更することも可能です。
名前をシャドーイングすると、それがバインドされた値が変更または破棄されることはなく、たとえアクセスできなくなっても、値は範囲外になるまで存在し続けることに注意してください。

```rust
let mut x: i32 = 1;
x = 7;
#//let x = x; // `x` is now immutable and is bound to `7`.
let x = x; //  `x`は現在不変であり、`7`バインドされています。

let y = 4;
#//let y = "I can also be bound to text!"; // `y` is now of a different type.
let y = "I can also be bound to text!"; //  `y`は現在異なるタイプです。
```
