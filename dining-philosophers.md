% 食事する哲学者たち

二番目の企画として、古典的な並列処理問題について考えていきましょう。
「食事する哲学者たち」と呼ばれる問題です。
元来は 1965 年にダイクストラ (Dijkstra) により考案されましたが、ここでは 1985 年に
トニー・ホーア (Tony Hoare) が簡単化した[この論文][paper]を利用します。

<!--For our second project, let’s look at a classic concurrency problem. It’s
called ‘the dining philosophers’. It was originally conceived by Dijkstra in
1965, but we’ll use a lightly adapted version from [this paper][paper] by Tony
Hoare in 1985.-->

[paper]: http://www.usingcsp.com/cspbook.pdf

> むかしむかし、ある裕福な慈善家が、5 人の高名な哲学者たちが宿泊できる学寮を寄付しました。
> それぞれの哲学者には専門の思索活動にふさわしい部屋が与えられました。
> 共用の食堂もあり、円卓が置かれていて、そのまわりには哲学者が座れる名札つきのイスが 5 つあります。
> 彼らは円卓に反時計回りに座ります。哲学者の左側にはそれぞれ金のフォークが配され、
> 中央には大きな器に入ったスパゲッティがいつも補充されていました。
> 哲学者はほとんどの時間を思考に費やすのですが、空腹を感じると食堂に出向いて自分のイスに座り、
> 左側にある自分のフォークをつかんで スパゲッティに突き刺します。 ところが、
> 絡まり合ったスパゲッティを口元まで運ぶには 2 本目のフォークが必要でした。
> こうして哲学者は右側のフォークも使う羽目になったのです。 食べ終わったところで両方のフォークを置き、
> 席をあとにして思索活動に戻ります。 もちろん、フォークは一度に一人の哲学者だけしか使えません。
> 他の哲学者が食事するときは、そのフォークが戻されるまで待たねばなりません。

<!-- > In ancient times, a wealthy philanthropist endowed a College to accommodate
> five eminent philosophers. Each philosopher had a room in which they could
> engage in their professional activity of thinking; there was also a common
> dining room, furnished with a circular table, surrounded by five chairs, each
> labelled by the name of the philosopher who was to sit in it. They sat
> anticlockwise around the table. To the left of each philosopher there was
> laid a golden fork, and in the center stood a large bowl of spaghetti, which
> was constantly replenished. A philosopher was expected to spend most of
> their time thinking; but when they felt hungry, they went to the dining
> room, sat down in their own chair, picked up their own fork on their left,
> and plunged it into the spaghetti. But such is the tangled nature of
> spaghetti that a second fork is required to carry it to the mouth. The
> philosopher therefore had also to pick up the fork on their right. When
> they were finished they would put down both their forks, get up from their
> chair, and continue thinking. Of course, a fork can be used by only one
> philosopher at a time. If the other philosopher wants it, they just have
> to wait until the fork is available again.-->

この古典的な問題は並列処理に特有の要素を浮き彫りにします。
その理由は、実装が少しやりづらい点にあります。
実は、素朴な実装ではこう着状態〈デッドロック〉に陥る可能性があるのです。
例として、この問題を解くはずの素朴な算法〈アルゴリズム〉を考えてみましょう。

<!--This classic problem shows off a few different elements of concurrency. The
reason is that it's actually slightly tricky to implement: a simple
implementation can deadlock. For example, let's consider a simple algorithm
that would solve this problem:-->

1. ある哲学者が左側のフォークをつかみます。
2. 続いて全員が右側のフォークをつかみます。
3. スパゲッティを食べます。
4. フォークを戻します。

<!--1. A philosopher picks up the fork on their left.
2. They then pick up the fork on their right.
3. They eat.
4. They return the forks.-->

いま、次のような事態が順番に起きたと想像してみましょう。

<!-- Now, let’s imagine this sequence of events: -->

1. 哲学者１が算法をもとに動きはじめ、左側のフォークをつかみあげる。
2. 哲学者２が算法をもとに動きはじめ、左側のフォークをつかみあげる。
3. 哲学者３が算法をもとに動きはじめ、左側のフォークをつかみあげる。
4. 哲学者４が算法をもとに動きはじめ、左側のフォークをつかみあげる。
5. 哲学者５が算法をもとに動きはじめ、左側のフォークをつかみあげる。
6. あやや...？ フォークはみんな取られたのに誰もスパゲッティに手をつけられません！

