% 構文索引

## 予約語 (Keywords)

* `as`: primitive casting。[Casting Between Types (`as`)]を参照。
* `break`: 繰り返し (loop) からの脱出。[Loops (Ending Iteration Early)]を参照。
* `const`: 項目を定数とする。[`const` と `static`]を参照。
* `continue`: 次の繰り返し (loop) の反復を続ける。[Loops (Ending Iteration Early)]を参照。
* `crate`: 外部のわく箱 (crate) を結ぶ。[Crates and Modules (Importing External Crates)]を参照。
* `else`: `if` および `if let` の失敗側。[`if`]、[`if let`]を参照。
* `enum`: 列挙体 (enumeration) を定義する。[Enums]を参照。
* `extern`: 外部のわく箱 (crate)、機能 (function)、変数 (variable)を結ぶ。[Crates and Modules (Importing External Crates)]、[Foreign Function Interface]を参照。
* `false`: 真偽値 (boolean) の偽の表記。[Primitive Types (Booleans)]を参照。
* `fn`: 機能 (function) 定義および機能場指し型。[Functions]を参照。
* `for`: 反復子 (iterator) 繰り返し (loop) 、特性 `impl` 構文の一部、高階の寿命構文。[Loops (`for`)]、[Method Syntax]を参照。
* `if`: 条件分岐。[`if`]、[`if let`]を参照。
* `impl`: 継承と特性実装段落(trait impl block)。[Method Syntax]を参照。
* `in`: `for` 繰り返し (loop) 構文の一部。[Loops (`for`)]を参照。
* `let`: 変数束縛。[Variable Bindings]を参照。
* `loop`: unconditional、infinite loop。[Loops (`loop`)]を参照。
* `match`: pattern matching。[Match]を参照。
* `mod`: module declaration。[Crates and Modules (Defining Modules)]を参照。
* `move`: part of closure syntax。[Closures (`move` closures)]を参照。
* `mut`: denotes mutability in pointer types and pattern bindings。[Mutability]を参照。
* `pub`: denotes public visibility in `struct` fields、`impl` blocks、and modules。[Crates and Modules (Exporting a Public Interface)]を参照。
* `ref`: by-reference binding。[Patterns (`ref` and `ref mut`)]を参照。
* `return`: return from function。[Functions (Early Returns)]を参照。
* `Self`: implementor type alias。[Traits]を参照。
* `self`: method subject。[Method Syntax (Method Calls)]を参照。
* `static`: global variable。[`const` and `static` (`static`)]を参照。
* `struct`: structure definition。[Structs]を参照。
* `trait`: trait definition。[Traits]を参照。
* `true`: boolean true literal。[Primitive Types (Booleans)]を参照。
* `type`: type alias、and associated type definition。[`type` Aliases]、[Associated Types]を参照。
* `unsafe`: denotes unsafe code、functions、traits、and implementations。[Unsafe]を参照。
* `use`: import symbols into scope。[Crates and Modules (Importing Modules with `use`)]を参照。
* `where`: type constraint clauses。[Traits (`where` clause)]を参照。
* `while`: conditional loop。[Loops (`while`)]を参照。

## 演算子 (Operators) と 記号 (Symbols)

