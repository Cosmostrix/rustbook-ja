## 所有権とは何でしょうか？　

Rustの主な特徴は*所有権*です。
この機能は説明するのは簡単ですが、残りの言語には深い意味があります。

すべての<ruby>算譜<rt>プログラム</rt></ruby>は、実行中に<ruby>計算機<rt>コンピューター</rt></ruby>の記憶を使用する方法を管理する必要があります。
一部の言語では、<ruby>算譜<rt>プログラム</rt></ruby>の実行中に記憶が使用されなくなることを常に検出する<ruby>ごみ集め<rt>ガベージコレクション</rt></ruby>があります。
他の言語では、<ruby>演譜師<rt>プログラマー</rt></ruby>は記憶を明示的に割り当てて解放する必要があります。
Rustは第3のアプローチを使用しています。記憶は、<ruby>製譜<rt>コンパイル</rt></ruby>時に<ruby>製譜器<rt>コンパイラー</rt></ruby>がチェックする一連の規則を持つ所有権体系によって管理されます。
所有権機能は、実行中に<ruby>算譜<rt>プログラム</rt></ruby>の速度を低下させるものではありません。

所有権は多くの<ruby>演譜師<rt>プログラマー</rt></ruby>のための新しい概念なので、慣れるまでに時間がかかります。
良い情報は、Rustと所有権体系のルールにもっと熟練すればするほど、安全かつ効率的な<ruby>譜面<rt>コード</rt></ruby>を自然に開発できるようになることです。
それをつけろ！　

所有権を理解すると、Rustをユニークにする機能を理解するための強固な基盤が得られます。
この章では、非常に一般的なデータ構造（<ruby>文字列<rt>ストリング</rt></ruby>）に焦点を当てたいくつかの例を使って、所有権を学習します。

