#!/bin/sh -e

rm -rf build
script/check.sh --ci-mode
# TODO: Commented out because role dependencies are not available. Individual roles will not get their own CI job. They are integrated into the main provisioning repository as well as the project they are required for setting up a development environment that is as similar as possible to where it gets deployed.
#script/ansible/check.sh
# TODO: Be sure that this will be non-destructive and non-cluttering on the CI server.
#script/ansible/test.sh
