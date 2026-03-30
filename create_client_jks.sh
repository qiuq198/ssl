#!/bin/bash

# Script to generate JKS format server public key certificate to client directory
# Usage: sh create_client_jks.sh [server name] [JKS password]

message="Usage:  sh create_client_jks.sh [server name] [JKS password]"

if [ $# -ne 2 ]; then
	echo $message
	exit 2
fi

if [ $1 = "--help" ]; then
	echo $message
	exit 2
fi

sname=$1
password=$2

export OPENSSL_CONF=../openssl.cnf

# Create client directory if it doesn't exist
if [ ! -d ./client/ ]; then
	echo "Creating Client folder: client/"
	mkdir client
fi

# Check if server certificate exists
if [ ! -f ./server/$sname.cert.pem ]; then
    echo "Error: Server certificate ./server/$sname.cert.pem not found!"
    echo "Please run 'sh make_server_cert.sh $sname <PKCS12_password>' first"
    exit 1
fi

echo "-------------------------------------------"
echo "Importing server certificate to JKS format in client directory"
echo "-------------------------------------------"

# Import server certificate to JKS format
keytool -import \
  -alias $sname-server \
  -file server/$sname.cert.pem \
  -keystore client/$sname-truststore.jks \
  -storepass $password \
  -noprompt

if [ $? -eq 0 ]; then
    echo "-------------------------------------------"
    echo "Successfully created JKS truststore: client/$sname-truststore.jks"
    echo "Alias: $sname-server"
    echo "Certificate: server/$sname.cert.pem"
    echo "-------------------------------------------"
else
    echo "Error: Failed to create JKS truststore"
    exit 1
fi