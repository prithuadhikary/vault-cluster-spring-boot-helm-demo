#! /bin/bash

caKey=$(openssl rsa -in root-ca/encrypted-ca.key 2>/dev/null)

if [ $? -ne 0 ]
then
   echo "Incorrect Passphrase"
   exit 1
fi

helm upgrade --install --namespace vault --set-file caCert=root-ca/ca.crt --set caKey="$caKey" vault-cluster vault-cluster