> ### <ruby>山<rt>スタック</rt></ruby>と原
> 
> > 多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語では、<ruby>山<rt>スタック</rt></ruby>と原について非常に頻繁に考える必要はありません。
> > しかし、Rustのようなシステム<ruby>演譜<rt>プログラミング</rt></ruby>言語では、値が<ruby>山<rt>スタック</rt></ruby>上にあるか原上にあるかは、言語の振る舞いや特定の決定を下さなければならない理由に大きな影響を与えます。
> > 所有権の一部については、この章の後半で<ruby>山<rt>スタック</rt></ruby>と原に関連して説明しますので、ここでは簡単な説明をします。
> 
> > <ruby>山<rt>スタック</rt></ruby>と原は、実行時に<ruby>譜面<rt>コード</rt></ruby>で使用できる<ruby>記憶域<rt>メモリー</rt></ruby>の一部ですが、さまざまな方法で構造化されています。
> > <ruby>山<rt>スタック</rt></ruby>は値を取得した順に値を格納し、逆の順序で値を削除します。
> > これは、後で先入れ先出しと呼ば*れ*ます。
> > 皿の<ruby>山<rt>スタック</rt></ruby>を考えてみましょう。皿を追加するときは、皿の上に置き、皿が必要なときは、皿を上から外します。
> > 中央や底からの皿の追加や削除もうまくいかないでしょう！　
> > データの追加*は<ruby>山<rt>スタック</rt></ruby>へのプッシュ*と呼ば*れ、*データの削除*は<ruby>山<rt>スタック</rt></ruby>からのポップオフ*と呼ばれ*ます*。
> 
> > <ruby>山<rt>スタック</rt></ruby>はデータにアクセスする方法が速いため、高速です。新しいデータを置く場所やデータを取得する場所を検索する必要はありません。その場所は常に先頭にあるからです。
> > <ruby>山<rt>スタック</rt></ruby>を高速化するもう1つの<ruby>特性<rt>トレイト</rt></ruby>は、<ruby>山<rt>スタック</rt></ruby>上のすべてのデータが既知の固定サイズを占有しなければならないということです。
> 
> > <ruby>製譜<rt>コンパイル</rt></ruby>時にサイズが不明なデータまたは変更される可能性があるサイズのデータ​​は、代わりに原に格納できます。
> > 原は組織化されていません。原上にデータを置くと、いくらかの容量を要求します。
> > <ruby>基本算系<rt>オペレーティングシステム</rt></ruby>は、原内のどこかに空きがあり、十分な大きさの空き領域を見つけ出し、使用中であるとマークし、その場所の番地である*<ruby>指し手<rt>ポインタ</rt></ruby>*を返します。
> > この過程は*、原上での割り当て*と呼ばれ、時には単に「割り当て」と略されます。<ruby>山<rt>スタック</rt></ruby>に値をプッシュすることは、割り当てとはみなされません。
> > <ruby>指し手<rt>ポインタ</rt></ruby>は既知の固定サイズなので、<ruby>山<rt>スタック</rt></ruby>に<ruby>指し手<rt>ポインタ</rt></ruby>を格納することはできますが、実際のデータが必要な場合は<ruby>指し手<rt>ポインタ</rt></ruby>をたどらなければなりません。
> 
> > レストランに座っていると考えてください。
> > 入力すると、グループの人の数を述べ、スタッフは誰にも合ってあなたをリードする空のテーブルを見つけます。
> > グループの誰かが遅れて来たら、どこに座ってあなたを見つけるのかを聞くことができます。
> 
> > 原内のデータへのアクセスは、そこに到達するための<ruby>指し手<rt>ポインタ</rt></ruby>に従わなければならないため、<ruby>山<rt>スタック</rt></ruby>上のデータにアクセスするよりも時間がかかります。
> > 現代のプロセッサは、記憶が少なくても飛び越えば高速になります。
> > 同様のことを続けると、多くのテーブルから注文を受けているレストランの<ruby>提供器<rt>サーバー</rt></ruby>を考えてみましょう。
> > 1つのテーブルですべての注文を取得してから次のテーブルに移動するのが最も効率的です。
> > テーブルAからの注文を受けると、テーブルBからの注文、次にAからの注文、Bからの注文の順番はずっと遅くなります。
> > 同様に、プロセッサは、（原上にあるように）離れているのではなく、（<ruby>山<rt>スタック</rt></ruby>上にある）他のデータに近いデータで動作する場合、その仕事をより良くすることができます。
> > 原上に大量の領域を割り当てることも時間がかかることがあります。
> 
> > <ruby>譜面<rt>コード</rt></ruby>が機能を呼び出すと、機能に渡された値（原上のデータへの<ruby>指し手<rt>ポインタ</rt></ruby>を含む）と機能のローカル変数が<ruby>山<rt>スタック</rt></ruby>にプッシュされます。
> > 機能が終了すると、それらの値が<ruby>山<rt>スタック</rt></ruby>からポップされます。
> 
> > 原上のどのデータを使用しているのかを追跡し、原上の重複データの量を最小限に抑え、原上の未使用データを後始末してスペースを使い果たしないようにすることは、
> > 所有権を理解したら、<ruby>山<rt>スタック</rt></ruby>と原を頻繁に考える必要はありませんが、原データを管理することは所有権が存在する理由で、なぜそれが動作するのかを説明するのに役立ちます。

### 所有権ルール

まず、所有権ルールを見てみましょう。
これらのルールを説明する例で作業するときは、これらのルールを念頭に置いてください。

* Rustの各値には、*所有者*と呼ばれる変数があります。
* 一度に所有できるオーナーは1人だけです。
* 所有者が範囲外になると、その値は削除されます。

### 可変<ruby>有効範囲<rt>スコープ</rt></ruby>

2章ですでに説明したRust<ruby>算譜<rt>プログラム</rt></ruby>の例を見てきました。基本的な構文を過ぎたので、`fn main() {`<ruby>譜面<rt>コード</rt></ruby>の例はすべて含まれていないので、以下の例を`main`機能の中に手動で入れなければなりません。
その結果、例は少し簡潔になり、定型<ruby>譜面<rt>コード</rt></ruby>ではなく実際の詳細に焦点を当てることができます。

所有権の最初の例として、いくつかの変数の*範囲*を見ていきます。
<ruby>有効範囲<rt>スコープ</rt></ruby>は、項目が有効な<ruby>算譜<rt>プログラム</rt></ruby>内の範囲です。
次のような変数があるとします。

```rust
let s = "hello";
```

