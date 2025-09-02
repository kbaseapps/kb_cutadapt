FROM kbase/sdkpython:3.8.0
MAINTAINER KBase Developer

# Upgrade pip tooling & keep coverage
RUN python3 -m pip install -U pip setuptools wheel && \
    python3 -m pip install coverage

# System packages: pigz for fast multi-core gzip
RUN apt-get update && apt-get install -y --no-install-recommends \
      pigz ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Cutadapt 4.9 (wheels available on PyPI)
RUN python3 -m pip install --no-cache-dir "cutadapt==4.9" && \
    cutadapt --version

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module
RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]
CMD [ ]

