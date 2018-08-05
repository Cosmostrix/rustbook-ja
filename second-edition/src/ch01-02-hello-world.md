## こんにちは世界！　

Rustを導入したので、最初のRust<ruby>算譜<rt>プログラム</rt></ruby>を作成しましょう。
これは伝統的なこと`Hello, world!`が、`Hello, world!`テキストを画面に表示する小さな<ruby>算譜<rt>プログラム</rt></ruby>を書くために新しい言語を学ぶので、ここでも同じことをします！　

> > 注意。この説明書では、<ruby>命令行<rt>コマンドライン</rt></ruby>についての基本的な知識があることを前提としています。
> > Rustは、編集や道具立て、<ruby>譜面<rt>コード</rt></ruby>が存在する場所について特別な要求をしないので、<ruby>命令行<rt>コマンドライン</rt></ruby>の代わりに統合開発環境（IDE）を使用する場合は、好きなIDEを自由に使用してください。
> > 多くのIDEは、ある程度のRustをサポートしています。
> > 詳細は、IDEの開発資料を参照してください。
> > 最近、Rustチームは素晴らしいIDEサポートを可能にすることに重点を置いており、その前進が急速に進んでいます！　

### 企画ディレクトリの作成

まず、Rust<ruby>譜面<rt>コード</rt></ruby>を格納するディレクトリを作成します。
<ruby>譜面<rt>コード</rt></ruby>がどこにあるのかは問題ではありませんが、この本の演習と企画では、ホームディレクトリに*projects*ディレクトリを作成し、そこにすべての企画を保存することをお勧めします。

<ruby>端末<rt>ターミナル</rt></ruby>を開き、次の命令を入力して、Helloディレクトリの*企画*ディレクトリとディレクトリを作成し*ます*。
企画ディレクトリ内の*企画*。

LinuxおよびmacOSの場合は、次のように入力します。

```text
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

Windows CMDの場合は、次のように入力します。

```cmd
> mkdir "%USERPROFILE%\projects"
> cd /d "%USERPROFILE%\projects"
> mkdir hello_world
> cd hello_world
```

Windows PowerShellの場合は、次のように入力します。

```powershell
> mkdir $env:USERPROFILE\projects
> cd $env:USERPROFILE\projects
> mkdir hello_world
> cd hello_world
```

### Rust<ruby>算譜<rt>プログラム</rt></ruby>の作成と実行

次に、新しい原本を作り、それを*main.rs*と呼んで*ください*。
Rustファイルは常に*.rs*拡張子で終わります。
ファイル名に複数の単語を使用する場合は、下線を使用して単語を区切ります。
たとえば、*helloworld.rs*ではなく*hello_world.rsを*使用し*ます*。

今作成した*main.rs*ファイルを開き、リスト1-1の<ruby>譜面<rt>コード</rt></ruby>を入力します。

<span class="filename">ファイル名。main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

<span class="caption">リスト1-1。 <code>Hello, world€</code>を出力する算譜</span>

ファイルを保存して、<ruby>端末<rt>ターミナル</rt></ruby>窓に戻ります。
LinuxまたはmacOSの場合は、次の命令を入力してファイルを<ruby>製譜<rt>コンパイル</rt></ruby>して実行します。

```text
$ rustc main.rs
$ ./main
Hello, world!
```

Windowsでは、命令を入力します`.\main.exe`代わりの`./main`。

```powershell
> rustc main.rs
> .\main.exe
Hello, world!
```

<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>にかかわらず、<ruby>文字列<rt>ストリング</rt></ruby>`Hello, world!`が<ruby>端末<rt>ターミナル</rt></ruby>に出力されます。
この出力が表示されない場合は、「困ったときは」章に戻って手助け入手する方法を参照してください。

`Hello, world!`が<ruby>印字<rt>プリント</rt></ruby>されました、おめでとうございます！　
正式にRust<ruby>算譜<rt>プログラム</rt></ruby>を書いています。
それであなたはRust<ruby>演譜師<rt>プログラマー</rt></ruby> -歓迎します！　

### Rust<ruby>算譜<rt>プログラム</rt></ruby>の解剖

ちょうどこんにちは、世界で起こったことを詳しく見てみましょう！　
<ruby>算譜<rt>プログラム</rt></ruby>。
パズルの最初の部分は次のとおりです。

```rust
fn main() {

}
```

これらの行は、Rustの機能を定義します。
`main`機能は特別です。常に実行可能なすべてのRust<ruby>算譜<rt>プログラム</rt></ruby>で実行される最初の<ruby>譜面<rt>コード</rt></ruby>です。
最初の行は、パラメータのない`main`という機能を宣言し、何も返しません。
パラメータがあった場合は、かっこ内に入ります`()`。

また、機能の本文は`{}`中かっこで囲まれています。
Rustはすべての機能本体の周りにこれらを必要とします。
機能の宣言と同じ行に中かっこを配置し、間にスペースを1つ追加するのは良い作法です。

この執筆時点では、`rustfmt`という自動整形器が開発中です。
Rust企画全体で標準作法に固執したい場合、`rustfmt`は<ruby>譜面<rt>コード</rt></ruby>を特定の作法で整形します。
Rustチームは、この道具に`rustc`ような標準のRust頒布物を`rustc`です。
あなたがこの本を読んだときには、<ruby>計算機<rt>コンピューター</rt></ruby>にすでに導入されているかもしれません！　
詳細については、オンライン開発資料を参照してください。

`main`機能の中には次の<ruby>譜面<rt>コード</rt></ruby>があります。

```rust
    println!("Hello, world!");
