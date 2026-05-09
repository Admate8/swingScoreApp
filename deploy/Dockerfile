FROM rocker/verse:4.5.3

# System dependencies
RUN apt-get update -y && apt-get install -y \
    libpq-dev libicu-dev cmake make libuv1-dev \
    libcurl4-openssl-dev libssl-dev pandoc zlib1g-dev \
    libmagick++-dev gsfonts git \
    && rm -rf /var/lib/apt/lists/*

# R options
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(renv.config.pak.enabled = FALSE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" \
    | tee /usr/local/lib/R/etc/Rprofile.site \
    | tee /usr/lib/R/etc/Rprofile.site

# Install renv and restore packages
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("renv", version = "1.0.3")'
COPY renv.lock.prod renv.lock
RUN R -e 'renv::restore()'

# Copy and install app
COPY swingScore_*.tar.gz /app.tar.gz
RUN R -e 'remotes::install_local("/app.tar.gz", upgrade="never")'
RUN rm /app.tar.gz

EXPOSE 7860

CMD R -e "options('shiny.port'=7860, shiny.host='0.0.0.0'); library(swingScore); swingScore::run_app()"
