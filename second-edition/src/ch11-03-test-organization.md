## 試験機関

この章の冒頭で述べたように、テストは複雑な規律であり、異なる人々は異なる用語と組織を使用します。
Rustコミュニティでは、*ユニットテスト*と*インテグレーションテスト*という2つの主要分類の観点からテストについて考えてい*ます*。
単体テストは、小さくて集中的で、一度に1つの<ruby>役区<rt>モジュール</rt></ruby>を単独でテストし、<ruby>内部用<rt>プライベート</rt></ruby>接点をテストできます。
統合テストは完全に<ruby>譜集<rt>ライブラリー</rt></ruby>の外部にあり、他の外部<ruby>譜面<rt>コード</rt></ruby>と同じ方法で<ruby>譜面<rt>コード</rt></ruby>を使用します。<ruby>公開<rt>パブリック</rt></ruby>接点のみを使用し、テストごとに複数の<ruby>役区<rt>モジュール</rt></ruby>を実行する可能性があります。

両方の種類のテストを書くことは、<ruby>譜集<rt>ライブラリー</rt></ruby>の断片が期待することを、個別に、そして一緒に行うことを確実にするために重要です。

### 単体テスト

単体テストの目的は、<ruby>譜面<rt>コード</rt></ruby>の各単位を他の<ruby>譜面<rt>コード</rt></ruby>と孤立してテストして、<ruby>譜面<rt>コード</rt></ruby>がどこにあるかを素早く特定し、期待どおりに動作しないようにすることです。
それぞれのファイルの*src*ディレクトリに単体テストを、テストしている<ruby>譜面<rt>コード</rt></ruby>とともに入れます。
大会は、名前の<ruby>役区<rt>モジュール</rt></ruby>を作成することです`tests`テスト機能を含むようにしてで<ruby>役区<rt>モジュール</rt></ruby>に<ruby>注釈<rt>コメント</rt></ruby>を付けるために、各ファイル内`cfg(test)`。

#### テスト<ruby>役区<rt>モジュール</rt></ruby>と`#[cfg(test)]`

テスト<ruby>役区<rt>モジュール</rt></ruby>の`#[cfg(test)]`<ruby>注釈<rt>コメント</rt></ruby>は、`cargo build`を実行するときではなく、`cargo test`を実行するときにのみテスト<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して実行するようRustに指示します。
これにより、<ruby>譜集<rt>ライブラリー</rt></ruby>が構築され、結果として<ruby>製譜<rt>コンパイル</rt></ruby>された成果物にスペースが節約されるだけで、テストが含まれないため<ruby>製譜<rt>コンパイル</rt></ruby>時間が節約されます。
統合テストは別のディレクトリにあるので、`#[cfg(test)]`<ruby>注釈<rt>コメント</rt></ruby>は必要ありません。
しかし、単体テストは<ruby>譜面<rt>コード</rt></ruby>と同じファイルに格納されるため、`#[cfg(test)]`を使用して<ruby>製譜<rt>コンパイル</rt></ruby>結果に含めないように指定します。

この章の最初の章で新しい`adder`企画を生成したとき、Cargoがこの<ruby>譜面<rt>コード</rt></ruby>を生成したことを思い出してください。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
```

この<ruby>譜面<rt>コード</rt></ruby>は自動的に生成されたテスト<ruby>役区<rt>モジュール</rt></ruby>です。
属性`cfg`は*構成*を表しており、特定の構成<ruby>選択肢<rt>オプション</rt></ruby>を指定した場合にのみ、次の項目を含める*よう*に指示します。
この場合、構成<ruby>選択肢<rt>オプション</rt></ruby>は`test`。これは、 `test`<ruby>製譜<rt>コンパイル</rt></ruby>と実行のためにRustによって提供されます。
使用することにより`cfg`属性を、カーゴは、積極的にテストを実行する場合にのみ、テスト<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>する`cargo test`。
これには、`#[test]`<ruby>注釈<rt>コメント</rt></ruby>を付けられた機能に加えて、この<ruby>役区<rt>モジュール</rt></ruby>内にある任意の補助譜機能が含まれます。

#### <ruby>内部用<rt>プライベート</rt></ruby>機能のテスト

