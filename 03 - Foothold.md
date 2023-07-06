# Foothold

## Initial Foothold: `sqlmap --os-shell`

Using a saved copy of the injecitble request, we used the `sqlmap` tool to gain a rudimentary webshell on the target as the `postgresql` user.  This user has read/write privileges on the target, as well as network access, which can be exploited to gain a persistent reverse shell.
