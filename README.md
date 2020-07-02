easypki
======

Easy Public Key Infrastructure intends to provide most of the components needed
to manage a PKI, so you can either use the API in your automation, or use the
CLI.


# CLI

Current implementation of the CLI uses the local store and uses a structure
compatible with openssl, so you are not restrained.

```
# Get the source code:
git clone https://github.com/nf3/easypki.git


# You can also pass the following through arguments if you do not want to use
# env variables.
# You can set them manually or run ./getstarted.sh
export PKI_ROOT=/tmp/pki
export PKI_ORGANIZATION="Acme Inc."
export PKI_ORGANIZATIONAL_UNIT=IT
export PKI_COUNTRY=US
export PKI_LOCALITY="Agloe"
export PKI_PROVINCE="New York"

mkdir $PKI_ROOT

# To run ./getstarted.sh
source ./getstarted.sh

#Set the go environment do the build and then install
go env
go build ./...
go install ./...

# Create the root CA:
# The value passed as the filename will be the same value that you pass into future commands as the --ca-name in order to sign new certs using this CA
easypki create --filename root --ca "Acme Inc. Certificate Authority"

# In the following commands, ca-name corresponds to the filename containing
# the CA.

# Create a server certificate for blog.acme.com and www.acme.com:
# Note the 2 --dns parameters are to set the SAN but the last www.acme.com param looks like it is a duplicate, but it is argument for the Common Name CN
easypki create --ca-name root --dns blog.acme.com --dns www.acme.com www.acme.com

# Create an intermediate CA:
easypki create --ca-name root --filename intermediate --intermediate "Acme Inc. - Internal CA"

# Create a wildcard certificate for internal use, signed by the intermediate ca:
easypki create --ca-name intermediate --dns "*.internal.acme.com" "*.internal.acme.com"

# Create a client certificate:
easypki create --ca-name intermediate --client --email bob@acme.com bob@acme.com

# Revoke the www certificate.
easypki revoke $PKI_ROOT/root/certs/www.acme.com.crt

# Generate a CRL expiring in 1 day (PEM Output on stdout):
easypki crl --ca-name root --expire 1

# Generate a CA without the proper Basic Constraint of CA:true
easypki create --basicConstraints 0 --filename root_bc_false --ca "Acme Inc. Certificate Authority bc false"
```

You will find the generated certificates in `$PKI_ROOT/ca_name/certs/` and
private keys in `$PKI_ROOT/ca_name/keys/`

For more info about available flags, checkout out the help `easypki -h`.

```
## OpenSSL command that you can use to verify or inspect the certs

# To look at the cert properties after it is generated
openssl x509 -in ~/certs/root_bc_false/certs/root_bc_false.crt -text

# To verify that the certificate chain is valid
# This should pass even if the CA root was created without the proper Basic Constraint
openssl verify -CAfile ~/certs/root/certs/root.crt ~/certs/root/certs/leafcert.example.com.crt

# To verify that the certificate chain is valid even under strict mode
# This should fail if the CA root was created without the proper Basic Constraint
openssl verify -x509_strict -CAfile ~/certs/root/certs/root.crt ~/certs/root/certs/leafcert.example.com.crt


```

# Disclaimer

This is not an official Google product.
