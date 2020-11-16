#!/bin/sh

set -o errexit
set -o nounset

arg=${1:-}
readonly arg="$(printf "%s" "$arg" | tr '[A-Z]' '[a-z]')"

case "$arg" in
    --rebuild)
        rebuild=1
        ;;
    "")
        rebuild=
        ;;
    *)
        echo "Invalid arg \"$arg\"; only \"--rebuild\" is allowed." >&2
        exit 1
        ;;
esac
readonly rebuild

if [ -z "$rebuild" ]
then
    images=$(docker images --format '{{ .Repository }}')
    readonly images
fi

build() (
    env=$1
    shift

    if [ -n "$rebuild" ] || {
        printf "%s" "$images" | grep "^${env}\$" >/dev/null
        [ "$?" -ne 0 ]
    }
    then
        cd "$env"
        docker build -t "$env" .
    fi
)

build base-dev
for image in *
do
    if [ -d "$image" ] && [ base-dev != "$image" ]
    then
        build "$image" &
    fi
done
wait

