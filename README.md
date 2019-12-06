# Ubuntu Configs

## Update your system

```bash
$ sudo apt update && sudo apt upgrade
```

## Install software

Dependencies come from `requirements.system` using (this trick)[https://stackoverflow.com/a/10123093]:
```bash
$ cat requirements.system | xargs sudo apt install -y
```

Python `requirements.txt`:
```bash
$ pip3 install -r requirements.txt
```

## Configs

Copy over hidden files to home directory:
```bash
$ cp {.profile,.inputrc,.screenrc,.vimrc} ~/
```

Generate a public/private keypair to use as a deploy key for this box (will be stored in `~/.ssh/id_rsa.pub`):
```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
(Hit enter through defaults FIXME: should this have a PW?)

Start docker and set to run at startup per (these instructions)[https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04]:
```bash
$ sudo systemctl start docker
$ sudo systemctl enable docker
Synchronizing state of docker.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable docker
```
