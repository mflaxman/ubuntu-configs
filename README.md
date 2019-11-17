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
