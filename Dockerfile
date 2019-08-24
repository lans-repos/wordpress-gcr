#pulls the wordpress docker image get lastest phpX.X-apache image
FROM wordpress:latest	

# expose PORT 8080
EXPOSE 8080

# Use the PORT environment variable in Apache configuration files.
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

#specify container volume path
VOLUME /var/www/html

# downloads the latest version of wordpress files  from wordpress.org
RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://wordpress.org/latest.tar.gz"; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf *.tar.gz -C /usr/src/; \
	rm *.tar.gz; \
        chown -R www-data:www-data /usr/src/wordpress
# download zip and unzip        
RUN apt-get update && apt-get install -y unzip zip net-tools wget ;

# download and install cloud_sql_proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy;
RUN chmod +x /usr/local/bin/cloud_sql_proxy;

# downloand the Google Cloud Storage plugin for wordpress from wordpress.org	
RUN curl -o gcs.zip -L "https://downloads.wordpress.org/plugin/gcs.0.1.4.zip" ; \
    unzip gcs.zip -d /usr/src/wordpress/wp-content/plugins/; \
    rm gcs.zip;
       
#docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh; 

# wordpress conf
COPY  wp-config.php  /usr/src/wordpress/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]
