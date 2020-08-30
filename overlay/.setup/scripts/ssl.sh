#!/bin/sh
#
#  ssl.sh
#  Generate SSL (Secure Socket Layer) certificates.
#
#  Copyright 2020, Marc S. Brooks (https://mbrooks.info)
#

BASE_DIR=/.setup/scripts
. $BASE_DIR/lib.sh

cert_dir=/etc/ssl/certs

#
# Output Private Key/Certificate
#
revert_file $cert_dir/nanopi-neo-cert.pem
revert_file $cert_dir/nanopi-neo-key.pem

openssl req -x509 -newkey rsa:2048 -nodes -sha256 -keyout $cert_dir/nanopi-neo-key.pem -out $cert_dir/nanopi-neo-cert.pem -days 365 -subj "/C=US/ST=CA/L=San Diego/O=Marc S. Brooks/OU=NanoPi-NEO Network/CN=*.nanopi-neo.localhost"
