FROM wordpress:5.2.2-php7.3-apache

RUN set -ex; \
    apt-get update && apt-get install -y \
        wget \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# テーマのダウンロード
WORKDIR /tmp/wp-themes
RUN wget https://wp-cocoon.com/download/791/cocoon-master-2.1.9.1.zip

# テーマを配置
RUN unzip './*.zip' -d /usr/src/wordpress/wp-content/themes

# 不要ファイル削除
RUN apt-get clean
RUN rm -rf /tmp/*

WORKDIR /usr/src/wp-plugins

RUN set -ex; \
    wget -q -O amazon-s3-and-cloudfront.zip https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.1.4.3.zip \
    && unzip -q -o '*.zip' -d /usr/src/wordpress/wp-content/plugins \
    && chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins \
    && rm -f '*.zip'

# 所有者の変更
RUN chown -R www-data:www-data /usr/src/wordpress/wp-content/themes

WORKDIR /var/www/html