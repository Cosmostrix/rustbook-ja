## 参照と借用

リスト4-5の組<ruby>譜面<rt>コード</rt></ruby>の問題は、返す必要があることである`String`、まだ使用できるように、呼び出し元の機能に`String`呼び出した後`calculate_length`ので、`String`に移された`calculate_length`。

ここでは、値の所有権を取得するのではなく、<ruby>対象<rt>オブジェクト</rt></ruby>への参照をパラメータとして持つ`calculate_length`機能を定義して使用する方法を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

最初に、変数宣言内のすべての組<ruby>譜面<rt>コード</rt></ruby>と機能の戻り値がなくなったことに注目してください。
第二に、合格ことに注意してください`&s1`に`calculate_length`と、その定義では、取る`&String`ではなく`String`。

これらのアンパサンドは*参照*であり、所有権を取らずに値を参照することができます。
図4-5にダイアグラムを示します。

<img src="img/trpl04-05.svg" alt="＆s Stringを指すString s" class="center" />
<span class="caption">図4-5。 <code>String s1</code>指す<code>&amp;String s</code>図</span>

> > 注。使用して、参照の反対`&`逆参照演算子を用いて達成される*間接参照*され、`*`。
> > 第8章では逆参照演算子をいくつか使用し、第15章では逆参照の詳細について説明します。

ここで機能呼び出しを詳しく見てみましょう。

```rust
# fn calculate_length(s: &String) -> usize {
#     s.len()
# }
let s1 = String::from("hello");

let len = calculate_length(&s1);
```

`&s1`構文は、の値を*参照する*参照作成することができます`s1`が、それを所有していませんが。
それが所有していないので、参照先が範囲外になると、その参照元が指している値は削除されません。

同様に、機能の型注釈は`&`を使用して、パラメータ`s`型が参照であることを示します。
説明的な<ruby>注釈<rt>コメント</rt></ruby>を追加しましょう。

```rust
#//fn calculate_length(s: &String) -> usize { // s is a reference to a String
fn calculate_length(s: &String) -> usize { //  sは<ruby>文字列<rt>ストリング</rt></ruby>への参照です
    s.len()
#//} // Here, s goes out of scope. But because it does not have ownership of what
#  // it refers to, nothing happens.
} // ここで、sは範囲外になます。しかし、それが何を指しているの所有権がないため、何も起こりません。
```

変数`s`が有効である<ruby>有効範囲<rt>スコープ</rt></ruby>は、機能パラメータの<ruby>有効範囲<rt>スコープ</rt></ruby>と同じですが、所有権を持たないため<ruby>有効範囲<rt>スコープ</rt></ruby>から外れるときに参照が指すものを削除しません。
機能が実際の値ではなくパラメータとして参照を持つ場合、所有権を持たないため、所有権を返すために値を返す必要はありません。

機能パラメータの*借用*として参照を持つことを呼ぶ。
実際の人生の場合と同様に、人が何かを所有していれば、その人からそれを借りることができます。
終わったら、それを返さなければなりません。

借りているものを変更しようとするとどうなりますか？　
リスト4-6の<ruby>譜面<rt>コード</rt></ruby>を試してみてください。
スポイラー警告。それは動作しません！　

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let s = String::from("hello");

    change(&s);
}

fn change(some_string: &String) {
    some_string.push_str(", world");
}
```

<span class="caption">譜面リスト4-6。借用した値を変更しようとしています</span>

ここに<ruby>誤り<rt>エラー</rt></ruby>があります。

```text
error[E0596]: cannot borrow immutable borrowed content `*some_string` as mutable
 --> error.rs:8:5
  |
7 | fn change(some_string: &String) {
  |                        ------- use `&mut String` here to make mutable
8 |     some_string.push_str(", world");
  |     ^^^^^^^^^^^ cannot borrow as mutable
```

自動的に変数が不変であるのと同じように、参照もそうです。
参照しているものを変更することはできません。

### 変更可能な参照

リスト4-6の<ruby>譜面<rt>コード</rt></ruby>の<ruby>誤り<rt>エラー</rt></ruby>をわずかに微調整して修正できます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

まず、`s`を`mut`に変更する必要がありました。
次に、`&mut s`を使って可変参照を作成し、`some_string: &mut String`を使用して可変参照を受け入れる必要がありました。

ただし、変更可能な参照には大きな制限があります。特定の<ruby>有効範囲<rt>スコープ</rt></ruby>内の特定のデータに対して1つの可変参照のみを持つことができます。
この<ruby>譜面<rt>コード</rt></ruby>は失敗します。

```rust,ignore
let mut s = String::from("hello");

let r1 = &mut s;
let r2 = &mut s;
```

ここに<ruby>誤り<rt>エラー</rt></ruby>があります。

```text
error[E0499]: cannot borrow `s` as mutable more than once at a time
 --> borrow_twice.rs:5:19
  |
4 |     let r1 = &mut s;
  |                   - first mutable borrow occurs here
5 |     let r2 = &mut s;
  |                   ^ second mutable borrow occurs here
6 | }
  | - first borrow ends here
```

この制限は変更を可能にするが、非常に制御された様式であます。
それは、ほとんどの言語が好きなときに変更させるので、新しいRustびた人が苦労しているものです。

この制限を受ける利点は、Rustが<ruby>製譜<rt>コンパイル</rt></ruby>時にデータ競合を防止できることです。
*データレース*はレースコンディションに似ており、次の3つの動作が発生すると発生します。

* 2つ以上の<ruby>指し手<rt>ポインタ</rt></ruby>ーが同じデータに同時にアクセスします。
* 少なくとも1つの<ruby>指し手<rt>ポインタ</rt></ruby>がデータの書き込みに使用されています。
* データへのアクセスを同期させるためのしくみはありません。

データ競合は未定義の動作を引き起こし、実行時にそれらを追跡しようとしているときに診断して修正するのが難しい場合があります。
Rustは、データレースで<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しないので、この問題が起こらないようにします！　

いつものように、複数の可変の参照のためだけに*同時*ではないものを許可する、新しい<ruby>有効範囲<rt>スコープ</rt></ruby>を作成するために、中かっこを使用することができます。

```rust
let mut s = String::from("hello");

