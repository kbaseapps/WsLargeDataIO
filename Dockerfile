FROM kbase/kbase:sdkbase.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Insert apt-get instructions here to install
# any required dependencies for your module.

# RUN apt-get update

# update jars
RUN cd /kb/dev_container/modules/jars \
	&& git pull \
	&& . /kb/dev_container/user-env.sh \
	&& make deploy

# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module

# Fix for problem with lets-encript in Java (PKIX path building failed:
#   sun.security.provider.certpath.SunCertPathBuilderException: unable
#   to find valid certification path to requested target)
RUN keytool -import -keystore /usr/lib/jvm/java-7-oracle/jre/lib/security/cacerts -storepass changeit -noprompt \
    -trustcacerts -alias letsencryptauthorityx3 -file ./ssl/lets-encrypt-x3-cross-signed.der

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