<!--1. Philosopher 1 begins the algorithm, picking up the fork on their left.
2. Philosopher 2 begins the algorithm, picking up the fork on their left.
3. Philosopher 3 begins the algorithm, picking up the fork on their left.
4. Philosopher 4 begins the algorithm, picking up the fork on their left.
5. Philosopher 5 begins the algorithm, picking up the fork on their left.
6. ... ? All the forks are taken, but nobody can eat!-->

この問題の解決方法にはいろいろありますが、この手引きでは独自の解法をとります。
今は問題の模型〈モデル〉化からはじめましょう。まずは哲学者。

<!--There are different ways to solve this problem. We’ll get to our solution in
the tutorial itself. For now, let’s get started modeling the problem itself.
We’ll start with the philosophers:-->

```rust
struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }
}

fn main() {
    let p1 = Philosopher::new("Judith Butler");    // ジュディス・バトラー
    let p2 = Philosopher::new("Gilles Deleuze");   // ジル・ドゥルーズ
    let p3 = Philosopher::new("Karl Marx");        // カール・マルクス
    let p4 = Philosopher::new("Emma Goldman");     // エマ・ゴールドマン
    let p5 = Philosopher::new("Michel Foucault");  // ミシェル・フーコー
}
```

> 【訳者註】以前の版では `p1` に スピノザ (Baruch Spinoza)、`p4` に ニーチェ
> (Friedrich Nietzsche) が入っていました。時代の流れでしょうか。
> 余談ですが フーコー著『監獄の誕生』はちょっと長いですが刺激的です。

ここで、哲学者を表現するために [構造体 (`struct`)][struct] を作りました。
今は名前だけが必須です。名前の型には `&str` ではなく [`String`][string] を選びました。
一般的に言って、中身を所有する型を使った方が参照を使った型よりも簡単になります。

<!--Here, we make a [`struct`][struct] to represent a philosopher. For now,
a name is all we need. We choose the [`String`][string] type for the name,
rather than `&str`. Generally speaking, working with a type which owns its
data is easier than working with one that uses references.-->

[struct]: structs.html
[string]: strings.html

続けましょう。

<!-- Let’s continue: -->

```rust
# struct Philosopher {
#     name: String,
# }
impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }
}
```

この `impl` 段落 (block)〈ブロック〉で (哲学者) `Philosopher` 構造体を定義できます。
この場合は `new` という名前の「付属機能」を定義しています。
最初の行はこのようになっています。

<!--This `impl` block lets us define things on `Philosopher` structs. In this case,
we define an ‘associated function’ called `new`. The first line looks like this:-->

```rust
# struct Philosopher {
#     name: String,
# }
# impl Philosopher {
fn new(name: &str) -> Philosopher {
#         Philosopher {
#             name: name.to_string(),
#         }
#     }
# }
```

型 `&str` の `name` を１個、引数にとっています。これは他の文字列への参照です。
結果は `Philosopher` 構造体の実例 (instance)〈インスタンス〉になります。

<!--We take one argument, a `name`, of type `&str`. This is a reference to another
string. It returns an instance of our `Philosopher` struct.-->

```rust
# struct Philosopher {
#     name: String,
# }
# impl Philosopher {
#    fn new(name: &str) -> Philosopher {
Philosopher {
    name: name.to_string(),
}
#     }
# }
```

ここで新しい `Philosopher` をつくり、その `name` をさっきの `name` 引数にしています。
`.to_stirng()` を呼んでいるので引数そのままではありませんけどね。
呼ぶと `&str` が指していた文字列の写しを作って新しい `String` を返します。
これが `Philosopher` の `name` 欄 (field)〈フィールド〉になります。

<!--This creates a new `Philosopher`, and sets its `name` to our `name` argument.
Not just the argument itself, though, as we call `.to_string()` on it. This
will create a copy of the string that our `&str` points to, and give us a new
`String`, which is the type of the `name` field of `Philosopher`.-->

なぜ `String` を直接受け取るようにしないのでしょうか？ その方が呼びやすそうなのに。
もし `String` を取ってしまうと、呼び出し側が `&str`
しか持っていない場合に呼び出し側がこの操作法を自分で呼ぶ必要があるからです。
欠点は、この柔軟性と引き換えに _常に_ 写しが作られるようになってしまうことです。
どのみち小さな文字列しか扱わないとわかっているので、この小さな算譜では全く問題になりません。

