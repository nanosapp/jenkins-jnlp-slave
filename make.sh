#!/bin/sh
set -eux

IMAGE=${JENKINS_JNLP_IMAGE:-mgoltzsche/jenkins-jnlp-slave}

while [ $# -gt 0 ]; do
	case "$1" in
		build)
			docker build --force-rm -t $IMAGE .
		;;
		run)
			docker run -ti --rm --privileged $IMAGE
		;;
	esac
	shift
done
