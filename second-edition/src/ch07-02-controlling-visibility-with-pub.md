## `pub`可視性の制御

リスト7-5の誤りメッセージは、`network`および`network::server`譜面を*src / network / mod.rs*ファイルと*src / network / server.rs*ファイルにそれぞれ移動して解決しました。
その時点で、`cargo build`は企画を組み上げできましたが、`client::connect`、 `network::connect`、および`network::server::connect`機能が使用されていないという警告メッセージが表示されます。

では、なぜこれらの警告を受けているのでしょうか？　
結局のところ、自分の企画の中で必ずしもそうではなく、*ユーザー*によって使用されることを意図した機能を持つ譜集を構築しているので、これらの`connect`機能は使用されなくてもかまいません。
それらを作成することのポイントは、自分の企画ではなく別の企画で使用されることです。

この算譜がなぜこれらの警告を呼び出すのかを理解するために、別の企画の`communicator`譜集を外部から呼び出すことを試みてみましょう。
これを行うには、この譜面を含む*src / main.rs*ファイルを作成して、譜集通い箱と同じディレクトリに二進譜通い箱を作成します。

<span class="filename">ファイル名。src / main.rs</span>

```rust,ignore
extern crate communicator;

fn main() {
    communicator::client::connect();
}
```

`extern crate`命令を使用して、`communicator`譜集通い箱を有効範囲にします。
パッケージには*2つの*通い箱が入っています。
Cargoは*src / main.rs*を、ルートファイルが*src / lib.rs*である既存の譜集通い箱とは別の二進譜通い箱のルートファイルとして扱います。
このパターンは実行可能な企画では非常に一般的です。ほとんどの機能は譜集通い箱にあり、二進譜通い箱はその譜集通い箱を使用します。
その結果、他の算譜でも譜集通い箱を使用することができ、それは良い関心の分離です。

探している`communicator`譜集ー外の通い箱の観点からは、作成している役区はすべて、通い箱・`communicator`と同じ名前の役区内にあります。
通い箱の最上位役区を*ルート役区*と呼び*ます*。

また、企画の下位役区内の外部通い箱を使用している場合でも、ご注意`extern crate`（それほど*のsrc / main.rs*または*SRC / lib.rs*で）ルート役区に行く必要があります。
次に、下位役区では、項目が最上位の役区であるかのように、外部通い箱の項目を参照できます。

今、二進譜・通い箱は、`client`役区から譜集の`connect`機能を呼び出すだけです。
しかし、`cargo build`を呼び出すと、警告の後に誤りが表示されます。

```text
error[E0603]: module `client` is private
 --> src/main.rs:4:5
  |
4 |     communicator::client::connect();
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

ああ！　
この誤りは、`client`役区が内部用であることを示しています。これは警告の要点です。
それはまた、Rustの文脈で*公的*および*私的*という概念に入ったのは初めてです。
Rustのすべての譜面の黙用状態は内部用です。誰も譜面を使用することはできません。
算譜内で内部用機能を使用しない場合は、算譜がその機能を使用できる唯一の譜面であるため、Rustはその機能が使用されていないことを警告します。

`client::connect`ような機能がpublicであると指定した後は、二進譜通い箱からその機能への呼び出しを許可するだけでなく、その機能が使用されていないという警告が消えます。
機能を公開としてマークすると、機能が算譜外の譜面で使用されることがRustに通知されます。
Rustは、機能が "使用されている"として現在考えられる理論上の外部使用を考慮します。したがって、機能がpublicとマークされている場合、Rustは算譜で使用する必要はなく、機能が未使用であることの警告を停止します。

### 機能を公開にする

Rustに機能を公開させるために、`pub`予約語を宣言の先頭に追加し`pub`。
ここでは、`client::connect`が現在使用されていないことと、``module `client` is private``たちの二進譜通い箱の``module `client` is private``誤りであることを示す警告を修正することに焦点を当てます。
*src / lib.rs*を変更して`client`役区を公開にし`client`。

<span class="filename">ファイル名。src / lib.rs</span>

```rust,ignore
pub mod client;

mod network;
```

`pub`予約語は`mod`直前に置かれます。
もう一度組み上げしてみましょう。

```text
error[E0603]: function `connect` is private
 --> src/main.rs:4:5
  |
4 |     communicator::client::connect();
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

やめ！　
別の誤りがあります。
はい、異なる誤りメッセージがお祝いの原因です。
新しい誤りは``function `connect` is private``であることを示してい``function `connect` is private``ので、*src / client.rs*を編集して`client::connect` publicにしましょう。

<span class="filename">ファイル名。src / client.rs</span>

```rust
pub fn connect() {
}
```

今度は再び`cargo build`実行してください。

