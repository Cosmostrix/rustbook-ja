## 安全でないRust

これまで説明したすべての<ruby>譜面<rt>コード</rt></ruby>では、<ruby>製譜<rt>コンパイル</rt></ruby>時にRustの記憶安全性が保証されています。
しかし、Rustは内部に隠された第2言語を持っています。これは、*安全でないRust*と呼ばれ、通常のRustのように動作しますが、余分な超電力を与えます。

事実、静的分析は保守的であるため、安全でないRustが存在します。
<ruby>製譜器<rt>コンパイラー</rt></ruby>が<ruby>譜面<rt>コード</rt></ruby>が保証を維持するかどうかを判断しようとすると、いくつかの無効な<ruby>算譜<rt>プログラム</rt></ruby>を受け入れるのではなく、有効な<ruby>算譜<rt>プログラム</rt></ruby>を拒否する方が良いでしょう。
<ruby>譜面<rt>コード</rt></ruby>は大丈夫かもしれませんが、Rustが言うことができる限り、そうではありません！　
このような場合、安全でない<ruby>譜面<rt>コード</rt></ruby>を使用して、<ruby>製譜器<rt>コンパイラー</rt></ruby>に「信頼してください、私がやっていることを知っています。」ということを伝えることができます。危険な<ruby>譜面<rt>コード</rt></ruby>を使用することは危険です。安全でない<ruby>譜面<rt>コード</rt></ruby>を誤って使用すると、ヌル・<ruby>指し手<rt>ポインタ</rt></ruby>ー逆参照などの安全でないものが発生する可能性があります。

Rustが危険な自我を持っているもう一つの理由は、基本的な<ruby>計算機<rt>コンピューター</rt></ruby>のハードウェアが本質的に危険であるということです。
Rustが安全でない操作をさせなかった場合、特定の作業を行うことができませんでした。
Rustは、<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>と直接対話する、または独自の<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>を作成するなど、低水準のシステム<ruby>演譜<rt>プログラミング</rt></ruby>を可能にする必要があります。
低水準のシステム<ruby>演譜<rt>プログラミング</rt></ruby>を使用することは、言語の目標の1つです。
安全でないRustに何ができるのか、それをどうするかを探そう。

### 安全でない超大国

安全でないRustに切り替えるには、`unsafe`予約語を使用し、`unsafe`ない<ruby>譜面<rt>コード</rt></ruby>を保持する新しい<ruby>段落<rt>ブロック</rt></ruby>を開始します。
安全では*ないスーパーパワー*と呼ばれる*安全*でないルストでは、4つの動作を取ることができます。
これらの超大国には以下の能力が含まれます。

* 未処理の<ruby>指し手<rt>ポインタ</rt></ruby>を参照解除する
* 安全でない機能または<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す
* 可変静的変数へのアクセスまたは変更
* 安全でない<ruby>特性<rt>トレイト</rt></ruby>を実装する

`unsafe`ないと借用検査器を無効にしたり、Rustの安全チェックを無効にしたりすることはないことを理解することが重要です。`unsafe`でない<ruby>譜面<rt>コード</rt></ruby>で参照を使用してもチェックされます。
`unsafe`予約語は、記憶安全性のために<ruby>製譜器<rt>コンパイラー</rt></ruby>によってチェックされない4つの機能にのみアクセスできます。
まだ安全でない<ruby>段落<rt>ブロック</rt></ruby>の中である程度の安全を得るでしょう。

さらに、`unsafe`ないということは、<ruby>段落<rt>ブロック</rt></ruby>内の<ruby>譜面<rt>コード</rt></ruby>が必然的に危険であるということ、または<ruby>記憶域<rt>メモリー</rt></ruby>の安全上の問題があることを意味するわけではありません。<ruby>演譜師<rt>プログラマー</rt></ruby>として、`unsafe`<ruby>段落<rt>ブロック</rt></ruby>内の<ruby>譜面<rt>コード</rt></ruby>が、。

