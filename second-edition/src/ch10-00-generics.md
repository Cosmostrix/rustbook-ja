# 一般的な型、<ruby>特性<rt>トレイト</rt></ruby>、および寿命

すべての<ruby>演譜<rt>プログラミング</rt></ruby>言語には、概念の重複を効果的に処理する道具があります。
Rustでは、そのような道具の1つは*総称化*です。
Genericsは、具体的な型やその他のプロパティの抽象的なスタンドインです。
<ruby>譜面<rt>コード</rt></ruby>を書くときは、総称化の振る舞いや、<ruby>譜面<rt>コード</rt></ruby>を<ruby>製譜<rt>コンパイル</rt></ruby>して実行するときに何が起きるのかわからなくても、総称化の動作や他の総称化との関係を表現できます。

同じ<ruby>譜面<rt>コード</rt></ruby>を複数の具体的な値で実行するために、機能が未知の値を持つパラメータを取る方法と同様に、機能は、`i32`や`String`ような具体的な型ではなく、汎用型のパラメータを取ることができます。
実際には、第6章で`Option<T>`、第8章`Vec<T>`、 `HashMap<K, V>`、第9章`Result<T, E>`総称化を既に使用しています。
この章では、総称化で独自の型、機能、および<ruby>操作法<rt>メソッド</rt></ruby>を定義する方法について説明します。

まず、<ruby>譜面<rt>コード</rt></ruby>の重複を減らす機能を抽出する方法を見ていきます。
次に、同じ技法を使用して、パラメータの型だけが異なる2つの機能から汎用機能を作成します。
構造体と列挙型の定義で総称型を使用する方法についても説明します。

次に、*<ruby>特性<rt>トレイト</rt></ruby>*を使って行動を一般的な方法で定義する方法を学びます。
型を総称型と組み合わせることで、総称型を特定の振る舞いを持つ型だけに制限することができます。

最後に、*生存時間*、さまざまな総称化について議論します。これらの総称化は、<ruby>製譜器<rt>コンパイラー</rt></ruby>ーが参照の相互関係に関する情報を提供します。
Lifetimesでは、多くの状況で値を借用することができますが、<ruby>製譜器<rt>コンパイラー</rt></ruby>ーは参照が有効であることを確認することができます。

## 機能を抽出して複製を削除する

総称化の構文に入る前に、まず機能を抽出して総称型を含まない重複を削除する方法を見てみましょう。
次に、この技法を適用して汎用機能を抽出します。
機能に重複した<ruby>譜面<rt>コード</rt></ruby>を抽出するのと同じ方法で、総称化を使用できる重複した<ruby>譜面<rt>コード</rt></ruby>を認識し始めます。

リスト10-1に示すように、リスト内で最大の数を見つける短い<ruby>算譜<rt>プログラム</rt></ruby>を考えてみましょう。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let mut largest = number_list[0];

    for number in number_list {
        if number > largest {
            largest = number;
        }
    }

    println!("The largest number is {}", largest);
#  assert_eq!(largest, 100);
}
```

<span class="caption">リスト10-1。数字のリストの中で最大の数字を見つける譜面</span>

この<ruby>譜面<rt>コード</rt></ruby>は、変数`number_list`に整数のリストを格納し、リスト内の最初の数値を`largest`の変数に`number_list`します。
次に、リスト内のすべての数値を繰り返し処理し、現在の数値が`largest`値に格納されている数値よりも大きい場合は、その変数の数値を置き換えます。
ただし、現在の数値がこれまでに見た最大数値よりも小さい場合、変数は変更されず、<ruby>譜面<rt>コード</rt></ruby>はリストの次の数値に移動します。
リスト内のすべての数字を考慮した後、`largest`、この場合には100の最大の数を、保持する必要があります。

2つの異なる数値リストで最大の数値を見つけるには、リスト10-1の<ruby>譜面<rt>コード</rt></ruby>を複製し、<ruby>算譜<rt>プログラム</rt></ruby>の2つの異なる場所で同じ<ruby>論理<rt>ロジック</rt></ruby>を使用することができます（リスト10-2を参照）。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let mut largest = number_list[0];

    for number in number_list {
        if number > largest {
            largest = number;
        }
    }

    println!("The largest number is {}", largest);

    let number_list = vec![102, 34, 6000, 89, 54, 2, 43, 8];

    let mut largest = number_list[0];

    for number in number_list {
        if number > largest {
            largest = number;
        }
    }

    println!("The largest number is {}", largest);
}
```

<span class="caption">リスト10-2。 <em>2つ</em>の数字のリストで最大の数字を見つける譜面</span>

この<ruby>譜面<rt>コード</rt></ruby>は機能しますが、<ruby>譜面<rt>コード</rt></ruby>を複製するのは面倒で<ruby>誤り<rt>エラー</rt></ruby>が発生しやすいです。
<ruby>譜面<rt>コード</rt></ruby>を変更したいときは、複数の場所で<ruby>譜面<rt>コード</rt></ruby>を更新する必要があります。

この重複を排除するために、与えられた整数リストに作用する機能をパラメータで定義して抽象化を作成することができます。
この解決法は、<ruby>譜面<rt>コード</rt></ruby>をより明確にし、最も大きな数字を抽象的にリストするという概念を表現することができます。

リスト10-3で、名前の機能に最大数を見つけ<ruby>譜面<rt>コード</rt></ruby>抽出`largest`。
リスト10-1の<ruby>譜面<rt>コード</rt></ruby>とは異なり、この<ruby>算譜<rt>プログラム</rt></ruby>は特定の1つのリストで最大の番号を見つけることができますが、この<ruby>算譜<rt>プログラム</rt></ruby>は2つの異なるリストで最大の番号を見つけることができます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn largest(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest(&number_list);
    println!("The largest number is {}", result);
#    assert_eq!(result, 100);

    let number_list = vec![102, 34, 6000, 89, 54, 2, 43, 8];

    let result = largest(&number_list);
    println!("The largest number is {}", result);
#    assert_eq!(result, 6000);
}
```

<span class="caption">リスト10-3。2つのリストの中で最大の数を見つける抽象譜面</span>

`largest`機能には`list`というパラメータがあります。このパラメータは、機能に渡す`i32`値の具体的なスライスを表します。
その結果、機能を呼び出すと、渡された特定の値で<ruby>譜面<rt>コード</rt></ruby>が実行されます。

要約すると、リスト10-2の<ruby>譜面<rt>コード</rt></ruby>をリスト10-3に変更するために取った手順は次のとおりです。

1. 重複した<ruby>譜面<rt>コード</rt></ruby>を特定します。
2. 機能の本体に重複した<ruby>譜面<rt>コード</rt></ruby>を抽出し、その機能の型注釈にその<ruby>譜面<rt>コード</rt></ruby>の入力と戻り値を指定します。
3. 代わりに機能を呼び出すように、重複した<ruby>譜面<rt>コード</rt></ruby>の2つの<ruby>実例<rt>インスタンス</rt></ruby>を更新します。

次に、同じ手順を総称化で使用して、<ruby>譜面<rt>コード</rt></ruby>の重複をさまざまな方法で減らします。
機能本体が特定の値ではなく抽象`list`動作するのと同じように、総称化は抽象型で<ruby>譜面<rt>コード</rt></ruby>を操作できるようにします。

たとえば、`i32`値のスライスで最大の項目を検出する機能と、`char`値のスライスで最大の項目を検出する機能の2つの機能があります。
その重複をどのように排除しますか？　
確認してみましょう！　
