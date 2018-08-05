## `Result`回復可能な<ruby>誤り<rt>エラー</rt></ruby>

ほとんどの<ruby>誤り<rt>エラー</rt></ruby>は、<ruby>算譜<rt>プログラム</rt></ruby>が完全に停止するのに十分な深刻なものではありません。
時には、機能が失敗すると、それはあなたが簡単に解釈して応答できるという理由からです。
たとえば、ファイルを開こうとしたときにそのファイルが存在しないために操作が失敗した場合は、過程を終了する代わりにファイルを作成することができます。

「 [`Result`型による潜在的な障害の処理][handle_failure] 」を思い出してください。
 第2章では、`Result`列挙型は、`Ok`と`Err`という2つの<ruby>場合値<rt>バリアント</rt></ruby>を持つと定義されています。

[handle_failure]: ch02-00-guessing-game-tutorial.html#handling-potential-failure-with-the-result-type

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`T`と`E`は総称型のパラメータです。総称化については第10章でより詳しく説明します。今知る必要があるのは、`T`は`Ok`<ruby>場合値<rt>バリアント</rt></ruby>内で成功のケースで返される値の型を表し、`E`は`Err`<ruby>場合値<rt>バリアント</rt></ruby>内の`Err`場合に返される<ruby>誤り<rt>エラー</rt></ruby>の型を表します。
`Result`はこれらの総称型パラメータがあるため、`Result`型と、標準<ruby>譜集<rt>ライブラリー</rt></ruby>が定義している機能を使用することができます。戻り値と<ruby>誤り<rt>エラー</rt></ruby>値が異なる場合があります。

機能が失敗する可能性があるため、`Result`値を返す機能を呼び出しましょう。
<ruby>譜面<rt>コード</rt></ruby>リスト9-3では、ファイルを開こうとしています。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");
}
```

<span class="caption">リスト9-3。ファイルを開く</span>

`File::open`が`Result`返す方法を知るには？　
標準<ruby>譜集<rt>ライブラリー</rt></ruby>APIの開発資料を見ることができますか、<ruby>製譜器<rt>コンパイラー</rt></ruby>に尋ねることができます！　
与えた場合`f`、機能の戻り値の型で*はありません*知っているし、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>しようとする型の<ruby>注釈<rt>コメント</rt></ruby>は、<ruby>製譜器<rt>コンパイラー</rt></ruby>は型が一致しないことを私たちに教えてくれます。
<ruby>誤り<rt>エラー</rt></ruby>メッセージは、その後の型を教えます`f` *あります*。
試してみよう！　
`File::open`戻り値の型は`u32`型ではないので、`let f`文をこれに変更し`let f`。

```rust,ignore
let f: u32 = File::open("hello.txt");
```

今<ruby>製譜<rt>コンパイル</rt></ruby>しようとすると、次のような出力が得られます。

```text
error[E0308]: mismatched types
 --> src/main.rs:4:18
  |
4 |     let f: u32 = File::open("hello.txt");
  |                  ^^^^^^^^^^^^^^^^^^^^^^^ expected u32, found enum
`std::result::Result`
  |
  = note: expected type `u32`
             found type `std::result::Result<std::fs::File, std::io::Error>`
