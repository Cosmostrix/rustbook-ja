## <ruby>閉包<rt>クロージャー</rt></ruby>。環境を<ruby>捕捉<rt>キャッチ</rt></ruby>できる無名機能

Rustの<ruby>閉包<rt>クロージャー</rt></ruby>は、変数に保存するか、他の機能に引数として渡すことができる無名機能です。
1つの場所に<ruby>閉包<rt>クロージャー</rt></ruby>を作成してから別の文脈で<ruby>閉包<rt>クロージャー</rt></ruby>を評価することができます。
機能とは異なり、<ruby>閉包<rt>クロージャー</rt></ruby>は呼び出された<ruby>有効範囲<rt>スコープ</rt></ruby>から値を取得できます。
これらの<ruby>閉包<rt>クロージャー</rt></ruby>機能が<ruby>譜面<rt>コード</rt></ruby>の再利用と動作のカスタマイズを可能にする方法を示します。

### <ruby>閉包<rt>クロージャー</rt></ruby>を使用した動作の抽象化の作成

後で実行される<ruby>閉包<rt>クロージャー</rt></ruby>を保存すると便利な状況の例を取り上げてみましょう。
途中で、<ruby>閉包<rt>クロージャー</rt></ruby>、型推論、および<ruby>特性<rt>トレイト</rt></ruby>の構文について説明します。

この仮説的な状況を考えてみましょう。スタートアップ時に、独自の運動トレーニング計画を作成するアプリを作っています。
バックエンドはRustで書かれており、トレーニングプランを生成する<ruby>計算手続き<rt>アルゴリズム</rt></ruby>は、アプリ利用者の年齢、体格指数、運動の好み、最近のトレーニング、彼らが指定した強度番号など、多くの要因を考慮しています。
使用される実際の<ruby>計算手続き<rt>アルゴリズム</rt></ruby>は、この例では重要ではありません。
重要なのは、この計算に数秒かかるということです。
この<ruby>計算手続き<rt>アルゴリズム</rt></ruby>を呼び出す必要があるときにのみ呼び出し、一度呼び出すだけで、利用者が必要以上に待たされることはありません。

リスト13-1に示す機能`simulated_expensive_calculation`使って、この仮説的な<ruby>計算手続き<rt>アルゴリズム</rt></ruby>を呼び出すことをシミュレートします。これは、`calculating slowly...` 2秒間待ってから渡した数を返します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::thread;
use std::time::Duration;

fn simulated_expensive_calculation(intensity: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    intensity
}
```

<span class="caption">譜面リスト13-1。実行に約2秒かかっている仮説計算を待つ機能</span>

次に、`main`機能は、この例で重要なトレーニングアプリの部分を含んでいます。
この機能は、利用者がワークアウトプランを要求したときに<ruby>譜体<rt>アプリケーション</rt></ruby>が呼び出す<ruby>譜面<rt>コード</rt></ruby>を表します。
<ruby>譜体<rt>アプリケーション</rt></ruby>のフロントエンドとのやりとりは<ruby>閉包<rt>クロージャー</rt></ruby>の使用に関係しないので、<ruby>算譜<rt>プログラム</rt></ruby>への入力を表す値をハード<ruby>譜面<rt>コード</rt></ruby>し、出力を出力します。

必要な入力は次のとおりです。

* 利用者からの強度番号。低強度のトレーニングや高強度のトレーニングを希望するかどうかを示すためにトレーニングをリクエストしたときに指定されます。
* 運動計画に多種多様な乱数を生成する

出力は、推奨されるワークアウト計画になります。
<ruby>譜面<rt>コード</rt></ruby>リスト13-2は、使用する`main`機能を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let simulated_user_specified_value = 10;
    let simulated_random_number = 7;

    generate_workout(
        simulated_user_specified_value,
        simulated_random_number
    );
}
# fn generate_workout(intensity: u32, random_number: u32) {}
```

<span class="caption">リスト13-2。利用者入力と乱数生成をシミュレートするハード<ruby>譜面<rt>コード</rt></ruby>された値を持つ<code>main</code>機能</span>

わかりやすくするために、変数`simulated_user_specified_value`を10、変数`simulated_random_number`を7にハード作譜しました。
実際の<ruby>算譜<rt>プログラム</rt></ruby>では、アプリのフロントエンドからの強度番号を取得したい、と使用したい`rand`第2章で推測ゲームの例で行ったように、乱数を生成するための<ruby>通い箱<rt>クレート</rt></ruby>を`main`機能呼び出し`generate_workout`機能をシミュレートされた入力値と比較します。

