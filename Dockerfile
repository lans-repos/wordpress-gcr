#pulls the wordpress docker image so as to use the lastest wordpress supported php-apache version
FROM wordpress:latest	

# expose PORT 8080
EXPOSE 8080

# Use the PORT environment variable in Apache configuration files.
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

#specify container volume path
VOLUME /var/www/html

# downloads the latest version of wordpress from wordpress.org
RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://wordpress.org/latest.tar.gz"; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf *.tar.gz -C /usr/src/; \
	rm *.tar.gz; \
	chmod +x docker-entrypoint.sh; \
	chown -R www-data:www-data /usr/src/wordpress


# wordpress conf
COPY  wp-config.php  /usr/src/wordpress/

#docker-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/


ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]
