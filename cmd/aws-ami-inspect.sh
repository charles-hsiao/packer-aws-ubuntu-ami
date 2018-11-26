#!/bin/bash

# Current OS
OS=$1

# AWS region:
AWS_REGION=$2

# Ubuntu version:
UBUNTU_VERSION=$3

# AMI Volume
AMI_VOLUME=$4

# AMI Arch
AMI_ARCH=$5

# Validation
if [[ ${OS} == "" ]];
then
  echo "[Error] OS is null!"
  exit 1
fi

if [[ ${AWS_REGION} == "" ]];
then
  echo "[Error] AWS region is null!"
  exit 1
fi

if [[ ${UBUNTU_VERSION} == "" ]];
then
  echo "[Error] Ubuntu version is null!"
  exit 1
fi

if [[ ${AMI_VOLUME} == "" ]];
then
  echo "[Error] AMI volume is null!"
  exit 1
fi

if [[ ${AMI_ARCH} == "" ]];
then
  echo "[Error] AWS arch is null!"
  exit 1
fi

if [[ ${OS} == "Darwin" ]];
then 
  AMI_INFO=$(curl -s "https://cloud-images.ubuntu.com/locator/ec2/releasesTable" \
           | gsed '$x;$G;/\(.*\),/!H;//!{$!d};  $!x;$s//\1/;s/^\n//' \
           | jq -c ".aaData[] | select(contains([\"${UBUNTU_VERSION}\", \"${AWS_REGION}\", \"${AMI_VOLUME}\", \"${AMI_ARCH}\"]))")
  AMI_ID=$(echo ${AMI_INFO} | grep -o 'ami-[a-z0-9]\+' | head -1)
  UBUNTU_RELEASE=$(echo ${AMI_INFO} | jq --raw-output -c '.[5]')
elif [[ ${OS} == "Linux" ]]; then
  AMI_INFO=$(curl -s "https://cloud-images.ubuntu.com/locator/ec2/releasesTable" \
           | sed '$x;$G;/\(.*\),/!H;//!{$!d};  $!x;$s//\1/;s/^\n//' \
           | jq -c ".aaData[] | select(contains([\"${UBUNTU_VERSION}\", \"${AWS_REGION}\", \"${AMI_VOLUME}\", \"${AMI_ARCH}\"]))")
  AMI_ID=$(echo ${AMI_INFO} | grep -o 'ami-[a-z0-9]\+' | head -1)
  UBUNTU_RELEASE=$(echo ${AMI_INFO} | jq --raw-output -c '.[5]')
fi

echo "{\"AMI_ID\":\"${AMI_ID}\",\"UBUNTU_RELEASE\":\"${UBUNTU_RELEASE}\"}"
