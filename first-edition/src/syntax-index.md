# 構文索引

## 予約語

* `as`。原始的な型、または項目を含む特定の特性を曖昧さをなくします。
   [Casting Between Types (`as`)]、 [Universal Function Call Syntax (Angle-bracket Form)]、 [Associated Types]。
* `break`。ループから脱出します。
   [Loops (Ending Iteration Early)]参照してください。
* `const`。定数項目と定数ロー指し手。
   [`const` and `static`]、 [Raw Pointers]。
* `continue`。次のループの繰り返しに進みます。
   [Loops (Ending Iteration Early)]参照してください。
* `crate`。外部通い箱結合すること。
   [Crates and Modules (Importing External Crates)]参照してください。
* `else`。 `if`と`if let`フォールバック。
   [`if`]、 [`if let`]参照してください。
* `enum`。 `enum`定義します。
   [Enums]参照してください。
* `extern`。外部通い箱、機能、および可変結合すること。
   [Crates and Modules (Importing External Crates)] [Foreign Function Interface]参照してください。
* `false`。真偽値false直書き。
   [Primitive Types (Booleans)]参照してください。
* `fn`。機能定義と機能指し手の型。
   [Functions]参照してください。
* `for`。反復子ループ、特性の一部`impl`構文、および寿命の構文をより高ランクインしています。
   [Loops (`for`)]、 [Method Syntax]参照してください。
* `if`。条件付き分岐。
   [`if`]、 [`if let`]参照してください。
* `impl`。固有および特性導入段落。
   [Method Syntax]参照してください。
* `in`。一部の`for`ループ構文。
   [Loops (`for`)]参照してください。
* `let`。変数の束縛。
   「 [Variable Bindings] 」を参照してください。
* `loop`。無条件、無限ループ。
   [Loops (`loop`)]参照してください。
* `match`。模式照合。
   [Match]参照してください。
* `mod`。役区宣言。
   [Crates and Modules (Defining Modules)]参照してください。
* `move`。閉包構文の一部。
   [Closures (`move` closures)]参照してください。
* `mut`。指し手型とパターン束縛の変更可能性を示します。
   [Mutability]参照してください。
* `pub`。 `struct`欄、`impl`段落、および役区の公開可視性を示します。
   [Crates and Modules (Exporting a Public Interface)]参照してください。
* `ref`。by-reference束縛。
   [Patterns (`ref` and `ref mut`)]参照してください。
* `return`。機能からの戻り値。
   [Functions (Early Returns)]参照してください。
* `Self`。実装者型別名。
   [Traits]参照してください。
* `self`。操作法の対象。
   [Method Syntax (Method Calls)]参照してください。
* `static`。全体変数。
   [`const` and `static` (`static`)]参照してください。
* `struct`。構造体の定義。
   参照[Structs]。
* `trait`。特性の定義。
   [Traits]参照してください。
* `true`。真偽値true直書き。
   [Primitive Types (Booleans)]参照してください。
* `type`。別名、および関連する型定義。
   [`type` Aliases]、 [Associated Types]参照してください。
* `unsafe`。安全でない譜面、機能、特性、実装を示します。
   [Unsafe]参照してください。
* `use`。有効範囲にシンボルを輸入します。
   [Crates and Modules (Importing Modules with `use`)]参照してください。
* `where`。型制約節。
   [Traits (`where` clause)]参照してください。
* `while`。条件付きループ。
   [Loops (`while`)]参照してください。

## 演算子と記号

* `!`（ `ident!(…)`、 `ident!{…}`、 `ident![…]`）。マクロ展開を示します。
   [Macros]参照してください。
* `!`（ `!expr`）。ビットまたは論理の補数。
   多重定義可能（`Not`）。
* `!=`（ `var != expr`）。不一致比較。
   多重定義可能（`PartialEq`）。
* `%`（ `expr % expr`）。算術剰余。
   多重定義可能（`Rem`）。
* `%=`（ `var %= expr`）。算術剰余と代入。
   多重定義可能（`RemAssign`）。
* `&`（ `expr & expr`）。ビットごとにおよび。
   多重定義可能（`BitAnd`）。
