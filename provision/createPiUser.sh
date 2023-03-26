#!/usr/bin/env bash
#

[ $EUID -eq 0 ] || { echo 'must be root' >&2; exit 1; }

set -o errexit
set -o xtrace

groupadd pi && \
useradd --gid pi --groups pi,users,adm --shell /bin/bash  -c "pi" --create-home pi

cat <<EOT >> /etc/sudoers.d/90-pi
pi ALL=(ALL) NOPASSWD:ALL
EOT

usermod -aG sudo pi

cat <<EOT >> /home/vagrant/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc0+YDghqqiQES78/ej32bdch2A3sUAJto16y1WaHvJoS7PhyvMyWp3vmoe2QISgeyg+uBpxHqT6qMVg8OTeAXsM2PVjoUFnlSchHZ037zwe8dInYE+ndWcVk67L6awuRT6jMUqAHyZXo4907VpxcGLIcfyKcGBOGDf38/JXmVkFLddG3oH0wx1EdMv9gqMSaoSr2R+rrwscjRV8odK3B/IUXojSz/E5jLyXZmZ4rvKHx797B0cB8wqZ+bNQSRYy8jkdRIN+RH6L4BwYgfT5qNDXTV8HGNGD5fuMSMr+2lWq2oSeaJS7+WZE+DAKH7rIDPzy4i4QSJS/FW/EMDls51 gute@gutes-MacBook.local
EOT

# Copy keys used by vagrant user to pi user
(cd /home/vagrant ; tar cSf - .ssh ) | ( cd /home/pi ; tar xSvfp - ) ; chown -R pi:pi ~pi/.ssh

cat << EOT >> /home/pi/.emacs
;; use C-x g for goto-line
(global-set-key "\C-xg" 'goto-line)
(setq line-number-mode t)
(setq column-number-mode t)
(setq make-backup-files nil)

;; tabs are evail
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq-default c-basic-offset 4)
EOT
chown pi:pi /home/pi/.emacs

cat << EOT >> /home/pi/.vimrc
set expandtab
set tabstop=2
set shiftwidth=2
EOT
chown pi:pi /home/pi/.vimrc
