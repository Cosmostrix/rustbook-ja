## `panic!`か、`panic!`

だから`panic!`を呼び出すべき時と、`Result`を返すべき時を決める方法は？　
<ruby>譜面<rt>コード</rt></ruby>がパニックすると、回復する方法はありません。
復旧の可能性があるかどうかに関わらず、<ruby>誤り<rt>エラー</rt></ruby>状況については`panic!`呼び出すことができますが、状況を回復できない<ruby>譜面<rt>コード</rt></ruby>を呼び出す<ruby>譜面<rt>コード</rt></ruby>に代わって決定を下しています。
`Result`値を返すことを選択した場合、呼び出し<ruby>譜面<rt>コード</rt></ruby>オプションの決定を行うのではなく、その譜面<ruby>選択肢<rt>オプション</rt></ruby>を指定します。
呼び出し元の<ruby>譜面<rt>コード</rt></ruby>は、その状況に応じて適切だ方法で回復しようとすることを選択することができ、またはそれはそれを決めることができました`Err`それが呼び出すことができるように、この場合の値は、回復不能な`panic!`し、回復不能一つに、回復可能な<ruby>誤り<rt>エラー</rt></ruby>をオンにします。
したがって、失敗する可能性のある機能を定義するときは、`Result`返すのが適切な<ruby>黙用<rt>デフォルト</rt></ruby>の選択です。

まれな状況では、`Result`を返す代わりにパニックする<ruby>譜面<rt>コード</rt></ruby>を記述する方が適切です。
サンプル、プロト型<ruby>譜面<rt>コード</rt></ruby>、テストでなぜパニックになるのが適切かを調べてみましょう。
そして、<ruby>製譜器<rt>コンパイラー</rt></ruby>が失敗は不可能だが、人間として考えることができない状況について話し合う。
この章では、<ruby>譜集<rt>ライブラリー</rt></ruby>譜面をパニックするかどうかを決定する方法に関する一般的なガイドラインを示します。

### 例、プロト型<ruby>譜面<rt>コード</rt></ruby>、およびテスト

いくつかの概念を説明するための例を書くときには、この例でも堅牢な<ruby>誤り<rt>エラー</rt></ruby>処理<ruby>譜面<rt>コード</rt></ruby>を使用することで、この例をあまり明確にすることはできません。
例では、`unwrap`ようなパニックに陥る可能性のある<ruby>操作法<rt>メソッド</rt></ruby>への呼び出しは、<ruby>譜体<rt>アプリケーション</rt></ruby>で<ruby>誤り<rt>エラー</rt></ruby>を処理する方法の<ruby>場所取り<rt>プレースホルダ</rt></ruby>ーとして意味され、<ruby>譜面<rt>コード</rt></ruby>の残りの部分に基づいて異なる場合があることが理解されます。

同様に、`unwrap`と`expect`<ruby>操作法<rt>メソッド</rt></ruby>はプロト型作成時に非常に便利です。<ruby>誤り<rt>エラー</rt></ruby>を処理する方法を決める準備が整う前に、
<ruby>算譜<rt>プログラム</rt></ruby>をより堅牢にする準備ができたら、<ruby>譜面<rt>コード</rt></ruby>に明瞭なマーカーが残っています。

テストで<ruby>操作法<rt>メソッド</rt></ruby>呼び出しが失敗した場合、たとえその<ruby>操作法<rt>メソッド</rt></ruby>がテスト中の機能ではなくても、テスト全体が失敗することが望まれます。
`panic!`とは、テストが失敗としてマークされる方法であるため、`unwrap`や`expect`呼び出す`expect`はまさに何が起こるべきかです。

### <ruby>製譜器<rt>コンパイラー</rt></ruby>より多くの情報を持っている場合

また、`Result`に`Ok`値があることを保証する他の<ruby>論理<rt>ロジック</rt></ruby>があるときに`unwrap`を呼び出すのが適切ですが、<ruby>論理<rt>ロジック</rt></ruby>は<ruby>製譜器<rt>コンパイラー</rt></ruby>が理解できるものではありません。
まだ処理しなければならない`Result`値を持っています。あなたの特定の状況では<ruby>論理<rt>ロジック</rt></ruby>的に不可能であるにもかかわらず、呼び出している操作はどれも、一般的には失敗する可能性があります。
`Err`<ruby>場合値<rt>バリアント</rt></ruby>を使用しない<ruby>譜面<rt>コード</rt></ruby>を手動で検査することで確実にできれば、`unwrap`を呼び出すことは完全に受け入れられます。
ここに例があります。

