FROM crystallang/crystal:0.24.1

# Install Dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y --no-install-recommends libpq-dev libsqlite3-dev libmysqlclient-dev libreadline-dev git curl vim netcat

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

WORKDIR /opt/maze

# Build Maze
ENV PATH /opt/maze/bin:$PATH
COPY . /opt/maze
RUN shards build maze

CMD ["crystal", "spec", "-D", "run_build_tests"]
