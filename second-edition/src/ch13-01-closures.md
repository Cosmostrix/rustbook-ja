## 閉包。環境を捕捉できる無名機能

Rustの閉包は、変数に保存するか、他の機能に引数として渡すことができる無名機能です。
1つの場所に閉包を作成してから別の文脈で閉包を評価することができます。
機能とは異なり、閉包は呼び出された有効範囲から値を取得できます。
これらの閉包機能が譜面の再利用と動作のカスタマイズを可能にする方法を示します。

### 閉包を使用した動作の抽象化の作成

後で実行される閉包を保存すると便利な状況の例を取り上げてみましょう。
途中で、閉包、型推論、および特性の構文について説明します。

この仮説的な状況を考えてみましょう。スタートアップ時に、独自の運動トレーニング計画を作成するアプリを作っています。
バックエンドはRustで書かれており、トレーニングプランを生成する計算手続きは、アプリユーザーの年齢、体格指数、運動の好み、最近のトレーニング、彼らが指定した強度番号など、多くの要因を考慮しています。
使用される実際の計算手続きは、この例では重要ではありません。
重要なのは、この計算に数秒かかるということです。
この計算手続きを呼び出す必要があるときにのみ呼び出し、一度呼び出すだけで、ユーザーが必要以上に待たされることはありません。

リスト13-1に示す機能`simulated_expensive_calculation`使って、この仮説的な計算手続きを呼び出すことをシミュレートします。これは、`calculating slowly...` 2秒間待ってから渡した数を返します。

<span class="filename">ファイル名。src / main.rs</span>

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
この機能は、ユーザーがワークアウトプランを要求したときに譜体が呼び出す譜面を表します。
譜体のフロントエンドとのやりとりは閉包の使用に関係しないので、算譜への入力を表す値をハード譜面し、出力を出力します。

必要な入力は次のとおりです。

* ユーザーからの強度番号。低強度のトレーニングや高強度のトレーニングを希望するかどうかを示すためにトレーニングをリクエストしたときに指定されます。
* 運動計画に多種多様な乱数を生成する

出力は、推奨されるワークアウト計画になります。
譜面リスト13-2は、使用する`main`機能を示しています。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト13-2。ユーザ入力と乱数生成をシミュレートするハード譜面された値を持つ<code>main</code>機能</span>

わかりやすくするために、変数`simulated_user_specified_value`を10、変数`simulated_random_number`を7にハード作譜しました。
実際の算譜では、アプリのフロントエンドからの強度番号を取得したい、と使用したい`rand`第2章で推測ゲームの例で行ったように、乱数を生成するための通い箱を`main`機能呼び出し`generate_workout`機能をシミュレートされた入力値と比較します。

文脈があるので、計算手続きに着きましょう。
リスト13-3の機能`generate_workout`には、この例で最も関心のある譜体のビジネスロジックが含まれています。
この例の譜面変更の残りの部分がこの機能に適用されます。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト13-3。 <code>simulated_expensive_calculation</code>機能への入力と呼び出しに基づいてワークアウトプランを出力するビジネスロジック</span>

譜面リスト13-3の譜面では、低速計算機能が複数呼び出されています。
最初の`if`段落の呼び出しは`simulated_expensive_calculation`二回、`if`外側内側の`else`全くそれを呼び出すことはありません、第二の内部譜面`else`場合は、一度それを呼び出します。


`generate_workout`機能の望ましい挙動は、ユーザが低強度トレーニング（25未満の数字で示される）または高強度トレーニング（25以上の数）を望むかどうかを最初に確認することであます。

低強度トレーニング計画では、シミュレーションしている複雑な計算手続きに基づいて、いくつかのプッシュアップと腹筋を推奨します。

ユーザーが高輝度のトレーニングをしたい場合は、追加のロジックがあります。アプリによって生成された乱数の値が3になると、アプリは休憩と水分をおすすめします。
そうでない場合、ユーザーは複雑な計算手続きに基づいて実行するまでに数分かかるでしょう。

