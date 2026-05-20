#!/bin/bash

# Resolve Typst
if [ -n "$LOCALAPPDATA" ]; then
  WINGET_TYPST_PATH=$(cygpath -u "$LOCALAPPDATA/Microsoft/WinGet/Packages/Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe/typst-x86_64-pc-windows-msvc")
  export PATH="$PATH:$WINGET_TYPST_PATH"
fi
export PATH="$PATH:/c/Program Files/Typst:/c/Program Files (x86)/Typst"

# Resolve Python
PYTHON=""
for cmd in python3 python; do
  path=$(command -v "$cmd" 2>/dev/null || true)
  if [ -n "$path" ] && ! echo "$path" | grep -qi "WindowsApps"; then
    PYTHON="$cmd"
    break
  fi
done

if [ -z "$PYTHON" ]; then
  if command -v py >/dev/null 2>&1; then
    PYTHON="py -3"
  elif [ -x "/c/Windows/py.exe" ]; then
    PYTHON="/c/Windows/py.exe -3"
  fi
fi

# Path
SOURCE_DIR="src"
PUBLIC_DIR="public"
OUT_DIR="docs"
APPENDIX_PATH="appendix.yaml"
STYLESHEET_PATH="docs/style.css"

# Clean output directory
echo "Cleaning output directory $OUT_DIR..."
rm -rf "$OUT_DIR"/*

# Create appendix
echo "Creating appendix file..."
$PYTHON tools/generate_appendix.py --source "$SOURCE_DIR" --out "$APPENDIX_PATH"

# Copy public files to output directory
echo "Copying public files from $PUBLIC_DIR to $OUT_DIR..."
cp -r "$PUBLIC_DIR"/* "$OUT_DIR"/

# Compile Typst documents in source directory to output directory
shopt -s globstar
for file in "$SOURCE_DIR"/**/*.typ; do
  [ -e "$file" ] || continue
  relative_path="${file#${SOURCE_DIR}/}"
  out_path="$OUT_DIR/${relative_path%.typ}.html"
  mkdir -p "$(dirname -- "$out_path")"
  typst compile --input out-path="$out_path" --input stylesheet-path="$STYLESHEET_PATH" --features html --format html --root "$PWD" "$file" "$out_path"
done
shopt -u globstar
