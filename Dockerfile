FROM ubuntu:17.10

MAINTAINER Denis Torre <denis.torre@mssm.com>

RUN apt-get update && apt-get install -y python3
RUN apt-get update && apt-get install -y python3-pip
RUN apt-get update && apt-get install -y python3-dev
RUN apt-get update && apt-get install -y libmysqlclient-dev

RUN pip3 install --no-cache-dir notebook==5.*

#pip dependencies
RUN pip3 install numpy==1.14.2
RUN pip3 install pandas==0.22.0
RUN pip3 install Flask==0.12.2
RUN pip3 install sqlalchemy==1.2.5
RUN pip3 install flask-sqlalchemy==2.3.2
RUN pip3 install pymysql==0.8.0
RUN pip3 install nbformat==4.4.0
RUN pip3 install nbconvert==5.3.1
RUN pip3 install google-cloud==0.32.0
RUN pip3 install jupyter==1.0.0
RUN pip3 install jupyter_client==5.2.3
RUN pip3 install seaborn==0.8.1
RUN pip3 install plotly==2.5.0

#r and python dependencies
RUN apt-get update && apt-get install --allow-unauthenticated -y r-base
#tzlocal needed for rpy2
RUN pip3 install tzlocal 
RUN pip3 install rpy2==2.9.2
RUN pip3 install h5py==2.7.1
RUN pip3 install sklearn==0.0
RUN pip3 install qgrid==1.0.2
RUN pip3 install clustergrammer-widget==1.13.3
#r
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("limma");'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("edgeR");'
#wget
RUN apt-get update && apt-get install -y wget
RUN pip3 install matplotlib-venn==0.11.5

#biojupies directories
RUN mkdir /download; chmod 777 /download;
RUN mkdir /tmp; chmod 777 /tmp;

#creating temporary user join-user w/ id 1000
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

#cd to join-user directory
WORKDIR home/join-user

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