* `&`（ `&expr`、 `&mut expr`）。借りてください。
   参照[References and Borrowing]参照してください。
* `&`（ `&type` `&mut type`、 `&'a type`、 `&'a mut type`）。借用指し手型。
   参照[References and Borrowing]参照してください。
* `&=`（ `var &= expr`）。ビット単位の＆代入。
   多重定義可能（`BitAndAssign`）。
* `&&`（ `expr && expr`）。論理と。
* `*`（ `expr * expr`）。算術乗算。
   多重定義可能（`Mul`）。
* `*`（ `*expr`）。逆参照。
* `*`（ `*const type`、 `*mut type`）。生指し手。
   [Raw Pointers]参照してください。
* `*=`（ `var *= expr`）。算術乗算と代入。
   多重定義可能（`MulAssign`）。
* `+`（ `expr + expr`）。算術加算。
   多重定義（`Add`）。
* `+`（ `trait + trait`、 `'a + trait`）。複合型制約。
   [Traits (Multiple Trait Bounds)]参照のこと。
* `+=`（ `var += expr`）。算術加算＆代入。
   多重定義可能（`AddAssign`）。
* `,`。引数と要素区切り文字。
   参照[Attributes]、 [Functions]、 [Structs]、 [Generics]、 [Match]、 [Closures]、 [Crates and Modules (Importing Modules with `use`)]。
* `-`（ `expr - expr`）。算術減算。
   多重定義可能（`Sub`）。
* `-`（ `- expr`）。算術否定。
   多重定義（`Neg`）。
* `-=`（ `var -= expr`）。算術引き算と代入。
   多重定義可能（`SubAssign`）。
* `->`（ `fn(…) -> type`、 `|…| -> type`）。機能と閉包の戻り値の型。
   [Functions]、 [Closures]参照してください。
* `.` （`expr.ident`）。要素アクセス。
   [Structs]、 [Method Syntax]参照してください。
* `..`（ `..`、 `expr..`、 `..expr`、 `expr..expr`）。右排他的範囲直書き。
* `..`（ `..` `..expr`）。struct直書きの更新構文。
   構造体[Structs (Update syntax)]参照してください。
* `..`（ `variant(x, ..)`、 `struct_type { x, .. }`）。 "残りの"パターン束縛。
   「 [Patterns (Ignoring bindings)] 」を参照してください。
* `...`（ `...expr`、 `expr...expr`） *を含む式*。包括的な範囲式。
   [Iterators]参照してください。
* `...`（ `expr...expr`） *を*含む*パターン*。包括的範囲パターン。
   [Patterns (Ranges)]参照してください。
* `/`（ `expr / expr`）。算術除算。
   多重定義可能（`Div`）。
* `/=`（ `var /= expr`）。算術除算と代入。
   多重定義可能（`DivAssign`）。
* `:`（ `pat: type`、 `ident: type`）。制約。
   参照[Variable Bindings]、 [Functions]、 [Structs]、 [Traits]。
* `:`（ `ident: expr`）。構造体欄初期化子。
   参照[Structs]。
* `:` `'a: loop {…}`）。ループラベル。
   [Loops (Loops Labels)]参照してください。
* `;` 。文と項目ターミネータ。
* `;` （`[…; len]`）。固定長配列構文の一部。
   [Primitive Types (Arrays)]参照してください。
* `<<`（ `expr << expr`）。左シフト。
   多重定義可能（`Shl`）。
* `<<=`（ `var <<= expr`）。左シフト＆代入。
   多重定義可能（`ShlAssign`）。
* `<`（ `expr < expr`）。より小さい比較。
   多重定義可能（`PartialOrd`）。
* `<=`（ `var <= expr`）。より小さいか等しい比較。
   多重定義可能（`PartialOrd`）。
* `=`（ `var = expr`、 `ident = type`）。代入/等価。
   [Variable Bindings]、 [`type` Aliases]、総称化パラメータの黙用を参照してください。
* `==`（ `var == expr`）。等価比較。
   多重定義可能（`PartialEq`）。
* `=>`（ `pat => expr`）。マッチアーム構文の一部。
   [Match]参照してください。
* `>`（ `expr > expr`）。より大きい比較。
   多重定義可能（`PartialOrd`）。
