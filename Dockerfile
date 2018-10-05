FROM rocker/r-base
MAINTAINER Alexey Kuzmenkov <kuzmenkov111@mail.ru>

RUN useradd plumber \
    && mkdir /home/plumber \
    && chown plumber:plumber /home/plumber \
    && addgroup plumber staff \
  && mkdir /home/plumber/data \
  && chown -R plumber /home/plumber/data

COPY install.R /home/plumber/install.R  
COPY install.R /home/plumber/utils.R
COPY my4model /home/plumber/my4model

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  python-pip \
  libhdf5-dev

RUN pip install numpy scipy
RUN pip install virtualenv


RUN R -e 'install.packages(c("devtools"))'\
&& R -e 'devtools::install_github("trestletech/plumber")' \
&& R -e "install.packages('rjson', repos='https://cran.r-project.org/')" \
&& R -e 'devtools::install_github("rstudio/reticulate")' \
&& R -e 'devtools::install_github("rstudio/tensorflow")' \
&& R -e 'devtools::install_github("rstudio/keras")' \
&& R -e 'setwd("/home/plumber"); source("install.R"); source("utils.R"); tensorflow::install_tensorflow(version = "1.5.0", extra_packages = "keras")'


VOLUME /home/plumber
EXPOSE 8000
CMD ["R", "-e", "setwd('/home/plumber'); r <- plumber::plumb('api.R'); r$run(host='0.0.0.0', port=8000)"]