```

これは、`File::open`機能の戻り値の型が`Result<T, E>`ます。
総称化パラメータ`T`は、ここで成功値の型`std::fs::File`（ファイル<ruby>手綱<rt>ハンドル</rt></ruby>）で埋められています。
<ruby>誤り<rt>エラー</rt></ruby>値に使用される`E`の型は`std::io::Error`です。

この戻り値の型は、`File::open`への呼び出しが成功し、読み書き可能なファイル<ruby>手綱<rt>ハンドル</rt></ruby>を返すことを意味します。
機能呼び出しも失敗する可能性があります。たとえば、ファイルが存在しないか、ファイルにアクセスする権限がないなどです。
`File::open`機能には、成功したか失敗したかを示す方法が必要です。同時に、ファイル<ruby>手綱<rt>ハンドル</rt></ruby>または<ruby>誤り<rt>エラー</rt></ruby>情報のいずれかを与えます。
この情報は、`Result` enumが伝えるものとまったく同じです。

`File::open`が成功した場合、変数`f`値はファイル<ruby>手綱<rt>ハンドル</rt></ruby>を含む`Ok`<ruby>実例<rt>インスタンス</rt></ruby>になります。
失敗した場合、`f`の値は、発生した<ruby>誤り<rt>エラー</rt></ruby>の種類に関する詳細情報を含む`Err`<ruby>実例<rt>インスタンス</rt></ruby>になります。

リスト9-3の<ruby>譜面<rt>コード</rt></ruby>に、`File::open`値に応じて異なる動作を取るために追加する必要があります。
リスト9-4は、基本的な道具である第6章で説明した`match`式を使用して`Result`を処理する方法の1つを示しています。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => {
            panic!("There was a problem opening the file: {:?}", error)
        },
    };
}
```

<span class="caption">リスト9-4。 <code>match</code>式を使用して返される可能性のある<code>Result</code>場合値を処理する</span>

同様に、なお`Option`列挙型、`Result`列挙型とその亜種はプレリュードに<ruby>輸入<rt>インポート</rt></ruby>されているので、指定する必要はありません`Result::`前に、`Ok`し、`Err`中<ruby>場合値<rt>バリアント</rt></ruby>`match`分岐。

ここでは、結果があるときというRustを教えて`Ok`、インナー返す`file`のうち、値を`Ok`<ruby>場合値<rt>バリアント</rt></ruby>、その後、変数にそのファイル<ruby>手綱<rt>ハンドル</rt></ruby>値を割り当て`f`。
`match`後、ファイル<ruby>手綱<rt>ハンドル</rt></ruby>を読み書きすることができます。

`match`のもう一方の分岐は、`File::open`から`Err`値を取得するケースを処理し`File::open`。
この例では、`panic!`マクロを呼び出すことにしました。
現在のディレクトリに*hello.txt*という名前のファイルがなく、この<ruby>譜面<rt>コード</rt></ruby>を実行すると、`panic!`マクロから次の出力が表示されます。

```text
thread 'main' panicked at 'There was a problem opening the file: Error { repr:
Os { code: 2, message: "No such file or directory" } }', src/main.rs:9:12
```

いつものように、この出力は何が間違っているかを正確に教えてくれます。

### さまざまな<ruby>誤り<rt>エラー</rt></ruby>での照合

リスト9-4の<ruby>譜面<rt>コード</rt></ruby>は、`File::open`失敗した理由に関係なく、`panic!`ます。
ファイルが存在しないために`File::open`失敗した場合、ファイルを作成して新しいファイルに<ruby>手綱<rt>ハンドル</rt></ruby>を戻したいと考えています。
`File::open`が他の理由で失敗した場合（たとえば、ファイルを開く権限がないなど）、リスト9-4と同じ方法で<ruby>譜面<rt>コード</rt></ruby>を`panic!`ます。
リスト9-5を見てください。これは、`match`別の分岐を追加します。

<span class="filename">ファイル名。src/main.rs</span>


```rust,ignore
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(ref error) if error.kind() == ErrorKind::NotFound => {
            match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => {
                    panic!(
                        "Tried to create file but there was a problem: {:?}",
                        e
                    )
                },
            }
        },
        Err(error) => {
            panic!(
                "There was a problem opening the file: {:?}",
                error
            )
        },
    };
}
```

<span class="caption">譜面リスト9-5。さまざまな種類の<ruby>誤り<rt>エラー</rt></ruby>をさまざまな方法で処理する</span>

