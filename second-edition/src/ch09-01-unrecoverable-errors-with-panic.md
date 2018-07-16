## `panic!`回復不能な誤り

時には、あなたの譜面に悪いことが起こることもあります。あなたができることは何もありません。
このような場合、Rustには`panic!`マクロがあります。
`panic!`マクロが実行されると、算譜は失敗メッセージを出力し、山の巻き戻しと後始末を行い、終了します。
これは最も一般的には、何らかのバグが検出されたときに発生し、演譜師に誤りを処理する方法が明確でない場合に発生します。

> ### パニックに対する山の巻き戻しまたは中止
> 
> > 自動的には、パニックが発生すると、算譜は*巻き戻しを*開始します。これは、Rustが山をウォークバックし、遭遇した各機能からデータを後始末することを意味します。
> > しかし、この歩き戻って後始末は多くの仕事です。
> > 代わりに、即座に*中止*することができます。これは、後始末せずに算譜を終了します。
> > 算譜が使用していた記憶は、オペレーティングシステムによって後始末する必要があります。
> > 企画内で二進譜を可能な限り小さくする必要がある場合は、`panic = 'abort'`を*Cargo.toml*ファイルの適切な`[profile]`章に追加することで、パニック時に巻き戻しから打ち切りに切り替えることができます。
> > たとえば、リリースモードでパニックを中止する場合は、次のように追加します。
> 
> ```toml
> [profile.release]
> panic = 'abort'
> ```

簡単な算譜で`panic!`呼び出すようにしましょう。

<span class="filename">ファイル名。src / main.rs</span>

```rust,should_panic
fn main() {
    panic!("crash and burn");
}
```

算譜を実行すると、次のように表示されます。

```text
$ cargo run
   Compiling panic v0.1.0 (file:///projects/panic)
    Finished dev [unoptimized + debuginfo] target(s) in 0.25 secs
     Running `target/debug/panic`
thread 'main' panicked at 'crash and burn', src/main.rs:2:4
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

`panic!`呼び出すと、最後の2行に含まれる誤りメッセージが表示されます。
*2。4は*、第2行、私たち*のsrc / main.rsファイル*の4番目の文字であるということを示している*のsrc / main.rs。*最初の行は、パニックメッセージとパニックが発生し、当社の原譜内の場所を示しています。

この場合、示された行は譜面の一部です。その行に行くと、`panic!`マクロ呼び出しが表示されます。
他のケースでは、`panic!`呼び出しは譜面で呼び出され、誤りメッセージによって報告されたファイル名と行番号は、最終的に導かれる譜面の行ではなく`panic!`列が呼び出される他の誰かの譜面になります`panic!`通話に
問題の原因となっている譜面の部分を理解するために、`panic!`呼び出しの機能のバックトレースを使用することができます。
次に、バックトレースの詳細を次に説明します。

### `panic!`バックトレースを使用する

マクロを直接呼び出す譜面ではなく、譜面のバグのために`panic!`な呼び出しが譜集ーから来たときの状況を見てみましょう。
譜面リスト9-1に、ベクトルの添字で要素にアクセスしようとする譜面があります。

<span class="filename">ファイル名。src / main.rs</span>

```rust,should_panic
fn main() {
    let v = vec![1, 2, 3];

    v[99];
}
```

<span class="caption">譜面リスト9-1。ベクトルの終わりを超えて要素にアクセスしようとすると<code>panic€</code></span>

ここでは、ベクトルの100番目の要素（添字がゼロから始まるため、添字99にあります）にアクセスしようとしていますが、要素は3つしかありません。
この状況では、Rustはパニックに陥ります。
`[]`を使用すると要素が返されるはずですが、無効な添字を渡すと、ここでRustが正しい要素を返す要素はありません。

Cのような他の言語は、あなたが望むものではないにしても、あなたがこのような状況であなたが求めたものを正確に与えるようにしようとします。ベクトルの要素に対応する記憶上の場所たとえ記憶がベクトルに属していなくても。
これは*バッファオーバーレイ*と呼ばれ、攻撃者が配列の後に格納されてはならないデータを読み取るような方法で添字を操作できると、セキュリティ上の脆弱性につながる可能性があります。

この種の脆弱性から算譜を保護するために、存在しない添字の要素を読み込もうとすると、Rustは実行を停止し、続行を拒否します。
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

この誤りは、書き込んでいないファイル、*vec.rs*を指しています。
これは、標準譜集の`Vec<T>`実装です。
ベクトル`v` `[]`を使用したときに実行される譜面は、*vec.rs内*にあり、`panic!`が実際に起こっている場所です。

次のノート・行は、`RUST_BACKTRACE`環境変数を設定して、誤りの原因となったもののバックトレースを取得できることを示しています。
*バックトレース*は、この時点までに呼び出されたすべての機能のリストです。
Backtraces in Rustは他の言語と同じように動作します。バックトレースを読むための鍵は、最初から書いたファイルが見えるまで読むことです。
問題が発生した場所です。
あなたのファイルに言及している行の上の行は、あなたの譜面が呼び出す譜面です。
以下の行はあなたの譜面を呼び出す譜面です。
これらの行には、コアRust譜面、標準譜集譜面、または使用している通い箱が含まれている場合があります。
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
表示される正確な出力は、オペレーティングシステムとRustの版によって異なる場合があります。
この情報でバックトレースを取得するには、虫取りシンボルを有効にする必要があります。
使用している場合、虫取りシンボルが自動的に有効になっている`cargo build`や`cargo run`せずに`--release`フラグここに持っているとして、。

リスト9-2の出力では、バックトレースの11行目は、問題を引き起こしている企画の行を指しています*。src / main.rsの* 4行*目*。
算譜がパニックに陥るのを避けたいのであれば、書いたファイルに言及している最初の行で指し示されている場所は調査を開始する場所です。
リスト9-1では、バックトレースを使用する方法を示すためにパニックになる譜面を意図的に記述したが、パニックを修正する方法は、3つの項目のみを含むベクトルから添字99の要素を要求しないことです。
譜面が将来パニックに陥った場合、パニックを引き起こす値とその譜面が何をすべきかを譜面がどのような動作を取っているのか把握する必要があります。

して戻ってくる`panic!`、して使用してはならない必要があるときに`panic!`中に誤り条件を処理するために「には`panic!`たりしないように`panic!` 」この章の後の章を。
次に、`Result`を使用して誤りから回復する方法を見ていきます。