```rust
use std::net::IpAddr;

let home: IpAddr = "127.0.0.1".parse().unwrap();
```

ハード<ruby>譜面<rt>コード</rt></ruby>された<ruby>文字列<rt>ストリング</rt></ruby>を解析することによって`IpAddr`<ruby>実例<rt>インスタンス</rt></ruby>を作成して`IpAddr`ます。
`127.0.0.1`が有効なIP番地であることがわかります。ここで`unwrap`を使用しても問題あり`unwrap`。
ただし、ハード<ruby>譜面<rt>コード</rt></ruby>された有効な<ruby>文字列<rt>ストリング</rt></ruby>を使用しても、`parse`<ruby>操作法<rt>メソッド</rt></ruby>の戻り値の型は変更されません`Result`値が返されますが、<ruby>製譜器<rt>コンパイラー</rt></ruby>は`Err`<ruby>場合値<rt>バリアント</rt></ruby>が可能であるかのように`Result`を処理します。この<ruby>文字列<rt>ストリング</rt></ruby>が常に有効なIP番地であることが分かります。
IP番地の<ruby>文字列<rt>ストリング</rt></ruby>は、利用者から来たのではなく<ruby>算譜<rt>プログラム</rt></ruby>にハード<ruby>譜面<rt>コード</rt></ruby>されているため、故障の可能性を持って*いた*場合、間違いなく処理したいと思います`Result`代わりに、より堅牢な方法で。

### <ruby>誤り<rt>エラー</rt></ruby>処理のガイドライン

<ruby>譜面<rt>コード</rt></ruby>が悪い状態になる可能性がある場合は、<ruby>譜面<rt>コード</rt></ruby>パニックを起こすことをお勧めします。
この文脈では、無効な値、矛盾する値、欠損値が<ruby>譜面<rt>コード</rt></ruby>に渡されたり、次のうちの1つ以上が発生した場合など、いくつかの前提条件、保証、契約、または不変条件が破られた*状態*が*悪い状態*です。

* 悪い状態は時々起こると*思われる*ものではありません。
* この時点以降の<ruby>譜面<rt>コード</rt></ruby>は、この悪い状態にないことに依存する必要があります。
* この情報を使用する型で符号化する良い方法はありません。

誰かが<ruby>譜面<rt>コード</rt></ruby>を呼び出し、意味をなさない値を渡した場合、最良の選択は`panic!`を呼び出して、開発中に修正できるように、<ruby>譜面<rt>コード</rt></ruby>内のバグに<ruby>譜集<rt>ライブラリー</rt></ruby>を使用している人に警告することです。
同様に、制御から外れている外部<ruby>譜面<rt>コード</rt></ruby>を呼び出していて、修正する方法がない無効な状態を返す場合、`panic!`はしばしば適切です。

悪い状態になっても、<ruby>譜面<rt>コード</rt></ruby>を書いても問題は起こりませんが、`panic!`通話をするのではなく、`Result`を返す方が適切`panic!`。
例としては、不正なデータが与えられた構文解析器ーや、レート制限を超えたことを示すステータスを返すHTTPリクエストなどがあります。
このような場合、`Result`を返してこれらの不良状態を上方に伝播させ、呼び出し<ruby>譜面<rt>コード</rt></ruby>が問題の処理方法を決定できるようにすることで、失敗が予想される可能性があることを示す必要があります。
`panic!`を呼び出すことは、これらのケースを処理する最良の方法ではありません。

