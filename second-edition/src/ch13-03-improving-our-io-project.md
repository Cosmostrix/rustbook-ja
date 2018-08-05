## I/O企画の改善

<ruby>反復子<rt>イテレータ</rt></ruby>に関するこの新しい知識を使用して、第12章でI/O企画を改善することで、<ruby>反復子<rt>イテレータ</rt></ruby>を使用して<ruby>譜面<rt>コード</rt></ruby>内の場所をより明確かつ簡潔にすることができます。
<ruby>反復子<rt>イテレータ</rt></ruby>が`Config::new`機能と`search`機能の実装を改善する方法を見てみましょう。


### <ruby>反復子<rt>イテレータ</rt></ruby>を使用した`clone`削除

<ruby>譜面<rt>コード</rt></ruby>リスト12-6では、スライスに<ruby>添字<rt>インデックス</rt></ruby>を付けて値を複製し、`Config`構造体がそれらの値を所有できるようにして、`String`値のスライスを取り、`Config`構造体の<ruby>実例<rt>インスタンス</rt></ruby>を作成する<ruby>譜面<rt>コード</rt></ruby>を追加しました。
リスト13-24では、リスト12-23のように`Config::new`機能の実装を再現しました。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Config {
    pub fn new(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 3 {
            return Err("not enough arguments");
        }

        let query = args[1].clone();
        let filename = args[2].clone();

        let case_sensitive = env::var("CASE_INSENSITIVE").is_err();

        Ok(Config { query, filename, case_sensitive })
    }
}
```

<span class="caption">リスト13-24。リスト12-23の<code>Config::new</code>機能の再現</span>

当時、`clone`呼び出しの非効率性については心配しないようにしました。なぜなら、将来`clone`呼び出しを削除するからです。
さて、その時は今です！　

パラメータ`args` `String`要素を含むスライスがあるため、ここで`clone`必要でしたが、`new`機能は`args`所有していません。
所有権戻るには`Config`<ruby>実例<rt>インスタンス</rt></ruby>を、から値のクローンを作成しなければならなかった`query`と`filename`の<ruby>欄<rt>フィールド</rt></ruby>`Config`よう`Config`<ruby>実例<rt>インスタンス</rt></ruby>は、その値を所有することができます。

<ruby>反復子<rt>イテレータ</rt></ruby>についての新しい知識があれば、`new`機能を変更して、スライスを借用するのではなく、<ruby>反復子<rt>イテレータ</rt></ruby>の所有権を引数として取ることができます。
スライダの長さをチェックし、特定の場所に<ruby>添字<rt>インデックス</rt></ruby>を付ける<ruby>譜面<rt>コード</rt></ruby>の代わりに、<ruby>反復子<rt>イテレータ</rt></ruby>機能を使用します。
これは、<ruby>反復子<rt>イテレータ</rt></ruby>が値にアクセスするため、`Config::new`機能が何をしているのかを明確にします。

`Config::new`が<ruby>反復子<rt>イテレータ</rt></ruby>の所有権を奪い、借りている<ruby>添字<rt>インデックス</rt></ruby>処理の使用をやめると、`clone`を呼び出して新しい割り当てを行うのではなく、<ruby>反復子<rt>イテレータ</rt></ruby>から`Config` `String`値を移すことができます。

#### 返された<ruby>反復子<rt>イテレータ</rt></ruby>を直接使用する

I/O企画の*src/main.rs*ファイルを*開き*ます。これは次のようになります。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::new(&args).unwrap_or_else(|err| {
        eprintln!("Problem parsing arguments: {}", err);
        process::exit(1);
    });

#    // --snip--
    //  --snip--
}
```

<ruby>譜面<rt>コード</rt></ruby>リスト12-24の`main`機能の開始点をリスト13-25の<ruby>譜面<rt>コード</rt></ruby>に変更します。
これは、`Config::new`も更新するまでは<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/main.rs</span>

```rust,ignore
fn main() {
    let config = Config::new(env::args()).unwrap_or_else(|err| {
        eprintln!("Problem parsing arguments: {}", err);
        process::exit(1);
    });

#    // --snip--
    //  --snip--
}
```

<span class="caption">リスト13-25。 <code>env::args</code>戻り値を<code>Config::new</code>渡す</span>

`env::args`機能は<ruby>反復子<rt>イテレータ</rt></ruby>を返します。
<ruby>反復子<rt>イテレータ</rt></ruby>の値をベクトルに集めてから、`Config::new`スライスを渡すのではなく、`env::args`から返された<ruby>反復子<rt>イテレータ</rt></ruby>の所有権を`Config::new`直接渡しています。

