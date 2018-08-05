## `pub`可視性の制御

リスト7-5の<ruby>誤り<rt>エラー</rt></ruby>メッセージは、`network`および`network::server`<ruby>譜面<rt>コード</rt></ruby>を*src/network/mod.rs*ファイルと*src/network/server.rs*ファイルにそれぞれ移動して解決しました。
その時点で、`cargo build`は企画を<ruby>組み上げ<rt>ビルド</rt></ruby>できましたが、`client::connect`、 `network::connect`、および`network::server::connect`機能が使用されていないという警告メッセージが表示されます。

では、なぜこれらの警告を受けているのでしょうか？　
結局のところ、自分の企画の中で必ずしもそうではなく、*利用者*によって使用されることを意図した機能を持つ<ruby>譜集<rt>ライブラリー</rt></ruby>を構築しているので、これらの`connect`機能は使用されなくてもかまいません。
それらを作成することのポイントは、自分の企画ではなく別の企画で使用されることです。

この<ruby>算譜<rt>プログラム</rt></ruby>がなぜこれらの警告を呼び出すのかを理解するために、別の企画の`communicator`<ruby>譜集<rt>ライブラリー</rt></ruby>を外部から呼び出すことを試みてみましょう。
これを行うには、この<ruby>譜面<rt>コード</rt></ruby>を含む*src/main.rs*ファイルを作成して、譜集<ruby>通い箱<rt>クレート</rt></ruby>と同じディレクトリに<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱を作成します。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
extern crate communicator;

fn main() {
    communicator::client::connect();
}
```

`extern crate`命令を使用して、`communicator`譜集<ruby>通い箱<rt>クレート</rt></ruby>を<ruby>有効範囲<rt>スコープ</rt></ruby>にします。
パッケージには*2つの*<ruby>通い箱<rt>クレート</rt></ruby>が入っています。
Cargoは*src/main.rs*を、ルートファイルが*src/lib.rs*である既存の譜集<ruby>通い箱<rt>クレート</rt></ruby>とは別の<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱のルートファイルとして扱います。
このパターンは実行可能な企画では非常に一般的です。ほとんどの機能は譜集<ruby>通い箱<rt>クレート</rt></ruby>にあり、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱はその譜集<ruby>通い箱<rt>クレート</rt></ruby>を使用します。
その結果、他の<ruby>算譜<rt>プログラム</rt></ruby>でも譜集<ruby>通い箱<rt>クレート</rt></ruby>を使用することができ、それは良い関心の分離です。

探している`communicator`<ruby>譜集<rt>ライブラリー</rt></ruby>ー外の<ruby>通い箱<rt>クレート</rt></ruby>の観点からは、作成している<ruby>役区<rt>モジュール</rt></ruby>はすべて、<ruby>通い箱<rt>クレート</rt></ruby>・`communicator`と同じ名前の<ruby>役区<rt>モジュール</rt></ruby>内にあります。
<ruby>通い箱<rt>クレート</rt></ruby>の最上位<ruby>役区<rt>モジュール</rt></ruby>を*ルート<ruby>役区<rt>モジュール</rt></ruby>*と呼び*ます*。

また、企画の下位<ruby>役区<rt>モジュール</rt></ruby>内の外部<ruby>通い箱<rt>クレート</rt></ruby>を使用している場合でも、ご注意`extern crate`（それほど*のsrc/main.rs*または*SRC/lib.rs*で）ルート<ruby>役区<rt>モジュール</rt></ruby>に行く必要があります。
次に、下位<ruby>役区<rt>モジュール</rt></ruby>では、項目が最上位の<ruby>役区<rt>モジュール</rt></ruby>であるかのように、外部<ruby>通い箱<rt>クレート</rt></ruby>の項目を参照できます。

今、<ruby>二進譜<rt>バイナリ</rt></ruby>・<ruby>通い箱<rt>クレート</rt></ruby>は、`client`<ruby>役区<rt>モジュール</rt></ruby>から<ruby>譜集<rt>ライブラリー</rt></ruby>の`connect`機能を呼び出すだけです。
しかし、`cargo build`を呼び出すと、警告の後に<ruby>誤り<rt>エラー</rt></ruby>が表示されます。

```text
error[E0603]: module `client` is private
 --> src/main.rs:4:5
  |
4 |     communicator::client::connect();
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

ああ！　
この<ruby>誤り<rt>エラー</rt></ruby>は、`client`<ruby>役区<rt>モジュール</rt></ruby>が<ruby>内部用<rt>プライベート</rt></ruby>であることを示しています。これは警告の要点です。
それはまた、Rustの文脈で*公的*および*私的*という概念に入ったのは初めてです。
Rustのすべての<ruby>譜面<rt>コード</rt></ruby>の<ruby>黙用<rt>デフォルト</rt></ruby>状態は<ruby>内部用<rt>プライベート</rt></ruby>です。誰も<ruby>譜面<rt>コード</rt></ruby>を使用することはできません。
<ruby>算譜<rt>プログラム</rt></ruby>内で<ruby>内部用<rt>プライベート</rt></ruby>機能を使用しない場合は、<ruby>算譜<rt>プログラム</rt></ruby>がその機能を使用できる唯一の<ruby>譜面<rt>コード</rt></ruby>であるため、Rustはその機能が使用されていないことを警告します。

