# mdocs: Typst → HTML ビルド
#   make      … 変更があったページだけビルド
#   make -B   … 全ページを強制ビルド

TYPST := typst compile --features html --pretty --root .

# 目次の構造（トップ・フォルダページだけが依存する）
APPENDIX := appendix.yaml lib/appendix.typ

# どのページにも影響する共通ファイル（lib/appendix.typ は除く）
LIBS := $(filter-out lib/appendix.typ,$(wildcard lib/*.typ))
BIBS := $(wildcard src/bib/*)

# lib/appendix.typ の変数（files / folders）を空白区切りで取り出す
appendix = $(shell typst eval --root . '{import "/lib/appendix.typ": $(1); $(1).join(" ")}' | tr -d '"')

PAGES   := $(call appendix,files)
FOLDERS := $(call appendix,folders)

ifeq ($(strip $(PAGES)),)
  $(error Failed to read the page list from appendix.yaml)
endif

TOP_HTML    := docs/index.html
FOLDER_HTML := $(FOLDERS:%=docs/%/index.html)
PAGE_HTML   := $(PAGES:%=docs/%/index.html)

.PHONY: all
all: $(TOP_HTML) $(FOLDER_HTML) $(PAGE_HTML)

# トップページ
$(TOP_HTML): templates/top.typ $(APPENDIX) $(LIBS)
	@mkdir -p $(@D)
	$(TYPST) $< $@
	git add $@

# フォルダの目次ページ（$* には X が入る）
$(FOLDER_HTML): docs/%/index.html: templates/folder.typ $(APPENDIX) $(LIBS)
	@mkdir -p $(@D)
	$(TYPST) --input path=$* $< $@
	git add $@

# 各ドキュメント（$* には X/Y が入る）
$(PAGE_HTML): docs/%/index.html: src/%.typ templates/file.typ $(LIBS) $(BIBS)
	@mkdir -p $(@D)
	$(TYPST) --input path=$* templates/file.typ $@
	git add $@