変数`s`は文字列<ruby>直書き<rt>リテラル</rt></ruby>を参照し、<ruby>文字列<rt>ストリング</rt></ruby>の値は<ruby>算譜<rt>プログラム</rt></ruby>のテキストにハード<ruby>譜面<rt>コード</rt></ruby>されます。
変数は、宣言されているポイントから現在の*<ruby>有効範囲<rt>スコープ</rt></ruby>の*終わりまで*有効*です。
リスト4-1には、変数`s`が有効な場所に<ruby>注釈<rt>コメント</rt></ruby>を付ける<ruby>注釈<rt>コメント</rt></ruby>があります。

```rust
#//{                      // s is not valid here, it’s not yet declared
{                      // ここでは無効ですが、宣言されていません
#//    let s = "hello";   // s is valid from this point forward
    let s = "hello";   // この時点から有効です

#    // do stuff with s
    //  sでものをする
#//}                      // this scope is now over, and s is no longer valid
}                      // この<ruby>有効範囲<rt>スコープ</rt></ruby>は終了し、sはもはや有効ではありません
```

<span class="caption">譜面リスト4-1。変数とその有効範囲</span>

つまり、ここでは2つの重要なポイントがあります。

* `s`が*<ruby>有効範囲<rt>スコープ</rt></ruby>*に入るとき、それは有効です。
* *範囲外になる*まで有効です。

この時点で、<ruby>有効範囲<rt>スコープ</rt></ruby>と変数が有効なときの関係は、他の<ruby>演譜<rt>プログラミング</rt></ruby>言語のそれと同様です。
ここでは、`String`型を導入して、この理解の上に構築します。

### `String`型

所有権の規則を説明するには、第3章の「データ型」の章で説明したよりも複雑なデータ型が必要です。以前に説明した型はすべて<ruby>山<rt>スタック</rt></ruby>に格納され、<ruby>有効範囲<rt>スコープ</rt></ruby>終了しましたが、原に格納されているデータを調べ、Rustがそのデータをいつ後始末するかを知りたいと考えています。

ここでは`String`を例として使用し、所有権に関連する`String`の部分に集中します。
これらの側面は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供され、作成する他の複雑なデータ型にも適用されます。
`String`については第8章で詳しく説明します。

<ruby>文字列<rt>ストリング</rt></ruby>の値が<ruby>算譜<rt>プログラム</rt></ruby>にハード<ruby>譜面<rt>コード</rt></ruby>されている文字列<ruby>直書き<rt>リテラル</rt></ruby>は既に見てきました。
文字列<ruby>直書き<rt>リテラル</rt></ruby>は便利ですが、テキストを使用したいあらゆる状況には適していません。
1つの理由は、それらが不変であるということです。
もう1つは、<ruby>譜面<rt>コード</rt></ruby>を書くときに<ruby>文字列<rt>ストリング</rt></ruby>の値がすべてわかっているわけではないことです。たとえば、利用者の入力を受け取り、格納する場合はどうすればいいでしょうか？　
このような状況の場合、Rustには2番目の<ruby>文字列<rt>ストリング</rt></ruby>型`String`ます。
この型は原上に割り当てられ、<ruby>製譜<rt>コンパイル</rt></ruby>時にはわからない量のテキストを格納することができます。
`from`機能を使用して文字列<ruby>直書き<rt>リテラル</rt></ruby>から`String`を作成することができます。

```rust
let s = String::from("hello");
```

ダブルコロン（`::`:）は、 `string_from`ような何らかの種類の名前を使用するのではなく、この特定の名前空間を`String`型の機能`from`名前空間にすることを可能にする演算子です。
この構文については、第5章の「<ruby>操作法<rt>メソッド</rt></ruby>の構文」の節、第7章の「<ruby>役区<rt>モジュール</rt></ruby>の定義」で<ruby>役区<rt>モジュール</rt></ruby>の名前空間について説明します。

この種の<ruby>文字列<rt>ストリング</rt></ruby>*は*変更*する可能性*があります。

