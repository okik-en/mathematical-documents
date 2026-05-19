from __future__ import annotations

import argparse
from pathlib import Path


def build_tree(source: Path) -> dict[str, dict]:
    tree: dict[str, dict] = {}
    for path in source.rglob("index.typ"):
        rel = path.parent.relative_to(source)
        if not rel.parts:
            continue
        node = tree
        for part in rel.parts:
            node = node.setdefault(part, {})
    return tree


def render_yaml(tree: dict[str, dict], root_name: str) -> str:
    lines: list[str] = [f"- {root_name}:"]

    def render(node: dict[str, dict], indent: int) -> None:
        for name in sorted(node):
            child = node[name]
            prefix = " " * indent + f"- {name}"
            if child:
                lines.append(prefix + ":")
                render(child, indent + 2)
            else:
                lines.append(prefix)

    render(tree, 2)
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate appendix.yaml from index.typ files.")
    parser.add_argument("--source", default="src", help="Source directory to scan.")
    parser.add_argument("--out", default="appendix.yaml", help="Output YAML path.")
    args = parser.parse_args()

    source = Path(args.source)
    out_path = Path(args.out)

    tree = build_tree(source)
    out_path.write_text(render_yaml(tree, source.name), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
