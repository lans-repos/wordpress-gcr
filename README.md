## Wordpress on Cloud Run

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch WordPress on Google Cloud Run. 

The Google Cloud Storage (GCS) wordpress plugin is baked into the Wordpress image to enable upload of images to GCS bucket for persistent storage.

**If you do not want to use the above "Run on Google Cloud Button", then you can:**

 *1.Clone the repository ( using the command git clone https://github.com/lans-repos/wordpress-gcr.git)
 
 *2.Edit the wp-config.php file to provide relevant values for  "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME" 
 
 *3.Build the docker image (using the command  docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .  )
 
 *4.Push the image to Cloud Registry (using the command  docker push gcr.io/[PROJECT-ID]/wordpress-gcr )
 
 *5.Deploy the image from Cloud Registry to Cloud Run. (using the command gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr )

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
 
 **"CLOUDSQL_INSTANCE"** if you using Cloud SQL, this is the Cloud SQL instance connection that you get from Cloud SQL Overiew Tab. 
 
 This should be provided in the  format **poject.id:region:instance-name**

 CLOUDSQL_INSTANCE is not a required parameter. It can therefore be ignored if you are not using not using Cloud SQL.
 
 
Note: This is created as quick proof of concept.

## Update WordPress plugins, and themes

This has to done locally in Google Cloud Shell and then pushed (i.e redployed) to Cloud Run and requires the use of the wp-cli utility and the wordpress directory included in this repository.

*1.  Install the wp-cli utility using the command:

     $ composer require wp-cli/wp-cli-bundle

*2. Copy the wp-config.php  file into the wordpress direcotry ( i.e  cp  wp-config.php  /wordpress/  )   

*3. From inside the wordpress directory ( i.e. cd to wordpress ) you can update all  plugins and themes using the commands:

    $ vendor/bin/wp plugin update --all
    
    $ vendor/bin/wp theme update --all
    
*4. You can also from inside the wordpress directory, run the command wp server and then use the Cloud Shell Web Preview feature to access the a local version of the wordpress site. You can login to wordpress admin and update plugins or themes.

*5. After locally updating plugins or themes, you need to rebuild the docker image, push it to cloud registry and then push (redeploy) the updated image to Cloud Run by running the following three commands:

        docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .
        
        docker push gcr.io/[PROJECT-ID]/wordpress-gcr

        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr
        
    
       In the above commands  [PROJECT-ID] is your gcp project-id. The command also assume that Cloud Run Service name is unchange and remains wordpress-gcr.

*6. The wordpress core can not be updated via this process.Since the docker build process always pulls the latest wordpress docker image you can update the wordpress core by just running the three commands in step 5 even if you did not update the any plugin or theme.


   