文脈があるので、<ruby>計算手続き<rt>アルゴリズム</rt></ruby>に着きましょう。
リスト13-3の機能`generate_workout`には、この例で最も関心のある<ruby>譜体<rt>アプリケーション</rt></ruby>のビジネス<ruby>論理<rt>ロジック</rt></ruby>が含まれています。
この例の<ruby>譜面<rt>コード</rt></ruby>変更の残りの部分がこの機能に適用されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
# fn simulated_expensive_calculation(num: u32) -> u32 {
#     println!("calculating slowly...");
#     thread::sleep(Duration::from_secs(2));
#     num
# }
#
fn generate_workout(intensity: u32, random_number: u32) {
    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            simulated_expensive_calculation(intensity)
        );
        println!(
            "Next, do {} situps!",
            simulated_expensive_calculation(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                simulated_expensive_calculation(intensity)
            );
        }
    }
}
```

<span class="caption">リスト13-3。 <code>simulated_expensive_calculation</code>機能への入力と呼び出しに基づいてワークアウトプランを出力するビジネス論理</span>

<ruby>譜面<rt>コード</rt></ruby>リスト13-3の<ruby>譜面<rt>コード</rt></ruby>では、低速<ruby>計算機<rt>コンピューター</rt></ruby>能が複数呼び出されています。
最初の`if`<ruby>段落<rt>ブロック</rt></ruby>の呼び出しは`simulated_expensive_calculation`二回、`if`外側内側の`else`全くそれを呼び出すことはありません、第二の内部<ruby>譜面<rt>コード</rt></ruby>`else`場合は、一度それを呼び出します。


`generate_workout`機能の望ましい挙動は、利用者が低強度トレーニング（25未満の数字で示される）または高強度トレーニング（25以上の数）を望むかどうかを最初に確認することであます。

低強度トレーニング計画では、シミュレーションしている複雑な<ruby>計算手続き<rt>アルゴリズム</rt></ruby>に基づいて、いくつかのプッシュアップと腹筋を推奨します。

利用者が高輝度のトレーニングをしたい場合は、追加の<ruby>論理<rt>ロジック</rt></ruby>があります。アプリによって生成された乱数の値が3になると、アプリは休憩と水分をおすすめします。
そうでない場合、利用者は複雑な<ruby>計算手続き<rt>アルゴリズム</rt></ruby>に基づいて実行するまでに数分かかるでしょう。

この<ruby>譜面<rt>コード</rt></ruby>は今のところビジネスが望んでいるように機能しますが、データ科学チームは、将来`simulated_expensive_calculation`機能を呼び出す方法をいくつか変更する必要があると判断したとしましょう。
これらの変更が発生したときに更新を簡素化するため、この<ruby>譜面<rt>コード</rt></ruby>をリファクタリングして、`simulated_expensive_calculation`機能を1回だけ呼び出すようにします。
また、現在、不必要に機能を2回呼び出す場所を、その機能の他の呼び出しを過程に追加することなく切り詰める必要があります。
つまり、結果が必要でない場合は呼びたくないのですが、それを一度だけ呼びたいと思っています。

#### 機能を使用したリファクタリング

様々な方法でワークアウト<ruby>算譜<rt>プログラム</rt></ruby>を再構成することができました。
まず、`simulated_expensive_calculation`機能の重複呼び出しを変数に抽出してみましょう（リスト13-4を参照）。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
# fn simulated_expensive_calculation(num: u32) -> u32 {
#     println!("calculating slowly...");
#     thread::sleep(Duration::from_secs(2));
#     num
# }
#
fn generate_workout(intensity: u32, random_number: u32) {
    let expensive_result =
        simulated_expensive_calculation(intensity);

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_result
        );
        println!(
            "Next, do {} situps!",
            expensive_result
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_result
            );
        }
    }
}
```

<span class="caption">譜面リスト13-4。 <code>simulated_expensive_calculation</code>への呼び出しを1つの場所に抽出し、その結果を<code>expensive_result</code>変数に格納する</span>

この変更により、`simulated_expensive_calculation`へのすべての呼び出しが統一され、最初の`if`<ruby>段落<rt>ブロック</rt></ruby>が不必要に機能を2回呼び出すという問題が解決されます。
残念ながら、この機能を呼び出して、結果値をまったく使用しない内部の`if`<ruby>段落<rt>ブロック</rt></ruby>を含むすべての場合の結果を待っています。

<ruby>算譜<rt>プログラム</rt></ruby>内のある場所に<ruby>譜面<rt>コード</rt></ruby>を定義したいが、実際に結果が必要な場所で<ruby>譜面<rt>コード</rt></ruby>を*実行する*だけです。
これは<ruby>閉包<rt>クロージャー</rt></ruby>の使用例です！　

#### <ruby>譜面<rt>コード</rt></ruby>を格納するための<ruby>閉包<rt>クロージャー</rt></ruby>によるリファクタリング

