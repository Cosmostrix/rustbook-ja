## カーゴ作業空間

第12章では、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱と譜集<ruby>通い箱<rt>クレート</rt></ruby>を含むパッケージを作成しました。
企画が進展するにつれて、譜集<ruby>通い箱<rt>クレート</rt></ruby>は引き続き大きくなり、パッケージを複数の譜集<ruby>通い箱<rt>クレート</rt></ruby>にさらに分割したいと思うかもしれません。
このような状況では、Cargoには複数の関連パッケージを一元的に管理するための*作業空間*という機能があり*ます*。

### 作業空間の作成

*作業空間*は、同じ*Cargo.lock*と出力ディレクトリを共有する一連のパッケージです。
作業空間を使って企画を作ってみましょう。作業空間の構造に集中できるように、簡単な<ruby>譜面<rt>コード</rt></ruby>を使用します。
作業空間を構成するには複数の方法があります。
1つの共通の方法を示します。
<ruby>二進譜<rt>バイナリ</rt></ruby>と2つの<ruby>譜集<rt>ライブラリー</rt></ruby>を含む作業空間があります。
主な機能を提供する<ruby>二進譜<rt>バイナリ</rt></ruby>は、2つの<ruby>譜集<rt>ライブラリー</rt></ruby>に依存します。
1つの<ruby>譜集<rt>ライブラリー</rt></ruby>は`add_one`機能を提供し、2つ目の<ruby>譜集<rt>ライブラリー</rt></ruby>は`add_two`機能を`add_two`ます。
これらの3つの<ruby>通い箱<rt>クレート</rt></ruby>は同じ作業空間の一部になります。
作業領域の新しいディレクトリを作成します。

```text
$ mkdir add
$ cd add
```

次に、*add*ディレクトリに作業空間全体を構成する*Cargo.toml*ファイルを作成します。
このファイルには、他の*Cargo.toml*ファイルで見た`[package]`章やメタデータはありません。
代わりに、`[workspace]`章から開始し、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱へのパスを指定することで作業空間に要素を追加できます。
この場合、そのパスは*加算器*です。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[workspace]

members = [
    "adder",
]
```

次に、*add*ディレクトリ内で`cargo new`実行して、`adder`<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱を作成します。

```text
$ cargo new --bin adder
     Created binary (application) `adder` project
```

この時点で、`cargo build`実行して作業領域を構築することができます。
*add*ディレクトリのファイルは次のようになります。

```text
├── Cargo.lock
├── Cargo.toml
├── adder
│   ├── Cargo.toml
│   └── src
│       └── main.rs
└── target
```

作業空間には、<ruby>製譜<rt>コンパイル</rt></ruby>された成果物が配置される最上位に1つの*目標・*ディレクトリーがあります。
`adder`枠はそれ自身の*目標*ディレクトリを持たない。
たとえ、*adder*ディレクトリの中から`cargo build`を実行するとしても、<ruby>製譜<rt>コンパイル</rt></ruby>された成果物は*/ adder/targetを追加* *するの*ではなく、*add/target*で終わるでしょう。
Cargoは、作業空間内の<ruby>通い箱<rt>クレート</rt></ruby>が相互に依存するため、このような作業空間内の*目標*ディレクトリを構造化します。
各<ruby>通い箱<rt>クレート</rt></ruby>に独自の*目標*ディレクトリがある場合、各<ruby>通い箱<rt>クレート</rt></ruby>は作業空間内の他の各<ruby>通い箱<rt>クレート</rt></ruby>を再<ruby>製譜<rt>コンパイル</rt></ruby>して、独自の*目標*ディレクトリにアーティファクトを持たせる必要があります。
1つの*目標*ディレクトリを共有することで、不必要な再構築を避けることができます。

### 作業空間での第2の<ruby>通い箱<rt>クレート</rt></ruby>の作成

次に、作業空間に別の要素<ruby>通い箱<rt>クレート</rt></ruby>を作成し、それを`add-one`と呼んでみましょう。
最上位の*Cargo.toml*を変更して、`members`リストの*追加1の*パスを指定します。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[workspace]

members = [
    "adder",
    "add-one",
]
```

次に、`add-one`という名前の新しい譜集<ruby>通い箱<rt>クレート</rt></ruby>を生成します。

```text
$ cargo new add-one
     Created library `add-one` project
```

*add*ディレクトリに次のディレクトリとファイルが作成されます。

```text
├── Cargo.lock
├── Cargo.toml
├── add-one
│   ├── Cargo.toml
│   └── src
│       └── lib.rs
├── adder
│   ├── Cargo.toml
│   └── src
│       └── main.rs
└── target
```

*add-one/src/lib.rs*ファイルに、`add_one`機能を追加しましょう。