この譜面は今のところビジネスが望んでいるように機能しますが、データ科学チームは、将来`simulated_expensive_calculation`機能を呼び出す方法をいくつか変更する必要があると判断したとしましょう。
これらの変更が発生したときに更新を簡素化するため、この譜面をリファクタリングして、`simulated_expensive_calculation`機能を1回だけ呼び出すようにします。
また、現在、不必要に機能を2回呼び出す場所を、その機能の他の呼び出しを過程に追加することなく切り詰める必要があります。
つまり、結果が必要でない場合は呼びたくないのですが、それを一度だけ呼びたいと思っています。

#### 機能を使用したリファクタリング

様々な方法でワークアウト算譜を再構成することができました。
まず、`simulated_expensive_calculation`機能の重複呼び出しを変数に抽出してみましょう（リスト13-4を参照）。

<span class="filename">ファイル名。src / main.rs</span>

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

この変更により、`simulated_expensive_calculation`へのすべての呼び出しが統一され、最初の`if`段落が不必要に機能を2回呼び出すという問題が解決されます。
残念ながら、この機能を呼び出して、結果値をまったく使用しない内部の`if`段落を含むすべての場合の結果を待っています。

算譜内のある場所に譜面を定義したいが、実際に結果が必要な場所で譜面を*実行する*だけです。
これは閉包の使用例です！　

#### 譜面を格納するための閉包によるリファクタリング

代わりに、常に呼び出しの`simulated_expensive_calculation`前に機能を`if`段落、閉包を定義し、むしろリスト13-5に示すように、機能呼び出しの結果を格納するよりも、変数に*閉包を*保存することができます。
実際には、ここで導入しているclosure内で`simulated_expensive_calculation`の全身を動かすことができます。

<span class="filename">ファイル名。src / main.rs</span>

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

閉包の定義は、`=`後に来て、それを変数`expensive_closure`に代入します。
閉包を定義するには、閉包のパラメータを指定する一対の垂直パイプ（`|`）から始めます。
この構文は、SmalltalkとRubyにおける閉包定義との類似性のために選択されました。
この閉包には`num`という名前のパラメーターが1つあります。複数のパラメーターがある場合は、`|param1, param2|`ようにカンマで区切ります`|param1, param2|`
。

パラメータの後ろに、閉包の本体を保持する中かっこを配置します。これらは、閉包本体が単一の式であれば選択肢です。
中かっこの後ろには、`let`文を完了するためにセミコロンが必要です。
閉包本体（`num`）の最後の行から返される値は、閉包が呼び出されるときに返される値です。その行はセミコロンで終わらないためです。
機能本体の場合とまったく同じです。

この`let`文は、`expensive_closure`には無名機能の*定義*が含まれており、無名機能を呼び出す*結果の値*は含まれないことに注意してください。
ある時点で呼び出す譜面を定義し、その譜面を格納し、後で呼び出したいので、閉包を使用していることを思い出してください。
呼び出したい譜面が`expensive_closure`格納されます。

閉包が定義されている`if`、 `if`段落の譜面を変更して、閉包を呼び出して譜面を実行し、結果の値を取得することができます。
リスト13-6に示すように、閉包定義を保持する変数名を指定し、使用する引数値を含むかっこで囲みます。

<span class="filename">ファイル名。src / main.rs</span>

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

高価な計算は1つの場所でのみ呼び出され、結果を必要とするところでその譜面を実行しています。

しかし、リスト13-3の問題の1つを再導入しました。最初の`if`段落で閉包を2回呼び出します。これは高価な譜面を2回呼び出し、必要なだけ長くユーザーを待機させます。
閉包を呼び出した結果を保持する段落で`if`ローカル変数を作成することでこの問題を解決できますが、閉包は別の解決策を提供します。
その解決策について少し話します。
しかし、最初に、閉包の定義に型の注釈がなく、閉包に関連する特性がない理由について話しましょう。

