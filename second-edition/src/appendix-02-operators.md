## 付録B。演算子と記号

この付録には、Rustの構文の用語集が含まれています。演算子や、パス、総称化、特性縛り、マクロ、属性、注釈、組、角かっこの文脈で表示されるその他のシンボルも含まれます。

### 演算子

表B-1に、Rustの演算子を示します。ここでは、演算子が文脈でどのように表示されるか、簡単な説明、およびその演算子が多重定義可能かどうかを示しています。
演算子が多重定義になると、その演算子を多重定義にするために使用する関連特性がリストされます。

<span class="caption">表B-1。演算子</span>

|<!--Operator-->演算子|<!--Example-->例|<!--Explanation-->説明|<!--Overloadable?-->多重定義？　|
|----------|---------|-------------|---------------|
|`!`|<!--`ident!(...)`, `ident!{...}`, `ident![...]`-->`ident!(...)`、 `ident!{...}`、 `ident![...]`|<!--Macro expansion-->マクロ展開| |
|`!`|`!expr`|<!--Bitwise or logical complement-->ビットまたは論理補数|`Not`|
|`!=`|`var != expr`|<!--Nonequality comparison-->満足度の比較|`PartialEq`|
|`%`|`expr % expr`|<!--Arithmetic remainder-->算術余剰|`Rem`|
|`%=`|`var %= expr`|<!--Arithmetic remainder and assignment-->算術剰余と代入|`RemAssign`|
|`&`|<!--`&expr`, `&mut expr`-->`&expr`、 `&mut expr`|<!--Borrow-->かりて| |
|`&`|<!--`&type`, `&mut type`, `&'a type`, `&'a mut type`-->`&type`、 `&mut type`、 `&'a type`、 `&'a mut type`|<!--Borrowed pointer type-->借用指し手型| |
|`&`|`expr & expr`|<!--Bitwise AND-->ビット単位AND|`BitAnd`|
|`&=`|`var &= expr`|<!--Bitwise AND and assignment-->ビット単位のANDと代入|`BitAndAssign`|
|`&&`|`expr && expr`|<!--Logical AND-->論理AND| |
|`*`|`expr * expr`|<!--Arithmetic multiplication-->算術乗算|`Mul`|
|`*=`|`var *= expr`|<!--Arithmetic multiplication and assignment-->算術乗算と代入|`MulAssign`|
|`*`|`*expr`|<!--Dereference-->相互参照| |
|`*`|<!--`*const type`, `*mut type`-->`*const type`、 `*mut type`|<!--Raw pointer-->生指し手| |
|`+`|<!--`trait + trait`, `'a + trait`-->`trait + trait`、 `'a + trait`|<!--Compound type constraint-->複合型制約| |
|`+`|`expr + expr`|<!--Arithmetic addition-->算術加算|`Add`|
|`+=`|`var += expr`|<!--Arithmetic addition and assignment-->算術加算と代入|`AddAssign`|
|`,`|`expr, expr`|<!--Argument and element separator-->引数と要素の区切り文字| |
|`-`|`- expr`|<!--Arithmetic negation-->算術否定|`Neg`|
|`-`|`expr - expr`|<!--Arithmetic subtraction-->算術減算|`Sub`|
|`-=`|`var -= expr`|<!--Arithmetic subtraction and assignment-->算術減算と代入|`SubAssign`|
|`->`|<!--`fn(...) -> type`, `\|...\| -> type`-->`fn(...) -> type`、 `\|...\| -> type``\|...\| -> type`|<!--Function and closure return type-->機能と閉包の戻り値の型| |
|`.`|`expr.ident`|<!--Member access-->要素アクセス| |
|`..`|<!--`..`, `expr..`, `..expr`, `expr..expr`-->`..`、 `expr..`、 `..expr`、 `expr..expr`|<!--Right-exclusive range literal-->右排他的直書き| |
|`..`|`..expr`|<!--Struct literal update syntax-->構造体直書きの更新構文| |
|`..`|<!--`場合値(x, ..)`, `struct_type { x, .. }`-->`場合値(x, ..)`、 `struct_type { x, .. }`|<!--“And the rest” pattern binding-->"そして残りの"パターン束縛| |
|`...`|`expr...expr`|<!--In a pattern: inclusive range pattern-->パターン。包含範囲パターン| |
|`/`|`expr/expr`|<!--Arithmetic division-->算術除算|`Div`|
|`/=`|`var /= expr`|<!--Arithmetic division and assignment-->算術除算と代入|`DivAssign`|
|`:`|<!--`pat: type`, `ident: type`-->`pat: type`、 `ident: type`|<!--Constraints-->制約| |
|`:`|`ident: expr`|<!--Struct field initializer-->構造体欄初期化子| |
|`:`|`'a: loop {...}`|<!--Loop label-->ループラベル| |
|`;`|`expr;`|<!--Statement and item terminator-->文と項目ターミネータ| |
|`;`|`[...; len]`|<!--Part of fixed-size array syntax-->固定サイズの配列構文の一部| |
|`<<`|`expr << expr`|<!--Left-shift-->左方移動|`Shl`|
|`<<=`|`var <<= expr`|<!--Left-shift and assignment-->左シフトと代入|`ShlAssign`|
|`<`|`expr < expr`|<!--Less than comparison-->比較よりも少ない|`PartialOrd`|
|`<=`|`expr <= expr`|<!--Less than or equal to comparison-->比較値以下|`PartialOrd`|
|`=`|<!--`var = expr`, `ident = type`-->`var = expr`、 `ident = type`|<!--Assignment/equivalence-->代入/等価| |
|`==`|`expr == expr`|<!--Equality comparison-->等価比較|`PartialEq`|
|`=>`|`pat => expr`|<!--Part of match arm syntax-->マッチアーム構文の一部| |
|`>`|`expr > expr`|<!--Greater than comparison-->比較以上|`PartialOrd`|
|`>=`|`expr >= expr`|<!--Greater than or equal to comparison-->比較以上|`PartialOrd`|
|`>>`|`expr >> expr`|<!--Right-shift-->右シフト|`Shr`|
|`>>=`|`var >>= expr`|<!--Right-shift and assignment-->右シフトと代入|`ShrAssign`|
|`@`|`ident @ pat`|<!--Pattern binding-->パターン束縛| |
|`^`|`expr ^ expr`|<!--Bitwise exclusive OR-->ビットごとの排他的論理和|`BitXor`|
|`^=`|`var ^= expr`|<!--Bitwise exclusive OR and assignment-->ビット単位の排他的論理和と代入|`BitXorAssign`|
|<code>\|</code>|`pat \| pat`|<!--Pattern alternatives-->パターンの選択肢| |
|<code>\|</code>|`expr \| expr`|<!--Bitwise OR-->ビット単位OR|`BitOr`|
|`\|=`|`var \|= expr`|<!--Bitwise OR and assignment-->ビット単位のORと代入|`BitOrAssign`|
|`\|\|`|`expr \|\| expr`|<!--Logical OR-->論理OR| |
|`?`|`expr?`|<!--Error propagation-->誤り伝播| |

