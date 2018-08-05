## 付録C。導出可能な<ruby>特性<rt>トレイト</rt></ruby>

本のさまざまな場所では、structまたはenum定義に適用できる`derive`属性について説明しました。
`derive`属性は、`derive`構文で<ruby>注釈<rt>コメント</rt></ruby>を付けた型で独自の<ruby>黙用<rt>デフォルト</rt></ruby>実装を持つ<ruby>特性<rt>トレイト</rt></ruby>を実装する<ruby>譜面<rt>コード</rt></ruby>を生成します。

この付録では、標準<ruby>譜集<rt>ライブラリー</rt></ruby>ーのすべての<ruby>特性<rt>トレイト</rt></ruby>を`derive`使用することができます。
各章の内容は次のとおりです。

* この<ruby>特性<rt>トレイト</rt></ruby>を導く演算子と<ruby>操作法<rt>メソッド</rt></ruby>が可能にするもの
* `derive`によって提供さ`derive`<ruby>特性<rt>トレイト</rt></ruby>の実装が
* どのような<ruby>特性<rt>トレイト</rt></ruby>を実装するのが型を意味するのか
* その<ruby>特性<rt>トレイト</rt></ruby>を実現することを許されているか否かの条件
* <ruby>特性<rt>トレイト</rt></ruby>を必要とする操作の例

`derive`属性によって提供される動作と異なる動作が必要な場合は、手動で実装する方法の詳細について、各<ruby>特性<rt>トレイト</rt></ruby>の標準<ruby>譜集<rt>ライブラリー</rt></ruby>の説明書を参照してください。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>で定義された<ruby>特性<rt>トレイト</rt></ruby>の残りの部分は、使用して、型に実装することはできません`derive`。
これらの<ruby>特性<rt>トレイト</rt></ruby>は、賢明な<ruby>黙用<rt>デフォルト</rt></ruby>の動作を持たないため、達成しようとしていることに合った方法で実装する必要があります。

導出することができない<ruby>特性<rt>トレイト</rt></ruby>の例は、エンド利用者の書式設定を処理する`Display`です。
エンド利用者に型を表示する適切な方法を常に検討する必要があります。
エンド利用者はどのような部分を見なければなりませんか？　
それらはどの部分に関連性があると思いますか？　
どのような形式のデータが最も関連性がありますか？　
Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>にはこの洞察がないため、適切な<ruby>黙用<rt>デフォルト</rt></ruby>の動作を提供することはできません。

この付録で提供<ruby>特性<rt>トレイト</rt></ruby>誘導のリストは包括的ではありません。<ruby>譜集<rt>ライブラリー</rt></ruby>が実装でき`derive`使用できる<ruby>特性<rt>トレイト</rt></ruby>のリストを作り、自分の<ruby>特性<rt>トレイト</rt></ruby>について`derive`真にオープンエンドで。
実装`derive`、付録Dで覆われている手続きマクロを使用することを含みます

### <ruby>演譜師<rt>プログラマー</rt></ruby>出力の`Debug`

`Debug`<ruby>特性<rt>トレイト</rt></ruby>は、書式<ruby>文字列<rt>ストリング</rt></ruby>の<ruby>虫取り<rt>デバッグ</rt></ruby>書式を有効にします`:?`
`{}`<ruby>場所取り<rt>プレースホルダ</rt></ruby>内にあります。

`Debug`<ruby>特性<rt>トレイト</rt></ruby>を使用すると、<ruby>虫取り<rt>デバッグ</rt></ruby>目的で型の<ruby>実例<rt>インスタンス</rt></ruby>を<ruby>印字<rt>プリント</rt></ruby>できます。したがって、あなたと他の型の<ruby>演譜師<rt>プログラマー</rt></ruby>は、<ruby>算譜<rt>プログラム</rt></ruby>の実行中の特定の地点で<ruby>実例<rt>インスタンス</rt></ruby>を検査できます。

たとえば、`assert_eq!`マクロを使用する場合は、`Debug`<ruby>特性<rt>トレイト</rt></ruby>が必要です。
このマクロは、等価アサーションが失敗した場合に引数として指定された<ruby>実例<rt>インスタンス</rt></ruby>の値を出力するので、2つの<ruby>実例<rt>インスタンス</rt></ruby>が同じでない理由を<ruby>演譜師<rt>プログラマー</rt></ruby>が確認できます。

### 等価比較のための`PartialEq`と`Eq`

`PartialEq`<ruby>特性<rt>トレイト</rt></ruby>では、型の<ruby>実例<rt>インスタンス</rt></ruby>を比較して等しいかどうかをチェックし、`==`および`!=`演算子を使用できます。

