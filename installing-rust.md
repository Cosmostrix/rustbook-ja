% Rust を導入しよう

Rust を使う最初の一歩はまずそれを導入〈インストール〉することです！
Rust の導入方法には色々ありますが、最も簡単なのは `rustup` 台譜〈スクリプト〉を使う方法です。
Linux または Mac をお使いの場合、
唯一必要なことは次の行を端末〈ターミナル〉で実行することだけです。

> 【注意】先頭の `$` 記号は入力しないでください。これらは各命令の始まりを示すだけの印です。
> Web の各所でこのような慣例に従った多くの指導書〈チュートリアル〉やお手本を見かけると思います。
> 標準利用者〈ユーザー〉として実行する命令〈コマンド〉には `$` を、
> 管理者として実行しなければならない命令には `#` を使います。

```bash
$ curl -sf -L https://static.rust-lang.org/rustup.sh | sh
```

`curl | sh` を使うことについて[もしやの不安 (英語)][insecurity]を懸念されるのならば、
このまま読み進めて下にある私達の免責条項をご覧ください。また、
次の２段階版を使って私達の導入台譜を査読することもご遠慮なくどうぞ。

```bash
$ curl -f -L https://static.rust-lang.org/rustup.sh -O
$ sh rustup.sh
```

[insecurity]: http://curlpipesh.tumblr.com

Windows をお使いの場合、適切な[取付具〈インストーラー〉][install-page]を入荷〈ダウンロード〉してください。

【訳者註】無料です。強いて言えば使って広めることが対価という考えもあります。

> 【注意】黙用的に〈By default〉、Windows用取付具は %PATH% 算系〈システム〉環境変数に
> Rust の場所を追加しません。もしこの Rust が導入後に命令行〈コマンドライン〉から走らせたい
> ただひとつの版なら、導入〈ダイアログ〉の "Advanced" を押下〈クリック〉して
> "Product Features" ページの "Add to PATH" が〈ローカルハードドライブ〉に導入される
> ことを確実にしてください。


[install-page]: https://www.rust-lang.org/install.html

## Uninstalling

If you decide you don't want Rust anymore, we'll be a bit sad, but that's okay.
Not every programming language is great for everyone. We'll just run the
uninstall script:

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

If we used the Windows installer, we'll just re-run the `.msi` and it will give
us an uninstall option.

## That disclaimer we promised

Some people, and somewhat rightfully so, get very upset when we tell them to
`curl | sh`. Basically, when they do this, they are trusting that the good
people who maintain Rust aren't going to hack their computer and do bad things.
That's a good instinct! If you're one of those people, please check out the
documentation on [building Rust from Source][from-source], or [the official
binary downloads][install-page].

[from-source]: https://github.com/rust-lang/rust#building-from-source

## Platform support

Oh, we should also mention the officially supported platforms:

* Windows (7 or later, Server 2008 R2)
* Linux (2.6.18 or later, various distributions), x86 and x86-64
* OSX 10.7 (Lion) or later, x86 and x86-64

We extensively test Rust on these platforms, and a few others, too, like
Android. But these are the ones most likely to work, as they have the most
testing.

Finally, a comment about Windows. Rust considers Windows to be a first-class
platform upon release, but if we're honest, the Windows experience isn't as
integrated as the Linux/OS X experience is. We're working on it! If anything
doesn't work, it is a bug. Please let us know if that happens. Each and every
commit is tested against Windows just like any other platform.

## After installation

If we've got Rust installed, we can open up a shell, and type this:

```bash
$ rustc --version
```

You should see the version number, commit hash, and commit date.

If you do, Rust has been installed successfully! Congrats!

If you don't and you're on Windows, check that Rust is in your %PATH% system
variable. If it isn't, run the installer again, select "Change" on the "Change,
repair, or remove installation" page and ensure "Add to PATH" is installed on
the local hard drive.

This installer also installs a copy of the documentation locally, so we can read
it offline. On UNIX systems, `/usr/local/share/doc/rust` is the location. On
Windows, it's in a `share/doc` directory, inside the directory to which Rust was
installed.

If not, there are a number of places where we can get help. The easiest is
[the #rust IRC channel on irc.mozilla.org][irc], which we can access through
[Mibbit][mibbit]. Click that link, and we'll be chatting with other Rustaceans
(a silly nickname we call ourselves) who can help us out. Other great resources
include [the user’s forum][users], and [Stack Overflow][stackoverflow].

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust
