## 注釈

すべての演譜師は、譜面を分かりやすくするために努力していますが、時には余分な説明が必要です。
このような場合、演譜師は製譜器が無視する原譜にメモや*注釈を*残しますが、原譜を読んでいる人は役に立つと思うかもしれません。

ここに簡単な注釈があります。

```rust
#// hello, world
// こんにちは世界
```

Rustでは、注釈は2つのスラッシュで始まり、行の終わりまで続きます。
単一行を越える注釈については、次のように各行に`//`を入れる必要があります。

```rust
#// So we’re doing something complicated here, long enough that we need
#// multiple lines of comments to do it! Whew! Hopefully, this comment will
#// explain what’s going on.
// だからここで何か複雑な作業をしています。それを行うには、複数の注釈行が必要です。すごい！　うまくいけば、この注釈は何が起こっているのかを説明します。
```

注釈は譜面を含む行の最後に置くこともできます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#//    let lucky_number = 7; // I’m feeling lucky today
    let lucky_number = 7; // 今日は運が良かった
}
```

しかし、この形式で使用されることがよくあります。注釈を付ける譜面の上の別の行に注釈が表示されます。

<span class="filename">ファイル名。src/main.rs</span>

```rust
fn main() {
#    // I’m feeling lucky today
    // 今日は運が良かった
    let lucky_number = 7;
}
```

Rustには別の種類の注釈、開発資料集注釈があります。これについては第14章で説明します。