代わりに、常に呼び出しの`simulated_expensive_calculation`前に機能を`if`<ruby>段落<rt>ブロック</rt></ruby>、<ruby>閉包<rt>クロージャー</rt></ruby>を定義し、むしろリスト13-5に示すように、機能呼び出しの結果を格納するよりも、変数に*<ruby>閉包<rt>クロージャー</rt></ruby>を*保存することができます。
実際には、ここで導入しているclosure内で`simulated_expensive_calculation`の全身を動かすことができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
let expensive_closure = |num| {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    num
};
# expensive_closure(5);
```

<span class="caption">リスト13-5。closureを定義してこれを<code>expensive_closure</code>変数に格納する</span>

<ruby>閉包<rt>クロージャー</rt></ruby>の定義は、`=`後に来て、それを変数`expensive_closure`に代入します。
<ruby>閉包<rt>クロージャー</rt></ruby>を定義するには、<ruby>閉包<rt>クロージャー</rt></ruby>のパラメータを指定する一対の垂直パイプ（`|`）から始めます。
この構文は、SmalltalkとRubyにおける<ruby>閉包<rt>クロージャー</rt></ruby>定義との類似性のために選択されました。
この<ruby>閉包<rt>クロージャー</rt></ruby>には`num`という名前のパラメーターが1つあります。複数のパラメーターがある場合は、`|param1, param2|`ようにカンマで区切ります`|param1, param2|`
。

パラメータの後ろに、<ruby>閉包<rt>クロージャー</rt></ruby>の本体を保持する中かっこを配置します。これらは、<ruby>閉包<rt>クロージャー</rt></ruby>本体が単一の式であればオプションです。
中かっこの後ろには、`let`文を完了するためにセミコロンが必要です。
<ruby>閉包<rt>クロージャー</rt></ruby>本体（`num`）の最後の行から返される値は、<ruby>閉包<rt>クロージャー</rt></ruby>が呼び出されるときに返される値です。その行はセミコロンで終わらないためです。
機能本体の場合とまったく同じです。

この`let`文は、`expensive_closure`には無名機能の*定義*が含まれており、無名機能を呼び出す*結果の値*は含まれないことに注意してください。
ある時点で呼び出す<ruby>譜面<rt>コード</rt></ruby>を定義し、その<ruby>譜面<rt>コード</rt></ruby>を格納し、後で呼び出したいので、<ruby>閉包<rt>クロージャー</rt></ruby>を使用していることを思い出してください。
呼び出したい<ruby>譜面<rt>コード</rt></ruby>が`expensive_closure`格納されます。

<ruby>閉包<rt>クロージャー</rt></ruby>が定義されている`if`、 `if`<ruby>段落<rt>ブロック</rt></ruby>の<ruby>譜面<rt>コード</rt></ruby>を変更して、<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出して<ruby>譜面<rt>コード</rt></ruby>を実行し、結果の値を取得することができます。
リスト13-6に示すように、<ruby>閉包<rt>クロージャー</rt></ruby>定義を保持する変数名を指定し、使用する引数値を含むかっこで囲みます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
fn generate_workout(intensity: u32, random_number: u32) {
    let expensive_closure = |num| {
        println!("calculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    };

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_closure(intensity)
        );
        println!(
            "Next, do {} situps!",
            expensive_closure(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_closure(intensity)
            );
        }
    }
}
```

<span class="caption">リスト13-6。定義済みの<code>expensive_closure</code>を呼び出す</span>

高価な計算は1つの場所でのみ呼び出され、結果を必要とするところでその<ruby>譜面<rt>コード</rt></ruby>を実行しています。

しかし、リスト13-3の問題の1つを再導入しました。最初の`if`<ruby>段落<rt>ブロック</rt></ruby>で<ruby>閉包<rt>クロージャー</rt></ruby>を2回呼び出します。これは高価な<ruby>譜面<rt>コード</rt></ruby>を2回呼び出し、必要なだけ長く利用者を待機させます。
<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出した結果を保持する<ruby>段落<rt>ブロック</rt></ruby>で`if`ローカル変数を作成することでこの問題を解決できますが、<ruby>閉包<rt>クロージャー</rt></ruby>は別の解決策を提供します。
その解決策について少し話します。
しかし、最初に、<ruby>閉包<rt>クロージャー</rt></ruby>の定義に型の<ruby>注釈<rt>コメント</rt></ruby>がなく、<ruby>閉包<rt>クロージャー</rt></ruby>に関連する<ruby>特性<rt>トレイト</rt></ruby>がない理由について話しましょう。

### <ruby>閉包<rt>クロージャー</rt></ruby>型推論と<ruby>注釈<rt>コメント</rt></ruby>

<ruby>閉包<rt>クロージャー</rt></ruby>では、パラメータの型や`fn`機能のような戻り値に<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありません。
型<ruby>補注<rt>アノテーション</rt></ruby>は、利用者に<ruby>公開<rt>パブリック</rt></ruby>されている明示的な<ruby>接点<rt>インターフェース</rt></ruby>の一部であるため、機能に必要です。
この<ruby>接点<rt>インターフェース</rt></ruby>を厳密に定義することは、機能が使用して返した値の型に誰もが同意することを確実にするために重要です。
しかし、<ruby>閉包<rt>クロージャー</rt></ruby>は、<ruby>公開<rt>パブリック</rt></ruby>された<ruby>接点<rt>インターフェース</rt></ruby>ではこのように使用されません。変数は変数に格納され、名前を付けずに<ruby>譜集<rt>ライブラリー</rt></ruby>の利用者に<ruby>公開<rt>パブリック</rt></ruby>します。

<ruby>閉包<rt>クロージャー</rt></ruby>は通常、短く、任意の場合ではなく狭い文脈内でのみ関連します。
これらの制限された文脈の中で、<ruby>製譜器<rt>コンパイラー</rt></ruby>は、ほとんどの変数の型を推論する方法と同様に、パラメータの型と戻り型を確実に推論することができます。

