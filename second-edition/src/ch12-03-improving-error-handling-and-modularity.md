## <ruby>役区<rt>モジュール</rt></ruby>性と<ruby>誤り<rt>エラー</rt></ruby>処理を改善するためのリファクタリング

<ruby>算譜<rt>プログラム</rt></ruby>を改善するために、<ruby>算譜<rt>プログラム</rt></ruby>の構造と関係している4つの問題と潜在的な<ruby>誤り<rt>エラー</rt></ruby>をどのように処理するのかを修正します。

最初に、`main`機能は2つの仕事を実行します。引数を解析してファイルを開きます。
このような小さな機能にとって、これは大きな問題ではありません。
しかし、`main`で<ruby>算譜<rt>プログラム</rt></ruby>を成長させ続ければ、`main`機能の<ruby>手綱<rt>ハンドル</rt></ruby>が増えます。
機能が責任を負うにつれて、その一部を破ることなく、推論するのが難しくなり、テストが難しくなり、変更するのが難しくなります。
各機能が1つの仕事を担当するように、機能を分離することが最善です。

この問題は第2の問題にも関連してい`query`と`filename`は<ruby>算譜<rt>プログラム</rt></ruby>の構成変数ですが、`f`や`contents`などの変数を使用して<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>を実行します。
`main`が長くなればなるほど、より多くの変数を<ruby>有効範囲<rt>スコープ</rt></ruby>に入れる必要があります。
<ruby>有効範囲<rt>スコープ</rt></ruby>の変数が多ければ多いほど、それぞれの目的を把握することが難しくなります。
目的を明確にするために、構成変数を1つの構造にグループ化することが最善です。

3番目の問題は、ファイルを開くときに<ruby>誤り<rt>エラー</rt></ruby>メッセージを出力`expect`を`expect`していたが、<ruby>誤り<rt>エラー</rt></ruby>メッセージが単に`file not found`です。
ファイルを開くことは、ファイルが存在しないこと以外にもいくつかの方法で失敗する可能性があります。たとえば、ファイルが存在する可能性がありますが、ファイルを開く権限がない可能性があります。
今の状況では、`file not found`<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示され、利用者に間違った情報が与えられます。

第4に、さまざまな<ruby>誤り<rt>エラー</rt></ruby>を繰り返し処理する`expect`ています。利用者が十分な引数を指定せずに<ruby>算譜<rt>プログラム</rt></ruby>を実行すると、問題を明確に説明していないRustから`index out of bounds`<ruby>誤り<rt>エラー</rt></ruby>が発生します。
<ruby>誤り<rt>エラー</rt></ruby>処理<ruby>論理<rt>ロジック</rt></ruby>を変更する必要がある場合は、将来のメンテナーが<ruby>譜面<rt>コード</rt></ruby>内で相談する場所が1つしかないため、すべての<ruby>誤り<rt>エラー</rt></ruby>処理<ruby>譜面<rt>コード</rt></ruby>が1か所にある場合に最適です。
すべての<ruby>誤り<rt>エラー</rt></ruby>処理<ruby>譜面<rt>コード</rt></ruby>を1か所にまとめることで、エンド利用者にとって意味のあるメッセージを確実に<ruby>印字<rt>プリント</rt></ruby>できるようになります。

企画をリファクタリングして、これらの4つの問題に取り組んでみましょう。

### <ruby>二進譜<rt>バイナリ</rt></ruby>企画の懸念の分離

複数の仕事の責任を`main`機能に割り当てるという組織の問題は、多くの<ruby>二進譜<rt>バイナリ</rt></ruby>企画に共通しています。
その結果、Rustコミュニティは、`main`が大きくなったときに<ruby>二進譜<rt>バイナリ</rt></ruby>算譜の別の懸案事​​項を分割するためのガイドラインとして使用する過程を開発しました。
過程には次のステップがあります。

* *main.rs*と*lib.rs*に<ruby>算譜<rt>プログラム</rt></ruby>を分割し*、lib.rs*に<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>を移動します。
* <ruby>命令行<rt>コマンドライン</rt></ruby>の解析<ruby>論理<rt>ロジック</rt></ruby>が小さい限り、
*main.rs。*
*<ruby>命令行<rt>コマンドライン</rt></ruby>の解析<ruby>論理<rt>ロジック</rt></ruby>が複雑になると、*main.rs*から抽出して*lib.rs*に移動し*ます*。

