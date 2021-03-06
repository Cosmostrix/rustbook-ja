## 独自の命令によるカーゴの拡張

Cargoは、カーゴを変更することなく新しい下位命令で拡張できるように設計されています。
中の<ruby>二進譜<rt>バイナリ</rt></ruby>た場合`$PATH`命名された`cargo-something`、それは実行して、カーゴの下位命令であるかのように、それを実行することができ`cargo something`。
`cargo --list`を実行すると、このような独自の命令も表示されます。
使用することができること`cargo install`拡張機能を導入した後、同じようにそれらを実行する組み込みのカーゴ道具カーゴの設計の超便利な利点があります！　

## 概要

Cargoと[crates.io](https://crates.io)<ruby>譜面<rt>コード</rt></ruby>を共有する
 Rust生態系をさまざまな仕事に役立てる要素の一部です。
Rustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>は小さく安定していますが、言語とは異なるタイムラインで簡単に共有、使用、改善することができます。
[crates.io](https://crates.io)あなたに役立つ<ruby>譜面<rt>コード</rt></ruby>を共有することに恥ずかしがり屋
 ;
それは他の人にとっても有用である可能性が高いです！　