`client::connect`ような機能がpublicであると指定した後は、<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱からその機能への呼び出しを許可するだけでなく、その機能が使用されていないという警告が消えます。
機能を<ruby>公開<rt>パブリック</rt></ruby>としてマークすると、機能が<ruby>算譜<rt>プログラム</rt></ruby>外の<ruby>譜面<rt>コード</rt></ruby>で使用されることがRustに通知されます。
Rustは、機能が "使用されている"として現在考えられる理論上の外部使用を考慮します。したがって、機能がpublicとマークされている場合、Rustは<ruby>算譜<rt>プログラム</rt></ruby>で使用する必要はなく、機能が未使用であることの警告を停止します。

### 機能を<ruby>公開<rt>パブリック</rt></ruby>にする

Rustに機能を<ruby>公開<rt>パブリック</rt></ruby>させるために、`pub`予約語を宣言の先頭に追加し`pub`。
ここでは、`client::connect`が現在使用されていないことと、``module `client` is private``たちの<ruby>二進譜<rt>バイナリ</rt></ruby>通い箱の``module `client` is private``<ruby>誤り<rt>エラー</rt></ruby>であることを示す警告を修正することに焦点を当てます。
*src/lib.rs*を変更して`client`<ruby>役区<rt>モジュール</rt></ruby>を<ruby>公開<rt>パブリック</rt></ruby>にし`client`。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub mod client;

mod network;
```

`pub`予約語は`mod`直前に置かれます。
もう一度<ruby>組み上げ<rt>ビルド</rt></ruby>してみましょう。

```text
error[E0603]: function `connect` is private
 --> src/main.rs:4:5
  |
4 |     communicator::client::connect();
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

やめ！　
別の<ruby>誤り<rt>エラー</rt></ruby>があります。
はい、異なる<ruby>誤り<rt>エラー</rt></ruby>メッセージがお祝いの原因です。
新しい<ruby>誤り<rt>エラー</rt></ruby>は``function `connect` is private``であることを示してい``function `connect` is private``ので、*src/client.rs*を編集して`client::connect` publicにしましょう。

<span class="filename">ファイル名。src/client.rs</span>

```rust
pub fn connect() {
}
```

今度は再び`cargo build`実行してください。

```text
warning: function is never used: `connect`
 --> src/network/mod.rs:1:1
  |
1 |/fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default

warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 |/fn connect() {
2 | | }
  | |_^
```

<ruby>製譜<rt>コンパイル</rt></ruby>された<ruby>譜面<rt>コード</rt></ruby>と、`client::connect`が使用されていないという警告は消えました！　

未使用の<ruby>譜面<rt>コード</rt></ruby>の警告は、<ruby>譜面<rt>コード</rt></ruby>内の項目を<ruby>公開<rt>パブリック</rt></ruby>する必要があることを必ずしも示すもので*はありませ*ん。これらの機能を<ruby>公開<rt>パブリック</rt></ruby>APIの一部にしたく*ない*場合*は*、未使用の<ruby>譜面<rt>コード</rt></ruby>の警告により、安全に削除することができます。
この機能が呼び出される<ruby>譜集<rt>ライブラリー</rt></ruby>内のすべての場所を誤って削除した場合は、バグに警告することもできます。

しかし、この場合、他の2つの機能を<ruby>通い箱<rt>クレート</rt></ruby>の<ruby>公開<rt>パブリック</rt></ruby>APIの一部に*し*たいので、残っている警告を取り除くためにそれらを`pub`としてマークしましょう。
*src/network/mod.rs*を次のように変更します。

<span class="filename">ファイル名。src/network/mod.rs</span>

```rust,ignore
pub fn connect() {
}

mod server;
```

次に、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>します。

```text
warning: function is never used: `connect`
 --> src/network/mod.rs:1:1
  |
1 |/pub fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default

warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 |/fn connect() {
2 | | }
  | |_^
```

`network::connect`が`pub`設定されているにもかかわらず、未使用の機能警告が表示されて`pub`ます。
その理由は、機能が<ruby>役区<rt>モジュール</rt></ruby>内でpublicであるが、機能が存在する`network`<ruby>役区<rt>モジュール</rt></ruby>がpublicでないためです。
今回は<ruby>譜集<rt>ライブラリー</rt></ruby>の内部から作業していますが、`client::connect`では外部から作業しました*。src/lib.rs*を変更して`network`<ruby>公開<rt>パブリック</rt></ruby>する必要があります。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub mod client;

