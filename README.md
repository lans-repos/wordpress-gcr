## Wordpress on Cloud Run

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch WordPress on Google Cloud Run. The wordpress image has the Google Cloud Storage (GCS) plugin which can used to load wordpress media files to a GCS bucket.

## Requirements
A  MYSQL database (e.g called named wordpress) that can be accessed remotely via external IP address.

FYI: This was tested with a MYSQL database created using [GCP MYSQL deployment](https://console.cloud.google.com/marketplace/partners/click-to-deploy-images?project=pemm-220514)

## Deployment Parameters
The deployment will prompt for the following environment variables "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME".
 
 "DB_HOST" is externally exposed IP address to access the MySQL database (The default value is "localhost")
 
 "DB_USER" is the MySQL database username (The default value is "root")
 
 "DB_PASSWORD" is the MySQL database userpassword (The default valu is "password")
 
 "DB_NAME" is  name of the database for WordPress ( The default valu is "wordpress")
 
  

Note: This is created as quick proof of concept.