この過程後の`main`機能に残っている責任は、次のように限定されます。

* 引数値を使用して<ruby>命令行<rt>コマンドライン</rt></ruby>解析<ruby>論理<rt>ロジック</rt></ruby>を呼び出す
* 他の設定を設定する
* *lib.rsで* `run`機能を*呼び出す*
* `run`<ruby>誤り<rt>エラー</rt></ruby>を処理すると<ruby>誤り<rt>エラー</rt></ruby>`run`返される

このパターンは、懸念を分離についてです*。main.rs*<ruby>手綱<rt>ハンドル</rt></ruby>は、<ruby>算譜<rt>プログラム</rt></ruby>を実行している、と*lib.rsは*手元の作業のすべての<ruby>論理<rt>ロジック</rt></ruby>を処理します。
`main`機能を直接テストすることはできないので、この構造体を使用すると、*lib.rs*内の機能に<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>を移動することで、すべての<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>をテストできます。
*main.rsに*残っている唯一の<ruby>譜面<rt>コード</rt></ruby>は、*それ*を読み取って正当性を検証するのに十分小さいものです。
この過程を踏んで<ruby>算譜<rt>プログラム</rt></ruby>を修正しましょう。

#### 引数構文解析器ーの抽出

<ruby>命令行<rt>コマンドライン</rt></ruby>解析<ruby>論理<rt>ロジック</rt></ruby>を*src/lib.rsに*移動する準備をするために`main`が呼び出す機能に引数を解析する機能を抽出します。
リスト12-5は新しい機能`parse_config`を呼び出す新しい`main`開始を示しています。これについては*src/main.rsですぐに*定義します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let args: Vec<String> = env::args().collect();

    let (query, filename) = parse_config(&args);

#    // --snip--
    //  --snip--
}

fn parse_config(args: &[String]) -> (&str, &str) {
    let query = &args[1];
    let filename = &args[2];

    (query, filename)
}
```

<span class="caption">リスト12-5。抽出<code>parse_config</code>からの機能<code>main</code></span>

<ruby>命令行<rt>コマンドライン</rt></ruby>引数をベクトルに集めていますが、<ruby>添字<rt>インデックス</rt></ruby>1の引数値を変数`query`に、<ruby>添字<rt>インデックス</rt></ruby>2の引数値を`main`機能内の変数`filename`に代入するのではなく、ベクトル全体を`parse_config`機能。
次に、`parse_config`機能は、どの引数がどの変数に入り、その値を`main`戻すかを決定する<ruby>論理<rt>ロジック</rt></ruby>を保持します。
`main`は依然として`query`と`filename`変数が作成されてい`query`が、`main`はもはや<ruby>命令行<rt>コマンドライン</rt></ruby>の引数と変数がどのように対応しているかを決定する責任がありません。

このリワークは、小規模な<ruby>算譜<rt>プログラム</rt></ruby>では過度のように思えるかもしれませんが、少しずつ段階的にリファクタリングしています。
この変更を行った後、<ruby>算譜<rt>プログラム</rt></ruby>を再度実行して、引き数解析が引き続き機能することを確認します。
進行状況を頻繁に確認し、発生した問題の原因を特定するのに役立ちます。

#### 設定値のグループ化

`parse_config`機能をさらに改善するためにもう一度小さなステップを踏むことができます。
現時点では組を返していますが、すぐにその組を個々のパーツに分割し直します。
これは、おそらくまだ適切な抽象概念を持っていないという兆候です。

改善の余地があることを示す別の指標は、`parse_config`の`config`部分です。これは、返される2つの値が関連しており、両方が1つの構成値の一部であることを意味します。
現在のところ、2つの値を組にグループ化する以外の方法で、データの構造にこの意味を伝えていません。
2つの値を1つの構造体に入れ、各構造体<ruby>欄<rt>フィールド</rt></ruby>に意味のある名前を付けることができます。
そうすることで、この<ruby>譜面<rt>コード</rt></ruby>の将来のメンテナが、異なる値がどのように相互に関係し、その目的が理解できるようになります。

> > 注。複雑な型がより適切な*基本的な執着である*場合、基本型値を使用するというこの反パターンと呼ばれる人もいます。

`parse_config`リスト12-6に、`parse_config`機能の改善点を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
# use std::env;
# use std::fs::File;
#
fn main() {
    let args: Vec<String> = env::args().collect();

    let config = parse_config(&args);

    println!("Searching for {}", config.query);
    println!("In file {}", config.filename);

    let mut f = File::open(config.filename).expect("file not found");

#    // --snip--
    //  --snip--
}

struct Config {
    query: String,
    filename: String,
}

fn parse_config(args: &[String]) -> Config {
    let query = args[1].clone();
    let filename = args[2].clone();

    Config { query, filename }
}
```