pub mod network;
```

今<ruby>製譜<rt>コンパイル</rt></ruby>すると、その警告は消えてしまいます。

```text
warning: function is never used: `connect`
 --> src/network/server.rs:1:1
  |
1 |/fn connect() {
2 | | }
  | |_^
  |
  = note: #[warn(dead_code)] on by default
```

1つの警告だけが残っています -あなた自身でこれを修正しよう！　

### プライバシールール

全体的に、これらは項目の可視性のためのルールです。

- 項目が<ruby>公開<rt>パブリック</rt></ruby>されている場合は、その親<ruby>役区<rt>モジュール</rt></ruby>のいずれかを介してアクセスできます。
- 項目が<ruby>内部用<rt>プライベート</rt></ruby>である場合、その直接の親<ruby>役区<rt>モジュール</rt></ruby>と親の子<ruby>役区<rt>モジュール</rt></ruby>のいずれかによってのみアクセスできます。

### プライバシーの例

いくつかの練習をするためにいくつかのプライバシーの例を見てみましょう。
新しい<ruby>譜集<rt>ライブラリー</rt></ruby>企画を作成し、リスト7-6の<ruby>譜面<rt>コード</rt></ruby>を新しい企画の*src/lib.rsに入力し*ます。

<span class="filename">ファイル名。src/lib.rs</span>

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

この<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>する前に、`try_me`機能のどの行に<ruby>誤り<rt>エラー</rt></ruby>があるかを推測して`try_me`。
次に、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して、正しいかどうかを確認し、<ruby>誤り<rt>エラー</rt></ruby>についての説明を読んでください。

#### <ruby>誤り<rt>エラー</rt></ruby>を見る

`try_me`機能は、企画のルート<ruby>役区<rt>モジュール</rt></ruby>にあります。
名前の<ruby>役区<rt>モジュール</rt></ruby>`outermost`<ruby>内部用<rt>プライベート</rt></ruby>ですが、2番目のプライバシールールは、と述べている`try_me`機能がアクセスすることを許可されている`outermost`ための<ruby>役区<rt>モジュール</rt></ruby>を`outermost`あるとして、現在の（ルート）<ruby>役区<rt>モジュール</rt></ruby>である`try_me`。

`outermost::middle_function`の呼び出しは、`middle_function`がpublicで`try_me`がその親<ruby>役区<rt>モジュール</rt></ruby>を介して`middle_function` `outermost`アクセスしている`middle_function`します。
すでにこの<ruby>役区<rt>モジュール</rt></ruby>が操作可能であると判断しました。

`outermost::middle_secret_function`は、<ruby>製譜<rt>コンパイル</rt></ruby>誤りを引き起こします。
`middle_secret_function`は<ruby>内部用<rt>プライベート</rt></ruby>なので、2番目のルールが適用されます。
ルート<ruby>役区<rt>モジュール</rt></ruby>は、`middle_secret_function`（ `outermost`）の現在の<ruby>役区<rt>モジュール</rt></ruby>でも、 `middle_secret_function`現在の<ruby>役区<rt>モジュール</rt></ruby>の子<ruby>役区<rt>モジュール</rt></ruby>でもありません。

`inside`という名前の<ruby>役区<rt>モジュール</rt></ruby>は<ruby>内部用<rt>プライベート</rt></ruby>であり、子<ruby>役区<rt>モジュール</rt></ruby>を持たないため、現在の<ruby>役区<rt>モジュール</rt></ruby>の`outermost`の<ruby>役区<rt>モジュール</rt></ruby>だけがアクセスできます。
それは意味`try_me`機能を呼び出すことが許可されていない`outermost::inside::inner_function`または`outermost::inside::secret_function`。

#### <ruby>誤り<rt>エラー</rt></ruby>の修正

<ruby>誤り<rt>エラー</rt></ruby>を修正するために<ruby>譜面<rt>コード</rt></ruby>を変更するための提案がいくつかあります。
それぞれを試す前に、<ruby>誤り<rt>エラー</rt></ruby>を修正するかどうかを推測してください。
次に、プライバシールールを使用して理由を理解するために、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して正しいかどうかを確認します。
もっと実験を設計して試してみてください！　

* `inside`<ruby>役区<rt>モジュール</rt></ruby>が<ruby>公開<rt>パブリック</rt></ruby>さ`inside`とどうなりますか？　
* `outermost`が公的で`inside`が非<ruby>公開<rt>パブリック</rt></ruby>だったらどうなるでしょうか？　
* `inner_function`の本体で、`::outermost::middle_secret_function()`場合はどうなりますか？　
   （最初の2つのコロンは、ルート<ruby>役区<rt>モジュール</rt></ruby>から始まる<ruby>役区<rt>モジュール</rt></ruby>を参照することを意味します）。

次に、`use`予約語を`use`て項目を<ruby>有効範囲<rt>スコープ</rt></ruby>に持ち込む方法について説明し`use`。
