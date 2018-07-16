## `Drop` Traitによる後始末時の譜面実行

スマート指し手パターンにとって重要な第2の特性は、`Drop`。これにより、値が範囲外になるときの処理をカスタマイズできます。
任意の型の`Drop`特性の実装を提供できます。指定した譜面を使用して、ファイルやネットワーク接続などの資源を解放できます。
スマート指し手を実装するときは、`Drop`特性の機能がほとんど常に使用されるため、スマート指し手の文脈で`Drop`を導入しています。
たとえば、`Box<T>`は、ボックスが指す原上のスペースを解放するために、`Drop`をカスタマイズします。

他の言語では、スマート指し手の実例を使用するたびに記憶または資源を解放する譜面を演譜師が呼び出さなければなりません。
彼らが忘れると、システムが多重定義になり異常終了する可能性があります。
Rustでは、値が範囲外になるたびに特定のビットの譜面を実行するように指定することができ、製譜器はこの譜面を自動的に挿入します。
その結果、特定の型の実例が終了した算譜のどこにでも後始末譜面を配置することに注意する必要はありません。資源はまだ漏れません。

`Drop`特性を実装して値が範囲外になったときに実行する譜面を指定します。
`Drop`特性では、`self`への変更可能な参照を取る`drop`という名前の操作法を実装する必要があります。
Rustの呼び出しがいつ`drop`を見るには、`println!`文を使って`drop`を実装しましょう。

`CustomSmartPointer`リスト15-14は、`CustomSmartPointer`構造体を示しています。`CustomSmartPointer`構造体は、実例が有効範囲外に出たときに`Dropping CustomSmartPointer!`する独自の機能のみを`Dropping CustomSmartPointer!`ています。
この例は、Rustが`drop`機能を実行するときを示しています。

<span class="filename">ファイル名。src / main.rs</span>

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}

fn main() {
    let c = CustomSmartPointer { data: String::from("my stuff") };
    let d = CustomSmartPointer { data: String::from("other stuff") };
    println!("CustomSmartPointers created.");
}
```

<span class="caption">リスト15-14。後始末譜面を置く<code>Drop</code>特性を実装する<code>CustomSmartPointer</code>構造体</span>

`Drop`特性はプレリュードに含まれているので、輸入する必要はありません。
`CustomSmartPointer` `Drop`特性を実装し、`println!`を呼び出す`drop`操作法の実装を提供します。
`drop`機能の本体は、型の実例が範囲外になるときに実行したいロジックを配置する場所です。
Rustが呼び出す際に証明するためにここにいくつかの文言を印字している`drop`。

`main`では、`CustomSmartPointer` 2つの実例を作成し、作成した`CustomSmartPointer`を印字します`CustomSmartPointers created.`
。
`main`の最後に、`CustomSmartPointer`実例が範囲外になり、Rustが`drop`操作法に配置した譜面を呼び出して、最終メッセージを出力します。
明示的に`drop`操作法を呼び出す必要はありませんでした。

この算譜を実行すると、次の出力が表示されます。

```text
CustomSmartPointers created.
Dropping CustomSmartPointer with data `other stuff`!
Dropping CustomSmartPointer with data `my stuff`!
```

指定した譜面を呼び出して、実例が有効範囲から外れたときに自動的に`drop`操作法が呼び出されました。
変数は作成の逆の順序で削除されるため、`d`は`c`前に削除されました。
この例では、`drop`操作法の仕組みを視覚的に示します。
通常、印字メッセージではなく、実行する必要がある後始末譜面を指定します。

### 初期値を`std::mem::drop`

残念ながら、自動`drop`機能を無効にするのは簡単ではありません。
通常、`drop`無効に`drop`必要はありません。
`Drop`特性の全ポイントは、それが自動的に世話をすることです。
ただし、値を早期に後始末したいことがあります。
1つの例は、ロックを管理するスマート指し手を使用する場合です。ロックを解除する`drop`操作法を強制的に実行して、同じ有効範囲内の他の譜面がロックを取得できるようにしたい場合があります。
Rustは`Drop`特性の`drop`操作法を手動で呼び出させることはできません。
代わりに、有効範囲の終了前に値を強制的に`std::mem::drop`たい場合は、標準譜集によって提供される`std::mem::drop`機能を呼び出す必要があります。

リスト15-15に示すように、リスト15-14の`main`機能を変更して`Drop`特性の`drop`操作法を手動で呼び出そうとすると、製譜器誤りが発生します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let c = CustomSmartPointer { data: String::from("some data") };
    println!("CustomSmartPointer created.");
    c.drop();
    println!("CustomSmartPointer dropped before the end of main.");
}
```