`PartialEq`すると、`eq`<ruby>操作法<rt>メソッド</rt></ruby>が実装されます。
structで`PartialEq`が導出されると、2つの<ruby>実例<rt>インスタンス</rt></ruby>は*すべての*<ruby>欄<rt>フィールド</rt></ruby>が等しい場合にのみ等しくなり、<ruby>欄<rt>フィールド</rt></ruby>が等しくない場合には<ruby>実例<rt>インスタンス</rt></ruby>が等しくなりません。
列挙型で導出すると、各<ruby>場合値<rt>バリアント</rt></ruby>はそれ自体に等しく、他の<ruby>場合値<rt>バリアント</rt></ruby>と等しくはありません。

`PartialEq`<ruby>特性<rt>トレイト</rt></ruby>は、たとえば、`assert_eq!`マクロの使用で必要となります`assert_eq!`は、型の2つの<ruby>実例<rt>インスタンス</rt></ruby>を比較できるようにする必要があります。

`Eq`<ruby>特性<rt>トレイト</rt></ruby>には<ruby>操作法<rt>メソッド</rt></ruby>がありません。
その目的は、<ruby>注釈<rt>コメント</rt></ruby>付き型のすべての値に対して、その値がそれ自身と等しいことを通知することです。
`Eq`<ruby>特性<rt>トレイト</rt></ruby>は`PartialEq`実装する型にのみ適用できますが、`PartialEq`を実装するすべての型が`Eq`を実装できるわけではありません。
これの1つの例は浮動小数点数型です。浮動小数点数の実装では、非数（`NaN`）値の2つの<ruby>実例<rt>インスタンス</rt></ruby>が互いに等しくないことが示されています。

場合の例`Eq`のキーのために必要とされている`HashMap<K, V>`ので`HashMap<K, V>` 2つのキーが同じであるかどうかを伝えることができます。

### `PartialOrd`と`Ord`

`PartialOrd`<ruby>特性<rt>トレイト</rt></ruby>では、ソートの目的で型の<ruby>実例<rt>インスタンス</rt></ruby>を比較できます。
`PartialOrd`を実装する型は、`<`、 `>`、 `<=`、および`>=`演算子で使用できます。
あなただけ適用することができます`PartialOrd`も実装する型に<ruby>特性<rt>トレイト</rt></ruby>を`PartialEq`。

`PartialOrd`すると`partial_cmp`<ruby>操作法<rt>メソッド</rt></ruby>が実装され、`PartialOrd`された値が順序付けを生成しない場合は`None`になる`Option<Ordering>`が返されます。
順序を生成しない値の例は、その型のほとんどの値を比較できる場合でも、非数（`NaN`）の浮動小数点値です。
`partial_cmp`を任意の浮動小数点数と`NaN`浮動小数点数で呼び出すと、`None`が返されます。

structで導出すると、`PartialOrd`は、各<ruby>欄<rt>フィールド</rt></ruby>の値を構造体定義に現れる順序で比較して2つの<ruby>実例<rt>インスタンス</rt></ruby>を比較します。
列挙型で導出すると、列挙型定義で前に宣言された列挙型の変形は、後で列挙する変形よりも小さいとみなされます。

`PartialOrd`<ruby>特性<rt>トレイト</rt></ruby>は、たとえば、低い値と高い値で指定された範囲で乱数を生成する`rand` `gen_range`<ruby>操作法<rt>メソッド</rt></ruby>の場合に必要です。

`Ord`<ruby>特性<rt>トレイト</rt></ruby>は、<ruby>注釈<rt>コメント</rt></ruby>付き型の任意の2つの値に対して、有効な順序付けが存在することを知ることができます。
`Ord`<ruby>特性<rt>トレイト</rt></ruby>は、有効な順序付けが常に可能であるため、`Option<Ordering>`ではなく`Ordering`を返す`cmp`<ruby>操作法<rt>メソッド</rt></ruby>を実装します。
`PartialOrd`と`Eq`（ `PartialEq`と`Eq`は`PartialEq`が必要）を実装している型に対してのみ、`Ord`<ruby>特性<rt>トレイト</rt></ruby>を適用することができます。
構造体と列挙型で導出すると、`cmp`は`PartialOrd`で`partial_cmp`の導出実装と同じように動作し`PartialOrd`。

`Ord`が必要な場合の例は、値のソート順に基づいてデータを格納するデータ構造である`BTreeSet<T>`に値を格納する場合です。

### 値を複製するための`Clone`と`Copy`

`Clone`<ruby>特性<rt>トレイト</rt></ruby>を使用すると、明示的に値のディープコピーを作成できます。複製過程では、任意の<ruby>譜面<rt>コード</rt></ruby>を実行して原データをコピーすることがあります。
詳細については、第4章の章。「クローン方法の変数とデータのインターアクト」を参照してください`Clone`。

