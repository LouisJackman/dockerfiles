from dataclasses import dataclass
import json
from urllib import request
from urllib.error import URLError
from subprocess import DEVNULL, CalledProcessError, run

from .image_stores import ImageStore, Registry


@dataclass
class ImageExistenceChecker:
    image_store: ImageStore
    secure_manifest_inspections: bool = True

    def does_exist(self, name: str, version: str) -> bool:
        if self.image_store.is_local:
            result = self.does_exist_via_command(name, version)
        elif isinstance(self.image_store, Registry):
            api_endpoint = self.image_store.api_endpoint

            # TODO: find out why some registries don't respond properly to the
            # API, necessitating a (sometimes unrepresentative) local check via
            # `docker manifest inspect`.
            result = self.does_exist_via_api(
                api_endpoint, name, version
            ) or self.does_exist_via_command(name, version)
        else:
            result = False
        return result

    def does_exist_via_command(self, name: str, version: str) -> bool:
        img = f"{self.image_store.prefix}/{name}:{version}"
        secure = [] if self.secure_manifest_inspections else ["--insecure"]
        try:
            run(
                ["docker", "manifest", "inspect", *secure, img],
                stdout=DEVNULL,
                stderr=DEVNULL,
            )
            result = True
        except CalledProcessError:
            result = False
        return result

    @classmethod
    def does_exist_via_api(cls, api_endpoint: str, name: str, version: str) -> bool:
        uri = f"{api_endpoint}/v2/{name}/tags/list"
        try:
            with request.urlopen(uri) as response:
                result = bool(
                    cls._is_response_ok(response)
                    and (tags := json.load(response).get("tags"))
                    and (version in tags)
                )
        except URLError:
            result = False
        return result

    @staticmethod
    def _is_response_ok(response) -> bool:
        return 200 <= response.status < 300