<!--Why not accept a `String` directly? It’s nicer to call. If we took a `String`,
but our caller had a `&str`, they’d have to call this method themselves. The
downside of this flexibility is that we _always_ make a copy. For this small
program, that’s not particularly important, as we know we’ll just be using
short strings anyway.-->

最後にひとつ分かることは、`Philosopher` を定義しただけでまったく何にもしていないように見える点です。
Rust は「式を土台に」した言語で、Rust の中のほとんど全ては値を返す式になっています。
機能も実はそうなっており、最後の式が自動的に返されます。
新しい `Philosopher` の作成をこの機能の最後の式で行ったので、この値を返しているのです。

<!--One last thing you’ll notice: we just define a `Philosopher`, and seemingly
don’t do anything with it. Rust is an ‘expression based’ language, which means
that almost everything in Rust is an expression which returns a value. This is
true of functions as well, the last expression is automatically returned. Since
we create a new `Philosopher` as the last expression of this function, we end
up returning it.-->

この `new()` という名前は Rust が特別に扱うものではありませんが、
構造体の実例を作る機能によくつけられる (慣例的な) 名前です。
その理由について話す前に `main()` をもう一度見てみましょう。

<!--This name, `new()`, isn’t anything special to Rust, but it is a convention for
functions that create new instances of structs. Before we talk about why, let’s
look at `main()` again:-->

```rust
# struct Philosopher {
#     name: String,
# }
#
# impl Philosopher {
#     fn new(name: &str) -> Philosopher {
#         Philosopher {
#             name: name.to_string(),
#         }
#     }
# }
#
fn main() {
    let p1 = Philosopher::new("Judith Butler");    // ジュディス・バトラー
    let p2 = Philosopher::new("Gilles Deleuze");   // ジル・ドゥルーズ
    let p3 = Philosopher::new("Karl Marx");        // カール・マルクス
    let p4 = Philosopher::new("Emma Goldman");     // エマ・ゴールドマン
    let p5 = Philosopher::new("Michel Foucault");  // ミシェル・フーコー
}
```

ここでは、５人の新しい哲学者に対して５つの変数束縛を作っています。
お気に入りの５人なのですが、自由に置き換えて構いませんよ。

<!--Here, we create five variable bindings with five new philosophers. These are my
favorite five, but you can substitute anyone you want.-->

仮に `new()` 機能を定義しなかった場合は、こう書かなければなりません。

<!--If we _didn’t_ define that `new()` function, it would look like this:-->

```rust
# struct Philosopher {
#     name: String,
# }
fn main() {
    let p1 = Philosopher { name: "Judith Butler".to_string() };
    let p2 = Philosopher { name: "Gilles Deleuze".to_string() };
    let p3 = Philosopher { name: "Karl Marx".to_string() };
    let p4 = Philosopher { name: "Emma Goldman".to_string() };
    let p5 = Philosopher { name: "Michel Foucault".to_string() };
}
```

ずっとゴチャゴチャしていますね。`new` を使う利点は他にもありますが、
この簡単な場合でさえあった方がよかったと分かります。

<!--That’s much noisier. Using `new` has other advantages too, but even in
this simple case, it ends up being nicer to use.-->

基本的な用意ができたので、より広い問題に取り組むいくつもの道があらわれました。
逆順にやってみたいので、まずはそれぞれの哲学者が食事を終えるところを準備しましょう。
この小さな一歩では、操作法を作って全員分の繰り返しでそれを呼びだします。

<!--Now that we’ve got the basics in place, there’s a number of ways that we can
tackle the broader problem here. I like to start from the end first: let’s
set up a way for each philosopher to finish eating. As a tiny step, let’s make
a method, and then loop through all the philosophers, calling it:-->

```rust
struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} は食べ終わった。", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),    // ジュディス・バトラー
        Philosopher::new("Gilles Deleuze"),   // ジル・ドゥルーズ
        Philosopher::new("Karl Marx"),        // カール・マルクス
        Philosopher::new("Emma Goldman"),     // エマ・ゴールドマン
        Philosopher::new("Michel Foucault"),  // ミシェル・フーコー
    ];

    for p in &philosophers {
        p.eat();
    }
}
```

`main()` にまず注目してください。哲学者５人に対して別個の変数束縛を作らず、
代わりに哲学者の入った `Vec<T>` を作りました。
`Vec<T>` はベクトル (vector) とも呼ばれている伸長可能な配列型です。それから [`for`][for]
繰り返し〈ループ〉を使ってベクトルを総なめし、哲学者ひとりひとりの参照を順番に得ます。

