# firewalld-close-ports-make-vm-secure

# 🚀 Close down firewalld ports and make VM more secure 🚀


https://github.com/coding-to-music/firewalld-close-ports-make-vm-secure

From / By 


## GitHub

```java
git init
git add .
git remote remove origin
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:coding-to-music/firewalld-close-ports-make-vm-secure.git
git push -u origin main
```

https://stackoverflow.com/questions/60151640/kdevtmpfsi-using-the-entire-cpu#60185198


Ok I've been facing the same issue as a lot of you. But my process was running as a postgres user. I suspect it was because I had opened up all incoming connections.

Yeah sure, my bad.

After trying all the solutions above none seemed to fix it permanently. It just kept spawning again with a slightly different name. No luck at all really.

## First - protect agaisnt any other connections.

First things first, restrict connections in the postgres config file.

Usually found here. `/etc/postgresql/12/main/postgresql.conf`

## Create a script to kill and remove kdevtmpfsi

Then create a new bash script in a location of your choosing..

```bash
nano kill.sh
```

Populate the file with the below.

```bash
#!/bin/bash

kill $(pgrep kdevtmp)
kill $(pgrep kinsing)
find / -iname kdevtmpfsi -exec rm -fv {} \;
find / -iname kinsing -exec rm -fv {} \;
rm /tmp/kdevtmp*
rm /tmp/kinsing*
```
press ctrl + c to exit

`kill` will kill the process and the next 4 commands should delete the file(s).

We need to make the file executable with

```bash
chmod +x kill.sh
```

run via

```
sudo bash kill-kinsing.sh
```

## Set it to run on schedule
Ok great now if we set this up as a cron job to run every minute it should help solve the issue. (not an elegant solution but it works)

```bash
sudo crontab -e
```

The above command opens the crontab, a place were we can define scheduled tasks to run at set intervals.

Append this to the end.

```bash
* * * * * sh {absolutepath}kill.sh > /tmp/kill.log
```

ie

```bash
* * * * * sh /home/user/kill.sh > /tmp/kill.log
```

## What the crontab entry does
```bash
* * * * *  sets the time - this means every minute
```

sh /home/user/kill.sh runs the kill script

&

```bash
 > /tmp/kill.log writes any output to file.
```

I know this is not a good solution. But it works.

## Check firewall status

```
sudo systemctl status firewalld
```

```bash
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -F DOCKER-ISOLATION-STAGE-1' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -X DOCKER-ISOLATION-STAGE-1' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -F DOCKER-ISOLATION-STAGE-2' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -X DOCKER-ISOLATION-STAGE-2' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -F DOCKER-ISOLATION' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -X DOCKER-ISOLATION' failed: iptables: No chain/target/match by that name.
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker_gwbridge -o docker_gwbridge -j ACCEPT' failed: iptables: Bad rule (does a matching rule exist in that chain?).
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker0 -o docker0 -j DROP' failed: iptables: Bad rule (does a matching rule exist in that chain?).
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker0 -o docker0 -j DROP' failed: iptables: Bad rule (does a matching rule exist in that chain?).
WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -t filter -nL DOCKER-INGRESS' failed: iptables: No chain/target/match by that name.
```

## Check the currently active firewall configuration by running the following command:

```bash
sudo firewall-cmd --list-all
```

This command will display the active zones and their associated settings.

Identify the zone you are interested in (e.g., the default zone or a specific zone) from the output of the previous command.

Run the following command to view the open ports for the chosen zone:

```bash
sudo firewall-cmd --zone=<zone_name> --list-ports
```

Replace <zone_name> with the name of the zone you want to check (e.g., "public", "work", or "home").

This command will list all the open ports in that zone.

Additionally, you can use the --list-services option instead of --list-ports to view the services allowed through the firewall.

## List open ports

```bash
sudo firewall-cmd --list-all
```

- Port 9100/tcp: This port is commonly associated with the printer-related protocol called "JetDirect" or "AppSocket/HP JetDirect." If you don't have any printers or print services running on your system, it is generally safe to close this port.

- Port 9134/tcp: This port is not associated with any well-known service or protocol. If you don't recognize it and don't have any specific applications requiring this port, it's generally recommended to close it.

- Port 9101/tcp: This port is often used by the Bacula backup software for communication between the Bacula Director and Bacula Storage daemon. If you are not using Bacula or any backup software that requires this port, it is generally safe to close it.

- Port 9091/tcp: This port is commonly associated with the Transmission BitTorrent client's web interface. If you are not running Transmission or any other application that uses this port, it is generally safe to close it.

- Port 9093/tcp: This port is often used by the Prometheus monitoring system for remote read/write access to its storage. If you are not using Prometheus or any monitoring software that requires this port, it is generally safe to close it.

- Port 9094/tcp: This port is not associated with any well-known service or protocol. If you don't recognize it and don't have any specific applications requiring this port, it's generally recommended to close it.

- Port 3000/tcp: This port is commonly used by various web applications and services, such as Node.js applications or development servers. If you are not actively using any application that relies on this port, it is generally recommended to close it for security purposes.

It's important to note that closing ports that are not actively used or required by your system can enhance your security posture by reducing potential attack vectors. However, before closing any ports, ensure that you understand the implications and verify that no critical services or applications will be affected.

If you are uncertain about the purpose of a particular port or its impact on your system, it is advisable to consult with a knowledgeable system administrator or a cybersecurity professional who can assess your specific setup and provide tailored recommendations.

## To close open ports using firewalld

Check the currently active firewall configuration by running the following command:

```bash
sudo firewall-cmd --list-all

9100/tcp 9134/tcp 9101/tcp 9091/tcp 9093/tcp 9094/tcp 3000/tcp
```

This command will display the active zones and their associated settings.

Identify the zone in which you want to close the ports. It could be the default zone or a specific zone. For example, if you want to modify the default zone, proceed with the next steps.

Run the following command to remove or close a specific port for the chosen zone:

```bash
sudo firewall-cmd --zone=public --remove-port=<port_number>/tcp


sudo firewall-cmd --zone=public --remove-port=9100/tcp
sudo firewall-cmd --zone=public --remove-port=9134/tcp
sudo firewall-cmd --zone=public --remove-port=9101/tcp
sudo firewall-cmd --zone=public --remove-port=9091/tcp
sudo firewall-cmd --zone=public --remove-port=9093/tcp
sudo firewall-cmd --zone=public --remove-port=9094/tcp
sudo firewall-cmd --zone=public --remove-port=3000/tcp
```

Replace <port_number> with the port number you want to close. Repeat this command for each port you wish to close.

For example, to close port 9100/tcp:

```bash
sudo firewall-cmd --zone=public --remove-port=9100/tcp
```

Repeat the command for each port you want to close.

After removing the ports, save the changes by running the following command:

```bash
sudo firewall-cmd --runtime-to-permanent
```

This command will make the changes permanent, so they persist across system reboots.

## List all the users in ubuntu


```bash
sudo cut -d: -f1 /etc/passwd
```

This command retrieves the first field (username) from each line of the /etc/passwd file, which contains user information.

The output will be a list of usernames, with each username appearing on a separate line.

This method retrieves all users on the system, including system users and service accounts. It does not differentiate between regular users and system users.

## View the running processes and users

```bash
sudo pstree -U
```

```bash
sudo ps -aux
```


