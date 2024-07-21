#!/bin/bash

# Create a directory for SSL files
rm -rf ssl
mkdir -p ssl
cd ssl

# Generate CA private key
openssl genpkey -algorithm RSA -out ca-key.pem

# Generate CA certificate
openssl req -x509 -new -nodes -key ca-key.pem -sha256 -days 1024 -out ca-cert.pem -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=example.com"

# Generate Tomcat private key
openssl genpkey -algorithm RSA -out tomcat-key.pem

# Create a certificate signing request (CSR) for Tomcat
openssl req -new -key tomcat-key.pem -out tomcat.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=example.com"

# Sign the Tomcat CSR with the CA certificate
openssl x509 -req -in tomcat.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out tomcat-cert.pem -days 500 -sha256

# Create a PKCS12 keystore from the Tomcat private key and certificate
openssl pkcs12 -export -in tomcat-cert.pem -inkey tomcat-key.pem -out tomcat.p12 -name tomcat -CAfile ca-cert.pem -caname root -password pass:xpandit

# Convert the PKCS12 keystore to a Java keystore
keytool -importkeystore -deststorepass xpandit -destkeypass xpandit -destkeystore keystore.jks -srckeystore tomcat.p12 -srcstoretype PKCS12 -srcstorepass xpandit -alias tomcat
