#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

bosh -e ${ALIAS} upload-stemcell ${ROOT_FOLDER}/ubuntu-stemcell/stemcell.tgz

mkdir -p ${ROOT_FOLDER}/output

cd ${ROOT_FOLDER}/output || exit 666

echo "version="$(cat ${ROOT_FOLDER}/ubuntu-stemcell/version) > keyval.properties