# DOCKER-VERSION 0.3.4
FROM        perl:5.18.4
MAINTAINER  Gonzalo Barco gonzalo.barco@globant.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus && cpanm Carton Starman

RUN cachebuster=c53b35 git clone https://github.com/gbarco/wsSingleCode.git
WORKDIR wsSingleCode
RUN cd wsSingleCode && carton install --deployment

EXPOSE 8080

CMD carton exec starman --port 8080 wsSingleCode/bin/wsSingleCode.pl
