ARG INTERVAL=10

FROM base/archlinux:latest AS builder
MAINTAINER hare1039 hare1039@hare1039.nctu.me

RUN pacman -Syy &&\
    pacman -S --needed --noconfirm git base-devel

RUN useradd --create-home --shell /bin/bash hare &&\
    echo "hare ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN git clone https://aur.archlinux.org/megatools.git megatools &&\
    chmod 777 megatools                                         &&\
    cd megatools                                                &&\
    sudo -u hare bash -c 'yes y | makepkg -sicr'

FROM base/archlinux:latest
MAINTAINER hare1039 hare1039@hare1039.nctu.me
ARG INTERVAL

RUN pacman -Syy &&\
    pacman -S --needed --noconfirm git python3 jq htop cronie &&\
    curl https://getcaddy.com | bash -s personal              &&\
    bash -c 'echo "zh_TW.UTF-8 UTF-8" >> /etc/locale.gen'     &&\
    bash -c 'echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen'     &&\
    bash -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'     &&\
    locale-gen

COPY --from=builder /megatools/megatools-1.10.2-1-x86_64.pkg.tar.xz /tmp/megatools-1.10.2-1-x86_64.pkg.tar.xz

RUN cd /tmp                                                    &&\
    pacman -U --noconfirm megatools-1.10.2-1-x86_64.pkg.tar.xz &&\
    cd /                                                       &&\
    git clone https://github.com/hare1039/gdrivedl.git         &&\
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py    &&\
    python get-pip.py                                          &&\
    pip install selenium

VOLUME ["/anime-updater", "/mnt"]

RUN bash -c "echo '*/${INTERVAL} * * * * bash -c /anime-updater/trace.sh &>/dev/null' | crontab"

COPY Caddyfile /Caddyfile

EXPOSE 80 443

ENTRYPOINT ["bash", "-c", "crond -P /usr/bin:/bin:/usr/sbin; caddy -conf /Caddyfile"]