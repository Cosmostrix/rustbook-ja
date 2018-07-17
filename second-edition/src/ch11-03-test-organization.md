## 試験機関

この章の冒頭で述べたように、テストは複雑な規律であり、異なる人々は異なる用語と組織を使用します。
Rustコミュニティでは、*ユニットテスト*と*インテグレーションテスト*という2つの主要分類の観点からテストについて考えてい*ます*。
単体テストは、小さくて集中的で、一度に1つの役区を単独でテストし、内部用接点をテストできます。
統合テストは完全に譜集の外部にあり、他の外部譜面と同じ方法で譜面を使用します。公開接点のみを使用し、テストごとに複数の役区を実行する可能性があります。

両方の種類のテストを書くことは、譜集の断片が期待することを、個別に、そして一緒に行うことを確実にするために重要です。

### 単体テスト

単体テストの目的は、譜面の各単位を他の譜面と孤立してテストして、譜面がどこにあるかを素早く特定し、期待どおりに動作しないようにすることです。
それぞれのファイルの*src*階層に単体テストを、テストしている譜面とともに入れます。
大会は、名前の役区を作成することです`tests`テスト機能を含むようにしてで役区に注釈を付けるために、各ファイル内`cfg(test)`。

#### テスト役区と`#[cfg(test)]`

テスト役区の`#[cfg(test)]`注釈は、`cargo build`を実行するときではなく、`cargo test`を実行するときにのみテスト譜面を製譜して実行するようRustに指示します。
これにより、譜集が構築され、結果として製譜された成果物にスペースが節約されるだけで、テストが含まれないため製譜時間が節約されます。
統合テストは別の階層にあるので、`#[cfg(test)]`注釈は必要ありません。
しかし、単体テストは譜面と同じファイルに格納されるため、`#[cfg(test)]`を使用して製譜結果に含めないように指定します。

この章の最初の章で新しい`adder`企画を生成したとき、Cargoがこの譜面を生成したことを思い出してください。

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

この譜面は自動的に生成されたテスト役区です。
属性`cfg`は*構成*を表しており、特定の構成選択肢を指定した場合にのみ、次の項目を含める*よう*に指示します。
この場合、構成選択肢は`test`。これは、 `test`製譜と実行のためにRustによって提供されます。
使用することにより`cfg`属性を、カーゴは、積極的にテストを実行する場合にのみ、テスト譜面を製譜する`cargo test`。
これには、`#[test]`注釈を付けられた機能に加えて、この役区内にある任意の補助機能が含まれます。

#### 内部用機能のテスト

内部用機能を直接テストする必要があるかどうか、また他の言語では内部用機能をテストすることが困難または不可能になるかどうかは、テストコミュニティ内で議論されています。
どのテストイデオロギーを遵守しているかに関係なく、Rustのプライバシールールでは内部用機能をテストできます。
リスト11-12の譜面をprivate機能`internal_adder`使って考えてみましょう。

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

<span class="caption">リスト11-12。内部用機能のテスト</span>

`internal_adder`機能は`pub`としてマークされて`pub`ませんが、テストはRust譜面だけで、`tests`役区は単なる別の役区なので、`internal_adder`を輸入して呼び出しても問題ありません。
私的機能がテストされるべきだと思っていないなら、そうするように強制型変換するRustには何もありません。

### 統合テスト

Rustでは、統合テストは完全に譜集の外部にあります。
他の譜面と同じ方法で譜集を使用します。つまり、譜集の公開APIの一部である機能のみを呼び出すことができます。
その目的は、譜集の多くの部分が正しく連携しているかどうかをテストすることです。
独自に正しく動作する譜面単位では、統合されたときに問題が発生する可能性があるため、統合譜面のテストカバレッジも重要です。
統合テストを作成するには、まず*テスト*階層が必要です。

#### *テスト*階層

企画階層の最上位に*srcの*隣に*tests*階層を作成し*ます*。
Cargoはこの階層に統合テストファイルを探すことを知っています。
次に、この階層にいくつでもテストファイルを作成することができ、Cargoはそれぞれのファイルを個々の通い箱として製譜します。

統合テストを作成しましょう。
リスト11-12の譜面を*src/lib.rs*ファイルに*残し*て、*tests*階層を作成し、*tests/integration_test.rs*という名前の新しいファイルを作成し、リスト11-13の譜面を入力します。

<span class="filename">ファイル名。tests/integration_test.rs</span>

```rust,ignore
extern crate adder;

#[test]
fn it_adds_two() {
    assert_eq!(4, adder::add_two(2));
}
```

<span class="caption">リスト11-13。 <code>adder</code>枠内の機能の統合テスト</span>

