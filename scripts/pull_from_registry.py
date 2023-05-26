#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path

from src.image_existence_checking import ImageExistenceChecker
from src.utils import (
    docker,
    extract_name_of_context,
    get_contexts,
    version_context,
)
from src.image_stores import Registry


class FromRegistryPuller:
    registry: Registry
    secure_manifest_inspections: bool

    def __init__(
        self,
        registry: Registry,
        secure_manifest_inspections: bool,
    ) -> None:
        self.registry = registry
        self.secure_manifest_inspections = secure_manifest_inspections

        self._image_existence_checker = ImageExistenceChecker(
            image_store=registry,
            secure_manifest_inspections=secure_manifest_inspections,
        )

    def pull(self) -> None:
        for context in get_contexts():
            self._pull_context(context)

    def _pull_context(self, context: Path) -> None:
        name = extract_name_of_context(context)
        version = version_context(context)
        image = f"{self.registry.prefix}/{name}"
        versioned = f"{image}:{version}"

        if self._image_existence_checker.does_exist(name, version):
            print(
                f"{versioned} exists on registry {self.registry.prefix}; "
                "pulling to the container store..."
            )
            self._pull_missing_context(image, version)
        else:
            print(
                f"{versioned} is missing on registry "
                f"{self.registry.prefix}; won't attempt to pull it to the "
                "container store"
            )

    @staticmethod
    def _pull_missing_context(image_name: str, version: str) -> None:
        versioned = f"{image_name}:{version}"
        docker("pull", versioned)
        docker("tag", versioned, image_name)


parser = ArgumentParser()
parser.add_argument("--registry", required=True)
parser.add_argument("--secure-manifest-inspections", type=bool, default=True)
args = parser.parse_args()

registry = Registry.from_uri(args.registry)

puller = FromRegistryPuller(registry, args.secure_manifest_inspections)
puller.pull()
