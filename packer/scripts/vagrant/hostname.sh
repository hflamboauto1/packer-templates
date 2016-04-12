#!/bin/bash

#
# hostname.sh
#
# Copyright 2016 Krzysztof Wilczynski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

readonly UBUNTU_VERSION=$(lsb_release -r | awk '{ print $2 }')
readonly HOSTNAME="ubuntu$(echo $UBUNTU_VERSION | tr -d '.')"
readonly IP_ADDRESS=$(hostname -I | cut -d' ' -f 1)

cat <<EOF > /etc/hosts
127.0.0.1 localhost.localdomain localhost loopback
${IP_ADDRESS} ${HOSTNAME}.localdomain ${HOSTNAME} ubuntu
EOF

chown root: /etc/hosts
chmod 644 /etc/hosts

echo $HOSTNAME | tee \
    /proc/sys/kernel/hostname \
    /etc/hostname \
    > /dev/null

chown root: /etc/hostname
chmod 644 /etc/hostname

echo 'localdomain' \
    > /proc/sys/kernel/domainname

hostname -F /etc/hostname
service rsyslog restart
