#!/bin/bash
CFSSL_URL=https://pkg.cfssl.org/R1.2
curl -s -Lo /usr/local/bin/cfssl ${CFSSL_URL}/cfssl_linux-amd64
curl -s -Lo /usr/local/bin/cfssljson ${CFSSL_URL}/cfssljson_linux-amd64
curl -s -Lo /usr/local/bin/cfssl-certinfo ${CFSSL_URL}/cfssl-certinfo_linux-amd64
chmod +x /usr/local/bin/cfssl*
