## 導入

最初のステップは、Rustを導入することです。
Rust版と関連する道具を管理するための<ruby>命令行<rt>コマンドライン</rt></ruby>道具、`rustup`を通じてRustを<ruby>入荷<rt>ダウンロード</rt></ruby>します。
<ruby>入荷<rt>ダウンロード</rt></ruby>にはインターネット接続が必要です。

> > 注。何らかの理由で`rustup`ないようにしたい場合は[、Rustの導入ページ](https://www.rust-lang.org/install.html)を参照し[て](https://www.rust-lang.org/install.html)ください。

以下の手順で最新の安定版のRust<ruby>製譜器<rt>コンパイラー</rt></ruby>を導入します。
本書のすべての例と出力では、安定したRust 1.21.0を使用しています。
Rustの安定性は、<ruby>製譜<rt>コンパイル</rt></ruby>された本のすべての例が新しいRust版で<ruby>製譜<rt>コンパイル</rt></ruby>され続けることを保証します。
Rustは<ruby>誤り<rt>エラー</rt></ruby>メッセージと警告を改善することが多いため、出力は版によって若干異なる場合があります。
言い換えれば、これらの手順を使用して導入する新しい、安定版のRustは、この本の内容で期待どおりに動作するはずです。

> ### <ruby>命令行<rt>コマンドライン</rt></ruby>表記法
> 
> > この章と本では、<ruby>端末<rt>ターミナル</rt></ruby>で使用される命令をいくつか示します。
> > <ruby>端末<rt>ターミナル</rt></ruby>に入力する行はすべて`$`始まります。
> > `$`文字を入力する必要はありません。
> > 各命令の開始を示します。
> > `$`始まらない行は通常、前の命令の出力を表示します。
> > さらに、PowerShell固有の例では、`$`ではなく`>`が使用されます。

### LinuxまたはmacOSに`rustup`を導入する

LinuxまたはmacOSを使用している場合は、<ruby>端末<rt>ターミナル</rt></ruby>を開いて次の命令を入力します。

```text
$ curl https://sh.rustup.rs -sSf | sh
```

この命令は<ruby>台譜<rt>スクリプト</rt></ruby>を<ruby>入荷<rt>ダウンロード</rt></ruby>して、Rustの最新の安定版を導入する`rustup`道具の導入を開始します。
パスワードの入力を求めるメッセージが表示される場合があります。
導入が成功すると、次の行が表示されます。

```text
Rust is installed now. Great!
```

必要に応じて、実行する前に<ruby>台譜<rt>スクリプト</rt></ruby>を<ruby>入荷<rt>ダウンロード</rt></ruby>して検査してください。

導入<ruby>台譜<rt>スクリプト</rt></ruby>は、次回のログイン後にシステムPATHに自動的にRustを追加します。
<ruby>端末<rt>ターミナル</rt></ruby>を再起動する代わりにRustをすぐに使用したい場合は、<ruby>司得<rt>シェル</rt></ruby>で次の命令を実行して、システムPATHにRustを手動で追加します。

```text
$ source $HOME/.cargo/env
```

あるいは、*〜/.bash_profileに*次の行を追加することもできます。

```text
$ export PATH="$HOME/.cargo/bin:$PATH"
```

さらに、何らかの<ruby>結合器<rt>リンカー</rt></ruby>が必要です。
既に導入されている可能性がありますが、Rust<ruby>算譜<rt>プログラム</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>してリンカが実行できないという<ruby>誤り<rt>エラー</rt></ruby>が表示された場合は、システムにリンカが導入されていないことを意味し、手動で導入する必要があります。
C<ruby>製譜器<rt>コンパイラー</rt></ruby>には通常、適切なリンカが付属しています。
C<ruby>製譜器<rt>コンパイラー</rt></ruby>ーの導入方法については、ご使用の<ruby>基盤環境<rt>プラットフォーム</rt></ruby>の資料を参照してください。
また、いくつかの一般的なRustパッケージはC<ruby>譜面<rt>コード</rt></ruby>に依存しており、C<ruby>製譜器<rt>コンパイラー</rt></ruby>が必要になります。
したがって、今すぐ導入する価値があります。

### 導入`rustup` Windows上で

Windowsでは、[https://www.rust-lang.org/install.html][install]、Rustの導入手順に従ってください。
導入のある時点で、Visual Studio 2013以降のC ++<ruby>組み上げ<rt>ビルド</rt></ruby>道具も必要であることを示すメッセージが表示されます。
<ruby>組み上げ<rt>ビルド</rt></ruby>道具を入手する最も簡単な方法は[、Visual Studio 2017用の<ruby>組み上げ<rt>ビルド</rt></ruby>道具][visualstudio]を導入することです。
道具は[その他の道具とFramework]章にあります。

[visualstudio]: https://www.visualstudio.com/downloads/
 [install]: https://www.rust-lang.org/install.html


この本の残りの部分では、*cmd.exe*とPowerShellの両方で動作する命令を使用します。
具体的な相違点がある場合は、どちらを使用するかを説明します。

### 更新と撤去

Rustを`rustup`て導入した後は、最新版への更新は簡単です。
<ruby>司得<rt>シェル</rt></ruby>から、次の更新<ruby>台譜<rt>スクリプト</rt></ruby>を実行します。

```text
$ rustup update
```

Rustと`rustup`を撤去するには、<ruby>司得<rt>シェル</rt></ruby>から次の撤去<ruby>台譜<rt>スクリプト</rt></ruby>を実行します。

```text
$ rustup self uninstall
```

### 困ったときは

Rustが正しく導入されているかどうかを確認するには、<ruby>司得<rt>シェル</rt></ruby>を開いて次の行を入力します。

```text
$ rustc --version
```

次の形式でリリースされた最新の安定版の版番号、コミットハッシュ、およびコミット日付が表示されます。

```text
rustc x.y.z (abcabcabc yyyy-mm-dd)
```

この情報が表示されたら、Rustを正常に導入しました！　
この情報が表示されず、Windowsの場合は、`%PATH%`システム変数にRustがあることを確認してください。
それでも問題ないのですが、まだRustが働いていない場合は、助けてくれる場所がたくさんあります。
最も簡単なのは[、irc.mozilla.orgの#rust IRCチャネルです][irc]
 これは[Mibbit][mibbit]を介してアクセスできます。
その番地で、あなたを助けることができる他のラステーシャン（私たち自身のたわいない名前）とチャットすることができます。
その他の素晴らしい資源には[、Usersフォーラム][users]や[Stack Overflowなどがあり][stackoverflow]ます。

[irc]: irc://irc.mozilla.org/#rust
 [mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
 [users]: https://users.rust-lang.org/
 [stackoverflow]: http://stackoverflow.com/questions/tagged/rust


### ローカル開発資料

<ruby>導入譜<rt>インストーラー?</rt></ruby>には、開発資料集のコピーもローカルに含まれているため、接続なしで読むことができます。
`rustup doc`を実行して、ブラウザのローカル`rustup doc`を開きます。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>によって型または機能が提供され、その動作や使用方法がわからない場合は、譜体<ruby>演譜<rt>プログラミング</rt></ruby>接点（API）の開発資料を参照してください。