### 閉包型推論と注釈

閉包では、パラメータの型や`fn`機能のような戻り値に注釈を付ける必要はありません。
型注釈は、ユーザーに公開されている明示的な接点の一部であるため、機能に必要です。
この接点を厳密に定義することは、機能が使用して返した値の型に誰もが同意することを確実にするために重要です。
しかし、閉包は、公開された接点ではこのように使用されません。変数は変数に格納され、名前を付けずに譜集のユーザーに公開します。

閉包は通常、短く、任意の場合ではなく狭い文脈内でのみ関連します。
これらの制限された文脈の中で、製譜器は、ほとんどの変数の型を推論する方法と同様に、パラメータの型と戻り型を確実に推論することができます。

演譜師がこれらの小さな、無名機能の型に注釈を付けることは、製譜器ーがすでに利用可能な情報を迷惑にし、ほとんど冗長になります。

変数の場合と同様に、厳密に必要以上に冗長であることを犠牲にして、明示と明快さを増やしたい場合は、型注釈を追加できます。
リスト13-5で定義した閉包の型に注釈を付けると、リスト13-7のようになります。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト13-7。閉包内のパラメータと戻り値の型の選択肢の型の注釈の追加</span>

型の注釈が追加されると、閉包の構文は機能の構文に似ています。
以下は、パラメータに1を加えた機能の定義と、同じ振る舞いを持つ閉包の構文の垂直比較です。
関連する部分を整理するためのスペースを追加しました。
これは、パイプの使用と選択肢の構文の量を除いて、閉包構文が機能構文とどのように似ているかを示しています。

```rust,ignore
fn  add_one_v1   (x: u32) -> u32 { x + 1 }
let add_one_v2 = |x: u32| -> u32 { x + 1 };
let add_one_v3 = |x|             { x + 1 };
let add_one_v4 = |x|               x + 1  ;
```

最初の行は機能定義を示し、2行目は完全に注釈付きの閉包定義を示します。
3行目は型定義を閉包定義から削除し、4行目はかっこを削除します。これは選択肢です。閉包本体には1つの式しかないためです。
これらはすべて、呼び出し時に同じ動作を生成する有効な定義です。

閉包定義では、それぞれのパラメータとその戻り値に対して推定される1つの具体的な型があります。
例えば、リスト13-8は、パラメータとして受け取った値を返すshort closureの定義を示しています。
この閉包は、この例の目的を除いてあまり有用ではありません。
型の注釈を定義に追加していないことに注意してください。最初に`String`を引数として、2回目に`u32`を使用して閉包を2回呼び出すと、誤りが発生します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
let example_closure = |x| x;

