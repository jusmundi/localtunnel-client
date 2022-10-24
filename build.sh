#!/bin/bash
set -eu -o pipefail

## General internal vars
image="${CI_REGISTRY_IMAGE:-localtunnel-client}"
tag="${CI_COMMIT_REF_SLUG:-latest}"

echo ""
echo "Building $image:$tag"
node_container=$(buildah from docker.io/node:16.17.1-alpine3.15)

## General configuration
buildah config \
  --author='Jav <jotamontecino@gmail.com>' \
  --workingdir=/usr/src/app/ \
  $node_container

## Adding raw layers
function brun() {
  buildah run $node_container -- "$@"
}

## Set alpine as starting point
buildah add $node_container ./bin /usr/ltc/bin
buildah add $node_container ./lib /usr/ltc/lib
buildah add $node_container ./localtunnel.js /usr/ltc/localtunnel.js
buildah add $node_container ./package.json /usr/ltc/package.json
buildah add $node_container ./node_modules /usr/ltc/node_modules
brun npm i -g /usr/ltc/ ## Set the link so the the nodejs module can be used as a cli directly

## Creating image
buildah commit --rm $node_container "$image:$tag"
echo "Created image: $image:$tag"
