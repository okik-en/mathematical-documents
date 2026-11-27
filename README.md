# mdocs

## 必要なもの

- [Typst](https://typst.app/)（HTML 出力を使う）と GNU Make：ページのビルド
- [GitHub CLI（gh）](https://cli.github.com/)：clone に使う
- [uv](https://docs.astral.sh/uv/)：pre-commit の管理（`pyproject.toml`）
- [mise](https://mise.jdx.dev/)：Node の管理（`mise.toml`）。textlint を動かすのに使う
- フォント Noto Sans CJK JP と Noto Sans Math：プレビュー（PNG/PDF）用

## セットアップ

```sh
gh repo clone okik-en/mathematical-documents
cd mathematical-documents
uv sync                    # pre-commit を入れる
uv run pre-commit install  # コミット時にフックが動くようにする
mise install               # Node を入れる
mise exec -- npm ci        # textlint などを入れる
```

## ビルド

```sh
make
```

`src/**/*.typ` から `docs/**/index.html` を生成し、生成した HTML を `git add` する。ページの一覧は `appendix.yaml` で管理している。
ページを消したり名前を変えたりしても古い HTML は残るので、`git rm` で消す。

## コミット時のチェック（pre-commit）

`git commit` すると、`.pre-commit-config.yaml` の次のフックが動く。

| フック | 内容 |
|---|---|
| `uv-lock` | `uv.lock` が `pyproject.toml` と合っているか確認する |
| `build` | `make` で HTML をビルドする |
| `textlint` | ステージした `src/**/*.typ` の日本語をチェックする（下記） |

手動で全フックを動かすには `uv run pre-commit run --all-files`。

## 日本語の校閲（textlint）

コミット時に、ステージした `src/**/*.typ` を pre-commit が textlint でチェックする。手動で全ページをチェックするには次を実行する。

```sh
mise exec -- npm run lint                  # src/ 全体
mise exec -- npx textlint src/foo/bar.typ  # 1ファイルだけ
```

一時的にチェックを飛ばしてコミットするなら `SKIP=textlint git commit`。
設定は `.textlintrc.json`、Typst 向けの前処理（数式の置き換えなど）は `.textlint/typst-math/` にある。
