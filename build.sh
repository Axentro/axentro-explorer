#!/bin/sh

rm -rf dist
mint build --skip-icons --skip-service-worker
rm -rf server/public
mv dist server/public
