#!/usr/bin/env bash 

set -ex

export ROOT_FOLDER=${PWD}

export BOSH_CONFIG=$PWD/bosh-director-config/bosh_config.yml

last_uploaded=$(cat ${ROOT_FOLDER}/uploaded-version/keyval.properties | grep "^version" | cut -d"=" -f2)


bosh -e ${ALIAS} stemcells | cat \
| grep $OS \
| grep -v "\*" \
| grep -wv "${BS_STEMCELL}" \
| grep -wv "${last_uploaded}" |awk '{printf "%s/%s\n",$1,$2}' | xargs -i -t bosh -e ${ALIAS} delete-stemcell -n {}
