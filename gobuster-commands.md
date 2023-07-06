Not much to go on.  Let's see if there are any subdomains. 

GoBuster turns up a subdomain of `kiosk.jupiter.htb`.

```bash
gobuster vhost \
    -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt \
    -u jupiter.htb \
    -o jupiter.gobuster
    --append-domain
```

* `-w` : specifiy wordlist.  I tried a few wordlists but SecLists found it
* `-u`: host
* `-o`: capture output to file
* `--append-dommain`: "Append main domain from URL to words from wordlist. Otherwise the fully qualified domains need to be specified in the wordlist."

![011 - gobuster results](011%20-%20gobuster%20results.md)
Update `/etc/hosts`

```
10.10.11.216    jupiter.htb kiosk.jupiter.htb
```