## Wordpress on Cloud Run

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch WordPress container on Google Cloud Run that uses a Cloud SQL or an external MySQL database.

The Google Cloud Storage (GCS) wordpress plugin is baked into the Wordpress image to enable upload of images to GCS bucket for persistent storage.

Note: The Cloud SQL or external MySQL database for the wordpress should be setup & ready before clicking the Run on Google Cloud Button.

## Requirements

* A Cloud SQL database **OR** external MySQL database that can be accessed remotely via external IP address.

  * The Cloud SQL or external MySQL database for the wordpress should be setup & ready before clicking the Run on Google Cloud Button.

  * A Cloud SQL database can be created quickly by downloading the  [createCloudSQL.sh](https://github.com/lans-repos/wordpress-gcr/blob/master/createCloudSQL.sh) script and running it in Cloud Shell.

* A Google Cloud Storage (GCS) Bucket with its object default permission configured for allUsers. See this [plugin support response](https://wordpress.org/support/topic/google-storage-not-work/page/2/#post-8897852) on how to configure the  GCS bucket so that uploaded images are publicly available.

## Deployment Parameters
The Run on Google Cloud deployment will prompt for the following environment variables "DB_HOST","DB_USER","DB_PASSWORD", &"DB_NAME".
 
* **"DB_HOST** is externally exposed IP address to access the MySQL database or the Cloud SQL host (The default value is "localhost")
 If you are using Cloud SQL set this to 127.0.0.1
 
* **"DB_USER"** is the MySQL or Cloud SQL  database username (The default value is "root")
 
* **"DB_PASSWORD"** is the MySQL or Cloud SQL database user password (The default value is "password")
 
* **"DB_NAME"** is the name of the database for WordPress on MySQL or Cloud SQL ( The default value is "wordpress")
 
* **"CLOUDSQL_INSTANCE"** if you using Cloud SQL, this is the Cloud SQL instance connection name that you get from Cloud SQL Overiew Tab. This should be provided in the  format **poject.id:region:instance-name**

  * CLOUDSQL_INSTANCE is not a required parameter. It can therefore be ignored if you are not using not using Cloud SQL.
 
## Deploy Manually
**If you do not want to use the above "Run on Google Cloud Button", then you can:**

 * Clone the repository ( using the command ```git clone https://github.com/lans-repos/wordpress-gcr.git```)
 
 * Cd to wordpress-gcr 
  
 * Build the docker image (using the command ``` docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .  ```)
 
 * Push the image to Cloud Registry (using the command ``` docker push gcr.io/[PROJECT-ID]/wordpress-gcr ```)
 
 * Deploy the image from Cloud Registry to Cloud Run.
 
    If your are using a Cloud SQL database then deploy using the command after replacing  PROJECT-ID, DB_NAME, DB_USER, DB_PASSWORD & CLOUDSQL_INSTANCE with the relevant values: 
            
        
        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr --set-env-vars DB_HOST='127.0.0.1',DB_NAME=<dbname>,DB_USER=<dbuser>,DB_PASSWORD=<dbpass>,CLOUDSQL_INSTANCE='poject.id:region:instance-name' 

       
     If you are using an exertnal MysQL databas then deploy using the command after replacing  PROJECT-ID, DB_HOST, DB_NAME, DB_USER & DB_PASSWORD with the relevant values: 
    
  
        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr --set-env-vars DB_HOST=<dbhost>,DB_NAME=<dbname>,DB_USER=<dbuser>,DB_PASSWORD=<dbpass>
        

 
 
 
## Post Deployment & the GCS Wordpress plugin

After deployment & installionton of Wordpress , sign into WP-ADMIN, go to plugins, activate the GCS plugin , go the GCS plugin settings and input the url of the GCS bucket.


## Update / Install / Delete WordPress plugins or themes

This has to done locally in Google Cloud Shell and then pushed (i.e redployed) to Cloud Run and requires the use of the wp-cli utility and the wordpress directory included in this repository.

Since the Run on Google Cloud deployment uses Cloud Shell "Trusted Environment" it might be advisable to return to Cloud Shell  Default enviroment and pull a clone of this repository before you start any of the steps below:

*  Install the wp-cli utility using the command:

     ``` composer require wp-cli/wp-cli-bundle```

* A wp-config.php file , with the correct values for the DB_HOST, DB_NAME, DB_USER , DB_PASSWORD , CLOUDSQL_INSTANCE variables , **is required in the wordpress directory before you can use the wp-cli utility**. 

  * This will be true if image had already be deployed( using the button  or mannually)  to Cloud Run.

  * If the wp-config.php is not present in the wordpress directory or if the file is present but does not have the correct values for  DB_HOST, DB_NAME, DB_USER & DB_PASSWORD, CLOUDSQL_INSTANCE variables then copy wp-config.php from the root directory to the wordpress directory and provide the correct values for DB_HOST, DB_NAME, DB_USER & DB_PASSWORD, CLOUDSQL_INSTANCE variables

* From inside the wordpress directory ( i.e. cd to wordpress ) you can now update   plugins and themes using the commands wp cli commands:

    ``` vendor/bin/wp plugin update --all```
    
    ``` vendor/bin/wp theme update --all```
    
* You can also use the several ```wp plugin <command> ``` or ```wp theme <command> ```  to install , delete, activate, or act upon any individual plugins or themes.

* You can also from inside the wordpress directory, run the command ```wp server``` and then use the Cloud Shell Web Preview feature to access the a local version of the wordpress site. You can login to wordpress admin and update plugins or themes. 


* After locally updating plugins or themes, you need to rebuild the docker image, push it to cloud registry and then push (redeploy) the updated image to Cloud Run by running the following three commands:

        docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .
        
        docker push gcr.io/[PROJECT-ID]/wordpress-gcr

        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr
        
    
       In the above commands  [PROJECT-ID] is your gcp project-id.
       
       The command also assume that the Cloud Run Service name is unchange and remains wordpress-gcr.
       
       
  The proccess of rebuilding the docker image and redeploying it to the Cloud Run Service could be automated using [Cloud Build Triggers](https://cloud.google.com/run/docs/continuous-deployment?_ga=2.244497477.-1913607253.1558898014).

* The wordpress core can not be updated via this process. Since docker build process always pulls the latest wordpress docker image the wordpress core can be updated by just running the three commands step above.  

## Using Cloud Run Custom Domain on the Wordpress deployment

If you decide to use Cloud Run Custom Domain mapping on the Wordpress deployment then you have to remember that Cloud Run only maps a  domain to /, but not to a specific base path. 

**This means a url path like https://customdomain.com/contact.php  will not be mapped !**

To map the custom domain to all path urls you should:

* Clone the repositry to Cloud Shell ( that is if you have not already)

* Edit the wp-config.php files to add 


       define( 'WP_HOME', 'https://customdomain.com' ); 
        
       define( 'WP_SITEURL', 'https://customdomain.com/' );

            
        with https:cutomdomain.com refering to your custom domain.
 
 
   
 * Then rebuild the docker image, push it to cloud registry and then push (redeploy) the updated image to Cloud Run by running the following three commands:

        docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .
        
        docker push gcr.io/[PROJECT-ID]/wordpress-gcr

        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr
  
## Firebase Integration

Coming Soon :)

## Does it even make sense to deploy Wordpress in Cloud Run ?

That is a great question ! 

I will admit that Cloud Run's stateless container model makes Wordpress admini & update cumbersome and time consuming. Hence this  might only appeal to an enthustiast or a DevOps that likes over-engineered solutions.

I did however observe that [Wordpress on AppEngine](https://cloud.google.com/wordpress/#appengine) also uses a stateless severless architecture. I am therefore going to assume that stateless severless Wordpress does have some technically benefits. :)









