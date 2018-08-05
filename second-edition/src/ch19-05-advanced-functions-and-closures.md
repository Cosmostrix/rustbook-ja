## 発展的な機能と<ruby>閉包<rt>クロージャー</rt></ruby>

最後に、機能<ruby>指し手<rt>ポインタ</rt></ruby>と機能<ruby>閉包<rt>クロージャー</rt></ruby>を含む機能と<ruby>閉包<rt>クロージャー</rt></ruby>に関するいくつかの発展的な機能について説明します。

### 機能<ruby>指し手<rt>ポインタ</rt></ruby>

機能に<ruby>閉包<rt>クロージャー</rt></ruby>を渡す方法について話しました。
正規機能を機能に渡すこともできます。
この手法は、新しい<ruby>閉包<rt>クロージャー</rt></ruby>を定義するのではなく、すでに定義した機能を渡す場合に便利です。
機能<ruby>指し手<rt>ポインタ</rt></ruby>でこれを行うと、機能を他の機能の引数として使用できます。
機能は、`Fn`<ruby>閉包<rt>クロージャー</rt></ruby>の<ruby>特性<rt>トレイト</rt></ruby>と混同しないように、`fn`（小文字のf）型を強制型変換します。
`fn`型は*機能<ruby>指し手<rt>ポインタ</rt></ruby>*と呼ばれ*ます*。
パラメータが機能<ruby>指し手<rt>ポインタ</rt></ruby>であることを指定する構文は、リスト19-35に示すように、<ruby>閉包<rt>クロージャー</rt></ruby>の構文に似ています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer = do_twice(add_one, 5);

    println!("The answer is: {}", answer);
}
```

<span class="caption">リスト19-35。 <code>fn</code>型を使って機能<ruby>指し手<rt>ポインタ</rt></ruby>を引数として受け入れる</span>

この<ruby>譜面<rt>コード</rt></ruby>`The answer is: 12`。
`do_twice`のパラメータ`f`は、型`i32` 1つのパラメータをとり、`i32`を返す`fn`あると指定します。
`do_twice`の本文で`f`を呼び出すことができます。
では`main`、機能名を渡すことができ`add_one`最初の引数として`do_twice`。

<ruby>閉包<rt>クロージャー</rt></ruby>とは異なり、`fn`は<ruby>特性<rt>トレイト</rt></ruby>ではなく型なので、`Fn`<ruby>特性<rt>トレイト</rt></ruby>の1つを<ruby>特性<rt>トレイト</rt></ruby>縛りとして持つ総称型パラメータを宣言するのではなく、直接パラメータ型として`fn`を指定します。

機能<ruby>指し手<rt>ポインタ</rt></ruby>は、3つの閉包<ruby>特性<rt>トレイト</rt></ruby>（`Fn`、 `FnMut`、および`FnOnce`）をすべて実装しているため、<ruby>閉包<rt>クロージャー</rt></ruby>が必要な機能の引数として機能<ruby>指し手<rt>ポインタ</rt></ruby>ーを渡すことができます。
総称型と閉包<ruby>特性<rt>トレイト</rt></ruby>の1つを使用して機能を書くことが最善です。そのため、機能は機能または<ruby>閉包<rt>クロージャー</rt></ruby>を受け入れることができます。

<ruby>閉包<rt>クロージャー</rt></ruby>を持たない外部<ruby>譜面<rt>コード</rt></ruby>との<ruby>接点<rt>インターフェース</rt></ruby>をとる場合は、`fn`だけを受け取り、<ruby>閉包<rt>クロージャー</rt></ruby>を受け入れない場合の例です。C機能は機能を引数として受け入れることができますが、Cには<ruby>閉包<rt>クロージャー</rt></ruby>はありません。

行内で定義された<ruby>閉包<rt>クロージャー</rt></ruby>または名前付き機能を使用できる場所の例として、`map`使用を見てみましょう。
`map`機能を使用して数値のベクトルを<ruby>文字列<rt>ストリング</rt></ruby>のベクトルにするには、次のように<ruby>閉包<rt>クロージャー</rt></ruby>を使用します。

```rust
let list_of_numbers = vec![1, 2, 3];
let list_of_strings: Vec<String> = list_of_numbers
    .iter()
    .map(|i| i.to_string())
    .collect();
