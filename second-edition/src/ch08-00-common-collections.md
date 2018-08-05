# 共通<ruby>集まり<rt>コレクション</rt></ruby>

Rustの標準<ruby>譜集<rt>ライブラリー</rt></ruby>には、*<ruby>集まり<rt>コレクション</rt></ruby>*と呼ばれる多数の非常に有用なデータ構造が含まれてい*ます*。
他のほとんどのデータ型は1つの特定の値を表しますが、<ruby>集まり<rt>コレクション</rt></ruby>には複数の値を含めることができます。
組み込みの配列型や組型とは異なり、これらの<ruby>集まり<rt>コレクション</rt></ruby>が指し示すデータは原に格納されるため、<ruby>製譜<rt>コンパイル</rt></ruby>時にデータの量を知る必要はなく、<ruby>算譜<rt>プログラム</rt></ruby>の実行に伴って拡大または縮小することができます。
各種類の<ruby>集まり<rt>コレクション</rt></ruby>には異なる機能とコストがあり、現在の状況に適したものを選択することは、時間の経過とともに発展する技能です。
この章では、Rust<ruby>算譜<rt>プログラム</rt></ruby>で頻繁に使用される3つの<ruby>集まり<rt>コレクション</rt></ruby>について説明します。

* *ベクトルを*使用すると、可変数の値を互いに隣に格納することができます。
* *<ruby>文字列<rt>ストリング</rt></ruby>*は*文字*の集合です。
   これまで`String`型について触れましたが、この章ではこれについて詳しく説明します。
* *ハッシュマップを*使用すると、値を特定のキーに関連付けることができます。
   これは、*マップ*と呼ばれるより一般的なデータ構造の特定の実装です。

標準<ruby>譜集<rt>ライブラリー</rt></ruby>が提供する他の種類の<ruby>集まり<rt>コレクション</rt></ruby>について[は、開発資料を][collections]参照してください。

[collections]: ../../std/collections/index.html

ベクトル、<ruby>文字列<rt>ストリング</rt></ruby>、ハッシュマップの作成と更新の方法と、それぞれの特殊なものを作成する方法について説明します。