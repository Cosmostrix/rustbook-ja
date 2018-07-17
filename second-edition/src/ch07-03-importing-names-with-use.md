## 異なる役区の名前を参照する

リスト7-7の`nested_modules`機能の呼び出しのように、役区名を呼び出しの一部として使用して役区内で定義された機能を呼び出す方法について説明しました。

<span class="filename">ファイル名。src/main.rs</span>

```rust
pub mod a {
    pub mod series {
        pub mod of {
            pub fn nested_modules() {}
        }
    }
}

fn main() {
    a::series::of::nested_modules();
}
```

<span class="caption">リスト7-7。役区のパスを完全に指定して機能を呼び出す</span>

ご覧のとおり、完全修飾名を参照するとかなり長い時間がかかります。
幸いにも、Rustはこれらの呼び出しをより簡潔にするための予約語を持っています。

### `use`予約語で有効範囲に名前を持たせる

Rustの`use`予約語は、呼び出したい機能の役区を有効範囲に持ってくることで長い機能呼び出しを短縮します。
`a::series::of`役区を二進譜通い箱のルート有効範囲に入れる例を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
pub mod a {
    pub mod series {
        pub mod of {
            pub fn nested_modules() {}
        }
    }
}

use a::series::of;

fn main() {
    of::nested_modules();
}
```

この行`use a::series::of;`
むしろフル使用するよりも意味`a::series::of`を参照したい場所にパスを`of`役区、使用することができます`of`。

`use`予約語は、有効範囲に指定したものだけを返します。役区の子を有効範囲に持ち込まない。
そのため、`nested_modules`機能を呼び出すときには`of::nested_modules`まだ`of::nested_modules`を使用する`nested_modules`ます。

代わりに機能を指定することにより、有効範囲に機能を持参することを選択した可能性があり`use`、次のように。

```rust
pub mod a {
    pub mod series {
        pub mod of {
            pub fn nested_modules() {}
        }
    }
}

use a::series::of::nested_modules;

fn main() {
    nested_modules();
}
```

そうすることで、すべての役区を除外し、機能を直接参照することができます。

列挙型は役区のような一種の名前空間を形成するので、列挙型の場合値を`use`して有効範囲に持ち込むこともできます。
どのような種類の`use`文でも、ある名前空間から複数の項目を有効範囲に持ってくる場合は、次のように中かっことカンマを最後の位置に指定できます。

```rust
enum TrafficLight {
    Red,
    Yellow,
    Green,
}

use TrafficLight::{Red, Yellow};

fn main() {
    let red = Red;
    let yellow = Yellow;
    let green = TrafficLight::Green;
}
```

`use`文に`Green`を含めなかったので、`Green`場合値の`TrafficLight`名前空間を指定して`TrafficLight`ます。

### すべての名前をGlobで有効範囲に変換

ネームスペース内のすべての項目を一度に有効範囲に入れるには、*glob演算子*と呼ばれる`*`構文を使用できます。
この例では、列挙型のすべての場合値を有効範囲に入れます。具体的に列挙する必要はありません。

```rust
enum TrafficLight {
    Red,
    Yellow,
    Green,
}

use TrafficLight::*;

fn main() {
    let red = Red;
    let yellow = Yellow;
    let green = Green;
}
```

`*`演算子は、`TrafficLight`名前空間内に表示されているすべての項目を有効範囲にします。
グロブは控えめに使用する必要があります。便利ですが、グロブが予想以上に多くの項目を引き込み、命名の競合を引き起こす可能性があります。

### `super`を使用した親役区へのアクセス

この章の冒頭で見たように、譜集通い箱を作成すると、Cargoが`tests`役区を作成します。
それについてもっと詳しく説明しましょう。
`communicator`企画で、*src/lib.rsを*開きます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub mod client;

pub mod network;

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
```

第11章ではテストの詳細を説明していますが、この例の部分は意味をなさないはず`it_works`。他の役区の隣にあり、 `it_works`という名前の機能を含む`tests`という名前の役区を持っています。
特別な補注があるにもかかわらず、`tests`役区は単なる別の役区です！　
したがって、役区階層は次のようになります。

```text
communicator
 ├── client
 ├── network
 |   └── client
 └── tests
```

テストは譜集内で譜面を実行するためのものですので、今は機能をチェックしなくても、この`it_works`機能から`client::connect`機能を呼び出そうとします。
これはまだ動作しません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        client::connect();
    }
}
```

`cargo test`命令を呼び出してテストを実行します。

```text
$ cargo test
   Compiling communicator v0.1.0 (file:///projects/communicator)
error[E0433]: failed to resolve. Use of undeclared type or module `client`
 --> src/lib.rs:9:9
  |
9 |         client::connect();
  |         ^^^^^^ Use of undeclared type or module `client`
```

製譜に失敗しましたが、なぜでしょうか？　
*src/main.rsのよう*に、`communicator`譜集の枠内にあるので、機能の前に`communicator::`を配置する必要はありません。
その理由は、パスは常に現在の役区との相対的なものであり、ここでは`tests`です。
唯一の例外は、自動的にはパスが通い箱ルートと相対的な`use`文です。
`tests`役区には`client`役区が必要です。

だから、役区階層の中の一つの役区をバックアップして、`tests`役区の`client::connect`機能を呼び出すにはどうすればいいでしょうか？　
`tests`役区では、先頭のコロンを使用してルートから開始し、次のようにパス全体をリストしたいとRustに知らせることができます。

```rust,ignore
::client::connect();
```

または、`super`を使用して、現在の役区の階層内の1つの役区を上に移動できます。

```rust,ignore
super::client::connect();
```

これらの2つの選択肢は、この例では違いはありませんが、役区階層の中で深い場合は、毎回ルートから始めると譜面が長くなります。
そのような場合、現在の役区から兄弟役区に到達するために`super`を使用するのがよい近道です。
さらに、譜面の多くの場所でルートからパスを指定し、下位ツリーを別の場所に移動して役区を再配置すると、いくつかの場所でパスを更新する必要がありますが、これは面倒です。

また、入力する必要は迷惑だろう`super::`各テストでは、しかし、あなたはすでにその解決のための道具を見てきました。 `use`！　
`super::`機能は、`use`パスを変更して、ルート役区ではなく親役区を基準にしています。

これらの理由から、特に`tests`役区では、`use super::something`が最も良い解決策です。
だからテストは次のようになります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
#[cfg(test)]
mod tests {
    use super::client;

    #[test]
    fn it_works() {
        client::connect();
    }
}
```

`cargo test`再度実行すると、テストは終了し、テスト結果の出力の最初の部分は次のようになります。

```text
$ cargo test
   Compiling communicator v0.1.0 (file:///projects/communicator)
     Running target/debug/communicator-92007ddb5330fa5a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

## 概要

これで、譜面を整理するための新しい技法が分かりました。
これらの手法を使用して、関連する機能をグループ化し、ファイルが長くなりすぎないようにし、譜集利用者に整理された公開APIを提示します。

次に、標準譜集の集まりデータ構造を見ていきます。これは、きちんとしたきれいな譜面で使用できます。
