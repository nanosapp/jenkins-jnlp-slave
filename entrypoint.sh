#!/bin/sh

chown jenkins:jenkins /home/jenkins/.local/share/containers/storage &&

CGROUP="$(grep -E '^1:name=' /proc/self/cgroup | sed -E 's/^1:name=([^:]+):/\1/')"
mkdir -p "/sys/fs/cgroup/$CGROUP"

#exec gosu jenkins bash
exec gosu jenkins jenkins-slave "$@"
