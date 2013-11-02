#!/bin/sh

git checkout src;
rm -rf _site;
cd ../blog;
git checkout master;
git rm -rf .;
git add --all;
git commit -am 'Clear blog';
cd ../blog-src;
jekyll build;
cp -r _site/ ../blog/;
cd ../blog/;
git add --all;
git commit -am 'Update';
git push origin master;
cd ../blog-src/;
rm -rf _site;