<ruby>演譜師<rt>プログラマー</rt></ruby>がこれらの小さな、無名機能の型に<ruby>注釈<rt>コメント</rt></ruby>を付けることは、<ruby>製譜器<rt>コンパイラー</rt></ruby>ーがすでに利用可能な情報を迷惑にし、ほとんど冗長になります。

変数の場合と同様に、厳密に必要以上に冗長であることを犠牲にして、明示と明快さを増やしたい場合は、型注釈を追加できます。
リスト13-5で定義した<ruby>閉包<rt>クロージャー</rt></ruby>の型に<ruby>注釈<rt>コメント</rt></ruby>を付けると、リスト13-7のようになります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
let expensive_closure = |num: u32| -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    num
};
```

<span class="caption">リスト13-7。<ruby>閉包<rt>クロージャー</rt></ruby>内のパラメータと戻り値の型のオプションの型の<ruby>注釈<rt>コメント</rt></ruby>の追加</span>

型の<ruby>注釈<rt>コメント</rt></ruby>が追加されると、<ruby>閉包<rt>クロージャー</rt></ruby>の構文は機能の構文に似ています。
以下は、パラメータに1を加えた機能の定義と、同じ振る舞いを持つ<ruby>閉包<rt>クロージャー</rt></ruby>の構文の垂直比較です。
関連する部分を整理するためのスペースを追加しました。
これは、パイプの使用とオプションの構文の量を除いて、<ruby>閉包<rt>クロージャー</rt></ruby>構文が機能構文とどのように似ているかを示しています。

```rust,ignore
fn  add_one_v1   (x: u32) -> u32 { x + 1 }
let add_one_v2 = |x: u32| -> u32 { x + 1 };
let add_one_v3 = |x|             { x + 1 };
let add_one_v4 = |x|               x + 1  ;
```

最初の行は機能定義を示し、2行目は完全に<ruby>注釈<rt>コメント</rt></ruby>付きの<ruby>閉包<rt>クロージャー</rt></ruby>定義を示します。
3行目は型定義を<ruby>閉包<rt>クロージャー</rt></ruby>定義から削除し、4行目はかっこを削除します。これはオプションです。<ruby>閉包<rt>クロージャー</rt></ruby>本体には1つの式しかないためです。
これらはすべて、呼び出し時に同じ動作を生成する有効な定義です。

<ruby>閉包<rt>クロージャー</rt></ruby>定義では、それぞれのパラメータとその戻り値に対して推定される1つの具体的な型があります。
例えば、リスト13-8は、パラメータとして受け取った値を返すshort closureの定義を示しています。
この<ruby>閉包<rt>クロージャー</rt></ruby>は、この例の目的を除いてあまり有用ではありません。
型の<ruby>注釈<rt>コメント</rt></ruby>を定義に追加していないことに注意してください。最初に`String`を引数として、2回目に`u32`を使用して<ruby>閉包<rt>クロージャー</rt></ruby>を2回呼び出すと、<ruby>誤り<rt>エラー</rt></ruby>が発生します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
let example_closure = |x| x;

let s = example_closure(String::from("hello"));
let n = example_closure(5);
```

<span class="caption">リスト13-8。型が2つの異なる型で推論される<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出そうとする</span>

<ruby>製譜器<rt>コンパイラー</rt></ruby>はこの<ruby>誤り<rt>エラー</rt></ruby>を返します。

```text
error[E0308]: mismatched types
 --> src/main.rs
  |
  | let n = example_closure(5);
  |                         ^ expected struct `std::string::String`, found
  integral variable
  |
  = note: expected type `std::string::String`
             found type `{integer}`
```

最初に`example_closure`を`String`値で呼び出すと、<ruby>製譜器<rt>コンパイラー</rt></ruby>は`x`型と<ruby>閉包<rt>クロージャー</rt></ruby>の戻り型を`String`推論します。
これらの型は`example_closure`の<ruby>閉包<rt>クロージャー</rt></ruby>にロックインされ、同じ<ruby>閉包<rt>クロージャー</rt></ruby>で別の型を使用しようとすると型<ruby>誤り<rt>エラー</rt></ruby>が発生します。

### 汎用パラメータと`Fn`<ruby>特性<rt>トレイト</rt></ruby>を使用した<ruby>閉包<rt>クロージャー</rt></ruby>の格納

ワークアウト生成アプリに戻りましょう。
<ruby>譜面<rt>コード</rt></ruby>リスト13-6では、<ruby>譜面<rt>コード</rt></ruby>では、必要以上に高価な計算<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出していました。
この問題を解決する1つの方法は、高価な<ruby>閉包<rt>クロージャー</rt></ruby>の結果を変数に保存して再利用し、<ruby>閉包<rt>クロージャー</rt></ruby>を再度呼び出すのではなく、結果が必要な各場所で変数を使用することです。
ただし、この方法は繰り返し<ruby>譜面<rt>コード</rt></ruby>が多く発生する可能性があります。

