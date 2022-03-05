FROM rocker/geospatial:4.1.2
RUN apt-get update && apt-get install -y cron freetds-dev tdsodbc gdal-bin git-core libcurl4-openssl-dev libgdal-dev libgeos-dev libgeos++-dev libgit2-dev libicu-dev libjq-dev libpng-dev libproj-dev libprotobuf-dev libssl-dev libudunits2-dev libv8-dev libxml2-dev make pandoc pandoc-citeproc protobuf-compiler libprotoc-dev unixodbc-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*
  RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.6.2")'
RUN Rscript -e 'remotes::install_version("DBI",upgrade="never", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.8")'
RUN Rscript -e 'remotes::install_version("fs",upgrade="never", version = "1.5.2")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.1")'
RUN Rscript -e 'remotes::install_version("geojsonsf",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("leaflet",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.2.0")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.8.0")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.1.2")'
RUN Rscript -e 'remotes::install_version("here",upgrade="never", version = "1.0.1")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("waiter",upgrade="never", version = "0.2.5")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.2")'
RUN Rscript -e 'remotes::install_version("odbc",upgrade="never", version = "1.3.3")'
RUN Rscript -e 'remotes::install_version("geojsonio",upgrade="never", version = "0.9.4")'
RUN Rscript -e 'remotes::install_version("reactable",upgrade="never", version = "0.2.3")'
RUN Rscript -e 'remotes::install_version("leaflet.extras",upgrade="never", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("janitor",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_github("r-spatial/sf")'
RUN Rscript -e 'remotes::install_github("Thinkr-open/golem")'
RUN Rscript -e 'remotes::install_github("RinteRface/bs4Dash")'
RUN Rscript -e 'remotes::install_github("dbca-wa/wastdr", upgrade = "always", force=TRUE)'
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN R -e 'remotes::install_local(upgrade="always", force=TRUE, dependencies = TRUE)'

# Mount a volume to /app/inst that is shared with turtleviewer2
RUN mkdir -p /app/inst

# Initiate cronjob
RUN crontab cron/cronjob

# Run command on container startup
CMD echo "cronjob gets started" &&\
  (cron) &&\
  echo "now touch n' tail" &&\
  touch /app/inst/cron.log &&\
  tail -f /app/inst/cron.log