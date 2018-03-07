#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

bosh -e ${ALIAS} -d prometheus deploy prometheus-boshrelease/manifests/prometheus.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/prometheus-opsfile.yml \
  -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
  -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
  -v bosh_url=${IP} \
  -v uaa_bosh_exporter_client_secret=${UAA_BOSH_EXPORTER_CLIENT_SECRET} \
  -v bosh_ca_cert=<(echo ${BOSH_CA}) \
  -v metrics_environment=${METRICS_ENVIRONMENT}