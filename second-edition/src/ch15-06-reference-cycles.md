## 参照円環が記憶をリークする可能性がある

Rustの記憶安全性保証により、決して決して浄化されない記憶（*記憶リークと*呼ばれる）を誤って作成することは、不可能ではありません。
記憶リークを完全に防ぐことは、<ruby>製譜<rt>コンパイル</rt></ruby>時にデータ競合を禁止するのと同じ方法で、Rustの保証の1つではなく、記憶リークがRustで記憶セーフであることを意味します。
Rustは`Rc<T>`と`RefCell<T>`を使用して記憶リークを許可することがわかります。項目が円環内で互いに参照する参照を作成することは可能です。
これにより、円環内の各項目の参照カウントが決して0にならず、値が決して破棄されないため、記憶リークが発生します。

### 参照円環の作成

リスト15-25の`List` enumと`tail`<ruby>操作法<rt>メソッド</rt></ruby>の定義から始めて、参照円環がどのように起こるか、そしてそれを防ぐ方法を見てみましょう。

<span class="filename">ファイル名。src/main.rs</span>


```rust
# fn main() {}
use std::rc::Rc;
use std::cell::RefCell;
use List::{Cons, Nil};

#[derive(Debug)]
enum List {
    Cons(i32, RefCell<Rc<List>>),
    Nil,
}

impl List {
    fn tail(&self) -> Option<&RefCell<Rc<List>>> {
        match *self {
            Cons(_, ref item) => Some(item),
            Nil => None,
        }
    }
}
```

<span class="caption">15-25リスト。保持短所リスト定義<code>RefCell&lt;T&gt;</code>何を修正することができるように<code>Cons</code>場合値が参照しています</span>

リスト15-5の`List`定義の別の<ruby>場合値<rt>バリアント</rt></ruby>を使用しています。
`Cons`<ruby>場合値<rt>バリアント</rt></ruby>の2番目の要素は`RefCell<Rc<List>>`。つまり、リスト15-24のように`i32`値を変更するのではなく、`Cons`<ruby>場合値<rt>バリアント</rt></ruby>が指している`List`値を変更する必要がありますに。
また、`Cons`<ruby>場合値<rt>バリアント</rt></ruby>があれば、2番目の項目にアクセスするのに便利な`tail`<ruby>操作法<rt>メソッド</rt></ruby>を追加しています。

リスト15-26に、リスト15-25の定義を使用する`main`機能を追加します。
この<ruby>譜面<rt>コード</rt></ruby>は、リスト作成と、リスト`a` `b`内のリストを指します。`a`
次に、`a`のリストを`b`を指すように変更して、参照円環を作成します。
この過程のさまざまな時点で参照カウントが何であるかを示すために途中で`println!`文があります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use List::{Cons, Nil};
# use std::rc::Rc;
# use std::cell::RefCell;
# #[derive(Debug)]
# enum List {
#     Cons(i32, RefCell<Rc<List>>),
#     Nil,
# }
#
# impl List {
#     fn tail(&self) -> Option<&RefCell<Rc<List>>> {
#         match *self {
#             Cons(_, ref item) => Some(item),
#             Nil => None,
#         }
#     }
# }
#
fn main() {
    let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));

    println!("a initial rc count = {}", Rc::strong_count(&a));
    println!("a next item = {:?}", a.tail());

    let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

    println!("a rc count after b creation = {}", Rc::strong_count(&a));
    println!("b initial rc count = {}", Rc::strong_count(&b));
    println!("b next item = {:?}", b.tail());

    if let Some(link) = a.tail() {
        *link.borrow_mut() = Rc::clone(&b);
    }

    println!("b rc count after changing a = {}", Rc::strong_count(&b));
    println!("a rc count after changing a = {}", Rc::strong_count(&a));

