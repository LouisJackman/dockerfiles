from __future__ import annotations
import re
from typing import Literal, Protocol, TypeGuard


class ImageStore(Protocol):
    @property
    def is_local(self) -> bool: ...

    @property
    def prefix(self) -> str: ...


_REGISTRY_WITH_PROTO = re.compile(
    r"""
    ^
    \s*
    (?P<proto> [\w\d]+)
    : //
    (?P<host> \S+)
    \s*
    $
    """,
    re.MULTILINE | re.VERBOSE,
)


RegistryProtocol = Literal["https", "http"]


# Give MyPy's narrowing of literal types a helping hand.
def _is_protocol(s: str) -> TypeGuard[RegistryProtocol]:
    return (s == "https") or (s == "http")


_DEFAULT_PROTOCOL: RegistryProtocol = "https"


class Registry(ImageStore):
    protocol: RegistryProtocol
    host: str

    @classmethod
    def from_uri(cls, uri: str) -> Registry:
        if match := _REGISTRY_WITH_PROTO.search(uri):
            protocol, host = match.groups()
            if not (isinstance(protocol, str) and isinstance(host, str)):
                raise ValueError(f"invalid matches '{protocol}' and '{host}'")
            if not _is_protocol(protocol):
                raise ValueError(f"invalid protocol {protocol}")
            result = cls(protocol=protocol, host=host)
        else:
            result = cls(host=uri)
        return result

    def __init__(
        self,
        host: str,
        protocol: RegistryProtocol = _DEFAULT_PROTOCOL,
    ) -> None:
        self.host = host
        self.protocol = protocol

    @property
    def is_local(self) -> bool:
        return False

    @property
    def prefix(self) -> str:
        return self.host

    @property
    def api_endpoint(self) -> str:
        return f"{self.protocol}://{self.host}"


class ContainerStore(ImageStore):
    _prefix: str

    def __init__(self, prefix: str) -> None:
        self._prefix = prefix

    @property
    def is_local(self):
        return True

    @property
    def prefix(self) -> str:
        return self._prefix
