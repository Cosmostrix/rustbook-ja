## 関連付けられた値を持つキーをハッシュマップに格納する

最後の一般的な<ruby>集まり<rt>コレクション</rt></ruby>は*ハッシュマップ*です。
型`HashMap<K, V>`型のキーのマッピングを格納する`K`型の値に`V`。
これは、これらのキーと値をどのように記憶に格納するかを決定する*ハッシュ機能*を介して行います。
多くの<ruby>演譜<rt>プログラミング</rt></ruby>言語はこの種のデータ構造をサポートしていますが、ハッシュ、マップ、<ruby>対象<rt>オブジェクト</rt></ruby>、ハッシュテーブル、または連想配列などの異なる名前を使用することがよくあります。

ハッシュマップは、ベクトルを使用する場合と同じように、<ruby>添字<rt>インデックス</rt></ruby>を使用せずに任意の型のキーを使用してデータをルックアップする場合に便利です。
たとえば、ゲームでは、各キーがチームの名前で値が各チームのスコアであるハッシュマップで各チームのスコアを追跡できます。
チーム名を指定するとスコアを取得できます。

この章では、ハッシュマップの基本APIについて説明しますが、標準<ruby>譜集<rt>ライブラリー</rt></ruby>では`HashMap<K, V>`定義されている機能にはさらに多くの機能が隠されています。
詳細は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の説明書を参照してください。

### 新しいハッシュマップの作成

`new`を使って空のハッシュマップを作成し、`insert`要素を追加することができます。
リスト8-20では、名前がBlueとYellowの2つのチームの得点を記録しています。
ブルーチームは10地点でスタートし、イエローチームは50地点でスタートします。

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
```

<span class="caption">リスト8-20。新しいハッシュマップを作成し、いくつかのキーと値を挿入する</span>

最初に、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>集まり<rt>コレクション</rt></ruby>部分から`HashMap`を`use`する必要があることに注意してください。
3つの一般的な<ruby>集まり<rt>コレクション</rt></ruby>のうち、これは最も頻繁に使用されるものではないため、プレリュードに自動的に適用される機能には含まれていません。
ハッシュマップは、標準<ruby>譜集<rt>ライブラリー</rt></ruby>からのサポートも少なくなっています。
例えば、それらを構築するための組み込みマクロはありません。

ベクトルと同様に、ハッシュマップは原上にデータを格納します。
この`HashMap`は、型`String`キーと型`i32`値があります。
ベクトルと同様に、ハッシュマップは同種である。すべてのキーは同じ型でなければならず、すべての値は同じ型でなければならない。

ハッシュマップを構築するもう1つの方法は、組のベクトル上で`collect`<ruby>操作法<rt>メソッド</rt></ruby>を使用することです。ここで、各組はキーとその値で構成されます。
`collect`<ruby>操作法<rt>メソッド</rt></ruby>は、`HashMap`を含む多くの<ruby>集まり<rt>コレクション</rt></ruby>型にデータを収集します。
たとえば、チーム名と初期スコアが2つの別々のベクトルにある場合、`zip`<ruby>操作法<rt>メソッド</rt></ruby>を使用して、"Blue"が10とペアになっている組のベクトルを作成することができます。
リスト8-21に示すように、`collect`<ruby>操作法<rt>メソッド</rt></ruby>を使用して組のベクトルをハッシュマップに`collect`ことができます。

```rust
use std::collections::HashMap;

let teams  = vec![String::from("Blue"), String::from("Yellow")];
let initial_scores = vec![10, 50];

let scores: HashMap<_, _> = teams.iter().zip(initial_scores.iter()).collect();
```

<span class="caption">リスト8-21。チームのリストと得点のリストからハッシュマップを作成する</span>

`HashMap<_, _>`型の<ruby>注釈<rt>コメント</rt></ruby>はここで必要です。なぜなら、指定しない限り、多くの異なるデータ構造に`collect`ことが可能であり、Rustは必要なものを知りません。
ただし、キーと値の型のパラメータでは、下線を使用し、ハッシュマップに含まれるデータの型に基づいて型を推測できます。

### ハッシュマップと所有権

`i32`ように、`Copy`<ruby>特性<rt>トレイト</rt></ruby>を実装する型の場合、値はハッシュマップにコピーされます。
リスト8-22に示すように、`String`ような所有値の場合、値は移動され、ハッシュマップはそれらの値の所有者になります。

```rust
use std::collections::HashMap;

let field_name = String::from("Favorite color");
let field_value = String::from("Blue");

