## 単一走脈Web提供機の構築

まず、単一走脈のWeb提供機を動作させることから始めます。
はじめに、Web提供機の構築に関わる約束事の概要を見ていきましょう。
これらの約束事の詳細は本書の範囲を超えていますが、必要な情報が簡単に表示されます。

Web提供機に関連する2つの主な約束事は、*HTTP（* *Hypertext Transfer Protocol* *）*と*TCP（* *Transmission Control Protocol* *）*です。
どちらの約束事も*要求応答*約束事で、*クライアント*が要求を開始し、*提供機*が要求をリッスンしてクライアントに応答を提供します。
これらの要求と応答の内容は、約束事によって定義されます。

TCPは、ある提供機から別の提供機に情報を取得する方法の詳細を記述する低水準の約束事ですが、その情報が何であるかは指定していません。
HTTPは、要求と応答の内容を定義することによって、TCPの上に構築されます。
HTTPを他の約束事と併用することは技術的に可能ですが、大部分の場合、HTTPはTCP経由でデータを送信します。
TCPとHTTPリクエストと応答の生のバイトを扱います。

### TCP接続のリッスン

Web提供機はTCP接続を聞く必要があります。これが最初に作業する部分です。
標準譜集は、これを可能にする`std::net`役区を提供しています。
通常の方法で新しい企画を作ってみましょう。

```text
$ cargo new hello --bin
     Created binary (application) `hello` project
$ cd hello
```

リスト20-1の譜面を*src/main.rsに入力*して開始します。
この譜面は、着信TCPストリームの番地`127.0.0.1:7878`でリッスンします。
着信ストリームを取得すると、`Connection established!`ます。

<span class="filename">ファイル名。src/main.rs</span>

```rust,no_run
use std::net::TcpListener;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        println!("Connection established!");
    }
}
```

<span class="caption">リスト20-1。受信したストリームをリッスンし、ストリームを受信したときにメッセージを出力する</span>

`TcpListener`を使用して、番地`127.0.0.1:7878` TCP接続を`TcpListener`できます。
番地では、コロンの前の章は、お使いの計算機を表すIP番地です（これはすべての計算機で同じで、作成者の計算機を特に表すものではありません）`7878`はポートです。
HTTPは、通常、このポートで受け入れられ、および7878は、電話に入力された*Rust*である。2つの理由から、このポートを選択しました。

この場合の`bind`機能は、新しい`TcpListener`実例を返すという点で、`new`機能と同様に機能します。
この機能が`bind`と呼ばれる理由は、ネットワーキングでは、listenするポートに接続することを「ポートへの束縛」と呼びます。

`bind`機能は、束縛が失敗する可能性があることを示す`Result<T, E>`返します。
たとえば、ポート80に接続するには管理者権限が必要です（非管理者は1024以上のポートでしか聞くことができません）。したがって、管理者でなくてもポート80に接続しようとすると束縛は機能しません。
別の例として、算譜の2つの実例を実行し、同じポートをリッスンする2つの算譜がある場合、束縛は機能しません。
学習目的のためだけに基本的な提供機を作成しているので、この種の誤りの処理については心配しません。
代わりに、誤りが発生した場合に`unwrap`を使用して算譜を停止します。

`TcpListener`の`incoming`操作法は、一連のストリーム（より具体的には、`TcpStream`型のストリーム）を返す反復子を返します。
単一の*ストリーム*は、クライアントと提供機の間のオープンな接続を表します。
*接続*とは、クライアントが提供機に接続し、提供機が応答を生成し、提供機が接続を閉じる完全な要求および応答過程の名前です。
そのため、`TcpStream`はクライアントから何を送信したかを確認し、応答をストリームに書き込むことができます。
全体として、この`for`ループは順番に各接続を処理し、処理する一連のストリームを生成します。

今のところ、ストリームの処理では、ストリームに誤りがあれば算譜を終了するために`unwrap`を呼び出すことからなります。
誤りがなければ、算譜はメッセージを出力します。
次のリストに成功例の機能を追加します。
クライアントが提供機に接続するときに`incoming`操作法から誤りを受け取る理由は、実際に接続を繰り返すわけではないからです。
代わりに、*接続の試行を*繰り返してい*ます*。
多くの理由で、基本算系固有の多くの理由で、接続が成功しない可能性があります。
たとえば、多くの基本算系では、サポートできる同時オープン接続の数に制限があります。
その番号を超えて新しい接続を試みると、開いている接続の一部が閉じられるまで誤りが発生します。