#    // Uncomment the next line to see that we have a cycle;
#    // it will overflow the stack
#    // println!("a next item = {:?}", a.tail());
    // 次の行の<ruby>注釈<rt>コメント</rt></ruby>を外して、円環があることを確認します。それは<ruby>山<rt>スタック</rt></ruby>println！　（"次の項目= {。？　}"、a.tail（））をオーバーフローさせます。
}
```

<span class="caption">リスト15-26。互いに指し示す2つの<code>List</code>値の参照円環を作成する</span>

最初のリストが`5, Nil`変数`a` `List`値を保持する`Rc<List>`<ruby>実例<rt>インスタンス</rt></ruby>を作成します。
その後、作成`Rc<List>`別の保持の<ruby>実例<rt>インスタンス</rt></ruby>`List`変数に値を`b`でリストに値10と点を含んでいます。`a`

私は`a`を修正して`a` `Nil`代わりに`b`を指し、円環を作ります。
使用していることを行う`tail`への参照を取得する方法を`RefCell<Rc<List>>`で、変数に入れて、`a` `link`。
次に`RefCell<Rc<List>>`の`borrow_mut`<ruby>操作法<rt>メソッド</rt></ruby>を使用して、`Nil`値を保持する`Rc<List>`から内部の値を`b` `Rc<List>`します。

この<ruby>譜面<rt>コード</rt></ruby>を実行すると、最後の`println!`<ruby>注釈<rt>コメント</rt></ruby>化されたままになって`println!`ば、次の出力が得られます。

```text
a initial rc count = 1
a next item = Some(RefCell { value: Nil })
a rc count after b creation = 2
b initial rc count = 1
b next item = Some(RefCell { value: Cons(5, RefCell { value: Nil }) })
b rc count after changing a = 2
a rc count after changing a = 2
```

参照カウント`Rc<List>`の両方で<ruby>実例<rt>インスタンス</rt></ruby>`a`と`b`リストを変更した後、2ですを指すように`a` `b`。
`main`の最後で、Rustは最初に`b`を落とそうとし、`a`と`b`の`Rc<List>`<ruby>実例<rt>インスタンス</rt></ruby>のそれぞれの数を1減らします。

しかし、まだ参照している`a` `Rc<List>`にあった`b`することを、`Rc<List>` 1ではなく0の数を持っているので、記憶`Rc<List>`<ruby>脱落<rt>ドロップ</rt></ruby>されることはありません原上にあります。
記憶は永遠に1のカウントでそこに座ります。
この参照円環を視覚化するために、図15-4の図を作成しました。

<img src="img/trpl15-04.svg" alt="リストの参照円環" class="center" />
<span class="caption">図15-4。互いに指し示すリスト<code>a</code>と<code>b</code>参照円環</span>

最後の<ruby>注釈<rt>コメント</rt></ruby>を解除した場合`println!`、<ruby>算譜<rt>プログラム</rt></ruby>を実行し、Rustがでこの円環を<ruby>印字<rt>プリント</rt></ruby>しようとするポインティング`a` `b`を指して、それが<ruby>山<rt>スタック</rt></ruby>をオーバーフローするまで、などと。`a`

この場合、参照円環を作成した直後に、<ruby>算譜<rt>プログラム</rt></ruby>は終了します。
この円環の結果はあまり悲惨ではありません。
しかし、より複雑な<ruby>算譜<rt>プログラム</rt></ruby>が1つの円環で大量の記憶を割り当てて長時間保持すると、<ruby>算譜<rt>プログラム</rt></ruby>は必要以上の記憶を使用し、システムを圧倒して使用可能な記憶が使い果たされる可能性があります。

参照円環の作成は簡単ではありませんが、不可能ではありません。
`Rc<T>`値または内部の変更可能性と参照カウントを持つ型の同様の入れ子になった組み合わせを含む`RefCell<T>`値がある場合は、円環を作成しないようにする必要があります。
それらを捕まえるためにRustに頼ることはできません。
参照円環を作成することは、自動化されたテスト、<ruby>譜面精査<rt>コードレビュー</rt></ruby>、およびその他の<ruby>譜体<rt>アプリケーション</rt></ruby>開発の慣行を最小限に抑えるために、<ruby>算譜<rt>プログラム</rt></ruby>の<ruby>論理<rt>ロジック</rt></ruby>バグになります。

参照円環を回避するもう1つの方法は、データ構造を再編成して、一部の参照が所有権を表し、一部の参照が所有権を示さないようにすることです。
その結果、いくつかの所有関係といくつかの非所有関係からなる円環を持つことができ、所有関係だけが値を削除できるかどうかに影響します。
リスト15-25では、`Cons`<ruby>場合値<rt>バリアント</rt></ruby>が常にリストを所有するようにしたいので、データ構造を再編成することはできません。
親ノードと子ノードで構成されるグラフを使用して、非所有関係が参照円環を防止する適切な方法であるかどうかを確認する例を見てみましょう。

### 参照円環の防止。 `Rc<T>`を`Weak<T>`変える

これまで、`Rc::clone`を呼び出すと`Rc::clone` `Rc<T>`<ruby>実例<rt>インスタンス</rt></ruby>の`strong_count`が増加し、`Rc<T>`<ruby>実例<rt>インスタンス</rt></ruby>はその`strong_count`が0の場合にのみ後始末されることが*示さ*れています。`Rc::downgrade`を呼び出して`Rc<T>`への参照を渡すことにより、`Rc<T>`<ruby>実例<rt>インスタンス</rt></ruby>内の値を取得します。
`Rc::downgrade`を呼び出すと`Weak<T>`型のスマート<ruby>指し手<rt>ポインタ</rt></ruby>が得られます。
代わり増加の`strong_count`で`Rc<T>`を呼び出す、1<ruby>実例<rt>インスタンス</rt></ruby>を`Rc::downgrade`増加`weak_count` 1だけ`Rc<T>`型が使用`weak_count`どのように多くのトラック維持する`Weak<T>`と同様、参照が存在し`strong_count`。
違いは、`Rc<T>`<ruby>実例<rt>インスタンス</rt></ruby>を後始末するには、`weak_count` 0にする必要はないということです。

強力な参照は、`Rc<T>`<ruby>実例<rt>インスタンス</rt></ruby>の所有権を共有する方法です。
弱い参照は所有関係を表していません。
関連する値の強い参照カウントが0になると、弱い参照を含む円環が壊れるため、参照円環が発生しません。

`Weak<T>`参照している値が削除されている可能性があるため、`Weak<T>`が指す値で何かを行うには、その値がまだ存在することを確認する必要があります。
これを行うには、`Option<Rc<T>>`を返す`Weak<T>`<ruby>実例<rt>インスタンス</rt></ruby>の`upgrade`<ruby>操作法<rt>メソッド</rt></ruby>を呼び出し`upgrade`。
結果を得るだろう`Some`場合`Rc<T>`値がまだ削除されていないとの結果`None`場合`Rc<T>`値が削除されました。
`upgrade`は`Option<T>`返すので、Rustは`Some` caseと`None`ケースが処理され、無効な<ruby>指し手<rt>ポインタ</rt></ruby>が存在しないことを保証します。

例として、項目が次の項目のみを知っているリストを使用するのではなく、項目が子項目*と*その親項目について知っているツリーを作成します。

#### ツリーデータ構造の作成。 `Node`の子ノードとし

まず、子ノードについて知っているノードを持つツリーを構築します。
構造体の名前の作成します`Node`自身の保持している`i32`その子への参照だけでなく、値を`Node`値を。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::rc::Rc;
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    children: RefCell<Vec<Rc<Node>>>,
}
```

