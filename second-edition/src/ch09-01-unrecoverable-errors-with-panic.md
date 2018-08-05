## `panic!`回復不能な<ruby>誤り<rt>エラー</rt></ruby>

時には、<ruby>譜面<rt>コード</rt></ruby>に悪いことが起こることもあります。できることは何もありません。
このような場合、Rustには`panic!`マクロがあります。
`panic!`マクロが実行されると、<ruby>算譜<rt>プログラム</rt></ruby>は失敗メッセージを出力し、<ruby>山<rt>スタック</rt></ruby>の巻き戻しと後始末を行い、終了します。
これは最も一般的には、何らかのバグが検出されたときに発生し、<ruby>演譜師<rt>プログラマー</rt></ruby>に<ruby>誤り<rt>エラー</rt></ruby>を処理する方法が明確でない場合に発生します。

> ### パニックに対する<ruby>山<rt>スタック</rt></ruby>の巻き戻しまたは中止
> 
> > 自動的には、パニックが発生すると、<ruby>算譜<rt>プログラム</rt></ruby>は*巻き戻しを*開始します。これは、Rustが<ruby>山<rt>スタック</rt></ruby>をウォークバックし、遭遇した各機能からデータを後始末することを意味します。
> > しかし、この歩き戻って後始末は多くの仕事です。
> > 代わりに、即座に*中止*することができます。これは、後始末せずに<ruby>算譜<rt>プログラム</rt></ruby>を終了します。
> > <ruby>算譜<rt>プログラム</rt></ruby>が使用していた記憶は、<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>によって後始末する必要があります。
> > 企画内で<ruby>二進譜<rt>バイナリ</rt></ruby>を可能な限り小さくする必要がある場合は、`panic = 'abort'`を*Cargo.toml*ファイルの適切な`[profile]`章に追加することで、パニック時に巻き戻しから打ち切りに切り替えることができます。
> > たとえば、リリースモードでパニックを中止する場合は、次のように追加します。
> 
> ```toml
> [profile.release]
> panic = 'abort'
> ```

