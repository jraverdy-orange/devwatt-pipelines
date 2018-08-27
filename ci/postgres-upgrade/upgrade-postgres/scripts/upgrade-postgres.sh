#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

cd ${ROOT_FOLDER}/postgres-release

[ ! -f release.tgz ] && exit 1

# uploading the release
bosh -e ${ALIAS} upload-release release.tgz