#!/bin/bash

# path
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
python tools/generate_appendix.py --source "$SOURCE_DIR" --out "$APPENDIX_PATH"

# Copy public files to output directory
echo "Copying public files from $PUBLIC_DIR to $OUT_DIR..."
cp -r "$PUBLIC_DIR"/* "$OUT_DIR"/

# Compile Typst documents in source directory to output directory
echo "Compiling Typst documents in $SOURCE_DIR to $OUT_DIR..."
find "$SOURCE_DIR" -name "*.typ" | while read -r file; do
  relative_path="${file#${SOURCE_DIR}/}"
  out_path="$OUT_DIR/${relative_path%.typ}.html"
  mkdir -p "$(dirname -- "$out_path")"
  typst compile --input out-path="$out_path" --input stylesheet-path="$STYLESHEET_PATH" --features html --format html --root "$PWD" "$file" "$out_path"
done