幸いにも、私たちにはもう一つの解決策があります。
<ruby>閉包<rt>クロージャー</rt></ruby>を保持する構造体と<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出す結果の値を作成できます。
構造体は、結果の値が必要な場合にのみ<ruby>閉包<rt>クロージャー</rt></ruby>を実行し、残りの<ruby>譜面<rt>コード</rt></ruby>は結果を保存して再利用する必要がないように結果の値をキャッシュします。
このパターンを*メモ*や*怠惰な評価*として知っているかもしれません。

<ruby>閉包<rt>クロージャー</rt></ruby>を保持する構造体を作成するには、<ruby>閉包<rt>クロージャー</rt></ruby>の型を指定する必要があります。構造体の定義では、各<ruby>欄<rt>フィールド</rt></ruby>の型を知る必要があるからです。
各<ruby>閉包<rt>クロージャー</rt></ruby>実例には、独自の一意の無名型があります。つまり、2つの<ruby>閉包<rt>クロージャー</rt></ruby>が同じ型注釈を持っていても、それらの型はまだ異なるとみなされます。
<ruby>閉包<rt>クロージャー</rt></ruby>を使用する構造体、列挙型、または機能パラメータを定義するには、第10章で説明したように総称化と<ruby>特性<rt>トレイト</rt></ruby>縛りを使用します。

`Fn`<ruby>特性<rt>トレイト</rt></ruby>は、標準<ruby>譜集<rt>ライブラリー</rt></ruby>ーによって提供されます。
すべての<ruby>閉包<rt>クロージャー</rt></ruby>は、`Fn`、 `FnMut`、または`FnOnce`うちの少なくとも1つの<ruby>特性<rt>トレイト</rt></ruby>を実装し`Fn`。
これらの<ruby>特性<rt>トレイト</rt></ruby>の違いについては、「環境をクローズで取り込む」章で説明します。
この例では、`Fn`<ruby>特性<rt>トレイト</rt></ruby>を使用することができます。

`Fn`<ruby>特性<rt>トレイト</rt></ruby>束縛に型を追加して、パラメータの型を表現し、<ruby>閉包<rt>クロージャー</rt></ruby>がこの<ruby>特性<rt>トレイト</rt></ruby>縛りに一致する必要がある戻り値を追加します。
この場合、<ruby>閉包<rt>クロージャー</rt></ruby>は、型のパラメータがある`u32`して返す`u32`、指定した束縛特徴はある`Fn(u32) -> u32`。

リスト13-9は、<ruby>閉包<rt>クロージャー</rt></ruby>とオプションの結果値を保持する`Cacher`構造体の定義を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
struct Cacher<T>
    where T: Fn(u32) -> u32
{
    calculation: T,
    value: Option<u32>,
}
```

<span class="caption">リスト13-9。 <code>calculation</code>閉包と<code>value</code>任意の結果を保持する<code>Cacher</code>構造体の定義</span>

`Cacher`構造体には、総称型`T` `calculation`<ruby>欄<rt>フィールド</rt></ruby>があります。
`T`の<ruby>特性<rt>トレイト</rt></ruby>縛りは、`Fn`<ruby>特性<rt>トレイト</rt></ruby>を使用して<ruby>閉包<rt>クロージャー</rt></ruby>であることを指定します。
`calculation`<ruby>欄<rt>フィールド</rt></ruby>に格納する<ruby>閉包<rt>クロージャー</rt></ruby>は、1つの`u32`パラメータ（`Fn`後のかっこ内に指定）を持つ必要があり、`u32`（ `->`）の後に指定する必要があります。

> > 注。機能は3つの`Fn`<ruby>特性<rt>トレイト</rt></ruby>もすべて実装してい`Fn`。
> > やりたいことが環境からの価値を取り込む必要がなければ、`Fn`<ruby>特性<rt>トレイト</rt></ruby>を実装するものが必要な<ruby>閉包<rt>クロージャー</rt></ruby>ではなく機能を使うことができます。

`value`<ruby>欄<rt>フィールド</rt></ruby>の型は`Option<u32>`です。
<ruby>閉包<rt>クロージャー</rt></ruby>を実行する前に、`value`は`None`ます。
`Cacher`を使用している<ruby>譜面<rt>コード</rt></ruby>が<ruby>閉包<rt>クロージャー</rt></ruby>の*結果*を要求すると、`Cacher`はその時点で<ruby>閉包<rt>クロージャー</rt></ruby>を実行し、その結果を`value`<ruby>欄<rt>フィールド</rt></ruby>の`Some`<ruby>場合値<rt>バリアント</rt></ruby>に格納します。
次に、<ruby>譜面<rt>コード</rt></ruby>が再び<ruby>閉包<rt>クロージャー</rt></ruby>の結果を求める場合、<ruby>閉包<rt>クロージャー</rt></ruby>を再度実行する代わりに、`Cacher`は`Some`<ruby>場合値<rt>バリアント</rt></ruby>に保持されている結果を返します。

上で説明した`value`<ruby>欄<rt>フィールド</rt></ruby>の周りの<ruby>論理<rt>ロジック</rt></ruby>は、リスト13-10で定義されています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# struct Cacher<T>
#     where T: Fn(u32) -> u32
# {
#     calculation: T,
#     value: Option<u32>,
# }
#
impl<T> Cacher<T>
    where T: Fn(u32) -> u32
{
    fn new(calculation: T) -> Cacher<T> {
        Cacher {
            calculation,
            value: None,
        }
    }

    fn value(&mut self, arg: u32) -> u32 {
        match self.value {
            Some(v) => v,
            None => {
                let v = (self.calculation)(arg);
                self.value = Some(v);
                v
            },
        }
    }
}
```

