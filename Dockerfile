FROM jetty:9.4-jre11

LABEL "Organization"="geOrchestra"
LABEL "Description"="CAS server webapp"

RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,jmx-remote,stats,gzip,http-forwarded

VOLUME [ "/tmp", "/run/jetty" ]

EXPOSE 8080

COPY ./etc /etc
COPY build/cas /var/lib/jetty/webapps/cas

ENV XMS=256M XMX=1G

CMD ["sh", "-c", "exec java \
        -Djava.io.tmpdir=/tmp/jetty \
        -Dgeorchestra.datadir=/etc/georchestra \
        -Xms$XMS -Xmx$XMX \
        -XX:-UsePerfData \
        ${JAVA_OPTIONS} \
        -DCAS_BANNER_SKIP=true \
        -DCAS_UPDATE_CHECK_ENABLED=true \
        -Dcas.standalone.configurationDirectory=/etc/georchestra/cas/config \
        -Djetty.httpConfig.sendServerVersion=false \
        -Djetty.jmxremote.rmiregistryhost=0.0.0.0 \
        -Djetty.jmxremote.rmiserverhost=0.0.0.0 \
        -jar /usr/local/jetty/start.jar"]