* `>=`（ `var >= expr`）。より大きいか等しい比較。
   多重定義可能（`PartialOrd`）。
* `>>`（ `expr >> expr`）。右シフト。
   多重定義可能（`Shr`）。
* `>>=`（ `var >>= expr`）。右シフト＆代入。
   多重定義可能（`ShrAssign`）。
* `@`（ `ident @ pat`）。パターン束縛。
   「 [Patterns (Bindings)] 」を参照してください。
* `^`（ `expr ^ expr`）。排他的ビットまたはビット。
   多重定義可能（`BitXor`）。
* `^=`（ `var ^= expr`）。排他的論理和または代入。
   多重定義可能（`BitXorAssign`）。
* `|` （`expr | expr`）。ビット単位または。
   多重定義可能（`BitOr`）。
* `|` （`pat | pat`）。パターンの選択肢。
   [Patterns (Multiple patterns)]参照してください。
* `|` （`|…| expr`）。閉包。
   [Closures]参照してください。
* `|=`（ `var |= expr`）。ビット単位または＆assignment。
   多重定義可能（`BitOrAssign`）。
* `||` （`expr || expr`）。論理または。
* `_`。パターン束縛を[Patterns (Ignoring bindings)]参照）。
   整数直書きを読みやすくするためにも使われます（参照[Reference (Integer literals)]を[Reference (Integer literals)]）。
* `?` （`expr?`）。誤り伝搬。
   `Err(_)`に遭遇したときに早期に戻り、それ以外の場合ははがしします。
   [`try!` macro]似ています。

## その他の構文


* `'ident`。命名された寿命またはループラベル。
   [Lifetimes]、 [Loops (Loops Labels)]参照してください。
* `…u8`、 `…i32`、 `…f64`、 `…usize`、...。特定の型の数値直書き。
* `"…"`。文字列直書き。
   [Strings]参照してください。
* `r"…"`、 `r#"…"#`、 `r##"…"##`、...。生の文字列直書き、エスケープ文字は処理されません。
   「 [Reference (Raw String Literals)] 」を参照してください。
* `b"…"`。バイト文字列直書きで、文字列ではなく`[u8]`を構成します。
   「 [Reference (Byte String Literals)] 」を参照してください。
* `br"…"`、 `br#"…"#`、 `br##"…"##`、...。生のバイト文字列直書き、生文字列とバイト文字列直書きの組み合わせ。
   「 [Reference (Raw Byte String Literals)] 」を参照してください。
* `'…'`。文字直書き。
   [Primitive Types (`char`)]参照してください。
* `b'…'`。ASCIIバイトの直書き。
* `|…| expr` `|…| expr`。閉包。
   [Closures]参照してください。


* `ident::ident`。パス。
   [Crates and Modules (Defining Modules)]参照してください。
* `::path`。通い箱ルートに対する相対パス（ *つまり*、明示的な絶対パス）。
   [Crates and Modules (Re-exporting with `pub use`)]参照してください[Crates and Modules (Re-exporting with `pub use`)]。
* `self::path`。現在の役区（ *つまり、*明示的に相対パス）への相対パス。
   [Crates and Modules (Re-exporting with `pub use`)]参照してください[Crates and Modules (Re-exporting with `pub use`)]。
* `super::path`。現在の役区の親に対する相対パス。
   [Crates and Modules (Re-exporting with `pub use`)]参照してください[Crates and Modules (Re-exporting with `pub use`)]。
* `type::ident`、 `<type as trait>::ident`。関連する定数、機能、および型。
   関連[Associated Types]参照してください。
* `<type>::…`。直接指定できない型（ *例。* `<&T>::…`、 `<[T]>::…` *など*）に関連付けられた項目。
   関連[Associated Types]参照してください。
* `trait::method(…)`。操作法呼び出しを定義する特性に名前を付けることによって、操作法呼び出しをあいまいにします。
   [Universal Function Call Syntax]参照してください。
* `type::method(…)`。定義されている型の名前を指定して操作法呼び出しの曖昧さを解消します。
   [Universal Function Call Syntax]参照してください。
