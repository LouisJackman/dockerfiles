from pathlib import Path
import re
from subprocess import CompletedProcess, run
from typing import Iterable


def docker(*args: str, **kwargs) -> CompletedProcess[str]:
    return run(["docker", *args], check=True, **kwargs)


def docker_build(*args, **kwargs) -> CompletedProcess[str]:
    return docker("buildx", "build", *args, **kwargs)


def check_valid_context(context: Path) -> None:
    if not (context / "Dockerfile").is_file():
        raise RuntimeError(
            "all directories in `context` should have a Dockerfile, but it "
            f"is missing in {context}"
        )
    if not (context / "VERSION").is_file():
        raise RuntimeError(
            "all directories in `context` should have a VERSION file, but it "
            f"is missing in {context}"
        )


def get_contexts() -> Iterable[Path]:
    for path in sorted(Path("contexts").iterdir()):
        if path.is_dir():
            check_valid_context(path)
            yield path


CONTEXT_NAME_PATTERN = re.compile(
    r"^ \d+ - (?P<name> .*) $",
    re.MULTILINE | re.VERBOSE,
)


def extract_name_of_context(context: Path) -> str:
    match = CONTEXT_NAME_PATTERN.search(context.name)
    if not match:
        raise RuntimeError(f"could not extract name from {context}")
    return match.group("name")


SEMANTIC_VERSION_PATTERN = re.compile(
    r"^ \d+ \. \d+ \. \d+ $",
    re.VERBOSE,
)


def version_context(context: Path) -> str:
    version = (context / "VERSION").read_text().strip()
    if not SEMANTIC_VERSION_PATTERN.search(version):
        raise RuntimeError(
            f"VERSION files should match semver, e.g. 1.2.3, not {version}"
        )
    return version


_TRUE_STR_REPRESENTATIONS = {"true", "t", "1", "on", "yes", "y"}
_FALSE_STR_REPRESENTATIONS = {"false", "f", "0", "off", "no", "n"}


def arg_to_bool(arg: str) -> bool:
    # This was migrated from using `distutils.strtobool`to a handrolled
    # implementation as `distutils` was removed as a default package in
    # Python 3.12.

    normalised = arg.lower().strip()
    if normalised in _TRUE_STR_REPRESENTATIONS:
        return True
    if normalised in _FALSE_STR_REPRESENTATIONS:
        return False
    raise ValueError(f"invalid boolean string representation: {arg}")
