#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

cd ${ROOT_FOLDER}/concourse-release || exit 666

[ ! -f release.tgz ] && exit 1

# uploading the release
bosh -e ${ALIAS} upload-release release.tgz

cd ${ROOT_FOLDER}/concourse-release-src || exit 666

#
bosh -e ${ALIAS} -d concourse deploy manifests/single-vm.yml  \
-o $ROOT_FOLDER/devwatt-pipelines/opsfiles/concourse-opsfile.yml \
-v deployment_name=concourse \
-v network_name=concourse \
-v web_ip=10.165.0.18 \
-v vm_type=medium \
-v concourse_version=latest \
-v garden_runc_version=latest \
-n