人々は間違いがあり、間違いが起こりますが、これらの4つの安全でない操作に安全で`unsafe`ことが<ruby>注釈<rt>コメント</rt></ruby>された<ruby>段落<rt>ブロック</rt></ruby>の内側にあることを要求することにより、<ruby>記憶域<rt>メモリー</rt></ruby>の安全性に関する<ruby>誤り<rt>エラー</rt></ruby>は`unsafe`<ruby>段落<rt>ブロック</rt></ruby>内になければなりません。
`unsafe`<ruby>段落<rt>ブロック</rt></ruby>は小さくしてください。
後で記憶バグを調べると感謝しています。

安全でない<ruby>譜面<rt>コード</rt></ruby>を可能な限り分離するには、安全でない<ruby>譜面<rt>コード</rt></ruby>を安全な抽象的に囲み、安全なAPIを提供することが最善です。これについては、安全でない機能や<ruby>操作法<rt>メソッド</rt></ruby>を調べるときの章で後述します。
標準<ruby>譜集<rt>ライブラリー</rt></ruby>の一部は、監査された安全でない<ruby>譜面<rt>コード</rt></ruby>に対して安全な抽象として実装されています。
危険な<ruby>譜面<rt>コード</rt></ruby>を安全な抽象的に包むことで、安全な抽象を使用することは`unsafe`であるため、安全で`unsafe`<ruby>譜面<rt>コード</rt></ruby>を実装する機能を使用したいと思うすべての場所に`unsafe`で`unsafe`ものが漏れるのを防ぎます。

安全でない4つの超大国のそれぞれを順番に見てみましょう。
また、安全でない<ruby>譜面<rt>コード</rt></ruby>との安全な<ruby>接点<rt>インターフェース</rt></ruby>を提供する抽象概念についても見ていきます。

### 未処理の<ruby>指し手<rt>ポインタ</rt></ruby>を参照解除する

第4章の「Dangling References」章では、<ruby>製譜器<rt>コンパイラー</rt></ruby>が参照が常に有効であることを保証していると述べました。
Unsafe Rustには、参照に似ている*生<ruby>指し手<rt>ポインタ</rt></ruby>*という2つの新しい型があります。
参照の場合と同様に、生<ruby>指し手<rt>ポインタ</rt></ruby>は不変または変更可能であり、それぞれ`*const T`および`*mut T`として記述されます。
アスタリスクは逆参照演算子ではありません。
それは型名の一部です。
生<ruby>指し手<rt>ポインタ</rt></ruby>の文脈では、*immutable*は、逆参照された後に<ruby>指し手<rt>ポインタ</rt></ruby>を直接割り当てることができないことを意味します。

参照とスマート<ruby>指し手<rt>ポインタ</rt></ruby>とは異なり、生<ruby>指し手<rt>ポインタ</rt></ruby>。

* 不変および変更可能な<ruby>指し手<rt>ポインタ</rt></ruby>または同じ場所への複数の変更可能な<ruby>指し手<rt>ポインタ</rt></ruby>の両方を持つことによって、借用ルールを無視することができます
* 有効な記憶を指すことが保証されていない
* nullにできる
* 自動後始末を実装しないでください

Rustにこれらの保証を適用することを拒否することにより、より高いパフォーマンスとRustの保証が適用されない別の言語またはハードウェアとの<ruby>接点<rt>インターフェース</rt></ruby>機能と引き換えに保証された安全性を放棄することができます。

リスト19-1は、参照から不変および変更可能な生<ruby>指し手<rt>ポインタ</rt></ruby>を作成する方法を示しています。

```rust
let mut num = 5;

let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;
```

<span class="caption">リスト19-1。参照からの生<ruby>指し手<rt>ポインタ</rt></ruby>の作成</span>

この<ruby>譜面<rt>コード</rt></ruby>に`unsafe`予約語は含まれていないことに注意してください。
安全な<ruby>譜面<rt>コード</rt></ruby>で生<ruby>指し手<rt>ポインタ</rt></ruby>を作成することができます。
安全でない<ruby>段落<rt>ブロック</rt></ruby>の外に生の<ruby>指し手<rt>ポインタ</rt></ruby>を逆参照することはできません。

