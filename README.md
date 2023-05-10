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

## iptables 

iptables is a user-space utility program for configuring and managing the netfilter firewall in Linux-based operating systems. It allows you to define and modify rules that control network traffic by filtering, NAT (Network Address Translation), and other packet manipulation tasks.

iptables works by examining packets as they pass through the Linux kernel's networking stack and applying rules to determine the action to take for each packet. These actions can include accepting, dropping, or forwarding packets based on various criteria such as source/destination IP addresses, ports, protocols, and more.

To view the current iptables configuration on your system, you can use the following command:

```bash
sudo iptables -L
```

This command displays the current iptables rules for the default filter table. It provides information about the chains, rules, and packet counters for each rule. The output will include the rules for INPUT, OUTPUT, and FORWARD chains, along with any custom chains you may have defined.

If you want to view the rules for a specific chain, you can specify the chain name as an argument to the -L option. For example, to view the rules for the INPUT chain, you can use:

```bash
sudo iptables -L INPUT
```

Additionally, you can use other options with the iptables command to view specific aspects of the firewall configuration. You can refer to the iptables man page (man iptables) for more information on the available options and usage examples.

Note that viewing the iptables configuration usually requires administrative privileges (root or sudo access) as it deals with system-level network configuration.


## why would docker be using iptables?

Docker uses iptables as part of its networking functionality. When Docker creates and manages network connections for containers, it leverages iptables to set up and manage the necessary network rules and configurations.

To reset and prevent the attempted iptables commands or the DOCKER-INGRESS chain from being executed in the future, you can take the following steps:

### Resetting iptables:

Flush all iptables rules: This will remove all existing rules from iptables. Execute the following command as root or with sudo:

```bash
sudo iptables -F
```

Delete any custom chains: If you have created any custom chains, remove them using the following command:

```bash
sudo iptables -X
```

Reset the default policies: Set the default policies for the filter table to ACCEPT, which allows all traffic by default:

```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
```

Note: Be cautious when executing these commands, as they will remove all existing iptables rules and policies.

## Preventing docker-ingress or firewalld-related actions:

Disable Docker network iptables: If you want to prevent Docker from modifying iptables rules altogether, you can disable the Docker network iptables feature. Edit the Docker daemon configuration file (typically located at /etc/docker/daemon.json) and add or modify the following entry:

```bash
{
  "iptables": false
}
```

Save the file and restart the Docker service for the changes to take effect.

Disable firewalld: If you want to disable firewalld and prevent it from making any firewall-related changes, you can stop and disable the firewalld service. Execute the following commands as root or with sudo:

```bash
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

This will stop the firewalld service and prevent it from starting automatically on system boot.

By following these steps, you should be able to reset iptables and prevent the execution of Docker or firewalld-related actions that trigger the errors you mentioned. Remember to carefully consider the implications of these actions and ensure that they align with your system's security requirements and network configurations.

## un-install docker and docker-compose and clean up iptables

To uninstall Docker and Docker Compose and clean up iptables, you can follow the steps below:

## Uninstalling Docker:

Stop and remove running Docker containers: It's recommended to stop and remove any running Docker containers to ensure a clean uninstallation. You can use the following command to stop and remove all containers:

```bash
sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
```

Uninstall Docker packages: The package management method depends on your Linux distribution. Below are the commands for some common distributions:

```bash
sudo apt-get purge docker-ce docker-ce-cli containerd.io
```

Use the appropriate package manager command for your distribution to uninstall Docker.

Remove Docker-related files and directories: After uninstalling Docker packages, you can remove Docker-related files and directories if they exist. Some common locations are:

```bash
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
```

## Uninstalling Docker Compose:

Locate the Docker Compose binary: Determine the location of the Docker Compose binary. It is often located in /usr/local/bin/docker-compose, but it can vary depending on your installation method.

Remove the Docker Compose binary: Use the following command to remove the Docker Compose binary:

```bash
sudo rm /usr/local/bin/docker-compose

sudo rm /usr/bin/docker-compose
```

## Cleaning up iptables:

Flush all iptables rules: To remove all existing iptables rules, execute the following command:

```bash
sudo iptables -F
```

Delete any custom chains: If you have created custom chains, remove them using the following command:

```bash
sudo iptables -X
```

Reset the default policies: Set the default policies for the filter table to ACCEPT:

```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
```

By following these steps, you should be able to uninstall Docker and Docker Compose from your system and clean up the iptables rules. Remember to exercise caution and ensure that you have a backup of any important data before proceeding with the uninstallation.

## View the firewalld configuration

```bash
sudo sh -c "cd /etc/firewalld && cat firewalld.conf"
sudo sh -c "cd /etc/firewalld && cat lockdown-whitelist.xml"
```

## Restart firewalld

```bash
sudo systemctl restart firewalld

sudo systemctl status firewalld
```

## Remaining firewalld errors

```bash
firewalld[9854]: WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker_gwbridge -o docker_gwbridge -j ACCEPT' failed: iptables: Bad rule (does a matching rule exist in that chain?).
firewalld[9854]: WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker0 -o docker0 -j DROP' failed: iptables: Bad rule (does a matching rule exist in that chain?).
firewalld[9854]: WARNING: COMMAND_FAILED: '/usr/sbin/iptables -w10 -D FORWARD -i docker0 -o docker0 -j DROP' failed: iptables: Bad rule (does a matching rule exist in that chain?).
```

## Set up aliases to check ports

```
alias ports1='sudo firewall-cmd --list-all'
alias ports2='sudo systemctl status firewalld'
```
