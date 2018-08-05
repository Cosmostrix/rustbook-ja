## `Drop` Traitによる後始末時の<ruby>譜面<rt>コード</rt></ruby>実行

スマート<ruby>指し手<rt>ポインタ</rt></ruby>パターンにとって重要な第2の<ruby>特性<rt>トレイト</rt></ruby>は、`Drop`。これにより、値が範囲外になるときの処理をカスタマイズできます。
任意の型の`Drop`<ruby>特性<rt>トレイト</rt></ruby>の実装を提供できます。指定した<ruby>譜面<rt>コード</rt></ruby>を使用して、ファイルやネットワーク接続などの資源を解放できます。
スマート<ruby>指し手<rt>ポインタ</rt></ruby>を実装するときは、`Drop`<ruby>特性<rt>トレイト</rt></ruby>の機能がほとんど常に使用されるため、スマート<ruby>指し手<rt>ポインタ</rt></ruby>の文脈で`Drop`を導入しています。
たとえば、`Box<T>`は、ボックスが指す原上のスペースを解放するために、`Drop`をカスタマイズします。

他の言語では、スマート<ruby>指し手<rt>ポインタ</rt></ruby>の<ruby>実例<rt>インスタンス</rt></ruby>を使用するたびに記憶または資源を解放する<ruby>譜面<rt>コード</rt></ruby>を<ruby>演譜師<rt>プログラマー</rt></ruby>が呼び出さなければなりません。
彼らが忘れると、システムが多重定義になり<ruby>異常終了<rt>クラッシュ</rt></ruby>する可能性があります。
Rustでは、値が範囲外になるたびに特定のビットの<ruby>譜面<rt>コード</rt></ruby>を実行するように指定することができ、<ruby>製譜器<rt>コンパイラー</rt></ruby>はこの<ruby>譜面<rt>コード</rt></ruby>を自動的に挿入します。
その結果、特定の型の<ruby>実例<rt>インスタンス</rt></ruby>が終了した<ruby>算譜<rt>プログラム</rt></ruby>のどこにでも後始末<ruby>譜面<rt>コード</rt></ruby>を配置することに注意する必要はありません。資源はまだ漏れません。

`Drop`<ruby>特性<rt>トレイト</rt></ruby>を実装して値が範囲外になったときに実行する<ruby>譜面<rt>コード</rt></ruby>を指定します。
`Drop`<ruby>特性<rt>トレイト</rt></ruby>では、`self`への変更可能な参照を取る`drop`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を実装する必要があります。
Rustの呼び出しがいつ`drop`を見るには、`println!`文を使って`drop`を実装しましょう。

`CustomSmartPointer`リスト15-14は、`CustomSmartPointer`構造体を示しています。`CustomSmartPointer`構造体は、<ruby>実例<rt>インスタンス</rt></ruby>が<ruby>有効範囲<rt>スコープ</rt></ruby>外に出たときに`Dropping CustomSmartPointer!`する独自の機能のみを`Dropping CustomSmartPointer!`ています。
この例は、Rustが`drop`機能を実行するときを示しています。

<span class="filename">ファイル名。src/main.rs</span>

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

<span class="caption">リスト15-14。後始末<ruby>譜面<rt>コード</rt></ruby>を置く<code>Drop</code>特性を実装する<code>CustomSmartPointer</code>構造体</span>

`Drop`<ruby>特性<rt>トレイト</rt></ruby>はプレリュードに含まれているので、<ruby>輸入<rt>インポート</rt></ruby>する必要はありません。
`CustomSmartPointer` `Drop`<ruby>特性<rt>トレイト</rt></ruby>を実装し、`println!`を呼び出す`drop`<ruby>操作法<rt>メソッド</rt></ruby>の実装を提供します。
`drop`機能の本体は、型の<ruby>実例<rt>インスタンス</rt></ruby>が範囲外になるときに実行したい<ruby>論理<rt>ロジック</rt></ruby>を配置する場所です。
Rustが呼び出す際に証明するためにここにいくつかのテキストを<ruby>印字<rt>プリント</rt></ruby>している`drop`。

`main`では、`CustomSmartPointer` 2つの<ruby>実例<rt>インスタンス</rt></ruby>を作成し、作成した`CustomSmartPointer`を<ruby>印字<rt>プリント</rt></ruby>します`CustomSmartPointers created.`
。
`main`の最後に、`CustomSmartPointer`<ruby>実例<rt>インスタンス</rt></ruby>が範囲外になり、Rustが`drop`<ruby>操作法<rt>メソッド</rt></ruby>に配置した<ruby>譜面<rt>コード</rt></ruby>を呼び出して、最終メッセージを出力します。
明示的に`drop`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す必要はありませんでした。

この<ruby>算譜<rt>プログラム</rt></ruby>を実行すると、次の出力が表示されます。

```text
CustomSmartPointers created.
Dropping CustomSmartPointer with data `other stuff`!
Dropping CustomSmartPointer with data `my stuff`!
```

指定した<ruby>譜面<rt>コード</rt></ruby>を呼び出して、<ruby>実例<rt>インスタンス</rt></ruby>が<ruby>有効範囲<rt>スコープ</rt></ruby>から外れたときに自動的に`drop`<ruby>操作法<rt>メソッド</rt></ruby>が呼び出されました。
変数は作成の逆の順序で削除されるため、`d`は`c`前に削除されました。
この例では、`drop`<ruby>操作法<rt>メソッド</rt></ruby>の仕組みを視覚的に示します。
通常、<ruby>印字<rt>プリント</rt></ruby>メッセージではなく、実行する必要がある後始末<ruby>譜面<rt>コード</rt></ruby>を指定します。

### 初期値を`std::mem::drop`

