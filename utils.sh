#!/bin/sh

apt-get update && apt install sudo curl wget nano -y
apt-get install python3-pip -y
echo "python installed">>/home/ubuntu/logs.txt

#### gcloud login using service principal ---- https://cloud.google.com/sdk/gcloud/reference/auth/activate-service-account
gcloud auth activate-service-account <SERVICE_ACCOUNT@DOMAIN.COM> --key-file <KEY_FILE_PATH> --project <PROJECT_NAME>
### Install Docker-ce
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce -y
echo "docker installed">>/home/ubuntu/logs.txt
sudo gcloud storage ls --recursive gs://<CLOUD_BUCKET_URI> | grep .tar.gz | sudo tee -a /home/ubuntu/images.ini

while read image_uri; do
  sudo gsutil -m cp $image_uri /home/ubuntu
  sudo docker load -i ${file}
done <images.ini

for file in /home/ubuntu*.tar.gz
do
  docker load -i ${file}
  rm ${file}
done
