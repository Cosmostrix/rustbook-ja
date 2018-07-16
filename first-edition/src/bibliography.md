# 参考文献

これは、Rustに関連する資料の読書リストです。
これには、過去にRustの設計に影響を与えた研究や、Rustの出版物が含まれています。

### 型システム

* [サイクロンでのリージョンベースの記憶管理](http://209.68.42.137/ucsd-pages/Courses/cse227.w03/handouts/cyclone-regions.pdf)
* [サイクロンでの安全な手動記憶管理](http://www.cs.umd.edu/projects/PL/cyclone/scp.pdf)
* [型抜き。アドホックな多形性をあまりアドホックにしない](http://www.ps.uni-sb.de/courses/typen-ws99/class.ps.gz)
* [一緒に動作するマクロ](https://www.cs.utah.edu/plt/publications/jfp12-draft-fcdf.pdf)
* [特性。構成可能な行動単位](http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf)
* [別名埋葬](http://www.cs.uwm.edu/faculty/boyland/papers/unique-preprint.ps) -同様のことを試み、それを放棄した。
* [外部の独自性は十分にユニークです](http://www.cs.uu.nl/research/techreps/UU-CS-2002-048.html)
* [安全な並列性のための一意性と参照不変性](https://research.microsoft.com/pubs/170528/msr-tr-2012-79.pdf)
* [地域ベースの記憶管理](http://www.cs.ucla.edu/~palsberg/tba/papers/tofte-talpin-iandc97.pdf)

### 並列実行

* [特異性。譜体山を再考する](https://research.microsoft.com/pubs/69431/osr2007_rethinkingsoftwarestack.pdf)
* [特殊性OSでの高速かつ信頼性の高いメッセージ転送のための言語サポート](https://research.microsoft.com/pubs/67482/singsharp.pdf)
* [ワークスチールによるマルチ走脈計算のスケジューリング](http://supertech.csail.mit.edu/papers/steal.pdf)
* [マルチプロセッサマルチ演譜のための走脈スケジューリング](http://www.eecis.udel.edu/%7Ecavazos/cisc879-spring2008/papers/arora98thread.pdf)
* [仕事の窃盗のデータローカリティ](http://www.aladdin.cs.cmu.edu/papers/pdfs/y2000/locality_spaa00.pdf)
* [動的サーキュラーワークのデッケージ](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.170.1097&rep=rep1&type=pdf) -The Chase / Lev deque
* [非同期仕上げ仕事並列処理のための作業優先と手引き初回スケジューリングポリシー](http://www.cs.rice.edu/%7Eyguo/pubs/PID824943.pdf) -完全に厳密な作業盗みよりも一般的です
* [Java fork / join災害](http://www.coopsoft.com/ar/CalamityArticle.html) -Javaのfork / join譜集の批判、特に厳密ではない計算への作業窃取の適用
* [並行システムのスケジューリング手法](http://www.stanford.edu/~ouster/cgi-bin/papers/coscheduling.pdf)
* [競合対応スケジューリング](http://www.blagodurov.net/files/a8-blagodurov.pdf)
* [時分割マルチコアのためのバランスのとれた作業の盗難](http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-12-1.pdf)
* [共有記憶演譜のための3層ケーキ](http://dl.acm.org/citation.cfm?id=1953616&dl=ACM&coll=DL&CFID=524387192&CFTOKEN=44362705)
* [ノンブロッキングのスチール・ハーフ・ワーク・キュー](http://www.cs.bgu.ac.il/%7Ehendlerd/papers/p280-hendler.pdf)
* [試薬。きめ細かな並列実行の式と構成](http://www.mpi-sws.org/~turon/reagents.pdf)
* [共有記憶マルチプロセッサのスケーラブルな同期のための計算手続き](https://www.cs.rochester.edu/u/scott/papers/1991_TOCS_synch.pdf)
* [エポックベースの再生](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-579.pdf)。

### その他

* [異常終了専用譜体](https://www.usenix.org/legacy/events/hotos03/tech/full_papers/candea/candea.pdf)
* [高性能記憶割当譜の作成](http://people.cs.umass.edu/~emery/pubs/berger-pldi2001.pdf)
* [独自の記憶割り当ての再考](http://people.cs.umass.edu/~emery/pubs/berger-oopsla2002.pdf)

### Rust*についての*論文

* [RustにおけるGPU演譜。システムレベル言語における高レベル抽象化の実装](http://www.cs.indiana.edu/~eholk/papers/hips2013.pdf)。
   Eric Holkによる初期のGPU作業。
* [パラレル閉包。古いアイデアの新しいひねり](https://www.usenix.org/conference/hotpar12/parallel-closures-new-twist-old-idea)
  - 厳密にはRustについてではなく、nmatsakisによって
* [Patina。Rust演譜言語の定式化](ftp://ftp.cs.washington.edu/tr/2015/03/UW-CSE-15-03-02.pdf)。
   Eric Reedによる型システムの下位セットの早期形式化。
* [体験レポート。Rustを使用したServo Webブラウザエンジンの開発](http://arxiv.org/abs/1505.07383)
   Lars Bergstrom
* [Rustにおける一般基数トライの実装](https://michaelsproul.github.io/rust_radix_paper/rust-radix-sproul.pdf)。
   Michael Sproulによる学位論文。
* [Reenix。RustにおけるUnixライクなオペレーティングシステムの実装](http://scialex.github.io/reenix.pdf)
   Alex LightのUndergrad紙。
* [HPC環境における潜在的演譜言語の性能および生産性メトリクスの評価](http://octarineparrot.com/assets/mrfloya-thesis-ba.pdf)。
   Florian Wilkensによる学士論文。
   C、Go、Rustを比較します。
* [Nom、Rustのバイト指向、ストリーミング、ゼロコピー、構文解析器ー組子譜集](http://spw15.langsec.org/papers/couprie-nom.pdf)
   Geoffroy Couprie、VLCの研究。
* [グラフベースの高次中間式](http://compilers.cs.uni-saarland.de/papers/lkh15_cgo.pdf)。
   Impalaで実装された実験的なIR、Rustのような言語。
* [ステンシル譜面の譜面リファイン](http://compilers.cs.uni-saarland.de/papers/ppl14_web.pdf)。
   インパラを使った別の論文。
* [フォークジョイントとフレンドによるRustの並列化](http://publications.lib.chalmers.se/records/fulltext/219016/219016.pdf)
   Linus Farnstrandの修士論文であます。
* [Rustのセッション型](http://munksgaard.me/papers/laumann-munksgaard-larsen.pdf)。
   フィリップ・ムンクスガードの卒業論文。
   サーボの研究。
* [所有権は盗難である。Rustの組み込みOS構築経験 -Amit Levy、et。](http://amitlevy.com/papers/tock-plos2015.pdf)
   [al。](http://amitlevy.com/papers/tock-plos2015.pdf)
* [Rustのない信頼を綴ることはできません](https://raw.githubusercontent.com/Gankro/thesis/master/thesis.pdf)。
   Alexis Beingessnerの修士論文。
* [高性能GC実装の​​ための言語としてのRust](http://users.cecs.anu.edu.au/~steveb/downloads/pdf/rust-ismm-2016.pdf)
