# wordpress-gcr
[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch a WordPress Image ( with GCS plugin)  on Google Cloud Run

Requirements: 
1. A  MySQLdatabase (e.g called wordpress) in a virtual machine that can be accessed remotely via external IP address.  ( This was tested with GCP MYSQL deployment https://console.cloud.google.com/marketplace/partners/click-to-deploy-images?project=pemm-220514)


 Deployment Darameters
 
 The deployment will prompt for the following environment variables "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME".
 
 "DB_HOST" is externally exposed IP address to access the MySQL database (The default valu is "localhost")
 "DB_USER" is the MySQL database username (The default value is "root")
 "DB_PASSWORD" is the MySQL database userpassword (The default valu is "password")
 "DB_NAME" is  name of the database for WordPress ( The default valu is "wordpress")
 
 
Note: This is created as quick proof of concept.
