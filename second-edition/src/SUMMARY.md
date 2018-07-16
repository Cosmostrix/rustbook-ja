# Rust演譜言語

[Foreword](foreword.md) [Introduction](ch00-00-introduction.md)

## 入門

- [入門](ch01-00-getting-started.md)
    - [Installation](ch01-01-installation.md)
    - [こんにちは世界！　](ch01-02-hello-world.md)
    - [こんにちは、カーゴ！　](ch01-03-hello-cargo.md)

- [推測ゲームを演譜する](ch02-00-guessing-game-tutorial.md)

- [共通演譜の概念](ch03-00-common-programming-concepts.md)
    - [変数と変更可能性](ch03-01-variables-and-mutability.md)
    - [データ型](ch03-02-data-types.md)
    - [機能のしくみ](ch03-03-how-functions-work.md)
    - [Comments](ch03-04-comments.md)
    - [制御の流れ](ch03-05-control-flow.md)

- [所有権について](ch04-00-understanding-ownership.md)
    - [所有権とは何でしょうか？　](ch04-01-what-is-ownership.md)
    - [参照および借用](ch04-02-references-and-borrowing.md)
    - [Slices](ch04-03-slices.md)

- [構造体を使用した関連データの構造化](ch05-00-structs.md)
    - [構造体の定義と実例化](ch05-01-defining-structs.md)
    - [構造体を使用したサンプル算譜](ch05-02-example-structs.md)
    - [操作法の構文](ch05-03-method-syntax.md)

- [列挙型と模式照合](ch06-00-enums.md)
    - [列挙型の定義](ch06-01-defining-an-enum.md)
    - [`match`制御の流れ演算子](ch06-02-match.md)
    - [`if let`簡潔な制御の流れ](ch06-03-if-let.md)

## 基本Rustリテラシー

- [Modules](ch07-00-modules.md)
    - [`mod`とファイルシステム](ch07-01-mod-and-the-filesystem.md)
    - [`pub`可視性の制御](ch07-02-controlling-visibility-with-pub.md)
    - [異なる役区の名前を参照する](ch07-03-importing-names-with-use.md)

- [共通集まり](ch08-00-common-collections.md)
    - [Vectors](ch08-01-vectors.md)
    - [Strings](ch08-02-strings.md)
    - [ハッシュマップ](ch08-03-hash-maps.md)

- [誤り処理](ch09-00-error-handling.md)
    - [`panic!`回復不能な誤り](ch09-01-unrecoverable-errors-with-panic.md)
    - [`Result`回復可能な誤り](ch09-02-recoverable-errors-with-result.md)
    - [`panic!`か`panic!`](ch09-03-to-panic-or-not-to-panic.md)

- [一般的な型、特性、および寿命](ch10-00-generics.md)
    - [汎用データ型](ch10-01-syntax.md)
    - [特性。共有動作の定義](ch10-02-traits.md)
    - [寿命による参照の検証](ch10-03-lifetime-syntax.md)

- [Testing](ch11-00-testing.md)
    - [テストの作成](ch11-01-writing-tests.md)
    - [テストの実行](ch11-02-running-tests.md)
    - [試験機関](ch11-03-test-organization.md)

- [I / O企画。命令行算譜の構築](ch12-00-an-io-project.md)
    - [命令行引数の受け入れ](ch12-01-accepting-command-line-arguments.md)
    - [ファイルを読む](ch12-02-reading-a-file.md)
    - [役区性と誤り処理を改善するためのリファクタリング](ch12-03-improving-error-handling-and-modularity.md)
    - [テスト駆動開発による譜集の機能開発](ch12-04-testing-the-librarys-functionality.md)
    - [環境変数の操作](ch12-05-working-with-environment-variables.md)
    - [標準出力ではなく標準誤りへの誤りメッセージの書き込み](ch12-06-writing-to-stderr-instead-of-stdout.md)

## Rustの中で考える

