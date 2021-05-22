# Bitcoin Setup

This includes the following:
* Bitcoin Core
* Specter-Desktop
* Electrs
* Esplora

You don't have to do all of these, but they all require Bitcoin Core

---

## Bitcoin Core

### Download / Verification

Note that you can no longer just use ppa, so these steps are harder.

Visit the Bitcoin Core Download page and download the latest release as well as signatures in a good directory for the future (then `cd` to that directory):
https://bitcoin.org/en/download
```bash
$ curl -OJ https://bitcoin.org/bin/bitcoin-core-0.21.1/bitcoin-0.21.1-x86_64-linux-gnu.tar.gz
```

Also get the `SHA256SUMS.asc` (unless they're already up-to-date in this repo):
```
$ curl -OJ https://bitcoin.org/bin/bitcoin-core-0.21.1/SHA256SUMS.asc
```

Verify sha256 of download:
```bash
$ sha256sum -c SHA256SUMS.asc 2>&1 | grep OK
bitcoin-0.20.0-x86_64-linux-gnu.tar.gz: OK
```

Import Wladimir's release key (`01EA 5486 DE18 A882 D4C2 6845 90C8 019E 36C2 E964`) which is already included in this repo:
```bash
$ gpg --import laanwj-releases.asc
```

You can verify this with the following (not needed):
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
(untrusted message is because I don't have any web of trust sigs that verify Wladimir's key)

Unzip it (you may want to move it to your destination folder first).
```bash
$ tar -zvxf bitcoin-0.21.1-x86_64-linux-gnu.tar.gz
```

### Installation

Copy files to bin
```bash
$ sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.20.0/bin/*
```

Copy the `bitcoin.conf` config file to the default location (you will need to run `$ mkdir ~/.bitcoin` first if that directory already doesn't exit):
```bash
$ cp bitcoin.conf ~/.bitcoin/

```
FIXME: add Tor setup!

### Starting

Start bitcoin GUI (path is relative):
```bash
$ time bitcoin-qt
```
Notes:
* For testnet, use the same `bitcoin.conf` file but call `bitcoin-qt` with `--testnet` (`-testnet=1` may also work)
* You can append `&` afterwards to have it run quietly in the background. TODO: add `bitcoind` CLI instructions as well (not really needed but uses less resources).
* You can do `$ /usr/local/bin/bitcoin-qt` to be sure you're running the correct version (in case you installed multiple)
* You can do `-conf=bitcoin.conf` to be sure you're running the correct `bitcoin.conf` file, but if it's located in `$HOME/.bitcoin/bitcoin.conf` (as setup earlier in this page) then it won't matter
* For IBD, `-dbcache=6144` (for 16GB RAM) will speed things up (but use more resources), default in `bitcoin.conf` is set at 4096 (which is also likely too high)

### Query bitcoin core
Confirm it's working:
```bash
$ bitcoin-cli getblockchaininfo
```
Notes:
* For testnet pass in `--testnet` or `-chain=test` to set the port (mainnet is otherwise defaulted)
* Auth is more complicated if querying from another machine (see below)

### View the Logs
For mainnet:
```
$ tail $HOME/.bitcoin/debug.log -f
```

For testnet:
```
$ tail $HOME/.bitcoin/testnet3/debug.log -f
```

### Stopping
Do not force quit or `kill -9` if at all possible, as this may corrupt your blockchain data!
Tail the logs (see previous) to see what's happening, it can take minutes to close and that may give you a sense that it's still working under the hood.
This is just generally kind of annoying, but is a lot less bad when the node is fully synced.

### Setup Auth
(you may be able to skip this step if querying from this box only)

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

### Advanced

Run both mainnet and testnet in the background:
```
$ /usr/local/bin/bitcoin-qt -conf=bitcoin.conf & /usr/local/bin/bitcoin-qt -conf=bitcoin.conf --testnet &
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

You can check on these processes with
```
$ ps -aux | grep bitcoin
```
FIXME: add output

---

### Specter-Desktop

Create and activate the virtual environment
```
$ python3 -m virtualenv .venv3 && source .venv3/bin/activate
```
Install Specter-Desktop
```
$ pip3 install -r requirements.txt --require-hashes && pip3 install -e .
```
(Note that `$ pip3 install cryptoadvance.specter` should also work, but I prefer to build from source since that's easy for me)

Start the server:
```
$ python3 -m cryptoadvance.specter server
```
(this requires bitcoin core running to be useful but you can start bitcoin core after starting this server)

Now you can visit <127.0.0.1:25441/> to run the app!

---

## Electrs Electrum Server

Note that if you get stuck anywhere, this was built from [these instructions](https://github.com/romanz/electrs/blob/master/doc/usage.md).

### Install Dependencies
```
$ sudo apt install cargo rustc clang cmake build-essential -y
```
(these may be already installed from requirements.system)

### Install Electrs
Download:
```
$ git clone https://github.com/romanz/electrs && cd electrs
```

Build:
```
$ time cargo build --locked --release
```
(took ~13min on my crappy dev laptop in 2021-05)

### Run
```
$ time ./target/release/electrs -vvvv --timestamp --index-batch-size=10 --db-dir ./db --electrum-rpc-addr="127.0.0.1:50001"
```
Notes:
* Docs call for `--jsonrpc_import`, but in 2021-05 on a crappy laptop this was painfully slow so I disabled it and had good results.
I believe this flag is for machines with low RAM but am not sure.
* Add `--network=testnet` flag and it will run on testnet (otherwise it defaults to `mainnet`).

TODO: should testnet be on `60001` instead of `50001`?
Convention only so doesn't stricly matter but may cause downstream issues.

### Auth
TODO (right now this is only for local querying)

### Query
Note that neither method will return at all until electrs has fully synced (annoying).

#### Option A: CLI query

Ping for version:
```
$ echo '{"jsonrpc": "2.0", "method": "server.version", "params": ["", "1.4"], "id": 0}' | netcat 127.0.0.1 50001
{"id":0,"jsonrpc":"2.0","result":["electrs 0.8.10","1.4"]}
```

TODO: add advanced queries for balance and such.

#### Option B: Python Script

Install pycoin (ugh):
```
$ pip3 install pycoin
```

Query an address (must `cd` to `electrs/contrib` first):
```
$ python3 addr.py 144STc7gcb9XCp6t4hvrcUEKg9KemivsCR
144STc7gcb9XCp6t4hvrcUEKg9KemivsCR has {'confirmed': 0, 'unconfirmed': 0} satoshis
```

#### Other

See storage useage:
```
$ du -h db/*
71G	db/mainnet
6.0G	db/testnet
```
(#s go up on original sync before going down after compaction, these numbers are after compaction in 2021-05)

---

## Esplora (electrs and block explorer)

TODO: these notes are from 2020 but I since moved on to Electrs for ~10x faster sync time.
May revisit in the future if seeking a block explorer, so keeping fornow.

FIXME: confirm this is using my bitcoin core (I think it's not)?
TODO: connect to Electrum server!

Clone and enter the repo:
```bash
$ git clone https://github.com/Blockstream/esplora && cd esplora
```

Build the dockerfile (requires `sudo` unless you configure [rootless mode](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)):
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

More [here](https://www.tecmint.com/run-docker-container-in-background-detached-mode/)

---

## Storage

Bitcoin is storage intensive!

As of 2021-05, here is the disk usage for bitcoin core with electrs (no Esplora) for both mainnet and testnet on my lightweight dev box (does include filesystem and apps):
```
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb2       4.6T  531G  3.8T  13% /
```

I believe adding Esplora will increase this by 1-2 TBs.