この譜面を実行しよう！　
端末で`cargo run`してから、ウェブブラウザで*127.0.0.1。7878*を読み込みします。
提供機が現在データを返送していないため、ブラウザに「Connection reset」のような誤りメッセージが表示されるはずです。
しかし、端末を見ると、ブラウザが提供機に接続されているときにいくつかのメッセージが表示されるはずです。

```text
     Running `target/debug/hello`
Connection established!
Connection established!
Connection established!
```

1つのブラウザ要求に対して複数のメッセージが表示されることがあります。
その理由は、ブラウザーがページの要求とブラウザー・タブに表示される*favicon.ico*アイコンのような他の資源の要求をしているためです。

また、提供機が何のデータでも応答していないため、ブラウザーが提供機に複数回接続しようとしている可能性があります。
`stream`が有効範囲外になり、ループの最後に`drop`されると、接続は`drop`実装の一部として閉じられます。
ブラウザーは、問題が一時的である可能性があるため、再試行によってクローズされた接続を処理することがあります。
重要な要素は、TCP接続の処理に成功したことです。

特定の版の譜面の実行が終了したら、<span class="keystroke">ctrl-cを</span>押して算譜を停止することを忘れないでください。
次に、最新の譜面を実行していることを確認するために、各譜面セットを変更した後で、`cargo run`再開します。

### リクエストを読む

ブラウザからリクエストを読み込む機能を実装しましょう！　
最初に接続を取得してから接続で何らかの動作をとることを避けるために、接続処理のための新しい機能を開始します。
この新しい`handle_connection`機能では、TCPストリームからデータを読み取り、それを印字してブラウザから送信されたデータを見ることができます。
リスト20-2のように譜面を変更します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,no_run
use std::io::prelude::*;
use std::net::TcpStream;
use std::net::TcpListener;

