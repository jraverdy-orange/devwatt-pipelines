#!/usr/bin/env bash 

set -e

# install curl
apt update
apt install -y curl

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml


cd ${ROOT_FOLDER}/prometheus-boshrelease
# retrieving last tag
last_tag=$(git for-each-ref --sort=-taggerdate --count=1 refs/tags|sed -e "s/.*\/\([^[\/]]*\)/\1/")
git checkout $last_tag
cd ${ROOT_FOLDER}

# downloading the needed release
url=$(grep "https://github.com/bosh-prometheus/prometheus-boshrelease/releases/download" \
			prometheus-boshrelease/manifests/prometheus.yml \
	|awk '{print $2}')
curl -o prometheus-release.tar.gz -L ${url}
# uploading the release
bosh -e ${ALIAS} upload-release prometheus-release.tar.gz


bosh -e ${ALIAS} -d prometheus deploy -n prometheus-boshrelease/manifests/prometheus.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/prometheus2-opsfile.yml \
  -o ${ROOT_FOLDER}/devwatt-pipelines/opsfiles/use-last-postgres-release-opsfile.yml \
  -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
  -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
  -v bosh_url=${IP} \
  -v uaa_bosh_exporter_client_secret=${UAA_BOSH_EXPORTER_CLIENT_SECRET} \
  --var-file bosh_ca_cert=${ROOT_FOLDER}/bosh-director-config/bosh_ca.crt \
  -v metrics_environment=${METRICS_ENVIRONMENT}