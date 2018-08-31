#!/usr/bin/env bash 

set -e

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

cd ${ROOT_FOLDER}/concourse-release || exit 666

[ ! -f release.tgz ] && exit 1

# uploading the release
bosh -e ${ALIAS} upload-release release.tgz

cd ${ROOT_FOLDER}/concourse-bosh-deployment/cluster || exit 666

dir=$(dirname $0)
bosh -e ${ALIAS} deploy -d concourse concourse.yml \
  -l ../versions.yml \
  -o $ROOT_FOLDER/devwatt-pipelines/opsfiles/concourse-opsfile.yml \
  -o operations/http-proxy.yml \
  -o operations/prometheus.yml \
  -o operations/add-local-users.yml \
  --var web_ip=${FLOATING_IP} \
  --var external_url=http://${FLOATING_IP}:8080 \
  --var network_name=concourse \
  --var web_vm_type=small \
  --var db_vm_type=medium \
  --var concourse_version=latest \
  --var garden_runc_version=latest \
  --var postgres_version=latest \
  --var worker_vm_type=medium \
  --var deployment_name=concourse \
  --var db_persistent_disk_type=large \
  --var http_proxy_url=${HTTP_PROXY} \
  --var https_proxy_url=${HTTPS_PROXY} \
  --var no_proxy='["localhost", "127.0.0.1"]' \
  --var prometheus_port=${PROMETHEUS_PORT} \
  --var main_team_local_users=${MAIN_TEAM_USERS} \
  --var add_local_users=${LOCAL_USERS} \
  -n