`Err`<ruby>場合値<rt>バリアント</rt></ruby>の中で`File::open`が返す値の型は`io::Error`。これは標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供される構造体です。
この構造体には、<ruby>操作法<rt>メソッド</rt></ruby>がある`kind`、取得するために呼び出すことができ`io::ErrorKind`値を。
enum `io::ErrorKind`は標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって提供され、`io`操作の結果として生じるさまざまな種類の<ruby>誤り<rt>エラー</rt></ruby>を表す<ruby>場合値<rt>バリアント</rt></ruby>を持っています。
使用する<ruby>場合値<rt>バリアント</rt></ruby>は`ErrorKind::NotFound`。これは、開こうとしているファイルがまだ存在しないことを示します。

`if error.kind() == ErrorKind::NotFound`が*マッチガード*と呼ばれる場合の条件は、`match`分岐の余分な条件であり、分岐のパターンをさらに洗練させます。
この条件は、その分岐の<ruby>譜面<rt>コード</rt></ruby>を実行するためには真でなければなりません。
そうでない場合、<ruby>模式<rt>パターン</rt></ruby>照合は、内の次の分岐を検討する上で移動する`match`。
パターン内の`ref`が必要なので、`error`はガード条件に移動せずに単に参照されます。
`&` `ref`代わりに`ref`を使って第18章でパターンを参照する理由は、第18章で詳しく説明します。パターンの文脈では`&`は参照と一致し、その値を`ref`ますが、`ref`は値と一致します。あなたにそれへの参照を与えます。

マッチガードでチェックしたい条件は、`error.kind()`によって返された値が`ErrorKind` enumの`NotFound`<ruby>場合値<rt>バリアント</rt></ruby>かどうかです。
そうであれば、`File::create`を使ってファイルを作成しようとし`File::create`。
しかし、`File::create`も失敗`File::create`可能性があるため、内部`match`式も追加する必要があります。
ファイルを開くことができない場合は、別の<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。
外側の`match`の最後の分岐は同じままであり、ファイル<ruby>誤り<rt>エラー</rt></ruby>以外の<ruby>誤り<rt>エラー</rt></ruby>でも<ruby>算譜<rt>プログラム</rt></ruby>はパニックに陥ります。

### パニック<ruby>誤り<rt>エラー</rt></ruby>の近道。 `unwrap` and `expect`