<!--Let’s look at `main()` first. Rather than have five individual variable
bindings for our philosophers, we make a `Vec<T>` of them instead. `Vec<T>` is
also called a ‘vector’, and it’s a growable array type. We then use a
[`for`][for] loop to iterate through the vector, getting a reference to each
philosopher in turn.-->

[for]: loops.html#for

繰り返しの本体で `p.eat()` を呼んでいます。定義は上の方にありました。

<!-- In the body of the loop, we call `p.eat()`, which is defined above: -->

```rust,ignore
fn eat(&self) {
    println!("{} は食べ終わった。", self.name);
}
```

Rust の操作法は必ず `self` 引数をとります。これが、 `eat()` が操作法であって `new`
が付属機能である理由です。`new()` には `self` がないですからね。
できたての `eat()` では哲学者の名前を出して食べ終わったと印字するだけです。
この算譜を実行すると次の出力がなされるはずです。

<!--In Rust, methods take an explicit `self` parameter. That’s why `eat()` is a
method, but `new` is an associated function: `new()` has no `self`. For our
first version of `eat()`, we just print out the name of the philosopher, and
mention they’re done eating. Running this program should give you the following
output:-->

```text
Judith Butler は食べ終わった。
Gilles Deleuze は食べ終わった。
Karl Marx は食べ終わった。
Emma Goldman は食べ終わった。
Michel Foucault は食べ終わった。
```

全員終わりました！ 楽勝です。
まあ実際は本当の問題を実装していないので、まだ終わってはいないのですが！

<!--Easy enough, they’re all done! We haven’t actually implemented the real problem
yet, though, so we’re not done yet!-->

次に、哲学者がただ食べ終えるだけでなく実際に食べるようにしていきます。次にできた版はこちらです。

<!--Next, we want to make our philosophers not just finish eating, but actually
eat. Here’s the next version:-->

```rust
use std::thread;
use std::time::Duration;

struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} が食事をはじめた。", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} は食べ終わった。", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),    // ジュディス・バトラー
        Philosopher::new("Gilles Deleuze"),   // ジル・ドゥルーズ
        Philosopher::new("Karl Marx"),        // カール・マルクス
        Philosopher::new("Emma Goldman"),     // エマ・ゴールドマン
        Philosopher::new("Michel Foucault"),  // ミシェル・フーコー
    ];

    for p in &philosophers {
        p.eat();
    }
}
```

変更は 2 カ所です。かみ砕いて行きましょう。

<!-- Just a few changes. Let’s break it down. -->

```rust,ignore
use std::thread;
use std::time::Duration;
```

`use` で名前を可視(有効)範囲 (scope)〈スコープ〉に持ち込みます。
標準譜集から `thread` 役区〈モジュール〉を使おうとしているので、`use` が必要です。

<!--`use` brings names into scope. We’re going to start using the `thread` module
from the standard library, and so we need to `use` it.-->

```rust,ignore
    fn eat(&self) {
        println!("{} が食事をはじめた。", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} は食べ終わった。", self.name);
    }
```

今度は `sleep()` を間にはさんで 2 つの文章を印字しています。
これで哲学者が食べる時間を再現しましょう。

> 【訳者註】走脈 (`thread`)〈スレッド〉は「実行の脈絡
> (thread of execution)」の略で、並列実行の主体です。
> `sleep` はある時間の間 (duration) 何もしないことで、1000 ミリ秒 (millisecond) は
> 1 秒に等しい時間の長さです。

<!--We now print out two messages, with a `sleep()` in the middle. This will
simulate the time it takes a philosopher to eat.-->

この算譜を実行すると、哲学者が順番に食べていく様子が見られるはずです。

<!-- If you run this program, you should see each philosopher eat in turn: -->

```text
Judith Butler が食事をはじめた。
Judith Butler は食べ終わった。
Gilles Deleuze が食事をはじめた。
Gilles Deleuze は食べ終わった。
Karl Marx が食事をはじめた。
Karl Marx は食べ終わった。
Emma Goldman が食事をはじめた。
Emma Goldman は食べ終わった。
Michel Foucault が食事をはじめた。
Michel Foucault は食べ終わった。
```

素晴らしい！ ここまで来ました。ただひとつ問題があります。
この問題の本丸である並列化にまだ手をつけていません！

<!--Excellent! We’re getting there. There’s just one problem: we aren’t actually
operating in a concurrent fashion, which is a core part of the problem!-->

哲学者たちに同時並行に食事させるためには小さな変更を加える必要があります。
次の一歩はこうです。