```

この行は、この小さな<ruby>算譜<rt>プログラム</rt></ruby>のすべての作業を行います。画面にテキストを<ruby>印字<rt>プリント</rt></ruby>します。
ここで注意すべき4つの重要な詳細があります。
まず、Rust作法は、タブではなく4つのスペースで字下げすることです。

次に、`println!`はRustマクロを呼び出します。
代わりに機能を呼び出すと、それは`println`として（`!`なしで）入力されます。
Rustマクロについては、付録Dで詳しく説明します。今のところ`!`を使用すると、通常の機能の代わりにマクロを呼び出すということを知る必要があります。

第3に、`"Hello, world!"`<ruby>文字列<rt>ストリング</rt></ruby>があります。
この<ruby>文字列<rt>ストリング</rt></ruby>を`println!`引数として渡し、<ruby>文字列<rt>ストリング</rt></ruby>を画面に出力します。

第4に、セミコロン（`;`）で終わり`;`これは、この式が終了し、次の式が開始する準備ができていることを示します。
ほとんどの行のRust<ruby>譜面<rt>コード</rt></ruby>はセミコロンで終わります。

### <ruby>製譜<rt>コンパイル</rt></ruby>と実行は別々の手順です

新しく作成した<ruby>算譜<rt>プログラム</rt></ruby>を実行しただけなので、その過程の各ステップを調べてみましょう。

Rust<ruby>算譜<rt>プログラム</rt></ruby>を実行する前に、`rustc`命令を入力し、原本の名前を次のように渡して、Rust<ruby>製譜器<rt>コンパイラー</rt></ruby>を使用して<ruby>製譜<rt>コンパイル</rt></ruby>する必要があります。

```text
$ rustc main.rs
```

CまたはC ++の背景を持っている場合、これは`gcc`または`clang`似ていることがあります。
<ruby>製譜<rt>コンパイル</rt></ruby>が正常に終了すると、Rustは<ruby>二進譜<rt>バイナリ</rt></ruby>実行可能ファイルを出力します。

WindowsのLinux、macOS、およびPowerShellでは、次のように<ruby>司得<rt>シェル</rt></ruby>に`ls`命令を入力して実行可能ファイルを確認できます。

```text
$ ls
main  main.rs
```

WindowsでCMDを使用する場合は、次のように入力します。

```cmd
> dir /B %= the /B option says to only show the file names =%
main.exe
main.pdb
main.rs
```

これは、*.rs*拡張子を持つ原譜ファイル、実行可能ファイル（Windowsでは*main.exe*、他のすべての<ruby>基盤環境<rt>プラットフォーム</rt></ruby>では*メイン*）、およびCMDを使用する場合は拡張子*.pdbの*<ruby>虫取り<rt>デバッグ</rt></ruby>情報を含むファイルを示しています。
ここから*main*や*main.exe*ファイルを実行します。

```text
$ ./main # or .\main.exe on Windows
```

*main.rs*がこんにちは、世界だったら！　
この行は<ruby>端末<rt>ターミナル</rt></ruby>に`Hello, world!`を出力します。

Ruby、Python、JavaScriptなどの動的言語に慣れている場合は、<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して別の手順として実行することに慣れていない可能性があります。
Rustは*事前に<ruby>製譜<rt>コンパイル</rt></ruby>された*言語です。つまり、<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して実行可能ファイルを他の人に与えることができ、Rustを導入しなくても実行できます。
誰かに*.rb*、 *.py*、または*.js*ファイルを与える場合は、Ruby、Python、またはJavaScriptの実装をそれぞれ導入する必要があります。
しかし、これらの言語では、<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して実行するための命令が1つだけ必要です。
すべてが言語設計の<ruby>相殺取引<rt>トレードオフ</rt></ruby>です。

`rustc`で<ruby>製譜<rt>コンパイル</rt></ruby>するだけで、簡単な<ruby>算譜<rt>プログラム</rt></ruby>でうまくいきますが、企画が成長するにつれて、すべての<ruby>選択肢<rt>オプション</rt></ruby>を管理して<ruby>譜面<rt>コード</rt></ruby>を簡単に共有できるようになります。
次に、実際のRust<ruby>算譜<rt>プログラム</rt></ruby>を書くのに役立つCargo道具を導入します。