譜面の先頭に`extern crate adder`を追加しました。これは単体テストでは不要でした。
その理由は、`tests`階層内の各テストは個別の通い箱であるため、それぞれに譜集を輸入する必要があるからです。

*tests/integration_test.rs*内の譜面に`#[cfg(test)]`注釈を付ける必要はありません。
Cargoは`tests`階層を特別に扱い、`cargo test`を実行するときにのみこの階層のファイルを製譜します。
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

より多くの単体テスト機能を追加することでユニットテスト章に結果行が追加されるのと同様に、より多くのテスト機能を統合テストファイルに追加することで、この統合テストファイルの章に多くの結果行が追加されます。
各統合テストファイルには独自の章があります。したがって、*tests*階層にファイルを追加すると、より多くの統合テスト章が作成されます。

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

#### 統合テストにおける下位役区

より多くの統合テストを追加すると、*テスト*階層に複数のファイルを作成して整理するのに役立つ場合があります。
たとえば、テスト機能をテストしている機能でグループ化できます。
先に述べたように、*tests*階層内の各ファイルは独自の別の通い箱として製譜されます。

各統合テストファイルを独自の通い箱として扱うことは、エンド利用者が通い箱を使用する方法に似た別の有効範囲を作成するのに便利です。
しかし、これは、譜面を役区とファイルに分割する方法については、第7章で学習したように、*tests*階層のファイルは*srcの*ファイルと同じ動作を共有しないことを意味します。

*tests*階層内のファイルの動作が異なるのは、複数の統合テストファイルで役立つ一連のヘルパ機能があり、第7章の「役区を他のファイルに移動する」の手順を実行しようとすると最も顕著になります。それらを共通の役区に抽出します。
*テスト/ common.rsを*作成し、という名前の機能配置する場合たとえば、`setup`それには、いくつかの譜面を追加することができ`setup`複数のテストファイル内に複数のテスト機能から呼び出したいです。

<span class="filename">ファイル名。tests/common.rs</span>

```rust
pub fn setup() {
#    // setup code specific to your library's tests would go here
    // 譜集のテストに固有の設定譜面がここに入ります
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
他の統合テストファイルといくつかの譜面を共有したかっただけです。

*tests/common.rs*を作成するのではなく、テスト出力に`common`表示させないために、*tests/common/mod.rsを*作成し*ます*。
第7章の「役区ファイル算系の規則」章では、下位役区を持つ役区のファイルに*module_name/mod.rs*という命名規則を使用しました。
ここでは`common`下位役区はありませんが、このようにファイルを命名すると、Rustは`common`役区を統合テストファイルとして扱わないように指示します。
`setup`機能の譜面を*tests/common/mod.rs*に移動して*tests/common.rs*ファイルを削除すると、テスト出力の章は表示されなくなります。
*tests*階層の下位階層にあるファイルは、別々のファイルとして製譜されたり、テスト出力に章がありません。

*tests/common/mod.rs*を作成し*たら*、これを役区として統合テストファイルから使用できます。
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
宣言はリスト7-4で示した役区宣言と同じです。
次に、テスト機能では、`common::setup()`機能を呼び出すことができます。

#### 二進譜通い箱の統合テスト

企画が*src/main.rs*ファイルのみを含み、*src/lib.rs*ファイルを持たない二進譜の通い箱であれば、*tests*階層に統合テストを作成し、`extern crate` *crate*を使用して定義された機能を輸入することはできません*src/main.rs*ファイル。
譜集ー通い箱のみが、他の通い箱が呼び出して使用できる機能を公開します。
二進譜・通い箱は、単独で実行されることを意図しています。

これは、二進譜を提供Rust企画は*、SRC/lib.rsファイル*に存在している論理を呼び出す簡単な*のsrc/main.rsファイル*を持っている理由の一つです。
その構造を使用して、インテグレーションテストで*は*、 `extern crate`を使用して重要な機能を実行することによって譜集通い箱をテスト*でき*ます。
重要な機能が動作する場合は、*src/main.rs*ファイルの少量の譜面も同様に動作し、少量の譜面をテストする必要はありません。

## 概要

Rustのテスト機能は、たとえ変更を加えたとしても、譜面がどのように機能して期待通りに機能するかを指定する方法を提供します。
単体テストは譜集の別々の部分を個別に実行し、内部用な実装の詳細をテストできます。
統合テストでは、譜集の多くの部分が正しく連携していることを確認し、譜集の公開APIを使用して、外部譜面が使用するのと同じ方法で譜面をテストします。
Rustの型の算系と所有権のルールはいくつかの種類のバグを防ぐのに役立ちますが、テストが論理バグを減らすためには、譜面がどのように動作することが予想されるかに関係しています。

この章で学んだ知識とこれまでの章で学んだ知識を組み合わせて企画を進めましょう！　
