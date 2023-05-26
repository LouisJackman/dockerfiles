#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path

from src.image_existence_checking import ImageExistenceChecker
from src.utils import (
    extract_name_of_context,
    get_contexts,
    docker,
    version_context,
)
from src.image_stores import Registry


class LocalRegistryUploader:
    local_registry: Registry
    remote_registry: Registry
    secure_manifest_inspections: bool

    def __init__(
        self,
        local_registry: Registry,
        remote_registry: Registry,
        secure_manifest_inspections: bool = True,
    ) -> None:
        self.local_registry = local_registry
        self.remote_registry = remote_registry
        self.secure_manifest_inspections = secure_manifest_inspections

        self._image_existence_checker = ImageExistenceChecker(
            image_store=local_registry,
            secure_manifest_inspections=secure_manifest_inspections,
        )

    def upload(self) -> None:
        for context in get_contexts():
            self._upload_context(context)

    def _upload_context(self, context: Path) -> None:
        name = extract_name_of_context(context)
        version = version_context(context)

        remote = f"{self.remote_registry.prefix}/{name}:{version}"
        local = f"{self.local_registry.prefix}/{name}"
        versioned_local = f"{local}:{version}"

        if self._image_existence_checker.does_exist(name, version):
            print(
                f"{name}:{version} already exists on local registry "
                f"{self.local_registry.prefix}; skipping"
            )
        else:
            print(
                f"{name}:{version} is missing on local registry "
                f"{self.local_registry.prefix}; pushing..."
            )
            self._pull_missing_context(remote, local, versioned_local)

    @staticmethod
    def _pull_missing_context(
        remote: str,
        local: str,
        versioned_local: str,
    ) -> None:
        docker("pull", remote)
        docker("tag", remote, versioned_local)
        docker("tag", remote, local)
        docker("rmi", remote)
        docker("push", versioned_local)
        docker("push", local)


parser = ArgumentParser()
parser.add_argument("--local-registry", required=True)
parser.add_argument("--remote-registry", required=True)
parser.add_argument("--secure-manifest-inspections", default=True)
args = parser.parse_args()

local_registry = Registry.from_uri(args.local_registry)
remote_registry = Registry.from_uri(args.remote_registry)

uploader = LocalRegistryUploader(
    local_registry,
    remote_registry,
    args.secure_manifest_inspections,
)
uploader.upload()
