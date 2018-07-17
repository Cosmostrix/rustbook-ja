## テストを書く方法

テストは、非テスト譜面が期待どおりに機能していることを検証するRust機能です。
テスト機能の本体は、通常、次の3つの動作を実行します。

1. 必要なデータや状態を設定します。
2. テストする譜面を実行します。
3. アサート結果は期待通りです。

Rustが、`test`属性、いくつかのマクロ、`should_panic`属性を含むこれらの動作を実行するテストを記述するために特に提供する機能を見てみましょう。

### テスト機能の解剖

最も簡単な方法では、Rustでの`test`は`test`属性で注釈を付けられた機能です。
属性は、Rust譜面に関するメタデータです。
1つの例は、第5章でstructで使用した`derive`属性です。機能をテスト機能に変更するには、`fn`前の行に`#[test]`を追加します。
`cargo test`命令でテストを実行すると、Rustは`test`属性で注釈を付けられた機能を実行するテストランナー二進譜を作成し、各テスト機能が成功するか失敗するかを報告します。

第7章では、Cargoを使用して新しい譜集企画を作成するときに、その中にテスト機能を持つテスト役区が自動的に生成されることがわかりました。
この役区はテストの作成を開始するのに役立ちますので、新しい企画を開始するたびにテスト機能の構造と構文を正確に調べる必要はありません。
必要なだけ多くのテスト機能とテスト役区を追加することができます。

実際に譜面をテストすることなく、ために生成されたひな型テストを試すことで、テストの仕組みの一部の側面を探求します。
次に、書いた譜面を呼び出し、その動作が正しいことを主張する実際のテストを書きます。

`adder`という新しい譜集企画を作成しましょう。

```text
$ cargo new adder --lib
     Created library `adder` project
$ cd adder
```

`adder`譜集内の*src/lib.rs*ファイルの内容はリスト11-1のようになります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
```

<span class="caption">リスト11-1。 <code>cargo new</code>によって自動的に生成されたテスト役区と機能</span>

今のところ、上の2行を無視して、機能にどのように作用するかを見てみましょう。
`fn`行の前に`#[test]`注釈があることに注意してください。この属性はこれがテスト機能であることを示しているので、テストランナーはこの機能をテストとして扱うことを知っています。
`tests`役区には、共通の場合を設定したり、一般的な操作を実行するための非テスト機能もあるので、`#[test]`属性を使用して、どの機能がテストであるかを示す必要があります。

機能本体は`assert_eq!`マクロを使用して、2 + 2が4に等しいことを宣言します。このアサーションは、典型的なテストの形式の例として機能します。
このテストが合格することを確認するために実行してみましょう。

`cargo test`命令は、リスト11-2に示すように、企画内のすべてのテストを実行します。

```text
$ cargo test
   Compiling adder v0.1.0 (file:///projects/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.22 secs
     Running target/debug/deps/adder-ce99bcc2479f4607

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

<span class="caption">リスト11-2。自動的に生成されたテストを実行したときの出力</span>

カーゴは製譜され、テストが実行されました。
`Compiling`、 `Finished`、 `Running`行は、`running 1 test`を`Running`行です。
次の行には、生成されたテスト機能の名前`it_works`とそのテストを実行した結果`ok`ます。
次に、テストの実行の概要が表示されます。
テキスト`test result: ok.`
すべてのテストが合格したことを意味`1 passed; 0 failed`
`1 passed; 0 failed` totalは、合格または不合格のテストの数を示します。

無視されたテストはないため、サマリーには`0 ignored`た`0 ignored`ます。
また、実行されているテストをフィルタリングしていないため、要約の最後には`0 filtered out`た`0 filtered out`ます。
テストの無視と除外については、次の章「テストの実行方法の制御」で説明します。

`0 measured`統計値は、パフォーマンスを測定するベンチマークテストのものです。
ベンチマークテストは、この記事の執筆時点で、夜間のRustだけで利用可能です。
詳細[は、ベンチマークテストに関する開発資料を][bench]参照してください。

[bench]: ../../unstable-book/library-features/test.html

`Doc-tests adder`で始まるテスト出力の次の部分は、開発資料集テストの結果です。
まだ開発資料テストはありませんが、RustはAPI開発資料に記載されている譜面例を製譜できます。
この機能は、開発資料と譜面を同期させるのに役立ちます。
第14章の「開発資料集注釈をテストとして」の章で開発資料テストを書く方法について説明します。今度は、`Doc-tests`出力を無視します。

テストの名前を変更してテスト出力をどのように変更するかを見てみましょう。
`it_works`機能を`exploration`などの別の名前に変更します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[cfg(test)]
mod tests {
    #[test]
    fn exploration() {
        assert_eq!(2 + 2, 4);
    }
}
```