`match`を使用すると十分に機能しますが、少し冗長になり、必ずしも意図的に通信するとは限りません。
`Result<T, E>`型には、さまざまな仕事を実行するための多くの補助譜<ruby>操作法<rt>メソッド</rt></ruby>が定義されています。
`unwrap`と呼ばれる<ruby>操作法<rt>メソッド</rt></ruby>の1つは、リスト9-4で書いた`match`式のように実装された近道<ruby>操作法<rt>メソッド</rt></ruby>です。
`Result`値が`Ok`<ruby>場合値<rt>バリアント</rt></ruby>の場合、`unwrap`は`Ok`内の値を返します。
`Result`が`Err`<ruby>場合値<rt>バリアント</rt></ruby>の場合、`unwrap`は`panic!`マクロのために呼び出します。
実行中の`unwrap`例を次に示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap();
}
```

*hello.txt*ファイルなしでこの<ruby>譜面<rt>コード</rt></ruby>を実行すると、`unwrap`<ruby>操作法<rt>メソッド</rt></ruby>が行う`panic!`呼び出しからの<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。

```text
thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: Error {
repr: Os { code: 2, message: "No such file or directory" } }',
src/libcore/result.rs:906:4
```

`unwrap`に似ているもう1つの<ruby>操作法<rt>メソッド</rt></ruby>`expect`は、`panic!`<ruby>誤り<rt>エラー</rt></ruby>メッセージを選択することもできます。
`unwrap`代わりに`expect`を使用`expect`、良い<ruby>誤り<rt>エラー</rt></ruby>メッセージを提供すると、意図を伝えることができ、パニックの原因を簡単に追跡することができます。
`expect`の構文は次のようになります。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

`unwrap`と同じ方法で`expect`を使用`expect`ます。ファイル<ruby>手綱<rt>ハンドル</rt></ruby>を返すか`panic!`呼び出します。
`panic!`への呼び出しで`expect`で使用される<ruby>誤り<rt>エラー</rt></ruby>メッセージは、`unwrap`使用する<ruby>黙用<rt>デフォルト</rt></ruby>の`panic!`メッセージではなく、`expect`に渡すパラメータになります。
以下はその様子です。

```text
thread 'main' panicked at 'Failed to open hello.txt: Error { repr: Os { code:
2, message: "No such file or directory" } }', src/libcore/result.rs:906:4
```

この<ruby>誤り<rt>エラー</rt></ruby>メッセージは、指定したテキストで始まり、`Failed to open hello.txt`、この<ruby>誤り<rt>エラー</rt></ruby>メッセージがどこから来たのかを簡単に見つけることができます。
複数の場所で`unwrap`を使用すると、同じメッセージをパニックするすべての`unwrap`呼び出しが発生するため、どの`unwrap`がパニックを引き起こしているかを正確に把握するのに時間がかかることがあります。

### 伝播<ruby>誤り<rt>エラー</rt></ruby>

この機能内で<ruby>誤り<rt>エラー</rt></ruby>を処理する代わりに、実装が失敗する可能性のある呼び出しを呼び出す機能を書くときに、<ruby>誤り<rt>エラー</rt></ruby>を呼び出し<ruby>譜面<rt>コード</rt></ruby>に戻して何をすべきかを決定することができます。
これは、<ruby>誤り<rt>エラー</rt></ruby>を*伝播*するものとして知られており、<ruby>譜面<rt>コード</rt></ruby>の文脈で使用可能なものより<ruby>誤り<rt>エラー</rt></ruby>を処理する方法を指示する情報や<ruby>論理<rt>ロジック</rt></ruby>がある場合、呼び出し<ruby>譜面<rt>コード</rt></ruby>をより詳細に制御できます。

たとえば、<ruby>譜面<rt>コード</rt></ruby>リスト9-6は、ファイルから利用者名を読み取る機能を示しています。
ファイルが存在しないか、読み取れない場合、この機能はこれらの<ruby>誤り<rt>エラー</rt></ruby>をこの機能を呼び出した<ruby>譜面<rt>コード</rt></ruby>に返します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");

    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut s = String::new();

    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

<span class="caption">譜面リスト9-6。 <code>match</code>を使って呼び出し元の<ruby>譜面<rt>コード</rt></ruby>に<ruby>誤り<rt>エラー</rt></ruby>を返す機能</span>

最初に機能の戻り値の型を`Result<String, io::Error>`。
これは、機能が`Result<T, E>`型の値を返すことを意味します。ここで、総称化パラメータ`T`は具体的な型`String`で埋められ、総称型`E`は具象型`io::Error`埋められています。
この機能が問題なく成功すると、この機能を呼び出す<ruby>譜面<rt>コード</rt></ruby>は、この機能がファイルから読み取った利用者名である`String`を保持する`Ok`値を受け取ります。
この機能が何らかの問題に遭遇した場合、この機能を呼び出す<ruby>譜面<rt>コード</rt></ruby>は、問題の内容に関する詳細情報を含む`io::Error`<ruby>実例<rt>インスタンス</rt></ruby>を保持する`Err`値を受け取ります。
この機能の戻り値の型として`io::Error`を選択しました。これは、この機能の本体で呼び出されている両方の操作から返される<ruby>誤り<rt>エラー</rt></ruby>値の型であるためです。 `File::open`機能と`read_to_string`<ruby>操作法<rt>メソッド</rt></ruby>。

機能の本体は、`File::open`機能を呼び出すことによって開始します。
リスト9-4の`match`に似た`match`返された`Result`値を処理します`Err`ケースで`panic!`を呼び出すのではなく、この機能から早く戻り、`File::open`<ruby>誤り<rt>エラー</rt></ruby>値を<ruby>譜面<rt>コード</rt></ruby>をこの機能の<ruby>誤り<rt>エラー</rt></ruby>値として呼び出します。
`File::open`が成功すると、ファイル<ruby>手綱<rt>ハンドル</rt></ruby>を変数`f`格納して処理を続行します。

次に、変数`s`新しい`String`を作成し、`f`のファイル<ruby>手綱<rt>ハンドル</rt></ruby>の`read_to_string`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出して、ファイルの内容を`s`読み込みます。
`read_to_string`<ruby>操作法<rt>メソッド</rt></ruby>は、`File::open`成功したにもかかわらず失敗する可能性があるため、`Result`も返します。
だから他の必要な`match`その処理するために`Result`次の場合`read_to_string`成功し、その後、機能が成功した、と今のファイルから利用者名を返す`s`に包まれて`Ok`。
`read_to_string`が失敗した場合、`File::open`戻り値を処理した`match`で<ruby>誤り<rt>エラー</rt></ruby>値を返したのと同じ方法で<ruby>誤り<rt>エラー</rt></ruby>値を返します。
しかし、機能の最後の式であるため、`return`を明示的に言う必要はありません。

この<ruby>譜面<rt>コード</rt></ruby>を呼び出す<ruby>譜面<rt>コード</rt></ruby>は、利用者名を含む`Ok`値または`io::Error`を含む`Err`値のいずれかを取得して処理します。
これらの値で呼び出し側の<ruby>譜面<rt>コード</rt></ruby>が何をするかはわかりません。
呼び出し元の<ruby>譜面<rt>コード</rt></ruby>が`Err`値を取得した場合、`panic!`て<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>異常終了<rt>クラッシュ</rt></ruby>させたり、<ruby>黙用<rt>デフォルト</rt></ruby>の利用者名を使用したり、ファイル以外の利用者名を参照することができます。
呼び出し元<ruby>譜面<rt>コード</rt></ruby>が実際に何をしようとしているかについて十分な情報がないため、すべての成功または<ruby>誤り<rt>エラー</rt></ruby>の情報を上向きに伝播して適切に処理します。

この伝播<ruby>誤り<rt>エラー</rt></ruby>のパターンは、Rustが疑問符演算子を提供するほど一般的`?`
これをより簡単にします。

#### 伝播<ruby>誤り<rt>エラー</rt></ruby>の近道。 `?`
リスト9-7は、リスト9-6と同じ機能を持つ`read_username_from_file`実装を示していますが、この実装では`?`
演算子。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```