```rust
let mut s = String::from("hello");

#//s.push_str(", world!"); // push_str() appends a literal to a String
s.push_str(", world!"); //  push_str（）は<ruby>文字列<rt>ストリング</rt></ruby>に<ruby>直書き<rt>リテラル</rt></ruby>を追加する

#//println!("{}", s); // This will print `hello, world!`
println!("{}", s); // これで`hello, world!`が<ruby>印字<rt>プリント</rt></ruby>されます
```

では、違いは何でしょうか？　
なぜ`String`は変更できますが、`String`は変更できませんか？　
違いは、これらの2つの型が記憶をどう扱うかです。

### 記憶と割り当て

文字列<ruby>直書き<rt>リテラル</rt></ruby>の場合、<ruby>製譜<rt>コンパイル</rt></ruby>時に内容がわかるので、テキストは最終実行ファイルに直接ハード<ruby>譜面<rt>コード</rt></ruby>されます。
これが、文字列<ruby>直書き<rt>リテラル</rt></ruby>が高速で効率的な理由です。
しかし、これらのプロパティは文字列<ruby>直書き<rt>リテラル</rt></ruby>の不変性からのみ発生します。
残念ながら、<ruby>製譜<rt>コンパイル</rt></ruby>時にサイズが不明で、<ruby>算譜<rt>プログラム</rt></ruby>の実行中にサイズが変更される可能性がある各テキストの<ruby>二進譜<rt>バイナリ</rt></ruby>には、一塊の記憶を入れることはできません。

`String`型では、変更可能な拡張可能なテキストをサポートするために、<ruby>製譜<rt>コンパイル</rt></ruby>時には未知の原上に内容を保持するための記憶量を割り当てる必要があります。
これの意味は。

* 実行時に<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>から記憶を要求する必要があります。
* `String`が完了したら、この記憶を<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>に返す方法が必要です。

最初の部分は私たちによって行われます。 `String::from`を呼び出すとき、その実装は必要な記憶を要求します。
これは<ruby>演譜<rt>プログラミング</rt></ruby>言語ではかなり普遍的です。

しかし、第2の部分は異なます。
*<ruby>ごみ集め<rt>ガベージコレクション</rt></ruby>部（GC）*を持つ言語では、GCはもはや使用されていない記憶を追跡して後始末しますので、考慮する必要はありません。
GCがなければ、記憶が使用されなくなった時点を特定し、明示的に返すために<ruby>譜面<rt>コード</rt></ruby>を呼び出すことは、要求したのと同じです。
これを正しく行うことは、歴史的には<ruby>演譜<rt>プログラミング</rt></ruby>上の困難な問題でした。
忘れてしまったら、記憶を浪費します。
早すぎると無効な変数が返されます。
それを2回行うと、それもバグです。
ちょうど1つの`allocate`をちょうど1つの`free`とペアにする必要があります。

Rustは別のパスをとります。それを所有する変数が範囲外になると、記憶は自動的に返されます。
リスト4-1の<ruby>有効範囲<rt>スコープ</rt></ruby>の例は、文字列<ruby>直書き<rt>リテラル</rt></ruby>の代わりに`String`を使用したものです。

```rust
{
#//    let s = String::from("hello"); // s is valid from this point forward
    let s = String::from("hello"); // この時点から有効です

#    // do stuff with s
    //  sでものをする
#//}                                  // this scope is now over, and s is no
#                                   // longer valid
}                                  // この<ruby>有効範囲<rt>スコープ</rt></ruby>は終了し、sはもはや有効ではありません
```

`String`が必要とする記憶を<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>に返すことができる自然なポイントがあります。 `s`が範囲外になるとき。
変数が<ruby>有効範囲<rt>スコープ</rt></ruby>から外れると、Rustはために特別な機能を呼び出します。
この機能は`drop`と呼ばれ、`String`の作成者が記憶を返すための<ruby>譜面<rt>コード</rt></ruby>を置く場所です。
Rustは、中かっこで自動的に`drop`ます。

> > 注。C ++では、項目の有効期間の終わりに資源を割り当て解除するこのパターンは、「 *資源取得初期化（RAII）」*と呼ばれることもあります。
> > Rustの`drop`機能は、RAIIパターンを使用したことがあればおなじみです。

