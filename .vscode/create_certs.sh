#!/bin/bash
if [ $(openssl version | grep -c "OpenSSL 3") -eq 1 ] 
then
    echo "OpenSSL installed"
else
    sudo apt install -y openssl
fi

FILE1=../certs/private/key.pem
FILE2=../certs/public/certificate.pem

if ( test -f "$FILE1" ) && ( test -f "$FILE2" ) ; then
echo "Files $FILE1 and $FILE2 exist"
else
openssl req -newkey \
rsa:2048 -nodes \
-keyout key.pem \
-x509 -days 365 \
-subj "/C=DE/ST=BW/L=Stuttgart/O=/OU=/CN=" -out certificate.pem

openssl pkcs12 \
-inkey key.pem \
-in certificate.pem \
-export -passout pass: \
-out import_cert.p12

mv key.pem ../certs/private
mv certificate.pem ../certs/public
mv import_cert.p12 ../certs/public

if [ $(grep -c microsoft /proc/version) -ge 1 ]; then
uid=$(whoami.exe | grep -Po '(?<=\\)\S*')
cp ../certs/public/*.p12 /mnt/c/Users/$uid/Documents
echo -e 'Self signed certificate copied to Documents /n Please install !'
else
sudo openssl pkcs12 -in ../certs/public/*.p12 -cacerts -nokeys -out /usr/local/share/ca-certificates/self_signed.crt
sudo chmod 644 /usr/local/share/ca-certificates/self-signed.crt
echo 'self signed certificate installed'
fi

fi

