#!/bin/bash
set -euo pipefail

BASHRC="${HOME}/.bashrc"
DOCKER_SOURCE='source /.singularity.d/env/10-docker2singularity.sh'
LIB_EXPORT='export LD_LIBRARY_PATH="/.singularity.d/libs"'

[ -f "$BASHRC" ] || touch "$BASHRC"
grep -qxF "$DOCKER_SOURCE" "$BASHRC" || echo "$DOCKER_SOURCE" >> "$BASHRC"
grep -qxF "$LIB_EXPORT" "$BASHRC" || echo "$LIB_EXPORT" >> "$BASHRC"

# Fakeroot fixes for Singularity
sed -i 's/^sshd:x:100:65534:/sshd:x:0:0:/' /etc/passwd 2>/dev/null || true
(
cat > /usr/local/bin/tar << 'EOF'
#!/bin/bash
exec /bin/tar --no-same-owner "$@"
EOF
chmod +x /usr/local/bin/tar
) 2>/dev/null || true

mkdir -p ~/hostkeys
[ -f ~/hostkeys/ssh_host_rsa_key ] || ssh-keygen -q -N "" -t rsa -b 4096 -f ~/hostkeys/ssh_host_rsa_key

exec /usr/sbin/sshd -D -p 2222 \
    -o PermitUserEnvironment=yes \
    -o PermitTTY=yes \
    -o X11Forwarding=yes \
    -o AllowTcpForwarding=yes \
    -o GatewayPorts=yes \
    -o ForceCommand=/bin/bash \
    -o UsePAM=no \
    -h ~/hostkeys/ssh_host_rsa_key