<!--To make our philosophers eat concurrently, we need to make a small change.
Here’s the next iteration:-->

```rust
use std::thread;
use std::time::Duration;

struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} が食事をはじめた。", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} は食べ終わった。", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),    // ジュディス・バトラー
        Philosopher::new("Gilles Deleuze"),   // ジル・ドゥルーズ
        Philosopher::new("Karl Marx"),        // カール・マルクス
        Philosopher::new("Emma Goldman"),     // エマ・ゴールドマン
        Philosopher::new("Michel Foucault"),  // ミシェル・フーコー
    ];

    let handles: Vec<_> = philosophers.into_iter().map(|p| {
        thread::spawn(move || {
            p.eat();
        })
    }).collect();

    for h in handles {
        h.join().unwrap();
    }
}
```

`main()` 内の繰り返し部の変更と二番目のものの追加で全部です！
最初の変更点は、

<!--All we’ve done is change the loop in `main()`, and added a second one! Here’s the
first change:-->

```rust,ignore
let handles: Vec<_> = philosophers.into_iter().map(|p| {
    thread::spawn(move || {
        p.eat();
    })
}).collect();
```

たった５行ですが、密度の高い５行になっています。それではかみ砕いていきましょう。

<!-- While this is only five lines, they’re a dense five. Let’s break it down. -->

```rust,ignore
let handles: Vec<_> =
```

`handles` と名づけた新しい束縛を導入します。 こう命名したのは、新しい走脈を作成するとき、
走脈のはたらきを制御できる手綱 (handle)〈ハンドル〉が返されるからです。
後ほど議論する問題があるため、ここでは型を陽に (明示的に) 書きくだす必要があります。
`_` は型の場所取り〈プレースホルダ〉です。つまり「`handles`
は _何か_ のベクトルとするが、この _何か_ の正体を君が推理できるのだよ、Rust 君」と言っているのです。

<!--We introduce a new binding, called `handles`. We’ve given it this name because
we are going to make some new threads, and that will return some handles to those
threads that let us control their operation. We need to explicitly annotate
the type here, though, due to an issue we’ll talk about later. The `_` is
a type placeholder. We’re saying “`handles` is a vector of something, but you
can figure out what that something is, Rust.”-->

```rust,ignore
philosophers.into_iter().map(|p| {
```

哲学者の一覧に対して `into_iter()` を呼びます。するとそれぞれの哲学者の所有権を取得した反復子が作成されます。
走脈に哲学者を渡すにはこうする必要があります。この反復子に対して `map`
を呼び、その引数には要素ごとに順番に呼ばれる閉包 (closure)〈クロージャ〉を渡します。

<!--We take our list of philosophers and call `into_iter()` on it. This creates an
iterator that takes ownership of each philosopher. We need to do this to pass
them to our threads. We take that iterator and call `map` on it, which takes a
closure as an argument and calls that closure on each element in turn.-->

```rust,ignore
    thread::spawn(move || {
        p.eat();
    })
```

ここで並列実行が始まります。`thread::spawn`
機能は閉包を引数として取り、新しい走脈でその閉包を実行します。
この閉包はつかまえようとしている値の所有権を獲得しようとすることを示すために特別の補注
`move` が必要です。
主に `map` 機能の `p` 変数のことです。

<!--Here’s where the concurrency happens. The `thread::spawn` function takes a closure
as an argument and executes that closure in a new thread. This closure needs
an extra annotation, `move`, to indicate that the closure is going to take
ownership of the values it’s capturing. Primarily, the `p` variable of the
`map` function.-->

走脈の中では `p` に対して `eat()` を呼ぶだけで終わりです。
`thread::spawn` の呼出しでは末尾のセミコロン (`;`) をなくし、式にしていることにも注意してください。
この区別は重要で正しい戻り値を生み出します。より詳しくは[式と文][es]をご覧ください。

<!--Inside the thread, all we do is call `eat()` on `p`. Also note that the call to `thread::spawn` lacks a trailing semicolon, making this an expression. This distinction is important, yielding the correct return value. For more details, read [Expressions vs. Statements][es].-->

[es]: functions.html#expressions-vs-statements

```rust,ignore
}).collect();
```

最後に、これらの `map` 呼出しの結果を全部集めてまとめあげます。
`collect()` は結果を何かしらの収集物〈コレクション〉の形にします。
今回は `Vec<T>` がほしかったので返り値の型にそう補注する必要がありました。
要素は `thread::spawn` 呼出しの返り値で、各走脈の手綱になっています。
ふー！

