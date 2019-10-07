FROM wordpress:5.5.1

# Install tools
RUN apt-get update
RUN apt-get -y --force-yes -o Dpkg::Options::="--force-confdef" install wget curl unzip python python-pip jq
RUN pip install awscli

# Wait DB
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /usr/local/bin/
RUN chmod +x /usr/local/bin/wait

# Install plugins
WORKDIR /tmp/wp-plugins
RUN wget https://downloads.wordpress.org/plugin/svg-support.2.3.18.zip
RUN wget https://downloads.wordpress.org/plugin/easy-fancybox.zip
RUN wget https://downloads.wordpress.org/plugin/google-analytics-for-wordpress.7.12.2.zip
RUN wget https://downloads.wordpress.org/plugin/google-sitemap-generator.4.1.1.zip
RUN wget https://downloads.wordpress.org/plugin/php-text-widget.zip
RUN wget https://downloads.wordpress.org/plugin/tinymce-advanced.5.5.0.zip
RUN wget https://downloads.wordpress.org/plugin/wp-multibyte-patch.2.9.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-web-services.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.4.4.zip
RUN wget https://downloads.wordpress.org/plugin/jetpack.8.9.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-associates-link-builder.1.9.3.zip
RUN wget https://downloads.wordpress.org/plugin/siteguard.1.5.2.zip
RUN wget https://downloads.wordpress.org/plugin/enlighter.4.3.1.zip

RUN unzip './*.zip' -d /usr/src/wordpress/wp-content/plugins

# Install themes
WORKDIR /tmp/themes
RUN wget https://s3-ap-northeast-1.amazonaws.com/tsukaby.techblog/stinger5ver20150505b.zip
RUN unzip './*.zip' -d /usr/src/wordpress/wp-content/themes

# Download lang files
WORKDIR /usr/src/wordpress/wp-content/
RUN wget https://downloads.wordpress.org/translation/core/5.5/ja.zip && \
  unzip ja.zip -d languages/ && rm ja.zip

RUN echo 'RemoteIPHeader X-Forwarded-For' > /etc/apache2/conf-available/remoteip-cloudfront.conf && \
  curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="CLOUDFRONT") | "RemoteIPTrustedProxy \(.ip_prefix)"' >> /etc/apache2/conf-available/remoteip-cloudfront.conf && \
  a2enconf remoteip-cloudfront;

# Change owner
RUN chown -R www-data:www-data /usr/src/wordpress/wp-content

WORKDIR /var/www/html