<ruby>内部用<rt>プライベート</rt></ruby>機能を直接テストする必要があるかどうか、また他の言語では<ruby>内部用<rt>プライベート</rt></ruby>機能をテストすることが困難または不可能になるかどうかは、テストコミュニティ内で議論されています。
どのテストイデオロギーを遵守しているかに関係なく、Rustのプライバシールールでは<ruby>内部用<rt>プライベート</rt></ruby>機能をテストできます。
リスト11-12の<ruby>譜面<rt>コード</rt></ruby>をprivate機能`internal_adder`使って考えてみましょう。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
pub fn add_two(a: i32) -> i32 {
    internal_adder(a, 2)
}

fn internal_adder(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn internal() {
        assert_eq!(4, internal_adder(2, 2));
    }
}
```

<span class="caption">リスト11-12。<ruby>内部用<rt>プライベート</rt></ruby>機能のテスト</span>

`internal_adder`機能は`pub`としてマークされて`pub`ませんが、テストはRust<ruby>譜面<rt>コード</rt></ruby>だけで、`tests`<ruby>役区<rt>モジュール</rt></ruby>は単なる別の<ruby>役区<rt>モジュール</rt></ruby>なので、`internal_adder`を<ruby>輸入<rt>インポート</rt></ruby>して呼び出しても問題ありません。
私的機能がテストされるべきだと思っていないなら、そうするように強制型変換するRustには何もありません。

### 統合テスト

Rustでは、統合テストは完全に<ruby>譜集<rt>ライブラリー</rt></ruby>の外部にあります。
他の<ruby>譜面<rt>コード</rt></ruby>と同じ方法で<ruby>譜集<rt>ライブラリー</rt></ruby>を使用します。つまり、<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>公開<rt>パブリック</rt></ruby>APIの一部である機能のみを呼び出すことができます。
その目的は、<ruby>譜集<rt>ライブラリー</rt></ruby>の多くの部分が正しく連携しているかどうかをテストすることです。
独自に正しく動作する<ruby>譜面<rt>コード</rt></ruby>単位では、統合されたときに問題が発生する可能性があるため、統合<ruby>譜面<rt>コード</rt></ruby>のテストカバレッジも重要です。
統合テストを作成するには、まず*テスト*ディレクトリが必要です。

#### *テスト*ディレクトリ

企画ディレクトリの最上位に*srcの*隣に*tests*ディレクトリを作成し*ます*。
Cargoはこのディレクトリに統合テストファイルを探すことを知っています。
次に、このディレクトリにいくつでもテストファイルを作成することができ、Cargoはそれぞれのファイルを個々の<ruby>通い箱<rt>クレート</rt></ruby>として<ruby>製譜<rt>コンパイル</rt></ruby>します。

統合テストを作成しましょう。
リスト11-12の<ruby>譜面<rt>コード</rt></ruby>を*src/lib.rs*ファイルに*残し*て、*tests*ディレクトリを作成し、*tests/integration_test.rs*という名前の新しいファイルを作成し、リスト11-13の<ruby>譜面<rt>コード</rt></ruby>を入力します。

<span class="filename">ファイル名。tests/integration_test.rs</span>

```rust,ignore
extern crate adder;

#[test]
fn it_adds_two() {
    assert_eq!(4, adder::add_two(2));
}
```

<span class="caption">リスト11-13。 <code>adder</code>枠内の機能の統合テスト</span>

<ruby>譜面<rt>コード</rt></ruby>の先頭に`extern crate adder`を追加しました。これは単体テストでは不要でした。
その理由は、`tests`ディレクトリ内の各テストは個別の<ruby>通い箱<rt>クレート</rt></ruby>であるため、それぞれに<ruby>譜集<rt>ライブラリー</rt></ruby>を<ruby>輸入<rt>インポート</rt></ruby>する必要があるからです。

*tests/integration_test.rs*内の<ruby>譜面<rt>コード</rt></ruby>に`#[cfg(test)]`<ruby>注釈<rt>コメント</rt></ruby>を付ける必要はありません。
Cargoは`tests`ディレクトリを特別に扱い、`cargo test`を実行するときにのみこのディレクトリのファイルを<ruby>製譜<rt>コンパイル</rt></ruby>します。
今すぐ`cargo test`実行してください。

