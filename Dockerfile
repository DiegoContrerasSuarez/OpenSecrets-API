FROM rocker/r-ver:4.3.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('plumber','DBI','RSQLite','dplyr','readr'), repos='https://cloud.r-project.org')"

WORKDIR /app

COPY . /app

EXPOSE 7860

CMD ["R", "-e", "pr <- plumber::pr('app.R'); pr$run(host='0.0.0.0', port=7860)"]