`as`を使っ`as`不変の参照と変更可能な参照を対応する未処理の<ruby>指し手<rt>ポインタ</rt></ruby>型にキャストすることで、未加工の<ruby>指し手<rt>ポインタ</rt></ruby>を作成しました。
有効であることが保証されている参照から直接作成したため、これらの特定のロー<ruby>指し手<rt>ポインタ</rt></ruby>が有効であることがわかりましたが、ロー<ruby>指し手<rt>ポインタ</rt></ruby>についてはその仮定をすることはできません。

次に、有効性がそれほど高くない生の<ruby>指し手<rt>ポインタ</rt></ruby>を作成します。
リスト19-2は、記憶内の任意の場所への生<ruby>指し手<rt>ポインタ</rt></ruby>を作成する方法を示しています。
任意の記憶を使用しようとすると、その番地にデータが存在する可能性があります。そうしないと、<ruby>製譜器<rt>コンパイラー</rt></ruby>は<ruby>譜面<rt>コード</rt></ruby>を最適化して記憶アクセスがないか、セグメンテーションフォルトで<ruby>誤り<rt>エラー</rt></ruby>が発生する可能性があります。
通常、このような<ruby>譜面<rt>コード</rt></ruby>を記述する正当な理由はありませんが、可能です。

```rust
let address = 0x012345usize;
let r = address as *const i32;
```

<span class="caption">リスト19-2。任意の記憶番地への生<ruby>指し手<rt>ポインタ</rt></ruby>の作成</span>

安全な<ruby>譜面<rt>コード</rt></ruby>で生<ruby>指し手<rt>ポインタ</rt></ruby>を作成できることを思い出してください。しかし、生<ruby>指し手<rt>ポインタ</rt></ruby>を*逆参照*したり、指し示されているデータを読み込んだりすることはできません。
リスト19-3では、`unsafe`<ruby>段落<rt>ブロック</rt></ruby>を必要とする生<ruby>指し手<rt>ポインタ</rt></ruby>に対して逆参照演算子`*`を使用しています。

```rust
let mut num = 5;

let r1 = &num as *const i32;
let r2 = &mut num as *mut i32;

unsafe {
    println!("r1 is: {}", *r1);
    println!("r2 is: {}", *r2);
}
```

<span class="caption">リスト19-3。 <code>unsafe</code>段落内で生<ruby>指し手<rt>ポインタ</rt></ruby>を参照解除する</span>

<ruby>指し手<rt>ポインタ</rt></ruby>を作成することは問題ありません。
無効な値を扱うことになるかもしれないと指摘している値にアクセスしようとするときだけです。

リスト19-1と19-3では、`num`が格納されている同じ記憶位置を指していた`*const i32`と`*mut i32`生<ruby>指し手<rt>ポインタ</rt></ruby>を作成したことにも注意してください。
代わりに、不変で変更可能な`num`への参照を作成しようとした場合、Rustの所有権規則は不変参照と同時に変更可能な参照を許可しないため、<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。
生の<ruby>指し手<rt>ポインタ</rt></ruby>では、可変<ruby>指し手<rt>ポインタ</rt></ruby>と不変の<ruby>指し手<rt>ポインタ</rt></ruby>を同じ場所に作成し、可変<ruby>指し手<rt>ポインタ</rt></ruby>を介してデータを変更することができ、データ競合が発生する可能性があります。
注意してください！　

これらの危険性のすべてを理由に、なぜ生<ruby>指し手<rt>ポインタ</rt></ruby>を使用するのでしょうか？　
次の章「安全ではない機能または<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す」のように、C<ruby>譜面<rt>コード</rt></ruby>と<ruby>接点<rt>インターフェース</rt></ruby>するときの主な使用例があります。もう1つのケースは、借用検査器が理解できない安全な抽象を構築する場合です。
安全でない機能を導入し、安全でない<ruby>譜面<rt>コード</rt></ruby>を使用する安全な抽象の例を見ていきます。

### 安全でない機能または<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す