簡単な<ruby>算譜<rt>プログラム</rt></ruby>で`panic!`呼び出すようにしましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
fn main() {
    panic!("crash and burn");
}
```

<ruby>算譜<rt>プログラム</rt></ruby>を実行すると、次のように表示されます。

```text
$ cargo run
   Compiling panic v0.1.0 (file:///projects/panic)
    Finished dev [unoptimized + debuginfo] target(s) in 0.25 secs
     Running `target/debug/panic`
thread 'main' panicked at 'crash and burn', src/main.rs:2:4
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

`panic!`呼び出すと、最後の2行に含まれる<ruby>誤り<rt>エラー</rt></ruby>メッセージが表示されます。
*2。4は*、第2ライン、私たち*のsrc/main.rsファイル*の4番目の文字であるということを示している*のsrc/main.rs。*最初の行は、パニックメッセージとパニックが発生し、当社の原譜内の場所を示しています。

この場合、示された行は<ruby>譜面<rt>コード</rt></ruby>の一部です。その行に行くと、`panic!`マクロ呼び出しが表示されます。
他のケースでは、`panic!`呼び出しは<ruby>譜面<rt>コード</rt></ruby>で呼び出され、<ruby>誤り<rt>エラー</rt></ruby>メッセージによって報告されたファイル名と行番号は、最終的に導かれる<ruby>譜面<rt>コード</rt></ruby>の行ではなく`panic!`列が呼び出される他の誰かの<ruby>譜面<rt>コード</rt></ruby>になります`panic!`通話に
問題の原因となっている<ruby>譜面<rt>コード</rt></ruby>の部分を理解するために、`panic!`呼び出しの機能のバックトレースを使用することができます。
次に、バックトレースの詳細を次に説明します。

### `panic!`バックトレースを使用する

マクロを直接呼び出す<ruby>譜面<rt>コード</rt></ruby>ではなく、<ruby>譜面<rt>コード</rt></ruby>のバグのために`panic!`な呼び出しが<ruby>譜集<rt>ライブラリー</rt></ruby>ーから来たときの状況を見てみましょう。
<ruby>譜面<rt>コード</rt></ruby>リスト9-1に、ベクトルの<ruby>添字<rt>インデックス</rt></ruby>で要素にアクセスしようとする<ruby>譜面<rt>コード</rt></ruby>があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust,should_panic
fn main() {
    let v = vec![1, 2, 3];

    v[99];
}
```

<span class="caption">譜面リスト9-1。ベクトルの終わりを超えて要素にアクセスしようとすると<code>panic€</code></span>

ここでは、ベクトルの100番目の要素（<ruby>添字<rt>インデックス</rt></ruby>がゼロから始まるため、<ruby>添字<rt>インデックス</rt></ruby>99にあります）にアクセスしようとしていますが、要素は3つしかありません。
この状況では、Rustはパニックに陥ります。
`[]`を使用すると要素が返されるはずですが、無効な<ruby>添字<rt>インデックス</rt></ruby>を渡すと、ここでRustが正しい要素を返す要素はありません。

Cのような他の言語は、望むものではないにしても、このような状況で求めたものを正確に与えるようにしようとします。ベクトルの要素に対応する記憶上の場所たとえ記憶がベクトルに属していなくても。
これは*バッファオーバーレイ*と呼ばれ、攻撃者が配列の後に格納されてはならないデータを読み取るような方法で<ruby>添字<rt>インデックス</rt></ruby>を操作できると、セキュリティ上の脆弱性につながる可能性があります。

この種の脆弱性から<ruby>算譜<rt>プログラム</rt></ruby>を保護するために、存在しない<ruby>添字<rt>インデックス</rt></ruby>の要素を読み込もうとすると、Rustは実行を停止し、続行を拒否します。
それを試して見てみましょう。

```text
$ cargo run
   Compiling panic v0.1.0 (file:///projects/panic)
    Finished dev [unoptimized + debuginfo] target(s) in 0.27 secs
     Running `target/debug/panic`
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is
99', /checkout/src/liballoc/vec.rs:1555:10
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

この<ruby>誤り<rt>エラー</rt></ruby>は、書き込んでいないファイル、*vec.rs*を指しています。
これは、標準<ruby>譜集<rt>ライブラリー</rt></ruby>の`Vec<T>`実装です。
ベクトル`v` `[]`を使用したときに実行される<ruby>譜面<rt>コード</rt></ruby>は、*vec.rs内*にあり、`panic!`が実際に起こっている場所です。

次のノート・ラインは、`RUST_BACKTRACE`環境変数を設定して、<ruby>誤り<rt>エラー</rt></ruby>の原因となったもののバックトレースを取得できることを示しています。
*バックトレース*は、この時点までに呼び出されたすべての機能のリストです。
Backtraces in Rustは他の言語と同じように動作します。バックトレースを読むための鍵は、最初から書いたファイルが見えるまで読むことです。
問題が発生した場所です。
ファイルに言及している行の上の行は、<ruby>譜面<rt>コード</rt></ruby>が呼び出す<ruby>譜面<rt>コード</rt></ruby>です。
以下の行は<ruby>譜面<rt>コード</rt></ruby>を呼び出す<ruby>譜面<rt>コード</rt></ruby>です。
これらの行には、コアRust<ruby>譜面<rt>コード</rt></ruby>、標準<ruby>譜集<rt>ライブラリー</rt></ruby>譜面、または使用している<ruby>通い箱<rt>クレート</rt></ruby>が含まれている場合があります。
`RUST_BACKTRACE`環境変数を0以外の値に設定して、バックトレースを取得してみましょう。リスト9-2は、表示されるものと同様の出力を示しています。

```text
$ RUST_BACKTRACE=1 cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/panic`
thread 'main' panicked at 'index out of bounds: the len is 3 but the index is 99', /checkout/src/liballoc/vec.rs:1555:10
stack backtrace:
   0: std::sys::imp::backtrace::tracing::imp::unwind_backtrace
             at /checkout/src/libstd/sys/unix/backtrace/tracing/gcc_s.rs:49
   1: std::sys_common::backtrace::_print
             at /checkout/src/libstd/sys_common/backtrace.rs:71
   2: std::panicking::default_hook::{{closure}}
             at /checkout/src/libstd/sys_common/backtrace.rs:60
             at /checkout/src/libstd/panicking.rs:381
   3: std::panicking::default_hook
             at /checkout/src/libstd/panicking.rs:397
   4: std::panicking::rust_panic_with_hook
             at /checkout/src/libstd/panicking.rs:611
   5: std::panicking::begin_panic
             at /checkout/src/libstd/panicking.rs:572
   6: std::panicking::begin_panic_fmt
             at /checkout/src/libstd/panicking.rs:522
   7: rust_begin_unwind
             at /checkout/src/libstd/panicking.rs:498
   8: core::panicking::panic_fmt
             at /checkout/src/libcore/panicking.rs:71
   9: core::panicking::panic_bounds_check
             at /checkout/src/libcore/panicking.rs:58
  10: <alloc::vec::Vec<T> as core::ops::index::Index<usize>>::index
             at /checkout/src/liballoc/vec.rs:1555
  11: panic::main
             at src/main.rs:4
  12: __rust_maybe_catch_panic
             at /checkout/src/libpanic_unwind/lib.rs:99
  13: std::rt::lang_start
             at /checkout/src/libstd/panicking.rs:459
             at /checkout/src/libstd/panic.rs:361
             at /checkout/src/libstd/rt.rs:61
  14: main
  15: __libc_start_main
  16: <unknown>
```

<span class="caption">リスト9-2。環境変数<code>RUST_BACKTRACE</code>が設定されているときに表示される<code>panic€</code>呼び出しによって生成されたバックトレース</span>

それは多くの出力です！　
表示される正確な出力は、<ruby>基本算系<rt>オペレーティングシステム</rt></ruby>とRustの版によって異なる場合があります。
この情報でバックトレースを取得するには、<ruby>虫取り<rt>デバッグ</rt></ruby>シンボルを有効にする必要があります。
使用している場合、<ruby>虫取り<rt>デバッグ</rt></ruby>シンボルが自動的に有効になっている`cargo build`や`cargo run`せずに`--release`フラグここに持っているとして、。

リスト9-2の出力では、バックトレースの11行目は、問題を引き起こしている企画の行を指しています*。src/main.rsの* 4行*目*。
<ruby>算譜<rt>プログラム</rt></ruby>がパニックに陥るのを避けたいのであれば、書いたファイルに言及している最初の行で指し示されている場所は調査を開始する場所です。
リスト9-1では、バックトレースを使用する方法を示すためにパニックになる<ruby>譜面<rt>コード</rt></ruby>を意図的に記述したが、パニックを修正する方法は、3つの項目のみを含むベクトルから<ruby>添字<rt>インデックス</rt></ruby>99の要素を要求しないことです。
<ruby>譜面<rt>コード</rt></ruby>が将来パニックに陥った場合、パニックを引き起こす値とその<ruby>譜面<rt>コード</rt></ruby>が何をすべきかを<ruby>譜面<rt>コード</rt></ruby>がどのような動作を取っているのか把握する必要があります。

して戻ってくる`panic!`、して使用してはならない必要があるときに`panic!`中に<ruby>誤り<rt>エラー</rt></ruby>条件を処理するために「には`panic!`たりしないように`panic!` 」この章の後の章を。
次に、`Result`を使用して<ruby>誤り<rt>エラー</rt></ruby>から回復する方法を見ていきます。
