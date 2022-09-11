#!/bin/bash

openssl pkcs12 -export -out /app-secrets/keystore.p12 -inkey /app-cert/tls.key \
-in /app-cert/tls.crt -name key -password pass:changeit

chmod ugo+rx /app-secrets/keystore.p12

if [ -f "/app-secrets/truststore.jks" ]; then
  keytool -delete -alias ca -keystore /app-secrets/truststore.jks \
 -keypass changeit -storepass changeit
fi

keytool -importcert -trustcacerts  -file /ca/tls.crt \
  -keystore /app-secrets/truststore.jks -alias ca -noprompt \
  -keypass changeit -storepass changeit