#!/bin/bash

USER="hallvard-indgjerd"
ORG="hallvard-indgjerd"
TOKEN="ghp_***************************"
REPO="playcanvas-viewer"
BRANCH="main"

# cd /home/debian/containers/vtm_www/data
cd ..
git clone -b $BRANCH https://$USER:$TOKEN@github.com/$ORG/$REPO.git
cd $REPO
git pull --ff-only