<!--Finally, we take the result of all those `map` calls and collect them up.
`collect()` will make them into a collection of some kind, which is why we
needed to annotate the return type: we want a `Vec<T>`. The elements are the
return values of the `thread::spawn` calls, which are handles to those threads.
Whew!-->

```rust,ignore
for h in handles {
    h.join().unwrap();
}
```

`main()` の終わりでは全部の手綱に対して繰り返して `join()` を呼んでいます。
すると該当走脈の実行が完了するまで実行が阻止〈ブロック〉されます。
これにより算譜の終了前に全脈が作業を完了することが保証されます。

<!--At the end of `main()`, we loop through the handles and call `join()` on them,
which blocks execution until the thread has completed execution. This ensures
that the threads complete their work before the program exits.-->

この算譜を走らせると哲学者がバラバラに食事をする光景が見られます！
これが多脈処理〈マルチスレッド処理〉です！

<!--If you run this program, you’ll see that the philosophers eat out of order!
We have multi-threading!-->

```text
Judith Butler が食事をはじめた。
Gilles Deleuze が食事をはじめた。
Karl Marx が食事をはじめた。
Emma Goldman が食事をはじめた。
Michel Foucault が食事をはじめた。
Judith Butler は食べ終わった。
Gilles Deleuze は食べ終わった。
Karl Marx は食べ終わった。
Emma Goldman は食べ終わった。
Michel Foucault は食べ終わった。
```

ところでフォークはどこに行ったんでしょうか？ フォークはまだ全然模型化していませんでしたね。

<!-- But what about the forks? We haven’t modeled them at all yet. -->

フォーク用に新しい `struct` を作りましょう。

<!-- To do that, let’s make a new `struct`: -->

```rust
use std::sync::Mutex;

struct Table {
    forks: Vec<Mutex<()>>,
}
```

この `Table` は `Mutex`〈ミューテックス〉のベクトルを持ちます。
〈ミューテックス〉は並列性を制御する方法のひとつで、同時にひとつの走脈だけがその中身を操作できます。
まさしく今回のフォークに求める性質そのものです。〈ミューテックス〉の中身は空の組 `()` にしました。
なぜなら、実際に中身を使うつもりはないので、ただ持っているだけで十分だからです。

<!--This `Table` has a vector of `Mutex`es. A mutex is a way to control
concurrency: only one thread can access the contents at once. This is exactly
the property we need with our forks. We use an empty tuple, `()`, inside the
mutex, since we’re not actually going to use the value, just hold onto it.-->

`Table` を使うように算譜を加工しましょう。

<!-- Let’s modify the program to use the `Table`: -->

```rust
use std::thread;
use std::time::Duration;
use std::sync::{Mutex, Arc};

struct Philosopher {
    name: String,
    left: usize,
    right: usize,
}

impl Philosopher {
    fn new(name: &str, left: usize, right: usize) -> Philosopher {
        Philosopher {
            name: name.to_string(),
            left: left,
            right: right,
        }
    }

    fn eat(&self, table: &Table) {
        let _left = table.forks[self.left].lock().unwrap();
        thread::sleep(Duration::from_millis(150));
        let _right = table.forks[self.right].lock().unwrap();

        println!("{} が食事をはじめた。", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} は食べ終わった。", self.name);
    }
}

struct Table {
    forks: Vec<Mutex<()>>,
}

fn main() {
    let table = Arc::new(Table { forks: vec![
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
    ]});

    let philosophers = vec![
        Philosopher::new("Judith Butler", 0, 1),    // ジュディス・バトラー
        Philosopher::new("Gilles Deleuze", 1, 2),   // ジル・ドゥルーズ
        Philosopher::new("Karl Marx", 2, 3),        // カール・マルクス
        Philosopher::new("Emma Goldman", 3, 4),     // エマ・ゴールドマン
        Philosopher::new("Michel Foucault", 0, 4),  // ミシェル・フーコー
    ];

    let handles: Vec<_> = philosophers.into_iter().map(|p| {
        let table = table.clone();

        thread::spawn(move || {
            p.eat(&table);
        })
    }).collect();

    for h in handles {
        h.join().unwrap();
    }
}
```

なんと変更が多い！ しかし、今の一歩によって、動く算譜を手にしました。
詳しく見ていきましょう！

<!--Lots of changes! However, with this iteration, we’ve got a working program.
Let’s go over the details:-->

