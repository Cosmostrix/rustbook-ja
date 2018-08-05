# 特性オブジェクト

コードに多型が含まれている場合、実際にどのバージョンが実行されているかを判断するメカニズムが必要です。
これは「ディスパッチ」と呼ばれます。
ディスパッチには、静的ディスパッチと動的ディスパッチという2つの主要な形式があります。
Rustは静的なディスパッチを優先しますが、それは「特性オブジェクト」と呼ばれるメカニズムを介した動的ディスパッチもサポートしています。

## バックグラウンド

この章の残りの部分では、特性といくつかの実装が必要です。
シンプルなものを作りましょう、`Foo`。
`String`を返すことが期待されるメソッドが1つあります。

```rust
trait Foo {
    fn method(&self) -> String;
}
```

`u8`と`String`この特性も実装します：

```rust
# trait Foo { fn method(&self) -> String; }
impl Foo for u8 {
    fn method(&self) -> String { format!("u8: {}", *self) }
}

impl Foo for String {
    fn method(&self) -> String { format!("string: {}", *self) }
}
```


## 静的なディスパッチ

この特性を使用して、特性境界で静的なディスパッチを実行することができます。

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something<T: Foo>(x: T) {
    x.method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();

    do_something(x);
    do_something(y);
}
```

Rustはここで静的ディスパッチを実行するために「単一形態」を使用します。
これは、Rustが`u8`と`String`両方に対して`do_something()`特別なバージョンを作成し、これらの特殊な関数への呼び出しで呼び出しサイトを置き換えることを意味します。
つまり、Rustは次のようなものを生成します。

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something_u8(x: u8) {
    x.method();
}

fn do_something_string(x: String) {
    x.method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();

    do_something_u8(x);
    do_something_string(y);
}
```

静的なディスパッチでは、コンパイル時に呼び出し先がわかっており、インライン展開が最適な最適化の鍵であるため、関数呼び出しをインライン化することができます。
静的なディスパッチは高速ですが、バイナリに存在する同じ関数の多くのコピーが各タイプごとに1つずつ存在するため、「コードが膨らむ」というトレードオフが発生します。

さらに、コンパイラは完璧ではなく、コードを「最適化」して低速になる可能性があります。
たとえば、インライン化された関数は、命令キャッシュを膨らませてしまいます（キャッシュルールは私たちの周りのすべてを制御します）。
これは、`#[inline]`と`#[inline(always)]`を慎重に使用する必要がある理由の1つで、動的ディスパッチを使用する理由の1つがより効率的な理由の1つです。

しかし、一般的なケースは、静的ディスパッチを使用する方が効率的であり、動的ディスパッチを行う静的にディスパッチされたラッパー関数を持つことができます。
このため、標準ライブラリは可能な場合は静的にディスパッチしようとします。

## ダイナミックディスパッチ

Rustは、「特性オブジェクト」と呼ばれる機能を通じて動的なディスパッチを提供します。
`&Foo`や`Box<Foo>`などの特性オブジェクトは、指定された特性を実装する*任意の*型の値を格納する通常の値です。正確な型は実行時にしか知ることができません。

形質オブジェクトは、それを*キャスト*することによって形質を実現する具体的な型へのポインタから得ることができる（例えば、`&x as &Foo`）又は（例えば、使用してそれを*強制する* `&x`とる関数の引数として`&Foo`）。

これらの特性オブジェクトの強制変換とキャストは、`&mut T`から`&mut Foo`、 `Box<T>`から`Box<Foo>` `&mut Foo`へのポインターでも機能しますが、それはすべて現時点でのものです。
強制とキャストは同じです。

この操作は、ポインタの特定の型に関するコンパイラの知識を「消去する」と見なすことができるため、特性オブジェクトは「型消去」と呼ばれることがあります。

上記の例に戻り、同じ特性を使用して、キャストによって特性オブジェクトを使用した動的ディスパッチを実行できます。

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something(x: &Foo) {
    x.method();
}

fn main() {
    let x = 5u8;
    do_something(&x as &Foo);
}
```

または強制することによって：

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something(x: &Foo) {
    x.method();
}

fn main() {
    let x = "Hello".to_string();
    do_something(&x);
}
```

traitオブジェクトをとる関数は、`Foo`を実装するそれぞれの型に特化していません。たった1つのコピーしか生成されませんが、常にそうであるとは限りません。
しかし、これは、より遅い仮想関数呼び出しを必要とし、インライン化および関連する最適化の発生を効果的に阻止することを犠牲にして行われる。

### なぜポインタ？

Rustは多くの管理言語と違って、デフォルトでポインタの後ろに物を置かないので、型のサイズが異なる可能性があります。
コンパイル時に値のサイズを知ることは、それを関数の引数として渡したり、スタック上でそれを移動したり、ヒープにスペースを割り当てて（割り当てを解除して）格納するなどの場合に重要です。

`Foo`場合、`String`（24バイト）または`u8`（1バイト）のほか、 `Foo`実装する可能性のある他の型（バイト数はまったくありません））。
値がポインタなしで格納されている場合、この最後の点が動作することを保証する方法はありません。これらの他の型は任意に大きくすることができるからです。

値をポインタの後ろに置くということは、traitオブジェクトを投げているときに値のサイズが関係なく、ポインタ自体のサイズだけであることを意味します。

### 表現

特性のメソッドは、伝統的に「コンパイラによって作成され、管理される」vtableと呼ばれる特別な関数ポインタのレコードを介して特性オブジェクト上で呼び出すことができます。