* `!` (`expr!(…)`, `expr!{…}`, `expr![…]`): denotes macro expansion。[Macros]を参照。
* `!` (`!expr`): bitwise or logical complement。 Overloadable (`Not`)。
* `%` (`expr % expr`): arithmetic remainder。 Overloadable (`Rem`)。
* `%=` (`var %= expr`): arithmetic remainder & assignment。
* `&` (`expr & expr`): bitwise and。 Overloadable (`BitAnd`)。
* `&` (`&expr`): borrow。[References and Borrowing]を参照。
* `&` (`&type`, `&mut type`, `&'a type`, `&'a mut type`): borrowed pointer type。[References and Borrowing]を参照。
* `&=` (`var &= expr`): bitwise and & assignment。
* `&&` (`expr && expr`): logical and。
* `*` (`expr * expr`): arithmetic multiplication。 Overloadable (`Mul`)。
* `*` (`*expr`): dereference。
* `*` (`*const type`, `*mut type`): raw pointer。[Raw Pointers]を参照。
* `*=` (`var *= expr`): arithmetic multiplication & assignment。
* `+` (`expr + expr`): arithmetic addition。 Overloadable (`Add`)。
* `+` (`trait + trait`, `'a + trait`): compound type constraint。[Traits (Multiple Trait Bounds)]を参照。
* `+=` (`var += expr`): arithmetic addition & assignment。
* `,`: argument and element separator。[Attributes]、[Functions]、[Structs]、[Generics]、[Match]、[Closures]、[Crates and Modules (Importing Modules with `use`)]を参照。
* `-` (`expr - expr`): arithmetic subtraction。 Overloadable (`Sub`)。
* `-` (`- expr`): arithmetic negation。 Overloadable (`Neg`)。
* `-=` (`var -= expr`): arithmetic subtraction & assignment。
* `->` (`fn(…) -> type`, `|…| -> type`): function and closure return type。[Functions]、[Closures]を参照。
* `-> !` (`fn(…) -> !`, `|…| -> !`): diverging function or closure。[Diverging Functions]を参照。
* `.` (`expr.ident`): member access。[Structs]、[Method Syntax]を参照。
* `..` (`..`, `expr..`, `..expr`, `expr..expr`): right-exclusive range literal。
* `..` (`..expr`): struct literal update syntax。[Structs (Update syntax)]を参照。
* `..` (`variant(x, ..)`, `struct_type { x, .. }`): "and the rest" pattern binding。[Patterns (Ignoring bindings)]を参照。
* `...` (`expr ... expr`): inclusive range pattern。[Patterns (Ranges)]を参照。
* `/` (`expr / expr`): arithmetic division。 Overloadable (`Div`)。
* `/=` (`var /= expr`): arithmetic division & assignment。
* `:` (`pat: type`, `ident: type`): constraints。[Variable Bindings]、[Functions]、[Structs]、[Traits]を参照。
* `:` (`ident: expr`): struct field initializer。[Structs]を参照。
* `:` (`'a: loop {…}`): loop label。[Loops (Loops Labels)]を参照。
* `;`: statement and item terminator。
* `;` (`[…; len]`): part of fixed-size array syntax。[Primitive Types (Arrays)]を参照。
* `<<` (`expr << expr`): left-shift。 Overloadable (`Shl`)。
* `<<=` (`var <<= expr`): left-shift & assignment。
* `<` (`expr < expr`): less-than comparison。 Overloadable (`Cmp`, `PartialCmp`)。
* `<=` (`var <= expr`): less-than or equal-to comparison。 Overloadable (`Cmp`, `PartialCmp`)。
* `=` (`var = expr`, `ident = type`): assignment/equivalence。[Variable Bindings]、[`type` Aliases]、generic parameter defaults。
* `==` (`var == expr`): comparison。 Overloadable (`Eq`, `PartialEq`)。
* `=>` (`pat => expr`): part of match arm syntax。[Match]を参照。
* `>` (`expr > expr`): greater-than comparison。 Overloadable (`Cmp`, `PartialCmp`)。
* `>=` (`var >= expr`): greater-than or equal-to comparison。 Overloadable (`Cmp`, `PartialCmp`)。
* `>>` (`expr >> expr`): right-shift。 Overloadable (`Shr`)。
* `>>=` (`var >>= expr`): right-shift & assignment。
* `@` (`ident @ pat`): pattern binding。[Patterns (Bindings)]を参照。
* `^` (`expr ^ expr`): bitwise exclusive or。 Overloadable (`BitXor`)。
* `^=` (`var ^= expr`): bitwise exclusive or & assignment。
* `|` (`expr | expr`): bitwise or。 Overloadable (`BitOr`)。
* `|` (`pat | pat`): pattern alternatives。[Patterns (Multiple patterns)]を参照。
* `|=` (`var |= expr`): bitwise or & assignment。
* `||` (`expr || expr`): logical or。
* `_`: "ignored" pattern binding。[Patterns (Ignoring bindings)]を参照。

## その他の構文

<!-- ## Other Syntax -->

<!-- Various bits of standalone stuff. -->

* `'ident`: named lifetime or loop label。[Lifetimes]、[Loops (Loops Labels)]を参照。
* `…u8`, `…i32`, `…f64`, `…usize`, …: numeric literal of specific type。
* `"…"`: string literal。[Strings]を参照。
* `r"…"`, `r#"…"#`, `r##"…"##`, …: raw string literal, escape characters are not processed。[Reference (Raw String Literals)]を参照。
* `b"…"`: byte string literal, constructs a `[u8]` instead of a string。[Reference (Byte String Literals)]を参照。
* `br"…"`, `br#"…"#`, `br##"…"##`, …: raw byte string literal, combination of raw and byte string literal。[Reference (Raw Byte String Literals)]を参照。
* `'…'`: character literal。[Primitive Types (`char`)]を参照。
* `b'…'`: ASCII byte literal。

<!-- Path-related syntax -->