<span class="caption">リスト13-10。のキャッシュ論理<code>Cacher</code></span>

`Cacher`は、呼び出し元<ruby>譜面<rt>コード</rt></ruby>がこれらの<ruby>欄<rt>フィールド</rt></ruby>の値を直接変更できるようにするのではなく、構造体<ruby>欄<rt>フィールド</rt></ruby>の値を管理したいので、これらの<ruby>欄<rt>フィールド</rt></ruby>は非<ruby>公開<rt>パブリック</rt></ruby>です。

`Cacher::new`機能は、総称化パラメータ`T`とります。これは、`Cacher`構造体と同じ<ruby>特性<rt>トレイト</rt></ruby>を持つと定義しています。
次に、`Cacher::new`は、`calculation`<ruby>欄<rt>フィールド</rt></ruby>で指定された<ruby>閉包<rt>クロージャー</rt></ruby>を保持する`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>と、まだ<ruby>閉包<rt>クロージャー</rt></ruby>を実行していないため、`value`<ruby>欄<rt>フィールド</rt></ruby>に`None`値を返します。

呼び出し元<ruby>譜面<rt>コード</rt></ruby>が<ruby>閉包<rt>クロージャー</rt></ruby>を評価する結果を必要とする場合、<ruby>閉包<rt>クロージャー</rt></ruby>を直接呼び出すのではなく、`value`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出し`value`。
この<ruby>操作法<rt>メソッド</rt></ruby>は、`Some` `self.value`に結果の値がすでにあるかどうかをチェックします。
もしそうであれば、Closureを再度実行せずに`Some`内の値を返します。

`self.value`が`None`場合、<ruby>譜面<rt>コード</rt></ruby>は`self.calculation`に格納されている<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出し、将来の使用のために`self.value`に結果を保存し、値も返します。

リスト13-11は、リスト13-6の`generate_workout`機能でこの`Cacher`構造体を使用する方法を示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::thread;
# use std::time::Duration;
#
# struct Cacher<T>
#     where T: Fn(u32) -> u32
# {
#     calculation: T,
#     value: Option<u32>,
# }
#
# impl<T> Cacher<T>
#     where T: Fn(u32) -> u32
# {
#     fn new(calculation: T) -> Cacher<T> {
#         Cacher {
#             calculation,
#             value: None,
#         }
#     }
#
#     fn value(&mut self, arg: u32) -> u32 {
#         match self.value {
#             Some(v) => v,
#             None => {
#                 let v = (self.calculation)(arg);
#                 self.value = Some(v);
#                 v
#             },
#         }
#     }
# }
#
fn generate_workout(intensity: u32, random_number: u32) {
    let mut expensive_result = Cacher::new(|num| {
        println!("calculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    });

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_result.value(intensity)
        );
        println!(
            "Next, do {} situps!",
            expensive_result.value(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_result.value(intensity)
            );
        }
    }
}
```

<span class="caption">リスト13-11。キャッシュ<ruby>論理<rt>ロジック</rt></ruby>を抽象化<code>generate_workout</code>ために<code>generate_workout</code>機能で<code>Cacher</code>を使う</span>

<ruby>閉包<rt>クロージャー</rt></ruby>を変数に直接保存する代わりに、<ruby>閉包<rt>クロージャー</rt></ruby>を保持する`Cacher`新しい<ruby>実例<rt>インスタンス</rt></ruby>を保存します。
次に、結果が必要な各場所で、`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>の`value`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出します。
`value`<ruby>操作法<rt>メソッド</rt></ruby>を何度でも呼び出すこともできますし、呼び出さないこともできます。高価な計算は最大1回実行されます。

リスト13-2の`main`機能でこの<ruby>算譜<rt>プログラム</rt></ruby>を実行してみてください。
内の値に変更`simulated_user_specified_value`と`simulated_random_number`様々で、すべての場合にそのことを確認するために、変数`if`と`else`、<ruby>段落<rt>ブロック</rt></ruby>を`calculating slowly...`必要なときに一度だけしか表示されます。
`Cacher`は、必要以上に高価な計算を呼び出さないようにするために必要な<ruby>論理<rt>ロジック</rt></ruby>を処理し、`generate_workout`はビジネス<ruby>論理<rt>ロジック</rt></ruby>に集中`generate_workout`ことができます。

### `Cacher`実装の制限

値をキャッシュすることは、異なる<ruby>閉包<rt>クロージャー</rt></ruby>を使用して<ruby>譜面<rt>コード</rt></ruby>の他の部分で使用したい場合がある一般的に有用な動作です。
しかし、`Cacher`の現在の実装には、異なる状況での再利用を困難にする2つの問題があります。

最初の問題は、`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>は、`value`<ruby>操作法<rt>メソッド</rt></ruby>への`arg`に対して常に同じ値を取得すると仮定しているということです。
つまり、この`Cacher`テストは失敗します。

