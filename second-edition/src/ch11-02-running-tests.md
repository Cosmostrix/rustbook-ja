## テストの実行方法の制御

`cargo run`譜面`cargo run`製譜され、二進譜が`cargo run`れるのと同じように、`cargo test`譜面をテストモードで製譜し、結果のテスト二進譜を実行します。
命令行選択肢を指定して、`cargo test`黙用動作を変更することができます。
たとえば、`cargo test`によって生成された二進譜の黙用の動作は、すべてのテストを並行して実行し、テスト実行中に生成された出力を捕獲し、出力が表示されないようにし、テスト結果に関連する出力を読みやすくすることです。

いくつかの命令行選択肢は`cargo test`に行き、いくつかは結果のテスト二進譜に行きます。
引数のこれらの2つの型を分離するために、あなたはに行く引数リスト`cargo test`区切りが続く`--`とテスト二進譜に行き、その後のものを。
実行`cargo test --help`あなたが使用できる選択肢が表示さ`cargo test`し、実行している`cargo test -- --help`あなたは、区切り文字の後に使用できる選択肢を表示します`--`

### 並行または連続的にテストを実行する

複数のテストを実行すると、自動的には走脈を使用して並列実行されます。
これは、テストがより速く実行されることを意味し、譜面が機能しているかどうかを迅速にフィードバックできます。
テストは同時に実行されるので、テストがお互いに依存しないか、現在の作業ディレクトリや環境変数などの共有環境を含め、共有状態に依存しないようにしてください。

たとえば、それぞれのテストで、*test-output.txt*という名前のディスク上にファイルを作成し、そのファイルにデータを書き込む譜面を実行するとします。
各テストでは、そのファイルのデータが読み込まれ、ファイルにはテストごとに異なる特定の値が含まれていることが示されます。
テストは同時に実行されるため、あるテストで別のテストがファイルを書き込んだり、読み込んだりするまでにファイルを上書きすることがあります。
2番目のテストは失敗します。譜面が正しくないためではなく、テストが並行して実行されているので、テストが互いに干渉したためです。
1つの解決策は、各テストが異なるファイルに書き込むことを確認することです。
別の解決策は、一度に1つずつテストを実行することです。

テストを並行して実行したくない場合や、使用する走脈数をより細かく制御したい場合は、テストに使用する走脈の数と`--test-threads`フラグを送信できます二進譜。
次の例を見てください。

```text
$ cargo test -- --test-threads=1
```

テスト走脈の数を`1`に設定し、算譜に並列性を使用しないように指示します。
ある走脈を使用してテストを実行すると、それらを並列に実行するより時間がかかりますが、テストが状態を共有する場合、テストは互いに干渉しません。

### 機能出力を表示する

自動的には、テストに合格すると、Rustのテスト譜集は標準出力に出力されたものをすべて取得します。
たとえば、テストで`println!`を呼び出してテストに合格すると、端末で`println!`出力が表示されません。
テストが成功したことを示す行だけが表示されます。
テストが失敗した場合は、残りの失敗メッセージと共に標準出力に表示されたものがすべて表示されます。

たとえば、譜面リスト11-10には、パラメータの値を出力して10を返すばかげた機能と、渡されたテストと失敗したテストがあります。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
fn prints_and_returns_10(a: i32) -> i32 {
    println!("I got the value {}", a);
    10
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn this_test_will_pass() {
        let value = prints_and_returns_10(4);
        assert_eq!(10, value);
    }

    #[test]
    fn this_test_will_fail() {
        let value = prints_and_returns_10(8);
        assert_eq!(5, value);
    }
}
```

<span class="caption">リスト11-10。 <code>println€</code>を呼び出す機能のテスト</span>

これらのテストを`cargo test`で実行すると、次の出力が表示されます。

```text
running 2 tests
test tests::this_test_will_pass ... ok
test tests::this_test_will_fail ... FAILED

failures:

---- tests::this_test_will_fail stdout ----
        I got the value 8
thread 'tests::this_test_will_fail' panicked at 'assertion failed: `(left == right)`
  left: `5`,
 right: `10`', src/lib.rs:19:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

failures:
    tests::this_test_will_fail

test result: FAILED. 1 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

この出力のどこ`I got the value 4`ことがわかり`I got the value 4`。これは、通過するテストが実行されたときに表示される`I got the value 4`です。
その出力が捕獲されました。
失敗したテストからの出力、`I got the value 8`、また、テストの失敗の原因を示してテストサマリー出力の章に表示されます。

テストを渡すための印字された値も表示したい場合は、--`--nocapture`フラグを使用して出力捕獲動作を無効にすることができます。

```text
$ cargo test -- --nocapture
```

リスト11-10のテストを`--nocapture`フラグで再実行すると、次のような出力が表示されます。

