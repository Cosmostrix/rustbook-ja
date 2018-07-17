## カーゴワークスペース

第12章では、二進譜通い箱と譜集通い箱を含むパッケージを作成しました。
企画が進展するにつれて、譜集通い箱は引き続き大きくなり、パッケージを複数の譜集通い箱にさらに分割したいと思うかもしれません。
このような状況では、Cargoには複数の関連パッケージを一元的に管理するための*ワークスペース*という機能があり*ます*。

### ワークスペースの作成

*ワークスペース*は、同じ*Cargo.lock*と出力階層を共有する一連のパッケージです。
ワークスペースを使って企画を作ってみましょう。ワークスペースの構造に集中できるように、簡単な譜面を使用します。
ワークスペースを構成するには複数の方法があります。
1つの共通の方法を示します。
二進譜と2つの譜集を含むワークスペースがあります。
主な機能を提供する二進譜は、2つの譜集に依存します。
1つの譜集は`add_one`機能を提供し、2つ目の譜集は`add_two`機能を`add_two`ます。
これらの3つの通い箱は同じワークスペースの一部になります。
作業領域の新しい階層を作成します。

```text
$ mkdir add
$ cd add
```

次に、*add*階層にワークスペース全体を構成する*Cargo.toml*ファイルを作成します。
このファイルには、他の*Cargo.toml*ファイルで見た`[package]`章やメタデータはありません。
代わりに、`[workspace]`章から開始し、二進譜通い箱へのパスを指定することでワークスペースに要素を追加できます。
この場合、そのパスは*加算器*です。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[workspace]

members = [
    "adder",
]
```

次に、*add*階層内で`cargo new`実行して、`adder`二進譜通い箱を作成します。

```text
$ cargo new --bin adder
     Created binary (application) `adder` project
```

この時点で、`cargo build`実行して作業領域を構築することができます。
*add*階層のファイルは次のようになります。

```text
├── Cargo.lock
├── Cargo.toml
├── adder
│   ├── Cargo.toml
│   └── src
│       └── main.rs
└── target
```

ワークスペースには、製譜された成果物が配置される最上位に1つの*目標・*階層ーがあります。
`adder`枠はそれ自身の*目標*階層を持たない。
たとえ、*adder*階層の中から`cargo build`を実行するとしても、製譜された成果物は*/ adder/targetを追加* *するの*ではなく、*add/target*で終わるでしょう。
Cargoは、ワークスペース内の通い箱が相互に依存するため、このようなワークスペース内の*目標*階層を構造化します。
各通い箱に独自の*目標*階層がある場合、各通い箱はワークスペース内の他の各通い箱を再製譜して、独自の*目標*階層にアーティファクトを持たせる必要があります。
1つの*目標*階層を共有することで、不必要な再構築を避けることができます。

### ワークスペースでの第2の通い箱の作成

次に、ワークスペースに別の要素通い箱を作成し、それを`add-one`と呼んでみましょう。
最上位の*Cargo.toml*を変更して、`members`リストの*追加1の*パスを指定します。

<span class="filename">ファイル名。Cargo.toml</span>

```toml
[workspace]

members = [
    "adder",
    "add-one",
]
```

次に、`add-one`という名前の新しい譜集通い箱を生成します。

```text
$ cargo new add-one
     Created library `add-one` project
```

*add*階層に次の階層とファイルが作成されます。

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

ワークスペースに譜集・通い箱があるので、二進譜・通い箱・`adder`譜集・通い箱・`add-one`依存させることができます。
まず、*addder/Cargo.toml*に`add-one`にパスの依存関係を追加する必要があります。

<span class="filename">ファイル名。adder/Cargo.toml</span>

```toml
[dependencies]

