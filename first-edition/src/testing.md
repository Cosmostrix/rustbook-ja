# テスト

> > 算譜テストは、バグの存在を示す非常に効果的な方法ですが、不在を示すために絶望的に不十分です。
> 
> > Edsger W. Dijkstra、"The Humble Programmer"（1972）

Rustの譜面をテストする方法について話しましょう。
話していないことは、Rust譜面をテストする正しい方法です。
テストを書くための正しい方法と間違った方法に関する多くの考え方があります。
これらのアプローチはすべて同じ基本道具を使用しているので、それらを使用するための構文を示します。

# `test`属性

最も簡単な方法では、Rustでの`test`は`test`属性で注釈を付けられた機能です。
Cargoで`adder`という新しい企画を作ってみましょう。

```bash
$ cargo new adder
$ cd adder
```

Cargoは、新しい企画を作成すると自動的に簡単なテストを生成します。
`src/lib.rs`内容は`src/lib.rs`です。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
    }
}
```

今のところ、`mod`ビットを削除し、機能にのみ焦点を当てましょう。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[test]
fn it_works() {
}
```

`#[test]`注意してください。
この属性は、これがテスト機能であることを示します。
現在、本体はありません。
それは合格するのに十分です！　
`cargo test`テストを実行できます。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
    Finished debug [unoptimized + debuginfo] target(s) in 0.15 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

カーゴは製譜され、テストを実行しました。
ここには2種類の出力があります。1つはテスト用に、もう1つは開発資料集テスト用です。
後でそれらについて話します。
今のところ、次の行を見てください。

```text
test it_works ... ok
```

`it_works`注意して`it_works`。
これは機能の名前から来ています。

```rust
# fn main() {
fn it_works() {
}
# }
```

要約の行も表示されます。

```text
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured
```

では、何もしないテストはなぜ合格するのでしょうか？　
`panic!`を`panic!`ないテストや、`panic!`テストは失敗します。
テストを失敗させましょう。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[test]
fn it_works() {
    assert!(false);
}
```

`assert!`は引数Rustが提供するマクロであり、引数が`true`は何も起こりません。
引数が`false`場合、それは`panic!`ます。
テストをもう一度やり直しましょう。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
    Finished debug [unoptimized + debuginfo] target(s) in 0.17 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 1 test
test it_works ... FAILED

failures:

---- it_works stdout ----
        thread 'it_works' panicked at 'assertion failed: false', src/lib.rs:5
note: Run with `RUST_BACKTRACE=1` for a backtrace.


failures:
    it_works

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured

error: test failed
```

Rustはテストが失敗したことを示します。

```text
test it_works ... FAILED
```

それは要約の行に反映されています。

```text
test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured
```

ゼロ以外の結果番号も取得します。
`$?`を使うことができます`$?`
macOSとLinuxでは。

```bash
$ echo $?
101
```

Windowsでは、`cmd`を使用している場合。

```bash
> echo %ERRORLEVEL%
```

PowerShellを使用している場合。

```bash
> echo $LASTEXITCODE # the code itself
> echo $? # a boolean, fail or succeed
```

これは、`cargo test`を他の道具立てに統合する場合に便利です。

テストの失敗を別の属性で`should_panic`ことができます。 `should_panic`。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[test]
#[should_panic]
fn it_works() {
    assert!(false);
}
```

このテストは、`panic!`た場合に成功し、完了したら失敗します。
試してみよう。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
    Finished debug [unoptimized + debuginfo] target(s) in 0.17 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

Rustは、`assert_eq!`別のマクロを提供しています。これは、2つの引数が等しいか`assert_eq!`かを比較します。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[test]
#[should_panic]
fn it_works() {
    assert_eq!("Hello", "world");
}
```

このテストは合格か失敗か
`should_panic`属性のため、次のように`should_panic`ます。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
    Finished debug [unoptimized + debuginfo] target(s) in 0.21 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

予期しない理由でテストが失敗しなかったことを保証するのが難しいため、`should_panic`テストは壊れやすい可能性があります。
これを助けるために、選択肢の`expected`パラメータを`should_panic`属性に追加することができます。
このテスト制約は、失敗メッセージに指定された文言が含まれていることを確認します。
上記の例のより安全な版は、次のようになります。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#[test]
#[should_panic(expected = "assertion failed")]
fn it_works() {
    assert_eq!("Hello", "world");
}
```

それが基本です。
「本当の」テストを書きましょう。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[test]
fn it_works() {
    assert_eq!(4, add_two(2));
}
```

