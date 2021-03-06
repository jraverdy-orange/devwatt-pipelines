#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

bosh -e ${ALIAS} upload-stemcell ${ROOT_FOLDER}/ubuntu-xenial-stemcell/stemcell.tgz

mkdir -p ${ROOT_FOLDER}/output

cd ${ROOT_FOLDER}/output || exit 666

echo "version="$(cat ${ROOT_FOLDER}/ubuntu-xenial-stemcell/version) > keyval.properties

echo "A new ubuntu xenial stemcell ($(cat ${ROOT_FOLDER}/ubuntu-xenial-stemcell/version)) has been succesfully uploaded to the Devwatt bosh director

${BUILD_PIPELINE_NAME}/jobs/${BUILD_JOB_NAME}/builds/${BUILD_NAME}" > mail.body