`Clone`導出は、`clone`<ruby>操作法<rt>メソッド</rt></ruby>を実装します。`clone`<ruby>操作法<rt>メソッド</rt></ruby>は、型全体に実装された場合、その型の各部分で`clone`を呼び出します。
また、これは実装しなければならない型のすべての<ruby>欄<rt>フィールド</rt></ruby>または値を意味`Clone`導出する`Clone`。

`Clone`が必要な場合の例は、スライス上で`to_vec`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す場合です。
スライスには型<ruby>実例<rt>インスタンス</rt></ruby>が含まれていませんが、`to_vec`から返されたベクトルは<ruby>実例<rt>インスタンス</rt></ruby>を所有する必要があるため、`to_vec`は各項目の`clone`を呼び出します。
したがって、スライスに格納された型は`Clone`実装する必要があります。

`Copy`<ruby>特性<rt>トレイト</rt></ruby>では、<ruby>山<rt>スタック</rt></ruby>に格納されたビットをコピーするだけで値を複製できます。
任意の<ruby>譜面<rt>コード</rt></ruby>は必要ありません。
詳細については、第4章の章。「コピー<ruby>山<rt>スタック</rt></ruby>専用データ」を参照してください`Copy`。

`Copy`<ruby>特性<rt>トレイト</rt></ruby>では、<ruby>演譜師<rt>プログラマー</rt></ruby>がそれらの<ruby>操作法<rt>メソッド</rt></ruby>を多重定義したり、任意の<ruby>譜面<rt>コード</rt></ruby>が実行されていないという前提に違反しないようにするための<ruby>操作法<rt>メソッド</rt></ruby>は定義されていません。
そうすれば、すべての<ruby>演譜師<rt>プログラマー</rt></ruby>は値のコピーが非常に高速になると考えることができます。

パーツがすべて`Copy`実装するすべての型で`Copy`を導出させることができます。
あなただけ適用することができます`Copy`も実装する型に<ruby>特性<rt>トレイト</rt></ruby>を`Clone`実装型ので、`Copy`の些細な実装がある`Clone`と同じ仕事を実行し`Copy`。

`Copy`<ruby>特性<rt>トレイト</rt></ruby>はめったに必要ありません。
`Copy`を実装する型には最適化が用意されています。つまり、<ruby>譜面<rt>コード</rt></ruby>をより簡潔にするために`clone`を呼び出す必要はありません。

`Copy`可能なことはすべて、`Clone`でも達成できますが、<ruby>譜面<rt>コード</rt></ruby>は遅くなるか、場所で`clone`を使用する必要があります。

### 値を固定サイズの値にマッピングするための`Hash`

`Hash`<ruby>特性<rt>トレイト</rt></ruby>を使用すると、任意のサイズの型の<ruby>実例<rt>インスタンス</rt></ruby>を取得し、その<ruby>実例<rt>インスタンス</rt></ruby>をハッシュ機能を使用して固定サイズの値にマップできます。
`Hash`導出すると、`hash`<ruby>操作法<rt>メソッド</rt></ruby>が実装されます。
導出した`hash`<ruby>操作法<rt>メソッド</rt></ruby>の実装は、型の各部分で`hash`を呼び出した結果を結合します。つまり、すべての<ruby>欄<rt>フィールド</rt></ruby>または値が`Hash`を導出するために`Hash`実装する必要があります。

`Hash`が必要な場合の例は、データを効率的に格納するためにキーを`HashMap<K, V>`に格納する場合です。

### `Default`値の<ruby>黙用<rt>デフォルト</rt></ruby>

`Default`<ruby>特性<rt>トレイト</rt></ruby>を使用すると、ある型の<ruby>黙用<rt>デフォルト</rt></ruby>値を作成できます。
`Default`導出すると`default`機能が実装され`default`。
導出した`default`機能の実装では、型の各部分で`default`機能が呼び出され`default`。つまり、型のすべての<ruby>欄<rt>フィールド</rt></ruby>または値は`Default`を導出するために`Default.`実装する必要があります`Default.`

`Default::default`機能は、第5章の「構造体更新構文による他の<ruby>実例<rt>インスタンス</rt></ruby>からの<ruby>実例<rt>インスタンス</rt></ruby>の作成」で説明した構造体の更新構文と組み合わせて一般に使用されます。構造体のいくつかの<ruby>欄<rt>フィールド</rt></ruby>をカスタマイズし、`..Default::default()`を使用して残りの<ruby>欄<rt>フィールド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>値を設定します。

たとえば、`Option<T>`<ruby>実例<rt>インスタンス</rt></ruby>で`unwrap_or_default`<ruby>操作法<rt>メソッド</rt></ruby>を使用する場合は、`Default`<ruby>特性<rt>トレイト</rt></ruby>が必要です。
`Option<T>`が`None`場合、`unwrap_or_default`<ruby>操作法<rt>メソッド</rt></ruby>は`Option<T>`格納された`T`型の`Default::default`結果を返し`Default::default`。
