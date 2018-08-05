## <ruby>対象<rt>オブジェクト</rt></ruby>指向言語の特徴

<ruby>演譜<rt>プログラミング</rt></ruby>コミュニティには、言語が<ruby>対象<rt>オブジェクト</rt></ruby>指向とみなされる必要がある機能についてのコンセンサスはない。
Rustは、OOPを含む多くの<ruby>演譜<rt>プログラミング</rt></ruby>パラダイムの影響を受けます。
たとえば、第13章の関数型<ruby>演譜<rt>プログラミング</rt></ruby>の機能を調べました.OOP言語は、<ruby>対象<rt>オブジェクト</rt></ruby>、カプセル化、および継承といった特定の共通の<ruby>特性<rt>トレイト</rt></ruby>を共有しています。
これらの特徴のそれぞれが何を意味し、Rustがそれをサポートしているかを見てみましょう。

### データと動作を含む<ruby>対象<rt>オブジェクト</rt></ruby>

「 *Design Patterns。* Enoch Gamma、Richard Helm、Ralph Johnson、John Vlissides（Addison-Wesley Professional、1994）の*「再利用可能な<ruby>対象<rt>オブジェクト</rt></ruby>指向<ruby>譜体<rt>アプリケーション</rt></ruby>の要素* 」の本は、*The Gang of Fourという*本書では<ruby>対象<rt>オブジェクト</rt></ruby>指向のカタログ設計パターン。
これはOOPを以下のように定義します。

> > <ruby>対象<rt>オブジェクト</rt></ruby>指向<ruby>算譜<rt>プログラム</rt></ruby>は<ruby>対象<rt>オブジェクト</rt></ruby>で構成されています。
> > *<ruby>対象<rt>オブジェクト</rt></ruby>は*、データとそのデータで動作するプロシージャの両方をパッケージ化します。
> > この手順は、通常、*<ruby>操作法<rt>メソッド</rt></ruby>*または*操作*と呼ばれ*ます*。

この定義を使用すると、Rustは<ruby>対象<rt>オブジェクト</rt></ruby>指向です。構造体と列挙型はデータを持ち、`impl`<ruby>段落<rt>ブロック</rt></ruby>は構造体と列挙型の<ruby>操作法<rt>メソッド</rt></ruby>を提供します。
<ruby>操作法<rt>メソッド</rt></ruby>を持つ構造体とenumは<ruby>対象<rt>オブジェクト</rt></ruby>*と呼ばれ*ませんが、Gang of Fourの<ruby>対象<rt>オブジェクト</rt></ruby>定義によれば、同じ機能を提供します。

### 実装の詳細を隠すカプセル化

一般的にOOPに関連するもう1つの側面は、<ruby>対象<rt>オブジェクト</rt></ruby>の実装の詳細がその<ruby>対象<rt>オブジェクト</rt></ruby>を使用する<ruby>譜面<rt>コード</rt></ruby>にアクセスできないことを意味する*カプセル化*のアイデアです。
したがって、<ruby>対象<rt>オブジェクト</rt></ruby>とやり取りする唯一の方法は、<ruby>公開<rt>パブリック</rt></ruby>APIを使用することです。
<ruby>対象<rt>オブジェクト</rt></ruby>を使用する<ruby>譜面<rt>コード</rt></ruby>は、<ruby>対象<rt>オブジェクト</rt></ruby>の内部に到達してデータやビヘイビアを直接変更することはできません。
これにより、<ruby>演譜師<rt>プログラマー</rt></ruby>は、<ruby>対象<rt>オブジェクト</rt></ruby>を使用する<ruby>譜面<rt>コード</rt></ruby>を変更することなく、<ruby>対象<rt>オブジェクト</rt></ruby>の内部を変更してリファクタリングすることができます。