<span class="filename">ファイル名。add-one/src/lib.rs</span>

```rust
pub fn add_one(x: i32) -> i32 {
    x + 1
}
```

作業空間に<ruby>譜集<rt>ライブラリー</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>があるので、<ruby>二進譜<rt>バイナリ</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>・`adder`<ruby>譜集<rt>ライブラリー</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>・`add-one`依存させることができます。
まず、*addder/Cargo.toml*に`add-one`にパスの依存関係を追加する必要があります。

<span class="filename">ファイル名。adder/Cargo.toml</span>

```toml
[dependencies]

add-one = { path = "../add-one" }
```

Cargoでは、作業空間内の<ruby>通い箱<rt>クレート</rt></ruby>が互いに依存するとは想定されていないため、<ruby>通い箱<rt>クレート</rt></ruby>間の依存関係について明示する必要があります。

次に、`adder`枠の`add-one`枠から`add_one`機能を使用しましょう。
*adder/src/main.rs*ファイルを開き、上部に`extern crate` *crate*行を`add-one`して、新しい`add-one`<ruby>譜集<rt>ライブラリー</rt></ruby>のcrateを<ruby>有効範囲<rt>スコープ</rt></ruby>に入れます。
リスト14-7のように、`main`機能を変更して`add_one`機能を呼び出します。

<span class="filename">ファイル名。adder/src/main.rs</span>

```rust,ignore
extern crate add_one;

fn main() {
    let num = 10;
    println!("Hello, world! {} plus one is {}!", num, add_one::add_one(num));
}
```

<span class="caption">リスト14-7。 <code>adder</code>通い箱の<code>add-one</code>譜集のcrateを使う</span>

最上位の*add*ディレクトリに`cargo build`を実行して作業領域を構築しましょう！　

```text
$ cargo build
   Compiling add-one v0.1.0 (file:///projects/add/add-one)
   Compiling adder v0.1.0 (file:///projects/add/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.68 secs
```

*add*ディレクトリから<ruby>二進譜<rt>バイナリ</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>を実行するには、`-p`引数を使用して作業領域内のどのパッケージを使用するかを指定し、`cargo run`時にパッケージ名を指定する必要があります。

```text
$ cargo run -p adder
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/adder`
Hello, world! 10 plus one is 11!
```

これは、`add-one` */ crate*に依存する*adder/src/main.rs*の<ruby>譜面<rt>コード</rt></ruby>を実行します。

#### 作業空間内の外部<ruby>通い箱<rt>クレート</rt></ruby>に応じて

作業空間には、各<ruby>通い箱<rt>クレート</rt></ruby>のディレクトリに*Cargo.lockを置くの*ではなく、作業空間の最上位に1つの*Cargo.lock*ファイルしかありません。
これにより、すべての<ruby>通い箱<rt>クレート</rt></ruby>がすべての依存関係の同じ版を使用していることが保証されます。
*加算器/ Cargo.toml*と*add-one/Cargo.toml*ファイルに`rand` *crate*を*追加*すると、Cargoはそれらの両方を1つの版の`rand`解決し、1つの*Cargo.lockに*記録します。
同じ依存関係を使用する作業空間内のすべての<ruby>通い箱<rt>クレート</rt></ruby>を作成すると、作業空間内の<ruby>通い箱<rt>クレート</rt></ruby>が常に互いに互換性があることを意味します。
さんが追加してみましょう`rand`に<ruby>通い箱<rt>クレート</rt></ruby>を`[dependencies]`を使用できるようにする*アドオン1/Cargo.toml*ファイルの章`rand`に<ruby>通い箱<rt>クレート</rt></ruby>を`add-one`<ruby>通い箱<rt>クレート</rt></ruby>。

<span class="filename">ファイル名。add-one/Cargo.toml</span>

```toml
[dependencies]