### 演算子以外の記号

次のリストには、演算子として機能しないすべての非文字が含まれています。
つまり、機能呼び出しや操作法呼び出しのように動作しません。

表B-2に、さまざまな場所で有効なシンボルを示します。

<span class="caption">表B-2。スタンドアロン構文</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`'ident`|<!--Named lifetime or loop label-->名前付き有効期間またはループラベル|
|<!--`...u8`, `...i32`, `...f64`, `...usize`, etc.-->`...u8`、 `...i32`、 `...f64`、 `...usize`など|<!--Numeric literal of specific type-->特定の型の数値直書き|
|`"..."`|<!--String literal-->文字列直書き|
|<!--`r"..."`, `r#"..."#`, `r##"..."##`, etc.-->`r"..."`、 `r#"..."#`、 `r##"..."##`など。|<!--Raw string literal, escape characters not processed-->生の文字列直書き、エスケープ文字は処理されません|
|`b"..."`|<!--Byte string literal;-->バイト文字列直書き。<!--constructs a `[u8]` instead of a string-->文字列の代わりに`[u8]`を作成する|
|<!--`br"..."`, `br#"..."#`, `br##"..."##`, etc.-->`br"..."`、 `br#"..."#`、 `br##"..."##`など|<!--Raw byte string literal, combination of raw and byte string literal-->生のバイト文字列直書き、生文字列とバイト文字列直書きの組み合わせ|
|`'...'`|<!--Character literal-->文字直書き|
|`b'...'`|<!--ASCII byte literal-->ASCIIバイト直書き|
|`\|...\| expr`|<!--Closure-->閉包|
|`!`|<!--Always empty bottom type for diverging functions-->分岐機能のために常に空のボトム型|
|`_`|<!--“Ignored” pattern binding;-->"無視される"パターン束縛。<!--also used to make integer literals readable-->整数直書きを読みやすくするためにも使われます|

