#!/bin/bash

STARTUP_PROFILE="/etc/rc.d/rc.local"

cat >> ${STARTUP_PROFILE} << EOF
runuser -l veritas -c 'go run /home/veritas/compute/valengine.go > /var/log/veritas/valengine.log 2>&1 &'
EOF

chmod +x ${STARTUP_PROFILE}