rand = "0.3.14"
```

`extern crate rand;`追加できるようになりました`extern crate rand;`
*add-one/src/lib.rs*ファイルに*追加*し、*add*ディレクトリに`cargo build`を実行して作業空間全体を`cargo build`すると、`rand` *crateが読み込ま*れ<ruby>製譜<rt>コンパイル</rt></ruby>されます。

```text
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.14
   --snip--
   Compiling rand v0.3.14
   Compiling add-one v0.1.0 (file:///projects/add/add-one)
   Compiling adder v0.1.0 (file:///projects/add/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 10.18 secs
```

最上位の*Cargo.lockに*、 `add-one` `rand`への依存性に関する情報が含まれるようになりました。
しかし、にもかかわらず、`rand`、追加しない限り、作業空間のどこかで使用されている、作業空間内の他の<ruby>通い箱<rt>クレート</rt></ruby>でそれを使用することはできません`rand`同様に彼らの*Cargo.tomlファイル*に。
たとえば、`extern crate rand;`を追加すると`extern crate rand;`
`adder`<ruby>通い箱<rt>クレート</rt></ruby>のための*/ src/main.rs*ファイルの`adder`に、<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
$ cargo build
   Compiling adder v0.1.0 (file:///projects/add/adder)
error: use of unstable library feature 'rand': use `rand` from crates.io (see
issue #27703)
 --> adder/src/main.rs:1:1
  |
1 | extern crate rand;
```

これを修正するには、`adder`枠の*Cargo.toml*ファイルを編集し、`rand`がその枠の依存関係であることを示します。
`adder`<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>組み上げ<rt>ビルド</rt></ruby>すると、*Cargo.lockの* `adder`の依存関係リストに`rand`が追加されますが、`rand`の追加コピーは<ruby>入荷<rt>ダウンロード</rt></ruby>されません。
Cargoは、`rand`<ruby>通い箱<rt>クレート</rt></ruby>を使用する作業スペースのすべての<ruby>通い箱<rt>クレート</rt></ruby>が同じ版を使用することを保証しています。
同じ版の`rand`を作業空間にわたって使用すると、複数のコピーを持たないため、作業空間内の<ruby>通い箱<rt>クレート</rt></ruby>が互いに互換性があるため、スペースが節約されます。

#### 作業空間へのテストの追加

もう1つの機能強化のために、`add_one::add_one`機能のテストを`add_one`<ruby>通い箱<rt>クレート</rt></ruby>に追加しましょう。

<span class="filename">ファイル名。add-one/src/lib.rs</span>

```rust
pub fn add_one(x: i32) -> i32 {
    x + 1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(3, add_one(2));
    }
}
```

次に、最上位の*add*ディレクトリで`cargo test`を実行します。

```text
$ cargo test
   Compiling add-one v0.1.0 (file:///projects/add/add-one)
   Compiling adder v0.1.0 (file:///projects/add/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.27 secs
     Running target/debug/deps/add_one-f0253159197f7841

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

     Running target/debug/deps/adder-f88af9d2cc175a5e

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests add-one

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

出力の最初の章は、`add-one`<ruby>通い箱<rt>クレート</rt></ruby>の`it_works`テストが`it_works`した`add-one`示しています。
次の章では、`adder`<ruby>通い箱<rt>クレート</rt></ruby>にゼロのテストが見つかり、最後の章に`add-one`<ruby>通い箱<rt>クレート</rt></ruby>の開発資料のテストがゼロである`add-one`が示されています。
このように構成された作業空間で`cargo test`を実行すると、作業空間内のすべての<ruby>通い箱<rt>クレート</rt></ruby>のテストが実行されます。

また、`-p`フラグを使用してテストする<ruby>通い箱<rt>クレート</rt></ruby>の名前を指定することで、最上位ディレクトリから作業空間内の特定の1つの<ruby>通い箱<rt>クレート</rt></ruby>のテストを実行することもできます。

```text
$ cargo test -p add-one
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running target/debug/deps/add_one-b3235fea9a156f74

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out

   Doc-tests add-one

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

この出力は、`cargo test`では、`add-one`<ruby>通い箱<rt>クレート</rt></ruby>の`cargo test`のみを実行し、`adder`<ruby>通い箱<rt>クレート</rt></ruby>テストを実行しなかったことを示しています。

作業空間内の<ruby>通い箱<rt>クレート</rt></ruby>を*https://crates.io/*に<ruby>公開<rt>パブリック</rt></ruby>する場合は、作業空間内の各<ruby>通い箱<rt>クレート</rt></ruby>を個別に<ruby>公開<rt>パブリック</rt></ruby>する必要があります。
`cargo publish`命令には`--all`フラグまたは`-p`フラグがないため、各<ruby>通い箱<rt>クレート</rt></ruby>のディレクトリに移動し、作業空間の各<ruby>通い箱<rt>クレート</rt></ruby>で`cargo publish`を実行して<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>する必要があります。

追加の練習をするには、`add-one`<ruby>通い箱<rt>クレート</rt></ruby>と同様の方法で、この作業空間に`add-two`<ruby>通い箱<rt>クレート</rt></ruby>を`add-one`ください！　

企画が成長するにつれて、作業空間の使用を検討してください。一つの大きな<ruby>譜面<rt>コード</rt></ruby>よりも小さく、個々の部品を理解する方が簡単です。
さらに、作業空間内に<ruby>通い箱<rt>クレート</rt></ruby>を保持することで、頻繁に変更されると、それらの間の調整をより簡単に行うことができます。
