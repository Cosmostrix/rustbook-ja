# 特性対象

譜面に多相性が含まれている場合、実際にどの版が実行されているかを判断するしくみが必要です。
これは「指名」と呼ばれます。
指名には、静的指名と動的指名という2つの主要な形式があります。
Rustは静的な指名を優先しますが、それは「特性対象」と呼ばれるしくみを介した動的指名もサポートしています。

## 背景

この章の残りの部分では、特性といくつかの実装が必要です。
シンプルなものを作りましょう、`Foo`。
`String`を返すことが期待される操作法が1つあります。

```rust
trait Foo {
    fn method(&self) -> String;
}
```

`u8`と`String`この特性も実装します。

```rust
# trait Foo { fn method(&self) -> String; }
impl Foo for u8 {
    fn method(&self) -> String { format!("u8: {}", *self) }
}

impl Foo for String {
    fn method(&self) -> String { format!("string: {}", *self) }
}
```


## 静的な指名

この特性を使用して、特性縛りで静的な指名を実行することができます。

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

Rustはここで静的指名を実行するために「単相化法」を使用します。
これは、Rustが`u8`と`String`両方に対して`do_something()`特別な版を作成し、これらの特殊な機能への呼び出しで呼び出し位置を置き換えることを意味します。
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

静的な指名では、製譜時に呼び出し先がわかっており、インライン展開が最適な最適化の鍵であるため、機能呼び出しをインライン化することができます。
静的な指名は高速ですが、二進譜に存在する同じ機能の多くのコピーが各型ごとに1つずつ存在するため、「譜面が膨らむ」という相殺取引が発生します。

さらに、製譜器は完璧ではなく、譜面を「最適化」して低速になる可能性があります。
たとえば、インライン化された機能は、命令キャッシュを膨らませてしまいます（キャッシュルールは周りのすべてを制御します）。
これは、`#[inline]`と`#[inline(always)]`を慎重に使用する必要がある理由の1つで、動的指名を使用する理由の1つがより効率的な理由の1つです。

しかし、一般的なケースは、静的指名を使用する方が効率的であり、動的指名を行う静的に指名された包み隠し用の機能を持つことができます。
このため、標準譜集は可能な場合は静的に指名しようとします。

## 動的指名

Rustは、「特性対象」と呼ばれる機能を通じて動的な指名を提供します。
`&Foo`や`Box<Foo>`などの特性対象は、指定された特性を実装する*任意の*型の値を格納する通常の値です。正確な型は実行時にしか知ることができません。

特性対象は、それを*キャスト*することによって特性を実現する具体的な型への指し手から得ることができる（例えば、`&x as &Foo`）又は（例えば、使用してそれを*強制型変換する* `&x`とる機能の引数として`&Foo`）。

これらの特性対象の強制型変換とキャストは、`&mut T`から`&mut Foo`、 `Box<T>`から`Box<Foo>` `&mut Foo`への指し手ーでも機能しますが、それはすべて現時点でのものです。
強制型変換とキャストは同じです。

この操作は、指し手の特定の型に関する製譜器の知識を「消去する」と見なすことができるため、特性対象は「型消去」と呼ばれることがあります。

上記の例に戻り、同じ特性を使用して、キャストによって特性対象を使用した動的指名を実行できます。

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

または強制型変換することによって。

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

trait対象をとる機能は、`Foo`を実装するそれぞれの型に特化していません。たった1つのコピーしか生成されませんが、常にそうであるとは限りません。
しかし、これは、より遅い仮想機能呼び出しを必要とし、インライン化および関連する最適化の発生を効果的に阻止することを犠牲にして行われます。

### なぜ指し手？　

Rustは多くのおまかせ言語と違って、自動的に指し手の後ろに物を置かないので、型のサイズが異なる可能性があります。
製譜時に値のサイズを知ることは、それを機能の引数として渡したり、山上でそれを移動したり、原に空間を割り当てて（割り当てを解除して）格納するなどの場合に重要です。

`Foo`場合、`String`（24バイト）または`u8`（1バイト）のほか、 `Foo`実装する可能性のある他の型（バイト数はまったくありません））。
値が指し手なしで格納されている場合、この最後の点が動作することを保証する方法はありません。これらの他の型は任意に大きくすることができるからです。

値を指し手の後ろに置くということは、trait対象を投げているときに値のサイズが関係なく、指し手自体のサイズだけであることを意味します。

### 式

特性の操作法は、従来「製譜器によって作成され、管理される」vtableと呼ばれる特別な機能指し手の記録票を介して特性対象上で呼び出すことができます。

特性対象はシンプルで複雑です。そのコア表現と配置はかなり単純ですが、中にはいくつかの誤りメッセージと驚くべき動作があります。

trait対象の実行時式を使って簡単に始めましょう。
`std::raw`役区には、[trait対象を含む][stdraw]複雑な組み込み型と同じ配置の構造体が含まれてい[ます][stdraw]。

