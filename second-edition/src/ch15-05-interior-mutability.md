## `RefCell<T>`とInterior Mutability Pattern


*インテリアの変更*は、そのデータへの不変な参照があってもデータを変更できるようにする、Rustの設計パターンです。
通常、この措置は借入ルールによって禁止されています。
データを変更するために、パターンはデータ構造内の`unsafe`譜面を使用して、変更と借用を管理するRustの通常の規則を曲げます。
安全でない譜面はまだ扱っていません。
たとえ製譜器がそれを保証できないとしても、実行時に借用規則を確実に守ることができる場合には、内部の可変パターンを使用する型を使用することができます。
`unsafe`譜面は安全なAPIで包まれ、外側の型は変わりません。

内部の変更パターンに続く`RefCell<T>`型を見て、この概念を探ってみましょう。

### `RefCell<T>`を`RefCell<T>`して実行時に借用ルールを強制型変換する

`Rc<T>`とは異なり、`RefCell<T>`型は、保持しているデータに対する単一の所有権を表します。
だから、`RefCell<T>` `Box<T>`ような型と何が違うのでしょうか？　
第4章で学んだ借用規則を思い出してください。

* 任意の時点で、1つの可変参照または任意の数の不変参照を持つことができ*ます*（ただし両方ではありません）。
* 参照は常に有効でなければなりません。

参照と`Box<T>`では、借用ルールの不変式は製譜時に強制型変換されます。
`RefCell<T>`では、これらの不変式は*実行時に*強制型変換さ*れます*。
参考文献を参照して、これらの規則を破ると、製譜器誤りが発生します。
`RefCell<T>`、これらのルールを破ると、算譜がパニックして終了します。

製譜時に借用ルールをチェックする利点は、開発過程で誤りがより早く検出され、すべての分析があらかじめ完了しているため実行時のパフォーマンスに影響がないことです。
こうした理由から、製譜時に借用ルールをチェックするのが大半のケースで最良の選択です。これがRustの自動的にす。

実行時時に借用ルールをチェックする利点は、製譜時のチェックでは許可されないものの、一定の記憶セーフ場合が許可されることです。
Rust製譜器のような静的解析は、本質的に保守的です。
譜面のいくつかの特性は、譜面を分析することで検出することは不可能です。最も有名な例はHalting Problemですが、この本の範囲を超えていますが、研究の興味深い話題です。

分析が不可能なため、Rust製譜器が譜面が所有権ルールに準拠しているかどうかを確かめることができない場合、正しい算譜を拒否することがあります。
このように、それは保守的です。
Rustが間違った算譜を受け入れると、利用者はRustが行う保証を信頼することができなくなります。
しかし、Rustが正しい算譜を拒否した場合、演譜師は不便になるが、致命的なことは起こりません。
`RefCell<T>`型は、譜面が借用ルールに従っていることを確認しているのに製譜器がそれを理解して保証することができない場合に便利です。

`Rc<T>`と同様、`RefCell<T>`は単一走脈の場合でのみ使用でき、多脈処理環境で使用すると製譜時誤りが発生します。
第16章の多脈処理算譜で`RefCell<T>`機能を取得する方法について説明します。

`Box<T>`、 `Rc<T>`、または`RefCell<T>`を選択する理由を要約すると次のようになります。

* `Rc<T>`は同じデータの複数の所有者を可能にします。
   `Box<T>`と`RefCell<T>`は1人の所有者がいます。
* `Box<T>`は、製譜時に不変または変更可能な借用をチェックします。
   `Rc<T>`は、製譜時にチェックされた不変のBorrowsのみを許可します。
   `RefCell<T>`は、実行時に不変または変更可能な借用をチェックできます。
* `RefCell<T>`は実行時に変更可能な借用をチェックできるため、`RefCell<T>`が不変の場合でも`RefCell<T>`内の値を変更することができます。

不変値内の値を変更する*内部可変性パターン*です。
内部の可変性が有用であり、それが可能である方法を調べる状況を見てみましょう。

### 内部の変更。不変の値への変更可能な借用

