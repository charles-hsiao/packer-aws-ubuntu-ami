#!/bin/bash

# Search AMI's AWS Owner
AWS_OWNER=$1

# AWS region:
AWS_REGION=$2

# Ubuntu version:
UBUNTU_VERSION=$3
UBUNTU_VERSION_SHORT=$( echo ${UBUNTU_VERSION} | sed -e 's/\.//g' )

# AMI Volume
AMI_VOLUME=$4

# AMI Arch
AMI_ARCH=$5

# Linux or Darwin(MacOS)
DETECTED_OS=$(sh -c 'uname 2>/dev/null || echo Unknown')

echo "========================================="
echo "[DEBUG] DETECTED_OS=${DETECTED_OS}"
echo "[DEBUG] UBUNTU_VERSION=${UBUNTU_VERSION}"
echo "[DEBUG] UBUNTU_VERSION_SHORT=${UBUNTU_VERSION_SHORT}"
echo "[DEBUG] AWS_REGION=${AWS_REGION}"
echo "[DEBUG] AMI_VOLUME=${AMI_VOLUME}"
echo "[DEBUG] AMI_ARCH=${AMI_ARCH}"
echo "========================================="

echo "[DEBUG] Start to inspect latest AMI id of official Ubuntu AMI"

AMI_INFO=$( bash cmd/aws-ami-inspect.sh ${DETECTED_OS} ${AWS_REGION} ${UBUNTU_VERSION} ${AMI_VOLUME} ${AMI_ARCH} )
UPSTREAM_UBUNTU_RELEASE=$( echo ${AMI_INFO} | jq --raw-output -c '.UBUNTU_RELEASE' )
UPSTREAM_UBUNTU_AMI=$( echo ${AMI_INFO} | jq --raw-output -c '.AMI_ID' )

echo "[DEBUG] UPSTREAM_UBUNTU_RELEASE=${UPSTREAM_UBUNTU_RELEASE}"
echo "[DEBUG] UPSTREAM_UBUNTU_AMI=${UPSTREAM_UBUNTU_AMI}"

# Get the latest git commit hash (First 7 charachers)
LATEST_GIT_HASH=$( git log -1 | grep commit | sed -e 's/commit //g' | cut -c1-7 )
echo "[DEBUG] LATEST_GIT_HASH=${LATEST_GIT_HASH}"

# Check if AMI already existed or not
AMI_COUNT=$( aws ec2 --region ${AWS_REGION} describe-images --filters "Name=name,Values=ubuntu_${UBUNTU_VERSION_SHORT}_${UPSTREAM_UBUNTU_RELEASE}_${LATEST_GIT_HASH}" --owners ${AWS_OWNER} | jq ".Images | length" )

echo "[DEBUG] AMI_COUNT=${AMI_COUNT}"

if [[ ${AMI_COUNT} == 0 ]];
then
  echo "[DEBUG] AMI ubuntu_${UBUNTU_VERSION_SHORT}_${UPSTREAM_UBUNTU_RELEASE}_${LATEST_GIT_HASH} not exist, packer start build"
  #TODO: Slack notify
  packer build -var-file=variables/ubuntu_${UBUNTU_VERSION_SHORT}.json -var "AWS_REGION=${AWS_REGION}" -var "UPSTREAM_UBUNTU_AMI=${UPSTREAM_UBUNTU_AMI}" -var "UPSTREAM_UBUNTU_RELEASE=${UPSTREAM_UBUNTU_RELEASE}" -var "UBUNTU_VERSION_SHORT=${UBUNTU_VERSION_SHORT}" -var "LATEST_GIT_HASH=${LATEST_GIT_HASH}" templates/ubuntu_${UBUNTU_VERSION_SHORT}.json 
else
  echo "[DEBUG] AMI ubuntu_${UBUNTU_VERSION_SHORT}_${UPSTREAM_UBUNTU_RELEASE}_${LATEST_GIT_HASH} already existed"
fi