{
    let r1 = &mut s;

#//} // r1 goes out of scope here, so we can make a new reference with no problems.
} //  r1はここで範囲外になるので、問題なく新しい参照を作成できます。

let r2 = &mut s;
```

可変と不変の参照を組み合わせるための同様の規則が存在します。
この<ruby>譜面<rt>コード</rt></ruby>は<ruby>誤り<rt>エラー</rt></ruby>になります。

```rust,ignore
let mut s = String::from("hello");

#//let r1 = &s; // no problem
let r1 = &s; // 問題ない
#//let r2 = &s; // no problem
let r2 = &s; // 問題ない
#//let r3 = &mut s; // BIG PROBLEM
let r3 = &mut s; // 大問題
```

ここに<ruby>誤り<rt>エラー</rt></ruby>があります。

```text
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as
immutable
 --> borrow_thrice.rs:6:19
  |
#//4 |     let r1 = &s; // no problem
4 |     let r1 = &s; // 問題ない
  |               - immutable borrow occurs here
#//5 |     let r2 = &s; // no problem
5 |     let r2 = &s; // 問題ない
#//6 |     let r3 = &mut s; // BIG PROBLEM
6 |     let r3 = &mut s; // 大問題
  |                   ^ mutable borrow occurs here
7 | }
  | - immutable borrow ends here
```

すごい！　
不変のものがある間は、変更可能な参照を持つこと*も*できません。
不変参照の利用者は、値が突然下から変更されることを期待しません！　
しかし、複数の不変参照は大丈夫です。ただデータを読み込んでいる誰も他の人のデータの読書に影響を与えることはできないからです。

これらの<ruby>誤り<rt>エラー</rt></ruby>は時には苛立つかもしれませんが、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>は潜在的なバグを早期に（実行時ではなく<ruby>製譜<rt>コンパイル</rt></ruby>時に）指摘し、問題のある場所を正確に示しています。
次に、データが思っていたものではない理由を追跡する必要はありません。

### 行方不明の参照

<ruby>指し手<rt>ポインタ</rt></ruby>を持つ言語では、*行方不明の<ruby>指し手<rt>ポインタ</rt></ruby>*、つまり他の人に与えられた可能性のある記憶内の場所を参照する<ruby>指し手<rt>ポインタ</rt></ruby>を間違って作成することは簡単です。その記憶への<ruby>指し手<rt>ポインタ</rt></ruby>を保持しながら記憶を解放します。
対照的に、Rustでは、<ruby>製譜器<rt>コンパイラー</rt></ruby>は参照がまったく参照を抱かないことを保証します。データへの参照がある場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>はデータへの参照の前にデータが<ruby>有効範囲<rt>スコープ</rt></ruby>外にならないようにします。

Rustが<ruby>製譜<rt>コンパイル</rt></ruby>時の<ruby>誤り<rt>エラー</rt></ruby>で防ぐことのできない、手間のかかる参照を作成しようとしましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String {
    let s = String::from("hello");

    &s
}
```

ここに<ruby>誤り<rt>エラー</rt></ruby>があります。

```text
error[E0106]: missing lifetime specifier
 --> main.rs:5:16
  |
5 | fn dangle() -> &String {
  |                ^ expected lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but there is
  no value for it to be borrowed from
  = help: consider giving it a 'static lifetime
```

この<ruby>誤り<rt>エラー</rt></ruby>メッセージには、まだ説明していない機能、つまり寿命が含まれています。
第10章では寿命について詳しく説明します。しかし、寿命についての部分を無視すると、メッセージにはなぜこの<ruby>譜面<rt>コード</rt></ruby>が問題であるかの鍵が含まれています。

```text
this function's return type contains a borrowed value, but there is no value
for it to be borrowed from.
```

`dangle`<ruby>譜面<rt>コード</rt></ruby>の各段階で何が起きているのかを詳しく見てみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
#//fn dangle() -> &String { // dangle returns a reference to a String
fn dangle() -> &String { //  dangleはStringへの参照を返します

#//    let s = String::from("hello"); // s is a new String
    let s = String::from("hello"); //  sは新しいStringです

#//    &s // we return a reference to the String, s
    &s //  Stringへの参照を返します。
#//} // Here, s goes out of scope, and is dropped. Its memory goes away.
#  // Danger!
} // ここでは、範囲外になり、削除されます。その記憶は消え去ます。危険！　
```

`s`は`dangle`中に作成されるため、`dangle`の<ruby>譜面<rt>コード</rt></ruby>が終了すると、`s`は割り当て解除されます。
しかし、それへの参照を返そうとしました。
これは、この参照が無効な`String`指していることを意味します。
Rustは私たちにこれをさせません。

ここでの解決方法は、`String`直接返すことです。

```rust
fn no_dangle() -> String {
    let s = String::from("hello");

    s
}
```

これは問題なく動作します。
所有権が移動され、割り当てが解除されることはありません。

### 参照ルール

参考文献について議論した内容を要約しましょう。

* 任意の時点で、1つの不定参照*または*不変の参照、任意の数の*いずれかを*持つことができます。
* 参照は常に有効でなければなりません。

次に、異なる種類の参照。スライスを見てみましょう。
