from distutils.util import strtobool
from pathlib import Path
import re
from subprocess import run


def docker(*args):
    return run(["docker", *args])


def docker_build(*args):
    return docker("buildx", "build", *args)


def check_valid_context(context):
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


def get_contexts():
    for path in sorted(Path("contexts").iterdir()):
        if path.is_dir():
            check_valid_context(path)
            yield path


CONTEXT_NAME_PATTERN = re.compile(
    r"^ \d+ - (?P<name> .*) $",
    re.MULTILINE | re.VERBOSE,
)


def extract_name_of_context(context):
    match = CONTEXT_NAME_PATTERN.search(context.name)
    if not match:
        raise RuntimeError(f"could not extract name from {context}")
    return match.group("name")


SEMANTIC_VERSION_PATTERN = re.compile(
    r"^ \d+ \. \d+ \. \d+ $",
    re.VERBOSE,
)


def version_context(context):
    version = (context / "VERSION").read_text().strip()
    if not SEMANTIC_VERSION_PATTERN.search(version):
        raise RuntimeError(
            f"VERSION files should match semver, e.g. 1.2.3, not {version}"
        )
    return version


def arg_to_bool(arg):
    return bool(strtobool(arg))