- [機能言語の特徴。反復子と閉包](ch13-00-functional-features.md)
    - [閉包。環境を捕捉できる無名機能](ch13-01-closures.md)
    - [反復子を使用した一連の項目の処理](ch13-02-iterators.md)
    - [I / O企画の改善](ch13-03-improving-our-io-project.md)
    - [パフォーマンスの比較。ループと反復子](ch13-04-performance.md)

- [カーゴとCrates.ioの詳細](ch14-00-more-about-cargo.md)
    - [リリースプロファイルを使用した組み上げのカスタマイズ](ch14-01-release-profiles.md)
    - [通い箱をCrates.ioに公開する](ch14-02-publishing-to-crates-io.md)
    - [カーゴワークスペース](ch14-03-cargo-workspaces.md)
    - [Crates.ioから二進譜を導入して`cargo install`](ch14-04-installing-binaries.md)
    - [独自の命令によるカーゴの拡張](ch14-05-extending-cargo.md)

- [スマート指し手](ch15-00-smart-pointers.md)
    - [`Box<T>`は原上のデータを指しており、既知のサイズを持っています](ch15-01-box.md)
    - [`Deref` Traitは参照によるデータへのアクセスを可能にする](ch15-02-deref.md)
    - [`Drop`特性により後始末時に譜面が実行される](ch15-03-drop.md)
    - [`Rc<T>`、参照カウントされたスマート指し手](ch15-04-rc.md)
    - [`RefCell<T>`とInterior Mutability Pattern](ch15-05-interior-mutability.md)
    - [参照円環の作成と記憶リークは安全です](ch15-06-reference-cycles.md)

- [恐れのない並列実行](ch16-00-concurrency.md)
    - [Threads](ch16-01-threads.md)
    - [メッセージの受け渡し](ch16-02-message-passing.md)
    - [共有状態](ch16-03-shared-state.md)
    - [拡張可能同時実行性。 `Sync`と`Send`](ch16-04-extensible-concurrency-sync-and-send.md)

- [対象指向演譜のRustの特徴](ch17-00-oop.md)
    - [対象指向言語の特徴](ch17-01-what-is-oo.md)
    - [異なる型の値を許容する特性対象の使用](ch17-02-trait-objects.md)
    - [対象指向設計パターンの実装](ch17-03-oo-design-patterns.md)

## 高度な話題

- [パターンが値の構造に一致する](ch18-00-patterns.md)
    - [すべてのプレイスパターンを使用できます](ch18-01-all-the-places-for-patterns.md)
    - [Refutability。パターンが一致しないかどうか](ch18-02-refutability.md)
    - [すべてのパターン構文](ch18-03-pattern-syntax.md)

- [高度な機能](ch19-00-advanced-features.md)
    - [安全でないRust](ch19-01-unsafe-rust.md)
    - [高度な寿命](ch19-02-advanced-lifetimes.md)
    - [高度な特性](ch19-03-advanced-traits.md)
    - [高度な型](ch19-04-advanced-types.md)
    - [高度な機能と終了](ch19-05-advanced-functions-and-closures.md)

- [最終的な企画。マルチ走脈Webサーバーの構築](ch20-00-final-project-a-web-server.md)
    - [単一走脈Webサーバー](ch20-01-single-threaded.md)
    - [単一走脈サーバーをマルチ走脈サーバーにする](ch20-02-multithreaded.md)
    - [グレースフルシャットダウンと後始末](ch20-03-graceful-shutdown-and-cleanup.md)

- [Appendix](appendix-00.md)
    - [A -予約語](appendix-01-keywords.md)
    - [B -演算子と記号](appendix-02-operators.md)
    - [C -導出可能な特性](appendix-03-derivable-traits.md)
    - [D -マクロ](appendix-04-macros.md)
    - [E -翻訳](appendix-05-translation.md)
    - [F -最新の機能](appendix-06-newest-features.md)
    - [G -Rustはどのように作られ、"夜間のRust"](appendix-07-nightly-rust.md)
