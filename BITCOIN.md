# Bitcoin Setup

Note: you can no longer just use ppa, so these steps are harder.

## Bitcoin Core Download / Verification

Visit the Bitcoin Core Download page and download the latest release as well as signatures in a good directory for the future (then `cd` to that directory):
https://bitcoin.org/en/download
```bash
$ curl -OJ https://bitcoin.org/bin/bitcoin-core-0.19.0.1/bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz && \
	curl -OJ https://bitcoin.org/bin/bitcoin-core-0.19.0.1/SHA256SUMS.asc
```

Verify sha256 of download:
```bash
$ sha256sum -c SHA256SUMS.asc 2>&1 | grep OK
bitcoin-0.19.0.1-x86_64-linux-gnu.tar.gz: OK
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
$ sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.19.0.1/bin/*
```

Copy the config file to the default location:
```bash
$ cp bitcoin.conf ~/.bitcoin/

```

Start bitcoin GUI (path is relative):
```bash
$ /usr/local/bin/bitcoin-qt -conf=bitcoin.conf
```
Notes:
* You can do `$ bitcoin-qt` directly if you like, this just guarantees you're running the correct version (in case you installed multiple)
* You can append `&` afterwards to have it run quietly (and then you can be sure you quit from the app instead of control-C.
* For mainnet change the `bitcoin.conf` file or call `bitcoin-qt` with `-testnet=0`.