`Node`はその子を所有したいので、ツリー内の各`Node`に直接アクセスできるように、その所有権を変数と共有する必要があります。
これを行うために、`Vec<T>`項目を`Rc<Node>`型の値と定義します。
また、どのノードが別のノードの子ノードであるかを変更したいので、`Vec<Rc<Node>>` `children`ノードに`RefCell<T>`があり`Vec<Rc<Node>>`。

次に、構造体定義を使用しますと、1つの作成`Node`<ruby>実例<rt>インスタンス</rt></ruby>という名前の`leaf`値3と子供がいない、と別の<ruby>実例<rt>インスタンス</rt></ruby>の名前で`branch`値5とで`leaf` 15-27リストに示すように、その子の1つとして。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::rc::Rc;
# use std::cell::RefCell;
#
# #[derive(Debug)]
# struct Node {
#     value: i32,
#    children: RefCell<Vec<Rc<Node>>>,
# }
#
fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        children: RefCell::new(vec![]),
    });

    let branch = Rc::new(Node {
        value: 5,
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });
}
```

<span class="caption">15-27リスト。作成<code>leaf</code>子を持たないノードと<code>branch</code>を持つノード<code>leaf</code>その子の1つとして、</span>

クローン`Rc<Node>`に`leaf`とのそれを保存`branch`意味、`Node`内`leaf`今2つのオーナーあり。 `leaf`や`branch`。
`branch.children`を通して、`branch`から`leaf`まで得ることができますが、`leaf`から`branch`に到達する方法はありません。
その理由は、`leaf`は`branch`への参照を持たず、それらが関連していることを知らないからです。
`leaf`が`branch`がその親であることを知ることを望みます。
次にそれを行います。

#### 子から親への参照の追加

子ノードがその親を認識するようにするには、`Node`構造体定義に`parent`<ruby>欄<rt>フィールド</rt></ruby>を追加する必要があります。
問題は、`parent`の型を決定することです。
それが含まれていないことを知って`Rc<T>`それがで基準周期を作成しますので、`leaf.parent`指し`branch`と`branch.children`を指して`leaf`その原因と思われる、`strong_count`値が0になることはありませんし。

別の方法で関係を考えると、親ノードは子ノードを所有する必要があります。親ノードが削除された場合、その子ノードも削除する必要があります。
しかし、子は親を所有すべきではありません。子ノードを削除すると、親はまだ存在するはずです。
これは弱い参照の場合です！　

したがって、`Rc<T>`代わりに、`Weak<T>` `parent`の型、特に`RefCell<Weak<Node>>`ます。
これで、`Node`構造体の定義は次のようになります。

<span class="filename">ファイル名。src/main.rs</span>

```rust
use std::rc::{Rc, Weak};
use std::cell::RefCell;