```rust,ignore
use std::sync::{Mutex, Arc};
```

`std::sync` 〈バッケージ〉からもうひとつの構造体 `Arc<T>` を使います。
あとで使うときにもっと説明します。

<!--We’re going to use another structure from the `std::sync` package: `Arc<T>`.
We’ll talk more about it when we use it.-->

```rust,ignore
struct Philosopher {
    name: String,
    left: usize,
    right: usize,
}
```

`Philosopher` にもう２つ欄を加えなければなりません。
哲学者には左に１本、右に１本、計２本のフォークを持たせます。
`usize` 型を使いフォークを表現します。ベクトルの添字になっている型がこれだからです。
この２つの値は `Table` が持つ `forks` の添字になります。

<!--We need to add two more fields to our `Philosopher`. Each philosopher is going
to have two forks: the one on their left, and the one on their right.
We’ll use the `usize` type to indicate them, as it’s the type that you index
vectors with. These two values will be the indexes into the `forks` our `Table`
has.-->

```rust,ignore
fn new(name: &str, left: usize, right: usize) -> Philosopher {
    Philosopher {
        name: name.to_string(),
        left: left,
        right: right,
    }
}
```

`left` と `right` の値を構築する必要があるので今 `new()` に追加しました。

<!--We now need to construct those `left` and `right` values, so we add them to
`new()`.-->

```rust,ignore
fn eat(&self, table: &Table) {
    let _left = table.forks[self.left].lock().unwrap();
    thread::sleep(Duration::from_millis(150));
    let _right = table.forks[self.right].lock().unwrap();

    println!("{} が食事をはじめた。", self.name);

    thread::sleep(Duration::from_millis(1000));

    println!("{} は食べ終わった。", self.name);
}
```

3 行増えました。引数 `table` を追加しました。`Table` のフォーク一覧を読み、続いて
`self.left` と `self.right` を使って添字の位置にあるフォークを取り出します。
その位置にある `Mutex` を操作できるようになったので `lock()` を呼びます。
もしこの〈ミューテックス〉が今まさに他から操作されている最中だった場合は、空くまでずっと待機します。
最初のフォークが取られて次のフォークが取られる合間に `thread::sleep` を呼ぶ必要があります。
フォークを瞬時に取り上げるのは変ですからね。

<!--We have three new lines. We’ve added an argument, `table`. We access the
`Table`’s list of forks, and then use `self.left` and `self.right` to access
the fork at that particular index. That gives us access to the `Mutex` at that
index, and we call `lock()` on it. If the mutex is currently being accessed by
someone else, we’ll block until it becomes available. We have also a call to
`thread::sleep` between the moment the first fork is picked and the moment the
second forked is picked, as the process of picking up the fork is not
immediate. -->

`lock()` の呼出しは失敗する可能性があり、仮にそうなった場合は急停止させたいです。
この場合、考えられる誤りは〈ミューテックス〉の[「汚染状態」][poison]です。
これはロックを抱えたままの走脈が混乱 (`panic!`)〈パニック〉した状況です。
今回は起こりえないはずですので、気にせず `unwrap()` します。

<!--The call to `lock()` might fail, and if it does, we want to crash. In this
case, the error that could happen is that the mutex is [‘poisoned’][poison],
which is what happens when the thread panics while the lock is held. Since this
shouldn’t happen, we just use `unwrap()`. -->

[poison]: ../std/sync/struct.Mutex.html#poisoning

もうひとつ奇妙なところがありますね。結果に `_left` と `_right` という名前をつけています。
この下線は一体どうしたのでしょうか？ そうですね、ロックの中の値を使う予定は _ない_ です。
ただロックを取得したいだけです。そのため、Rust は値を一度も使っていないと警告するでしょう。
下線をつけると Rust にこれが意図的なものであると伝えることができ、警告を消せます。

<!--One other odd thing about these lines: we’ve named the results `_left` and
`_right`. What’s up with that underscore? Well, we aren’t planning on
_using_ the value inside the lock. We just want to acquire it. As such,
Rust will warn us that we never use the value. By using the underscore,
we tell Rust that this is what we intended, and it won’t throw a warning.-->

ロックの解放はどうすればよいでしょう？
はい、`_left` と `_right` が範囲外に出たときに自動的に行われます。

<!--What about releasing the lock? Well, that will happen when `_left` and
`_right` go out of scope, automatically.-->

```rust,ignore
    let table = Arc::new(Table { forks: vec![
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
    ]});
```