```text
$ cargo test
   Compiling adder v0.1.0 (file:///projects/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running target/debug/deps/adder-abcabcabc

running 1 test
test tests::internal ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

     Running target/debug/deps/integration_test-ce99bcc2479f4607

running 1 test
test it_adds_two ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

出力の3つの章には、ユニットテスト、統合テスト、および開発資料テストが含まれます。
単体テストの最初の章は、見てきたものと同じです。単体テストごとに1行（リスト11-12で追加した名前の`internal`）と単体テストの要約行。

統合テスト章は、`Running target/debug/deps/integration-test-ce99bcc2479f4607`という行で始まります（出力の最後のハッシュは異なります）。
次に、その統合テストの各テスト機能の行と、`Doc-tests adder`章が開始する直前の統合テストの結果の要約行があります。

より多くの単体テスト機能を追加することでユニットテスト章に結果ラインが追加されるのと同様に、より多くのテスト機能を統合テストファイルに追加することで、この統合テストファイルの章に多くの結果ラインが追加されます。
各統合テストファイルには独自の章があります。したがって、*tests*ディレクトリにファイルを追加すると、より多くの統合テスト章が作成されます。

`cargo test`引数としてテスト機能の名前を指定することで、特定の統合テスト機能を実行することができます。
特定の統合テストファイル内のすべてのテストを実行するには、`cargo test` `--test`引数の後にファイルの名前を指定します。

```text
$ cargo test --test integration_test
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/integration_test-952a27e0126bb565

running 1 test
test it_adds_two ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

この命令は、*tests/integration_test.rs*ファイル内の*テスト*のみを実行します。

#### 統合テストにおける下位<ruby>役区<rt>モジュール</rt></ruby>

より多くの統合テストを追加すると、*テスト*ディレクトリに複数のファイルを作成して整理するのに役立つ場合があります。
たとえば、テスト機能をテストしている機能でグループ化できます。
先に述べたように、*tests*ディレクトリ内の各ファイルは独自の別の<ruby>通い箱<rt>クレート</rt></ruby>として<ruby>製譜<rt>コンパイル</rt></ruby>されます。

各統合テストファイルを独自の<ruby>通い箱<rt>クレート</rt></ruby>として扱うことは、エンド利用者が<ruby>通い箱<rt>クレート</rt></ruby>を使用する方法に似た別の<ruby>有効範囲<rt>スコープ</rt></ruby>を作成するのに便利です。
しかし、これは、<ruby>譜面<rt>コード</rt></ruby>を<ruby>役区<rt>モジュール</rt></ruby>とファイルに分割する方法については、第7章で学習したように、*tests*ディレクトリのファイルは*srcの*ファイルと同じ動作を共有しないことを意味します。

*tests*ディレクトリ内のファイルの動作が異なるのは、複数の統合テストファイルで役立つ一連のヘルパ機能があり、第7章の「<ruby>役区<rt>モジュール</rt></ruby>を他のファイルに移動する」の手順を実行しようとすると最も顕著になります。それらを共通の<ruby>役区<rt>モジュール</rt></ruby>に抽出します。
*テスト/ common.rsを*作成し、という名前の機能配置する場合たとえば、`setup`それには、いくつかの<ruby>譜面<rt>コード</rt></ruby>を追加することができ`setup`複数のテストファイル内に複数のテスト機能から呼び出したいです。

<span class="filename">ファイル名。tests/common.rs</span>

```rust
pub fn setup() {
#    // setup code specific to your library's tests would go here
    // <ruby>譜集<rt>ライブラリー</rt></ruby>のテストに固有の設定<ruby>譜面<rt>コード</rt></ruby>がここに入ります
}
```

テストをもう一度実行すると、*common.rs*ファイルのテスト出力に新しい章が表示されます。ただし、このファイルにはテスト機能が含まれていなくても、どこからでも`setup`機能を呼び出すことはできません。

