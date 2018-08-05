# 関連タイプ

関連タイプは、Rustのタイプシステムの強力な部分です。
彼らは「タイプファミリー」という考え方、つまり複数のタイプをまとめてグループ化するという考え方に関係しています。
その説明はちょっと抽象的なので、例を見てみましょう。
`Graph`特性を書きたい場合は、ノードタイプとエッジタイプの2種類があります。
ですから、`Graph<N, E>`書くと、次のようになります。

```rust
trait Graph<N, E> {
    fn has_edge(&self, &N, &N) -> bool;
    fn edges(&self, &N) -> Vec<E>;
#    // Etc.
    // 等。
}
```

この種の作品では、厄介なことに終わります。
例えば、取りたい任意の関数`Graph`パラメータとしては今 _も_ オーバー総称である必要が`N`頌歌と`E`あまりにDGEの種類：

```rust,ignore
fn distance<N, E, G: Graph<N, E>>(graph: &G, start: &N, end: &N) -> u32 { ... }
```

私たちの距離の計算は`Edge`タイプにかかわらず動作するので、この署名の`E`ものは注意散漫です。

私たちが本当に言いたいのは、特定の`E` dgeと`N` odeタイプが一緒になって各種類の`Graph`を形成するということです。
関連する型でこれを行うことができます：

```rust
trait Graph {
    type N;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
#    // Etc.
    // 等。
}
```

さて、私たちのクライアントは、与えられた`Graph`抽象化することができます：

```rust,ignore
fn distance<G: Graph>(graph: &G, start: &G::N, end: &G::N) -> u32 { ... }
```

ここで`E` dgeタイプに対処する必要はありません！

このすべてをもっと詳しく説明しましょう。

## 関連タイプの定義

`Graph`特性を作りましょう。
定義は次のとおりです。

```rust
trait Graph {
    type N;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
}
```

十分に簡単です。
関連する型は`type`キーワードを使用し、関数の本体の内部に関数とともに入ります。

これらの型宣言は、関数の型宣言と同じように機能します。
たとえば、`N`型が`Display`を実装してノードを印刷できるようにしたい場合、次のようにします。

```rust
use std::fmt;

trait Graph {
    type N: fmt::Display;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
}
```

## 関連する型の実装

関連する型を使用する`impl`、どんな形質と同様、実装を提供するために`impl`キーワードを使用します。
Graphの簡単な実装は次のとおりです。

```rust
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
struct Node;

struct Edge;

struct MyGraph;

impl Graph for MyGraph {
    type N = Node;
    type E = Edge;

    fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
        true
    }

    fn edges(&self, n: &Node) -> Vec<Edge> {
        Vec::new()
    }
}
```

この愚かな実装は常に`true`と空の`Vec<Edge>`返し`true`、このようなことを実装する方法のアイデアが得られます。
まず、グラフ用、ノード用、エッジ用の3つの`struct`が必要です。
別の型を使用する方が理にかなっていれば、同様に動作しますが、ここでは3つすべての`struct`を使用します。

次は`impl`ラインです。これは他の特性と同じように実装されています。

ここからは、`=`を使用して関連タイプを定義します。
形質が使用する名前は、左に行く`=`、と私たちはしている具体的なタイプ`impl`右側に行くためにこれをementing。
最後に、関数宣言で具体的な型を使用します。

## 関連する型を持つTraitオブジェクト

私たちが話しておくべきもう一つの構文があります：特性オブジェクトです。
関連する型を持つtraitからtraitオブジェクトを作成しようとすると、次のようになります。

```rust,ignore
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
# struct Node;
# struct Edge;
# struct MyGraph;
# impl Graph for MyGraph {
#     type N = Node;
#     type E = Edge;
#     fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
#         true
#     }
#     fn edges(&self, n: &Node) -> Vec<Edge> {
#         Vec::new()
#     }
# }
let graph = MyGraph;
let obj = Box::new(graph) as Box<Graph>;
```

2つのエラーが発生します：

```text
error: the value of the associated type `E` (from the trait `main::Graph`) must
be specified [E0191]
let obj = Box::new(graph) as Box<Graph>;
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
24:44 error: the value of the associated type `N` (from the trait
`main::Graph`) must be specified [E0191]
let obj = Box::new(graph) as Box<Graph>;
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

関連する型がわからないため、このような特性オブジェクトを作成することはできません。
代わりに、これを書くことができます：

```rust
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
# struct Node;
# struct Edge;
# struct MyGraph;
# impl Graph for MyGraph {
#     type N = Node;
#     type E = Edge;
#     fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
#         true
#     }
#     fn edges(&self, n: &Node) -> Vec<Edge> {
#         Vec::new()
#     }
# }
let graph = MyGraph;
let obj = Box::new(graph) as Box<Graph<N=Node, E=Edge>>;
```

`N=Node`構文を使用すると、`N`型パラメータに具体的な型`Node`指定できます。
`E=Edge`と同じです。
この制約を与えなかった場合、この特性オブジェクトとどの`impl`が一致するかはわかりませんでした。
