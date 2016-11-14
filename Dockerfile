FROM kbase/kbase:sdkbase.latest
MAINTAINER Michael Sneddon (mwsneddon@lbl.gov)

RUN apt-get update
RUN apt-get install -y python-coverage
RUN pip install --upgrade ndg-httpsclient

# update installed WS client (will now include get_objects2)
RUN mkdir -p /kb/module && \
    cd /kb/module && \
    git clone https://github.com/kbase/workspace_deluxe && \
    cd workspace_deluxe && \
    git checkout f14c9eb && \
    rm -rf /kb/deployment/lib/biokbase/workspace && \
    cp -vr lib/biokbase/workspace /kb/deployment/lib/biokbase/workspace && \
    cd /kb/module && \
    rm -rf workspace_deluxe


# install cutadapt
RUN pip install cutadapt==1.11


COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
