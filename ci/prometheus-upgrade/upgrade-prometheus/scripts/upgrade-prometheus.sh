#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

# forcing release... must to be fixed



cd ${ROOT_FOLDER}/prometheus-boshrelease
# retrieving last tag
last_tag=$(git for-each-ref --sort=-taggerdate --count=1 refs/tags|sed -e "s/.*\/\([^[\/]]*\)/\1/")
git checkout $last_tag
cd ${ROOT_FOLDER}

bosh -e ${ALIAS} -d prometheus deploy -n prometheus-boshrelease/manifests/prometheus.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/prometheus2-opsfile.yml \
  -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
  -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
  -v bosh_url=${IP} \
  -v uaa_bosh_exporter_client_secret=${UAA_BOSH_EXPORTER_CLIENT_SECRET} \
  --var-file bosh_ca_cert=${ROOT_FOLDER}/bosh-director-config/bosh_ca.crt \
  -v metrics_environment=${METRICS_ENVIRONMENT}