このパターンは、Rustの<ruby>譜面<rt>コード</rt></ruby>が書き込まれる方法に大きな影響を与えます。
今のところ単純に思えるかもしれませんが、原上に割り当てたデータを複数の変数で使用したい場合、複雑な状況では<ruby>譜面<rt>コード</rt></ruby>の動作が予期しないことがあります。
今これらの状況のいくつかを探そう。

#### 変数とデータのやり取り方法。移動

複数の変数は、Rustの異なる方法で同じデータとやりとりすることができます。
リスト4-2の整数を使った例を見てみましょう。

```rust
let x = 5;
let y = x;
```

<span class="caption">リスト4-2。変数<code>x</code>整数値を<code>y</code>に代入する</span>

おそらくこれが何をしているかを推測することができます。「値束縛`5`に`x`;
`x`の値のコピーを作成して`y`束縛します」 `x`と`y` 2つの変数があり、両方とも`5`ます。
整数は既知の固定サイズの単純な値であり、これらの2つの`5`つの値が<ruby>山<rt>スタック</rt></ruby>にプッシュされるため、これは実際に起こっていることです。

さあ、`String`版を見てみましょう。

```rust
let s1 = String::from("hello");
let s2 = s1;
```

これは前の<ruby>譜面<rt>コード</rt></ruby>と非常によく似ているので、同じように動作すると仮定します。つまり、2行目は`s1`の値のコピーを作成し、`s2`束縛します。
しかし、これはまったく起こりません。

図4-1を見て、カバーの下にある`String`何が起こっているのかを見てください。
`String`は、左に示すように、<ruby>文字列<rt>ストリング</rt></ruby>の内容、長さ、および容量を保持する記憶への<ruby>指し手<rt>ポインタ</rt></ruby>の3つの部分で構成されています。
このデータグループは<ruby>山<rt>スタック</rt></ruby>に格納されます。
右側には内容を保持する原上の記憶があります。

<img src="img/trpl04-01.svg" alt="記憶内の<ruby>文字列<rt>ストリング</rt></ruby>" class="center" />
<span class="caption">図4-1。 <code>s1</code>束縛された値<code>&quot;hello&quot;</code>保持する<code>String</code>記憶内の表現</span>

長さは、`String`の内容が現在使用している記憶量（バイト単位）です。
容量は、`String`が<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>から受け取った和記憶量（バイト単位）です。
長さと容量の違いは重要ですが、ここではそうではありません。今のところ容量を無視しても問題ありません。

`s1`に`s2`を代入すると、`String`データがコピーされます。つまり、<ruby>山<rt>スタック</rt></ruby>上にある<ruby>指し手<rt>ポインタ</rt></ruby>、長さ、および容量がコピーされます。
<ruby>指し手<rt>ポインタ</rt></ruby>が参照する原上のデータはコピーしません。
つまり、記憶内のデータ表現は図4-2のようになります。

<img src="img/trpl04-02.svg" alt="同じ値を指しているs1とs2" class="center" />
<span class="caption">図4-2。 <code>s1</code>指し手、長さ、および容量のコピーを持つ変数<code>s2</code>記憶内の表現</span>

この表現は図4-3のように*は*見えませ*ん*.Rustが原データをコピーした場合の<ruby>記憶域<rt>メモリー</rt></ruby>の様子です。
Rustがこれを実行した場合、原上のデータが大きい場合、`s2 = s1`操作は実行時パフォーマンスが非常に高価になります。

<img src="img/trpl04-03.svg" alt="s1とs2を2箇所に" class="center" />
<span class="caption">図4-3。Rustが原データも同様にコピーした場合の<code>s2 = s1</code>可能性の別の可能性</span>

以前は、変数が<ruby>有効範囲<rt>スコープ</rt></ruby>から外れると、Rustは自動的に`drop`機能を呼び出し、その変数の原記憶を後始末すると言っていました。
しかし、図4-2は、両方のデータ<ruby>指し手<rt>ポインタ</rt></ruby>が同じ場所を指していることを示しています。
これは問題です`s2`と`s1`が範囲外になると、両方とも同じ記憶を解放しようとします。
これは*ダブルフリー*<ruby>誤り<rt>エラー</rt></ruby>として知られており、以前に言及した<ruby>記憶域<rt>メモリー</rt></ruby>の安全性のバグの1つです。
記憶を2回解放すると記憶が破損し、セキュリティの脆弱性が発生する可能性があります。

