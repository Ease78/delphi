FROM        ubuntu:18.04
CMD         bash

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get -y install \
      apt-utils \
      build-essential \
      pkg-config \
      cmake \
      time \
      curl \
      git \
      tar \
      wget \
      python3 \
      doxygen \
      openjdk-8-jdk \
      libgraphviz-dev \
      graphviz \
      nlohmann-json-dev \
      libsqlite3-dev \
      libboost-all-dev \
      libeigen3-dev \
      libspdlog-dev \
      pybind11-dev \
      libfmt-dev \
      librange-v3-dev \
    && git clone https://github.com/ml4ai/delphi \
    && curl http://vanga.sista.arizona.edu/delphi_data/delphi.db -o delphi/data/delphi.db


# Set up virtual environment
ENV VIRTUAL_ENV=/delphi_venv
RUN apt-get install -y python3-venv
RUN python3.6 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set the environment variable DELPHI_DB to point to the SQLite3 database.
ENV DELPHI_DB=/delphi/data/delphi.db
ENV MODEL_FILES=/delphi/data/source_model_files
WORKDIR /delphi
RUN pip install wheel && \
    pip install scipy \
      matplotlib \
      pandas \
      seaborn \
      sphinx \
      sphinx-rtd-theme \
      recommonmark \
      ruamel.yaml \
      breathe \
      exhale \
      pytest \
      pytest-cov \
      pytest-sugar \
      pytest-xdist \
      plotly \
      sympy \
      flask \
      flask-WTF \
      flask-codemirror \
      salib \
      torch \
      tqdm \
      SQLAlchemy \
      flask-sqlalchemy \
      flask-executor \
      python-dateutil

COPY scripts/install_cmake_from_source.sh scripts/
RUN apt install sudo\
&& ./scripts/install_cmake_from_source.sh\
&& git clone https://github.com/nlohmann/json && cd json && mkdir build\
&& cd build && cmake .. && make -j && make -j install 
COPY lib/* lib
