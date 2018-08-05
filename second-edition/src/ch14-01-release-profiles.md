## リリースプロファイルを使用した<ruby>組み上げ<rt>ビルド</rt></ruby>のカスタマイズ

Rustでは、*リリースプロファイル*は、<ruby>演譜師<rt>プログラマー</rt></ruby>が<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>するためのさまざまな<ruby>選択肢<rt>オプション</rt></ruby>をより詳細に制御できるように、構成が異なる事前定義されたカスタマイズ可能なプロファイルです。
各プロファイルは他のプロファイルとは独立して構成されています。

カーゴは、主に2つのプロファイルを持っている。 `dev`実行したときに、プロファイルカーゴが使用する`cargo build`し、`release`、実行したときに、プロファイルカーゴが使用する`cargo build --release`。
`dev`プロファイルは、開発のための良い自動的に定義され、`release`リリース<ruby>組み上げ<rt>ビルド</rt></ruby>用のプロファイルが良い<ruby>黙用<rt>デフォルト</rt></ruby>値を持っています。

これらのプロファイル名は、<ruby>組み上げ<rt>ビルド</rt></ruby>の出力に慣れている可能性があります。

```text
$ cargo build
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
$ cargo build --release
    Finished release [optimized] target(s) in 0.0 secs
```

`dev`と`release`この<ruby>組み上げ<rt>ビルド</rt></ruby>出力に示されているが、<ruby>製譜器<rt>コンパイラー</rt></ruby>が異なるプロファイルを使用していることを示しています。

Cargoには、企画の*Cargo.toml*ファイルに`[profile.*]`章がない場合に適用される各プロファイルの<ruby>黙用<rt>デフォルト</rt></ruby>設定があります。
カスタマイズするプロファイルの`[profile.*]`章を追加することで、<ruby>黙用<rt>デフォルト</rt></ruby>設定の下位セットを上書きできます。
たとえば、`dev`および`release`プロファイルの`opt-level`設定の<ruby>黙用<rt>デフォルト</rt></ruby>値は次のとおりです。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[profile.dev]
opt-level = 0

[profile.release]
opt-level = 3
```

`opt-level`設定では、Rustが<ruby>譜面<rt>コード</rt></ruby>に適用される最適化の回数を0〜3の範囲で制御します。さらに最適化を適用すると<ruby>製譜<rt>コンパイル</rt></ruby>時間が延びるので、<ruby>譜面<rt>コード</rt></ruby>を頻繁に開発して<ruby>製譜<rt>コンパイル</rt></ruby>する場合は、結果の<ruby>譜面<rt>コード</rt></ruby>が遅く実行されても<ruby>製譜<rt>コンパイル</rt></ruby>できます。
これが`dev`<ruby>黙用<rt>デフォルト</rt></ruby>の`opt-level`が`0`ある理由です。
<ruby>譜面<rt>コード</rt></ruby>をリリースする準備ができたら、<ruby>製譜<rt>コンパイル</rt></ruby>にもっと時間を費やすのが最善です。
一度だけリリースモードで<ruby>製譜<rt>コンパイル</rt></ruby>しますが、<ruby>製譜<rt>コンパイル</rt></ruby>された<ruby>算譜<rt>プログラム</rt></ruby>は何度も実行されるため、リリースモードはより速く実行される<ruby>譜面<rt>コード</rt></ruby>の<ruby>製譜<rt>コンパイル</rt></ruby>時間を長くします。
そのため、`release`プロファイルの<ruby>黙用<rt>デフォルト</rt></ruby>`opt-level`は`3`です。

*Cargo.tomlに*別の値を追加することで、<ruby>黙用<rt>デフォルト</rt></ruby>設定を上書きすることができます。
たとえば、開発プロファイルで最適化水準1を使用する場合は、企画の*Cargo.toml*ファイルに次の2行を追加できます。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[profile.dev]
opt-level = 1
```

この<ruby>譜面<rt>コード</rt></ruby>は、<ruby>黙用<rt>デフォルト</rt></ruby>設定の`0`上書きします。
実行すると`cargo build`、カーゴはのための<ruby>黙用<rt>デフォルト</rt></ruby>値を使用します`dev`ためにプロファイルに加えて、当社のカスタマイズを`opt-level`。
`opt-level`を`1`設定しているので、Cargoは<ruby>黙用<rt>デフォルト</rt></ruby>よりも多くの最適化を適用しますが、リリース<ruby>組み上げ<rt>ビルド</rt></ruby>の場合ほど多くは適用しません。

各プロファイルの設定<ruby>選択肢<rt>オプション</rt></ruby>と<ruby>黙用<rt>デフォルト</rt></ruby>の完全なリストについては、[Cargoの開発資料を](https://doc.rust-lang.org/cargo/)参照してください。