安全でない<ruby>段落<rt>ブロック</rt></ruby>を必要とする第2の型の操作は、安全でない機能を呼び出すことです。
安全ではない機能や<ruby>操作法<rt>メソッド</rt></ruby>は、通常の機能や<ruby>操作法<rt>メソッド</rt></ruby>とまったく同じように見えますが、残りの定義よりも`unsafe`なります。
この文脈の`unsafe`予約語は、機能がこの機能を呼び出すときに必要とする要件があることを示しています。なぜなら、Rustはこれらの要件を満たしているとは保証できないからです。
`unsafe`<ruby>段落<rt>ブロック</rt></ruby>内で`unsafe`ない機能を呼び出すことによって、この機能の開発資料を読み、その機能の契約を守る責任があると言います。

ここに`dangerous`名前の`dangerous`な機能があります。危険な機能は本体内に何もしません。

```rust
unsafe fn dangerous() {}

unsafe {
    dangerous();
}
```

`unsafe`別の<ruby>段落<rt>ブロック</rt></ruby>内で`dangerous`機能を呼び出す必要があります。
`unsafe`<ruby>段落<rt>ブロック</rt></ruby>なしで`dangerous`を呼び出そうとすると、<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0133]: call to unsafe function requires unsafe function or block
 -->
  |
4 |     dangerous();
  |     ^^^^^^^^^^^ call to unsafe function
```

`unsafe`<ruby>段落<rt>ブロック</rt></ruby>を`dangerous`呼び出しの周りに挿入することで、機能の開発資料を読んだこと、正しく使用する方法を理解していること、そして機能の規約を満たしていることが確認されました。

危険な機能の本体が効果的です`unsafe`<ruby>段落<rt>ブロック</rt></ruby>、とても危険な機能内で他の危険な操作を実行するために、別の追加する必要はありません`unsafe`<ruby>段落<rt>ブロック</rt></ruby>を。

#### 安全でない<ruby>譜面<rt>コード</rt></ruby>に対する安全な抽象化の作成

機能が安全でない<ruby>譜面<rt>コード</rt></ruby>を含んでいるからといって、機能全体を危険なものとしてマークする必要はありません。
実際、安全でない<ruby>譜面<rt>コード</rt></ruby>を安全な機能に包むことは一般的な抽象化です。
一例として、標準<ruby>譜集<rt>ライブラリー</rt></ruby>`split_at_mut`から安全でない<ruby>譜面<rt>コード</rt></ruby>が必要な機能を調べて、実装する方法を調べてみましょう。
この安全な<ruby>操作法<rt>メソッド</rt></ruby>は可変スライスで定義されています。スライスを1つ取り、引数として与えられた<ruby>添字<rt>インデックス</rt></ruby>でスライスを分割して2つにします。
リスト19-4は、`split_at_mut`使い方を示しています。

```rust
let mut v = vec![1, 2, 3, 4, 5, 6];

let r = &mut v[..];

let (a, b) = r.split_at_mut(3);

assert_eq!(a, &mut [1, 2, 3]);
assert_eq!(b, &mut [4, 5, 6]);
```

<span class="caption">リスト19-4。safe <code>split_at_mut</code>機能の使用</span>

安全なRustだけを使用してこの機能を実装することはできません。
リスト19-5のようなものがありますが、これは<ruby>製譜<rt>コンパイル</rt></ruby>されません。
`split_at_mut`ために、`split_at_mut`を<ruby>操作法<rt>メソッド</rt></ruby>ではなく機能として実装し、総称型`T`ではなく`i32`値のスライスに対してのみ実装します。

```rust,ignore
fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();

    assert!(mid <= len);

    (&mut slice[..mid],
     &mut slice[mid..])
}
```

<span class="caption">リスト19-5。 <code>split_at_mut</code>だけを使って<code>split_at_mut</code>を実装しようとした</span>

この機能は、最初にスライスの全長を取得します。
次に、パラメータとして指定された<ruby>添字<rt>インデックス</rt></ruby>が長さ以下であるかどうかをチェックすることによってスライス内にあることを示します。
アサーションとは、スライスを分割する<ruby>添字<rt>インデックス</rt></ruby>よりも大きい<ruby>添字<rt>インデックス</rt></ruby>を渡すと、その<ruby>添字<rt>インデックス</rt></ruby>を使用しようとする前に機能がパニックすることを意味します。

次に、元のスライスの始めから`mid`<ruby>添字<rt>インデックス</rt></ruby>まで、スライスの`mid`から終わりまでの2つの可変スライスを組に返します。

リスト19-5の<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0499]: cannot borrow `*slice` as mutable more than once at a time
 -->
  |
6 |     (&mut slice[..mid],
  |           ----- first mutable borrow occurs here
7 |      &mut slice[mid..])
  |           ^^^^^ second mutable borrow occurs here
8 | }
  | - first borrow ends here
```