借用入れルールの結果、不変の価値を持っているときは、それを変更することはできません。
たとえば、この譜面は製譜されません。

```rust,ignore
fn main() {
    let x = 5;
    let y = &mut x;
}
```

この譜面を製譜しようとすると、次の誤りが発生します。

```text
error[E0596]: cannot borrow immutable local variable `x` as mutable
 --> src/main.rs:3:18
  |
2 |     let x = 5;
  |         - consider changing this to `mut x`
3 |     let y = &mut x;
  |                  ^ cannot borrow mutably
```

しかし、値がその操作法でそれ自身を変更させるが、他の譜面には不変であるように見えることが有益である状況があます。
値の操作法以外の譜面では、値を変更することはできません。
`RefCell<T>`を使用することは、内部の変更を可能にする方法の1つです。
しかし`RefCell<T>`は借用ルールを完全に回避しません。製譜器の借用検査器はこの内部の変更を許可し、代わりに実行時に借用ルールがチェックされます。
ルールに違反すると、製譜器誤りではなく`panic!`発生します。

`RefCell<T>`を使用して不変の値を変更し、それがなぜ有用であるかを実例で見てみましょう。

#### インテリア・ミュータビリティのための使用例。モック・対象

*テストダブル*は、*テスト*中に別の型の代わりに使用される型の一般的な演譜概念です。
*モック対象*は、テスト中に何が起こったかを記録する特定の型のテストダブルです。そのため、正しい動作が発生したと主張できます。

Rustには他の言語の対象と同じ意味の対象はなく、Rustは他の言語のように標準譜集にモック対象機能を組み込んでいません。
しかし、モック対象と同じ目的を果たす構造体を作成することは間違いありません。

ここではテストする場合を示します。最大値に対する値を追跡し、現在の値がどれくらい近いかに基づいてメッセージを送信する譜集を作成します。
この譜集は、たとえば、許可されているAPI呼び出しの数に対する利用者のクォータを追跡するために使用できます。

譜集は、最大値にどれくらい近づき、何時にメッセージを表示するのかを追跡する機能しか提供しません。
譜集を使用する譜体は、メッセージを送信するためのしくみを提供することが期待されます。つまり、譜体にメッセージを挿入したり、電子メールを送信したり、テキストメッセージを送信したりすることができます。
譜集はその詳細を知る必要はありません。
必要なのは、`Messenger`と呼ばれる特性を実装するものです。
譜面リスト15-20に譜集譜面を示します。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}

pub struct LimitTracker<'a, T: 'a + Messenger> {
    messenger: &'a T,
    value: usize,
    max: usize,
}

impl<'a, T> LimitTracker<'a, T>
    where T: Messenger {
    pub fn new(messenger: &T, max: usize) -> LimitTracker<T> {
        LimitTracker {
            messenger,
            value: 0,
            max,
        }
    }

    pub fn set_value(&mut self, value: usize) {
        self.value = value;

        let percentage_of_max = self.value as f64/self.max as f64;

        if percentage_of_max >= 0.75 && percentage_of_max < 0.9 {
            self.messenger.send("Warning: You've used up over 75% of your quota!");
        } else if percentage_of_max >= 0.9 && percentage_of_max < 1.0 {
            self.messenger.send("Urgent warning: You've used up over 90% of your quota!");
        } else if percentage_of_max >= 1.0 {
            self.messenger.send("Error: You are over your quota!");
        }
    }
}
```

<span class="caption">リスト15-20。値が最大値にどのくらい近いかを追跡し、値が特定の水準にあるときに警告する譜集</span>

この譜面の重要な部分の1つは、`Messenger`特性に、`self`とメッセージのテキストに対する不変の参照をとる`send`という1つの操作法があることです。
これはモック対象が必要とする接点です。
他の重要な部分は、行動のテストすることです`set_value`の方法`LimitTracker`。
渡した`value`パラメータで変更することはできますが、`set_value`はアサーションを行うために何も返しません。
作成した場合と言うことができるようにしたい`LimitTracker`実装して何かを`Messenger`特性とのための特定の値`max`異なる番号を渡すとき、`value`、メッセンジャーは、適切なメッセージを送信するように言われています。

`send`を呼び出すときに電子メールまたはテキストメッセージを送信する代わりに、送信するように指示されたメッセージのみを追跡するモック対象が必要です。
作成、モック対象の新しい実例を作成することができます`LimitTracker`、モック対象を使用して呼び出す`set_value`に方法を`LimitTracker`、その後、モック対象は、期待するメッセージを持っていることを確認してください。
リスト15-21は、それを行うための模擬対象を実装する試みを示していますが、借用検査器は許可しません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    use super::*;

    struct MockMessenger {
        sent_messages: Vec<String>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger { sent_messages: vec![] }
        }
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.push(String::from(message));
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        let mock_messenger = MockMessenger::new();
        let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);

        limit_tracker.set_value(80);

        assert_eq!(mock_messenger.sent_messages.len(), 1);
    }
}
```

