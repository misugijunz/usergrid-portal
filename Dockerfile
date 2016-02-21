# use same ubuntu version as java container
FROM yep1/usergrid-java

RUN \
  apt-get update && \
  \
  echo "++ build usergrid portal" && \
  apt-get install -y npm git-core nodejs-legacy phantomjs && \
  git clone --single-branch --branch master --depth 1 \
      https://github.com/apache/usergrid.git /root/usergrid && \
  cd /root/usergrid/portal && \
  npm install -g grunt-cli && \
  ./build.sh && \
  mv /root/usergrid/portal/dist/usergrid-portal/* /var/www/html && \
  chown -R www-data:www-data /var/www/html && \
  \
  echo "+++ cleanup" && \
  rm -rf /root/usergrid && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get purge -y npm git-core nodejs-legacy phantomjs &&\
  apt-get autoremove -y && \
  apt-get clean -y

EXPOSE 8989

COPY run.sh /root/run.sh
CMD /root/run.sh