Rustの借用検査器は、スライスのさまざまな部分を借りていることを理解できません。
同じスライスから2回借りていることを知っているだけです。
2つのスライスが重なっていないので、スライスの異なる部分を借用するのは基本的に問題ありませんが、Rustはこれを知るには十分スマートではありません。
<ruby>譜面<rt>コード</rt></ruby>は大丈夫だが、Rustはそうでないことが分かっているときは、安全でない<ruby>譜面<rt>コード</rt></ruby>に手を差し伸べるべき時です。

リスト19-6は、`unsafe`<ruby>段落<rt>ブロック</rt></ruby>、生<ruby>指し手<rt>ポインタ</rt></ruby>、および安全ではない機能への呼び出しを使用して`split_at_mut`の実装を`split_at_mut`させる方法を`split_at_mut`います。

```rust
use std::slice;

fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();
    let ptr = slice.as_mut_ptr();

    assert!(mid <= len);

    unsafe {
        (slice::from_raw_parts_mut(ptr, mid),
         slice::from_raw_parts_mut(ptr.offset(mid as isize), len - mid))
    }
}
```

<span class="caption">譜面リスト19-6。 <code>split_at_mut</code>機能の実装で安全でない<ruby>譜面<rt>コード</rt></ruby>を使用する</span>

第4章の「スライス型」の章から、スライスはそれ用のデータへの<ruby>指し手<rt>ポインタ</rt></ruby>とスライスの長さを思い出してください。
`len`<ruby>操作法<rt>メソッド</rt></ruby>を使用してスライスの長さを取得し、`as_mut_ptr`<ruby>操作法<rt>メソッド</rt></ruby>を使用してスライスの生<ruby>指し手<rt>ポインタ</rt></ruby>にアクセスします。
この場合、`i32`値に対する可変スライスを持っているので、`as_mut_ptr`は変数`ptr`格納した`*mut i32`型の生<ruby>指し手<rt>ポインタ</rt></ruby>を返します。

`mid`<ruby>添字<rt>インデックス</rt></ruby>がスライス内にあるという主張を維持します。
次に安全でない<ruby>譜面<rt>コード</rt></ruby>に到達します。 `slice::from_raw_parts_mut`機能は生<ruby>指し手<rt>ポインタ</rt></ruby>と長さを取り、スライスを作成します。
この機能を使用して、`ptr`から始まり、長い`mid`項目のスライスを作成します。
その後、呼んで`offset`の方法`ptr`して`mid`から始まる生の<ruby>指し手<rt>ポインタ</rt></ruby>を取得するには、引数として`mid`、その<ruby>指し手<rt>ポインタ</rt></ruby>を使用してスライスし、後の項目の残り数作成`mid`の長さなどを。

`slice::from_raw_parts_mut`機能は、生<ruby>指し手<rt>ポインタ</rt></ruby>を取り、この<ruby>指し手<rt>ポインタ</rt></ruby>が有効であると信頼する必要があるため、安全ではありません。
未処理の<ruby>指し手<rt>ポインタ</rt></ruby>に対する`offset`<ruby>操作法<rt>メソッド</rt></ruby>も安全ではありません。なぜなら、オフセット位置も有効な<ruby>指し手<rt>ポインタ</rt></ruby>であると信頼する必要があるからです。
したがって、`slice::from_raw_parts_mut`と`offset`呼び出しのあちこちに`unsafe`<ruby>段落<rt>ブロック</rt></ruby>を置く`slice::from_raw_parts_mut`ありました。
<ruby>譜面<rt>コード</rt></ruby>を見て、`mid`が`len`以下でなければならないというアサーションを追加することで、`unsafe`<ruby>段落<rt>ブロック</rt></ruby>内で使用されるすべての生<ruby>指し手<rt>ポインタ</rt></ruby>がスライス内のデータへの有効な<ruby>指し手<rt>ポインタ</rt></ruby>になることがわかります。
これは、`unsafe`では`unsafe`許容され、適切に使用されます。

