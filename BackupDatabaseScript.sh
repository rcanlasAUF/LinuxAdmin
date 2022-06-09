#!/bin/sh

mkdir /opt/backups

date=$(date '+%m-%d-%Y')
passw=rcanlas1

mysqldump -u root -p$passw wordpress > wordpress${date}.sql

tar -cv wordpress${date}.sql > wordpress${date}.gz 

