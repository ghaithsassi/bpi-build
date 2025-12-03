FROM	ubuntu:18.04

RUN	apt-get update && apt-get install -y \
	openjdk-8-jdk \
	git-core \
	gnupg \
	flex \
	bison \
	gperf \
	build-essential \
	zip \
	curl \
	zlib1g-dev \
	gcc-multilib \
	g++-multilib \
	libc6-dev-i386 \
	lib32ncurses5-dev \
	x11proto-core-dev \
	libx11-dev \
	lib32z-dev \
	ccache \
	libgl1-mesa-dev \
	libxml2-utils \
	xsltproc \
	unzip \
	python \
	cpio \
	locales \
	mkisofs \
	u-boot-tools \
	bc \
	gawk \
	busybox \
	openssh-server \
	vim \
  xz-utils

ADD	dtc /usr/bin/dtc


COPY gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz \
  gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf.tar.xz \
  gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.xz \
  gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz \
  /tmp/

RUN mkdir -p /opt && \
    for f in /tmp/*.tar.xz; do \
        tar -xJf "$f" -C /opt; \
    done && \
    rm /tmp/*.tar.xz

ENV PATH="/opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin:\
/opt/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf/bin:\
/opt/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin:\
/opt/gcc-linaro-arm-none-eabi-4.8-2014.04_linux/bin:${PATH}"

RUN	locale-gen en_US.UTF-8
ENV 	LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN	mkdir /var/run/sshd
RUN echo "root:1234" | chpasswd
RUN	sed -i 's/AcceptEnv LANG LC_*/#AcceptEnv LANG LC_*/g' /etc/ssh/sshd_config
RUN 	sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN 	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# Enable root login with password
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config


VOLUME	["/media"]

EXPOSE	22
CMD	["/usr/sbin/sshd", "-D"]