<span class="caption">リスト12-6。 <code>parse_config</code>をリファクタリングして<code>Config</code>実例を返すstruct</span>

`Config`という名前のstructを追加し、`query`および`filename`という名前の<ruby>欄<rt>フィールド</rt></ruby>を追加しました。
`parse_config`の型注釈は、`Config`値を返すことを示します。
`parse_config`の本体では、`args`に`String`値を参照する`String`列スライスを返すため、ここでは所有された`String`値を含むように`Config`を定義します。
`args`内の変数`main`引数値の所有者であるとだけさせて頂いており`parse_config`場合、Rustの借入ルールに違反するだろうことを意味する、それを借用機能を`Config`内の値の所有権を取得しようとした`args`。

`String`データはさまざまな方法で管理することができますが、最も簡単ではあるが非効率的な方法は、値で`clone`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことです。
これにより、`Config`<ruby>実例<rt>インスタンス</rt></ruby>のデータの完全なコピーが作成されます。これは、<ruby>文字列<rt>ストリング</rt></ruby>データへの参照を格納するよりも時間と記憶がかかります。
しかし、データのクローン作成は、参照の存続期間を管理する必要がないため、<ruby>譜面<rt>コード</rt></ruby>を非常に簡単にします。
この状況では、シンプルさを得るために少しのパフォーマンスを放棄することは、価値のある<ruby>相殺取引<rt>トレードオフ</rt></ruby>です。

> ### `clone`使用の<ruby>相殺取引<rt>トレードオフ</rt></ruby>
> 
> > 多くの屋根裏者は、実行時コストのために所有権の問題を修正するために`clone`を使用することを避ける傾向があります。
> > 第13章では、このような状況でより効率的な方法を使用する方法を学習します。
> > しかし今のところ、これらのコピーを一度しか作成せず、ファイル名とクエリ<ruby>文字列<rt>ストリング</rt></ruby>が非常に小さいため、いくつかの<ruby>文字列<rt>ストリング</rt></ruby>をコピーして処理を続行することは大丈夫です。
> > 最初のパスで<ruby>譜面<rt>コード</rt></ruby>をハイパーオプティマイズしようとするよりも少し非効率な作業<ruby>算譜<rt>プログラム</rt></ruby>を用意する方が良いでしょう。
> > Rustの経験が豊富になると、最も効率的なソリューションから簡単に始めることができますが、今のところ`clone`を呼び出すことは完全に受け入れられます。

更新した`main`それはの<ruby>実例<rt>インスタンス</rt></ruby>置くよう`Config`によって返さ`parse_config`という名前の変数に`config`、そしてこれまでに個別に使用される<ruby>譜面<rt>コード</rt></ruby>更新`query`および`filename`、それは今の<ruby>欄<rt>フィールド</rt></ruby>を使用していますので、変数を`Config`代わりに構造体を。

今、<ruby>譜面<rt>コード</rt></ruby>がより明確にすることを伝える`query`と`filename`関連していると彼らの目的は、<ruby>算譜<rt>プログラム</rt></ruby>が動作する方法を設定することであること。
これらの値を使用する<ruby>譜面<rt>コード</rt></ruby>は、その目的のために名前が付けられた<ruby>欄<rt>フィールド</rt></ruby>の`config`<ruby>実例<rt>インスタンス</rt></ruby>でそれらの値を見つけることができます。

#### `Config`<ruby>構築子<rt>コンストラクター</rt></ruby>の作成

これまで、`main`から<ruby>命令行<rt>コマンドライン</rt></ruby>引数を解析する<ruby>論理<rt>ロジック</rt></ruby>を抽出し、`parse_config`機能に配置しました。
そうすることで、`query`と`filename`値が関連し、その関係が<ruby>譜面<rt>コード</rt></ruby>で伝えられるべきであることがわかりました。
次に、`query`と`filename`名の関連する目的に名前を付け、`parse_config`機能から値の名前を構造体<ruby>欄<rt>フィールド</rt></ruby>名として返すために、`Config`構造体を追加しました。