* `<type as trait>::method(…)`。特性 _と_ 型を命名して操作法呼び出しの曖昧さを解消します。
   [Universal Function Call Syntax (Angle-bracket Form)]参照してください。


* `path<…>` *例えば* `Vec<u8>` *型に*総称型のパラメータを指定します。
   [Generics]参照してください。
* `path::<…>` `method::<…>` *例。* `"42".parse::<i32>()`総称型、機能、または*式の*操作法にパラメータを指定します。
   [総称化曖昧さの解消を](generics.html#resolving-ambiguities)参照してください。
* `fn ident<…> …`。汎用機能を定義します。
   [Generics]参照してください。
* `struct ident<…> …`。総称化構造を定義します。
   [Generics]参照してください。
* `enum ident<…> …`。一般的な列挙を定義します。
   [Generics]参照してください。
* `impl<…> …`。汎用実装を定義します。
* `for<…> type`。より高いランクの寿命限界。
* `type<ident=type>`（ *例えば、* `Iterator<Item=T>`）。1つ以上の関連型が特定の割り当てを持つ総称型。
   関連[Associated Types]参照してください。


* `T: U`。汎用パラメータ`T`、 `U`を実装する型に制約されます。
   [Traits]参照してください。
* `T: 'a`。総称型`T`は生き延びていなければならない`'a`。
   型が寿命よりも長く続くと言うとき、それは`'a`よりも寿命の短い参照を一時的に含むことができないということを意味します。
* `T : 'static`。総称型`T`は、`'static`なもの以外`'static`借用参照はありません。
* `'b: 'a`。一般的な寿命`'b`寿命を生き延びなければならない`'a`。
* `T: ?Sized`。総称型パラメータを動的サイズの型にすることができます。
   [Unsized Types (`?Sized`)]参照してください。
* `'a + trait`、 `trait + trait`。複合型制約。
   [Traits (Multiple Trait Bounds)]参照のこと。


* `#[meta]`。外部属性。
   [Attributes]参照してください。
* `#![meta]`。内部属性。
   [Attributes]参照してください。
* `$ident`。マクロ置換。
   [Macros]参照してください。
* `$ident:kind`。マクロ捕獲。
   [Macros]参照してください。
* `$(…)…`。マクロの繰り返し。
   [Macros]参照してください。


* `//`。行コメント。
   [Comments]参照して[Comments]。
* `//!`内部の開発資料のコメントです。
   [Comments]参照して[Comments]。
* `///`。外線文書コメント。
   [Comments]参照して[Comments]。
* `/*…*/`。コメントを段落します。
   [Comments]参照して[Comments]。
* `/*!…*/`。内部段落の開発資料コメント。
   [Comments]参照して[Comments]。
* `/**…*/`。外部段落のdocコメント。
   [Comments]参照して[Comments]。


* `!`。常に空です。入力しないでください。
   [Diverging Functions]参照してください。


* `()`。直書きと型の両方の空の組（ *別名*単位）。
* `(expr)`。かっこ式。
* `(expr,)`。単一要素組式。
   [Primitive Types (Tuples)]参照してください。
* `(type,)`。単一要素組型。
   [Primitive Types (Tuples)]参照してください。
* `(expr, …)`。組式。
   [Primitive Types (Tuples)]参照してください。
* `(type, …)`。組型。
   [Primitive Types (Tuples)]参照してください。
* `expr(expr, …)`。機能呼び出し式。
   また、組`struct`と組`enum`型を初期化するためにも使用されます。
   [Functions]参照してください。
* `ident!(…)`、 `ident!{…}`、 `ident![…]`。マクロ呼び出し。
   [Macros]参照してください。
* `expr.0`、 `expr.1`、...。組の索引付け。
   [Primitive Types (Tuple Indexing)]参照してください。


* `{…}`。段落式。
* `Type {…}`。 `struct`直書き。
   参照[Structs]。


* `[…]`。配列直書き。
   [Primitive Types (Arrays)]参照してください。
* `[expr; len]` `[expr; len]`。 `expr` `len`コピーを含む配列直書き。
   [Primitive Types (Arrays)]参照してください。
* `[type; len]` `[type; len]`。型の`len`実例を含む配列`type`。
   [Primitive Types (Arrays)]参照してください。
* `expr[expr]`。集まりの索引付け。
   多重定義可能（`Index`、 `IndexMut`）。
* `expr[..]` `expr[a..]` `expr[..b]` `expr[a..b]`集まり・索引が使用して、集まりのスライスのふり`Range`、 `RangeFrom`、 `RangeTo`、 `RangeFull` "指標"として。

[`const` and `static` (`static`)]: const-and-static.html#static
 [`const` and `static`]: const-and-static.html
 [`if let`]: if-let.html
 [`if`]: if.html
 [`type` Aliases]: type-aliases.html
 [Associated Types]: associated-types.html
 [Attributes]: attributes.html
 [Casting Between Types (`as`)]: casting-between-types.html#as
 [Closures (`move` closures)]: closures.html#move-closures
 [Closures]: closures.html
 [Comments]: comments.html
 [Crates and Modules (Defining Modules)]: crates-and-modules.html#defining-modules
 [Crates and Modules (Exporting a Public Interface)]: crates-and-modules.html#exporting-a-public-interface
 [Crates and Modules (Importing External Crates)]: crates-and-modules.html#importing-external-crates
 [Crates and Modules (Importing Modules with `use`)]: crates-and-modules.html#importing-modules-with-use
 [Crates and Modules (Re-exporting with `pub use`)]: crates-and-modules.html#re-exporting-with-pub-use
 [Diverging Functions]: functions.html#diverging-functions
 [Enums]: enums.html
 [Foreign Function Interface]: ffi.html
 [Functions (Early Returns)]: functions.html#early-returns
 [Functions]: functions.html
 [Generics]: generics.html
 [Iterators]: iterators.html
 [`try!` macro]: error-handling.html#the-try-macro
 [Lifetimes]: lifetimes.html
 [Loops (`for`)]: loops.html#for
 [Loops (`loop`)]: loops.html#loop
 [Loops (`while`)]: loops.html#while
 [Loops (Ending Iteration Early)]: loops.html#ending-iteration-early
 [Loops (Loops Labels)]: loops.html#loop-labels
 [Macros]: macros.html
 [Match]: match.html
 [Method Syntax (Method Calls)]: method-syntax.html#method-calls
 [Method Syntax]: method-syntax.html
 [Mutability]: mutability.html
 [Operators and Overloading]: operators-and-overloading.html
 [Patterns (`ref` and `ref mut`)]: patterns.html#ref-and-ref-mut
 [Patterns (Bindings)]: patterns.html#bindings
 [Patterns (Ignoring bindings)]: patterns.html#ignoring-bindings
 [Patterns (Multiple patterns)]: patterns.html#multiple-patterns
 [Patterns (Ranges)]: patterns.html#ranges
 [Primitive Types (`char`)]: primitive-types.html#char
 [Primitive Types (Arrays)]: primitive-types.html#arrays
 [Primitive Types (Booleans)]: primitive-types.html#booleans
 [Primitive Types (Tuple Indexing)]: primitive-types.html#tuple-indexing
 [Primitive Types (Tuples)]: primitive-types.html#tuples

[Raw Pointers]: raw-pointers.html
 [Reference (Byte String Literals)]: ../../reference/tokens.html#byte-and-byte-string-literals
 [Reference (Integer literals)]: ../../reference/tokens.html#integer-literals
 [Reference (Raw Byte String Literals)]: ../../reference/tokens.html#raw-byte-string-literals
 [Reference (Raw String Literals)]: ../../reference/tokens.html#raw-string-literals
 [References and Borrowing]: references-and-borrowing.html
 [Strings]: strings.html
 [Structs (Update syntax)]: structs.html#update-syntax
 [Structs]: structs.html
 [Traits (`where` clause)]: traits.html#where-clause
 [Traits (Multiple Trait Bounds)]: traits.html#multiple-trait-bounds
 [Traits]: traits.html
 [Universal Function Call Syntax]: ufcs.html
 [Universal Function Call Syntax (Angle-bracket Form)]: ufcs.html#angle-bracket-form
 [Unsafe]: unsafe.html
 [Unsized Types (`?Sized`)]: unsized-types.html#sized
 [Variable Bindings]: variable-bindings.html