<ruby>記憶域<rt>メモリー</rt></ruby>の安全性を確保するために、Rustのこの状況で何が起こるかについてもう少し詳細があります。
割り当てられた記憶をコピーしようとする代わりに、Rustは`s1`がもはや有効ではないとみなし、したがって、`s1`が<ruby>有効範囲<rt>スコープ</rt></ruby>外になったときにRustは何も解放する必要はありません。
`s2`が作成された後に`s1`を使用しようとすると何が起きるか調べてください。
それは動作しません。

```rust,ignore
let s1 = String::from("hello");
let s2 = s1;

println!("{}, world!", s1);
```

Rustは無効化された参照を使用できないため、次のような<ruby>誤り<rt>エラー</rt></ruby>が発生します。

```text
error[E0382]: use of moved value: `s1`
 --> src/main.rs:5:28
  |
3 |     let s2 = s1;
  |         -- value moved here
4 |
5 |     println!("{}, world!", s1);
  |                            ^^ value used here after move
  |
  = note: move occurs because `s1` has type `std::string::String`, which does
  not implement the `Copy` trait
```

他の言語で作業しているときに*浅いコピー*と*深いコピー*という言葉を聞いたことがある場合、データをコピーせずに<ruby>指し手<rt>ポインタ</rt></ruby>、長さ、容量をコピーするという概念は、浅いコピーのように聞こえるでしょう。
しかし、Rustは最初の変数を無効にするため、浅いコピーと呼ばれるのではなく、*動き*として知られています。
この例では、`s1`が`s2`に*移動*したとします。
実際に何が起こるかを図4-4に示します。

<img src="img/trpl04-04.svg" alt="s1はs2に移動しました" class="center" />
<span class="caption">図4-4。 <code>s1</code>が無効化された後の記憶内の表現</span>

それが問題を解決する！　
有効な`s2`のみで、範囲外になると、それだけで記憶が解放され、完了です。

さらに、Rustは自動的にデータの「深い」コピーを作成することはありません。
したがって、*自動*コピーは、実行時のパフォーマンスに関して安価であるとみなすことができます。

#### 変数とデータのやりとり方法。クローン

<ruby>山<rt>スタック</rt></ruby>データだけでなく、`String`原データを深くコピー*し*たい場合は、`clone`という一般的な<ruby>操作法<rt>メソッド</rt></ruby>を使用できます。
第5章では<ruby>操作法<rt>メソッド</rt></ruby>構文について説明しますが、<ruby>操作法<rt>メソッド</rt></ruby>は多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語で共通の機能なので、以前はそれらを見たことがあります。

実際の`clone`<ruby>操作法<rt>メソッド</rt></ruby>の例を次に示します。

```rust
let s1 = String::from("hello");
let s2 = s1.clone();

println!("s1 = {}, s2 = {}", s1, s2);
```

これは正常に動作し、原データ*が*コピーされる図4-3のような動作を明示的に生成します。

`clone`呼び出すと、任意の<ruby>譜面<rt>コード</rt></ruby>が実行されており、その<ruby>譜面<rt>コード</rt></ruby>が高価になることがあります。
これは、何か違うことが起こっているという視覚的な指標です。

#### スタックオンリーデータ。コピー

まだ話していない別のしわがあります。
この<ruby>譜面<rt>コード</rt></ruby>の一部はリスト4-2に示した整数を使用して動作し、有効です。

```rust
let x = 5;
let y = x;

println!("x = {}, y = {}", x, y);
```

しかし、この<ruby>譜面<rt>コード</rt></ruby>はちょうど学んだことと矛盾するようです。 `clone`呼び出す必要はありませんが、`x`はまだ有効で、`y`移動しませんでした。

その理由は、<ruby>製譜<rt>コンパイル</rt></ruby>時に既知のサイズを持つ整数などの型は<ruby>山<rt>スタック</rt></ruby>全体に格納されるため、実際の値のコピーはすばやく作成できるからです。
つまり、変数`y`を作成した後に`x`が有効にならないようにする必要はありません。
言い換えれば、ここでは深いコピーと浅いコピーの間に違いはないので、`clone`を呼び出すことは、通常の浅いコピーとは何も変わりません。

