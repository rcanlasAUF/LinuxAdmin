#!/bin/sh

mkdir /opt/backups
passw=rcanlas1
date=$(date '+%m-%d-%Y')
mysqldump -u root -p$passw wordpress > wordpress${date}.sql

tar -cv wordpress${date}.sql > wordpress${date}.gz 