let mut map = HashMap::new();
map.insert(field_name, field_value);
#// field_name and field_value are invalid at this point, try using them and
#// see what compiler error you get!
//  field_nameとfield_valueはこの時点で無効です。それらを使用してみて、どの<ruby>製譜器<rt>コンパイラー</rt></ruby>誤りが発生しているのかを確認してください！　
```

<span class="caption">リスト8-22。挿入されたハッシュマップが所有するキーと値の表示</span>

`insert`の呼び出しでハッシュマップに移動された後、変数`field_name`と`field_value`を使用することはできません。

値への参照をハッシュマップに挿入すると、値はハッシュマップに移動されません。
参照が指す値は、少なくともハッシュマップが有効である限り有効でなければなりません。
これらの問題については、第10章の「寿命を使用した参照の検証」の章で詳しく説明します。

### ハッシュマップの値へのアクセス

リスト8-23に示すように、キーを`get`<ruby>操作法<rt>メソッド</rt></ruby>に渡すことで、ハッシュマップから値を取得できます。

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);

let team_name = String::from("Blue");
let score = scores.get(&team_name);
```

<span class="caption">リスト8-23。ハッシュマップに格納されているBlueチームのスコアにアクセスする</span>

`score`は青チームに関連付けられた値があり、結果は`Some(&10)`ます。
`get`は`Option<&V>`返すので、結果は`Some`で包まれます。
そのキーの値がハッシュマップにない場合、`get`は`None`を返します。
<ruby>算譜<rt>プログラム</rt></ruby>は、第6章で取り上げた方法の1つで、`Option`を処理する必要があります。

`for`ループを使用して、ベクトルと同様の方法で、ハッシュマップ内の各キーと値のペアを繰り返し処理できます。

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);

for (key, value) in &scores {
    println!("{}: {}", key, value);
}
```

この<ruby>譜面<rt>コード</rt></ruby>は各ペアを任意の順序で出力します。

```text
Yellow: 50
Blue: 10
```

### ハッシュマップの更新

キーと値の数は増えますが、各キーは一度に1つの値しか関連付けられません。
ハッシュマップ内のデータを変更する場合は、キーにすでに値が割り当てられている場合の処理​​方法を決定する必要があります。
古い値を新しい値に置き換えて、古い値を完全に無視することができます。
古い値を保持して新しい値を無視し、キーにまだ値*がない*場合は新しい値を追加するだけです。
または、古い値と新しい値を組み合わせることもできます。
これらのそれぞれを行う方法を見てみましょう！　

#### 値を上書きする

ハッシュマップにキーと値を挿入し、同じキーに別の値を挿入すると、そのキーに関連付けられた値が置き換えられます。
リスト8-24の<ruby>譜面<rt>コード</rt></ruby>で`insert` 2回呼び出すとしても、Blueチームのキーの値を両方とも挿入するため、ハッシュマップには1つのキーと値のペアしか含まれません。

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 25);

println!("{:?}", scores);
```

<span class="caption">リスト8-24。特定のキーに格納されている値を置き換える</span>

この<ruby>譜面<rt>コード</rt></ruby>は`{"Blue": 25}`を<ruby>印字<rt>プリント</rt></ruby>します。
元の`10`値は上書きされています。

#### キーに値がない場合にのみ値を挿入する

特定のキーに値があるかどうかをチェックし、キーに値がない場合は値を挿入するのが一般的です。
ハッシュマップには、パラメータとしてチェックしたいキーを取得する、この呼び出された`entry`用の特別なAPIがあります。
`entry`<ruby>操作法<rt>メソッド</rt></ruby>の戻り値は、`Entry`と呼ばれる列挙型で、存在する場合と存在しない場合がある値を表します。
Yellowチームのキーに関連する値があるかどうかを確認したいとします。
そうでない場合は、値50を挿入し、Blueチームに同じ値を挿入します。
`entry` APIを使用すると、<ruby>譜面<rt>コード</rt></ruby>はリスト8-25のようになります。

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);

scores.entry(String::from("Yellow")).or_insert(50);
scores.entry(String::from("Blue")).or_insert(50);

println!("{:?}", scores);
```

<span class="caption">リスト8-25。 <code>entry</code>操作法を使って、キーにまだ値がない場合のみ挿入する</span>

`Entry`の`or_insert`<ruby>操作法<rt>メソッド</rt></ruby>は、対応する`Entry`キーが存在する場合はその値への変更可能な参照を返すように定義され、そうでない場合は、このキーの新しい値としてパラメータを挿入し、新しい値への変更可能な参照を返します。
この技法は、<ruby>論理<rt>ロジック</rt></ruby>を書くよりもはるかにクリーンで、さらに、借用検査器でうまくいく。

リスト8-25の<ruby>譜面<rt>コード</rt></ruby>を実行すると`{"Yellow": 50, "Blue": 10}`ます。
黄色のチームには既に価値がないため、`entry`の最初の呼び出しでは、値が50のイエローチームのキーが挿入されます。
2番目の呼び出し`entry`ブルーチームはすでに値が10を持っているので、ハッシュマップを変更しません。

#### 古い値に基づく値の更新

ハッシュマップの別の一般的な使用例は、キーの値をルックアップし、古い値に基づいてキーの値を更新することです。
たとえば、リスト8-26は、各単語がテキストに何回出現するかを数える<ruby>譜面<rt>コード</rt></ruby>を示しています。
単語をキーとしてハッシュマップを使用し、その単語を何回見たかを追跡するために値を増やします。
単語を見たのが初めての場合は、最初に値0を挿入します。

```rust
use std::collections::HashMap;