次に、再び`cargo test`実行します。
出力に`it_works`代わりに`exploration`ように`it_works`。

```text
running 1 test
test tests::exploration ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

別のテストを追加しましょう。今回は失敗したテストを行います。
テスト機能で何かがパニックすると、テストは失敗します。
各テストは新しい走脈で実行され、メイン走脈がテスト走脈が終了したことがわかると、テストは失敗とマークされます。
パニックを引き起こす最も単純な方法について話しました。`panic!`を呼び出すこと`panic!`。
新しいテストを`another`入力すると、*src/lib.rs*ファイルはリスト11-3のように*なり*ます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[cfg(test)]
mod tests {
    #[test]
    fn exploration() {
        assert_eq!(2 + 2, 4);
    }

    #[test]
    fn another() {
        panic!("Make this test fail");
    }
}
```

<span class="caption">リスト11-3。 <code>panic€</code>マクロを呼び出すために失敗する2番目のテストを追加する</span>

`cargo test`を使用してテストを再実行します。
リスト11-4のような出力が表示されます。これは、`exploration`テストが合格し、`another`失敗したことを示しています。

```text
running 2 tests
test tests::exploration ... ok
test tests::another ... FAILED

failures:

---- tests::another stdout ----
    thread 'tests::another' panicked at 'Make this test fail', src/lib.rs:10:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

failures:
    tests::another

test result: FAILED. 1 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out

error: test failed
```

<span class="caption">譜面リスト11-4。1つのテストが合格し、1つのテストが失敗した場合のテスト結果</span>

`ok`代わりに、回線`test tests::another`が`FAILED`示しています。
2つの新しい章が個々の結果とサマリーの間に表示されます。最初の章には、それぞれのテストの失敗の詳細な理由が表示されます。
この場合、*src/lib.rs*ファイルの10行目で起こった`panicked at 'Make this test fail'`で`panicked at 'Make this test fail'`たため`another`失敗しました。
次の章では、失敗したすべてのテストの名前だけを示します。これは、たくさんのテストがあり、多くの詳細な失敗したテスト出力がある場合に便利です。
失敗したテストの名前を使用して、そのテストだけを実行してより簡単に虫取りすることができます。
テストを実行する方法の詳細については、「テストの実行方法の制御」の章で説明します。

終了時に要約行が表示されます。全体的に、テスト結果は`FAILED`です。
1回のテストパスと1回のテストが失敗しました。

さまざまな場合でテスト結果がどのように見えるかを見てきましたので、テストで役立つ`panic!`以外のマクロを見てみましょう。

### `assert!`マクロによる結果の確認

標準譜集によって提供される`assert!`マクロは、テスト中のある条件が`true`評価されることを確実にしたい場合に便利`true`。
真偽値に評価する引数を`assert!`マクロに与えます。
値が`true`場合、`assert!`は何もせず、テストに合格します。
値が`false`場合、`assert!`マクロは`panic!`呼び出すため、テストが失敗します。
`assert!`マクロを使用する`assert!`、譜面が意図したとおりに機能していることを確認するのに役立ちます。

第5章のリスト5-15では、`Rectangle`構造体と`can_hold`操作法を使用しました。リスト11-5でこれを繰り返します。
この譜面を*src/lib.rs*ファイルに*置き*、 `assert!`マクロを使っていくつかのテストを書きましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[derive(Debug)]
pub struct Rectangle {
    length: u32,
    width: u32,
}

