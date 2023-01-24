#!/bin/bash

# this script is for subdoamin enumeration
mkdir output
cd output/
echo "starting subdomain enumeration...."
cp ../domains.txt .

## assetFinder
echo " aseet finder is running......"
cat domains.txt |assetfinder --subs-only | tee asset.txt 

## subfind
echo "subfind is running ......."
subfinder -dL domains.txt -all -nc -oJ -silent -o subfind.json 
cat subfind.json | jq| fgrep "host" | cut -d ':' -f 2| sed 's/"//g'| sed 's/,//g' | tee subfind.txt
rm subfind.json
#amass

echo "amass is runnnign....."
amass enum -passive -df domains.txt -o amass.txt


cat asset.txt | anew subdomains.txt
#cat subfind.txt | anew subdomains.txt
cat amass.txt | anew subdomains.txt
rm -rfd subfind* amass.txt 

#subdomains from CRT.Sh



#remove outof scope domains
#cp ../outofscope.txt .
#../scripts/scope.py 
#cat list.txt | sed 's/ //g' | anew final_list.txt 
#rm list.txt 
rm asset.txt domains.txt  
cd ../
#git add final_list.txt
# git pull
# git fetch origin main
# git add output/subdomains.txt  
# git config --global user.email "dk@test.com"
# git config --global user.name "DK9510"
# git commit -a -m "Subdomain enumeration completed"
# git branch -M main 
# git push origin main --force
echo " SUbdomain Enumeraiton is Done..";
echo "subdomains enumeration done and now sending new subdomains list" | notify -silent -provider-config configs/notify.yaml
cat output/subdomains.txt| anew monitor.txt |tee tmp.txt
notify -silent -provider-config configs/notify.yaml -bulk -data tmp.txt 
rm tmp.txt