<ruby>譜面<rt>コード</rt></ruby>が値に対して操作を実行するとき、<ruby>譜面<rt>コード</rt></ruby>は値が有効であることを確認し、値が有効でない場合はパニックにする必要があります。
これは主に安全上の理由によるものです。無効なデータを操作しようとすると、<ruby>譜面<rt>コード</rt></ruby>が脆弱性にさらされる可能性があります。
これは、標準<ruby>譜集<rt>ライブラリー</rt></ruby>が縛り外の記憶アクセスを試みた場合に`panic!`を呼び出す主な理由です。現在のデータ構造に属していない記憶にアクセスしようとするのはセキュリティ上の一般的な問題です。
機能はしばしば*契約を結ぶ*。入力が特定の要件を満たしていれば、その動作は保証されます。
契約違反は常に呼び出し側のバグを示し、呼び出し<ruby>譜面<rt>コード</rt></ruby>で明示的に処理しなければならない種類の<ruby>誤り<rt>エラー</rt></ruby>ではないため、契約違反時にパニックが発生します。
実際、<ruby>譜面<rt>コード</rt></ruby>を呼び出すための合理的な方法はありません。
呼び出す*<ruby>演譜師<rt>プログラマー</rt></ruby>*は<ruby>譜面<rt>コード</rt></ruby>を修正する必要があります。
機能の契約、特に違反がパニックの原因となる場合は、機能のAPI開発資料で説明する必要があります。

しかし、すべての機能で多くの<ruby>誤り<rt>エラー</rt></ruby>チェックを行うと、冗長で迷惑になります。
幸いなことに、Rustの型体系（したがって<ruby>製譜器<rt>コンパイラー</rt></ruby>が行う型チェック）を使用して、多くのチェックを行うことができます。
機能にパラメータとして特定の型がある場合は、<ruby>製譜器<rt>コンパイラー</rt></ruby>が有効な値を持つことを既に確認していることを確認して、<ruby>譜面<rt>コード</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>を進めることができます。
たとえば、`Option`ではなくTypeを持つ場合、<ruby>算譜<rt>プログラム</rt></ruby>は*何も*持たずに*何か*を持つ*ことを*想定しています。
<ruby>譜面<rt>コード</rt></ruby>では、`Some`と`None` 2つのケースを処理する必要はありません。値を確実に持つケースは1つだけです。
機能に何も渡そうとしない<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されないので、実行時にその機能をチェックする必要はありません。
別の例では、パラメータが負でないことを保証する`u32`などの符号なし整数型を使用しています。

### 検証のための独自の型の作成

Rustの型体系を使用して、有効な値をさらに確実に取得し、検証用の独自の型を作成する方法を考えてみましょう。
第2章の推測ゲームを思い出してください。この<ruby>譜面<rt>コード</rt></ruby>では、1から100までの数字を推測するように利用者に求めました。その数字の間に利用者の推測があることを確認してから、
推測が肯定的であることを確認しました。
この場合、その結果は非常に悲惨ではありませんでした。「高すぎる」または「低すぎる」という結果は依然として正しいでしょう。
しかし、利用者が正当な推測に向かうのに役立ち、利用者が範囲外の数字を推測したときと、利用者がたとえば文字を入力したときとでは異なる動作をするのは便利です。

これを行う1つの方法は、負の数を可能にする`u32`代わりに`i32`ような推測を解析し、範囲内にある数のチェックを追加することです。

```rust,ignore
loop {
#    // --snip--
    //  --snip--

    let guess: i32 = match guess.trim().parse() {
        Ok(num) => num,
        Err(_) => continue,
    };

    if guess < 1 || guess > 100 {
        println!("The secret number will be between 1 and 100.");
        continue;
    }

    match guess.cmp(&secret_number) {
#    // --snip--
    //  --snip--
}
```

`if`式は、値が範囲外であるかどうかをチェックし、問題について利用者に通知し、呼び出し`continue`ループの次の反復を開始し`continue`、別の推測を要求します。
`if`式の後に、`guess`が1と100の間であることを知って、`guess`と秘密の数の比較を続行できます。

しかし、これは理想的な解決策ではありません。<ruby>算譜<rt>プログラム</rt></ruby>が1〜100の値でしか動作しないことが絶対に重要で、この要件を持つ多くの機能を持っていれば、このようなチェックをすべての機能に持たせることは面倒ですパフォーマンス）。

その代わりに、新しい型を作成し、検証をどこにでも繰り返すのではなく、型の<ruby>実例<rt>インスタンス</rt></ruby>を作成する機能に入れることができます。
そうすれば、機能が新しい型を型注釈に使用し、受け取った値を確実に使用することは安全です。
リスト9-9は、`new`機能が1から100の間の値を受け取った場合にのみ`Guess`<ruby>実例<rt>インスタンス</rt></ruby>を作成する`Guess`型を定義する1つの方法を示しています。

