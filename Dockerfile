FROM wordpress:5.2.3

# Install tools
RUN apt-get update
RUN apt-get -y --force-yes -o Dpkg::Options::="--force-confdef" install wget curl unzip python python-pip jq
RUN pip install awscli

# Install plugins
WORKDIR /tmp/wp-plugins
RUN wget https://downloads.wordpress.org/plugin/svg-support.2.3.15.zip
RUN wget https://downloads.wordpress.org/plugin/easy-fancybox.zip
RUN wget https://downloads.wordpress.org/plugin/google-analytics-for-wordpress.7.8.2.zip
RUN wget https://downloads.wordpress.org/plugin/google-sitemap-generator.4.1.0.zip
RUN wget https://downloads.wordpress.org/plugin/php-text-widget.zip
RUN wget https://downloads.wordpress.org/plugin/tinymce-advanced.5.2.1.zip
RUN wget https://downloads.wordpress.org/plugin/wp-multibyte-patch.2.8.2.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-web-services.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.2.2.1.zip
RUN wget https://downloads.wordpress.org/plugin/jetpack.7.8.zip
RUN wget https://downloads.wordpress.org/plugin/amazon-associates-link-builder.1.9.3.zip
RUN wget https://downloads.wordpress.org/plugin/siteguard.1.4.3.zip
RUN wget https://downloads.wordpress.org/plugin/enlighter.3.10.0.zip

RUN unzip './*.zip' -d /usr/src/wordpress/wp-content/plugins

# Install themes
WORKDIR /tmp/themes
RUN wget https://s3-ap-northeast-1.amazonaws.com/tsukaby.techblog/stinger5ver20150505b.zip
RUN unzip './*.zip' -d /usr/src/wordpress/wp-content/themes

# Download lang files
WORKDIR /usr/src/wordpress/wp-content/
RUN wget https://downloads.wordpress.org/translation/core/5.2/ja.zip && \
  unzip ja.zip -d languages/ && rm ja.zip

RUN echo 'RemoteIPHeader X-Forwarded-For' > /etc/apache2/conf-available/remoteip-cloudfront.conf && \
  curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="CLOUDFRONT") | "RemoteIPTrustedProxy \(.ip_prefix)"' >> /etc/apache2/conf-available/remoteip-cloudfront.conf && \
  a2enconf remoteip-cloudfront;

# Change owner
RUN chown -R www-data:www-data /usr/src/wordpress/wp-content

WORKDIR /var/www/html