`parse_config`機能の目的は`Config`<ruby>実例<rt>インスタンス</rt></ruby>を作成することになったので、`parse_config`をそのまま機能から`Config`構造体に関連付けられた`new`という名前の機能に変更できます。
この変更を加えると、<ruby>譜面<rt>コード</rt></ruby>はより慣用的になります。
`String::new`呼び出すことで、`String`などの標準<ruby>譜集<rt>ライブラリー</rt></ruby>に型の<ruby>実例<rt>インスタンス</rt></ruby>を作成できます。
同様に、`parse_config`を`Config`に関連付けられた`new`機能に変更すると、`Config::new`呼び出すことによって`Config`<ruby>実例<rt>インスタンス</rt></ruby>を作成することができます。
<ruby>譜面<rt>コード</rt></ruby>リスト12-7は、変更が必要であることを示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
# use std::env;
#
fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::new(&args);

#    // --snip--
    //  --snip--
}

# struct Config {
#     query: String,
#     filename: String,
# }
#
#// --snip--
//  --snip--

impl Config {
    fn new(args: &[String]) -> Config {
        let query = args[1].clone();
        let filename = args[2].clone();

        Config { query, filename }
    }
}
```

<span class="caption">リスト12-7。 <code>parse_config</code>を<code>Config::new</code>変更する</span>

更新した`main`呼んでいたところ`parse_config`代わりに呼び出すように`Config::new`。
の名前変更した`parse_config`に`new`して以内にそれを移動`impl`関連付け<ruby>段落<rt>ブロック</rt></ruby>、`new`と機能`Config`。
この<ruby>譜面<rt>コード</rt></ruby>を再度<ruby>製譜<rt>コンパイル</rt></ruby>して、動作することを確認してください。

### <ruby>誤り<rt>エラー</rt></ruby>処理の修正

ここでは、<ruby>誤り<rt>エラー</rt></ruby>処理を修正する作業を行います。
`args`ベクトルの<ruby>添字<rt>インデックス</rt></ruby>1または<ruby>添字<rt>インデックス</rt></ruby>2の値にアクセスしようとすると、ベクトルに3つ未満の項目が含まれていると<ruby>算譜<rt>プログラム</rt></ruby>がパニックになることを思い出してください。
引数なしで<ruby>算譜<rt>プログラム</rt></ruby>を実行してみてください。
次のようになります。

```text
$ cargo run
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep`
thread 'main' panicked at 'index out of bounds: the len is 1
but the index is 1', src/main.rs:29:21
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

`index out of bounds: the len is 1 but the index is 1`の行`index out of bounds: the len is 1 but the index is 1`です。これは<ruby>演譜師<rt>プログラマー</rt></ruby>向けの<ruby>誤り<rt>エラー</rt></ruby>メッセージです。
エンド利用者が何が起こったのか、そして何をすべきかを理解するのに役立つものではありません。
今すぐ修正しましょう。

#### <ruby>誤り<rt>エラー</rt></ruby>メッセージの改善

リスト12-8では、`new`機能に、スライスが<ruby>添字<rt>インデックス</rt></ruby>1と2にアクセスする前に十分に長いことを確認するチェックを追加します。スライスの長さが十分でない場合、<ruby>算譜<rt>プログラム</rt></ruby>はパニックを起こし、より良い<ruby>誤り<rt>エラー</rt></ruby>メッセージを表示します。`index out of bounds`メッセージの`index out of bounds`

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
#// --snip--
//  --snip--
fn new(args: &[String]) -> Config {
    if args.len() < 3 {
        panic!("not enough arguments");
    }
#    // --snip--
    //  --snip--
```

<span class="caption">リスト12-8。引数の数のチェックを追加する</span>

この<ruby>譜面<rt>コード</rt></ruby>は、リスト9-9で書いた`Guess::new`機能に似ています。ここでは、`value`引数が有効な値の範囲外になったときに`panic!`を呼び出しました。
ここでは値の範囲を調べる代わりに、`args`の長さが少なくとも3であることを確認しています。残りの機能は、この条件が満たされていることを前提として動作します。
`args` 3つ以下の項目がある場合、この条件は真となり、すぐに<ruby>算譜<rt>プログラム</rt></ruby>を終了させるために`panic!`マクロを呼び出します。

