#!/usr/bin/awk -f 

BEGIN {
    insideCodeBlock = 0
}

/^(```.*|---)/ {
    insideCodeBlock = !insideCodeBlock # toggle
}

insideCodeBlock { print }

!insideCodeBlock {
    # find lines beginning with header or link markdown
    match($0, /^(##*.*|!\[.*)$/, trigger)

    # if match exists and starts with bang
    if (substr(trigger[1], 1, 1) == "!") {
        match(trigger[1], /!\[\]\(img\/(.*)\.(.*)\)/, matches)
        altText = matches[1]
        gsub("-", " ", altText)
        #print "matches[2]: " matches[2]
        print "\n" "![" altText "](img/" matches[1] "." matches[2] ")" "\n"
    } else if (substr(trigger[1], 1, 1) == "#") { # else, if starts with #
        print "\n" $0 "\n"
    } else { # otherwise
        print $0
    }
}
