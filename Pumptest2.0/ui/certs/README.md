# Generate self-signed certificates

The self signed certificate enable us to run the application over HTTPS (encrypted communication) without additional
costs of a real certificate.

## Prerequisites
- openssl command running on your machine
    - see [these docs](https://adamtheautomator.com/openssl-powershell/) on how to install openssl on Windows powershell
    - linux has this installed by default

## Commands and files explained

In this directory we have 4 different files:
- pumptest2.key
- pumptest2.cnf
- pumptest2.crt
- pumptest2.csr

##N CNF file
The CNF file (pumptest2.cnf) contains all the data which the openssl command will ask you to complete on certificate
generation. By using this file, you don't have to enter anything, just press Enter on all questions.

This file is generated for the following domains:
- pumptest2-c.westeurope.cloudapp.azure.com
- vndckr1c
- pumptest2.local

If you need additional domains, just add them in the alt_names section. DO not forget to increase the number for the DNS.

### Key file
The first file created is the certificate key file. This was created with the following command, and in case we need to
generate a new certificate, we can use the same key. In case we want to modify the key as well, we can use the following 
command:
```bash
$ openssl genrsa -out pumptest2.key 2048
```
The number 2048 at the end of the command represents the number of bits the key has, in this case we will generate a
2048-bit key.

### CSR file
The CSR file (Certificate Signing Request) file is an encoded text containing information that will be included in the
certificate, such as Organisation Name, domain name, locality, country etc (see CNF file). It also contains the public
key which will be included the certificate. The CSR can be generated using the following command:
```bash
$ openssl req -new -out pumptest2.csr -key pumptest2.key -config pumptest2.cnf
```
We pass the previous created key and cnf file. If you are asked any questions and user input is required, just press
the Enter key.

### CRT file
This is the actual certificate which will be generated based on the csr, key and cnf file. 
```bash
$ openssl x509 -req -days 3650 -in pumptest2.csr -signkey pumptest2.key -out pumptest2.crt -extensions v3_req -extfile pumptest2.cnf
```