* `ident::ident`: path。[Crates and Modules (Defining Modules)]を参照。
* `::path`: path relative to the crate root (*i.e.* an explicitly absolute path)。[Crates and Modules (Re-exporting with `pub use`)]を参照。
* `self::path`: path relative to the current module (*i.e.* an explicitly relative path)。[Crates and Modules (Re-exporting with `pub use`)]を参照。
* `super::path`: path relative to the parent of the current module。[Crates and Modules (Re-exporting with `pub use`)]を参照。
* `type::ident`: associated constants、functions、and types。[Associated Types]を参照。
* `<type>::…`: associated item for a type which cannot be directly named (*e.g.* `<&T>::…`, `<[T]>::…`, *etc.*)。[Associated Types]を参照。

<!-- Generics -->

* `path<…>` (*e.g.* `Vec<u8>`): specifies parameters to generic type *in a type*。[Generics]を参照。
* `path::<…>`, `method::<…>` (*e.g.* `"42".parse::<i32>()`): specifies parameters to generic type、function、or method *in an expression*.
* `fn ident<…> …`: define generic function。[Generics]を参照。
* `struct ident<…> …`: define generic structure。[Generics]を参照。
* `enum ident<…> …`: define generic enumeration。[Generics]を参照。
* `impl<…> …`: define generic implementation.
* `for<…> type`: higher-ranked lifetime bounds.
* `type<ident=type>` (*e.g.* `Iterator<Item=T>`): a generic type where one or more associated types have specific assignments。[Associated Types]を参照。

<!-- Constraints -->

* `T: U`: generic parameter `T` constrained to types that implement `U`。[Traits]を参照。
* `T: 'a`: generic type `T` must outlive lifetime `'a`.
* `'b: 'a`: generic lifetime `'b` must outlive lifetime `'a`.
* `T: ?Sized`: allow generic type parameter to be a dynamically-sized type。[Unsized Types (`?Sized`)]を参照。
* `'a + trait`, `trait + trait`: compound type constraint。[Traits (Multiple Trait Bounds)]を参照。

<!-- Macros and attributes -->

* `#[meta]`: outer attribute。[Attributes]を参照。
* `#![meta]`: inner attribute。[Attributes]を参照。
* `$ident`: macro substitution。[Macros]を参照。
* `$ident:kind`: macro capture。[Macros]を参照。
* `$(…)…`: macro repetition。[Macros]を参照。

<!-- Comments -->

* `//`: line comment。[Comments]を参照。
* `//!`: inner line doc comment。[Comments]を参照。
* `///`: outer line doc comment。[Comments]を参照。
* `/*…*/`: block comment。[Comments]を参照。
* `/*!…*/`: inner block doc comment。[Comments]を参照。
* `/**…*/`: outer block doc comment。[Comments]を参照。

<!-- Various things involving parens and tuples -->

* `()`: empty tuple (*a.k.a.* unit)、both literal and type.
* `(expr)`: parenthesized expression.
* `(expr,)`: single-element tuple expression。[Primitive Types (Tuples)]を参照。
* `(type,)`: single-element tuple type。[Primitive Types (Tuples)]を参照。
* `(expr, …)`: tuple expression。[Primitive Types (Tuples)]を参照。
* `(type, …)`: tuple type。[Primitive Types (Tuples)]を参照。
* `expr(expr, …)`: function call expression。Also used to initialize tuple `struct`s and tuple `enum` variants。[Functions]を参照。
* `ident!(…)`, `ident!{…}`, `ident![…]`: macro invocation。[Macros]を参照。
* `expr.0`, `expr.1`, …: tuple indexing。[Primitive Types (Tuple Indexing)]を参照。

<!-- Bracey things -->

* `{…}`: block expression.
* `Type {…}`: `struct` literal。[Structs]を参照。

<!-- Brackety things -->

* `[…]`: array literal。[Primitive Types (Arrays)]を参照。
* `[expr; len]`: array literal containing `len` copies of `expr`。[Primitive Types (Arrays)]を参照。
* `[type; len]`: array type containing `len` instances of `type`。[Primitive Types (Arrays)]を参照。

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
[Reference (Byte String Literals)]: ../reference.html#byte-string-literals
[Reference (Raw Byte String Literals)]: ../reference.html#raw-byte-string-literals
[Reference (Raw String Literals)]: ../reference.html#raw-string-literals
[References and Borrowing]: references-and-borrowing.html
[Strings]: strings.html
[Structs (Update syntax)]: structs.html#update-syntax
[Structs]: structs.html
[Traits (`where` clause)]: traits.html#where-clause
[Traits (Multiple Trait Bounds)]: traits.html#multiple-trait-bounds
[Traits]: traits.html
[Unsafe]: unsafe.html
[Unsized Types (`?Sized`)]: unsized-types.html#?sized
[Variable Bindings]: variable-bindings.html
