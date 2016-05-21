FROM ubuntu:xenial 
MAINTAINER Chris Smith <chris87@gmail.com> 

RUN apt-get update \
 && apt-get install -y \
      curl \
      inotify-tools

COPY letsencrypt.sh run.sh config.sh /
RUN chmod +x /run.sh /letsencrypt.sh

VOLUME ["/letsencrypt"]

ENTRYPOINT ["/bin/bash"]
CMD ["/run.sh"]

