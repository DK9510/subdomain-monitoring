#!/bin/bash

# this script is for subdomain monitor and dns resolution

scripts/subdomain.sh 
cd dns-resolve
cp ../output/subdomains.txt .
chmod +x massdns
./massdns -r resolvers.txt -t A -o S -w a-record.txt subdomains.txt
./massdns -r resolvers.txt -t CNAME -o S -w cname-record.txt subdomains.txt
./massdns -r resolvers.txt -t TXT -o S -w txt-record.txt subdomains.txt
./massdns -r resolvers.txt -t AAAA -o S -w aaaa-record.txt subdomains.txt


cat a-record.txt |grep " A "|	sed "s/A/:/g" |tee a
sleep 2;
cat cname-record.txt |sed "s/CNAME/:/g" |tee cname
cat a-record.txt|grep "CNAME" |sed "s/CNAME/:/g" |anew cname
sleep 2;
cat txt-record.txt |sed "s/TXT/:/g" |tee txt
sleep 2;
cat aaaa-record.txt |sed "s/AAAA/:/g" |sed "s/CNAME/:/g"|tee aaaa
sleep 2;
rm a-record.txt cname-record.txt txt-record.txt aaaa-record.txt


git add dns-resolve/
git config --global user.email "d.b.kapadiya9510@gmail.com"
git config --global user.name "DK9510"
git commit -a -m "Subdomain enumeration completed"
git branch -M main 
git push -u origin main

echo "dns resolution is done" | notify -silent -provider-config ../configs/notify.yaml 