fn main() {
    let listener = TcpListener::bind("127.0.0.1:7878").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 512];

    stream.read(&mut buffer).unwrap();

    println!("Request: {}", String::from_utf8_lossy(&buffer[..]));
}
```

<span class="caption">リスト20-2。 <code>TcpStream</code>からの<code>TcpStream</code>とデータの印字</span>

`std::io::prelude`を有効範囲に持っていくことで、ストリームの読み書きを可能にする特定の特性にアクセスできます。
`main`機能の`for`ループでは、接続したことを示すメッセージを出力する代わりに、新しい`handle_connection`機能を呼び出して`stream`を渡し`stream`。

`handle_connection`機能では、`stream`パラメータを変更可能にしました。
その理由は、`TcpStream`実例が内部的に私たちに返すデータを追跡するからです。
求めたデータよりも多くのデータを読んで、次にデータを要求するときにそのデータを保存するかもしれません。
したがって、内部状態が変化する可能性があるため、`mut`ある必要があります。
通常は、「読み込み」は変更を必要としないと考えますが、この場合は`mut`予約語が必要です。

次に、実際にストリームから読み込む必要があります。
これは、まず2つのステップで行います。まず、読み込まれたデータを保持する`buffer`を山に宣言します。バッファのサイズを512バイトにしました。これは、基本要求のデータを保持するのに十分な大きさであり、この章の目的のために。
任意のサイズのリクエストを処理したい場合、バッファ管理はより複雑になる必要があります。
今それを簡単に保つつもりです。
バッファを`stream.read`。これは、 `TcpStream`からバイトを読み込み、バッファに格納します。

次に、バッファ内のバイトを文字列に変換して出力します。
`String::from_utf8_lossy`機能は`&[u8]`をとり、そこから`String`を生成します。
それは不正なUTF-8シーケンスを見ているときに名前の「不可逆」の部分は、この機能の動作を示しています。それは、と無効な配列を置換します`U+FFFD REPLACEMENT CHARACTER`。
要求データで満たされていないバッファ内の文字の置換文字が表示されることがあります。

この譜面を試してみましょう！　
算譜を起動して、Webブラウザでリクエストをもう一度行います。
ブラウザにも誤りページが表示されますが、端末での算譜の出力は次のようになります。

```text
$ cargo run
   Compiling hello v0.1.0 (file:///projects/hello)
    Finished dev [unoptimized + debuginfo] target(s) in 0.42 secs
     Running `target/debug/hello`
Request: GET/HTTP/1.1
Host: 127.0.0.1:7878
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
Firefox/52.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
                                    
```

お使いのブラウザによっては、出力が多少異なる場合があります。
要求データを印字するので、`Request: GET`後のパスを調べることで、1つのブラウザ要求から複数の接続を取得する理由がわかります。
繰り返される接続がすべて*/*を要求している場合、ブラウザが算譜からの応答を得ていないので、ブラウザがフェッチ*/*繰り返しを試みていることがわかります。

このリクエストデータを分解して、ブラウザが算譜に対して求めていることを理解してみましょう。

### HTTPリクエストの詳細

HTTPはテキストベースの約束事であり、要求は次の形式をとります。

```text
Method Request-URI HTTP-Version CRLF
headers CRLF
message-body
```

最初の行は、クライアントが要求しているものに関する情報を保持する*要求行*です。
要求行の最初の部分は、クライアントがこの要求をどのようにしているかを記述する`GET`や`POST`など、使用されている*操作法を*示します。
クライアントは`GET`リクエストを使用しました。

要求行の次の部分は*/です*。これは、クライアントが要求しているURI *（* *Uniform Resource Identifier* *）*を示し*ます。URL*はほぼ同じではありませんが、*Uniform Resource Locator* *（URL）*とほとんど同じです。
URIとURLの違いはこの章の目的では重要ではありませんが、HTTP仕様ではURIという用語が使用されています。

最後の部分は、クライアントが使用するHTTP版であり、要求行は*CRLFシーケンスで*終了し*ます*。
（CRLFは*キャリッジリターン*と*改行*を表しますが、型ライターの日からの用語です）。CRLFシーケンスは`\r\n`と書くこともできます。`\r`はキャリッジリターン、`\n`は行フィードです。
CRLFシーケンスは、要求行を残りの要求データから分離します。
CRLFが印字されると、`\r\n`ではなく新しい行が開始されることに注意してください。

これまでの算譜の実行から得られたリクエスト行データを見ると、`GET`が操作法、*/*はリクエストURI、`HTTP/1.1`は版です。

要求行の後、`Host:`以降を始める残りの行はヘッダーです。
`GET`リクエストには本文がありません。

別のブラウザからリクエストを行うか、*127.0.0.1:7878/test*などの別の番地をリクエストしてリクエストデータの変更方法を確認してください。

ブラウザが何を求めているのか分かったので、それ用のデータを送り返しましょう！　

### レスポンスの作成

次に、クライアントからの要求に応じてデータを送信する実装を行います。
レスポンスの形式は次のとおりです。

```text
HTTP-Version Status-Code Reason-Phrase CRLF
headers CRLF
message-body
```

最初の行は、応答、要求の結果を要約する数値結果番号、および結果番号のテキスト説明を提供する理由句で使用されるHTTPの版が含まれている*ステータス行*です。
CRLFシーケンスの後には、ヘッダー、別のCRLFシーケンス、および応答本体があります。

HTTP版1.1を使用し、結果番号200、OK理由フレーズ、ヘッダーなし、本文なしのレスポンスの例を次に示します。

```text
HTTP/1.1 200 OK\r\n\r\n
```

結果番号200が標準的な成功応答です。
テキストは小さな成功したHTTPレスポンスです。
成功したリクエストに対する応答として、これをストリームに書きましょう！　
`handle_connection`機能から、リクエストデータを出力していた`println!`削除し、リスト20-3の譜面に置き換えます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::io::prelude::*;
# use std::net::TcpStream;
fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 512];

    stream.read(&mut buffer).unwrap();

    let response = "HTTP/1.1 200 OK\r\n\r\n";

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}
```

<span class="caption">リスト20-3。小さな成功したHTTPレスポンスをストリームに書き込む</span>

最初の改行は、成功メッセージのデータを保持する`response`変数を定義します。
次に、`response` `as_bytes`を呼び出して、文字列データをバイトに変換します。
`stream`上の`write`操作法は`&[u8]`を取り、それらのバイトを直接接続の下に送ります。

`write`操作が失敗する可能性があるため、以前と同様に誤り結果に対して`unwrap`を使用します。
ここでも、実際の譜体で誤り処理を追加します。
最後に、`flush`は待機し、すべてのバイトが接続に書き込まれるまで算譜が続かないようにします。
`TcpStream`は、基になる基本算系への呼び出しを最小限に抑えるための内部バッファが含まれています。

これらの変更により、譜面を実行してリクエストを行いましょう。
もはや端末にデータを印字していないので、Cargoからの出力以外の出力は表示されません。
Webブラウザで*127.0.0.1。7878*を読み込むと、誤りではなく空白のページが表示されます。
HTTPリクエストとレスポンスを手作業で作譜しただけです！　

### リアルHTMLを返す

ブランクページ以上を返す機能を実装しましょう。
*src*階層ではなく、企画階層のルートに新しいファイル*hello.htmlを*作成します。
必要なHTMLを入力できます。
リスト20-4は1つの可能性を示しています。

<span class="filename">ファイル名。hello.html</span>

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hello!</title>
  </head>
  <body>
    <h1>Hello!</h1>
    <p>Hi from Rust</p>
  </body>
</html>
```

<span class="caption">リスト20-4。レスポンスで返すサンプルHTMLファイル</span>

これは見出しとテキストを含む最小限のHTML5文書です。
要求を受け取ったときにこれを提供機から戻すには、リスト20-5に示すように`handle_connection`を変更して、HTMLファイルを読み込んで本文として応答に追加して送信します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::io::prelude::*;
# use std::net::TcpStream;
use std::fs::File;
#// --snip--
//  --snip--

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();

    let mut file = File::open("hello.html").unwrap();

    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();

    let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}
```

<span class="caption">リスト20-5。 <em>hello.html</em>の内容を<em>レスポンスの本文</em>として送信する</span>

一番上に標準譜集の`File`を入れるための行を追加しました。
ファイルを開いて内容を読むための譜面はよく分かります。
リスト12-4のI/O企画のファイルの内容を読むときには、第12章でそれを使用しました。

次に、ファイルの内容を成功応答の本文として追加するために、`format!`を使用し`format!`。

ブラウザでこの譜面を`cargo run`とload *127.0.0.1:7878*で`cargo run`してください。
HTMLが表示されるはずです！　

現在、`buffer`内のリクエストデータを無視し、HTMLファイルの内容を無条件に返送しています。
つまり、ブラウザで*127.0.0.1:7878/something-else*をリクエストすると、同じHTML応答が返されます。
当社の提供機は非常に限られており、ほとんどのWeb提供機ではありません。
リクエストに応じてレスポンスをカスタマイズし、*/*への整形式リクエストのHTMLファイルのみを返送します。

### 要求の検証と選択的応答

現在、Web提供機は、クライアントが要求したものに関係なく、HTMLファイルを返します。
のは、ブラウザがHTMLファイルを返す前に*/*要求していることを確認し、ブラウザが何かを要求した場合、誤りを返すための機能を追加してみましょう。
このためには、リスト20-6に示すように`handle_connection`を変更する必要があります。
この新しい譜面は、受信したリクエストの内容を、*/* lookのようなリクエストに対して知っているものと照らし合わせてチェックし、`if`および`else`段落を追加してリクエストを別々に扱います。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::io::prelude::*;
# use std::net::TcpStream;
# use std::fs::File;
#// --snip--
//  --snip--

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 512];
    stream.read(&mut buffer).unwrap();

    let get = b"GET/HTTP/1.1\r\n";

    if buffer.starts_with(get) {
        let mut file = File::open("hello.html").unwrap();

        let mut contents = String::new();
        file.read_to_string(&mut contents).unwrap();

        let response = format!("HTTP/1.1 200 OK\r\n\r\n{}", contents);

        stream.write(response.as_bytes()).unwrap();
        stream.flush().unwrap();
    } else {
#        // some other request
        // その他のリクエスト
    }
}
```

<span class="caption">リスト20-6。他のリクエストとリクエスト<em>/</em>ハンドリングのリクエストの照合</span>

まず、*/* requestに対応するデータを`get`変数にハード譜面します。
生のバイトをバッファに読み込んでいるので、内容データの先頭に`b""`文字列構文を追加して`get`をバイト列に変換します。
次に、`buffer`が`get`内のバイトで始まるかどうかをチェックし`get`。
そうであれば、*/*への整形式リクエストを受け取ったことを意味します。これは、HTMLファイルの内容を返す`if`段落で処理する成功例です。

`buffer`が`get`のバイトで始まら*ない*場合は、別の要求を受け取ったことを意味します。
他のすべてのリクエストに応答する譜面を`else`段落に追加します。

今すぐこの譜面を実行し、*127.0.0.1*。 *7878*をリクエストしてください。
*hello.htmlで* HTMLを取得する必要があります。
*127.0.0.1:7878/something-else*などの他のリクエストを行うと、リスト20-1とリスト20-2の譜面を実行したときに見たような接続誤りが発生します。

リスト20-7の譜面を`else`段落に追加して、要求の内容が見つからなかったことを示す結果番号404の応答を返します。
また、エンド利用者への応答を示すブラウザで描出するために、ページ用にいくつかのHTMLを返します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::io::prelude::*;
# use std::net::TcpStream;
# use std::fs::File;
# fn handle_connection(mut stream: TcpStream) {
# if true {
#// --snip--
//  --snip--

} else {
    let status_line = "HTTP/1.1 404 NOT FOUND\r\n\r\n";
    let mut file = File::open("404.html").unwrap();
    let mut contents = String::new();

    file.read_to_string(&mut contents).unwrap();

    let response = format!("{}{}", status_line, contents);

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}
# }
```

<span class="caption">20-7リスト。結果番号404と誤りページで応答<em>/</em>以外のものが要求された場合は</span>

ここでは、結果番号404のステータス行と、`NOT FOUND`理由フレーズが表示されます。
まだヘッダーを返さず、応答の本体は*404.html*ファイルのHTMLになります。
誤り・ページ用*hello.html*の横*404.htmlファイル*を作成する必要があります。
リスト20-8のサンプルHTMLを自由に使用しても構いません。

<span class="filename">ファイル名。404.html</span>

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Hello!</title>
  </head>
  <body>
    <h1>Oops!</h1>
    <p>Sorry, I don't know what you're asking for.</p>
  </body>
</html>
```

<span class="caption">リスト20-8。404応答で返送するページのサンプル内容</span>

これらの変更を加えて、提供機を再度実行してください。
*127.0.0.1:7878を*要求すると*、hello.html*の内容、およびその他の要求を返す必要があります*127.0.0.1:7878/foo*のように*、404.html*からの誤りHTMLを返す必要があります。

### リファクタリングのタッチ

現時点では、`if`段落と`else`段落には多くの繰り返しがあります。ファイルを読み込んでいて、ファイルの内容をストリームに書き込んでいます。
唯一の違いは、ステータス行とファイル名です。
これらの違いを`if`と`else`別々の行に引き出し、ステータス行の値とファイル名を変数に割り当てることで、譜面をより簡潔にしましょう。
譜面内でこれらの変数を無条件で使用して、ファイルを読み込んで応答を書き込むことができます。
譜面リスト20-9は、大きな`if`段落と`else`段落を置き換えた結果の譜面を示して`else`ます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::io::prelude::*;
# use std::net::TcpStream;
# use std::fs::File;
#// --snip--
//  --snip--

fn handle_connection(mut stream: TcpStream) {
#     let mut buffer = [0; 512];
#     stream.read(&mut buffer).unwrap();
#
#     let get = b"GET/HTTP/1.1\r\n";
#    // --snip--
    //  --snip--

    let (status_line, filename) = if buffer.starts_with(get) {
        ("HTTP/1.1 200 OK\r\n\r\n", "hello.html")
    } else {
        ("HTTP/1.1 404 NOT FOUND\r\n\r\n", "404.html")
    };

    let mut file = File::open(filename).unwrap();
    let mut contents = String::new();

    file.read_to_string(&mut contents).unwrap();

    let response = format!("{}{}", status_line, contents);

    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}
```

<span class="caption">リスト20-9。 <code>if</code>と<code>else</code>段落をリファクタリングして、2つのケースで異なる譜面のみを含むようにする</span>

これで、`if`段落と`else`段落は、組内のステータス行とファイル名に適切な値を返します。
第18章で説明するように、`status_line`を使用して、`let`文のパターンを使用して`status_line`と`filename`にこれらの2つの値を割り当て`filename`。

以前に複製された譜面は、`if`および`else`段落の外側にあり、`status_line`および`filename`変数を使用します。
これにより、2つのケースの違いをより簡単に確認できるようになります。つまり、ファイルの読み書きの仕方を変更したい場合は、譜面を更新する場所が1つだけです。
リスト20-9の譜面の動作は、リスト20-8の譜面の動作と同じです。

驚くばかり！　
1つのリクエストで1ページの内容で応答し、他のすべてのリクエストに404レスポンスで応答する、約40行のRust譜面でシンプルなWeb提供機を使用できるようになりました。

現在のところ、当社の提供機は単一の走脈で実行されます。つまり、一度に1つの要求のみを処理できます。
遅いリクエストをシミュレートすることで、その問題がどのようになるかを調べてみましょう。
その後、提供機が複数のリクエストを同時に処理できるように修正します。
