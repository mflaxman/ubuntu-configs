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
$ cp {.bash_profile,.inputrc,.screenrc,.vimrc} ~/
```

Generate a public/private keypair to use as a deploy key for this box (will be stored in `~/.ssh/id_rsa.pub`):
```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
(Hit enter through defaults FIXME: should this have a PW?)