impl Rectangle {
    pub fn can_hold(&self, other: &Rectangle) -> bool {
        self.length > other.length && self.width > other.width
    }
}
```

<span class="caption">リスト11-5。 <code>Rectangle</code>構造体と第5章の<code>can_hold</code>操作法の使用</span>

`can_hold`操作法は真偽値を返します。`can_hold`、 `assert!`マクロの完璧な使用例です。
リスト11-6において、行使テスト書き込み`can_hold`作成方法を`Rectangle` 8の長さと7の幅を有する実例を、それが別の保持することができると主張`Rectangle` 5の長さと幅を有する実例を1。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn larger_can_hold_smaller() {
        let larger = Rectangle { length: 8, width: 7 };
        let smaller = Rectangle { length: 5, width: 1 };

        assert!(larger.can_hold(&smaller));
    }
}
```

<span class="caption">リスト11-6。大きな長方形が実際に小さな長方形を保持できるかどうかを調べる<code>can_hold</code>のテスト</span>

`tests`役区の中に新しい行を追加したことに注意してください。 `use super::*;`
。
`tests`役区は、「プライバシールール」章の第7章で説明した通常の表示ルールに従う通常の役区です。
`tests`役区は内部役区なので、外部役区のテスト対象譜面を内部役区の有効範囲に持っていく必要があります。
ここではグロブを使用しているので、外部役区で定義したものはすべてこの`tests`役区で使用できます。

`larger_can_hold_smaller`という名前のテストを作成し、必要な2つの`Rectangle`実例を作成しました。
次に`assert!`マクロを呼び出し、`larger.can_hold(&smaller)`を呼び出した結果を渡します。
この式は`true`を返すと想定されているので、テストは成功するはずです。
確認してみましょう！　

```text
running 1 test
test tests::larger_can_hold_smaller ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

それは合格する！　
別のテストを追加してみましょう。今回は、小さな長方形で大きな長方形を保持できないと主張します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn larger_can_hold_smaller() {
#        // --snip--
        //  --snip--
    }

    #[test]
    fn smaller_cannot_hold_larger() {
        let larger = Rectangle { length: 8, width: 7 };
        let smaller = Rectangle { length: 5, width: 1 };

        assert!(!smaller.can_hold(&larger));
    }
}
```

この場合の`can_hold`機能の正しい結果は`false`であるため、その結果を`assert!`マクロに渡す前にその結果を否定する必要があります。
その結果、`can_hold`が`false`返す場合、テストは成功し`false`。

```text
running 2 tests
test tests::smaller_cannot_hold_larger ... ok
test tests::larger_can_hold_smaller ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

2つのテストが合格！　
次に、譜面にバグを導入したときに、テスト結果に何が起こるかを見てみましょう。
長さを比較するときに大なり記号を小記号で置き換えることにより、`can_hold`操作法の実装を変更しましょう。

```rust
# fn main() {}
# #[derive(Debug)]
# pub struct Rectangle {
#     length: u32,
#     width: u32,
# }
#// --snip--
//  --snip--

impl Rectangle {
    pub fn can_hold(&self, other: &Rectangle) -> bool {
        self.length < other.length && self.width > other.width
    }
}
```

テストを実行すると、以下が生成されます。

```text
running 2 tests
test tests::smaller_cannot_hold_larger ... ok
test tests::larger_can_hold_smaller ... FAILED

failures:

---- tests::larger_can_hold_smaller stdout ----
    thread 'tests::larger_can_hold_smaller' panicked at 'assertion failed:
    larger.can_hold(&smaller)', src/lib.rs:22:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

failures:
    tests::larger_can_hold_smaller

test result: FAILED. 1 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

テストではバグが見つかった！　
`larger.length`は8で`smaller.length`は5であるため、`can_hold`の長さの比較は`false`返し`false`.8は5以上です。

### `assert_eq!`および`assert_ne!`マクロを使用した`assert_eq!`テスト

