## 構造体の定義と実例化

構造体は第3章で説明した組に似ています。組のように、構造体の断片は異なる型にすることができます。
組とは異なり、各データに名前を付けて、値の意味を明確にします。
これらの名前の結果、構造体は組よりも柔軟性があります。つまり、実例の値を指定またはアクセスするためにデータの順序に頼る必要はありません。

構造体を定義するには、予約語`struct`を入力し、`struct`全体の名前を付けます。
構造体の名前は、一緒にグループ化されるデータの重要性を記述する必要があります。
次に、中かっこの中に、データと呼ばれるデータの名前と型を定義し*ます*。
たとえば、リスト5-1は、利用者アカウントに関する情報を格納する構造体を示しています。

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
```

<span class="caption">リスト5-1。 <code>User</code>構造体の定義</span>

構造体を定義した後でそれを使用するには、各構造体の具体的な値を指定して構造体の*実例*を作成し*ます*。
構造体の名前を記述して実例を作成し、`key: value`ペアを含む中かっこを追加し`key: value`ここで、キーは欄の名前であり、値はこれらの欄に格納するデータです。
構造体で宣言したのと同じ順序で欄を指定する必要はありません。
言い換えれば、構造体の定義は型の一般的なひな型のようであり、実例は型の値を作成するための特定のデータでそのひな型を埋めます。
たとえば、リスト5-2に示すように特定の利用者を宣言することができます。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
let user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};
```

<span class="caption">リスト5-2。 <code>User</code>構造体の実例を作成する</span>

構造体から特定の値を取得するには、ドット表記法を使用できます。
この利用者の電子メール番地だけが必要`user1.email`場合は、この値を使用したい場所で`user1.email`を使用できます。
実例が変更可能な場合は、ドット表記を使用して特定の欄に値を割り当てることで値を変更できます。
リスト5-3は、変更可能な`User`実例の`email`欄の値を変更する方法を示しています。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
let mut user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};

user1.email = String::from("anotheremail@example.com");
```

<span class="caption">リスト5-3。 <code>User</code>実例の<code>email</code>欄の値を変更する</span>

実例全体は変更可能でなければならないことに注意してください。
Rustは、特定の欄だけを変更可能としてマークすることはできません。
任意の式と同様に、機能本体の最後の式として構造体の新しい実例を構築して、その新しい実例を暗黙的に返すことができます。

リスト5-4に、指定した電子メールと利用者名で`User`実例を返す`build_user`機能を示します。
`active`欄は`true`の値を取得し、`sign_in_count`は値`1`取得します。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}
```

<span class="caption">リスト5-4。電子メールと利用者名をとり、 <code>User</code>実例を返す<code>build_user</code>機能</span>

構造体の欄と同じ名前の機能のパラメータに名前を付けるのは理にかなっていますが、`email`と`username`欄名と変数を繰り返すことはやや面倒です。
構造体にさらに欄がある場合は、それぞれの名前を繰り返すとさらに迷惑になります。
幸いにも、便利な略記があります！　

### 欄初期化の使用変数と欄の名前が同じ場合の省略形

パラメータ名と構造体欄名はリスト5-4と全く同じ`build_user`ので、*欄initの短縮形*構文を使用して`build_user`を書き直して、まったく同じように動作し`username`、 `email`と`username`繰り返しはありません。譜面リスト5-5を参照してください。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

<span class="caption">リスト5-5。 <code>email</code>と<code>username</code>パラメータがstruct欄と同じ名前を持つため、欄initを簡潔に使用する<code>build_user</code>機能</span>

ここでは、`email`という名前の欄を持つ`User`構造体の新しい実例を作成してい`email`。
`email`欄の値を`build_user`機能の`email`パラメータの値に設定し`email`。
そのため`email`欄と`email`パラメータが同じ名前を持って、唯一の書く必要がある`email`するのではなく`email: email`。

### 構造体の更新構文を使用して他の実例から実例を作成する

古い実例の値の大部分を使用するが、いくつかを変更する構造体の新しい実例を作成すると便利なことがよくあります。
これは*struct update構文*を使用して行い*ます*。

