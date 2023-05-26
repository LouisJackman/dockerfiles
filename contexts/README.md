# Contexts

Each context to build. The numeric prefix defines the order in which they're
built; this allows images to depend on one another. For example, `base-dev` can
depend on `debian-slim` so long as the latter has a greater numeric prefix.

