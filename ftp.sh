#!/bin/sh
date=`date +%Y_%m_%d`
days=7
orowner=face_data
bakdir=/mnt/
bakdata=$orowner"_"$date
ordatabak=$orowner"_"$date.tar.gz
cd $bakdir
tar -zcvf $ordatabak *
find $bakdir  -type f -name "*.tar.gz" -mtime +$days -exec rm -rf {} \;

ncftpput -u user -p password -R -P ip 目标目录 $ordatabak

