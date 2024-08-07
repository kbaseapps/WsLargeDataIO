FROM kbase/sdkpython:3.8.10
MAINTAINER KBase Developer
# -----------------------------------------
# Install any required dependencies for your module
RUN apt-get update \
	&& apt-get install -y ant openjdk-8-jdk \
	&& echo java versions: \
	&& java -version \
	&& javac -version \
	&& echo $JAVA_HOME \
	&& ls -l /usr/lib/jvm \
	&& rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN pip install configparser

# Set ANT_HOME environment variable and verify Ant installation
ENV ANT_HOME=/usr/share/ant
RUN ant -version

# Clone KBase jars repository
RUN git clone https://github.com/kbase/jars /tmp/repo
RUN mv /tmp/repo/* /kb/deployment && rm -r /tmp/repo
# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