<span class="caption">リスト15-21。 <code>MockMessenger</code>検査器で許可されていない<code>MockMessenger</code>を実装しようとする試み</span>

このテスト譜面は、送信するように指示されたメッセージを追跡するために、`Vec`の`String`値を持つ`sent_messages`欄を持つ`MockMessenger`構造体を定義します。
空のメッセージリストから始まる新しい`MockMessenger`値を作成するのに便利`new`ように、関連する機能`new`を定義します。
その後、実装`Messenger`のための特性を`MockMessenger`与えることができるよう`MockMessenger`する`LimitTracker`。
`send`操作法の定義では、渡されたメッセージをパラメータとして`MockMessenger`、 `MockMessenger`リストに`sent_messages`ます。

テストでは、`LimitTracker`が`max`値の75％を超える`value`を設定するように指示されたときに何が起こるかをテストしています。
まず、新しい`MockMessenger`を作成します`MockMessenger`は空のメッセージリストから始まります。
その後、新しい作成`LimitTracker`し、それを新しい参照与える`MockMessenger`と`max`呼ん100の値`set_value`の方法`LimitTracker`その後、主張100の75％以上である80の値とを、`MockMessenger`が追跡しているメッセージのリストに、メッセージが1つあるはずです。

ただし、ここに示すように、このテストには1つの問題があります。

```text
error[E0596]: cannot borrow immutable field `self.sent_messages` as mutable
  --> src/lib.rs:52:13
   |
51 |         fn send(&self, message: &str) {
   |                 ----- use `&mut self` here to make mutable
52 |             self.sent_messages.push(String::from(message));
   |             ^^^^^^^^^^^^^^^^^^ cannot mutably borrow immutable field
```

`send`操作法は`self`への不変の参照を取るので、メッセージを追跡するために`MockMessenger`を変更することはできません。
また、`send`の型指示が`Messenger` trait定義の型指示と一致しないため、誤りテキストから`&mut self`代わりに使用する`send`はできません（どのような誤りメッセージが表示されるか気軽に試してみてください）。

これは、内部の変更が助けになる状況です！　
保存します`sent_messages`内`RefCell<T>`その後、`send`メッセージは、変更することができるようになります`sent_messages`見てきたメッセージを格納します。
リスト15-22は、それがどのように見えるかを示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::RefCell;

    struct MockMessenger {
        sent_messages: RefCell<Vec<String>>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger { sent_messages: RefCell::new(vec![]) }
        }
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.borrow_mut().push(String::from(message));
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
#        // --snip--
        //  --snip--