let s = example_closure(String::from("hello"));
let n = example_closure(5);
```

<span class="caption">リスト13-8。型が2つの異なる型で推論される閉包を呼び出そうとする</span>

製譜器はこの誤りを返します。

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

最初に`example_closure`を`String`値で呼び出すと、製譜器は`x`型と閉包の戻り型を`String`推論します。
これらの型は`example_closure`の閉包にロックインされ、同じ閉包で別の型を使用しようとすると型誤りが発生します。

### 汎用パラメータと`Fn`特性を使用した閉包の格納

ワークアウト生成アプリに戻りましょう。
譜面リスト13-6では、譜面では、必要以上に高価な計算閉包を呼び出していました。
この問題を解決する1つの方法は、高価な閉包の結果を変数に保存して再利用し、閉包を再度呼び出すのではなく、結果が必要な各場所で変数を使用することです。
ただし、この方法は繰り返し譜面が多く発生する可能性があります。

幸いにも、私たちにはもう一つの解決策があります。
閉包を保持する構造体と閉包を呼び出す結果の値を作成できます。
構造体は、結果の値が必要な場合にのみ閉包を実行し、残りの譜面は結果を保存して再利用する必要がないように結果の値をキャッシュします。
あなたはこのパターンを*メモ*や*怠惰な評価*として知っているかもしれません。

閉包を保持する構造体を作成するには、閉包の型を指定する必要があります。構造体の定義では、各欄の型を知る必要があるからです。
各閉包実例には、独自の一意の無名型があります。つまり、2つの閉包が同じ型指示を持っていても、それらの型はまだ異なるとみなされます。
閉包を使用する構造体、列挙型、または機能パラメータを定義するには、第10章で説明したように総称化と特性縛りを使用します。

`Fn`特性は、標準譜集ーによって提供されます。
すべての閉包は、`Fn`、 `FnMut`、または`FnOnce`うちの少なくとも1つの特性を実装し`Fn`。
これらの特性の違いについては、「環境をクローズで取り込む」章で説明します。
この例では、`Fn`特性を使用することができます。

`Fn`特性束縛に型を追加して、パラメータの型を式し、閉包がこの特性縛りに一致する必要がある戻り値を追加します。
この場合、閉包は、型のパラメータがある`u32`して返す`u32`、指定した束縛特徴はある`Fn(u32) -> u32`。

リスト13-9は、閉包と選択肢の結果値を保持する`Cacher`構造体の定義を示しています。

<span class="filename">ファイル名。src / main.rs</span>

```rust
struct Cacher<T>
    where T: Fn(u32) -> u32
{
    calculation: T,
    value: Option<u32>,
}
```

<span class="caption">リスト13-9。 <code>calculation</code>閉包と<code>value</code>任意の結果を保持する<code>Cacher</code>構造体の定義</span>

`Cacher`構造体には、総称型`T` `calculation`欄があります。
`T`の特性縛りは、`Fn`特性を使用して閉包であることを指定します。
`calculation`欄に格納する閉包は、1つの`u32`パラメータ（`Fn`後のかっこ内に指定）を持つ必要があり、`u32`（ `->`）の後に指定する必要があります。

> > 注。機能は3つの`Fn`特性もすべて実装してい`Fn`。
> > やりたいことが環境からの価値を取り込む必要がなければ、`Fn`特性を実装するものが必要な閉包ではなく機能を使うことができます。

`value`欄の型は`Option<u32>`です。
閉包を実行する前に、`value`は`None`ます。
`Cacher`を使用している譜面が閉包の*結果*を要求すると、`Cacher`はその時点で閉包を実行し、その結果を`value`欄の`Some`場合値に格納します。
次に、譜面が再び閉包の結果を求める場合、閉包を再度実行する代わりに、`Cacher`は`Some`場合値に保持されている結果を返します。

上で説明した`value`欄の周りのロジックは、リスト13-10で定義されています。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト13-10。のキャッシュロジック<code>Cacher</code></span>

`Cacher`は、呼び出し元譜面がこれらの欄の値を直接変更できるようにするのではなく、構造体欄の値を管理したいので、これらの欄は非公開です。

`Cacher::new`機能は、総称化パラメータ`T`とります。これは、`Cacher`構造体と同じ特性を持つと定義しています。
次に、`Cacher::new`は、`calculation`欄で指定された閉包を保持する`Cacher`実例と、まだ閉包を実行していないため、`value`欄に`None`値を返します。

呼び出し元譜面が閉包を評価する結果を必要とする場合、閉包を直接呼び出すのではなく、`value`操作法を呼び出し`value`。
この操作法は、`Some` `self.value`に結果の値がすでにあるかどうかをチェックします。
もしそうであれば、Closureを再度実行せずに`Some`内の値を返します。

`self.value`が`None`場合、譜面は`self.calculation`に格納されている閉包を呼び出し、将来の使用のために`self.value`に結果を保存し、値も返します。

リスト13-11は、リスト13-6の`generate_workout`機能でこの`Cacher`構造体を使用する方法を示しています。

<span class="filename">ファイル名。src / main.rs</span>

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

<span class="caption">リスト13-11。キャッシュロジックを抽象化<code>generate_workout</code>ために<code>generate_workout</code>機能で<code>Cacher</code>を使う</span>

閉包を変数に直接保存する代わりに、閉包を保持する`Cacher`新しい実例を保存します。
次に、結果が必要な各場所で、`Cacher`実例の`value`操作法を呼び出します。
`value`操作法を何度でも呼び出すこともできますし、呼び出さないこともできます。高価な計算は最大1回実行されます。

リスト13-2の`main`機能でこの算譜を実行してみてください。
内の値に変更`simulated_user_specified_value`と`simulated_random_number`様々で、すべての場合にそのことを確認するために、変数`if`と`else`、段落を`calculating slowly...`必要なときに一度だけしか表示されます。
`Cacher`は、必要以上に高価な計算を呼び出さないようにするために必要なロジックを処理し、`generate_workout`はビジネスロジックに集中`generate_workout`ことができます。

### `Cacher`実装の制限

値をキャッシュすることは、異なる閉包を使用して譜面の他の部分で使用したい場合がある一般的に有用な動作です。
しかし、`Cacher`の現在の実装には、異なる状況での再利用を困難にする2つの問題があります。

最初の問題は、`Cacher`実例は、`value`操作法への`arg`に対して常に同じ値を取得すると仮定しているということです。
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

このテストでは、渡された値を返す閉包付きの新しい`Cacher`実例を作成します。
この`Cacher`実例の`value`操作法を`arg`値1と`arg`値2で呼び出すと、`arg`値2で`value`を呼び出すと2が返されます。

で、このテストを実行します`Cacher` 13-9とリスト13-10のリストの実装、およびテストが上で失敗します`assert_eq!`このメッセージで。

```text
thread 'call_with_different_values' panicked at 'assertion failed: `(left == right)`
  left: `1`,
 right: `2`', src/main.rs
