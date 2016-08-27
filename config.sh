#!/usr/bin/env bash

BASEDIR=/letsencrypt
CONTACT_EMAIL=$EMAIL
KEY_ALGO=secp384r1

if [ -z ${STAGING+-} ]; then
  CA="https://acme-v01.api.letsencrypt.org/directory"
else
  CA="https://acme-staging.api.letsencrypt.org/directory"
fi