続いて、`main()` で新しい `Table` を作り `Arc<T>` で包みこみます。
「arc」は「不可分参照数計 (atomic reference count)」の略で、`Table`
を複数の走脈にまたがって共用するために必要です。
共用した数にあわせて参照数が増えていき、走脈が終わりを迎えるごとに１ずつ減っていきます。

<!--Next, in `main()`, we make a new `Table` and wrap it in an `Arc<T>`.
‘arc’ stands for ‘atomic reference count’, and we need that to share
our `Table` across multiple threads. As we share it, the reference
count will go up, and when each thread ends, it will go back down.-->


```rust,ignore
let philosophers = vec![
    Philosopher::new("Judith Butler", 0, 1),    // ジュディス・バトラー
    Philosopher::new("Gilles Deleuze", 1, 2),   // ジル・ドゥルーズ
    Philosopher::new("Karl Marx", 2, 3),        // カール・マルクス
    Philosopher::new("Emma Goldman", 3, 4),     // エマ・ゴールドマン
    Philosopher::new("Michel Foucault", 0, 4),  // ミシェル・フーコー
];
```

`left` と `right` の値を内部の `Philosopher` 構築子〈コンストラクター〉に渡さなければなりません。
ただ、ここでもうひとつ小技が登場します。 _とても_ 大事なことです。この並びを見てどう思うでしょうか。
最後のひとつ前までは一貫していますが、ミシェル・フーコーの引数が `4, 0` と思いきや `0, 4` になっています。
実はこれがこう着状態を防ぐ技だったのです。哲学者の一人は左利きでした！
これは問題解決の一つの手法ですが、私の見立てでは最もかんたんな方法です。
引数の順番を変えてみるとこう着状態を観察できるでしょう。

<!--We need to pass in our `left` and `right` values to the constructors for our
`Philosopher`s. But there’s one more detail here, and it’s _very_ important. If
you look at the pattern, it’s all consistent until the very end. Monsieur
Foucault should have `4, 0` as arguments, but instead, has `0, 4`. This is what
prevents deadlock, actually: one of our philosophers is left handed! This is
one way to solve the problem, and in my opinion, it’s the simplest. If you
change the order of the parameters, you will be able to observe the deadlock
taking place. -->

```rust,ignore
let handles: Vec<_> = philosophers.into_iter().map(|p| {
    let table = table.clone();

    thread::spawn(move || {
        p.eat(&table);
    })
}).collect();
```

最後に、`map()`/`collect()` 繰り返しの内側で `table.clone()` を呼びます。
`Arc<T>` 上の `clone()` 操作法は参照数をひとつ増やすもので、可視範囲から外れたら計数をひとつ減らします。
これは `table` への参照が走脈内にどれだけ残っているか数えるために必要です。
仮に数えなかったとすると、どうやって正しく解放するか分からなかったことでしょう。

<!--Finally, inside of our `map()`/`collect()` loop, we call `table.clone()`. The
`clone()` method on `Arc<T>` is what bumps up the reference count, and when it
goes out of scope, it decrements the count. This is needed so that we know how
many references to `table` exist across our threads. If we didn’t have a count,
we wouldn’t know how to deallocate it.-->

`table` への新しい束縛を導入し、以前の名前を覆い隠していることに気づくでしょう。
２つのかぶらない名前を考えなくて済むようによく使われる手です。

<!--You’ll notice we can introduce a new binding to `table` here, and it will
shadow the old one. This is often used so that you don’t need to come up with
two unique names.-->

こうして、算譜が動くようになりました！
最大 2 人の哲学者が同時に食事できるので、出力は以下のようになるでしょう。

<!--With this, our program works! Only two philosophers can eat at any one time,
and so you’ll get some output like this:-->

```text
Gilles Deleuze が食事をはじめた。
Emma Goldman が食事をはじめた。
Emma Goldman は食べ終わった。
Gilles Deleuze は食べ終わった。
Judith Butler が食事をはじめた。
Karl Marx が食事をはじめた。
Judith Butler は食べ終わった。
Michel Foucault が食事をはじめた。
Karl Marx は食べ終わった。
Michel Foucault は食べ終わった。
```

おめでとう！ 古典的な並列処理問題を Rust で実装できましたね。

<!--Congrats! You’ve implemented a classic concurrency problem in Rust.-->

> 【訳者註】古典的 (classic)
> という言葉には「よく知られた」「標準的な」「不朽の」という意味合いもあります。
>  古くからある問題ですが、その内容は現代でも通用するものです。
