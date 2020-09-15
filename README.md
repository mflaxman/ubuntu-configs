# Ubuntu Configs

FIXME: Currently it is required to check the box for `run command as login shell` in terminal, not sure why (and if it's correct I should configure it automatically with these scripts).

## Update your system

```bash
$ sudo apt update && sudo apt upgrade
```

## Install software

To do the next step you need to fetch `requirements.system` from this repo, so let's just grab the whole thing now:
```bash
$ mkdir $HOME/workspace && cd $HOME/workspace
$ git clone https://github.com/mflaxman/ubuntu-configs.git && cd ubuntu-configs
```

Alternatively, you could fetch just `requirements.system` using `curl`:
```bash
$ curl -OJ https://raw.githubusercontent.com/mflaxman/ubuntu-configs/master/requirements.system
```

Dependencies come from `requirements.system` using (this trick)[https://stackoverflow.com/a/10123093]:
```bash
$ cat requirements.system | egrep -v "(^#.*|^$)" | xargs sudo apt install -y
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

Generate a public/private keypair using ed25519 (more [here](https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54)) to use as a deploy key for this box (will be stored in `~/.ssh/id_ed25519_XXXX.pub`):
```bash
$ ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_2020XXDATEHERE -C "you@email.com"
```
(pick your own naming convention for filename / email address)

You will be prompted for a passphrase, you can skip (hit enter for blank) but a strong passphrase is recommended (store it in a less secure PW manager).

TODO: add password to your agent:

Start docker and set to run at startup per [these instructions](https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04):
```bash
$ sudo systemctl start docker
$ sudo systemctl enable docker
Synchronizing state of docker.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable docker
```

Setup Remote Desktop (for Home):
https://www.makeuseof.com/tag/ubuntu-remote-desktop-builtin-vnc-compatible-dead-easy/