```

あるいは、次のように<ruby>閉包<rt>クロージャー</rt></ruby>の代わりに機能を`map`の引数として指定することもできます。

```rust
let list_of_numbers = vec![1, 2, 3];
let list_of_strings: Vec<String> = list_of_numbers
    .iter()
    .map(ToString::to_string)
    .collect();
```

`to_string`という名前の機能が複数存在するので、「先進的な<ruby>特性<rt>トレイト</rt></ruby>」の章で前述した完全修飾構文を使用する必要があることに注意してください。
ここでは、`ToString`<ruby>特性<rt>トレイト</rt></ruby>で定義された`to_string`機能を使用しています。標準<ruby>譜集<rt>ライブラリー</rt></ruby>は、`Display`実装するすべての型に対して実装しています。

この作法を好む人もいれば、<ruby>閉包<rt>クロージャー</rt></ruby>を使う人もいます。
それらは同じ<ruby>譜面<rt>コード</rt></ruby>に<ruby>製譜<rt>コンパイル</rt></ruby>されてしまいますので、どちらの作法でもより明確になります。

### 戻る<ruby>閉包<rt>クロージャー</rt></ruby>

<ruby>閉包<rt>クロージャー</rt></ruby>は<ruby>特性<rt>トレイト</rt></ruby>によって表されます。つまり、<ruby>閉包<rt>クロージャー</rt></ruby>を直接返すことはできません。
ほとんどの場合、<ruby>特性<rt>トレイト</rt></ruby>を返す必要がある場合は、その<ruby>特性<rt>トレイト</rt></ruby>を実装する具象型を機能の戻り値として使用することができます。
しかし、<ruby>閉包<rt>クロージャー</rt></ruby>ではリターン可能な具体的な型がないため、これを行うことはできません。
たとえば、戻り値の型として機能<ruby>指し手<rt>ポインタ</rt></ruby>`fn`を使用することはできません。

次の<ruby>譜面<rt>コード</rt></ruby>は<ruby>閉包<rt>クロージャー</rt></ruby>を直接返しますが、<ruby>製譜<rt>コンパイル</rt></ruby>されません。

```rust,ignore
fn returns_closure() -> Fn(i32) -> i32 {
    |x| x + 1
}
```

<ruby>製譜器<rt>コンパイラー</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>は次のとおりです。

```text
error[E0277]: the trait bound `std::ops::Fn(i32) -> i32 + 'static:
std::marker::Sized` is not satisfied
 -->
  |
1 | fn returns_closure() -> Fn(i32) -> i32 {
  |                         ^^^^^^^^^^^^^^ `std::ops::Fn(i32) -> i32 + 'static`
  does not have a constant size known at compile-time
  |
  = help: the trait `std::marker::Sized` is not implemented for
  `std::ops::Fn(i32) -> i32 + 'static`
  = note: the return type of a function must have a statically known size
```

<ruby>誤り<rt>エラー</rt></ruby>は`Sized`<ruby>特性<rt>トレイト</rt></ruby>を再度参照します！　
Rustは、<ruby>閉包<rt>クロージャー</rt></ruby>を保管するためにどれだけのスペースが必要かを知らない。
この問題を早期に解決する方法を見つけました。
<ruby>特性<rt>トレイト</rt></ruby>対象を使うことができます。

```rust
fn returns_closure() -> Box<Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}
```

この<ruby>譜面<rt>コード</rt></ruby>はうまく<ruby>製譜<rt>コンパイル</rt></ruby>されます。
<ruby>特性<rt>トレイト</rt></ruby>対象の詳細は、第17章の「異なる型の値を許容する<ruby>特性<rt>トレイト</rt></ruby>対象の使用」を参照してください。

## 概要

すごい！　
今では道具ボックスにRustの機能がいくつかありますが、頻繁に使用することはありませんが、非常に特殊な状況で使用できることがわかります。
<ruby>誤り<rt>エラー</rt></ruby>メッセージの提案や他の人々の<ruby>譜面<rt>コード</rt></ruby>に遭遇したときに、これらの概念や構文を認識できるように、いくつかの複雑な話題を導入しました。
この章を参考にして、ソリューションをご案内します。

次に、本で議論したことのすべてを実践し、もう1つの企画を行います。
