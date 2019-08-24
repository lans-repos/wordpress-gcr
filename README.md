## Wordpress on Cloud Run

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch WordPress on Google Cloud Run. 

The Google Cloud Storage (GCS) wordpress plugin is baked into the Wordpress image to enable upload of images to GCS bucket for persistent storage.

## Requirements
A  MYSQL database that can be accessed remotely via external IP address  OR  Cloud SQL database.

Note: The  MYSQL or Cloud SQL  database for the wordpress should be setup & ready before you click the Run on Google Cloud Button.

## Deployment Parameters
The deployment will prompt for the following environment variables "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME".
 
**"DB_HOST** is externally exposed IP address to access the MySQL database or the Cloud SQL host (The default value is "localhost")
 If you are using Cloud SQL set this to 127.0.0.1
 
**"DB_USER"** is the MySQL or Cloud SQL  database username (The default value is "root")
 
 **"DB_PASSWORD"** is the MySQL or Cloud SQL database userpassword (The default value is "password")
 
**"DB_NAME"** is the name of the database for WordPress on MySQL or Cloud SQL ( The default value is "wordpress")
 
 **"CLOUDSQL_INSTANCE"** if you using Cloud SQL ,this is the Cloud SQL instance connection that you get from Cloud SQL Overiew Tab. 
 
 This should be provided in the  format poject.id:region:instance-name 

 This is not a required parameter. It can therefore be ignored if you are not using not using Cloud SQL.
 
 
Note: This is created as quick proof of concept.


