#!/usr/bin/env bash
docker build --no-cache -t nilsramsperger/nodebb .
yes | docker image prune