FROM debian:testing

## NB: No 'apt-get upgrade -y' in official images, see eg
## https://github.com/docker-library/official-images/pull/13443#issuecomment-1297829291
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ed \
        less \
        locales \
        vim-tiny \
        wget \
        ca-certificates \
        fonts-texgyre \
        procps

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Install apt packages for building R packages
RUN apt-get install -y --no-install-recommends \
    build-essential \
    libbz2-dev \
    libz-dev \
    && rm -rf /var/lib/apt/lists/*

# Add conda to $PATH
ENV PATH /opt/conda/bin:$PATH

# Install miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Update conda
RUN conda update -n base -c defaults conda

# Install mamba
RUN conda install --name base -c conda-forge mamba

# Install conda packages
RUN mamba create --name packages python=3.8
ENV PATH /opt/conda/envs/packages/bin:$PATH

# Install base R packages
RUN mamba install -y --name packages -c conda-forge r-base=4.2.*
RUN mamba install -y --name packages -c conda-forge r-essentials=4.*
RUN mamba install -y --name packages -c conda-forge r-devtools=2.4.*
RUN mamba install -y --name packages -c conda-forge r-biocmanager=1.30.*
RUN mamba install -y --name packages -c conda-forge r-catools=1.18.*
RUN mamba install -y --name packages -c conda-forge r-doparallel=1.0.*
RUN mamba install -y --name packages -c conda-forge r-nmf=0.21.*

# Install bioconductor packages from mamba
RUN mamba install -y --name packages -c bioconda bioconductor-gseabase=1.60.*
RUN mamba install -y --name packages -c bioconda bioconductor-biomart=2.54.*

# Install native for broken mamba packages
RUN R -e 'install.packages("stringi", repos = "https://cran.ma.imperial.ac.uk/")'
RUN R -e 'BiocManager::install("pcaExplorer", version = "3.16")'

# Terminate Docker build if key packages fail to load
RUN R -e 'library("pcaExplorer")'
