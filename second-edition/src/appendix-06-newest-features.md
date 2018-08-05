# 付録F -最新の機能

この付録では、本の主要部分が完成して以来、安定したRustに追加されている機能について説明します。


## <ruby>欄<rt>フィールド</rt></ruby>初期化短縮

書き込むことによって、名前の<ruby>欄<rt>フィールド</rt></ruby>を持つデータ構造体（構造体、列挙型、労働組合）を初期化することができる`fieldname`の省略形として`fieldname: fieldname`。
これにより、重複の少ない初期化のコンパクトな構文が可能になります。

```rust
#[derive(Debug)]
struct Person {
    name: String,
    age: u8,
}

fn main() {
    let name = String::from("Peter");
    let age = 27;

#    // Using full syntax:
    // 完全な構文を使用する。
    let peter = Person { name: name, age: age };

    let name = String::from("Portia");
    let age = 27;

#    // Using field init shorthand:
    // <ruby>欄<rt>フィールド</rt></ruby>initの短縮形を使う。
    let portia = Person { name, age };

    println!("{:?}", portia);
}
```


## ループからの戻り

`loop`の使用法の1つは、<ruby>走脈<rt>スレッド</rt></ruby>がジョブを完了したかどうかを確認するなど、失敗する可能性のある操作を再試行することです。
ただし、その操作の結果を<ruby>譜面<rt>コード</rt></ruby>の残りの部分に渡す必要があるかもしれません。
ループを停止するために使用する`break`式に追加すると、ループが破損して戻されます。

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    assert_eq!(result, 20);
}
```

## `use`宣言の入れ子になったグループ

多くの異なる下位<ruby>役区<rt>モジュール</rt></ruby>を持つ複雑な<ruby>役区<rt>モジュール</rt></ruby>ツリーがあり、それぞれから複数の項目を<ruby>輸入<rt>インポート</rt></ruby>する必要がある場合は、同じ宣言ですべての<ruby>輸入<rt>インポート</rt></ruby>をグループ化して、<ruby>譜面<rt>コード</rt></ruby>をきれいにしてベース<ruby>役区<rt>モジュール</rt></ruby>の名前を繰り返さないようにすると便利です。

`use`宣言は、単純な<ruby>輸入<rt>インポート</rt></ruby>とglobの両方で、それらのケースであなたを助けるネストをサポートしています。
たとえば、このスニペットの<ruby>輸入<rt>インポート</rt></ruby>`bar`、 `Foo`、 `baz`および`Bar`すべての項目。

```rust
# #![allow(unused_imports, dead_code)]
#
# mod foo {
#     pub mod bar {
#         pub type Foo = ();
#     }
#     pub mod baz {
#         pub mod quux {
#             pub type Bar = ();
#         }
#     }
# }
#
use foo::{
    bar::{self, Foo},
    baz::{*, quux::Bar},
};
#
# fn main() {}
```

## 包括的範囲

以前は、範囲（`..`または`...`）が式として使用されたときに、それは`..`でなければならず、上限は除外され、パターンは`...`を使用しなければならず、これは上限を含み`...`。
今、`..=`は、式と範囲の両方の文脈で包括的な範囲の構文として受け入れられます。

```rust
fn main() {
    for i in 0 ..= 10 {
        match i {
            0 ..= 5 => println!("{}: low", i),
            6 ..= 10 => println!("{}: high", i),
            _ => println!("{}: out of range", i),
        }
    }
}
```

`...`構文はマッチでは受け入れられますが、式では受け入れられません。
`..=`好ましいはず`..=`。

## 128ビット整数

Rust 1.26.0は128ビット整数基本型を追加しました。

- `u128`。範囲が[0, 2^128 -1]ビット符号なし整数
- `i128`。範囲が[-(2^127), 2^127 -1]の128ビット符号付き整数

これらの基本型は、LLVMサポートを使用して効率的に実装されます。
これらは、128ビット整数をネイティブにサポートしない<ruby>基盤環境<rt>プラットフォーム</rt></ruby>でも利用でき、他の整数型と同様に使用できます。

これらの基本型は、特定の暗号<ruby>計算手続き<rt>アルゴリズム</rt></ruby>など、非常に大きな整数を効率的に使用する必要のある<ruby>計算手続き<rt>アルゴリズム</rt></ruby>に非常に役立ちます。
