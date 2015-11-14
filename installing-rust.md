% Rust を導入しよう

Rust を使う最初の一歩はまずそれを導入〈インストール〉することです！
Rust の導入方法には色々ありますが、最も簡単なのは `rustup` 台譜〈スクリプト〉を使う方法です。
Linux または Mac をお使いの場合、
唯一必要なことは次の行を端末〈ターミナル〉で実行することだけです。

> 【注意】先頭の `$` 記号は入力しないでください。これらは各命令〈コマンド〉
> の始まりを示すだけの印です。Web の各所でこのような慣例に従った
> 多くの指南書〈チュートリアル〉やお手本を見かけると思います。
> 標準利用者〈ユーザー〉として実行する命令には `$` を、
> 管理者として実行しなければならない命令には `#` を使います。

```bash
$ curl -sf -L https://static.rust-lang.org/rustup.sh | sh
```

`curl | sh` を使うことについて[もしやの不安 (英語)][insecurity]を懸念されるのならば、
このまま読み進めて下にある私達の免責事項をご覧ください。また、
次の２段階版を使って私達の導入台譜を査読することもご遠慮なく。

```bash
$ curl -f -L https://static.rust-lang.org/rustup.sh -O
$ sh rustup.sh
```

[insecurity]: http://curlpipesh.tumblr.com

Windows をお使いの場合、適切な[取付具〈インストーラー〉][install-page]を入荷〈ダウンロード〉してください。

【訳者註】無料です。強いて言えば使って広めることが対価という考えもあります。

> 【注意】黙用的に〈By default〉、Windows 用取付具は %PATH% 算系〈システム〉環境変数に
> Rust の場所を追加しません。もしこの Rust が導入後に命令行〈コマンドライン〉から走らせたい
> ただひとつの版なら、導入〈ダイアログ〉の "Advanced" を押下〈クリック〉して
> "Product Features" ページの "Add to PATH" が〈ローカルハードドライブ〉に導入される
> ことを確実にしてください。


[install-page]: https://www.rust-lang.org/install.html

## 撤去〈アンインストール〉するには

Rust は、もうええわ。と判断されたら、私達はちょっと寂しいですが、それでも構いません。
どの演譜〈プログラミング〉言語も万人にとって完璧なものではありません。
どうでもいいですね。撤去用の台譜はこのように走らせます。

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

Windows 用取付具を使った場合は、もう一度その `.msi` を実行すると
撤去 (Uninstall) の選択肢が現れます。

## お約束の免責事項

わりあい真っ当な方々はそうなのですが、`curl | sh` するように言うと激怒される方もいます。
根本的には、こうするとき Rust を保守している善良な人々が計算機を侵害して悪事を
はたらかないことを当てにしているからです。
実によい洞察です！もしあなたがそのような方々の一員なら、開発資料集の
[Rust を原譜から〈ビルド〉する][from-source]や[公式二進譜〈バイナリ〉置き場]
[install-page]を当たってみてください。

[from-source]: https://github.com/rust-lang/rust#building-from-source

## 〈プラットフォーム〉対応

あと、公式に対応〈サポート〉している〈プラットフォーム〉も述べておかなければなりません。

* Windows (7 以降、Server 2008 R2)
* Linux (2.6.18 以降、多くの頒布物〈ディストリビューション〉)、x86 及び x86-64
* OS X 10.7 (Lion) 以降、x86 及び x86-64

私達は以上に加え、他に Android のような２、３の〈プラットフォーム〉で広範囲に
Rust を検査しています。
とはいえ、上記３つは最も試されているので、最も動作しやすいはずです。

最後に、Windows について一つ。Rust は放流〈リリース〉に際し Windows を第一級市民扱いしていますが、率直に言うと Windows での使用感は Linux/OS X のものに比べて洗練されていません。目下改善中です！もし何か動かないものがあれば、
それは害虫〈バグ〉(不具合)です。もし見かけたらお知らせください。Windows
に対しても他の〈プラットフォーム〉と同様に全ての〈コミット〉
が漏れなく検査されています。

## 導入が終わったときは

Rust の導入が無事済んだら、司得〈シェル〉を開いてこのように打てるようになります。

```bash
$ rustc --version
```

版数〈バージョン数〉、〈コミットハッシュ〉、〈コミット日時〉が表示されるはずです。

うまく表示されたら導入成功です！ やったね たえちゃん演譜ができるよ！

Windows をお使いでうまく行かなかった場合は、%PATH% 算系環境変数に Rust
が含まれているか確認してください。もしなかった場合、取付具を再度走らせて
"Change,	 repair, or remove installation" ページ内の "Change" を選び、
"Add to PATH" が確実に〈ローカルハードドライブ〉
に導入されているようにしてください。

この取付具は開発資料集の写し一式も手元に導入します。従って、〈オフライン〉
で読めます。UNIX系算系では `/usr/local/share/doc/rust` がその場所です。
Windows では Rust が導入された階層〈フォルダ〉内の `share/doc`
階層にあります。

他にも、助けを求められる場所がたくさんあります。一番簡単なのは、
[irc.mozilla.org 上にある IRC #rust チャンネル (英語)][irc]で、そこには
[Mibbit][mibbit] を通して到達できます。リンクを押下すると、私達が他の心優しい 
Rustacean (私達が自分たちのことを呼ぶちゃらけた〈ニックネーム〉です)
達とおしゃべりしているはずです。
他によい場所には[〈ユーザーフォーラム〉(英語)][users]と
[Stack Overflow (英語)][stackoverflow]などがあります。

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust

【訳者註】（近日中に日本語コミュを作る？）