これらの余分な数行の<ruby>譜面<rt>コード</rt></ruby>を`new`、引数を指定せずに<ruby>算譜<rt>プログラム</rt></ruby>を実行して、<ruby>誤り<rt>エラー</rt></ruby>の内容を確認してみましょう。

```text
$ cargo run
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/minigrep`
thread 'main' panicked at 'not enough arguments', src/main.rs:30:12
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

この出力は良いです。今合理的な<ruby>誤り<rt>エラー</rt></ruby>メッセージがあります。
しかし、利用者に与えたくない余分な情報も持っています。
おそらく、リスト9-9で使用した手法を使用するのは、ここでは最善の方法ではありません。`panic!`呼び出しは、第9章で説明したように、<ruby>演譜<rt>プログラミング</rt></ruby>の問題に適しています。代わりに、成功または<ruby>誤り<rt>エラー</rt></ruby>を示す`Result`を返す第9章で学んだ技術。

#### `panic!`を呼び出す代わりに`new` `Result`を返す`panic!`

代わりに、成功したケースで`Config`<ruby>実例<rt>インスタンス</rt></ruby>を含む`Result`値を返し、<ruby>誤り<rt>エラー</rt></ruby>の場合の問題を説明することができます。
`Config::new`が`main`と通信しているとき、`Result`型を使用して問題があることを伝えることができます。
その後、変更することができ`main`変換すること`Err`について周囲のテキストなしで利用者の皆様のために、より実用的な<ruby>誤り<rt>エラー</rt></ruby>に<ruby>場合値<rt>バリアント</rt></ruby>を`thread 'main'`と`RUST_BACKTRACE`呼び出しがする`panic!`の原因。

リスト12-9は、`Config::new`戻り値と`Result`を返すために必要な機能の本体に加えた変更を示しています。
これは`main`を更新するまで<ruby>製譜<rt>コンパイル</rt></ruby>されないことに注意してください。これについては次のリストで行います。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
impl Config {
    fn new(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 3 {
            return Err("not enough arguments");
        }

        let query = args[1].clone();
        let filename = args[2].clone();

        Ok(Config { query, filename })
    }
}
```

<span class="caption">リスト12-9。 <code>Config::new</code>からの<code>Result</code>を返す</span>

`new`機能は今返す`Result`して`Config`成功事例とAには、<ruby>実例<rt>インスタンス</rt></ruby>`&'static str`<ruby>誤り<rt>エラー</rt></ruby>ケースに。
第10章の "Static Lifetime"章から思い出してください。`&'static str`は現在の<ruby>誤り<rt>エラー</rt></ruby>メッセージ型である文字列<ruby>直書き<rt>リテラル</rt></ruby>の型です。

`new`機能の本体に2つの変更が加えられました。利用者が十分な引数を渡さないときに`panic!`を呼び出す代わりに、`Err`値を返し、`Config`戻り値を`Ok`包みました。
これらの変更により、機能は新しい型の署名に適合します。

`Config::new`から`Err`値を返すと、`main`機能は`new`機能から返された`Result`値を処理し、<ruby>誤り<rt>エラー</rt></ruby>の場合には過程をよりきれいに終了させることができます。

#### `Config::new`およびHandling<ruby>誤り<rt>エラー</rt></ruby>の呼び出し

<ruby>誤り<rt>エラー</rt></ruby>の場合を処理し、わかりやすいメッセージを出力するには、リスト12-10に示すように、`Config::new`が返す`Result`を処理するために`main`を更新する必要があります。
また、<ruby>命令行<rt>コマンドライン</rt></ruby>道具を終了して、`panic!`誤り<ruby>譜面<rt>コード</rt></ruby>である0以外の誤り<ruby>譜面<rt>コード</rt></ruby>を手にして、それを実装します。
ゼロ以外の終了ステータスは、<ruby>算譜<rt>プログラム</rt></ruby>を呼び出した過程に、<ruby>誤り<rt>エラー</rt></ruby>状態で<ruby>算譜<rt>プログラム</rt></ruby>が終了したことを通知するための規則です。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::process;

fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::new(&args).unwrap_or_else(|err| {
        println!("Problem parsing arguments: {}", err);
        process::exit(1);
    });

#    // --snip--
    //  --snip--
