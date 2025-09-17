#!/bin/sh

echo "Running " $NODE_ENV
if [ "$NODE_ENV" = "production" ] ; then
  npm run serve
else
  npm run develop
fi