第7章でカプセル化を制御する方法について説明しました`pub`予約語を使用して、<ruby>譜面<rt>コード</rt></ruby>内のどの<ruby>役区<rt>モジュール</rt></ruby>、型、機能、<ruby>操作法<rt>メソッド</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>するかを決めることができます。
たとえば、`i32`値のベクトルを含む<ruby>欄<rt>フィールド</rt></ruby>を持つstruct `AveragedCollection`を定義できます。
構造体には、ベクトルの値の平均を含む<ruby>欄<rt>フィールド</rt></ruby>もあります。つまり、必要に応じて、必要に応じて平均値を計算する必要はありません。
つまり、`AveragedCollection`は計算された平均をキャッシュします。
リスト17-1は、`AveragedCollection`構造体の定義を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub struct AveragedCollection {
    list: Vec<i32>,
    average: f64,
}
```

<span class="caption">リスト17-1。整数リストと<ruby>集まり<rt>コレクション</rt></ruby>内の項目の平均を保持する<code>AveragedCollection</code>構造体</span>

構造体は`pub`とマークされ、他の<ruby>譜面<rt>コード</rt></ruby>でも使用できますが、構造体内の<ruby>欄<rt>フィールド</rt></ruby>は<ruby>内部用<rt>プライベート</rt></ruby>のままです。
この場合、値がリストに追加または削除されるたびに平均値も更新されるようにしたいので、これは重要です。
これは、リスト17-2に示すように、構造体に対して`add`、 `remove`、 `average`<ruby>操作法<rt>メソッド</rt></ruby>を実装`add`で`remove`ます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# pub struct AveragedCollection {
#     list: Vec<i32>,
#     average: f64,
# }
impl AveragedCollection {
    pub fn add(&mut self, value: i32) {
        self.list.push(value);
        self.update_average();
    }

    pub fn remove(&mut self) -> Option<i32> {
        let result = self.list.pop();
        match result {
            Some(value) => {
                self.update_average();
                Some(value)
            },
            None => None,
        }
    }

    pub fn average(&self) -> f64 {
        self.average
    }

    fn update_average(&mut self) {
        let total: i32 = self.list.iter().sum();
        self.average = total as f64/self.list.len() as f64;
    }
}
```

<span class="caption">リスト17-2。 <code>AveragedCollection</code> public操作法<code>add</code> 、 <code>remove</code> 、 <code>average</code>実装</span>

`AveragedCollection`<ruby>実例<rt>インスタンス</rt></ruby>を変更するには、public<ruby>操作法<rt>メソッド</rt></ruby>`add`、 `remove`、および`average`が唯一の方法です。
項目が`add`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`list`に`add`れるか、または`remove`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`remove`されると、それぞれの実装は`average`<ruby>欄<rt>フィールド</rt></ruby>の更新を処理するprivate `update_average`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出します。

`list`と`average`<ruby>欄<rt>フィールド</rt></ruby>を非<ruby>公開<rt>パブリック</rt></ruby>にしているので、外部<ruby>譜面<rt>コード</rt></ruby>が項目を`list`<ruby>欄<rt>フィールド</rt></ruby>に直接追加または削除する方法はありません。
それ以外の場合は、`list`が変更されたときに`average`<ruby>欄<rt>フィールド</rt></ruby>が同期しなくなることがあります。
`average`<ruby>操作法<rt>メソッド</rt></ruby>は`average`<ruby>欄<rt>フィールド</rt></ruby>の値を返します。これにより、外部<ruby>譜面<rt>コード</rt></ruby>は`average`を読み取ることができますが、変更はできません。

struct `AveragedCollection`実装の詳細をカプセル化したので、将来、データ構造などのアスペクトを簡単に変更できます。
たとえば、`list`<ruby>欄<rt>フィールド</rt></ruby>に`Vec<i32>`代わりに`HashSet<i32>`使用できます。
`add`、 `remove`、および`average`公開<ruby>操作法<rt>メソッド</rt></ruby>の型注釈が同じであれば、`AveragedCollection`を使用する<ruby>譜面<rt>コード</rt></ruby>は変更する必要はありません。
行った場合`list`代わりに<ruby>公開<rt>パブリック</rt></ruby>された、これは必ずしもそうではないでしょう。`HashSet<i32>`と`Vec<i32>`、外部<ruby>譜面<rt>コード</rt></ruby>はおそらくそれが変更された場合は変更する必要がありますので、項目の追加と削除のためのさまざまな方法を持っている`list`直接。

カプセル化が、言語が<ruby>対象<rt>オブジェクト</rt></ruby>指向とみなされるために必要な側面である場合、Rustはその要件を満たします。
<ruby>譜面<rt>コード</rt></ruby>のさまざまな部分に`pub`を使用するかどうかを選択すると、実装の詳細をカプセル化できます。

### 型体系としての継承と<ruby>譜面<rt>コード</rt></ruby>共有

