#!/bin/bash

export AWS_REGION=ap-southeast-1
export AWS_SSM_PREFIX=/dev/sample/
cat Deployment-template.yaml | sed "s|\${AWS_REGION}|${AWS_REGION}|" | sed "s|\${AWS_SSM_PREFIX}|${AWS_SSM_PREFIX}|" > Deployment.yaml