let text = "hello world wonderful world";

let mut map = HashMap::new();

for word in text.split_whitespace() {
    let count = map.entry(word).or_insert(0);
    *count += 1;
}

println!("{:?}", map);
```

<span class="caption">リスト8-26。単語とカウントを格納するハッシュマップを使って単語の出現を数える</span>

この<ruby>譜面<rt>コード</rt></ruby>は`{"world": 2, "hello": 1, "wonderful": 1}`ます。
`or_insert`<ruby>操作法<rt>メソッド</rt></ruby>は実際にこのキーの値に変更可能な参照（`&mut V`）を返します。
ここでは、その中に変更可能な参照保存`count`その値に割り当てるために、最初の間接参照しなければならないので、変数を`count`アスタリスク（使用して`*`）。
変更可能な参照は`for`ループの終了時に範囲外になるので、これらの変更はすべて安全であり、借用ルールによって許可されます。

### ハッシュ機能

自動的には、`HashMap`は<ruby>役務<rt>サービス</rt></ruby>拒否（DoS）攻撃に抵抗することができる暗号的に安全なハッシュ機能を使用します。
利用可能な最速のハッシング<ruby>計算手続き<rt>アルゴリズム</rt></ruby>ではありませんが、パフォーマンスの低下に伴うより良いセキュリティの<ruby>相殺取引<rt>トレードオフ</rt></ruby>が価値があります。
<ruby>譜面<rt>コード</rt></ruby>を*プロファイリング*し、<ruby>黙用<rt>デフォルト</rt></ruby>のハッシュ機能が目的に応じて遅すぎると*わかっ*た場合は、別の*ハッシャを*指定して別の機能に切り替えることができます。
ハッシャーは、`BuildHasher`<ruby>特性<rt>トレイト</rt></ruby>を実装する型です。
第10章では、<ruby>特性<rt>トレイト</rt></ruby>とその実装方法について説明します。必ずしも独自のハッシャーをゼロから実装する必要はありません。
[crates.io](https://crates.io)は、多くの一般的なハッシング<ruby>計算手続き<rt>アルゴリズム</rt></ruby>を実装しているハッシャーを提供する他のRust利用者が共有する<ruby>譜集<rt>ライブラリー</rt></ruby>があります。

## 概要

ベクトル、<ruby>文字列<rt>ストリング</rt></ruby>、およびハッシュマップは、データを格納、アクセス、および変更する必要がある場合に、<ruby>算譜<rt>プログラム</rt></ruby>に必要な大量の機能を提供します。
ここで解決する必要があるいくつかの演習があります。

* 整数のリストが与えられたら、ベクトルを使用して平均値（平均値）、中央値（ソート時、中央の値）、およびモード（最も頻繁に発生する値;ハッシュマップはここで役立ちます）リストの
* <ruby>文字列<rt>ストリング</rt></ruby>をブタのラテン語に変換します。
   各単語の最初の子音が単語の最後に移動し、"ay"が追加されるので、"最初"は "irst-fay"になります。母音で始まる単語は、代わりに "乾草""は"リンゴ -干し草 "となる）。
   UTF-8符号化の詳細を覚えておいてください！　
* ハッシュマップとベクトルを使用して、利用者が社内の部門に従業員名を追加できるようにするテキスト<ruby>接点<rt>インターフェース</rt></ruby>を作成します。
   たとえば、「Sallyをエンジニアリングに追加する」または「AmirをSalesに追加する」などとします。部門内の全員または部門内の全員のリストをアルファベット順に並べ替えることができます。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>のAPI開発資料では、これらの演習に役立つベクトル、<ruby>文字列<rt>ストリング</rt></ruby>、およびハッシュマップの<ruby>操作法<rt>メソッド</rt></ruby>について説明しています。

操作が失敗するより複雑な<ruby>算譜<rt>プログラム</rt></ruby>になってきているので、<ruby>誤り<rt>エラー</rt></ruby>処理について議論するのに最適なタイミングです。
次にそれをやります！　
