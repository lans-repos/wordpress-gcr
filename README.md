


## Wordpress  on Cloud Run <img src="https://github.com/lans-repos/wordpress-gcr/blob/master/WordPress.png" height="30"> + <img src="https://github.com/lans-repos/wordpress-gcr/blob/master/CloudRun.png" height="30"> 
[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/lans-repos/wordpress-gcr.git)

Launch a WordPress container on Google Cloud Run that uses a Cloud SQL (or an external MySQL) database and a Google Cloud Storage (GCS) bucket for media uploads.

## Requirements

* A Cloud SQL database OR external MySQL database that can be accessed remotely via external IP address.

  * A Cloud SQL database can be created quickly by downloading the  [createCloudSQL.sh](https://github.com/lans-repos/wordpress-gcr/blob/master/createCloudSQL.sh) script and running it in Cloud Shell.
  
  * A cheap, dirty, not production recommeded, and probably insecure database option is to deploy Google [MySQL VM](https://console.cloud.google.com/marketplace/details/click-to-deploy-images/mysql?q=mysql&id=59e776b5-96fb-4644-8a6e-92c2756ebef5) on GCP with an externally exposed IP & firewall configured to accept traffic on port 3306 from anywhere. This option could even be free (i.e eligible for [Google Cloud free tier](https://cloud.google.com/free/docs/gcp-free-tier#always-free-usage-limits))  if the VM is located in a US region (excluding Northern Virginia [us-east4]) and configured ( or re-configured after deployment) with 1 f1-micro instanc and max 30 GB HDD. 

* A Google Cloud Storage (GCS) Bucket with its object default permission configured for allUsers. See this [plugin support response](https://wordpress.org/support/topic/google-storage-not-work/page/2/#post-8897852) on how to configure the  GCS bucket so that uploaded images are publicly available.

## Deployment Parameters
The Run on Google Cloud deployment will prompt for the environment variables "DB_HOST","DB_USER","DB_PASSWORD", "DB_NAME" & CLOUDSQL_INSTANCE.
 
* **"DB_HOST** is externally exposed IP address to access the MySQL database or the Cloud SQL host (The default value is "localhost")
 If you are using Cloud SQL set this to 127.0.0.1
 
* **"DB_USER"** is the MySQL or Cloud SQL  database username (The default value is "root")
 
* **"DB_PASSWORD"** is the MySQL or Cloud SQL database user password (The default value is "password")
 
* **"DB_NAME"** is the name of the database for WordPress on MySQL or Cloud SQL ( The default value is "wordpress")
 
* **"CLOUDSQL_INSTANCE"** if you using Cloud SQL, this is the Cloud SQL instance connection name that you get from Cloud SQL Overiew Tab. This should be provided in the  format **poject.id:region:instance-name**

  * CLOUDSQL_INSTANCE is not a required parameter. It can therefore be ignored if you are not using Cloud SQL.
 
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
        

 
 
 
## Post Deployment & GCS plugin

After deployment & installionton of Wordpress , sign into WP-ADMIN, go to plugins, activate the GCS plugin , go the GCS plugin settings and input the url of the GCS bucket.

## Creating, Editing Wordpress Pages & Site

This is done the same way it is done with any other type of Wordpress depolyment. 

Wordpress stores page & site content in the connected database ( on Cloud SQL or external MySQL) and the media files are stored in the GCS bucket configured in the GCS plugin . The site content & media will therefore survive / persist  when the  Cloud Run container scales down to zero. 

 

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

* You can also, from inside the wordpress directory, run the wp-cli command ```wp server``` to locally launch PHP's built-in web server and then use [Cloud Shell Web Preview feature](https://cloud.google.com/shell/docs/using-web-preview#previewing_the_application) to access the local version of the wordpress site. You can login to wordpress admin and update plugins or themes. 


* After locally updating plugins or themes, you need to rebuild the docker image, push it to cloud registry and then push (redeploy) the updated image to Cloud Run by running the following three commands:

        docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .
        
        docker push gcr.io/[PROJECT-ID]/wordpress-gcr

        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr
        
    
       In the above commands  [PROJECT-ID] is your gcp project-id.
       
       The command also assume that the Cloud Run Service name is unchange and remains wordpress-gcr.
       
       
  The proccess of rebuilding the docker image and redeploying it to the Cloud Run Service could be automated using [Cloud Build Triggers](https://cloud.google.com/run/docs/continuous-deployment?_ga=2.244497477.-1913607253.1558898014).

* The wordpress core can not be updated via this process. 
  * The initial deployment however uses latest wordpress image and the  [Dockerfile](https://github.com/lans-repos/wordpress-gcr/blob/master/Dockerfile) always pulls the latest wordpress docker image. 
  * **The wordpress core is therefore updated each time the image is rebuilt for re-deployment.**

## Cloud Run Custom Domain Mapping

If you decide to use Cloud Run Custom Domain mapping on the Wordpress deployment then you have to remember that Cloud Run only maps a  domain to /, but not to a specific base path. 

**This means a url path like https://yourcustomdomain.com/contact.php  will not be mapped !**

To get the custom domain to map to all url paths beyound /, you need to 

* Edit the wp-config.php files to add 


       define( 'WP_HOME', 'https://yourcustomdomain.com' ); 
        
       define( 'WP_SITEURL', 'https://yourcustomdomain.com/' );

            
    
    
 * Then rebuild the docker image, push it to cloud registry and then push (redeploy) the updated image to Cloud Run by running the following three commands:

        docker build -t gcr.io/[PROJECT-ID]/wordpress-gcr .
        
        docker push gcr.io/[PROJECT-ID]/wordpress-gcr

        gcloud beta run deploy wordpress-gcr  --image gcr.io/[PROJECT-ID]/wordpress-gcr

## Access Control

If , for security or cost management purposes, you need to control access to the site you can configure Cloud Run's [access mananging via IAM](https://cloud.google.com/run/docs/securing/managing-access) feature.

## Firebase & CDN Integration

Coming Soon :)

## Is Wordpress in Cloud Run Ideal?

That is a great question ! 

I will agree that Cloud Run's stateless container model makes Wordpress admin & update cumbersome and time consuming. Hence this  might only appeal to an enthustiast or a DevOps that likes over-engineered solutions.

I did however observe that [Wordpress on AppEngine](https://cloud.google.com/wordpress/#appengine) also uses a stateless severless architecture. I am therefore going to assume that stateless severless Wordpress does have some technically benefits. :)

WordPress on Cloud Run might be perfect & cheap for a site that gets periodic, unpredictable spikes of intense traffic. It will be non-ideal and  expensive(due to [Cloud Run's billing model](https://cloud.google.com/run/pricing#pricing_table)) for a site that gets regular and consistent traffic.