#         let mock_messenger = MockMessenger::new();
#         let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);
#         limit_tracker.set_value(75);

        assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
    }
}
```

<span class="caption">リスト15-22。 <code>RefCell&lt;T&gt;</code>を使って内部値を変更し、外側の値が不変であると見なす</span>

`sent_messages`欄は、`Vec<String>`ではなく`RefCell<Vec<String>>`型に`RefCell<Vec<String>>`。
`new`機能では、空のベクトルの周りに新しい`RefCell<Vec<String>>`実例を作成します。

`send`操作法の実装では、最初のパラメータはまだ`self`不変の借用であり、これは特性定義に一致します。
呼んで`borrow_mut`に`RefCell<Vec<String>>`に`self.sent_messages`内の値を変更可能な参照を取得するために`RefCell<Vec<String>>`ベクトルです。
次に、テスト中に送信されたメッセージを追跡するために、ベクトルへの変更可能な参照を`push`を呼び出すことができます。

行う必要があり、最後の変更が主張している。呼んで、内側のベクトルであるどのように多くの項目を参照するために`borrow`に`RefCell<Vec<String>>`ベクトルへの不変の参照を取得します。

`RefCell<T>`使い方を見てきたので、どのように動作するかを見てみましょう。

#### `RefCell<T>`を`RefCell<T>`して実行時に借用を追跡する

不変で変更可能な参照を作成するときは、それぞれ`&`と`&mut`構文を使用します。
`RefCell<T>`使用`borrow`と`borrow_mut`に属する安全なAPIの一部である方法、`RefCell<T>`。
`borrow`方法は、スマート指し手型返し`Ref<T>`、そして`borrow_mut`スマート指し手型返し`RefMut<T>`。
どちらの型も`Deref`実装しているので、正規表現のように扱うことができます。

`RefCell<T>`は、現在アクティブな`Ref<T>`と`RefMut<T>`スマート指し手の数を`RefMut<T>`します。
`RefCell<T>`は、`borrow`を呼び出すたびに、不変の借用がいくつあるかをカウントします。
`Ref<T>`値が範囲外になると、不変の借用の数が1つ減ります。
`RefCell<T>`は、製譜時の借用規則と同じように、いつでも不変の借用または可変の借用が可能です。

これらのルールに違反しようとすると、参照と同じように製譜器誤りが発生するのではなく、実行時に`RefCell<T>`実装がパニックに陥ります。
リスト15-23は、リスト15-22の`send`の実装の変更を示しています。
`RefCell<T>`が実行時にこれを`RefCell<T>`ないようにするために、同じ有効範囲に対してアクティブな2つの可変の借用を意図的に作成しようとしています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Messenger for MockMessenger {
    fn send(&self, message: &str) {
        let mut one_borrow = self.sent_messages.borrow_mut();
        let mut two_borrow = self.sent_messages.borrow_mut();

        one_borrow.push(String::from(message));
        two_borrow.push(String::from(message));
    }
}
```

<span class="caption">リスト15-23。 <code>RefCell&lt;T&gt;</code>がパニックすることを<code>RefCell&lt;T&gt;</code>ために同じ有効範囲内に2つの可変参照を作成する</span>

変数を作成`one_borrow`ため`RefMut<T>`から返されたスマート指し手`borrow_mut`。
次に変数`two_borrow`同様の方法で別の可変ボローを作成します。
これにより、2つの可変参照が同じ有効範囲内に作成されますが、これは許可されません。
譜集のテストを実行すると、リスト15-23の譜面は誤りなく製譜されますが、テストは失敗します。

