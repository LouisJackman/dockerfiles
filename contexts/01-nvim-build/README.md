# nvim-build

This repo now takes the approach of using prebuilt binaries wherever possible,
for performance reasons. Building from source via QEMU is too slow, draining CI
credits too much.

For that reason, the version of Neovim should be pinned to whatever Debian
Testing currently offers. However, Debian Testing's build currently doesn't
bundle LuaJIT for ARM64 builds. The lack of LuaJIT not only degrades
performance, but breaks compatibility with some common plugins.

Until that is resolved, keep the version pinned to whatever Debian is currently
on and continue to use custom QEMU-based builds for now. For it to run in a
reasonable amount of time without CI timeouts, it'll need to be done manually
off the CI.
