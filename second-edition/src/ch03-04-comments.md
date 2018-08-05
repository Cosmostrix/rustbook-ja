## <ruby>注釈<rt>コメント</rt></ruby>

すべての<ruby>演譜師<rt>プログラマー</rt></ruby>は、<ruby>譜面<rt>コード</rt></ruby>を分かりやすくするために努力していますが、時には余分な説明が必要です。
このような場合、<ruby>演譜師<rt>プログラマー</rt></ruby>は<ruby>製譜器<rt>コンパイラー</rt></ruby>が無視する原譜にメモや*<ruby>注釈<rt>コメント</rt></ruby>を*残しますが、原譜を読んでいる人は役に立つと思うかもしれません。

ここに簡単な<ruby>注釈<rt>コメント</rt></ruby>があります。

```rust
#// hello, world
// こんにちは世界
```

Rustでは、<ruby>注釈<rt>コメント</rt></ruby>は2つのスラッシュで始まり、行の終わりまで続きます。
単一行を越える<ruby>注釈<rt>コメント</rt></ruby>については、次のように各行に`//`を入れる必要があります。

```rust
#// So we’re doing something complicated here, long enough that we need
#// multiple lines of comments to do it! Whew! Hopefully, this comment will
#// explain what’s going on.
// だからここで何か複雑な作業をしています。それを行うには、複数の<ruby>注釈<rt>コメント</rt></ruby>行が必要です。すごい！　うまくいけば、この<ruby>注釈<rt>コメント</rt></ruby>は何が起こっているのかを説明します。
```

<ruby>注釈<rt>コメント</rt></ruby>は<ruby>譜面<rt>コード</rt></ruby>を含む行の最後に置くこともできます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#//    let lucky_number = 7; // I’m feeling lucky today
    let lucky_number = 7; // 今日は運が良かった
}
```

しかし、この形式で使用されることがよくあります。<ruby>注釈<rt>コメント</rt></ruby>を付ける<ruby>譜面<rt>コード</rt></ruby>の上の別の行に<ruby>注釈<rt>コメント</rt></ruby>が表示されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#    // I’m feeling lucky today
    // 今日は運が良かった
    let lucky_number = 7;
}
```

Rustには別の種類の<ruby>注釈<rt>コメント</rt></ruby>、開発資料集<ruby>注釈<rt>コメント</rt></ruby>があります。これについては第14章で説明します。
