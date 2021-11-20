# syntax=docker/dockerfile:1
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"
ENV POSTEGRE_VERSION="14"

# Install GPG tools to add PostgreSQL PGP key
RUN apt-get update && apt-get install -y curl ca-certificates gnupg

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null

# Add PostgreSQL's repository. It contains the most recent stable release of PostgreSQL.
RUN export UBUNTU_CODE_NAME=$(lsb_release  -sc || cat /etc/*-release|grep -oP  'CODENAME=\K\w+$'|head -1) && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ ${UBUNTU_CODE_NAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL ${POSTEGRE_VERSION}
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y software-properties-common \
    postgresql-${POSTEGRE_VERSION} postgresql-client-${POSTEGRE_VERSION} postgresql-contrib-${POSTEGRE_VERSION}

# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-${POSTEGRE_VERSION}`` package when it 
#   was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/${POSTEGRE_VERSION}/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/${POSTEGRE_VERSION}/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/${POSTEGRE_VERSION}/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD /usr/lib/postgresql/${POSTEGRE_VERSION}/bin/postgres -D /var/lib/postgresql/${POSTEGRE_VERSION}/main -c \
config_file=/etc/postgresql/${POSTEGRE_VERSION}/main/postgresql.conf