これは`assert_eq!`非常に一般的な使用`assert_eq!`。いくつかの既知の引数で機能を呼び出し、それを期待される出力と比較します。

# `ignore`属性

場合によっては、一部の特定のテストが実行に非常に時間がかかることがあります。
`ignore`属性を使用すると、自動的に無効にすることが`ignore`ます。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[test]
fn it_works() {
    assert_eq!(4, add_two(2));
}

#[test]
#[ignore]
fn expensive_test() {
#    // Code that takes an hour to run...
    // 実行に1時間かかる譜面...
}
```

今、テストを実行していることがわかり`it_works`実行されますが、`expensive_test`ありません。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
    Finished debug [unoptimized + debuginfo] target(s) in 0.20 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 2 tests
test expensive_test ... ignored
test it_works ... ok

test result: ok. 1 passed; 0 failed; 1 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

時間のかかるテストは、`cargo test -- --ignored`を使用して明示的に実行できます`cargo test -- --ignored`。

```bash
$ cargo test -- --ignored
    Finished debug [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/deps/adder-941f01916ca4a642

running 1 test
test expensive_test ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

`--ignored`引数は、テスト二進譜の引数であり、`--ignored`引数ではありません。そのため、命令は`cargo test -- --ignored`です。

# `tests`役区

既存の例が慣例的ではない1つの方法があります。 `tests`役区がありません。
このテスト役区が最初に`cargo new`生成された譜面に存在していたが、最後の例では見つからなかったことに気が付いたかもしれません。
これが何をしているのか説明しよう。

例を書いている慣用的なやり方は次のようになります。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::add_two;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

ここにはいくつかの変更があります。
1つは、`cfg`属性を持つ`mod tests`導入です。
この役区を使用すると、すべてのテストをグループ化し、必要に応じて補助譜機能を定義することができます。これらは補助譜の残りの部分にはなりません。
`cfg`属性は、現在テストを実行しようとしている場合にのみテスト譜面を製譜します。
これにより、製譜時間を節約することができ、また、テストが完全に通常の組み上げから外れることも保証されます。

2番目の変更は`use`宣言です。
内部の役区であるため、テストされた機能を有効範囲に入れる必要があります。
これは大規模な役区がある場合にはわずらわしくなることがあるので、これはglobの一般的な使用です。
`src/lib.rs`を変更してみましょう。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

異なる`use`行に注意してください。
今度はテストを実行します。

```bash
$ cargo test
    Updating registry `https://github.com/rust-lang/crates.io-index`
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
     Running target/debug/deps/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

できます！　

現在の慣例では、`tests`役区を使用して 単体テストを保持します。
1つの小さな機能をテストするものはここに行くのが理にかなっています。
しかし、代わりに 統合テストはどうでしょうか？　
そのために、`tests`ディレクトリがあります。

# `tests`ディレクトリ

`tests/*.rs`ディレクトリ内の各ファイルは個別の通い箱として扱われます。
統合テストを書くには、`tests`ディレクトリを作り、その内容として`tests/integration_test.rs`ファイルを内部に入れてみましょう。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
#//# // Sadly, this code will not work in play.rust-lang.org, because we have no
# // 残念ながら、この譜面はplay.rust-lang.orgでは動作しません。
#//# // crate adder to import. You'll need to try this part on your own machine.
# // 輸入する通い箱加算器。あなた自身の機械でこの部分を試す必要があります。
extern crate adder;

#[test]
fn it_works() {
    assert_eq!(4, adder::add_two(2));
}
```

これは以前のテストと似ていますが、少し異なります。
今、`extern crate adder`上部を頂点にします。
これは、`tests`ディレクトリの各テストが完全に別個の通い箱であるため、譜集を輸入する必要があるためです。
これは、`tests`が統合テストを書くのに適した場所でもある理由です。それらは、他の消費者のように譜集を使用します。

それらを実行しましょう。

```bash
$ cargo test
   Compiling adder v0.1.0 (file:///home/you/projects/adder)
     Running target/debug/deps/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

     Running target/debug/integration_test-68064b69521c828a

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

今3つの章を持っています。以前のテストは新しいものと同様に実行されます。

Cargoは`tests/`ディレクトリの下位ディレクトリにあるファイルを無視します。
したがって、統合テストの共有役区が可能です。
たとえば、`tests/common/mod.rs`は、カーゴで別々に製譜されませんが、`mod common;`してすべてのテストで輸入できます`mod common;`

`tests`ディレクトリにはこれだけです。
`tests`役区はここでは必要ありません。なぜならすべてがテストに焦点を当てているからです。

統合テストを構築するとき、カーゴは`test`属性を製譜器に渡しません。
つまり、`cfg(test)`すべての部分は、統合テストで使用される組み上げに含まれません。

最後に、第3の章。開発資料集テストを見てみましょう。

# 開発資料集テスト

例を持つ文書より優れているものはありません。
開発資料集が書かれて以来、譜面が変更されたため、実際には動作しない例よりも悪いものはありません。
このため、Rustは開発資料で自動的に実行されるサンプルをサポートしています（**注。**これは二進譜通い箱ではなく、譜集通い箱でのみ機能します）。
ここに例を`src/lib.rs`ている`src/lib.rs`があります。

```rust,ignore
#//# // The next line exists to trick play.rust-lang.org into running our code as a
# // 次の行は、play.rust-lang.orgに譜面を
#//# // test:
# // テスト。
#//# // fn main
# //  fnメイン
#
//! The `adder` crate provides functions that add numbers to other numbers.
//!
//! # Examples
//!
//! ```
//! assert_eq!(4, adder::add_two(2));
//! ```

#///// This function adds two to its argument.
/// この機能は引数に2を加えます。
///
#///// # Examples
///  ＃例
///
#///// ```
///  `` ``
#///// use adder::add_two;
///  addder:: add_twoを使用します。
///
#///// assert_eq!(4, add_two(2));
///  assert_eq！　（4、add_two（2））;
#///// ```
///  `` ``
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

役区レベルの開発資料には`//!`を使用し、機能レベルの開発資料には`///`。
Rustの開発資料集はコメントのMarkdownをサポートしているので、3重スラッシュは譜面段落をマークします。
通常は、`# Examples`章を正確にそのように含め、その後に例を示します。

テストをもう一度やり直してみましょう。

```bash
$ cargo test
   Compiling adder v0.1.0. (file:///home/you/projects/adder)
     Running target/debug/deps/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

     Running target/debug/integration_test-68064b69521c828a

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 2 tests
test add_two_0 ... ok
test _0 ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured
```

今、3種類のテストを実行しています！　
開発資料集・テストの名前に注意してください。役区テストでは`_0`、機能テストでは`add_two_0`が生成されます。
これらは、例を追加すると、`add_two_1`などの名前で自動的に増分されます。

すべての詳細を開発資料テストを書くことでカバーしていません。
詳細については、[開発資料の章](documentation.html)を参照してください。

# テストと並列実行

テストは走脈を使用して同時に実行されることに注意することが重要です。
このため、テストがお互いや共有状態に依存しないように注意する必要があります。
「共有状態」には、現在の作業ディレクトリや環境変数などの環境も含めることができます。

これが問題の場合は、環境変数`RUST_TEST_THREADS`設定するか、テストに`--test-threads`引数を渡して、この並列実行を制御できます。

```bash
$ RUST_TEST_THREADS=1 cargo test   # Run tests with no concurrency
...
$ cargo test -- --test-threads=1   # Same as above
...
```

# テスト出力

自動的には、Rustのテスト譜集は出力を捕獲し、標準出力/誤り（例えば`println!()`からの出力）に破棄します。
これは、環境変数またはスイッチを使用して制御することもできます。


```bash
$ RUST_TEST_NOCAPTURE=1 cargo test   # Preserve stdout/stderr
...
$ cargo test -- --nocapture          # Same as above
...
```

しかし、捕獲を避けるより良い方法は、生の出力ではなく動作記録を使用することです。
Rustには[標準の動作記録APIがあり][log]、複数の動作記録実装にフロントエンドを提供します。
これは、実行時に制御できる方法で虫取り情報を出力するために、黙用の[env_logger]と組み合わせて使用​​できます。

[log]: https://crates.io/crates/log
 [env_logger]: https://crates.io/crates/env_logger

