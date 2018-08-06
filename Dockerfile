FROM ubuntu:17.10

MAINTAINER Denis Torre <denis.torre@mssm.com>

RUN apt-get update && apt-get install -y python3
RUN apt-get update && apt-get install -y python3-pip
RUN apt-get update && apt-get install -y python3-dev
RUN apt-get update && apt-get install -y libmysqlclient-dev

RUN pip3 install --no-cache-dir notebook==5.*

RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install Flask
RUN pip3 install sqlalchemy
RUN pip3 install flask-sqlalchemy
RUN pip3 install pymysql
RUN pip3 install nbformat
RUN pip3 install nbconvert
RUN pip3 install google-cloud
RUN pip3 install jupyter
RUN pip3 install jupyter_client

RUN pip3 install seaborn
RUN pip3 install plotly

RUN apt-get update && apt-get install --allow-unauthenticated -y r-base

#dependencies for rpy2
RUN pip3 install tzlocal
RUN pip3 install rpy2 
RUN pip3 install h5py
RUN pip3 install sklearn
RUN pip3 install qgrid
RUN pip3 install clustergrammer-widget

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("limma");'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("edgeR");'

RUN apt-get update && apt-get install -y wget

RUN pip3 install matplotlib-venn

RUN mkdir /download; chmod 777 /download;

ENV NB_USER join-user
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

WORKDIR home/join-user
# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]