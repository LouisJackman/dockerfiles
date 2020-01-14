#!/bin/sh

set -o errexit
set -o nounset

build() (
    env=$1

    cd "$env"
    docker build -t "$env" .
)

build base-dev
for image in *
do
    if [ -d "$image" ] && [ "$image" != base-dev ]
    then
        build "$image" &
    fi
done
wait

