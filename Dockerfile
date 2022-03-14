FROM nginx:1.21

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive TZ=Europe/Stockholm apt-get install \
		-y --no-install-recommends \
		git \
		fcgiwrap \
		apache2-utils \
		unzip \
	&& rm -rf /var/lib/apt/lists/*

COPY . /root/src

RUN cd /root/src \
	&& chmod +x create-repos.sh \
	&& ./create-repos.sh \
	&& cp -v /root/src/nginx.conf /etc/nginx/conf.d/git.conf \
	&& nginx -t \
	&& chmod +x /root/src/docker-entrypoint.d/* \
	&& cp -v /root/src/docker-entrypoint.d/* /docker-entrypoint.d/ \
	&& rm -rf /root/src
