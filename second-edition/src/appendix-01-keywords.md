## 付録A。予約語

以下のリストには、Rust言語による現在または将来の使用のために予約されている予約語が含まれています。
したがって、機能、変数、パラメータ、構造体<ruby>欄<rt>フィールド</rt></ruby>、<ruby>役区<rt>モジュール</rt></ruby>、<ruby>通い箱<rt>クレート</rt></ruby>、定数、マクロ、静的値、属性、型、<ruby>特性<rt>トレイト</rt></ruby>、または寿命の名前など、識別子として使用することはできません。

### 現在使用中の予約語

次の予約語は、現在説明されている機能を備えています。

* -、原始的な型を行う項目を含む特定の<ruby>特性<rt>トレイト</rt></ruby>を明確に、または内の項目の名前を変更し`use`して`extern crate`文
* `break` -すぐにループを終了する
* `const` -定数項目または定数生<ruby>指し手<rt>ポインタ</rt></ruby>を定義する
* `continue` -次のループの繰り返しに進む
* `crate` -マクロが定義されている<ruby>通い箱<rt>クレート</rt></ruby>を表す外部<ruby>通い箱<rt>クレート</rt></ruby>またはマクロ変数を結合する
* `else` -`if`および`if let`ためのフォールバック
* `enum` -`enum`定義する
* `extern` -外部の枠、機能、または変数を結合する
* `false` -真偽値false<ruby>直書き<rt>リテラル</rt></ruby>
* `fn` -機能または機能の<ruby>指し手<rt>ポインタ</rt></ruby>型を定義する
* `for` -iteratorの項目をループしたり、<ruby>特性<rt>トレイト</rt></ruby>を実装したり、より高いランクの寿命を指定することができます
* `if` -条件式の結果に基づく分岐
* `impl` -固有または<ruby>特性<rt>トレイト</rt></ruby>機能を実装する
* `in` -`for`ループ構文の一部
* `let` -変数を束縛する
* `loop` -無条件ループ
* `match` -値をパターンに一致させる
* `mod` -<ruby>役区<rt>モジュール</rt></ruby>を定義する
* `move` -<ruby>閉包<rt>クロージャー</rt></ruby>がすべての捕獲の所有権を取得するようにする
* `mut` -参照、生<ruby>指し手<rt>ポインタ</rt></ruby>、またはパターン束縛における変更可能性を示す
* `pub` -構造体<ruby>欄<rt>フィールド</rt></ruby>、`impl`<ruby>段落<rt>ブロック</rt></ruby>、または<ruby>役区<rt>モジュール</rt></ruby>の<ruby>公開<rt>パブリック</rt></ruby>な可視性を示します
* `ref`参照
* `return` -機能からの戻り値
* `Self` -<ruby>特性<rt>トレイト</rt></ruby>を実装する型の型<ruby>別名<rt>エイリアス</rt></ruby>
* `self`試験の主題または現在の<ruby>役区<rt>モジュール</rt></ruby>
* `static` -<ruby>算譜<rt>プログラム</rt></ruby>実行全体を持続させる大域変数または寿命
* `struct`定義する
* 現在の<ruby>役区<rt>モジュール</rt></ruby>の`super`親<ruby>役区<rt>モジュール</rt></ruby>
* `trait` -`trait`定義する
* `true` -真偽値true<ruby>直書き<rt>リテラル</rt></ruby>
* `type` -型の<ruby>別名<rt>エイリアス</rt></ruby>または関連する型を定義する
* `unsafe` -危険な<ruby>譜面<rt>コード</rt></ruby>、機能、<ruby>特性<rt>トレイト</rt></ruby>、実装を示す
* `use` -シンボルを<ruby>有効範囲<rt>スコープ</rt></ruby>に<ruby>輸入<rt>インポート</rt></ruby>する
* `where` -型を制約する節を示す
* `while` -式の結果に基づいて条件付きでループする

### 将来使用するために予約されている予約語

以下の予約語は機能を持ちませんが、将来の潜在的な使用のためにRustによって予約されています。

* `abstract`
* `alignof`
* `become`
* `box`
* `do`
* `final`
* `macro`
* `offsetof`
* `override`
* `priv`
* `proc`
* `pure`
* `sizeof`
* `typeof`
* `unsized`
* `virtual`
* `yield`