*継承*は、<ruby>対象<rt>オブジェクト</rt></ruby>が別の<ruby>対象<rt>オブジェクト</rt></ruby>の定義から継承することができるしくみであり、そのため、再度定義することなく、親<ruby>対象<rt>オブジェクト</rt></ruby>のデータと動作が得られます。

言語が<ruby>対象<rt>オブジェクト</rt></ruby>指向言語であるために継承を持たなければならない場合、Rustは1ではありません。
親構造体の<ruby>欄<rt>フィールド</rt></ruby>と<ruby>操作法<rt>メソッド</rt></ruby>の実装を継承する構造体を定義する方法はありません。
しかし、<ruby>演譜<rt>プログラミング</rt></ruby>道具ボックスに継承されることに慣れている場合は、最初に継承の理由に応じて、Rustの他のソリューションを使用することができます。

主に2つの理由から継承を選択します。
1つは<ruby>譜面<rt>コード</rt></ruby>の再利用です。ある型に対して特定の動作を実装することができ、継承を使用すると、その型の実装を再利用できます。
代わりに、<ruby>黙用<rt>デフォルト</rt></ruby>の特性<ruby>操作法<rt>メソッド</rt></ruby>実装を使用してRust<ruby>譜面<rt>コード</rt></ruby>を共有することができます。これは、リスト10-14で`Summary`<ruby>特性<rt>トレイト</rt></ruby>の`summarize`<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>実装を追加したときに見ました。
実装する任意の型の`Summary`<ruby>特性<rt>トレイト</rt></ruby>は持っているでしょう`summarize`任意の更なる<ruby>譜面<rt>コード</rt></ruby>なしにそれに方法が利用できます。
これは、<ruby>操作法<rt>メソッド</rt></ruby>の実装を持つ親クラスと、<ruby>操作法<rt>メソッド</rt></ruby>の実装を持つ継承する子クラスに似ています。
また、`Summary`クラスの実装時には、親クラスから継承した<ruby>操作法<rt>メソッド</rt></ruby>の実装を上書きする子クラスに似ている`Summary`プロパティを実装するときに、`summarize`<ruby>操作法<rt>メソッド</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>の実装を上書きすることもできます。

継承を使用するもう一つの理由は、型体系に関係します。子型を親型と同じ場所で使用できるようにすること。
これは、*ポリモフィズム*とも呼ばれ、特定の<ruby>特性<rt>トレイト</rt></ruby>を共有する複数の<ruby>対象<rt>オブジェクト</rt></ruby>を実行時に互いに置き換えることができます。

> ### 多相性
> 
> > 多くの人にとって、多相性は継承と同義です。
> > しかし、実際には、複数の型のデータで動作する<ruby>譜面<rt>コード</rt></ruby>を指す、より一般的な概念です。
> > 継承の場合、これらの型は一般に下位クラスです。
> 
> > 代わりにRustは総称化を使用して、異なる型の可能性のある型と<ruby>特性<rt>トレイト</rt></ruby>縛りを抽象化して、それらの型が提供しなければならないものに制約を課します。
> > これは、*有界パラメトリック多相性*とも呼ばれ*ます*。

継承は、多くの場合、必要以上に多くの<ruby>譜面<rt>コード</rt></ruby>を共有するリスクがあるため、多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語の<ruby>演譜<rt>プログラミング</rt></ruby>設計ソリューションとして、近年好まれていません。
下位クラスは、親クラスのすべての<ruby>特性<rt>トレイト</rt></ruby>を常に共有してはいけませんが、継承ではそうします。
これにより、<ruby>算譜<rt>プログラム</rt></ruby>の設計の柔軟性が低下する可能性があります。
また、<ruby>操作法<rt>メソッド</rt></ruby>が下位クラスに適用されないため、意味を持たない下位クラスや<ruby>誤り<rt>エラー</rt></ruby>の原因となる下位クラスで<ruby>操作法<rt>メソッド</rt></ruby>を呼び出す可能性があります。
さらに、言語によっては、下位クラスが1つのクラスから継承することしかできないため、<ruby>算譜<rt>プログラム</rt></ruby>の設計の柔軟性がさらに制限されます。

これらの理由から、Rustは、継承の代わりに<ruby>特性<rt>トレイト</rt></ruby>対象を使用する別のアプローチを採用しています。
Rustでどのように<ruby>特性<rt>トレイト</rt></ruby>対象が多相性を可能にするかを見てみましょう。