<span class="caption">リスト15-15。 <code>Drop</code>操作法から<code>drop</code>操作法を手動で呼び出して、早期に後始末しようとしています</span>

この譜面を製譜しようとすると、次の誤りが表示されます。

```text
error[E0040]: explicit use of destructor method
  --> src/main.rs:14:7
   |
14 |     c.drop();
   |       ^^^^ explicit destructor calls not allowed
```

この誤りメッセージは、明示的に`drop`呼び出すことができないことを示しています。
誤りメッセージには、*破棄子*という用語が使用されています。*破棄子*は、実例を後始末する機能の一般的な演譜用語です。
*破棄子*は、実例を作成する*構築子*に似ています。
Rustの`drop`機能は、特定の破棄子の1つです。

Rustは、Rustが`main`の最後にある値を自動的に`drop`するため、明示的に`drop`呼び出せません。
これは、Rustが同じ値を2回後始末しようとしているため、*2重のフリー*誤りになります。

値が範囲外になったときに`drop`の自動挿入を無効にすることはできません。また、`drop`操作法を明示的に呼び出すことはできません。
したがって、値を早期に強制的に消去する必要がある場合は、`std::mem::drop`機能を使用できます。

`std::mem::drop`機能は、`Drop`特性の`drop`操作法とは異なります。
強制的に強制型変換したい値を早期に引数として渡すことで呼び出します。
この機能はプレリュードにあります。リスト15-16の`main`を変更して、リスト15-16に示すように、`drop`機能を呼び出します。

<span class="filename">ファイル名。src / main.rs</span>

```rust
# struct CustomSmartPointer {
#     data: String,
# }
#
# impl Drop for CustomSmartPointer {
#     fn drop(&mut self) {
#         println!("Dropping CustomSmartPointer!");
#     }
# }
#
fn main() {
    let c = CustomSmartPointer { data: String::from("some data") };
    println!("CustomSmartPointer created.");
    drop(c);
    println!("CustomSmartPointer dropped before the end of main.");
}
```

<span class="caption">リスト15-16。有効範囲から外れる前に明示的に値を<code>std::mem::drop</code>する<code>std::mem::drop</code>を呼び出す</span>

この譜面を実行すると、次の内容が印字されます。

```text
CustomSmartPointer created.
Dropping CustomSmartPointer with data `some data`!
CustomSmartPointer dropped before the end of main.
```

文言 ` ``Dropping CustomSmartPointer with data `some data`!``
作成`is printed between the` CustomSmartPointerの`is printed between the`れます。
`and` CustomSmartPointerは、メインの終了前に落としました。
`text, showing that the`脱落`method code is called to drop`れてその時点でc` `method code is called to drop`示しています。

`Drop`特性実装で指定された譜面をさまざまな方法で使用すると、後始末を便利かつ安全に行うことができます。たとえば、独自の記憶割当譜を作成するために使用できます。
`Drop`特性とRustの所有権体系では、Rustが自動的に行うので、後始末するのを忘れる必要はありません。

また、誤って使用中の値を後始末したことによる問題についても心配する必要はありません。参照が常に有効であることを確認する所有権体系によっても、値が使用されなくなったときに`drop`が確実に呼び出されます。

`Box<T>`とスマート指し手の特性のいくつかを調べたところで、標準譜集で定義されている他のスマート指し手を見てみましょう。