残念ながら、自動`drop`機能を無効にするのは簡単ではありません。
通常、`drop`無効に`drop`必要はありません。
`Drop`<ruby>特性<rt>トレイト</rt></ruby>の全ポイントは、それが自動的に世話をすることです。
ただし、値を早期に後始末したいことがあります。
1つの例は、ロックを管理するスマート<ruby>指し手<rt>ポインタ</rt></ruby>を使用する場合です。ロックを解除する`drop`<ruby>操作法<rt>メソッド</rt></ruby>を強制的に実行して、同じ<ruby>有効範囲<rt>スコープ</rt></ruby>内の他の<ruby>譜面<rt>コード</rt></ruby>がロックを取得できるようにしたい場合があります。
Rustは`Drop`<ruby>特性<rt>トレイト</rt></ruby>の`drop`<ruby>操作法<rt>メソッド</rt></ruby>を手動で呼び出させることはできません。
代わりに、<ruby>有効範囲<rt>スコープ</rt></ruby>の終了前に値を強制的に`std::mem::drop`たい場合は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供される`std::mem::drop`機能を呼び出す必要があります。

リスト15-15に示すように、リスト15-14の`main`機能を変更して`Drop`<ruby>特性<rt>トレイト</rt></ruby>の`drop`<ruby>操作法<rt>メソッド</rt></ruby>を手動で呼び出そうとすると、<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let c = CustomSmartPointer { data: String::from("some data") };
    println!("CustomSmartPointer created.");
    c.drop();
    println!("CustomSmartPointer dropped before the end of main.");
}
```

<span class="caption">リスト15-15。 <code>Drop</code>操作法から<code>drop</code>操作法を手動で呼び出して、早期に後始末しようとしています</span>

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、次の<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
error[E0040]: explicit use of destructor method
  --> src/main.rs:14:7
   |
14 |     c.drop();
   |       ^^^^ explicit destructor calls not allowed
```

この<ruby>誤り<rt>エラー</rt></ruby>メッセージは、明示的に`drop`呼び出すことができないことを示しています。
<ruby>誤り<rt>エラー</rt></ruby>メッセージには、*<ruby>破棄子<rt>デストラクター</rt></ruby>*という用語が使用されています。*<ruby>破棄子<rt>デストラクター</rt></ruby>*は、<ruby>実例<rt>インスタンス</rt></ruby>を後始末する機能の一般的な<ruby>演譜<rt>プログラミング</rt></ruby>用語です。
*<ruby>破棄子<rt>デストラクター</rt></ruby>*は、<ruby>実例<rt>インスタンス</rt></ruby>を作成する*<ruby>構築子<rt>コンストラクター</rt></ruby>*に似ています。
Rustの`drop`機能は、特定の<ruby>破棄子<rt>デストラクター</rt></ruby>の1つです。

Rustは、Rustが`main`の最後にある値を自動的に`drop`するため、明示的に`drop`呼び出せません。
これは、Rustが同じ値を2回後始末しようとしているため、*2重のフリー*<ruby>誤り<rt>エラー</rt></ruby>になります。

値が範囲外になったときに`drop`の自動挿入を無効にすることはできません。また、`drop`<ruby>操作法<rt>メソッド</rt></ruby>を明示的に呼び出すことはできません。
したがって、値を早期に強制的に消去する必要がある場合は、`std::mem::drop`機能を使用できます。

`std::mem::drop`機能は、`Drop`<ruby>特性<rt>トレイト</rt></ruby>の`drop`<ruby>操作法<rt>メソッド</rt></ruby>とは異なります。
強制的に強制型変換したい値を早期に引数として渡すことで呼び出します。
この機能はプレリュードにあります。リスト15-16の`main`を変更して、リスト15-16に示すように、`drop`機能を呼び出します。

<span class="filename">ファイル名。src/main.rs</span>

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

<span class="caption">リスト15-16。<ruby>有効範囲<rt>スコープ</rt></ruby>から外れる前に明示的に値を<code>std::mem::drop</code>する<code>std::mem::drop</code>を呼び出す</span>

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、次の内容が<ruby>印字<rt>プリント</rt></ruby>されます。

```text
CustomSmartPointer created.
Dropping CustomSmartPointer with data `some data`!
CustomSmartPointer dropped before the end of main.
```

テキスト ` ``Dropping CustomSmartPointer with data `some data`!``
作成`is printed between the` CustomSmartPointerの`is printed between the`れます。
`and` CustomSmartPointerは、メインの終了前に落としました。
`text, showing that the`<ruby>脱落<rt>ドロップ</rt></ruby>`method code is called to drop`れてその時点でc` `method code is called to drop`示しています。

`Drop`<ruby>特性<rt>トレイト</rt></ruby>実装で指定された<ruby>譜面<rt>コード</rt></ruby>をさまざまな方法で使用すると、後始末を便利かつ安全に行うことができます。たとえば、独自の記憶<ruby>割当譜<rt>アロケーター</rt></ruby>を作成するために使用できます。
`Drop`<ruby>特性<rt>トレイト</rt></ruby>とRustの所有権体系では、Rustが自動的に行うので、後始末するのを忘れる必要はありません。

また、誤って使用中の値を後始末したことによる問題についても心配する必要はありません。参照が常に有効であることを確認する所有権体系によっても、値が使用されなくなったときに`drop`が確実に呼び出されます。

`Box<T>`とスマート<ruby>指し手<rt>ポインタ</rt></ruby>の<ruby>特性<rt>トレイト</rt></ruby>のいくつかを調べたところで、標準<ruby>譜集<rt>ライブラリー</rt></ruby>で定義されている他のスマート<ruby>指し手<rt>ポインタ</rt></ruby>を見てみましょう。
