# Ubuntu Maestrano base image

FROM maestrano/b-ubuntu:14.04

MAINTAINER Cesar Tonnoir <it@maestrano.com>

# Copy chef files
RUN touch /var/log/chef/s-install.log
COPY mno/chef/s-install-config.rb /mno/chef/
COPY mno/chef/s-install-attributes.json /mno/chef/

# Install cookbooks
RUN git clone https://github.com/maestrano/cookbook-phpmysql.git /mno/chef/cache/cookbooks/phpmysql
RUN berks install -b /mno/chef/cache/cookbooks/phpmysql/Berksfile
RUN berks package -b /mno/chef/cache/cookbooks/phpmysql/Berksfile /mno/chef/cookbook-phpmysql.tar.gz

# Run chef to install php-fpm, nginx, etc
RUN chef-solo -c /mno/chef/s-install-config.rb && \
	rm mno/chef/cookbook-phpmysql.tar.gz

CMD ["/bin/bash"]