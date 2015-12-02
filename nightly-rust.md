% 夢の中で逢った、ような……

Rust では３つの配布路線を提供しています。
それぞれ 夜行版 (nightly)〈ナイトリー〉、ベータ版 (beta)、安定版 (stable) といいます。
不安定な機能は (毎夜の) 夜行版 Rust でのみ利用できます。
この過程について詳しくは「[届けられるものとしての安定性 (英語)][stability]」をご覧ください。

<!-- Rust provides three distribution channels for Rust: nightly, beta, and stable.
Unstable features are only available on nightly Rust. For more details on this
process, see ‘[Stability as a deliverable][stability]’. -->

[stability]: http://blog.rust-lang.org/2014/10/30/Stability.html

夜行版 Rust を導入するには、`rustup.sh` を使えます。

<!-- To install nightly Rust, you can use `rustup.sh`: -->

```bash
$ curl -s https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly
```

`curl | sh` を使うことについて[もしやの不安 (英語)][insecurity]を懸念されるのならば、
このまま読み進めて下にある私達の免責事項をご覧ください。また、
次の２段階版を使って私達の導入台譜を査読することもご遠慮なく。

<!-- If you're concerned about the [potential insecurity][insecurity] of using `curl
| sh`, please keep reading and see our disclaimer below. And feel free to
use a two-step version of the installation and examine our installation script: -->

```bash
$ curl -f -L https://static.rust-lang.org/rustup.sh -O
$ sh rustup.sh --channel=nightly
```

[insecurity]: http://curlpipesh.tumblr.com

Windows をお使いの場合、[32ビット取付具][win32]または[64ビット取付具][win64]のどちらかを入荷し、実行してください。

<!-- If you're on Windows, please download either the [32-bit installer][win32] or
the [64-bit installer][win64] and run it. -->

[win32]: https://static.rust-lang.org/dist/rust-nightly-i686-pc-windows-gnu.msi
[win64]: https://static.rust-lang.org/dist/rust-nightly-x86_64-pc-windows-gnu.msi


## 撤去するには

<!-- ## Uninstalling -->

Rust は、もうええわ。と判断されたら、私達はちょっと寂しいですが、それでも構いません。
どの演譜言語も万人にとって完璧なものではありません。
撤去用の台譜はこのように走らせます。

<!-- If you decide you don't want Rust anymore, we'll be a bit sad, but that's okay.
Not every programming language is great for everyone. Just run the uninstall
script: -->

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

Windows 用取付具を使った場合は、もう一度その `.msi` を実行すると
撤去 (Uninstall) の選択肢が現れます。

<!-- If you used the Windows installer, just re-run the `.msi` and it will give you
an uninstall option. -->

わりあい真っ当な方々はそうなのですが、`curl | sh` するように言うと激怒される方もいます。
根本的には、こうするとき Rust を保守している善良な人々が計算機を侵害して悪事を
はたらかないことを当てにしているからです。
実によい洞察です！もしあなたがそのような方々の一員なら、開発資料集の
[Rust を原譜から組み上げる][from-source]や[公式二進譜置き場]
[install-page]を当たってみてください。

<!-- Some people, and somewhat rightfully so, get very upset when we tell you to
`curl | sh`. Basically, when you do this, you are trusting that the good
people who maintain Rust aren't going to hack your computer and do bad things.
That's a good instinct! If you're one of those people, please check out the
documentation on [building Rust from Source][from-source], or [the official
binary downloads][install-page]. -->

[from-source]: https://github.com/rust-lang/rust#building-from-source
[install-page]: https://www.rust-lang.org/install.html

あとは、公式に対応している土台環境も述べておかなければなりません。

<!-- Oh, we should also mention the officially supported platforms: -->

* Windows (7, 8, Server 2008 R2)
* Linux (2.6.18 以降、多くの頒布物)、x86 および x86-64
* OS X 10.7 (Lion) 以降、x86 および x86-64

<!-- * Windows (7, 8, Server 2008 R2)
* Linux (2.6.18 or later, various distributions), x86 and x86-64
* OSX 10.7 (Lion) or greater, x86 and x86-64 -->

私達は以上に加え、他に Android のような２〜３の土台環境で広範囲に Rust を検査しています。
とはいえ、上記３つは最も試されているので、最も動作しやすいはずです。

<!-- We extensively test Rust on these platforms, and a few others, too, like
Android. But these are the ones most likely to work, as they have the most
testing. -->

最後に、Windows について一つ。
Rust は放流に際し Windows を一級市民扱いしていますが、率直に言うと Windows
での使用感は Linux/OS X のものに比べて洗練されていません。目下改善中です！
もし何か動かないものがあれば、それは害虫(不具合)です。もし見かけたらお知らせください。
Windows に対しても他の土台環境と同様に全ての〈コミット〉が漏れなく検査されています。

<!-- Finally, a comment about Windows. Rust considers Windows to be a first-class
platform upon release, but if we're honest, the Windows experience isn't as
integrated as the Linux/OS X experience is. We're working on it! If anything
does not work, it is a bug. Please let us know if that happens. Each and every
commit is tested against Windows just like any other platform. -->

Rust の導入が無事済んだら、司得を開いてこのように打てるようになります。

<!-- If you've got Rust installed, you can open up a shell, and type this: -->

```bash
$ rustc --version
```

版数、〈コミットハッシュ〉、〈コミット〉日時が表示されるはずです。

<!-- You should see the version number, commit hash, commit date and build date: -->

```bash
rustc 1.0.0-nightly (f11f3e7ba 2015-01-04) (built 2015-01-06)
```

うまく表示されたら導入成功です！ やったぜ！

<!-- If you did, Rust has been installed successfully! Congrats! -->

この取付具は開発資料集の写し一式も手元に導入します。従って、無接続で読めます。
UNIX系算系では `/usr/local/share/doc/rust` がその場所です。
Windows では Rust が導入された階層内の `share/doc` 階層にあります。

<!-- This installer also installs a copy of the documentation locally, so you can
read it offline. On UNIX systems, `/usr/local/share/doc/rust` is the location.
On Windows, it's in a `share/doc` directory, inside wherever you installed Rust
to. -->

うまくいかなくても、助けを求められる場所がたくさんあります。一番簡単なのは、
[irc.mozilla.org 上にある IRC #rust チャンネル (英語)][irc]で、そこには
[Mibbit][mibbit] を通して到達できます。リンクを押下すると、私達が他の心優しい 
Rustacean (私達が自分たちのことを呼ぶちゃらけた二つ名です)
達とおしゃべりしているはずです。
他によい場所には[井戸端会議所(英語)][users]と
[Stack Overflow (英語)][stackoverflow]などがあります。

<!-- If not, there are a number of places where you can get help. The easiest is
[the #rust IRC channel on irc.mozilla.org][irc], which you can access through
[Mibbit][mibbit]. Click that link, and you'll be chatting with other Rustaceans
(a silly nickname we call ourselves), and we can help you out. Other great
resources include [the user’s forum][users], and [Stack Overflow][stackoverflow]. -->

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust

【訳者註】夜行版で遊ぶときは日本語資料よりも実際に作っている人や原文資料に当たる方が得策です。
