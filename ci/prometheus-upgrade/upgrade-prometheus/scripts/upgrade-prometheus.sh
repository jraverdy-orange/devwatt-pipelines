#!/usr/bin/env bash 

set -e

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml


cd ${ROOT_FOLDER}/prometheus-release

[ ! -f prometheus*.tgz ] && exit 1 || FILE=$(ls prometheus*.tgz|tail -1)

# uploading the release
bosh -e ${ALIAS} upload-release $FILE

# do the deployment
cd ${ROOT_FOLDER}/prometheus-release-src

# checkout the right tag
git checkout $(cat ${ROOT_FOLDER}/prometheus-release/tag)

bosh -e ${ALIAS} -d prometheus deploy -n manifests/prometheus.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/prometheus2-opsfile.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/use-last-postgres-release-opsfile.yml \
  -o manifests/operators/monitor-bosh.yml \
  -o manifests/operators/enable-bosh-uaa.yml \
  -v bosh_url=${IP} \
  -v uaa_bosh_exporter_client_secret=${UAA_BOSH_EXPORTER_CLIENT_SECRET} \
  --var-file bosh_ca_cert=${ROOT_FOLDER}/bosh-director-config/bosh_ca.crt \
  -v metrics_environment=${METRICS_ENVIRONMENT}