特性オブジェクトはシンプルで複雑です。そのコア表現とレイアウトはかなり単純ですが、中にはいくつかのエラーメッセージと驚くべき動作があります。

traitオブジェクトのランタイム表現を使って簡単に始めましょう。
`std::raw`モジュールには、[traitオブジェクトを含む][stdraw]複雑な組み込み型と同じレイアウトの構造体が含まれてい[ます][stdraw]。

```rust
# mod foo {
pub struct TraitObject {
    pub data: *mut (),
    pub vtable: *mut (),
}
# }
```

[stdraw]: ../../std/raw/struct.TraitObject.html

つまり、`&Foo`ような特性オブジェクトは、'data'ポインタと 'vtable'ポインタで構成されています。

データポインタは、特性オブジェクトが記憶している（未知のタイプ`T`）データをアドレス指定し、vテーブルポインタは`T`の`Foo`の実装に対応するvテーブル（「仮想メソッドテーブル」）を指し示す。


vtableは基本的には関数ポインタの構造体で、実装の各メソッドの具体的な機械コードを指しています。
`trait_object.method()`ようなメソッド呼び出しは、vtableから正しいポインタを取り出してからそれを動的に呼び出します。
例えば：

```rust,ignore
struct FooVtable {
    destructor: fn(*mut ()),
    size: usize,
    align: usize,
    method: fn(*const ()) -> String,
}

#// u8:
//  u8：

fn call_method_on_u8(x: *const ()) -> String {
#    // The compiler guarantees that this function is only called
#    // with `x` pointing to a u8.
    // コンパイラは、この関数は`x`がu8を指している場合にのみ呼び出されることを保証します。
    let byte: &u8 = unsafe { &*(x as *const u8) };

    byte.method()
}

static Foo_for_u8_vtable: FooVtable = FooVtable {
    destructor: /* compiler magic */,
    size: 1,
    align: 1,

#    // Cast to a function pointer:
    // 関数ポインタにキャスト：
    method: call_method_on_u8 as fn(*const ()) -> String,
};


#// String:
// 文字列：

fn call_method_on_String(x: *const ()) -> String {
#    // The compiler guarantees that this function is only called
#    // with `x` pointing to a String.
    // コンパイラは、この関数は、`x`がStringを指している場合にのみ呼び出されることを保証します。
    let string: &String = unsafe { &*(x as *const String) };

    string.method()
}

static Foo_for_String_vtable: FooVtable = FooVtable {
    destructor: /* compiler magic */,
#    // Values for a 64-bit computer, halve them for 32-bit ones.
    //  64ビットコンピュータの場合は32ビットの値を半分にします。
    size: 24,
    align: 8,

    method: call_method_on_String as fn(*const ()) -> String,
};
```

`destructor`のvtableのタイプのすべてのリソースをクリーンアップする関数への各vtableのポイントでのフィールド：のために`u8`それは簡単ですが、ために`String`、それはメモリを解放します。
これは、`Box<Foo>`ような特性オブジェクトを所有するために必要です.Byte `Box<Foo>`は、範囲外に出たときに`Box`割り当てと内部型の両方をクリーンアップする必要があります。
`size`および`align`フィールドには、消去されたタイプのサイズと整列要件が格納されます。

`Foo`を実装するいくつかの値があるとします。
`Foo`特性オブジェクトの明示的な構成と使用方法は少し違って見えるかもしれません（型の不一致は無視されます：とにかくすべてのポインタです）。

```rust,ignore
let a: String = "foo".to_string();
let x: u8 = 1;

#// let b: &Foo = &a;
//  let b：＆Foo =＆a;
let b = TraitObject {
#    // Store the data:
    // データを保存する：
    data: &a,
#    // Store the methods:
    // メソッドを格納します。
    vtable: &Foo_for_String_vtable
};

#// let y: &Foo = x;
//  let y：＆Foo = x;
let y = TraitObject {
#    // Store the data:
    // データを保存する：
    data: &x,
#    // Store the methods:
    // メソッドを格納します。
    vtable: &Foo_for_u8_vtable
};

#// b.method();
//  b.method（）;
(b.vtable.method)(b.data);

#// y.method();
//  y.method（）;
(y.vtable.method)(y.data);
```

## オブジェクトの安全

すべての形質を特性オブジェクトの作成に使用することはできません。
たとえば、ベクターは`Clone`実装しますが、traitオブジェクトを作成しようとすると、次のようになります。

```rust,ignore
let v = vec![1, 2, 3];
let o = &v as &Clone;
```

エラーが表示されます。

```text
error: cannot convert to a trait object because trait `core::clone::Clone` is not object-safe [E0038]
let o = &v as &Clone;
        ^~
note: the trait cannot require that `Self : Sized`
let o = &v as &Clone;
        ^~
```

エラーは、`Clone`は「オブジェクトセーフ」ではないと言います。
オブジェクトセーフである形質のみを形質オブジェクトにすることができます。
これらの両方が真である場合、形質はオブジェクトセーフです。

* その特性はそれを必要としません`Self: Sized`
* すべてのメソッドはオブジェクトセーフです

だから、メソッドをオブジェクトセーフにするには？
各メソッドは、`Self: Sized`または以下のすべてを必要とする必要があります。

* 型パラメータを持たない
* `Self`使用してはいけません

すごい！
わかるように、これらの規則のほとんどすべてが`Self`について語ります。
良い直感は、「特殊な状況を除いて、あなたの形質の方法が`Self`使用する場合、それはオブジェクトセーフではありません」。
