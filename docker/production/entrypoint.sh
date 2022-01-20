#!/bin/bash

# ref: https://github.com/gliderlabs/docker-alpine/issues/42#issuecomment-173825611
# Tell openrc loopback and net are already there, since docker handles the networking
echo 'rc_provide="loopback net"' >> /etc/rc.conf
rc-service nginx start

cd /app
RAILS_ENV=production bin/rails db:migrate
bundle exec pumactl start