```rust,ignore
#[test]
fn call_with_different_values() {
    let mut c = Cacher::new(|a| a);

    let v1 = c.value(1);
    let v2 = c.value(2);

    assert_eq!(v2, 2);
}
```

このテストでは、渡された値を返す<ruby>閉包<rt>クロージャー</rt></ruby>付きの新しい`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>を作成します。
この`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>の`value`<ruby>操作法<rt>メソッド</rt></ruby>を`arg`値1と`arg`値2で呼び出すと、`arg`値2で`value`を呼び出すと2が返されます。

で、このテストを実行します`Cacher` 13-9とリスト13-10のリストの実装、およびテストが上で失敗します`assert_eq!`このメッセージで。

```text
thread 'call_with_different_values' panicked at 'assertion failed: `(left == right)`
  left: `1`,
 right: `2`', src/main.rs
```

問題は、呼ば初めてということである`c.value` 1とは、`Cacher`<ruby>実例<rt>インスタンス</rt></ruby>が保存された`Some(1)`に`self.value`。
その後、`value`<ruby>操作法<rt>メソッド</rt></ruby>に何を渡しても、常に1が返されます。

単一の値ではなくハッシュマップを保持するように`Cacher`を修正してみてください。
ハッシュマップのキーは渡される`arg`値になり、ハッシュマップの値はそのキーの<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出した結果になります。
`self.value`が`Some`または`None`値を直接持っているかどうかを調べる代わりに、`value`機能はハッシュマップ内の`arg`をルックアップし、値が存在すればそれを返します。
それが存在しない場合、`Cacher`は<ruby>閉包<rt>クロージャー</rt></ruby>を呼び出し、結果値を`arg`値に関連付けられたハッシュマップに保存します。

現在の第2の問題`Cacher`実装は、それが唯一の型の一つのパラメータ取る<ruby>閉包<rt>クロージャー</rt></ruby>受け入れるということです`u32`して返す`u32`。
たとえば、<ruby>文字列<rt>ストリング</rt></ruby>スライスを使用して`usize`値を返す<ruby>閉包<rt>クロージャー</rt></ruby>の結果をキャッシュすることがあります。
この問題を解決するには、より一般的なパラメータを導入して、`Cacher`機能の柔軟性を高めてください。

### <ruby>閉包<rt>クロージャー</rt></ruby>による環境の捉え方

ワークアウト生成器の例では、インラインの無名機能としてのみ<ruby>閉包<rt>クロージャー</rt></ruby>を使用しました。
しかし、<ruby>閉包<rt>クロージャー</rt></ruby>には、機能にはない追加の機能があります。つまり、環境を捕獲し、定義されている<ruby>有効範囲<rt>スコープ</rt></ruby>から変数にアクセスできます。

`equal_to_x`リスト13-12には、<ruby>閉包<rt>クロージャー</rt></ruby>の周囲環境からの`x`変数を使用する`equal_to_x`変数に格納された<ruby>閉包<rt>クロージャー</rt></ruby>の例があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let x = 4;

    let equal_to_x = |z| z == x;

    let y = 4;

    assert!(equal_to_x(y));
}
```

<span class="caption">譜面リスト13-12。外側の<ruby>有効範囲<rt>スコープ</rt></ruby>内の変数を参照する<ruby>閉包<rt>クロージャー</rt></ruby>の例</span>

ここでは、にもかかわらず、`x`のパラメータの一つではありません`equal_to_x`、 `equal_to_x`<ruby>閉包<rt>クロージャー</rt></ruby>は使用を許可されている`x`同じ<ruby>有効範囲<rt>スコープ</rt></ruby>で定義されています変数`equal_to_x`に定義されているが。

機能でも同じことをすることはできません。
次の例で試してみると、<ruby>譜面<rt>コード</rt></ruby>は<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let x = 4;

    fn equal_to_x(z: i32) -> bool { z == x }

    let y = 4;

    assert!(equal_to_x(y));
}
```

<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
error[E0434]: can't capture dynamic environment in a fn item; use the || { ...
} closure form instead
 --> src/main.rs
  |
4 |     fn equal_to_x(z: i32) -> bool { z == x }
  |                                          ^