次に、`Config::new`定義を更新する必要があります。
I/O企画の*src/lib.rs*ファイルで、`Config::new`型注釈をリスト13-26のように変更しましょう。
機能本体を更新する必要があるため、これはまだ<ruby>製譜<rt>コンパイル</rt></ruby>されません。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
impl Config {
    pub fn new(mut args: std::env::Args) -> Result<Config, &'static str> {
#        // --snip--
        //  --snip--
```

<span class="caption">リスト13-26。<ruby>反復子<rt>イテレータ</rt></ruby>を期待するために<code>Config::new</code>型注釈を更新する</span>

`env::args`機能の標準<ruby>譜集<rt>ライブラリー</rt></ruby>の開発資料は、それが返す<ruby>反復子<rt>イテレータ</rt></ruby>の型が`std::env::Args`ことを示しています。
`Config::new`機能の型注釈を更新しました。パラメータ`args`には`&[String]`代わりに`std::env::Args`型があります。
の所有権取っているので`args`、変更することがあります`args`、反復処理を行うことで、追加できる`mut`の仕様に予約語を`args`それを可変にするパラメータ。

#### <ruby>添字<rt>インデックス</rt></ruby>作成の代わりに`Iterator` Trait<ruby>操作法<rt>メソッド</rt></ruby>を使用する

次に、`Config::new`本文を修正します。
標準的な<ruby>譜集<rt>ライブラリー</rt></ruby>の開発資料では、`std::env::Args`が`Iterator`<ruby>特性<rt>トレイト</rt></ruby>を実装しているので、`next`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出すことができます。
<ruby>譜面<rt>コード</rt></ruby>リスト13-27は、リスト12-23の<ruby>譜面<rt>コード</rt></ruby>を更新して`next`<ruby>操作法<rt>メソッド</rt></ruby>を使用する方法を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust
# fn main() {}
# use std::env;
#
# struct Config {
#     query: String,
#     filename: String,
#     case_sensitive: bool,
# }
#
impl Config {
    pub fn new(mut args: std::env::Args) -> Result<Config, &'static str> {
        args.next();

        let query = match args.next() {
            Some(arg) => arg,
            None => return Err("Didn't get a query string"),
        };

        let filename = match args.next() {
            Some(arg) => arg,
            None => return Err("Didn't get a file name"),
        };

        let case_sensitive = env::var("CASE_INSENSITIVE").is_err();

        Ok(Config { query, filename, case_sensitive })
    }
}
```

<span class="caption">リスト13-27。反復子<ruby>操作法<rt>メソッド</rt></ruby>を使うために<code>Config::new</code>本文を変更する</span>

`env::args`戻り値の最初の値は<ruby>算譜<rt>プログラム</rt></ruby>の名前です。
それを無視して次の値に到達したいので、最初に`next`を呼び出し、戻り値で何もしません。
次に、`next`を呼び出して、`Config` `query`<ruby>欄<rt>フィールド</rt></ruby>に入れたい値を取得します。
`next`が`Some`返す場合は、`match`を使用して値を抽出します。
`None`を返すと、十分な引数が与えられていないことを意味し、`Err`値で早期に返されます。
`filename`値も同じです。

### <ruby>反復子<rt>イテレータ</rt></ruby>アダプタで<ruby>譜面<rt>コード</rt></ruby>をより明瞭にする

リスト12-19のリスト13-28のように、I/O企画の`search`機能で<ruby>反復子<rt>イテレータ</rt></ruby>を利用することもできます。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let mut results = Vec::new();

    for line in contents.lines() {
        if line.contains(query) {
            results.push(line);
        }
    }

    results
}
```

<span class="caption">リスト13-28。<ruby>譜面<rt>コード</rt></ruby>リスト12-19の<code>search</code>機能の実装</span>

<ruby>反復子<rt>イテレータ</rt></ruby>アダプタの<ruby>操作法<rt>メソッド</rt></ruby>を使用して、この<ruby>譜面<rt>コード</rt></ruby>をより簡潔な方法で記述することができます。
そうすることで、変更可能な中間`results`ベクトルを避けることもできます。
関数型<ruby>演譜<rt>プログラミング</rt></ruby>作法は、<ruby>譜面<rt>コード</rt></ruby>を明確にするために可変状態の量を最小限にすることを好みます。
変更可能状態を削除すると、`results`ベクトルへの同時アクセスを管理する必要がないため、検索を並行して行うための将来の拡張が可能になり`results`。
リスト13-29はこの変更を示しています。

<span class="filename">ファイル名。src/lib.rs</span>

```rust,ignore
pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    contents.lines()
        .filter(|line| line.contains(query))
        .collect()
}
```

<span class="caption">リスト13-29。 <code>search</code>機能の実装における<ruby>反復子<rt>イテレータ</rt></ruby>アダプタ<ruby>操作法<rt>メソッド</rt></ruby>の使用</span>

`search`機能の目的は、`query`を含む`contents`すべての行を返すことです。
リスト13-19の`filter`例と同様に、この<ruby>譜面<rt>コード</rt></ruby>では、`filter`アダプタを使用して`line.contains(query)`が`true`を返す行だけを保持し`line.contains(query)`。
その後、一致する行を`collect`を`collect`て別のベクトルに`collect`ます。
もっと簡単！　
`search_case_insensitive`機能で反復子<ruby>操作法<rt>メソッド</rt></ruby>を使用するようにも同じ変更を加えてください。

次の<ruby>論理<rt>ロジック</rt></ruby>的な質問は、独自の<ruby>譜面<rt>コード</rt></ruby>でどの作法を選択する必要があるのか​​、またその理由はリスト13-28の元の実装またはリスト13-29の<ruby>反復子<rt>イテレータ</rt></ruby>を使用する版です。
ほとんどのRust<ruby>演譜師<rt>プログラマー</rt></ruby>は<ruby>反復子<rt>イテレータ</rt></ruby>ー作法を使用することを好みます。
最初はハングアップするのはやや難しいですが、いろいろな<ruby>反復子<rt>イテレータ</rt></ruby>ーアダプターの感覚を得ると、<ruby>反復子<rt>イテレータ</rt></ruby>ーは理解しやすくなります。
ループのさまざまな部分を手にして新しいベクトルを構築するのではなく、ループの高水準の目的に焦点を合わせます。
この<ruby>譜面<rt>コード</rt></ruby>では、いくつかの一般的な<ruby>譜面<rt>コード</rt></ruby>を抽象化しているので、<ruby>反復子<rt>イテレータ</rt></ruby>の各要素が通過しなければならないフィルタ条件など、この<ruby>譜面<rt>コード</rt></ruby>に固有の概念を簡単に見ることができます。

しかし、2つの実装は本当に同等でしょうか？　
直感的な前提は、より低水準のループが高速になることです。
パフォーマンスについて話しましょう。