Rustには、<ruby>山<rt>スタック</rt></ruby>に格納されている整数のような型に置くことができる`Copy`<ruby>特性<rt>トレイト</rt></ruby>という特殊な<ruby>注釈<rt>コメント</rt></ruby>があります（第10章の<ruby>特性<rt>トレイト</rt></ruby>について詳しく説明します）。
型に[<ruby>特性<rt>トレイト</rt></ruby>の`Copy`がある場合、割り当て後も古い変数を引き続き使用できます。
Rustは、型またはそのパーツのいずれかが`Drop`<ruby>特性<rt>トレイト</rt></ruby>を実装している場合、`Copy`<ruby>特性<rt>トレイト</rt></ruby>で型に<ruby>注釈<rt>コメント</rt></ruby>を付けることはできません。
値が範囲外になったときに型が特別なものを必要とし、その型に`Copy`<ruby>注釈<rt>コメント</rt></ruby>を追加すると、<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>が発生します。
`Copy`<ruby>注釈<rt>コメント</rt></ruby>を型に追加する方法については、付録Cの「導出可能な<ruby>特性<rt>トレイト</rt></ruby>」を参照してください。

だから`Copy`はどんな型でしょうか？　
確認するために、指定された型の開発資料をチェックすることはできませんが、一般的なルールとして、単純なスカラー値のいずれかのグループは、することができ`Copy`、および割り当てを要求するか、資源のいくつかの形式があるされて何も`Copy`。
`Copy`型のいくつかを以下に示します。

* すべての整数型（`u32`など）。
* Boolean型、`bool`。値は`true`および`false`です。
* すべての浮動小数点数型（`f64`など）。
* 文字型`char`
* 組ではなく、`Copy`もある型が含まれている場合に限ります。
   たとえば、`(i32, i32)`は`Copy`ですが、`(i32, String)`は`Copy`ません。

### 所有権と機能

機能に値を渡す意味論は、変数に値を代入する意味論と同様です。
変数に機能を渡すと、割り当てと同じように移動またはコピーされます。
<ruby>譜面<rt>コード</rt></ruby>リスト4-3には、変数が<ruby>有効範囲<rt>スコープ</rt></ruby>のどこに出入りするかを示す<ruby>補注<rt>アノテーション</rt></ruby>の例があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#//    let s = String::from("hello");  // s comes into scope
    let s = String::from("hello");  //  sは範囲に入る

#//    takes_ownership(s);             // s's value moves into the function...
#                                    // ... and so is no longer valid here
    takes_ownership(s);             //  sの値が機能に移ります......そして、もはやここでは有効ではありません

#//    let x = 5;                      // x comes into scope
    let x = 5;                      //  xが範囲に入る

#//    makes_copy(x);                  // x would move into the function,
#                                    // but i32 is Copy, so it’s okay to still
#                                    // use x afterward
    makes_copy(x);                  //  xは機能に移りますが、i32はコピーなので、後でxを使うのは大丈夫です

#//} // Here, x goes out of scope, then s. But because s's value was moved, nothing
#  // special happens.
} // ここで、xは範囲外になり、次にs。しかし、sの価値が動かされたので、特別なことは起こりません。

#//fn takes_ownership(some_string: String) { // some_string comes into scope
fn takes_ownership(some_string: String) { //  some_stringが範囲に入る
    println!("{}", some_string);
#//} // Here, some_string goes out of scope and `drop` is called. The backing
#  // memory is freed.
} // ここで、some_stringは範囲外になり、`drop`が呼び出されます。バッキング記憶が解放されます。

