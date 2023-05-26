#!/usr/bin/env python3

from pathlib import Path
import re
from shutil import copyfile
from typing import Iterable

from src.utils import extract_name_of_context, get_contexts


def cascade() -> None:
    print("Auto-cascading versions of derived images...")
    patch_all_derivative_images()
    print("Auto-cascade complete.")


def patch_all_derivative_images() -> None:
    for context in get_contexts():
        image = extract_name_of_context(context)
        version = (context / "VERSION").read_text().strip()
        patch_derivative_images_of(parent=image, to_version=version)


def patch_derivative_images_of(parent: str, to_version: str) -> None:
    for context in get_contexts():
        patch_image_derivation(context, parent, to_version)


def patch_image_derivation(
    context: Path,
    parent: str,
    to_version: str,
) -> None:
    dockerfile = context / "Dockerfile"
    version_file = context / "VERSION"

    replacement = replace(context, parent_image=parent, to_version=to_version)
    dockerfile_content = dockerfile.read_text()

    if not dockerfile_content == replacement:
        print(f"Patching {dockerfile}'s reference to {parent} up to {to_version}")
        version_replacement = replace_version(context)

        backup_and_replace(dockerfile, replacement)
        backup_and_replace(version_file, version_replacement)


def backup_and_replace(path: Path, replacement_content: str) -> None:
    backup(path)
    path.write_text(replacement_content)


def backup(path: Path) -> None:
    backup = path.parent / f"{path.name}.bk"
    copyfile(path, backup)


_FROM_CLAUSE_PREFIX = re.compile(
    r"""
    ^
    \s*
    (?i:FROM)
    \s+
    \$
    \{ \s* REGISTRY \s* \}
    /
    """,
    re.VERBOSE,
)


def replace(context: Path, parent_image: str, to_version: str) -> str:
    from_image = re.compile(
        fr"""
        (?P<from_clause>
            {_FROM_CLAUSE_PREFIX.pattern}
            {re.escape(parent_image)}
            :
        )
        """,
        re.VERBOSE,
    )

    from_image_with_version = re.compile(
        fr"""
        {from_image.pattern}
        \d+ \.
        \d+ \.
        \d+
        (?P<rest> .*)
        """,
        re.MULTILINE | re.VERBOSE,
    )

    def replace_lines(file: Iterable[str]) -> Iterable[str]:
        for line in file:
            if from_image.search(line):
                matches = from_image_with_version.search(line)
                if not matches:
                    raise RuntimeError(
                        f"image derivation '{line}' in context {context} is "
                        "missing a standard version tag"
                    )
                from_clause = matches.group("from_clause")
                rest = matches.group("rest")
                yield f"{from_clause}{to_version}{rest}\n"
            else:
                yield line

    with (context / "Dockerfile").open() as dockerfile:
        return "".join(replace_lines(dockerfile))


_PATCH_VERSION_PATTERN = re.compile(
    r"""
    \.
    (?P<patch> \d+ )
    $
    """,
    re.VERBOSE,
)


def replace_version(context: Path) -> str:
    file = context / "VERSION"
    version = file.read_text().strip()
    match = _PATCH_VERSION_PATTERN.search(version)
    if not match:
        raise RuntimeError(f"invalid VERSION file {file} with content '{version}'")

    replacement = str(int(match.group("patch")) + 1)
    return re.sub(r"\d+$", replacement, version)


cascade()