表B-3に、項目に対する役区階層を通るパスの文脈で表示されるシンボルを示します。

<span class="caption">表B-3。パス関連の構文</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`ident::ident`|<!--Namespace path-->名前空間のパス|
|`::path`|<!--Path relative to the crate root (ie, an explicitly absolute path)-->通い箱ルートに関連するパス（つまり、明示的な絶対パス）|
|
`self::path` |
現在の役区に対する相対的なパス（明示的な相対パス）。
|
`super::path` |
現在の役区の親に対する相対パス|
|
`type::ident`、 `<type as trait>::ident` |
関連する定数、機能、および型|
|
`<type>::...` |
`<&T>::...`、 `<[T]>::...`などのように直接名前を付けることができない型の関連項目。
|
`trait::method(...)` |
それを定義する特性に名前を付けて操作法呼び出しを曖昧さなくする|
|
`type::method(...)` |
それが定義されている型の名前を付けて操作法呼び出しの曖昧さを解消する|
|
`<type as trait>::method(...)` |
特性の名前をつけて型を呼んで操作法呼び出しの曖昧さを解消する|

表B-4に、総称化・型・パラメータを使用する文脈で表示されるシンボルを示します。

<span class="caption">表B-4。総称化</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`path<...>`|<!--Specifies parameters to generic type in a type (eg, `Vec<u8>`)-->型の総称型へのパラメータを指定します（例。 `Vec<u8>`）。|
|<!--`path::<...>`, `method::<...>`-->`path::<...>`、 `method::<...>`|<!--Specifies parameters to generic type, function, or method in an expression;-->式の総称型、機能、または操作法へのパラメータを指定します。<!--often referred to as turbofish (eg, `"42".parse::<i32>()`)-->しばしばターボフィッシュと呼ばれる（例えば、`"42".parse::<i32>()`）|
|`fn ident<...> ...`|<!--Define generic function-->総称化機能を定義する|
|`struct ident<...> ...`|<!--Define generic structure-->総称化構造を定義する|
|`enum ident<...> ...`|<!--Define generic enumeration-->総称化列挙を定義する|
|`impl<...> ...`|<!--Define generic implementation-->総称化実装を定義する|
|`for<...> type`|<!--Higher-ranked lifetime bounds-->より高いランクの寿命範囲|
|`type<ident=type>`|<!--A generic type where one or more associated types have specific assignments (eg, `Iterator<Item=T>`)-->1つ以上の関連型が特定の代入を持つ総称型（例。 `Iterator<Item=T>`）|

表B-5に、総称型のパラメータを特性縛りで制約する文脈で表示されるシンボルを示します。

<span class="caption">表B-5。特性に束縛された制約</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`T: U`|<!--Generic parameter `T` constrained to types that implement `U`-->`U`を実装する型に制約された汎用パラメータ`T`|
|`T: 'a`|<!--Generic type `T` must outlive lifetime `'a` (meaning the type cannot transitively contain any references with lifetimes shorter than `'a`)-->一般的な型`T`は寿命`'a`よりも寿命が長いものでなければならない（型は一時的に`'a`よりも寿命の短い参照を含むことができないことを意味`'a`）|
|`T : 'static`|<!--Generic type `T` contains no borrowed references other than `'static` ones-->一般的な型`T`は、`'static`なもの以外`'static`参照を借りていない|
|`'b: 'a`|<!--Generic lifetime `'b` must outlive lifetime `'a`-->一般的な寿命`'b`寿命より長生きしなければなりません`'a`|
|`T: ?Sized`|<!--Allow generic type parameter to be a dynamically sized type-->総称型パラメータを動的にサイズの変更できる型にする|
|<!--`'a + trait`, `trait + trait`-->`'a + trait`、 `trait + trait`|<!--Compound type constraint-->複合型制約|