結果として生じる`split_at_mut`機能を`unsafe`ものとしてマークする必要はなく、この機能を安全なRustから呼び出すことができます。
使用する機能の実装に危険な<ruby>譜面<rt>コード</rt></ruby>への安全な抽象化を作成した`unsafe`ことは、この機能がアクセスできるデータから、唯一の有効な<ruby>指し手<rt>ポインタ</rt></ruby>を作成するので、安全な方法で<ruby>譜面<rt>コード</rt></ruby>を。

対照的に、リスト19-7の`slice::from_raw_parts_mut`使用は、`slice::from_raw_parts_mut`の使用時に<ruby>異常終了<rt>クラッシュ</rt></ruby>する可能性があります。
この<ruby>譜面<rt>コード</rt></ruby>は任意の記憶位置をとり、10,000個の項目のスライスを作成します。

```rust
use std::slice;

let address = 0x012345usize;
let r = address as *mut i32;

let slice = unsafe {
    slice::from_raw_parts_mut(r, 10000)
};
```

<span class="caption">リスト19-7。任意の記憶位置からスライスを作成する</span>

この任意の場所に記憶を所有しておらず、この<ruby>譜面<rt>コード</rt></ruby>が作成するスライスに有効な`i32`値が含まれているという保証はありません。
有効なスライスであるかのように`slice`を使用しようとすると、未定義の動作が発生します。

#### `extern`機能を使用した外部<ruby>譜面<rt>コード</rt></ruby>の呼び出し

時々、Rustの<ruby>譜面<rt>コード</rt></ruby>は、別の言語で書かれた<ruby>譜面<rt>コード</rt></ruby>と対話する必要があるかもしれません。
このため、Rustには*外部機能<ruby>接点<rt>インターフェース</rt></ruby>（FFI）*の作成と使用を容易にする`extern`という予約語があります。
FFIは、<ruby>演譜<rt>プログラミング</rt></ruby>言語が機能を定義し、それらの機能を呼び出すために異なる（外部の）<ruby>演譜<rt>プログラミング</rt></ruby>言語を使用可能にする方法です。

リスト19-8は、C標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`abs`機能との統合を設定する方法を示しています。
`extern`<ruby>段落<rt>ブロック</rt></ruby>内で宣言された機能は、必ずしもRust<ruby>譜面<rt>コード</rt></ruby>から呼び出すのは安全ではありません。
その理由は、他の言語はRustの規則と保証を強制型変換せず、Rustはそれらを検査できないため、安全性を確保するために<ruby>演譜師<rt>プログラマー</rt></ruby>が責任を負うからです。

<span class="filename">ファイル名。src/main.rs</span>

```rust
extern "C" {
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("Absolute value of -3 according to C: {}", abs(-3));
    }
}
```

<span class="caption">リスト19-8。別の言語で定義された<code>extern</code>機能の宣言と呼び出し</span>

`extern "C"`<ruby>段落<rt>ブロック</rt></ruby>内では、外部機能の名前と署名を、別の言語から呼び出したいとします。
`"C"`部分は、外部機能が使用する*譜体<ruby>二進譜<rt>バイナリ</rt></ruby>接点（ABI）を*定義します。ABIは、アセンブリ水準で機能を呼び出す方法を定義します。
`"C"` ABIは最も一般的であり、C<ruby>演譜<rt>プログラミング</rt></ruby>言語のABIに従います。

