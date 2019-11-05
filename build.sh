#!/bin/sh

set -o errexit
set -o nounset

for env in base-dev *-dev
do
    (
        cd "$env"
        docker build -t "$env" .
    )
done