#//fn makes_copy(some_integer: i32) { // some_integer comes into scope
fn makes_copy(some_integer: i32) { //  some_integerが範囲に入る
    println!("{}", some_integer);
#//} // Here, some_integer goes out of scope. Nothing special happens.
} // ここで、some_integerは範囲外になります。何も特別なことは起こりません。
```

<span class="caption">リスト4-3。所有権と<ruby>有効範囲<rt>スコープ</rt></ruby>が<ruby>注釈<rt>コメント</rt></ruby>付きの機能</span>

`takes_ownership`の呼び出し`s`後に`s`を使用しようとすると、Rustは<ruby>製譜<rt>コンパイル</rt></ruby>時<ruby>誤り<rt>エラー</rt></ruby>を<ruby>送出<rt>スロー</rt></ruby>します。
これらの静的チェックは、私たちを間違いから守ります。
`s`と`x`を使用する`main`<ruby>譜面<rt>コード</rt></ruby>を追加して、どこでそれらを使用できるか、そして所有権の規則によってそうするのを妨げている場所を見てください。

### 戻り値と範囲

値を返すことで所有権を譲渡することもできます。
リスト4-4は、リスト4-3の<ruby>補注<rt>アノテーション</rt></ruby>と同様の<ruby>補注<rt>アノテーション</rt></ruby>を持つ例です。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#//    let s1 = gives_ownership();         // gives_ownership moves its return
#                                        // value into s1
    let s1 = gives_ownership();         //  give_ownershipは戻り値をs1に移動する

#//    let s2 = String::from("hello");     // s2 comes into scope
    let s2 = String::from("hello");     //  s2が範囲に入る

#//    let s3 = takes_and_gives_back(s2);  // s2 is moved into
#                                        // takes_and_gives_back, which also
#                                        // moves its return value into s3
    let s3 = takes_and_gives_back(s2);  //  s2はtakes_and_gives_backに移動され、戻り値もs3に移動されます
#//} // Here, s3 goes out of scope and is dropped. s2 goes out of scope but was
#  // moved, so nothing happens. s1 goes out of scope and is dropped.
} // ここで、s3は範囲外になり、削除されます。s2は範囲外になりましたが、移動されたので何も起こりません。s1は範囲外になり、削除されます。

#//fn gives_ownership() -> String {             // gives_ownership will move its
#                                             // return value into the function
#                                             // that calls it
fn gives_ownership() -> String {             //  give_ownershipは戻り値をそれを呼び出す機能に移動します

#//    let some_string = String::from("hello"); // some_string comes into scope
    let some_string = String::from("hello"); //  some_stringが範囲に入る

#//    some_string                              // some_string is returned and
#                                             // moves out to the calling
#                                             // function
    some_string                              //  some_stringが返され、呼び出し元の機能に移動します
}

#// takes_and_gives_back will take a String and return one
//  takes_and_gives_backは<ruby>文字列<rt>ストリング</rt></ruby>を受け取り、それを返します
#//fn takes_and_gives_back(a_string: String) -> String { // a_string comes into
#                                                      // scope
fn takes_and_gives_back(a_string: String) -> String { //  a_stringが範囲に入る

#//    a_string  // a_string is returned and moves out to the calling function
    a_string  //  a_stringが返され、呼び出し機能に移動します
}
```

<span class="caption">リスト4-4。戻り値の所有権の転送</span>

変数の所有権は毎回同じパターンに従います。別の変数に値を代入すると、変数が移動します。
原上のデータを含む変数が<ruby>有効範囲<rt>スコープ</rt></ruby>外になると、値がで後始末され`drop`データが別の変数によって所有されるように移動されていない限り。

所有権を取得してから、すべての機能で所有権を返すのはちょっと面倒です。
機能に値を使用させ、所有権を持たせたくない場合はどうすればよいでしょうか？　
渡したものも、機能本体から返されるデータに加えて、それを再び使用したい場合には、戻す必要があるということは、とても厄介です。

リスト4-5に示すように、組を使用して複数の値を返すことは可能です。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let s1 = String::from("hello");

    let (s2, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s2, len);
}

fn calculate_length(s: String) -> (String, usize) {
#//    let length = s.len(); // len() returns the length of a String
    let length = s.len(); //  len（）は<ruby>文字列<rt>ストリング</rt></ruby>の長さを返します。

    (s, length)
}
```

<span class="caption">リスト4-5。パラメータの所有権を返す</span>

しかし、これはあまりにも多くの式典であり、一般的でなければならない概念のための多くの仕事です。
幸いなことに、Rustにはこの概念のための機能があり、*参照*と呼ばれてい*ます*。
