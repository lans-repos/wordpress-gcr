FROM wordpress:latest	

RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /var/www/html

RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://en-ca.wordpress.org/latest-en_CA.tar.gz"; \
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf *.tar.gz -C /usr/src/; \
	rm *.tar.gz; \
	chown -R www-data:www-data /usr/src/wordpress

COPY  wordpress/wp-content/plugins/  /usr/src/wordpress/wp-content/plugins/

COPY  wp-config.php  /usr/src/wordpress/

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]