```

問題は、呼ば初めてということである`c.value` 1とは、`Cacher`実例が保存された`Some(1)`に`self.value`。
その後、`value`操作法に何を渡しても、常に1が返されます。

単一の値ではなくハッシュマップを保持するように`Cacher`を修正してみてください。
ハッシュマップのキーは渡される`arg`値になり、ハッシュマップの値はそのキーの閉包を呼び出した結果になります。
`self.value`が`Some`または`None`値を直接持っているかどうかを調べる代わりに、`value`機能はハッシュマップ内の`arg`をルックアップし、値が存在すればそれを返します。
それが存在しない場合、`Cacher`は閉包を呼び出し、結果値を`arg`値に関連付けられたハッシュマップに保存します。

現在の第2の問題`Cacher`実装は、それが唯一の型の一つのパラメータ取る閉包受け入れるということです`u32`して返す`u32`。
たとえば、文字列スライスを使用して`usize`値を返す閉包の結果をキャッシュすることが`usize`ます。
この問題を解決するには、より一般的なパラメータを導入して、`Cacher`機能の柔軟性を高めてください。

### 閉包による環境の捉え方

ワークアウト生成器の例では、インラインの無名機能としてのみ閉包を使用しました。
しかし、閉包には、機能にはない追加の機能があります。つまり、環境を捕獲し、定義されている有効範囲から変数にアクセスできます。

`equal_to_x`リスト13-12には、閉包の周囲環境からの`x`変数を使用する`equal_to_x`変数に格納された閉包の例があります。

<span class="filename">ファイル名。src / main.rs</span>

```rust
fn main() {
    let x = 4;

    let equal_to_x = |z| z == x;

    let y = 4;

    assert!(equal_to_x(y));
}
```

<span class="caption">譜面リスト13-12。外側の有効範囲内の変数を参照する閉包の例</span>

ここでは、にもかかわらず、`x`のパラメータの一つではありません`equal_to_x`、 `equal_to_x`閉包は使用を許可されている`x`同じ有効範囲で定義されています変数`equal_to_x`に定義されているが。

機能でも同じことをすることはできません。
次の例で試してみると、譜面は製譜されません。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let x = 4;

    fn equal_to_x(z: i32) -> bool { z == x }

    let y = 4;

    assert!(equal_to_x(y));
}
```