機能をテストする一般的な方法は、テスト中の譜面の結果と、譜面が一致することを期待する値とを比較することです。
これを行うには`assert!`マクロを使用し、`==`演算子を使用して式を渡します。
しかし、これは、標準譜集がこのテストをより便利に実行するために`assert_eq!`と`assert_ne!` `assert_eq!`提供するような共通のテストです。
これらのマクロは、それぞれ平等または不等式の2つの引数を比較します。
アサーションに失敗した場合は、2つの値も出力される*ため*、テストが失敗した*理由を*簡単に確認できます。
逆に、`assert!`マクロは、それが持っていることを示し`false`の値を`==`表現ではなく、につながるの値`false`値。

`add_two`リスト11-7では`add_two`という名前の機能を書いて、そのパラメータに`2`を加えて結果を返します。
次に、`assert_eq!`マクロを使ってこの機能をテストします。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_adds_two() {
        assert_eq!(4, add_two(2));
    }
}
```

<span class="caption">リスト11-7。機能検査<code>add_two</code>使用して<code>assert_eq€</code>マクロを</span>

それが通過することをチェックしよう！　

```text
running 1 test
test tests::it_adds_two ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

得た最初の引数`assert_eq!`マクロ`4`、呼び出した結果に等しい`add_two(2)`
このテストのための行は、`test tests::it_adds_two ... ok`、および`ok`のテキストは、テストに合格していることを示しています！　

`assert_eq!`を使ったテストが失敗したときの様子を見てみましょう。
`add_two`機能の実装を変更して、代わりに`3`を追加します。

```rust
# fn main() {}
pub fn add_two(a: i32) -> i32 {
    a + 3
}
```

テストをもう一度実行します。

```text
running 1 test
test tests::it_adds_two ... FAILED

failures:

---- tests::it_adds_two stdout ----
        thread 'tests::it_adds_two' panicked at 'assertion failed: `(left == right)`
  left: `4`,
 right: `5`', src/lib.rs:11:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

failures:
    tests::it_adds_two

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

テストではバグが見つかった！　
`it_adds_two`テストが失敗し、メッセージ``assertion failed: `(left == right)```と表示され、`left`が`4`で`right`が`5`あったこと`left`示されます。
このメッセージは有用で、虫取りを開始するのに役立ちます。つまり、`assert_eq!`の`left`引数は`4`でしたが、`add_two(2)`があった`right`引数は`5`でした。

他の言語とテストFrameworkでは、2つの値が同じであると宣言する機能のパラメータを`expected`値と`actual`と呼び、引数を指定する順序が重要であることに注意してください。
しかし、ルーストに、それらは呼ばれている`left`と`right`、そして期待値とテスト対象の譜面は問題ではありません生成する値を指定する順序。
このテストでアサーションを`assert_eq!(add_two(2), 4)`として書くと、アサーションが失敗したという誤りメッセージが表示されます``assertion failed: `(left == right)```、 `left`は`5`、 `right`は`4`でした。

`assert_ne!`マクロは、与えられた2つの値が等しくない場合に合格し、等しい場合に失敗します。
このマクロは、値*が*どのようなものかわからない場合に最も便利ですが、意図したとおりに譜面が機能している場合*は*、値がどう*なる*かはわかります。
たとえば、何らかの方法で入力を変更することが保証されている機能をテストする場合、入力を変更する方法はテストを実行する曜日によって異なりますが、機能の出力が入力と等しくないことを示します。

表面の下では、`assert_eq!`および`assert_ne!`マクロはそれぞれ演算子`==`および`!=`を使用します。
アサーションが失敗した場合、これらのマクロは引数を出力します。これは、比較される値が`PartialEq`と`Debug`特性を実装しなければならないことを意味します。
すべての基本型とほとんどの標準譜集型は、これらの特性を実装しています。
定義した構造体と列挙体では、`PartialEq`を実装して、それらの型の値が等しいかどうかを`PartialEq`する必要があります。
アサーションが失敗したときに値を出力するには、`Debug`を実装する必要があります。
第5章のリスト5-12で説明したように、両方の特性が導出可能な特性であるため、`#[derive(PartialEq, Debug)]`補注を構造体または列挙型の定義に追加するのと`#[derive(PartialEq, Debug)]`です。
これらおよび他の導出可能な特性の詳細については、付録Cを参照してください。

### 独自の誤りメッセージの追加