add-one = { path = "../add-one" }
```

Cargoでは、ワークスペース内の通い箱が互いに依存するとは想定されていないため、通い箱間の依存関係について明示する必要があります。

次に、`adder`枠の`add-one`枠から`add_one`機能を使用しましょう。
*adder/src/main.rs*ファイルを開き、上部に`extern crate` *crate*行を`add-one`して、新しい`add-one`譜集のcrateを有効範囲に入れます。
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

最上位の*add*階層に`cargo build`を実行して作業領域を構築しましょう！　

```text
$ cargo build
   Compiling add-one v0.1.0 (file:///projects/add/add-one)
   Compiling adder v0.1.0 (file:///projects/add/adder)
    Finished dev [unoptimized + debuginfo] target(s) in 0.68 secs
```

*add*階層から二進譜・通い箱を実行するには、`-p`引数を使用して作業領域内のどのパッケージを使用するかを指定し、`cargo run`時にパッケージ名を指定する必要があります。

```text
$ cargo run -p adder
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/adder`
Hello, world! 10 plus one is 11!
```

これは、`add-one` */ crate*に依存する*adder/src/main.rs*の譜面を実行します。

#### ワークスペース内の外部通い箱に応じて

ワークスペースには、各通い箱の階層に*Cargo.lockを置くの*ではなく、ワークスペースの最上位に1つの*Cargo.lock*ファイルしかありません。
これにより、すべての通い箱がすべての依存関係の同じ版を使用していることが保証されます。
*加算器/ Cargo.toml*と*add-one/Cargo.toml*ファイルに`rand` *crate*を*追加*すると、Cargoはそれらの両方を1つの版の`rand`解決し、1つの*Cargo.lockに*記録します。
同じ依存関係を使用するワークスペース内のすべての通い箱を作成すると、ワークスペース内の通い箱が常に互いに互換性があることを意味します。
さんが追加してみましょう`rand`に通い箱を`[dependencies]`を使用できるようにする*アドオン1/Cargo.toml*ファイルの章`rand`に通い箱を`add-one`通い箱。

<span class="filename">ファイル名。add-one/Cargo.toml</span>

```toml
[dependencies]

rand = "0.3.14"
```

`extern crate rand;`追加できるようになりました`extern crate rand;`
*add-one/src/lib.rs*ファイルに*追加*し、*add*階層に`cargo build`を実行してワークスペース全体を`cargo build`すると、`rand` *crateが読み込ま*れ製譜されます。

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
しかし、にもかかわらず、`rand`、追加しない限り、ワークスペースのどこかで使用されている、ワークスペース内の他の通い箱でそれを使用することはできません`rand`同様に彼らの*Cargo.tomlファイル*に。
たとえば、`extern crate rand;`を追加すると`extern crate rand;`
`adder`通い箱のための*/ src/main.rs*ファイルの`adder`に、誤りが表示されます。

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
`adder`通い箱を組み上げすると、*Cargo.lockの* `adder`の依存関係リストに`rand`が追加されますが、`rand`の追加コピーは入荷されません。
Cargoは、`rand`通い箱を使用する作業スペースのすべての通い箱が同じ版を使用することを保証しています。
同じ版の`rand`をワークスペースにわたって使用すると、複数のコピーを持たないため、ワークスペース内の通い箱が互いに互換性があるため、スペースが節約されます。

#### ワークスペースへのテストの追加

もう1つの機能強化のために、`add_one::add_one`機能のテストを`add_one`通い箱に追加しましょう。

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

次に、最上位の*add*階層で`cargo test`を実行します。

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

出力の最初の章は、`add-one`通い箱の`it_works`テストが`it_works`した`add-one`示しています。
次の章では、`adder`通い箱にゼロのテストが見つかり、最後の章に`add-one`通い箱の開発資料のテストがゼロである`add-one`が示されています。
このように構成された作業空間で`cargo test`を実行すると、ワークスペース内のすべての通い箱のテストが実行されます。

また、`-p`フラグを使用してテストする通い箱の名前を指定することで、最上位階層からワークスペース内の特定の1つの通い箱のテストを実行することもできます。

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

この出力は、`cargo test`では、`add-one`通い箱の`cargo test`のみを実行し、`adder`通い箱テストを実行しなかったことを示しています。

ワークスペース内の通い箱を*https://crates.io/*に公開する場合は、ワークスペース内の各通い箱を個別に公開する必要があります。
`cargo publish`命令には`--all`フラグまたは`-p`フラグがないため、各通い箱の階層に移動し、ワークスペースの各通い箱で`cargo publish`を実行して通い箱を公開する必要があります。

追加の練習をするには、`add-one`通い箱と同様の方法で、このワークスペースに`add-two`通い箱を`add-one`ください！　

企画が成長するにつれて、ワークスペースの使用を検討してください。一つの大きな譜面よりも小さく、個々の部品を理解する方が簡単です。
さらに、ワークスペース内に通い箱を保持することで、頻繁に変更されると、それらの間の調整をより簡単に行うことができます。
