FROM nanosapp/podman-static:1.6.3-2 AS podman

FROM jenkins/jnlp-slave:alpine
USER root
RUN apk add --no-cache iptables shadow-uidmap
COPY --from=podman /usr/local/bin/* /usr/local/bin/
COPY --from=podman /usr/libexec/podman /usr/libexec/podman
COPY --from=podman /etc/containers /etc/containers
RUN mkdir -p /home/jenkins/.local/share/containers/storage \
	&& chown -R jenkins:jenkins /home/jenkins
VOLUME /home/jenkins/.local/share/containers/storage
RUN wget https://github.com/containernetworking/plugins/releases/download/v0.8.3/cni-plugins-linux-amd64-v0.8.3.tgz -O /tmp/cni-plugins.tgz && \
  mkdir -p /usr/local/lib/cni && cd /usr/local/lib/cni && tar -xvf /tmp/cni-plugins.tgz
#COPY etc/containers/storage.conf /etc/containers/storage.conf
RUN usermod -v 10000-65536 -w 10000-65536 jenkins
RUN echo "runtime = \"/usr/local/bin/crun\"" > /etc/containers/libpod.conf
RUN echo "cgroup_manager = \"cgroupfs\"" >> /etc/containers/libpod.conf
RUN echo "jenkins:10000:55537" > /etc/subuid
RUN echo "jenkins:10000:55537" > /etc/subgid
COPY entrypoint.sh /
COPY docker /usr/local/bin/
ENTRYPOINT [ "/entrypoint.sh" ]
