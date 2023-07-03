#!/usr/bin/awk -f 

{ 
    print gensub(/!\[\[(Pasted image [^]]+)\]\]/, "![ . ](./img/\\1)", "g"); 
}

# sed 's/ image /%20image%20/' > testout.md
