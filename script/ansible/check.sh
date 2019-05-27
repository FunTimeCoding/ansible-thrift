#!/bin/sh -e

export ANSIBLE_CONFIG=tests/ansible.cfg
ansible-playbook tests/test.yaml --inventory=tests/inventory --syntax-check