```text
running 2 tests
I got the value 4
I got the value 8
test tests::this_test_will_pass ... ok
thread 'tests::this_test_will_fail' panicked at 'assertion failed: `(left == right)`
  left: `5`,
 right: `10`', src/lib.rs:19:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.
test tests::this_test_will_fail ... FAILED

failures:

failures:
    tests::this_test_will_fail

test result: FAILED. 1 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out
```

テスト用の出力とテスト結果はインターリーブされていることに注意してください。
その理由は、前の章で説明したように、テストが並行して実行されているためです。
`--test-threads=1`選択肢と`--nocapture`フラグを使って、出力がどのようなものか見てみましょう！　

### 名前でテストの下位セットを実行する

場合によっては、完全なテストスイートを実行するのに時間がかかることがあります。
特定の領域の譜面で作業している場合は、その譜面に関連するテストのみを実行することができます。
あなたは、引数として実行したい`cargo test`の名前を`cargo test`渡すことで、実行するテストを選択することができます。

テストの下位セットを実行する方法を示すために、`add_two`機能に対して3つのテストを作成し（リスト11-11を参照）、実行するテストを選択します。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_two_and_two() {
        assert_eq!(4, add_two(2));
    }

    #[test]
    fn add_three_and_two() {
        assert_eq!(5, add_two(3));
    }

    #[test]
    fn one_hundred() {
        assert_eq!(102, add_two(100));
    }
}
```

<span class="caption">リスト11-11。3つの異なる名前を持つ3つのテスト</span>

前に見たように、引数を渡さずにテストを実行すると、すべてのテストが並行して実行されます。

```text
running 3 tests
test tests::add_two_and_two ... ok
test tests::add_three_and_two ... ok
test tests::one_hundred ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

#### 単一のテストの実行

テスト機能の名前を`cargo test`に渡して、そのテストのみを実行することができます。

```text
$ cargo test one_hundred
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/deps/adder-06a75b4a1f2515e9

running 1 test
test tests::one_hundred ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 2 filtered out
```

`one_hundred`という名前のテストだけが走りました。
他の2つのテストはその名前と一致しませんでした。
テスト出力では、この命令が実行したものより多くのテストが要約行の最後に`2 filtered out`れて表示`2 filtered out`ていることがわかります。

このように複数のテストの名前を指定することはできません。
`cargo test`与えられた最初の値のみが使用されます。
しかし、複数のテストを実行する方法があります。

#### 複数のテストを実行するためのフィルタリング

テスト名の一部を指定することができ、その名前と一致する名前のテストが実行されます。
たとえば、テストの名前のうち2つに`add`が含まれているため、`cargo test add`実行して2つの`cargo test add`実行できます。

```text
$ cargo test add
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/deps/adder-06a75b4a1f2515e9

running 2 tests
test tests::add_two_and_two ... ok
test tests::add_three_and_two ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 1 filtered out
```

この命令は、すべてのテストを名前付きで`add`して実行し、`one_hundred`という名前のテストを除外しました。
また、テストが表示される役区はテストの名前の一部になりますので、役区の名前をフィルタリングして役区内のすべてのテストを実行できます。

### 特に要求されない限り、いくつかのテストを無視する

場合によっては、一部の特定のテストが実行に非常に時間がかかることがあるので、ほとんどの`cargo test`実行中にそれらを除外したい場合があります。
あなたが実行したいすべてのテストを引数として列挙するのではなく、時間のかかるテストに`ignore`属性を使用して注釈を付けて除外することが`ignore`ます。

<span class="filename">ファイル名。src / lib.rs</span>

```rust
#[test]
fn it_works() {
    assert_eq!(2 + 2, 4);
}

#[test]
#[ignore]
fn expensive_test() {
#    // code that takes an hour to run
    // 実行に1時間かかる譜面
}
```

`#[test]`後、`#[ignore]`行を除外したいテストに追加します。
テストを実行すると、`it_works`実行されますが、`expensive_test`ません。

```text
$ cargo test
   Compiling adder v0.1.0 (file:///projects/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.24 secs
     Running target/debug/deps/adder-ce99bcc2479f4607

running 2 tests
test expensive_test ... ignored
test it_works ... ok

test result: ok. 1 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out
```

`expensive_test`機能は`ignored`ます。
無視されたテストだけを実行したい場合、`cargo test -- --ignored`を使うことができます`cargo test -- --ignored`。

```text
$ cargo test -- --ignored
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/deps/adder-ce99bcc2479f4607

running 1 test
test expensive_test ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 1 filtered out
```

どのテストを実行するかを制御することで、`cargo test`結果が速くなるようにすることができます。
`ignored`テストの結果をチェックするのが得意で、結果を待つ時間があるときは、代わりに`cargo test -- --ignored`実行できます。