> #### 他の言語からRust機能を呼び出す
> 
> > `extern`を使用して、他の言語がRust機能を呼び出すことができるようにする<ruby>接点<rt>インターフェース</rt></ruby>を作成することもできます。
> > 代わりに`extern`<ruby>段落<rt>ブロック</rt></ruby>、追加`extern`予約語をし、直前に使用するABIを指定`fn`予約語。
> > また、`#[no_mangle]`<ruby>補注<rt>アノテーション</rt></ruby>を追加して、この機能の名前をmangleしないようにRust<ruby>製譜器<rt>コンパイラー</rt></ruby>に指示する必要があります。
> > *Mangling*は<ruby>製譜器<rt>コンパイラー</rt></ruby>が機能を与えた名前を、<ruby>製譜<rt>コンパイル</rt></ruby>過程の他の部分が消費するが人間の読取り可能性は低いというより多くの情報を含む別の名前に変更するときです。
> > すべての<ruby>演譜<rt>プログラミング</rt></ruby>言語<ruby>製譜器<rt>コンパイラー</rt></ruby>は名前を若干違うようにマングルするので、Rust機能が他の言語で名前を付けるためには、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>の名前マングリングを無効にする必要があります。
> 
> > 次の例では、`call_from_c`機能を共有<ruby>譜集<rt>ライブラリー</rt></ruby>に<ruby>製譜<rt>コンパイル</rt></ruby>してC<ruby>譜面<rt>コード</rt></ruby>からリンクした後で、C<ruby>譜面<rt>コード</rt></ruby>からアクセスできるようにします。
> 
> ```rust
> #[no_mangle]
> pub extern "C" fn call_from_c() {
>     println!("Just called a Rust function from C!");
> }
> ```
> 
> > `extern`この使用法は`unsafe`ないことを要求しませ`unsafe`。

### 可変静的変数へのアクセスまたは変更

今まで、Rustはサポートしていますが、Rustの所有権ルールでは問題になる可能性がある*大域変数*については説明していません。
2つの<ruby>走脈<rt>スレッド</rt></ruby>が同じ可変大域変数にアクセスしている場合、データ競合が発生する可能性があります。

Rustでは、大域変数は*静的*変数と呼ばれます。
リスト19-9は、<ruby>文字列<rt>ストリング</rt></ruby>sliceを値として持つ静的変数の宣言と使用例を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
static HELLO_WORLD: &str = "Hello, world!";

fn main() {
    println!("name is: {}", HELLO_WORLD);
}
```

<span class="caption">リスト19-9。不変の静的変数の定義と使用</span>

静的変数は定数と似ています。これについては第3章の「変数と定数の違い」で説明しました。静的変数の名前は慣習的に`SCREAMING_SNAKE_CASE`に*あり*、変数の型に<ruby>注釈<rt>コメント</rt></ruby>を付ける*必要があり* `&'static str`。この例。
静的変数は`'static`寿命を持つ参照のみを格納できます。これは、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>が寿命を把握できることを意味します。
明示的に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありません。
不変の静的変数へのアクセスは安全です。

定数と不変の静的変数は同じように見えるかもしれませんが、微妙な違いは静的な変数の値が記憶内の固定番地を持つことです。
値を使用すると常に同じデータにアクセスします。
一方、定数は使用されるたびにデータを複製することができます。

定数と静的変数の別の違いは、静的変数が変更可能であることです。
可変静的変数へのアクセスと変更は*安全で*はあり*ません*。
リスト19-10は、`COUNTER`という可変静的変数を宣言、アクセス、および変更する方法を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
static mut COUNTER: u32 = 0;

fn add_to_count(inc: u32) {
    unsafe {
        COUNTER += inc;
    }
}

