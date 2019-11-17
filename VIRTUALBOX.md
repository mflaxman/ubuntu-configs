# Virtualbox Setup

2019-11-16: this worked to get virtualbox installed but then was not used for that project so is untested.

Install according to (these instructions)[https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-virtualbox-4-5-ubuntu-16-04.html]:
```bash
$ sudo sh -c 'echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list.d/virtualbox.list'
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ sudo apt update && sudo apt install virtualbox -y
```

Follow these instructions if using secure boot (full disk encryption), kind of a PITA:
https://torstenwalter.de/virtualbox/ubuntu/2019/06/13/install-virtualbox-ubuntu-secure-boot.html
