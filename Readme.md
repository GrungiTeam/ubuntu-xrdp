# Ubuntu 21.04 Multi User Remote Desktop Server

:warning: _This repository is related to something that I use on a private stuff, it is not aimed for a public usage. Use it at your risk!_

This dockerfile contains a Ubuntu 21.04 image with some tools needed for generic stuff related to multimedia handling. It comes with mkvtoolnix, MakeMKV, RenameMyTvSeries (beta), ffmpeg, aria2, vlc, mediainfo and so on.

It is based on XFCE4 with XRDP and PulseAudio module.

## :whale: Manual Deploying

First of all, build the image running:

```bash
docker build . --name xrdpubuntu
```

Then create a new container running:

```bash
docker run -d --name uxrdp --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 xrdpubuntu:latest
```

**Notes:**

- It is important to use the `--shm-size 1g` or the web browsers will crash;
- If you are using a rdp server on `3389` change `-p <my-port>:3389`;
- If your `2222` is busy, change `-p <my-port>:22` for ssh access into the container;

## :satellite: Connecting to the container

You can connect to the container using a RDP client or SSH.

- By default, SSH is enabled on port `2222`, you can use any SSH client out of the web;
- By default, RDP is enabled on port `3389`, you can use all the clients supported by [XRDP](https://github.com/neutrinolabs/xrdp):
  
  - FreeRDP
  - rdesktop
  - KRDC
  - NeutrinoRDP
  - Windows MSTSC (Microsoft Terminal Services Client, aka mstsc.exe)
  - Microsoft Remote Desktop (found on Microsoft Store, which is distinct from MSTSC)

## :frowning_man: Creating new users

:warning: The main objective is to create users like root (with UID and GID set to 0), it is a crazy and unsafe setting but it is needed for my work, so bear with it.

To automate the creation of users, supply a file users.list in the /etc directory of the container.
The format is as follows:

```bash
username password-hash
```

The provided users.list file will create a sample root-like-user:

- Username: _ubuntu_
- Password: _ubuntu_

To generate the password hash use the following line:

```bash
openssl passwd -1 'newpassword'
```

Run the xrdp container with your file

```bash
docker run -d -v $PWD/users.list:/etc/users.list
```

You can change your password in the rdp session in a terminal

```bash
passwd
```

## :frowning_woman: Adding new users on existing container

No configuration is needed, you can add new user on a existing container running:

```bash
docker exec -it uxrdp adduser mynewuser
```

After this the new user can login.

## :gear: Adding new services

To make sure all processes are working supervisor is installed.
The location for services to start is `/etc/supervisor/conf.d`

**Example**: Adding `mysql` as a service

```bash
apt-get -yy install mysql-server
echo "[program:mysqld] \
command= /usr/sbin/mysqld \
user=mysql \
autorestart=true \
priority=100" > /etc/supervisor/conf.d/mysql.conf
supervisorctl update
```

## :whale2: Using docker-compose

```bash
git clone https://github.com/GrungiTeam/ubuntu-xrdp.git
cd ubuntu-xrdp/
%your_prefered_editor% docker-compose.override.yml # if you want to override any default value
docker-compose up -d
```
