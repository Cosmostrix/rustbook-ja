## Crates.ioから二進譜を導入して`cargo install`

`cargo install`命令を使用すると、二進譜通い箱をローカルに導入して使用できます。
これはシステムパッケージを置き換えるものではありません。
これは、Rustの開発者が他の人が[crates.io](https://crates.io)共有している道具を導入するのに便利な方法です。
 。
二進譜目標を持つパッケージのみを導入できることに注意してください。
*二進譜目標*は、*単独*では実行できないが、他のファイルに含めるのに適している譜集目標ではなく、*src / main.rs*ファイルまたは二進譜として指定された別のファイルがある場合に作成される実行可能算譜です算譜。
通常、通い箱は、通い箱が譜集であるか、二進譜・目標であるか、またはその両方であるかについて、*README*ファイルに情報を持っています。

`cargo install`されたすべての二進譜は、導入ルートの*bin*フォルダに格納されます。
`rustup`を使用してRustを導入した場合に独自の設定がない場合、このディレクトリは*$ HOME /.cargo / binになり*ます。
`cargo install`した算譜を実行できるようにするには、`$PATH`にディレクトリがあることを確認してください。

たとえば、第12章では、ファイルを検索するための`ripgrep`という`grep`道具のRust実装があると`ripgrep`ました。
`ripgrep`を導入する場合は、次の`ripgrep`を実行できます。

```text
$ cargo install ripgrep
Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading ripgrep v0.3.2
 --snip--
   Compiling ripgrep v0.3.2
    Finished release [optimized + debuginfo] target(s) in 97.91 secs
  Installing ~/.cargo/bin/rg
```

出力の最後の行には、導入されている二進譜の場所と名前が表示されます`ripgrep`の場合は`rg`です。
以前に述べたように、導入ディレクトリが`$PATH`にある限り、`rg --help`を実行して、ファイルを検索するためのより高速でRustびない道具を使い始めることができます！　
