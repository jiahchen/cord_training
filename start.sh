#!/bin/bash

DST=~/cord/build
TMP=/tmp/oai_scenario_backup/
mkdir /tmp/oai_scenario_backup

# Backup all old files
cp $DST/docker_images.yml $TMP
cp $DST/../.repo/manifests/default.xml $TMP
cp -r $DST/platform-install/roles/cord-profile/templates $TMP

# Copy new files into our target
cp docker_images.yml $DST/
cp manifest.xml $DST/../.repo/manifests/default.xml
cp cord-training.yml $DST/platform-install/profile_manifests/
cp cord-training-virtual.yml $DST/podconfig/
cp cord-training-services.yml.j2 $DST/platform-install/roles/cord-profile/templates
cp cord-training-service-graph.yml.j2 $DST/platform-install/roles/cord-profile/templates
cp iperf-net.yaml.j2 $DST/platform-install/roles/cord-profile/templates/

# Use custom version of vhss, vmme instead official
cd ~/cord/orchestration/xos_services

for var in "viperfser" "viperfcli" ; do
  if [ -d "$var" ]; then
    rm -rf $var
  fi
done

git clone https://github.com/jiahchen/viperfser viperfser
git clone https://github.com/jiahchen/viperfcli viperfcli

# Checkout to target branch
for var in "viperfser" "viperfcli" ; do
    cd $var;
    git remote add opencord https://github.com/jiahchen/$var.git;
    git checkout cord-4.1;
    git pull opencord cord-4.1;
    cd ..;
done