<span class="caption">リスト9-7。使用して呼び出し元の<ruby>譜面<rt>コード</rt></ruby>に<ruby>誤り<rt>エラー</rt></ruby>を返す機能<code>?</code></span>
<span class="caption">演算子</span>

`?`
後に置か`Result`値はほぼ同じ方法で動作するように定義されている`match`扱うように定義された式の`Result`リスト9-6の値を。
`Result`の値が`Ok`の場合、`Ok`内の値がこの式から返され、<ruby>算譜<rt>プログラム</rt></ruby>は続行されます。
値がある場合`Err`、内部値`Err`、使用していたかのように全体の機能から返される`return`<ruby>誤り<rt>エラー</rt></ruby>値は、呼び出し元の<ruby>譜面<rt>コード</rt></ruby>に伝播されますので、予約語を。

リスト9-6の`match`式と`?`
演算子do。<ruby>誤り<rt>エラー</rt></ruby>値は`?`
ある型から別の型への<ruby>誤り<rt>エラー</rt></ruby>を変換するために使用される、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`From`<ruby>特性<rt>トレイト</rt></ruby>で定義された`from`機能を実行します。
いつ`?`
演算子が`from`機能を呼び出すと、受け取った<ruby>誤り<rt>エラー</rt></ruby>・型が現行機能の戻り型で定義されている<ruby>誤り<rt>エラー</rt></ruby>・型に変換されます。
これは、機能が多くの異なる理由で失敗する可能性がある場合でも、機能が失敗する可能性のあるすべての方法を表す1つの<ruby>誤り<rt>エラー</rt></ruby>型を返す場合に便利です。
それぞれの<ruby>誤り<rt>エラー</rt></ruby>型が`from`機能を実装して、返された<ruby>誤り<rt>エラー</rt></ruby>型に変換する方法を定義する限り、`?`
演算子は自動的に変換を処理します。