```text
running 1 test
test tests::internal ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

     Running target/debug/deps/common-b8b07b6f1be2db70

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

     Running target/debug/deps/integration_test-d993c68b431d39df

running 1 test
test it_adds_two ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

`running 0 tests`表示し`running 0 tests`テスト結果に`common`表示させることは、望むものではありません。
他の統合テストファイルといくつかの<ruby>譜面<rt>コード</rt></ruby>を共有したかっただけです。

*tests/common.rs*を作成するのではなく、テスト出力に`common`表示させないために、*tests/common/mod.rsを*作成し*ます*。
第7章の「<ruby>役区<rt>モジュール</rt></ruby>ファイルシステムの規則」章では、下位<ruby>役区<rt>モジュール</rt></ruby>を持つ<ruby>役区<rt>モジュール</rt></ruby>のファイルに*module_name/mod.rs*という命名規則を使用しました。
ここでは`common`下位<ruby>役区<rt>モジュール</rt></ruby>はありませんが、このようにファイルを命名すると、Rustは`common`<ruby>役区<rt>モジュール</rt></ruby>を統合テストファイルとして扱わないように指示します。
`setup`機能の<ruby>譜面<rt>コード</rt></ruby>を*tests/common/mod.rs*に移動して*tests/common.rs*ファイルを削除すると、テスト出力の章は表示されなくなります。
*tests*ディレクトリの下位ディレクトリにあるファイルは、別々のファイルとして<ruby>製譜<rt>コンパイル</rt></ruby>されたり、テスト出力に章がありません。

*tests/common/mod.rs*を作成し*たら*、これを<ruby>役区<rt>モジュール</rt></ruby>として統合テストファイルから使用できます。
次に、*tests/integration_test.rsの* `it_adds_two`テストから`setup`機能を呼び出す例を示し`setup`。

<span class="filename">ファイル名。tests/integration_test.rs</span>

```rust,ignore
extern crate adder;

mod common;

#[test]
fn it_adds_two() {
    common::setup();
    assert_eq!(4, adder::add_two(2));
}
```

注意してください`mod common;`
宣言はリスト7-4で示した<ruby>役区<rt>モジュール</rt></ruby>宣言と同じです。
次に、テスト機能では、`common::setup()`機能を呼び出すことができます。

#### <ruby>二進譜<rt>バイナリ</rt></ruby>通い箱の統合テスト

企画が*src/main.rs*ファイルのみを含み、*src/lib.rs*ファイルを持たない<ruby>二進譜<rt>バイナリ</rt></ruby>の<ruby>通い箱<rt>クレート</rt></ruby>であれば、*tests*ディレクトリに統合テストを作成し、`extern crate` *crate*を使用して定義された機能を<ruby>輸入<rt>インポート</rt></ruby>することはできません*src/main.rs*ファイル。
<ruby>譜集<rt>ライブラリー</rt></ruby>ー<ruby>通い箱<rt>クレート</rt></ruby>のみが、他の<ruby>通い箱<rt>クレート</rt></ruby>が呼び出して使用できる機能を<ruby>公開<rt>パブリック</rt></ruby>します。
<ruby>二進譜<rt>バイナリ</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>は、単独で実行されることを意図しています。

これは、<ruby>二進譜<rt>バイナリ</rt></ruby>を提供Rust企画は*、SRC/lib.rsファイル*に存在している<ruby>論理<rt>ロジック</rt></ruby>を呼び出す簡単な*のsrc/main.rsファイル*を持っている理由の一つです。
その構造を使用して、インテグレーションテストで*は*、 `extern crate`を使用して重要な機能を実行することによって譜集<ruby>通い箱<rt>クレート</rt></ruby>をテスト*でき*ます。
重要な機能が動作する場合は、*src/main.rs*ファイルの少量の<ruby>譜面<rt>コード</rt></ruby>も同様に動作し、少量の<ruby>譜面<rt>コード</rt></ruby>をテストする必要はありません。

## 概要

Rustのテスト機能は、たとえ変更を加えたとしても、<ruby>譜面<rt>コード</rt></ruby>がどのように機能して期待通りに機能するかを指定する方法を提供します。
単体テストは<ruby>譜集<rt>ライブラリー</rt></ruby>の別々の部分を個別に実行し、<ruby>内部用<rt>プライベート</rt></ruby>な実装の詳細をテストできます。
統合テストでは、<ruby>譜集<rt>ライブラリー</rt></ruby>の多くの部分が正しく連携していることを確認し、<ruby>譜集<rt>ライブラリー</rt></ruby>の<ruby>公開<rt>パブリック</rt></ruby>APIを使用して、外部<ruby>譜面<rt>コード</rt></ruby>が使用するのと同じ方法で<ruby>譜面<rt>コード</rt></ruby>をテストします。
Rustの型体系と所有権のルールはいくつかの種類のバグを防ぐのに役立ちますが、テストが<ruby>論理<rt>ロジック</rt></ruby>バグを減らすためには、<ruby>譜面<rt>コード</rt></ruby>がどのように動作することが予想されるかに関係しています。

この章で学んだ知識とこれまでの章で学んだ知識を組み合わせて企画を進めましょう！　
