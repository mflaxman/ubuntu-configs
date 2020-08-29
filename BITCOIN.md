# Bitcoin Setup

Note: you can no longer just use ppa, so these steps are harder.

## Bitcoin Core Download / Verification

Visit the Bitcoin Core Download page and download the latest release as well as signatures in a good directory for the future (then `cd` to that directory):
https://bitcoin.org/en/download
```bash
$ curl -OJ https://bitcoin.org/bin/bitcoin-core-0.20.0/bitcoin-0.20.0-x86_64-linux-gnu.tar.gz
```

Also get the `SHA256SUMS.asc` (unless they're already up-to-date in this repo):
```
$ curl -OJ https://bitcoin.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
```

Verify sha256 of download:
```bash
$ sha256sum -c SHA256SUMS.asc 2>&1 | grep OK
bitcoin-0.20.0-x86_64-linux-gnu.tar.gz: OK
```

Import Wladimir's release key (`01EA 5486 DE18 A882 D4C2 6845 90C8 019E 36C2 E964`):
```bash
$ gpg --import laanwj-releases.asc
```

You can verify this with the following (no need to do this):
```bash
$ gpg --list-keys
```

Confirm the signature
```bash
$ gpg --verify SHA256SUMS.asc
gpg: Signature made Sun 24 Nov 2019 03:14:42 AM CST
gpg:                using RSA key 90C8019E36C2E964
gpg: Good signature from "Wladimir J. van der Laan (Bitcoin Core binary release signing key) <laanwj@gmail.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 01EA 5486 DE18 A882 D4C2  6845 90C8 019E 36C2 E964
```
(untrusted message is because I don't have any web of trust sigs that verify this one)

Unzip it (you may want to move it to your destination folder first).
```bash
$ tar -zvxf bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz
```

## Bitcoin Core Installation

Copy files to bin
```bash
$ sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.20.0/bin/*
```

Copy the `bitcoin.conf` config file to the default location:
```bash
$ cp bitcoin.conf ~/.bitcoin/

```
FIXME: add Tor setup!

Start bitcoin GUI (path is relative):
```bash
$ /usr/local/bin/bitcoin-qt -conf=bitcoin.conf
```
Notes:
* You can do `$ bitcoin-qt` directly if you like, this just guarantees you're running the correct version (in case you installed multiple)
* You can append `&` afterwards to have it run quietly in the background (and then you can be sure you properly quit from the app instead of control-C)
* For testnet use the same `bitcoin.conf` file but call `bitcoin-qt` with `-testnet=1`.
* For IBD, `-dbcache=4096` (for 16GB RAM) will speed things up (but use more resources), already set as default in `bitcoin.conf`

Confirm it's working:
```bash
$ bitcoin-cli getblockchaininfo
```
(for testnet pass in `-chain=test` to set the port. `-chain=main` is otherwise defaulted)

#### Setup Auth

Run script to generate password for username to `specter`:
```bash
$ python3 rpcauth.py specter insecurepasswordgoeshere
String to be appended to bitcoin.conf:
rpcauth=specter:1f48c76b188a325d4188c4830dc37848$87d730596f68faaa827eda20ae96390bcb6b126ff5786ccfcda7a849872c29c0
Your password:
insecurepasswordgoeshere
```
(Do **not** use these credentials)

and then add `rpcauth` to your `~/.bitcoin/bitcoin.conf` file (under **both** `test` and `main` sections!).

Now figure out your local IP address:
```
$ ip address show | grep 192
inet 192.168.1.75/24 brd 192.168.1.255 scope global dynamic noprefixroute enp4s0
```
And add this to your `~/.bitcoin/bitcoin.conf` file (under **both** `test` and `main` sections):
```
rpcbind=192.168.1.75
```

Test auth locally (anything can connect):
```
$ bitcoin-cli getblockchaininfo
```

Test auth over network (in this case `192.1.168.75` is what you put in your `rpcbind` in `bitcoin.conf`):
```
$ bitcoin-cli -rpcconnect=192.1.168.75 -rpcuser=specter -rpcpassword=insecurepasswordgoeshere getblockchaininfo
```

#### Advanced

Run both mainnet and testnet in the background:
```
$ /usr/local/bin/bitcoin-qt -conf=bitcoin.conf & /usr/local/bin/bitcoin-qt -conf=bitcoin.conf -testnet=1 &
```

You can verify `bitcoin-qt` is running and bound to the ports you're expecting like this:
```
$ netstat -alpn | grep 8332
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 192.168.1.75:18332      0.0.0.0:*               LISTEN      17199/bitcoin-qt    
tcp        0      0 127.0.0.1:18332         0.0.0.0:*               LISTEN      17199/bitcoin-qt    
tcp        0      0 192.168.1.75:8332       0.0.0.0:*               LISTEN      17162/bitcoin-qt    
tcp        0      0 127.0.0.1:8332          0.0.0.0:*               LISTEN      17162/bitcoin-qt    
```
(you can also pipe to `grep -i listen | grep tcp | grep bitcoin`)

---

## Esplora (electrs and block explorer)

FIXME: confirm this is using my bitcoin core (I think it's not):
TODO: connect to Electrum server

Clone and enter the repo:
```bash
$ git clone https://github.com/Blockstream/esplora && cd esplora
```

Build the dockerfile (requires `sudo` unless you configure (rootless mode)[https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user]):
```bash
$ sudo time docker build -t esplora .
```
(this may take a while, perhaps 15 mins)

Run esplora on testnet and mainnet (`$EXTERNAL_HD` is set in `.profile`):
```bash
$ sudo docker run -p 8084:80 --volume $EXTERNAL_HD/data_bitcoin_testnet:/data -itd esplora bash -c "/srv/explorer/run.sh bitcoin-testnet explorer"
$ sudo docker run -p 8080:80 --volume $EXTERNAL_HD/data_bitcoin_mainnet:/data -itd esplora bash -c "/srv/explorer/run.sh bitcoin-mainnet explorer"
```
Now visit http://localhost:8080/ for mainnet and http://localhost:8080/ for testnet.

`-d` flag used to run these in "detached" mode. You can see processes like this:
```bash
$ sudo docker ps -a
```

And kill processes like this (grab `CONTAINER ID` from previous command):
```bash
$ sudo docker stop 301aef99c1f3
```

More (here)[https://www.tecmint.com/run-docker-container-in-background-detached-mode/]