```rust
# mod foo {
pub struct TraitObject {
    pub data: *mut (),
    pub vtable: *mut (),
}
# }
```

[stdraw]: ../../std/raw/struct.TraitObject.html

つまり、`&Foo`ような特性対象は、'data'指し手と 'vtable'指し手で構成されています。

データ指し手は、特性対象が記憶している（未知の型`T`）データを番地指定し、vテーブル指し手は`T`の`Foo`の実装に対応するvテーブル（「仮想操作法テーブル」）を指し示します。


vtableは基本的には機能指し手の構造体で、実装の各操作法の具体的な機械譜面を指しています。
`trait_object.method()`ような操作法呼び出しは、vtableから正しい指し手を取り出してからそれを動的に呼び出します。
例えば。

```rust,ignore
struct FooVtable {
    destructor: fn(*mut ()),
    size: usize,
    align: usize,
    method: fn(*const ()) -> String,
}

#// u8:
//  u8。

fn call_method_on_u8(x: *const ()) -> String {
#    // The compiler guarantees that this function is only called
#    // with `x` pointing to a u8.
    // 製譜器は、この機能は`x`がu8を指している場合にのみ呼び出されることを保証します。
    let byte: &u8 = unsafe { &*(x as *const u8) };

    byte.method()
}

static Foo_for_u8_vtable: FooVtable = FooVtable {
    destructor: /* compiler magic */,
    size: 1,
    align: 1,

#    // Cast to a function pointer:
    // 機能指し手にキャスト。
    method: call_method_on_u8 as fn(*const ()) -> String,
};


#// String:
// 文字列。

fn call_method_on_String(x: *const ()) -> String {
#    // The compiler guarantees that this function is only called
#    // with `x` pointing to a String.
    // 製譜器は、この機能は、`x`がStringを指している場合にのみ呼び出されることを保証します。
    let string: &String = unsafe { &*(x as *const String) };

    string.method()
}

static Foo_for_String_vtable: FooVtable = FooVtable {
    destructor: /* compiler magic */,
#    // Values for a 64-bit computer, halve them for 32-bit ones.
    //  64ビット計算機の場合は32ビットの値を半分にします。
    size: 24,
    align: 8,

    method: call_method_on_String as fn(*const ()) -> String,
};
```

`destructor`のvtableの型のすべての資源を後始末する機能への各vtableの地点での欄。のために`u8`それは簡単ですが、ために`String`、それは記憶を解放します。
これは、`Box<Foo>`ような特性対象を所有するために必要です。Byte `Box<Foo>`は、範囲外に出たときに`Box`割り当てと内部型の両方を後始末する必要があります。
`size`および`align`欄には、消去された型のサイズと整列要件が格納されます。

`Foo`を実装するいくつかの値があるとします。
`Foo`特性対象の明示的な構成と使用方法は少し違って見えるかもしれません（型の不一致は無視されます。とにかくすべての指し手です）。

```rust,ignore
let a: String = "foo".to_string();
let x: u8 = 1;

#// let b: &Foo = &a;
//  let b。＆Foo =＆a;
let b = TraitObject {
#    // Store the data:
    // データを保存する。
    data: &a,
#    // Store the methods:
    // 操作法を格納します。
    vtable: &Foo_for_String_vtable
};

#// let y: &Foo = x;
//  let y。＆Foo = x;
let y = TraitObject {
#    // Store the data:
    // データを保存する。
    data: &x,
#    // Store the methods:
    // 操作法を格納します。
    vtable: &Foo_for_u8_vtable
};

#// b.method();
//  b.method（）;
(b.vtable.method)(b.data);

#// y.method();
//  y.method（）;
(y.vtable.method)(y.data);
```

## 対象の安全

すべての特性を特性対象の作成に使用することはできません。
たとえば、ベクターは`Clone`実装しますが、trait対象を作成しようとすると、次のようになります。

```rust,ignore
let v = vec![1, 2, 3];
let o = &v as &Clone;
```

誤りが表示されます。

```text
error: cannot convert to a trait object because trait `core::clone::Clone` is not object-safe [E0038]
let o = &v as &Clone;
        ^~
note: the trait cannot require that `Self : Sized`
let o = &v as &Clone;
        ^~
```

誤りは、`Clone`は「対象化安全」ではないと言います。
対象化安全である特性のみを特性対象にすることができます。
これらの両方が真である場合、特性は対象化安全です。

* その特性はそれを必要としません`Self: Sized`
* すべての操作法は対象化安全です

だから、操作法を対象化安全にするには？　
各操作法は、`Self: Sized`または以下のすべてを必要とする必要があります。

* 型パラメータを持たない
* `Self`使用してはいけません

すごい！　
わかるように、これらの規則のほとんどすべてが`Self`について語ります。
良い直感は、「特殊な状況を除いて、あなたの特性の方法が`Self`使用する場合、それは対象化安全ではありません」。
