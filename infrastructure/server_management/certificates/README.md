# Certificates

[Mozzilla Docs](https://wiki.mozilla.org/SecurityEngineering/x509Certs?_gl=1*131gb0o*_ga*MTE1NjY0MDQ0OS4xNzAyNDAxNDk4*_ga_2VC139B3XV*MTcwMjQwNjgxMS4yLjEuMTcwMjQwNjkxNi4wLjAuMA..)

## Creating CA Certificates

[Reference](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)

```bash
# generate private key
openssl genrsa -des3 -out myCA.key 2048

# generate root certificate
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
```

## Creating CA-Signed Certificates

[Reference](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)

```bash
# generate private key
openssl genrsa -out hellfish.test.key 2048

# create CSR
openssl req -new -key hellfish.test.key -out hellfish.test.csr
```

Create X509 extension config file

```conf
# hellfish.test.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = hellfish.test
```

Create certificate

```bash
openssl x509 -req -in hellfish.test.csr -CA myCA.pem -CAkey myCA.key \
-CAcreateserial -out hellfish.test.crt -days 825 -sha256 -extfile hellfish.test.ext
```

## Creating Self-Signed Certificates

```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365
```