リスト9-7の文脈では`?`
`File::open`呼び出しの終わりに、`Ok`中の値を変数`f`返します。
<ruby>誤り<rt>エラー</rt></ruby>が発生した場合、`?`
演算子は機能全体から早期に戻り、呼び出し<ruby>譜面<rt>コード</rt></ruby>に`Err`値を与えます。
同じことが`?`
`read_to_string`呼び出しの終わりに。

`?`
演算子は多くの定型文を削除し、この機能の実装を簡単にします。
この<ruby>譜面<rt>コード</rt></ruby>をさらに短縮することもでき`?`
リスト9-8を参照してください。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();

    File::open("hello.txt")?.read_to_string(&mut s)?;

    Ok(s)
}
```

<span class="caption">9-8のリスト。後<ruby>操作法<rt>メソッド</rt></ruby>呼び出しの連鎖<code>?</code></span>
<span class="caption">演算子</span>

新しいの創造移動した`String`中`s`機能の先頭にします。
その部分は変更されていません。
変数`f`を作成するのではなく、`File::open("hello.txt")?`の結果に`read_to_string`の呼び出しを直接`read_to_string`しました`File::open("hello.txt")?`
。
まだ`?`
`read_to_string`呼び出しの終わりで、`File::open`と`read_to_string`両方が<ruby>誤り<rt>エラー</rt></ruby>を返すのではなく成功したときに`s`に利用者名を含む`Ok`値を返します。
この機能はリスト9-6とリスト9-7と同じです。
これはちょうど異なった、より使い勝手のよいでそれを書くことです。

#### `?`
`?`
演算子は、リスト9-6で定義した`match`式と同じ方法で動作するように定義されているので、戻り値の型が`Result`である機能でのみ使用できます。
戻り値の型の`Result`が必要な`match`部分は`return Err(e)`なので、機能の戻り値の型はこの`return`と互換性がある`Result`なければなりません。

`?`を使うとどうなるのか見てみましょう`?`
`main`機能のoperatorには戻り値の型`()`ます。

```rust,ignore
use std::fs::File;

fn main() {
    let f = File::open("hello.txt")?;
}
```

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>すると、次の<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。

```text
error[E0277]: the trait bound `(): std::ops::Try` is not satisfied
 --> src/main.rs:4:13
  |
4 |     let f = File::open("hello.txt")?;
  |             ------------------------
  |             |
  |             the `?` operator can only be used in a function that returns
  `Result` (or another type that implements `std::ops::Try`)
  |             in this macro invocation
  |
  = help: the trait `std::ops::Try` is not implemented for `()`
  = note: required by `std::ops::Try::from_error`
```

この<ruby>誤り<rt>エラー</rt></ruby>は、使用することが許されていることを指摘しています`?`
`Result`を返す機能で演算子を使用します。
`Result`返さない機能では、`Result`を返す他の機能を呼び出すときには、`match`または`Result`<ruby>操作法<rt>メソッド</rt></ruby>の1つを使用して`?`を使用する代わりに`Result`を処理する必要があります`?`
呼び出し側<ruby>譜面<rt>コード</rt></ruby>に<ruby>誤り<rt>エラー</rt></ruby>を伝播させる可能性があります。

`panic!`や`Result`の返信の詳細については既に説明しましたが、どのケースで適切に使用するかを決める方法の話題に戻りましょう。
