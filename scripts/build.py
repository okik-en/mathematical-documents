#!/usr/bin/env python3

from collections.abc import Mapping, Sequence
from pathlib import Path
import subprocess
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parent.parent
DOCS = ROOT / "docs"


def run_typst(template: str, output: Path, path: str | None = None) -> None:
    command = [
        "typst",
        "compile",
        "--features",
        "html",
        "--pretty",
        "--root",
        ".",
    ]
    if path is not None:
        command.extend(["--input", f"path={path}"])
    command.extend(
        [f"templates/{template}.typ", output.relative_to(ROOT).as_posix()]
    )

    try:
        subprocess.run(
            command,
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
    except subprocess.CalledProcessError as error:
        if error.stdout:
            print(error.stdout, end="")
        if error.stderr:
            print(error.stderr, end="")
        raise


def stage(output: Path) -> None:
    subprocess.run(["git", "add", output.relative_to(ROOT).as_posix()], cwd=ROOT, check=True)


def build_folder(path: str) -> None:
    output = DOCS / path / "index.html"
    output.parent.mkdir(parents=True, exist_ok=True)
    run_typst("folder", output, path)
    stage(output)


def build_file(path: str) -> None:
    output = DOCS / path / "index.html"
    output.parent.mkdir(parents=True, exist_ok=True)
    run_typst("file", output, path)
    stage(output)


def walk(node: Mapping[str, Any], parent: str = "") -> None:
    for name, children in node.items():
        path = f"{parent}/{name}" if parent else str(name)
        build_folder(path)

        if not isinstance(children, Sequence) or isinstance(children, (str, bytes)):
            raise TypeError(f"Expected a list at appendix path '{path}'")

        for child in children:
            if isinstance(child, Mapping):
                walk(child, path)
            elif isinstance(child, str):
                build_file(f"{path}/{child}")
            else:
                raise TypeError(f"Expected a name or mapping at appendix path '{path}'")


def main() -> int:
    with (ROOT / "appendix.yaml").open(encoding="utf-8") as file:
        appendix = yaml.safe_load(file)

    if isinstance(appendix, Mapping):
        roots = [appendix]
    elif isinstance(appendix, Sequence) and not isinstance(appendix, (str, bytes)):
        roots = appendix
    else:
        raise TypeError("appendix.yaml must contain a mapping or list of mappings")

    if not all(isinstance(root, Mapping) for root in roots):
        raise TypeError("appendix.yaml must contain only mappings at the top level")

    DOCS.mkdir(exist_ok=True)
    output = DOCS / "index.html"
    run_typst("top", output)
    stage(output)
    for root in roots:
        walk(root)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