`assert!`、 `assert_eq!`、および`assert_ne!`マクロへの選択肢の引数として、失敗メッセージとともに出力される独自のメッセージを追加することもできます。
`assert!`または`assert_eq!`と`assert_ne!`必要な2つの引数を`assert_eq!`マクロに渡し`format!`（第8章の「 `+`演算子または`format!`マクロの連結」の章で説明してい`format!`）、含まれている形式文字列渡すことができますので、 `{}`これらの場所取りに行くための場所取りと値を。
独自のメッセージは、アサーションが意味するものを文書化するのに便利です。
テストが失敗した場合は、譜面の問題の詳細を知ることができます。

たとえば、名前で人を迎える機能があり、機能に渡す名前が出力に現れることをテストしたいとしましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
pub fn greeting(name: &str) -> String {
    format!("Hello {}!", name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greeting_contains_name() {
        let result = greeting("Carol");
        assert!(result.contains("Carol"));
    }
}
```

この算譜の要件はまだ合意されていません。挨拶の開始時の`Hello`テキストが変更されることは間違いありません。
要件が変更されたときにテストを更新する必要がないと判断したので、`greeting`機能から返された値と完全に等しいかどうかを調べる代わりに、出力に入力パラメータのテキストが含まれていると主張します。

`greeting`に`name`を`name`ないように`name`して、このテストの失敗の内容を確認して、この譜面にバグを導入しましょう。

```rust
# fn main() {}
pub fn greeting(name: &str) -> String {
    String::from("Hello!")
}
```

このテストを実行すると、以下が生成されます。

```text
running 1 test
test tests::greeting_contains_name ... FAILED

failures:

---- tests::greeting_contains_name stdout ----
        thread 'tests::greeting_contains_name' panicked at 'assertion failed:
result.contains("Carol")', src/lib.rs:12:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

failures:
    tests::greeting_contains_name
```

この結果は、アサーションが失敗し、アサーションがどの行にあるかを示します。
この場合、より有用な失敗メッセージは、`greeting`機能から得た値を出力します。
テスト機能を変更し、`greeting`機能から得られた実際の値で埋められた場所取りを持つ書式文字列から作成された独自の誤りメッセージを与えましょう。

```rust,ignore
#[test]
fn greeting_contains_name() {
    let result = greeting("Carol");
    assert!(
        result.contains("Carol"),
        "Greeting did not contain name, value was `{}`", result
    );
}
```

テストを実行すると、より有益な誤りメッセージが表示されます。

```text
---- tests::greeting_contains_name stdout ----
        thread 'tests::greeting_contains_name' panicked at 'Greeting did not
contain name, value was `Hello!`', src/lib.rs:12:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

実際にテスト結果に表示された値がわかります。これは、発生すると予想されるものではなく、発生したことを虫取りするのに役立ちます。

### `should_panic`でパニックをチェックする

譜面が期待する正しい値を返すことを確認することに加えて、われわれの譜面が予期したとおりに誤り条件を処理することを確認することも重要です。
たとえば、第9章のリスト9-9で作成した`Guess`型を考えてみましょう。
`Guess`を使用する他の譜面は、`Guess`実例に`Guess`値しか含まれないという保証に依存します。その範囲外の値を持つ`Guess`実例を作成しようとするテストを確実に行うことができます。

これを行うには、テスト機能に`should_panic`別の属性を追加します。
この属性は、機能内の譜面がパニックになった場合にテストに合格します。
機能内の譜面がパニックに陥らなければ、テストは失敗します。

リスト11-8は、期待通りに`Guess::new`誤り状態が発生したことをチェックするテストを示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
pub struct Guess {
    value: u32,
}

impl Guess {
    pub fn new(value: u32) -> Guess {
        if value < 1 || value > 100 {
            panic!("Guess value must be between 1 and 100, got {}.", value);
        }

        Guess {
            value
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

<span class="caption">リスト11-8。条件が<code>panic€</code>を引き起こすかどうかのテスト</span>

置く`#[should_panic]`の後に属性を`#[test]`属性と、それが適用されるテスト機能の前に。
このテストに合格したときの結果を見てみましょう。

```text
running 1 test
test tests::greater_than_100 ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

いいね！　
次に、値が100より大きい場合、`new`機能がパニックになるという条件を削除して、譜面内にバグを導入しましょう。

```rust
# fn main() {}
# pub struct Guess {
#     value: u32,
# }
#
#// --snip--
//  --snip--

impl Guess {
    pub fn new(value: u32) -> Guess {
        if value < 1  {
            panic!("Guess value must be between 1 and 100, got {}.", value);
        }

        Guess {
            value
        }
    }
}
```

リスト11-8のテストを実行すると失敗します。

```text
running 1 test
test tests::greater_than_100 ... FAILED

failures:

failures:
    tests::greater_than_100

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

この場合、非常に役立つメッセージはありませんが、テスト機能を見ると`#[should_panic]`注釈が付いています。
テスト機能の譜面がパニックを引き起こさなかったことを意味します。

`should_panic`を使用するテストは、譜面がいくつかのパニックを引き起こしたことだけを示しているため、不正確になる可能性があります。
たとえ期待していたのとは異なる理由でテストがパニックになっても、`should_panic`テストは合格となります。
作るために`should_panic`テストをより正確に、選択肢を追加することができ`expected`にパラメータを`should_panic`属性。
テストハーネスは、失敗メッセージに指定されたテキストが含まれていることを確認します。
たとえば、リスト11-9の`Guess`の変更された譜面では、値が小さすぎるか大きすぎるかに応じて異なるメッセージで`new`機能がパニックする場合があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
# pub struct Guess {
#     value: u32,
# }
#
#// --snip--
//  --snip--

impl Guess {
    pub fn new(value: u32) -> Guess {
        if value < 1 {
            panic!("Guess value must be greater than or equal to 1, got {}.",
                   value);
        } else if value > 100 {
            panic!("Guess value must be less than or equal to 100, got {}.",
                   value);
        }

        Guess {
            value
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic(expected = "Guess value must be less than or equal to 100")]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

<span class="caption">リスト11-9。条件が特定のパニックメッセージを含む<code>panic€</code>を引き起こすかどうかのテスト</span>

このテストは、`should_panic`属性の`expected`パラメータに入れた値が、`Guess::new`機能がパニックするメッセージの部分文字列であるため、合格します。
この場合、`Guess value must be less than or equal to 100, got 200.`パニックメッセージ全体を指定することができました`should_panic`の期待されるパラメータで指定するものは、どのくらいのパニックメッセージはユニークで動的であり、テストがどれほど正確であるかは正確です。
この場合、パニックメッセージの部分文字列は、テスト機能内の譜面が`else if value > 100`場合に`else if value > 100`実行するのに十分`else if value > 100`。

`expected`メッセージで`should_panic`テストが失敗したときに何が起こるかを見るには、`if value < 1`本体と`else if value > 100`段落の本体を入れ替えて、譜面にバグを導入してみましょう。

```rust,ignore
if value < 1 {
    panic!("Guess value must be less than or equal to 100, got {}.", value);
} else if value > 100 {
    panic!("Guess value must be greater than or equal to 1, got {}.", value);
}
```

今回は`should_panic`テストを実行すると失敗します。

```text
running 1 test
test tests::greater_than_100 ... FAILED

failures:

---- tests::greater_than_100 stdout ----
        thread 'tests::greater_than_100' panicked at 'Guess value must be
greater than or equal to 1, got 200.', src/lib.rs:11:12
note: Run with `RUST_BACKTRACE=1` for a backtrace.
note: Panic did not include expected string 'Guess value must be less than or
equal to 100'

failures:
    tests::greater_than_100

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

失敗メッセージは、このテストが期待通りにパニックになったことを示していますが、パニックメッセージに`'Guess value must be less than or equal to 100'`予想される文字列は含まれていませんでした。
このケースで得たパニックメッセージは、`Guess value must be greater than or equal to 1, got 200.`でした。今、バグがどこにあるかを知ることができます！　

テストを書くためのいくつかの方法を知ったので、テストを実行し、`cargo test`使用できるさまざまな選択肢を調べるときに何が起こっているかを見てみましょう。