fn main() {
    add_to_count(3);

    unsafe {
        println!("COUNTER: {}", COUNTER);
    }
}
```

<span class="caption">リスト19-10。可変静的変数からの読み書きは安全ではありません</span>

通常の変数と同様に、`mut`予約語を使用してmutabilityを指定します。
`COUNTER`から読み取りまたは書き込みを行う<ruby>譜面<rt>コード</rt></ruby>は、`unsafe`<ruby>段落<rt>ブロック</rt></ruby>内になければなりません。
この<ruby>譜面<rt>コード</rt></ruby>は、単一<ruby>走脈<rt>スレッド</rt></ruby>であるため、`COUNTER: 3`を<ruby>製譜<rt>コンパイル</rt></ruby>して出力します。
複数の<ruby>走脈<rt>スレッド</rt></ruby>が`COUNTER`アクセスすると、データ競合が発生する可能性があります。

大域が操作可能な変更可能なデータでは、データの競合がないことを保証することは難しいため、Rustは変更可能な静的変数を安全でないとみなしています。
可能であれば、第16章で説明した並行処理手法と<ruby>走脈<rt>スレッド</rt></ruby>セーフスマート<ruby>指し手<rt>ポインタ</rt></ruby>を使用することが望ましいため、<ruby>製譜器<rt>コンパイラー</rt></ruby>は、異なる<ruby>走脈<rt>スレッド</rt></ruby>からアクセスされたデータが安全に実行されることをチェックします。

### 安全でない<ruby>特性<rt>トレイト</rt></ruby>の実装

`unsafe`で`unsafe`場合にのみ機能する最終的な動作は、安全でない<ruby>特性<rt>トレイト</rt></ruby>を実装することです。
少なくとも1つの<ruby>操作法<rt>メソッド</rt></ruby>に<ruby>製譜器<rt>コンパイラー</rt></ruby>が検証できない不変量がある場合、<ruby>特性<rt>トレイト</rt></ruby>は安全ではありません。
リスト19-11に示すように、<ruby>特性<rt>トレイト</rt></ruby>の前に`unsafe`予約語を追加し、`trait`の実装を`unsafe`ものとしてマークすることで、<ruby>特性<rt>トレイト</rt></ruby>が`unsafe`ことを宣言することができます。

```rust
unsafe trait Foo {
#    // methods go here
    // <ruby>操作法<rt>メソッド</rt></ruby>はここに行く
}

unsafe impl Foo for i32 {
#    // method implementations go here
    // <ruby>操作法<rt>メソッド</rt></ruby>実装はここに
}
```

<span class="caption">リスト19-11。危険な<ruby>特性<rt>トレイト</rt></ruby>の定義と実装</span>

`unsafe impl`を使用することで、<ruby>製譜器<rt>コンパイラー</rt></ruby>が検証できない不変条件を維持することを約束しています。

たとえば、第16章の「 `Sync`と`Send`<ruby>特性<rt>トレイト</rt></ruby>による拡張可能な並列実行」の章で説明した`Sync`と`Send`マーカーの<ruby>特性<rt>トレイト</rt></ruby>を思い出して`Send`これらの<ruby>特性<rt>トレイト</rt></ruby>は、すべての型が`Send`型と`Sync`型で構成されていれば自動的に実装されます。
未処理の<ruby>指し手<rt>ポインタ</rt></ruby>など、`Send`または`Sync`ではない型を実装している場合、その型を`Send`または`Sync`としてマークするには、`unsafe`ないものを使用する必要があります。
Rustは、型が<ruby>走脈<rt>スレッド</rt></ruby>間で安全に送信されたり、複数の<ruby>走脈<rt>スレッド</rt></ruby>からアクセスされたりする保証があることを検証することはできません。
したがって、これらのチェックを手動で行い、`unsafe`で`unsafe`として指示する必要があります。

### 安全でない<ruby>譜面<rt>コード</rt></ruby>を使用する場合

今話題にされた4つの行動（超大国）のうちの1つを取るために`unsafe`を使用することは、間違っていないか、あるいは悩まされることさえありません。
しかし、<ruby>製譜器<rt>コンパイラー</rt></ruby>が<ruby>記憶域<rt>メモリー</rt></ruby>の安全性を支えることができないため、`unsafe`<ruby>譜面<rt>コード</rt></ruby>を正しいものにするのは難しいです。
`unsafe`<ruby>譜面<rt>コード</rt></ruby>を使用する理由がある場合は、そうすることができます。明示的で`unsafe`<ruby>注釈<rt>コメント</rt></ruby>があれば、問題が発生した場合に問題の原因を追跡するのが簡単になります。