#[derive(Debug)]
struct Node {
    value: i32,
    parent: RefCell<Weak<Node>>,
    children: RefCell<Vec<Rc<Node>>>,
}
```

ノードはその親ノードを参照することができるが、その親を所有しない。
リスト15-28では、この新しい定義を使用するように`main`を更新して、`leaf`ノードがその親の`branch`を参照する方法を持つようにします。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::rc::{Rc, Weak};
# use std::cell::RefCell;
#
# #[derive(Debug)]
# struct Node {
#     value: i32,
#     parent: RefCell<Weak<Node>>,
#     children: RefCell<Vec<Rc<Node>>>,
# }
#
fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());

    let branch = Rc::new(Node {
        value: 5,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });

    *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
}
```

<span class="caption">リスト15-28。親ノード<code>branch</code>への弱い参照を持つ<code>leaf</code>ノード</span>

`leaf`ノードの作成は、リスト15-27のように、`leaf`ノードを作成する方法と似ていますが、`parent`<ruby>欄<rt>フィールド</rt></ruby>は例外です。`leaf`は親なしで開始されるため、空の`Weak<Node>`参照<ruby>実例<rt>インスタンス</rt></ruby>を作成します。

この時点で、`upgrade`<ruby>操作法<rt>メソッド</rt></ruby>を使用して`leaf`の親への参照を取得しようとすると、`None`値が返されます。
これは最初の`println!`文の出力にあります。

```text
leaf parent = None
```

作成した場合`branch`ノードを、それはまた、新しい必要があります`Weak<Node>`で参照`parent`ので、<ruby>欄<rt>フィールド</rt></ruby>を`branch`親ノードを持ちません。
まだ`branch`の子供の一人として`leaf`を持っています。
`branch`<ruby>実例<rt>インスタンス</rt></ruby>に`Node`<ruby>実例<rt>インスタンス</rt></ruby>を設定したら、`leaf`を修正して親`Weak<Node>`への`Weak<Node>`参照を与えることができます。
`leaf`の`parent`<ruby>欄<rt>フィールド</rt></ruby>の`RefCell<Weak<Node>>`で`borrow_mut`<ruby>操作法<rt>メソッド</rt></ruby>を使用し、`Rc::downgrade`機能を使用して`branch`の`Rc<Node>`から`branch`する`Weak<Node>`参照を作成します`branch.`

今度は`leaf`の親をもう一度<ruby>印字<rt>プリント</rt></ruby>すると、今度は`branch`持つ`Some` <ruby>場合値<rt>バリアント</rt></ruby>を取得します。今、`leaf`はその親にアクセスできます！　
`leaf`を<ruby>印字<rt>プリント</rt></ruby>するとき、リスト15-26のように<ruby>山<rt>スタック</rt></ruby>のオーバーフローで終了する円環も回避します。
`Weak<Node>`参照は`(Weak)`として出力されます。

```text
leaf parent = Some(Node { value: 5, parent: RefCell { value: (Weak) },
children: RefCell { value: [Node { value: 3, parent: RefCell { value: (Weak) },
children: RefCell { value: [] } }] } })
```

無限の出力がないことは、この<ruby>譜面<rt>コード</rt></ruby>が参照円環を作成しなかったことを示します。
また、`Rc::strong_count`と`Rc::weak_count`呼び出すことで得られる値を調べることで、これを知ることができます。

#### `strong_count`と`weak_count`への変更の可視化

新しい内部<ruby>有効範囲<rt>スコープ</rt></ruby>を作成し、その<ruby>有効範囲<rt>スコープ</rt></ruby>に`branch`の作成を移動することによって、`Rc<Node>`<ruby>実例<rt>インスタンス</rt></ruby>の`strong_count`と`weak_count`値がどのように`strong_count`するかを見てみましょう。
そうすることで、`branch`が作成され、<ruby>有効範囲<rt>スコープ</rt></ruby>外になったときに`branch`が作成されたときに何が起こるかを確認することができます。
リスト15-29にその変更を示します。

