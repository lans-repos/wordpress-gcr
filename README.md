## Wordpress on Cloud Run

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch WordPress on Google Cloud Run. The Google Cloud Storage (GCS) wordpress plugin is baked into the Wordpress image to enable upload of images to GCS bucket for persistent storage.

## Requirements
A  MYSQL database that can be accessed remotely via external IP address.

FYI: This was tested with a MYSQL database created using [GCP MYSQL deployment](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/mysql?q=MYSQL&id=59e776b5-96fb-4644-8a6e-92c2756ebef5)

## Deployment Parameters
The deployment will prompt for the following environment variables "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME".
 
 "DB_HOST" is externally exposed IP address to access the MySQL database (The default value is "localhost")
 
 "DB_USER" is the MySQL database username (The default value is "root")
 
 "DB_PASSWORD" is the MySQL database userpassword (The default value is "password")
 
 "DB_NAME" is  name of the database for WordPress ( The default value is "wordpress")
 
  

Note: This is created as quick proof of concept.


