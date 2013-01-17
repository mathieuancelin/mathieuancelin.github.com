#!/bin/sh

git checkout src;
rm -rf _site;
cd ../blog;
git checkout master;
git rm -rf .;
git add --all;
git commit -am 'Clear blog';
cd ../blog-src;
jekyll --no-server &
sleep 10;
killall ruby;
cp -r _site/ ../blog/;
cd ../blog/;
git add --all;
git commit -am 'Update';
git push origin master;
cd ../blog-src/;