<span class="filename">ファイル名。src/main.rs</span>

```rust
# use std::rc::{Rc, Weak};
# use std::cell::RefCell;
#
# #[derive(Debug)]
# struct Node {
#     value: i32,
#     parent: RefCell<Weak<Node>>,
#     children: RefCell<Vec<Rc<Node>>>,
# }
#
fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );

    {
        let branch = Rc::new(Node {
            value: 5,
            parent: RefCell::new(Weak::new()),
            children: RefCell::new(vec![Rc::clone(&leaf)]),
        });

        *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

        println!(
            "branch strong = {}, weak = {}",
            Rc::strong_count(&branch),
            Rc::weak_count(&branch),
        );

        println!(
            "leaf strong = {}, weak = {}",
            Rc::strong_count(&leaf),
            Rc::weak_count(&leaf),
        );
    }

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );
}
```

<span class="caption">リスト15-29。内部<ruby>有効範囲<rt>スコープ</rt></ruby>内に<code>branch</code>を作成し、強い参照カウントと弱い参照カウントを調べる</span>

`leaf`が作成された後、その`Rc<Node>`は1の強いカウントと0の弱いカウントを持ちます。内部<ruby>有効範囲<rt>スコープ</rt></ruby>では、`branch`を作成し、それを`leaf`に関連付けます。カウントを<ruby>印字<rt>プリント</rt></ruby>するとき、`Rc<Node>` `branch`に1の強いカウントと1の弱いカウントがあります（`Weak<Node>` `branch`を指す`leaf.parent`場合）。
カウントを<ruby>印字<rt>プリント</rt></ruby>するとき`leaf`、ので、それは、2の強力な数を持っています表示されます`branch`今のクローンがある`Rc<Node>`の`leaf`に保存されている`branch.children`、まだ0の弱い数を持っています。

内部<ruby>有効範囲<rt>スコープ</rt></ruby>が終了すると、`branch`が<ruby>有効範囲<rt>スコープ</rt></ruby>外になり、`Rc<Node>`強いカウントが0に減少し、その`Node`が削除されます。
`leaf.parent`からの1の弱いカウントは、`Node`が<ruby>脱落<rt>ドロップ</rt></ruby>したかどうかに関係なく、記憶リークは発生しません！　

<ruby>有効範囲<rt>スコープ</rt></ruby>の終了後に`leaf`の親にアクセスしようとすると、再び`None`が`None`れます。
<ruby>算譜<rt>プログラム</rt></ruby>の終了時に、`Rc<Node>`で`leaf`可変のため、1の強力な数と0の弱い数を持っている`leaf`、今への参照のみである`Rc<Node>`もう一度。

カウントと値の低下を管理するすべての<ruby>論理<rt>ロジック</rt></ruby>は、`Rc<T>`と`Weak<T>`と`Drop`<ruby>特性<rt>トレイト</rt></ruby>の実装に組み込まれています。
子ノードから親ノードへの関係が`Node`の定義における`Weak<T>`参照であることを指定することによって、親ノードが子ノードを指すようにすることができます。

## 概要

この章では、スマート<ruby>指し手<rt>ポインタ</rt></ruby>を使用して、Rustが自動的に通常参照するものとは異なる保証と<ruby>相殺取引<rt>トレードオフ</rt></ruby>を行う方法について説明しました。
`Box<T>`型は既知のサイズを持ち、原に割り当てられたデータを指します。
`Rc<T>`型は、データが複数の所有者を持つことができるように、原上のデータへの参照の数を追跡します。
内部の`RefCell<T>`型は、不変型を必要とするが、その型の内部値を変更する必要があるときに使用できる型を与えます。
<ruby>製譜<rt>コンパイル</rt></ruby>時ではなく、実行時に借用ルールを強制型変換します。

スマート<ruby>指し手<rt>ポインタ</rt></ruby>の多くの機能を有効にする`Deref`と`Drop`特徴についても説明しました。
`Weak<T>`を使用して記憶リークを引き起こす可能性のある参照円環とその回避方法について調べました。

この章で興味をそそられていて、独自のスマート<ruby>指し手<rt>ポインタ</rt></ruby>を実装したい場合は、[「The Rustonomicon」][nomicon]を参照してください。

[nomicon]: https://doc.rust-lang.org/stable/nomicon/

次に、Rustの並行処理について説明します。
いくつかの新しいスマート<ruby>指し手<rt>ポインタ</rt></ruby>についても学びます。
