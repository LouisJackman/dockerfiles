#!/usr/bin/env python3

from argparse import ArgumentParser
from functools import partial
from pathlib import Path

from src.image_stores import ImageStore, Registry
from src.context_building import ContextBuilder
from src.utils import get_contexts, arg_to_bool


_BUILD_ERROR_MESSAGE_PREFIX = (
    "Building failed. As `stop_on_first_error` is false, the remaining images "
    "were attempted to be built afterwards; now that's finished, the failures "
    "were: "
)


def build(
    *remaining_docker_build_args: str,
    image_store: ImageStore,
    default_platforms: set[str],
    push: bool,
    only_local_arch: bool,
    secure_manifest_inspections: bool,
    stop_on_first_error: bool,
) -> None:
    def try_build(context: Path) -> None:
        builder = ContextBuilder(
            context=context,
            image_store=image_store,
            push=push,
            only_local_arch=only_local_arch,
            secure_manifest_inspections=secure_manifest_inspections,
            default_platforms=default_platforms,
        )
        builder.build(*remaining_docker_build_args)

    if stop_on_first_error:
        for context in get_contexts():
            try_build(context)
    else:
        errors = []
        for context in get_contexts():
            try:
                try_build(context)
            except Exception as e:
                errors.append(e)

        if errors:
            messages = "; ".join(str(error) for error in errors)
            raise RuntimeError(_BUILD_ERROR_MESSAGE_PREFIX + messages)


parser = ArgumentParser()
parser.add_argument("--remaining-docker-build-args")
parser.add_argument("--image-store", required=True)
parser.add_argument("--default-platforms", required=True)
parser.add_argument("--push", type=arg_to_bool, default=False)
parser.add_argument("--only-local-arch", type=arg_to_bool, default=False)
parser.add_argument(
    "--secure-manifest-inspections",
    type=arg_to_bool,
    default=True,
)
parser.add_argument("--stop-on-first-error", type=arg_to_bool, default=True)
args = parser.parse_args()

image_store = Registry.from_uri(args.image_store)
default_platforms = set(
    platform.strip() for platform in args.default_platforms.split(",")
)
if args.remaining_docker_build_args:
    remaining_docker_build_args = args.remaining_docker_build_args.split()
else:
    remaining_docker_build_args = []

build(
    *remaining_docker_build_args,
    image_store=image_store,
    default_platforms=default_platforms,
    push=args.push,
    only_local_arch=args.only_local_arch,
    secure_manifest_inspections=args.secure_manifest_inspections,
    stop_on_first_error=args.stop_on_first_error,
)