誤りが表示されます。

```text
error[E0434]: can't capture dynamic environment in a fn item; use the || { ...
} closure form instead
 --> src/main.rs
  |
4 |     fn equal_to_x(z: i32) -> bool { z == x }
  |                                          ^
```

製譜器は、これが閉包でのみ動作することを私たちに思い出させる！　

閉包がその環境から値を取得すると、記憶を使用して閉包本体で使用する値が格納されます。
この記憶域の使用は、環境を捕捉しない譜面を実行する、より一般的なケースでは支払う必要のないオーバーヘッドです。
機能は決して環境を捕捉することができないので、機能を定義して使用することは決してこのオーバーヘッドを招くことはありません。

閉包は、環境から3つの方法で値を取り込むことができます。これは、機能がパラメータをとる3つの方法、つまり所有権の取得、可変的な借用、および不変の借用の3つの方法に直接対応します。
これらは、以下のように3つの`Fn`特性で譜面される。

* `FnOnce`は、閉包の*環境*として知られる外側の有効範囲から捕獲する変数を消費します。
   捕獲された変数を消費するには、閉包はこれらの変数の所有権を取得し、閉包が定義されたときに閉包に移動する必要があります。
   名前の`Once`部分は、閉包が同じ変数の所有権を複数回取ることができないという事実を表しているため、一度しか呼び出しすることはできません。
* `FnMut`は、値を可変的に借りるので環境を変更することができます。
* `Fn`は環境から価値を借りています。

閉包を作成すると、Rustは閉包が環境からの値をどのように使用するかに基づいてどの特性を使用するかを推測します。
すべての閉包は少なくとも1回は`FnOnce`ことができるため、`FnOnce`実装しています。
捕獲された変数を移動しない閉包も`FnMut`実装し、捕獲された変数への変更可能なアクセスを必要としない閉包も`Fn`実装し`Fn`。
リスト13-12では、closureの本体が`x`の値を読み取るだけで`equal_to_x`ため、`equal_to_x`閉包は`x`不変に借用`Fn`（ `equal_to_x`は`Fn`特性を持ち`Fn`）。

閉包が強制的に環境内で使用する値の所有権を取得するように`move`には、パラメータリストの前に`move`予約語を使用します。
この技法は、データを移動して新しい走脈が所有するように閉包を新しい走脈に渡すときに最も役立ちます。

並行処理については、第16章で`move` closureの例をさらに導入します。
今のところ、リスト13-12の譜面では、`move`予約語を閉包定義に追加し、整数の代わりにベクトルを使用します。これは、整数を移動するのではなくコピーすることができるためです。
この譜面はまだ製譜されません。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
fn main() {
    let x = vec![1, 2, 3];

    let equal_to_x = move |z| z == x;

    println!("can't use x here: {:?}", x);

    let y = vec![1, 2, 3];

    assert!(equal_to_x(y));
}
```

次の誤りが表示されます。

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

`x`値は閉包が定義されたときに閉包に`move`されます。これは`move`予約語が追加されたためです。
次に、閉包は`x`所有権を持ち、`main`は`println!`文で`x`もう使用することはできません。
`println!`削除すると、この例が修正されます。

一つを指定する時間のほとんど`Fn`特性縛りは、あなたが始めることができる`Fn`とあなたが必要な場合、製譜器はあなたを教えてくれます`FnMut`または`FnOnce`閉包体に何が起こるかに基づきます。

環境を捕獲できる閉包が機能パラメータとして有用な状況を説明するために、次の話題、反復子に移りましょう。