表B-6に、マクロの呼び出しまたは定義、および項目の属性の指定の文脈で表示される記号を示します。

<span class="caption">表B-6。マクロと属性</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`#[meta]`|<!--Outer attribute-->外部属性|
|`#![meta]`|<!--Inner attribute-->内部属性|
|`$ident`|<!--Macro substitution-->マクロ置換|
|`$ident:kind`|<!--Macro capture-->マクロ捕獲|
|`$(…)…`|<!--Macro repetition-->マクロの繰り返し|

表B-7は、注釈を作成するシンボルを示しています。

<span class="caption">表B-7。注釈</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`//`|<!--Line comment-->行注釈|
|`//!`|<!--Inner line doc comment-->内部線の注釈|
|`///`|<!--Outer line doc comment-->外部行の開発資料注釈|
|`/*...*/`|<!--Block comment-->注釈を段落する|
|`/*!...*/`|<!--Inner block doc comment-->内部段落文書の注釈|
|`/**...*/`|<!--Outer block doc comment-->外部段落の開発資料の注釈|

表B-8に、組を使用する文脈で表示されるシンボルを示します。

<span class="caption">表B-8。組</span>

|<!--Symbol-->シンボル|<!--Explanation-->説明|
|--------|-------------|
|`()`|<!--Empty tuple (aka unit), both literal and type-->直書きと型の両方の空の組（別名ユニット）|
|`(expr)`|<!--Parenthesized expression-->カッコ内の式|
|`(expr,)`|<!--Single-element tuple expression-->単一要素組式|
|`(type,)`|<!--Single-element tuple type-->単一要素組型|
|`(expr, ...)`|<!--Tuple expression-->組式|
|`(type, ...)`|<!--Tuple type-->組型|
|`expr(expr, ...)`|<!--Function call expression;-->機能呼び出し式。<!--also used to initialize tuple `struct` s and tuple `enum` 場合値s-->組`struct`と組`enum`型の初期化にも使用されます|
|<!--`ident!(...)`, `ident!{...}`, `ident![...]`-->`ident!(...)`、 `ident!{...}`、 `ident![...]`|<!--Macro invocation-->マクロ呼び出し|
|<!--`expr.0`, `expr.1`, etc.-->`expr.0`、 `expr.1`など|<!--Tuple indexing-->組索引付け|

表B-9に、中かっこが使用されている文脈を示します。

<span class="caption">表B-9。波カッコ</span>

|<!--Context-->文脈|<!--Explanation-->説明|
|---------|-------------|
|`{...}`|<!--Block expression-->段落式|
|`Type {...}`|<!--`struct` literal-->`struct` literal|

表B-10に、角かっこを使用した文脈を示します。

<span class="caption">表B-10。角カッコ</span>

|<!--Context-->文脈|<!--Explanation-->説明|
|---------|-------------|
|`[...]`|<!--Array literal-->配列直書き|
|`[expr; len]`|<!--Array literal containing `len` copies of `expr`-->`expr` `len`コピーを含む配列直書き|
|`[type; len]`|<!--Array type containing `len` instances of `type`-->含む配列型`len`の実例`type`|
|`expr[expr]`|<!--Collection indexing.-->集まりの索引付け。<!--Overloadable (`Index`, `IndexMut`)-->多重定義可能（`Index`、 `IndexMut`）|
|<!--`expr[..]`, `expr[a..]`, `expr[..b]`, `expr[a..b]`-->`expr[..]`、 `expr[a..]`、 `expr[..b]`、 `expr[a..b]`|<!--Collection indexing pretending to be collection slicing, using `Range`, `RangeFrom`, `RangeTo`, or `RangeFull` as the “index”-->「添字」として`Range`、 `RangeFrom`、 `RangeTo`、または`RangeFull`を使用して、集まりのスライスを行う集まりの添字作成を行います。|
