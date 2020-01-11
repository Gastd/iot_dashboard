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

USER node

RUN cd /home/node
RUN mkdir /home/node/iot_dashboard
COPY . /home/node/iot_dashboard
RUN cd iot_dashboard
RUN apt-get install -y nodejs make 
#RUN npm install
#RUN gem install bundler
#RUN bundle install

# docker run -it iot_dash