```rust
pub struct Guess {
    value: u32,
}

impl Guess {
    pub fn new(value: u32) -> Guess {
        if value < 1 || value > 100 {
            panic!("Guess value must be between 1 and 100, got {}.", value);
        }

        Guess {
            value
        }
    }

    pub fn value(&self) -> u32 {
        self.value
    }
}
```

<span class="caption">リスト9-9。1と100の間の値だけを続ける<code>Guess</code>型</span>

まず、`u32`を保持する`value`という名前の<ruby>欄<rt>フィールド</rt></ruby>を持つ`Guess`という名前のstructを定義します。
これが番号が格納される場所です。

次に`Guess` `new`という名前の関連する機能を実装し、`Guess`値の<ruby>実例<rt>インスタンス</rt></ruby>を作成します。
`new`機能は、`u32`型の`value`という名前の1つのパラメータを持ち、`Guess` `value`を返すように定義されています。
`new`機能の本体にある<ruby>譜面<rt>コード</rt></ruby>は、`value`が1から100の間であることをテストし`value`。 `value`がこのテストに合格しない場合は、`panic!`呼び出しを行い、<ruby>演譜師<rt>プログラマー</rt></ruby>が呼び出した<ruby>譜面<rt>コード</rt></ruby>を記述していることを警告しますこの範囲外の`value`で`Guess`を作成すると、`Guess::new`が依存している契約に違反するため、修正する必要があるバグです。
`Guess::new`がパニックに陥る可能性のある条件は、<ruby>公開<rt>パブリック</rt></ruby>されているAPI開発資料で議論されるべきです。
可能性を示す文書の規則取り上げる`panic!`場合は、第14章で作成するAPI開発資料の`value`試験に合格しないと、新しい作成`Guess`その持つ`value`に設定し、<ruby>欄<rt>フィールド</rt></ruby>`value`パラメータをと返し`Guess`。

次に、`self`を借用、他のパラメータを持たず、`u32`を返す`value`という名前の<ruby>操作法<rt>メソッド</rt></ruby>を実装します。
この種の<ruby>操作法<rt>メソッド</rt></ruby>は、*getter*と呼ばれることもあります。その目的は、<ruby>欄<rt>フィールド</rt></ruby>からデータを取得して返すことです。
`Guess`構造体の`value`<ruby>欄<rt>フィールド</rt></ruby>はprivateであるため、この公開<ruby>操作法<rt>メソッド</rt></ruby>は必要です。
それはすることが重要です`value`<ruby>欄<rt>フィールド</rt></ruby>は<ruby>内部用<rt>プライベート</rt></ruby>でそう使用して<ruby>譜面<rt>コード</rt></ruby>`Guess`構造体を設定することが許可されていない`value`直接。<ruby>役区<rt>モジュール</rt></ruby>外の<ruby>譜面<rt>コード</rt></ruby>が使用*する必要があります* `Guess::new`<ruby>実例<rt>インスタンス</rt></ruby>を作成する機能を`Guess`、それによってための方法はありません確実に、 `Guess`には、`Guess::new`機能の条件でチェックされていない`value`があります。

パラメータを持つ機能、または1から100の間の数値しか返さない機能は、`u32`ではなく、`Guess` `u32`か返すという型注釈を宣言し、その本体で追加のチェックを行う必要はありません。

## 概要

Rustの<ruby>誤り<rt>エラー</rt></ruby>処理機能は、より堅牢な<ruby>譜面<rt>コード</rt></ruby>を書くのに役立つように設計されています。
`panic!`マクロは、<ruby>算譜<rt>プログラム</rt></ruby>が処理できない状態にあることを知らせ、無効または間違った値で処理するのではなく過程を停止するように指示します。
`Result` enumは、Rustの型体系を使用して、<ruby>譜面<rt>コード</rt></ruby>が回復する方法で操作が失敗する可能性があることを示します。
`Result`を使用して<ruby>譜面<rt>コード</rt></ruby>を呼び出す<ruby>譜面<rt>コード</rt></ruby>に、潜在的な成功または失敗を処理する必要があることを伝えることができます。
使用して`panic!`と`Result`適切な状況では、避けられない問題に直面して<ruby>譜面<rt>コード</rt></ruby>はより信頼性の高いようになります。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>が`Option`と`Result`列挙型で総称化を使用する便利な方法を見てきたので、総称化の仕組みと<ruby>譜面<rt>コード</rt></ruby>での使用方法について説明します。