```

<span class="caption">リスト12-10。新しい<code>Config</code>作成に失敗した場合の誤り<ruby>譜面<rt>コード</rt></ruby>での終了</span>

このリストでは、これまでに扱っていなかった<ruby>操作法<rt>メソッド</rt></ruby>、`unwrap_or_else`を使用しました。これは、標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって`Result<T, E>`定義されています。
使用`unwrap_or_else`いくつかの独自の、非定義することができます`panic!`<ruby>誤り<rt>エラー</rt></ruby>処理を。
`Result`が`Ok`値の場合、この<ruby>操作法<rt>メソッド</rt></ruby>の動作は`unwrap`似ています。つまり、内部値`Ok`が折り返しを返します。
しかし、値が`Err`値の場合、この<ruby>操作法<rt>メソッド</rt></ruby>は*closure*の<ruby>譜面<rt>コード</rt></ruby>を呼び出します。これは、無名機能であり、`unwrap_or_else`への引数として`unwrap_or_else`ます。
第13章で<ruby>閉包<rt>クロージャー</rt></ruby>について詳しく説明します。今のところ、`unwrap_or_else`は`Err`内部値を渡すことがあります。この場合、リスト12-9で追加した`not enough arguments`が`not enough arguments`ている静的な<ruby>文字列<rt>ストリング</rt></ruby>です。垂直パイプの間に現れる引数`err`<ruby>閉包<rt>クロージャー</rt></ruby>に`err`ます。
<ruby>閉包<rt>クロージャー</rt></ruby>内の<ruby>譜面<rt>コード</rt></ruby>は、実行時に`err`値を使用できます。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>から`process`を<ruby>輸入<rt>インポート</rt></ruby>`process`ための新しい`use`行を追加しました。
<ruby>誤り<rt>エラー</rt></ruby>の場合に実行される<ruby>閉包<rt>クロージャー</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>は2行だけです。 `err`値を出力してから`process::exit`呼び出し`process::exit`。
`process::exit`機能はすぐに<ruby>算譜<rt>プログラム</rt></ruby>を停止し、終了<ruby>結果番号<rt>ステータスコード</rt></ruby>として渡された番号を返します。
これは、リスト12-8で使用した`panic!`ベースの処理に似ていますが、余分な出力をすべて得ることはできません。
試してみよう。

```text
$ cargo run
   Compiling minigrep v0.1.0 (file:///projects/minigrep)
    Finished dev [unoptimized + debuginfo] target(s) in 0.48 secs
     Running `target/debug/minigrep`
Problem parsing arguments: not enough arguments
```

すばらしいです！　
この出力は、利用者にとって非常に面白いです。

### `main`から<ruby>論理<rt>ロジック</rt></ruby>を抽出する

コンフィグレーション解析のリファクタリングが完了したので、<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>を見てみましょう。
「<ruby>二進譜<rt>バイナリ</rt></ruby>企画の懸念の分離」で述べたように、設定や処理<ruby>誤り<rt>エラー</rt></ruby>の設定に関係しない`main`機能内のすべての<ruby>論理<rt>ロジック</rt></ruby>を保持する機能`run`を抽出します。
作業が完了したら、`main`は簡潔になり、検査で簡単に確認できるようになり、他のすべての<ruby>論理<rt>ロジック</rt></ruby>のテストを書くことができます。

<ruby>譜面<rt>コード</rt></ruby>リスト12-11に、抽出された`run`機能を示します。
今のところ、機能の抽出を少しずつ進めています。
*src/main.rsに*機能を定義しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
#    // --snip--
    //  --snip--

    println!("Searching for {}", config.query);
    println!("In file {}", config.filename);

    run(config);
}

fn run(config: Config) {
    let mut f = File::open(config.filename).expect("file not found");

    let mut contents = String::new();
    f.read_to_string(&mut contents)
        .expect("something went wrong reading the file");

    println!("With text:\n{}", contents);
}

#// --snip--
//  --snip--
```

<span class="caption">リスト12-11。残りの算譜<ruby>論理<rt>ロジック</rt></ruby>を含む<code>run</code>機能の抽出</span>

`run`機能には、`main`からの残りの<ruby>論理<rt>ロジック</rt></ruby>がすべてファイルの読み込みから開始されるようになりました。
`run`機能は、`Config`<ruby>実例<rt>インスタンス</rt></ruby>を引数として取ります。

#### `run`機能からの<ruby>誤り<rt>エラー</rt></ruby>の返却

リスト12-9の`Config::new`に、残りの算譜<ruby>論理<rt>ロジック</rt></ruby>を`run`機能に分けて<ruby>誤り<rt>エラー</rt></ruby>処理を改善することができます。
`expect`を呼び出す`expect`によって<ruby>算譜<rt>プログラム</rt></ruby>がパニックに陥るのを防ぐ代わりに、何かがうまくいかないときに`run`機能は`Result<T, E>`を返します。
これにより、利用者フレンドリーな方法で<ruby>誤り<rt>エラー</rt></ruby>を処理する<ruby>論理<rt>ロジック</rt></ruby>を`main`<ruby>論理<rt>ロジック</rt></ruby>にさらに統合することができます。
<ruby>譜面<rt>コード</rt></ruby>リスト12-12は、署名と`run`本体に加えなければならない変更を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
use std::error::Error;

#// --snip--
//  --snip--

fn run(config: Config) -> Result<(), Box<Error>> {
    let mut f = File::open(config.filename)?;

    let mut contents = String::new();
    f.read_to_string(&mut contents)?;

    println!("With text:\n{}", contents);

    Ok(())
}
```

<span class="caption">リスト12-12。 <code>run</code>機能を返す<code>run</code>変更する<code>Result</code></span>

ここでは3つの大きな変更を加えました。
まず、`run`機能の戻り値の型を`Result<(), Box<Error>>`。
この機能は、以前にユニット型`()`返しました。そして、それを`Ok`ケースで返される値として保持します。

<ruby>誤り<rt>エラー</rt></ruby>の種類については、*<ruby>特性<rt>トレイト</rt></ruby>対象*を使用`Box<Error>`（と、持ってきた`std::error::Error`で<ruby>有効範囲<rt>スコープ</rt></ruby>に`use`先頭に声明）。
今のところ、`Box<Error>`は、機能が`Error`<ruby>特性<rt>トレイト</rt></ruby>を実装する型を返すことを意味していますが、戻り値がどのような型になるかを指定する必要はありません。
これにより、異なる<ruby>誤り<rt>エラー</rt></ruby>ケースで異なる型の<ruby>誤り<rt>エラー</rt></ruby>値を返す柔軟性が得られます。

第二に、そのために`expect`する呼び出しを削除しました`?`
第9章でお話したように、演算子は、<ruby>誤り<rt>エラー</rt></ruby>で`panic!`はなく、`?`
演算子は、現在の機能から<ruby>誤り<rt>エラー</rt></ruby>値を返し、呼び出し元が処理します。

第3に、`run`機能は成功のケースで`Ok`値を返すようになりました。
`run`機能の成功型を型注釈に`()`として宣言しました。つまり、ユニット型の値を`Ok`値に包む必要があります。
この`Ok(())`構文は最初はちょっと変わって見えるかもしれませんが、このように`()`を使うと、副作用だけを`run`と呼ぶことを示す慣用的な方法です。
必要な値を返しません。

この<ruby>譜面<rt>コード</rt></ruby>を実行すると<ruby>製譜<rt>コンパイル</rt></ruby>されますが、警告が表示されます。

```text
warning: unused `std::result::Result` which must be used
  --> src/main.rs:18:5
   |
18 |     run(config);
   |     ^^^^^^^^^^^^
= note: #[warn(unused_must_use)] on by default
```

Rustは、<ruby>譜面<rt>コード</rt></ruby>が無視されていることを教えてくれる`Result`値をと`Result`値は、<ruby>誤り<rt>エラー</rt></ruby>が発生したことを示している可能性があります。
しかし、<ruby>誤り<rt>エラー</rt></ruby>があったかどうかを確認するのではなく、<ruby>製譜器<rt>コンパイラー</rt></ruby>はおそらくここで<ruby>誤り<rt>エラー</rt></ruby>処理<ruby>譜面<rt>コード</rt></ruby>をいくつか持っていることを思い出させます。
今問題を解決しよう。

#### `main` `run`れたときに返される<ruby>誤り<rt>エラー</rt></ruby>の処理

<ruby>譜面<rt>コード</rt></ruby>リスト12-10の`Config::new`で使用したのと似た技法を使用して<ruby>誤り<rt>エラー</rt></ruby>をチェックして処理しますが、わずかな違いがあります。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
#    // --snip--
    //  --snip--

    println!("Searching for {}", config.query);
    println!("In file {}", config.filename);

    if let Err(e) = run(config) {
        println!("Application error: {}", e);

        process::exit(1);
    }
}
```

`unwrap_or_else`ではなく`if let`を使用して`if let` `run`が`Err`値を返すかどうかをチェックし、`unwrap_or_else` `if let` `process::exit(1)`を呼び出し`process::exit(1)`。
`run`機能は、`Config::new`が`Config`<ruby>実例<rt>インスタンス</rt></ruby>を返すのと同じ方法で、`unwrap`したい値を返しません。
ので`run`リターン`()`成功の場合は、唯一の<ruby>誤り<rt>エラー</rt></ruby>を検出する気に、必要ありません`unwrap_or_else`それだけになるので開封された値を返すために`()`

`if let`と`unwrap_or_else`機能の本体は、どちらの場合も同じです。<ruby>誤り<rt>エラー</rt></ruby>を出力して終了します。

### <ruby>譜面<rt>コード</rt></ruby>を譜集<ruby>通い箱<rt>クレート</rt></ruby>に分割する

`minigrep`企画は今のところよく見ています！　
今、*、SRC/main.rsファイル*を分割し、それをテストし*、SRC/main.rsが*少ない責任を持つファイル持つことができるように、ファイル*のsrc/lib.rs*にいくつかの<ruby>譜面<rt>コード</rt></ruby>を配置します。

のではないすべての<ruby>譜面<rt>コード</rt></ruby>を移動してみましょう`main` *のsrc/lib.rs*へ*のsrc/main.rs*から機能を。

* `run`機能定義
* 関連する`use`声明
* `Config`の定義
* `Config::new`機能定義

*src/lib.rs*の内容は、リスト12-13に示す型注釈を持つ必要があります（簡略化のために機能の本体は省略しています）。
これはリスト12-14の*src/main.rs*を変更するまで<ruby>製譜<rt>コンパイル</rt></ruby>されないことに注意してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;

pub struct Config {
    pub query: String,
    pub filename: String,
}

impl Config {
    pub fn new(args: &[String]) -> Result<Config, &'static str> {
#        // --snip--
        //  --snip--
    }
}

