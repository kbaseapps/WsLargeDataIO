FROM kbase/sdkpython:3.8.10
MAINTAINER KBase Developer
# -----------------------------------------
# Install any required dependencies for your module
RUN apt-get update \
	&& apt-get install -y wget unzip openjdk-8-jdk \
	&& echo java versions: \
	&& java -version \
	&& javac -version \
	&& echo $JAVA_HOME \
	&& ls -l /usr/lib/jvm \
	&& ln -s /usr/lib/jvm/java-8-openjdk-amd64 java \
	&& ls -l \
	&& rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN pip install configparser

# Clone KBase jars repository
RUN git clone https://github.com/kbase/jars /tmp/repo
RUN cp -r /tmp/repo/* /kb/deployment


# Download and install Apache Ant
ENV ANT_VERSION 1.10.13
ENV ANT_HOME /usr/local/ant

RUN wget https://downloads.apache.org/ant/binaries/apache-ant-${ANT_VERSION}-bin.zip && \
    unzip apache-ant-${ANT_VERSION}-bin.zip && \
    mv apache-ant-${ANT_VERSION} ${ANT_HOME} && \
    rm apache-ant-${ANT_VERSION}-bin.zip

ENV PATH $PATH:$ANT_HOME/bin
RUN ant -version
# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
