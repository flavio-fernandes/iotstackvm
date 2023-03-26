# iotstackvm

Vagrant based VM to run [iotstack](https://sensorsiot.github.io/IOTstack/)

This repo offers an opinionated implementation of the
[IOT Stack VM](https://www.youtube.com/watch?v=_DO2wHI6JWQ), described [here](https://learnembeddedsystems.co.uk/easy-raspberry-pi-iot-server).

Ref links:

[Andreas Spiess -- Raspberry Pi4 Home Automation Server (incl. Docker, OpenHAB, HASSIO, NextCloud)](https://www.youtube.com/watch?v=KJRMjUzlHI8)

## Manual steps to complete installation

In the future, this can also be automated, but that is not yet implemented.

After **vagrant up**, do a **vagrant ssh**.

```bash
vagrant@iotstackvm:~$ sudo su - pi
pi@iotstackvm:~$ /vagrant/provision/iotStack.sh
```
and follow the install steps as described at [4:22 in the video](https://youtu.be/_DO2wHI6JWQ?t=262).
You will be asked to reboot the VM. Do so by invoking **vagrant reload** after exiting the ssh session.
Back in the system after reloading by doing **vagrant ssh**, follow the steps described at
[4:33 in the video](https://youtu.be/_DO2wHI6JWQ?t=273).

```bash
vagrant@iotstackvm:~$ sudo su - pi
pi@iotstackvm:~$ cd IOTstack/
pi@iotstackvm:~/IOTstack$ ./menu.sh
```

### Errata

In order to start node-red container in this VM, I needed to remove the devices section from
the generated `docker-compose.yml`

```bash
pi@iotstackvm:~/IOTstack$ diff -u docker-compose.yml.orig docker-compose.yml
--- docker-compose.yml.orig     2023-03-26 17:45:15.609704348 -0400
+++ docker-compose.yml  2023-03-26 17:46:08.247022774 -0400
@@ -108,8 +108,8 @@
     - ./volumes/nodered/ssh:/root/.ssh
     - /var/run/docker.sock:/var/run/docker.sock
     - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
-    devices:
-    - "/dev/ttyAMA0:/dev/ttyAMA0"
-    - "/dev/vcio:/dev/vcio"
-    - "/dev/gpiomem:/dev/gpiomem"
+    # devices:
+    # - "/dev/ttyAMA0:/dev/ttyAMA0"
+    # - "/dev/vcio:/dev/vcio"
+    # - "/dev/gpiomem:/dev/gpiomem"
```
