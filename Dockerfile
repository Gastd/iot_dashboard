# time docker build -t rosjoy .
FROM node:latest

RUN apt-get update && apt-get install -y \
    python g++ make gcc \
    software-properties-common \
    apt-utils \
    wget \
    apt-utils \
    ca-certificates

#Add basic user
#ENV USERNAME aluno
#ENV PULSE_SERVER /run/pulse/native
#RUN useradd -m $USERNAME && \
#    echo "$USERNAME:$USERNAME" | chpasswd && \
#    usermod --shell /bin/bash $USERNAME && \
#    usermod -aG sudo $USERNAME && \
#    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
#    chmod 0440 /etc/sudoers.d/$USERNAME && \
#    # Replace 1000 with your user/group id
#    usermod  --uid 1000 $USERNAME && \
#    groupmod --gid 1000 $USERNAME

#USER root
# Intall some basic CLI tools
RUN apt-get install -y \
    curl \
    screen \
    byobu \
    fish \
    git \
    glances \
    iputils-ping \
    net-tools \
    sudo 

CMD ["bash"]

# Intall some basic GUI and sound libs
RUN apt-get install -y \
        xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
        fonts-dejavu fonts-liberation hicolor-icon-theme \
        libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
        libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
        libgl1-mesa-glx libgl1-mesa-dri \
    && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX

# Intall some basic GUI tools
RUN apt-get install -y \
    cmake \
    gem

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN set -eux; \
    mkdir -p /usr/local/etc; \
    { \
        echo 'install: --no-document'; \
        echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc

ENV RUBY_MAJOR 2.7
ENV RUBY_VERSION 2.7.0
ENV RUBY_DOWNLOAD_SHA256 27d350a52a02b53034ca0794efe518667d558f152656c2baaf08f3d0c8b02343

# some of ruby's build scripts are written in ruby
#   we purge system ruby later to make sure our final image uses what we just built
RUN set -eux; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        bison \
        dpkg-dev \
        libgdbm-dev \
        ruby \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz"; \
    echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum --check --strict; \
    \
    mkdir -p /usr/src/ruby; \
    tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1; \
    rm ruby.tar.xz; \
    \
    cd /usr/src/ruby; \
    \
# hack in "ENABLE_PATH_CHECK" disabling to suppress:
#   warning: Insecure world writable dir
    { \
        echo '#define ENABLE_PATH_CHECK 0'; \
        echo; \
        cat file.c; \
    } > file.c.new; \
    mv file.c.new file.c; \
    \
    autoconf; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    ./configure \
        --build="$gnuArch" \
        --disable-install-doc \
        --enable-shared \
    ; \
    make -j "$(nproc)"; \
    make install; \
    \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark > /dev/null; \
    find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
        | awk '/=>/ { print $(NF-1) }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual \
    ; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
    cd /; \
    rm -r /usr/src/ruby; \
# verify we have no "ruby" packages installed
    ! dpkg -l | grep -i ruby; \
    [ "$(command -v ruby)" = '/usr/local/bin/ruby' ]; \
# rough smoke test
    ruby --version; \
    gem --version; \
    bundle --version

# don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH
# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

CMD [ "irb" ]

ENV USERNAME node
ENV PULSE_SERVER /run/pulse/native
RUN echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod  --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME

USER root

#RUN cd /home/node
#RUN mkdir /home/node/iot_dashboard
COPY . /iot_dashboard
WORKDIR /iot_dashboard
RUN npm install
WORKDIR /iot_dashboard
RUN gem install bundler
EXPOSE 3000
EXPOSE 3001
WORKDIR /iot_dashboard
RUN bundle install
WORKDIR /iot_dashboard
CMD ["bundle install"]

# docker run -it iot_dash
