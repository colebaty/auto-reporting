#/usr/bin/awk -f
{
    # find lines beginning with header or link markdown
    lineMatchIndex = match($0, /^(##*.*|!\[.*)$/)
    lineMatch = substr($0, lineMatchIndex)

    # if there's a match
    if (lineMatchIndex > 0) {
        #print "lineMatchIndex: " lineMatchIndex
        #print "lineMatch: " lineMatch

        # put the the file basename as the alt-text 
        lineMatch =  gensub(/!\[\]\(img\/(.*)\.([^\)])/, "![\\1](img\/\\1.\\2", "g", lineMatch); 
        #print "lineMatch: " lineMatch

        # replace hyphens with spaces in alt text: [alt-text] -> [alt text]
        match(lineMatch, /\[([^]]+)\]/, matches)
        matchText = matches[1]
        #print "matchText: " matchText
        gsub("-", " ", matchText)
        #print "matchText: " matchText
        #print "matches[1]: " matches[1]

        sub(matches[1], matchText, lineMatch)
        #print "lineMatch: " lineMatch "\n"

        # put each line on its own line
        print "\n" lineMatch "\n"

    }
}
