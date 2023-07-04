#!/usr/bin/awk -f 

BEGIN {
    insideCodeBlock = 0
}

/```.*/ {
    insideCodeBlock = !insideCodeBlock # toggle
}

insideCodeBlock { print }

!insideCodeBlock {
    print "not inside code block"
    # find lines beginning with header or link markdown
    lineMatchIndex = match($0, /^(##*.*|!\[.*)$/)
    lineMatch = substr($0, lineMatchIndex)

    # if there's a match
    if (lineMatchIndex > 0) {
        print "lineMatchIndex: " lineMatchIndex
        print "lineMatch: " lineMatch

        # put the the file basename as the alt-text 
        lineMatch =  gensub(/!\[\]\(img\/(.*)\.([^\)])/, "![\\1](img\/\\1.\\2", "g", lineMatch); 
        print "lineMatch: " lineMatch

        # replace hyphens with spaces in alt text: [alt-text] -> [alt text]
        match(lineMatch, /\[([^]]+)\]/, matches)
        matchText = matches[1]
        print "matchText: " matchText
        gsub("-", " ", matchText)
        print "matchText: " matchText
        print "matches[1]: " matches[1]

        sub(matches[1], matchText, lineMatch)
        print "lineMatch: " lineMatch "\n"
        print "\n" lineMatch "\n"
    }
    else {
        print $0
    }
}

#!insideCodeBlock {
#    if (replaceAltText) {
#    }
#    else if (putOnOwnLine) { 
#        print gensub(/\n?^(##*.*|!\[.*\]\(.*\)).*$\n?/, "\n\\1\n", "g")
#        putOnOwnLine = 0
#        next
#    }
#
#    print
#}

#/```/ {f = 1; next} /```/ {f = 0; next} f
# /```.*/ {f = 0} /```$/ {print; f = 1} f

# places basename of image file as alt-text, as well as resize scalar within
## square brackets
## pandoc parses the alt-text for use as the figure labels
#{ 
#    print gensub(/!\[\]\(img\/(.*)\.([^\)])/, "![\\1 | 600](img\/\\1.\\2", "g"); 
#}
#
## ensures that every link to an image or a heading is on its own line.
## shell-code comments contained in code blocks are ignored.
#
## regex = /^(##*.*|!\[.*\]\(.*\))  *$/
#{
#}