```text
warning: function is never used: `connect`
 --> src/network/mod.rs:1:1
  |
1 | / fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default

warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 | / fn connect() {
2 | | }
  | |_^
```

製譜された譜面と、`client::connect`が使用されていないという警告は消えました！　

未使用の譜面の警告は、譜面内の項目を公開する必要があることを必ずしも示すもので*はありませ*ん。これらの機能を公開APIの一部にしたく*ない*場合*は*、未使用の譜面の警告により、あなたは安全に削除することができます。
この機能が呼び出される譜集内のすべての場所を誤って削除した場合は、バグに警告することもできます。

しかし、この場合、他の2つの機能を通い箱の公開APIの一部に*し*たいので、残っている警告を取り除くためにそれらを`pub`としてマークしましょう。
*src / network / mod.rs*を次のように変更します。

<span class="filename">ファイル名。src / network / mod.rs</span>

```rust,ignore
pub fn connect() {
}

mod server;
```

次に、譜面を製譜します。

```text
warning: function is never used: `connect`
 --> src/network/mod.rs:1:1
  |
1 | / pub fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default

warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 | / fn connect() {
2 | | }
  | |_^
```

`network::connect`が`pub`設定されているにもかかわらず、未使用の機能警告が表示されて`pub`ます。
その理由は、機能が役区内でpublicであるが、機能が存在する`network`役区がpublicでないためです。
今回は譜集の内部から作業していますが、`client::connect`では外部から作業しました*。src / lib.rs*を変更して`network`公開する必要があります。

<span class="filename">ファイル名。src / lib.rs</span>

```rust,ignore
pub mod client;

pub mod network;
```

今製譜すると、その警告は消えてしまいます。

```text
warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 | / fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default
```

1つの警告だけが残っています -あなた自身でこれを修正しよう！　

### プライバシールール

全体的に、これらは項目の可視性のためのルールです。

- 項目が公開されている場合は、その親役区のいずれかを介してアクセスできます。
- 項目が内部用である場合、その直接の親役区と親の子役区のいずれかによってのみアクセスできます。

### プライバシーの例

いくつかの練習をするためにいくつかのプライバシーの例を見てみましょう。
新しい譜集企画を作成し、リスト7-6の譜面を新しい企画の*src / lib.rsに入力し*ます。

<span class="filename">ファイル名。src / lib.rs</span>

```rust,ignore
mod outermost {
    pub fn middle_function() {}

    fn middle_secret_function() {}

    mod inside {
        pub fn inner_function() {}

        fn secret_function() {}
    }
}

fn try_me() {
    outermost::middle_function();
    outermost::middle_secret_function();
    outermost::inside::inner_function();
    outermost::inside::secret_function();
}
```

<span class="caption">譜面リスト7-6。private機能とpublic機能の例</span>

この譜面を製譜する前に、`try_me`機能のどの行に誤りがあるかを推測して`try_me`。
次に、譜面を製譜して、正しいかどうかを確認し、誤りについての説明を読んでください。

#### 誤りを見る

`try_me`機能は、企画のルート役区にあります。
名前の役区`outermost`内部用ですが、2番目のプライバシールールは、と述べている`try_me`機能がアクセスすることを許可されている`outermost`ための役区を`outermost`あるとして、現在の（ルート）役区である`try_me`。

`outermost::middle_function`の呼び出しは、`middle_function`がpublicで`try_me`がその親役区を介して`middle_function` `outermost`アクセスしている`middle_function`します。
すでにこの役区が操作可能であると判断しました。

`outermost::middle_secret_function`は、製譜誤りを引き起こします。
`middle_secret_function`は内部用なので、2番目のルールが適用されます。
ルート役区は、`middle_secret_function`（ `outermost`）の現在の役区でも、 `middle_secret_function`現在の役区の子役区でもありません。

`inside`という名前の役区は内部用であり、子役区を持たないため、現在の役区の`outermost`の役区だけがアクセスできます。
それは意味`try_me`機能を呼び出すことが許可されていない`outermost::inside::inner_function`または`outermost::inside::secret_function`。

#### 誤りの修正

誤りを修正するために譜面を変更するための提案がいくつかあります。
それぞれを試す前に、誤りを修正するかどうかを推測してください。
次に、プライバシールールを使用して理由を理解するために、譜面を製譜して正しいかどうかを確認します。
もっと実験を設計して試してみてください！　

* `inside`役区が公開さ`inside`とどうなりますか？　
* `outermost`が公的で`inside`が非公開だったらどうなるでしょうか？　
* `inner_function`の本体で、`::outermost::middle_secret_function()`場合はどうなりますか？　
   （最初の2つのコロンは、ルート役区から始まる役区を参照することを意味します）。

次に、`use`予約語を`use`て項目を有効範囲に持ち込む方法について説明し`use`。
