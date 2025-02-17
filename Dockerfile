FROM python:3.6
MAINTAINER Marcos Federico Mandrille <mmandrille@gmail.com>

# Base installs
RUN apt-get update
RUN apt-get install -y libopenblas-dev gfortran

# Virtual Enviroment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Requierements installation
RUN pip install --upgrade pip
RUN pip install wheel
RUN pip install cython
RUN pip install requests
RUN pip install numpy==1.12.1
RUN pip install scipy==0.19.0
RUN pip install gunicorn==19.7.1
RUN pip install flask==0.12.2
RUN pip install image-match==1.1.2
RUN pip install "elasticsearch>=6.0.0,<7.0.0"
RUN rm -rf /var/lib/apt/lists/*

# Enviroment Variables, you can overwrite them
ENV PORT=80
ENV WORKER_COUNT=4
ENV TIMEOUT=60
ENV MAX_RETRIES=5
ENV ELASTICSEARCH_URL=http://localhost:9200
ENV ELASTICSEARCH_INDEX=images
ENV ELASTICSEARCH_DOC_TYPE=images
ENV ALL_ORIENTATIONS=true
ENV DEBUG_LEVEL=20

# Generate Matlib Cache
RUN python -c "import matplotlib as mpl"

# Copy files
COPY entrypoint.sh /
COPY wait_for_elastic.py  /
COPY server.py /

# Run:
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "/entrypoint.sh"]