pub fn run(config: Config) -> Result<(), Box<Error>> {
#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト12-13。 <code>Config</code>を移動して<em>src/lib.rsに</em> <code>run</code>する</span>

`Config`、その<ruby>欄<rt>フィールド</rt></ruby>とその`new`<ruby>操作法<rt>メソッド</rt></ruby>、および`run`機能について`pub`予約語を自由に使用しました。
現在、テストできる<ruby>公開<rt>パブリック</rt></ruby>APIを持った譜集<ruby>通い箱<rt>クレート</rt></ruby>を持っています！　

リスト12-14に示すように、*src/main.rs*内の<ruby>二進譜<rt>バイナリ</rt></ruby>*・キュー*の<ruby>有効範囲<rt>スコープ</rt></ruby>に*src/lib.rs*に移動した<ruby>譜面<rt>コード</rt></ruby>を持たせる必要があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate minigrep;

use std::env;
use std::process;

use minigrep::Config;

fn main() {
#    // --snip--
    //  --snip--
    if let Err(e) = minigrep::run(config) {
#        // --snip--
        //  --snip--
    }
}
```

<span class="caption">リスト12-14。 <code>minigrep</code>を<em>src/main.rsの</em>有効範囲に<em>持ち込む</em></span>

譜集<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱に持ち込むために、`extern crate minigrep`を使用します。
次に、`use minigrep::Config`行を`use minigrep::Config`て`Config`型を<ruby>有効範囲<rt>スコープ</rt></ruby>に追加し、`run`機能の頭に名前を付けます。
今、すべての機能が接続され、動作するはずです。
で<ruby>算譜<rt>プログラム</rt></ruby>を実行し`cargo run`し、すべてが正常に動作することを確認してください。

すごい！　
それはたくさんの仕事でしたが、将来の成功のために自分を決めました。
今度は<ruby>誤り<rt>エラー</rt></ruby>を処理する方がはるかに簡単で、<ruby>譜面<rt>コード</rt></ruby>を<ruby>役区<rt>モジュール</rt></ruby>化しました。
ほとんどの作業はここから*src/lib.rs*で行われます。

古い<ruby>譜面<rt>コード</rt></ruby>では難しかったが、新しい<ruby>譜面<rt>コード</rt></ruby>では簡単なことを行うことで、この新しい<ruby>役区<rt>モジュール</rt></ruby>性を利用しよう。いくつかのテストを書くだろう！　