まず、リスト5-6は、更新構文なしで`user2`新しい`User`実例を作成する方法を示しています。
`email`と`username`新しい値を設定し`username`が、リスト5-2で作成した`user1`値と同じ値を使用します。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
# let user1 = User {
#     email: String::from("someone@example.com"),
#     username: String::from("someusername123"),
#     active: true,
#     sign_in_count: 1,
# };
#
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    active: user1.active,
    sign_in_count: user1.sign_in_count,
};
```

<span class="caption">リスト5-6。 <code>user1</code>の値のいくつかを使って新しい<code>User</code>実例を作成する</span>

構造体の更新構文を使用すると、リスト5-7に示すように、譜面を減らして同じ効果を得ることができます。
構文`..`は、明示的に設定されていない残りの欄は、指定された実例の欄と同じ値を持つ必要があることを指定します。

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
# let user1 = User {
#     email: String::from("someone@example.com"),
#     username: String::from("someusername123"),
#     active: true,
#     sign_in_count: 1,
# };
#
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    ..user1
};
```

<span class="caption">譜面リスト5-7。 <code>User</code>実例の新しい<code>email</code>と<code>username</code>値を設定するのにstruct update構文を使用しますが、 <code>user1</code>変数の実例の欄から残りの値を使用します</span>

リスト5-7の譜面はまた、実例を作成し`user2`ために異なる値持ち`email`と`username`しかし同じ値がある`active`と`sign_in_count`から欄`user1`。

### 名前付き欄のない組構造体を使用して異なる型を作成する

*組構造体*と呼ばれる*組に*似た構造体を定義することもできます。
組構造体には、構造体名が提供する追加の意味がありますが、欄に関連付けられた名前はありません。
むしろ、それらは欄の型を持っています。
組構造体は、組全体に名前を付け、組を他の組とは異なる型にする場合や、通常の構造体のように各欄の名前を冗長または冗長にする場合に便利です。

組構造体を定義するには、`struct`予約語と構造体名の後に組の型を続けます。
たとえば、`Color`と`Point`という名前の2つの組構造体の定義と用途を次に示します。

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

`black`と`origin`値は異なる組構造体の実例なので、異なる型であることに注意してください。
構造体内の欄に同じ型があっても、定義する各構造体は独自の型です。
たとえば、`Color`型のパラメータを受け取る機能は、両方の型が3つの`i32`値で構成されていても、`Point`を引数として取ることはできません。
さもなければ、組構造体実例は組のように振る舞います。それらを個々の部分に分解することができます`.`
その後に個別の値にアクセスするための添字などがあります。

### 任意の欄を持たないユニットのような構造体

また、欄を持たない構造体を定義することもできます。
それらはと同様に動作するので、これらは、*ユニットのような構造体*と呼ばれている`()`ユニット型、。
ユニットのような構造体は、ある型の型を実装する必要がありますが、型自体に格納するデータはありません。
第10章で、特性について議論します。

> ### 構造データの所有権
> 
> > リスト5-1の`User`構造体定義では、`&str` stringスライス型ではなく、所有する`String`型を使用しました。
> > この構造体の実例がすべてのデータを所有し、構造体全体が有効である限り、そのデータが有効であることが望ましいため、これは意図的な選択です。
> 
> > これは、構造体は、他の何かが所有するデータへの参照を格納することは可能だが、そうすることは*寿命*の使用を必要とし、第10章の有効期限に説明しますRust機能は、構造体が参照するデータがある限りのために有効であることを確認してください構造体がそうであるように。
> > このように、動作しない寿命を指定せずに構造体に参照を格納しようとするとしましょう。
> 
> > <span class="filename">ファイル名。src/main.rs</span>
> 
> ```rust,ignore
> struct User {
>     username: &str,
>     email: &str,
>     sign_in_count: u64,
>     active: bool,
> }
> 
> fn main() {
>     let user1 = User {
>         email: "someone@example.com",
>         username: "someusername123",
>         active: true,
>         sign_in_count: 1,
>     };
> }
> ```
> 
> > 製譜器は寿命指定子が必要であると不満を持ちます。
> 
> ```text
> error[E0106]: missing lifetime specifier
>  -->
>   |
> 2 |     username: &str,
>   |               ^ expected lifetime parameter
> 
> error[E0106]: missing lifetime specifier
>  -->
>   |
> 3 |     email: &str,
>   |            ^ expected lifetime parameter
> ```
> 
> > 第10章では、これらの誤りを修正して参照を構造体に格納する方法について説明しますが、今のところ、`&str`ような参照の代わりに`String`ような所有型を使用して誤りを修正し`&str`。
