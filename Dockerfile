FROM debian:stable-slim

LABEL maintainer="Michael Nival <docker@mn-home.fr>" \
	name="debian-ntp" \
	description="Debian Stable with the package ntp" \
	docker.cmd="docker run -d -p 123:123/udp --cap-add=SYS_TIME --cap-add=SYS_RESOURCE --name ntp mnival/debian-ntp"

RUN printf "deb http://ftp.debian.org/debian/ stable main\ndeb http://ftp.debian.org/debian/ stable-updates main\ndeb http://security.debian.org/ stable/updates main\n" >> /etc/apt/sources.list.d/stable.list && \
	cat /dev/null > /etc/apt/sources.list && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt update && \
	apt -y --no-install-recommends full-upgrade && \
	addgroup --system ntp --gid 110 && \
	adduser --system --ingroup ntp --no-create-home ntp --uid 110 && \
	apt install -y --no-install-recommends ntp && \
	echo "UTC" > /etc/timezone && \
	rm /etc/localtime && \
	dpkg-reconfigure tzdata && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/alternatives.log /var/log/dpkg.log /var/log/apt/ /var/cache/debconf/*-old

ADD start-ntp /usr/local/bin/

ENV ntpconf.driftfile="/var/lib/ntp/ntp.drift"
ENV ntpconf.statistics="loopstats peerstats clockstats"
ENV ntpconf.filegen="loopstats file loopstats type day enable;peerstats file peerstats type day enable;clockstats file clockstats type day enable"
ENV ntpconf.pool="0.debian.pool.ntp.org iburst;1.debian.pool.ntp.org iburst;2.debian.pool.ntp.org iburst;3.debian.pool.ntp.org iburst"
ENV ntpconf.restrict="-4 default kod notrap nomodify nopeer noquery limited;-6 default kod notrap nomodify nopeer noquery limited;127.0.0.1;::1;source notrap nomodify noquery"
ENV ntpconf.logfile="/dev/stdout"
ENV ntp.uid=110
ENV ntp.gid=110
ENV ntp.args="-g"

EXPOSE 123/udp

ENTRYPOINT ["start-ntp"]
