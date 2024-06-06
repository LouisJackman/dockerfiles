from functools import lru_cache
from pathlib import Path
from subprocess import CalledProcessError, PIPE

from .image_stores import ImageStore
from .image_existence_checking import ImageExistenceChecker
from .utils import docker_build, extract_name_of_context, version_context


class ContextBuilder:
    image_store: ImageStore
    secure_manifest_inspections: bool
    default_platforms: set[str]
    context: Path
    only_local_arch: bool
    push: bool

    _build_message_suffix: str

    def __init__(
        self,
        image_store: ImageStore,
        secure_manifest_inspections: bool,
        default_platforms: set[str],
        context: Path | None = None,
        only_local_arch: bool = False,
        push: bool = False,
    ) -> None:
        self.image_store = image_store
        self.secure_manifest_inspections = secure_manifest_inspections
        self.context = context or Path.cwd()
        self.only_local_arch = only_local_arch
        self.push = push
        self.default_platforms = default_platforms

        self._image_existence_checker = ImageExistenceChecker(
            image_store=image_store,
            secure_manifest_inspections=secure_manifest_inspections,
        )

        # Strip numeric prefix which is only used for ordering builds.
        self.name = extract_name_of_context(self.context)

        self.version = version_context(self.context)
        self.image = f"{image_store.prefix}/{self.name}"
        self.versioned_image = f"{self.image}:{self.version}"

        if push:
            if only_local_arch:
                self._build_message_suffix = (
                    "building and pushing for just the current architecture..."
                )
            else:
                self._build_message_suffix = (
                    "building and pushing for all supported architectures..."
                )
        else:
            self._build_message_suffix = (
                "building only the current architecture and loading locally..."
            )

    def build(self, *args: str) -> None:
        if self._does_image_exist():
            if self.image_store.is_local:
                storage_message = "locally"
            else:
                storage_message = "on the registry"
            print(
                f"Image {self.versioned_image} already exists "
                f"{storage_message}; skipping..."
            )
        else:
            self._build_missing(*args)

    def _does_image_exist(self) -> bool:
        return self._image_existence_checker.does_exist(self.name, self.version)

    def _build_missing(self, *args: str) -> None:
        print(
            f"Image '{self.versioned_image}' is missing; "
            f"{self._build_message_suffix}"
        )
        flags = self._make_build_args(*args)
        docker_build(*flags)

    def _make_build_args(self, *args: str) -> list[str]:
        if self.push and not self.only_local_arch:
            platform_flags = [f"--platform={','.join(self._platforms)}"]
        else:
            platform_flags = []

        push_flag = ["--push"] if self.push else ["--load"]

        # Workaround for issues like these:
        #
        # - https://gitlab.com/gitlab-org/gitlab/-/issues/388865
        # - https://github.com/docker/buildx/issues/1533
        #
        # Don't mention provenance if the Docker version doesn't support it. If
        # it does, explicitly disable support for provenance.
        if self._supports_provenance_flag:
            provenance_flag = ["--provenance=false"]
        else:
            provenance_flag = []

        return [
            f"--build-arg=REGISTRY={self.image_store.prefix}",
            "--tag",
            self.versioned_image,
            "--tag",
            self.image,
            *platform_flags,
            "--pull",
            *push_flag,
            *provenance_flag,
            *args,
            str(self.context),
        ]

    @property
    def _platforms(self) -> set[str]:
        platforms_override = self.context / "PLATFORMS_OVERRIDE"
        if platforms_override.is_file():
            platform_strings = platforms_override.read_text().split(",")
            result = set(s.strip() for s in platform_strings)
        else:
            result = self.default_platforms
        return result

    _MISSING_PROVENANCE_ERROR_MESSAGE = "unknown flag: --provenance"

    @classmethod
    @property
    @lru_cache
    def _supports_provenance_flag(cls) -> bool:
        try:
            docker_build("--provenance=false", "--help", stderr=PIPE)
        except CalledProcessError as error:
            if cls._MISSING_PROVENANCE_ERROR_MESSAGE in error.stderr.decode():
                return False
        return True
