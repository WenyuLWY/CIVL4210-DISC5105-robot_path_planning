#!/bin/bash
source config.env

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${IMAGE_NAME}:latest \
  --push .