```

<ruby>製譜器<rt>コンパイラー</rt></ruby>は、これが<ruby>閉包<rt>クロージャー</rt></ruby>でのみ動作することを私たちに思い出させる！　

<ruby>閉包<rt>クロージャー</rt></ruby>がその環境から値を取得すると、記憶を使用して<ruby>閉包<rt>クロージャー</rt></ruby>本体で使用する値が格納されます。
この<ruby>記憶域<rt>メモリー</rt></ruby>の使用は、環境を<ruby>捕捉<rt>キャッチ</rt></ruby>しない<ruby>譜面<rt>コード</rt></ruby>を実行する、より一般的なケースでは支払う必要のないオーバーヘッドです。
機能は決して環境を<ruby>捕捉<rt>キャッチ</rt></ruby>することができないので、機能を定義して使用することは決してこのオーバーヘッドを招くことはありません。

<ruby>閉包<rt>クロージャー</rt></ruby>は、環境から3つの方法で値を取り込むことができます。これは、機能がパラメータをとる3つの方法、つまり所有権の取得、可変的な借用、および不変の借用の3つの方法に直接対応します。
これらは、以下のように3つの`Fn`<ruby>特性<rt>トレイト</rt></ruby>で<ruby>譜面<rt>コード</rt></ruby>される。

* `FnOnce`は、<ruby>閉包<rt>クロージャー</rt></ruby>の*環境*として知られる外側の<ruby>有効範囲<rt>スコープ</rt></ruby>から捕獲する変数を消費します。
   捕獲された変数を消費するには、<ruby>閉包<rt>クロージャー</rt></ruby>はこれらの変数の所有権を取得し、<ruby>閉包<rt>クロージャー</rt></ruby>が定義されたときに<ruby>閉包<rt>クロージャー</rt></ruby>に移動する必要があります。
   名前の`Once`部分は、<ruby>閉包<rt>クロージャー</rt></ruby>が同じ変数の所有権を複数回取ることができないという事実を表しているため、一度しか呼び出しすることはできません。
* `FnMut`は、値を可変的に借りるので環境を変更することができます。
* `Fn`は環境から価値を借りています。

<ruby>閉包<rt>クロージャー</rt></ruby>を作成すると、Rustは<ruby>閉包<rt>クロージャー</rt></ruby>が環境からの値をどのように使用するかに基づいてどの<ruby>特性<rt>トレイト</rt></ruby>を使用するかを推測します。
すべての<ruby>閉包<rt>クロージャー</rt></ruby>は少なくとも1回は`FnOnce`ことができるため、`FnOnce`実装しています。
捕獲された変数を移動しない<ruby>閉包<rt>クロージャー</rt></ruby>も`FnMut`実装し、捕獲された変数への変更可能なアクセスを必要としない<ruby>閉包<rt>クロージャー</rt></ruby>も`Fn`実装し`Fn`。
リスト13-12では、closureの本体が`x`の値を読み取るだけで`equal_to_x`ため、`equal_to_x`<ruby>閉包<rt>クロージャー</rt></ruby>は`x`不変に借用`Fn`（ `equal_to_x`は`Fn`<ruby>特性<rt>トレイト</rt></ruby>を持ち`Fn`）。

<ruby>閉包<rt>クロージャー</rt></ruby>が強制的に環境内で使用する値の所有権を取得するように`move`には、パラメータリストの前に`move`予約語を使用します。
この技法は、データを移動して新しい<ruby>走脈<rt>スレッド</rt></ruby>が所有するように<ruby>閉包<rt>クロージャー</rt></ruby>を新しい<ruby>走脈<rt>スレッド</rt></ruby>に渡すときに最も役立ちます。

並行処理については、第16章で`move` closureの例をさらに導入します。
今のところ、リスト13-12の<ruby>譜面<rt>コード</rt></ruby>では、`move`予約語を<ruby>閉包<rt>クロージャー</rt></ruby>定義に追加し、整数の代わりにベクトルを使用します。これは、整数を移動するのではなくコピーすることができるためです。
この<ruby>譜面<rt>コード</rt></ruby>はまだ<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let x = vec![1, 2, 3];

    let equal_to_x = move |z| z == x;

    println!("can't use x here: {:?}", x);

    let y = vec![1, 2, 3];

    assert!(equal_to_x(y));
}
```

次の<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
error[E0382]: use of moved value: `x`
 --> src/main.rs:6:40
  |
4 |     let equal_to_x = move |z| z == x;
  |                      -------- value moved (into closure) here
5 |
6 |     println!("can't use x here: {:?}", x);
  |                                        ^ value used here after move
  |
  = note: move occurs because `x` has type `std::vec::Vec<i32>`, which does not
  implement the `Copy` trait
```

`x`値は<ruby>閉包<rt>クロージャー</rt></ruby>が定義されたときに<ruby>閉包<rt>クロージャー</rt></ruby>に`move`されます。これは`move`予約語が追加されたためです。
次に、<ruby>閉包<rt>クロージャー</rt></ruby>は`x`所有権を持ち、`main`は`println!`文で`x`もう使用することはできません。
`println!`削除すると、この例が修正されます。

一つを指定する時間のほとんど`Fn`<ruby>特性<rt>トレイト</rt></ruby>縛りは、始めることができる`Fn`と必要な場合、<ruby>製譜器<rt>コンパイラー</rt></ruby>はあなたを教えてくれます`FnMut`または`FnOnce`<ruby>閉包<rt>クロージャー</rt></ruby>体に何が起こるかに基づきます。

環境を捕獲できる<ruby>閉包<rt>クロージャー</rt></ruby>が機能パラメータとして有用な状況を説明するために、次の話題、<ruby>反復子<rt>イテレータ</rt></ruby>に移りましょう。
