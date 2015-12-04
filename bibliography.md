% 参考文献

こちらは Rust に関係している読み物の一覧です。
Rust の〈デザイン〉に―― いつだったか ――影響を与えた先行調査と、Rust に関する刊行物があります。

<!--This is a reading list of material relevant to Rust. It includes prior
research that has - at one time or another - influenced the design of
Rust, as well as publications about Rust.-->

### 型体系

<!-- ### Type system -->

* [Region based memory management in Cyclone](http://209.68.42.137/ucsd-pages/Courses/cse227.w03/handouts/cyclone-regions.pdf)
* [Safe manual memory management in Cyclone](http://www.cs.umd.edu/projects/PL/cyclone/scp.pdf)
* [Typeclasses: making ad-hoc polymorphism less ad hoc](http://www.ps.uni-sb.de/courses/typen-ws99/class.ps.gz)
* [Macros that work together](https://www.cs.utah.edu/plt/publications/jfp12-draft-fcdf.pdf)
* [Traits: composable units of behavior](http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf)
* [Alias burying](http://www.cs.uwm.edu/faculty/boyland/papers/unique-preprint.ps) - 似たようなことを試してあきらめました
* [External uniqueness is unique enough](http://www.cs.uu.nl/research/techreps/UU-CS-2002-048.html)
* [Uniqueness and Reference Immutability for Safe Parallelism](https://research.microsoft.com/pubs/170528/msr-tr-2012-79.pdf)
* [Region Based Memory Management](http://www.cs.ucla.edu/~palsberg/tba/papers/tofte-talpin-iandc97.pdf)

### 並行性

<!-- ### Concurrency -->

* [Singularity: rethinking the software stack](https://research.microsoft.com/pubs/69431/osr2007_rethinkingsoftwarestack.pdf)
* [Language support for fast and reliable message passing in singularity OS](https://research.microsoft.com/pubs/67482/singsharp.pdf)
* [Scheduling multithreaded computations by work stealing](http://supertech.csail.mit.edu/papers/steal.pdf)
* [Thread scheduling for multiprogramming multiprocessors](http://www.eecis.udel.edu/%7Ecavazos/cisc879-spring2008/papers/arora98thread.pdf)
* [The data locality of work stealing](http://www.aladdin.cs.cmu.edu/papers/pdfs/y2000/locality_spaa00.pdf)
* [Dynamic circular work stealing deque](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.170.1097&rep=rep1&type=pdf) - Chase/Lev deque
* [Work-first and help-first scheduling policies for async-finish task parallelism](http://www.cs.rice.edu/%7Eyguo/pubs/PID824943.pdf) - 完全正格な作業横取り (work stealing) よりも一般化されている
* [A Java fork/join calamity](http://www.coopsoft.com/ar/CalamityArticle.html) - Java の fork/join 譜集への批判、特に作業横取りの非正格計算への応用
* [Scheduling techniques for concurrent systems](http://www.stanford.edu/~ouster/cgi-bin/papers/coscheduling.pdf)
* [Contention aware scheduling](http://www.blagodurov.net/files/a8-blagodurov.pdf)
* [Balanced work stealing for time-sharing multicores](http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-12-1.pdf)
* [Three layer cake for shared-memory programming](http://dl.acm.org/citation.cfm?id=1953616&dl=ACM&coll=DL&CFID=524387192&CFTOKEN=44362705)
* [Non-blocking steal-half work queues](http://www.cs.bgu.ac.il/%7Ehendlerd/papers/p280-hendler.pdf)
* [Reagents: expressing and composing fine-grained concurrency](http://www.mpi-sws.org/~turon/reagents.pdf)
* [Algorithms for scalable synchronization of shared-memory multiprocessors](https://www.cs.rochester.edu/u/scott/papers/1991_TOCS_synch.pdf)
* [Epoc-based reclamation](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-579.pdf).

### その他

<!-- ### Others -->

* [Crash-only software](https://www.usenix.org/legacy/events/hotos03/tech/full_papers/candea/candea.pdf)
* [Composing High-Performance Memory Allocators](http://people.cs.umass.edu/~emery/pubs/berger-pldi2001.pdf)
* [Reconsidering Custom Memory Allocation](http://people.cs.umass.edu/~emery/pubs/berger-oopsla2002.pdf)

### Rust *を* 扱った論文

<!-- ### Papers *about* Rust -->

* [GPU Programming in Rust: Implementing High Level Abstractions in a
Systems Level
Language](http://www.cs.indiana.edu/~eholk/papers/hips2013.pdf). Eric Holk による初期の GPU の仕事。
* [Parallel closures: a new twist on an old
  idea](https://www.usenix.org/conference/hotpar12/parallel-closures-new-twist-old-idea)
  - 厳密に rust のことではないけれど nmatsakis によるもの
* [Patina: A Formalization of the Rust Programming
  Language](ftp://ftp.cs.washington.edu/tr/2015/03/UW-CSE-15-03-02.pdf). 型体系の部分集合の初期の定式化で、Eric Reed による。
* [Experience Report: Developing the Servo Web Browser Engine using
  Rust](http://arxiv.org/abs/1505.07383). Lars Bergstrom 作。
* [Implementing a Generic Radix Trie in
  Rust](https://michaelsproul.github.io/rust_radix_paper/rust-radix-sproul.pdf). Michael Sproul の学部論文。
* [Reenix: Implementing a Unix-Like Operating System in
  Rust](http://scialex.github.io/reenix.pdf). Alex Light の学部論文。
* [Evaluation of performance and productivity metrics of potential
  programming languages in the HPC environment]
  (http://octarineparrot.com/assets/mrfloya-thesis-ba.pdf).
  Florian Wilkens の学士論文。C・Go・Rust の比較。
* [Nom, a byte oriented, streaming, zero copy, parser combinators library
  in Rust](http://spw15.langsec.org/papers/couprie-nom.pdf). Geoffroy Couprie による、VLC のための研究。
* [Graph-Based Higher-Order Intermediate
  Representation](http://compilers.cs.uni-saarland.de/papers/lkh15_cgo.pdf). Rust 風の言語 Impala を使った実験的 IR 実装。
* [Code Refinement of Stencil
  Codes](http://compilers.cs.uni-saarland.de/papers/ppl14_web.pdf). Impala を使った別の論文。
* [Parallelization in Rust with fork-join and
  friends](http://publications.lib.chalmers.se/records/fulltext/219016/219016.pdf). Linus
  Farnstrand の修士論文。
* [Session Types for
  Rust](http://munksgaard.me/papers/laumann-munksgaard-larsen.pdf). Philip
  Munksgaard の修士論文。Servo のための研究。
* [Ownership is Theft: Experiences Building an Embedded OS in Rust - Amit Levy, et. al.](http://amitlevy.com/papers/tock-plos2015.pdf)