```text
---- tests::it_sends_an_over_75_percent_warning_message stdout ----
	thread 'tests::it_sends_an_over_75_percent_warning_message' panicked at
'already borrowed: BorrowMutError', src/libcore/result.rs:906:4
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

`already borrowed: BorrowMutError`ているメッセージで慌てた譜面`already borrowed: BorrowMutError`。
これは`RefCell<T>`が実行時に借用ルールの違反を処理する方法`RefCell<T>`。

製譜時ではなく実行時に借用誤りを捕捉することは、開発過程の後半で譜面に間違いがあり、譜面が本番環境に配備されるまで間違いを見つけることを意味します。
また、製譜時ではなく実行時に借用を追跡した結果、実行時のパフォーマンスが低下する可能性があります。
しかし、`RefCell<T>`を使うと、変更可能なモック対象を書くことが可能になります。モック対象は、変更可能な値だけが許されている文脈で使用している間に見たメッセージを追跡することができます。
`RefCell<T>`使用することで、通常の参照よりも多くの機能を得ることができます。

### `Rc<T>`と`RefCell<T>`組み合わせて変更可能なデータの複数の所有者を持つ

`RefCell<T>`を使用する一般的な方法は`Rc<T>`と組み合わせて使用​​されます。
`Rc<T>`はそれ用のデータの複数の所有者を持つことができますが、そのデータへの不変のアクセスしか与えないことを思い出してください。
`RefCell<T>` `Rc<T>`を保持する`Rc<T>`を持っている場合は、複数の所有者*を*持つことができる値を得ることができます。

たとえば、リスト15-18のconsリストの例を思い出してください。ここでは、複数のリストが別のリストの所有権を共有できるように`Rc<T>`を使用しました。
`Rc<T>`は不変の値しか保持しないため、作成した後はリストの値を変更することはできません。
`RefCell<T>`を追加して、リスト内の値を変更できるようにしましょう。
リスト15-24は、`Cons`定義で`RefCell<T>`を使用することによって、すべてのリストに格納されている値を変更できることを示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
#[derive(Debug)]
enum List {
    Cons(Rc<RefCell<i32>>, Rc<List>),
    Nil,
}

use List::{Cons, Nil};
use std::rc::Rc;
use std::cell::RefCell;

fn main() {
    let value = Rc::new(RefCell::new(5));

    let a = Rc::new(Cons(Rc::clone(&value), Rc::new(Nil)));

    let b = Cons(Rc::new(RefCell::new(6)), Rc::clone(&a));
    let c = Cons(Rc::new(RefCell::new(10)), Rc::clone(&a));

    *value.borrow_mut() += 10;

    println!("a after = {:?}", a);
    println!("b after = {:?}", b);
    println!("c after = {:?}", c);
}
```

<span class="caption">リスト15-24。 <code>Rc&lt;RefCell&lt;i32&gt;&gt;</code>を使用して、変更可能な<code>List</code>を作成する</span>

`Rc<RefCell<i32>>`実例である値を作成し、それを後で直接アクセスできるように`value`という名前の変数に格納します。
その後、作成する`List`中での`a` `Cons`を保持場合値`value`。
クローンを作成する必要がある`value`両方ので`a`と`value`、内側の所有権が持っている`5`むしろから所有権を転送するよりも、値を`value`にか持つからボロー`a` `a` `value`。

リストラップ`a`で`Rc<T>`リスト作成時にその`b`および`c`、それらは両方を参照することができ、リスト15-18で何をしたかです。 `a`

`a`、 `b`、 `c`にリストを作成した後、valueの値に10を追加し`value`。
呼び出すことによってこれを行う`borrow_mut`に`value`（「だ章を参照第5章で説明した自動逆参照機能を使用して、 `->`逆参照に？　演算子」）`Rc<T>`の内側に`RefCell<T>`値。
`borrow_mut`操作法は`RefMut<T>`スマート指し手を返し、それに対して逆参照演算子を使用して内部値を変更します。

`a`、 `b`、 `c`を印字`a`、5つではなく15の値が変更されていることがわかります。

```text
a after = Cons(RefCell { value: 15 }, Nil)
b after = Cons(RefCell { value: 6 }, Cons(RefCell { value: 15 }, Nil))
c after = Cons(RefCell { value: 10 }, Cons(RefCell { value: 15 }, Nil))
```

この技法はかなりきれいです！　
`RefCell<T>`を使用することで、外部的に不変な`List`値が得られます。
しかし`RefCell<T>`操作法を使用すると、内部の変更が可能になり、必要なときにデータを変更できます。
実行時の借用ルールのチェックにより、データ競合から私たちを守ることができます。データ構造の柔軟性のために、時には速度を少し上げる価値があります。

標準譜集のような内部可変性を提供する他の型有する`Cell<T>`の代わりに内部値への参照を与えることを除いて同様である、値がの内外にコピーされる`Cell<T>`。
また、`Mutex<T>`もあります。これは走脈間で安全に使用できる内部の変更を提供します。
第16章でその使い方について説明します。これらの型の違いの詳細については、標準譜集の開発資料を参照してください。
