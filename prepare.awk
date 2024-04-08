#!/usr/bin/awk -f 

# Ensures proper formatting of CommonMark markdown before PDF
# conversion by pandoc.
#
# Pandoc requires that all embed links and section/chapter headings
# appear on their own lines for proper rendering. This script is 
# intended to be run as the step immediately before passing the data 
# to pandoc for conversion, automatically enforcing this requirement
# while also preserving the original contents of the file. 
#
# There is no need for the author to worry about enforcing this 
# formatting requirement manually.

BEGIN { insideCodeBlock = 0 }

# checks for markdown, yaml code blocks
# TODO:
#   - [ ] account for nested markdown blocks
/^(```.*|---)$/ {
    insideCodeBlock = !insideCodeBlock # toggle
}

# do nothing to lines appearing inside code blocks
insideCodeBlock { print }

# otherwise
!insideCodeBlock {
    # find lines beginning with header or link markdown
    match($0, /^(##*.*|!\[.*)$/, trigger)

    # if match exists and starts with bang
    if (substr(trigger[1], 1, 1) == "!") {
        # use matching groups to grab basename, optional reference label,
        # extension of linked file, optional sizing param
        match(trigger[1], /!\[(.*\\[^}]*})?.*\]\((.*img\/)(.*)\.(.*)\)/, matches)
        #match(trigger[1], /!\[(.*\\[^}]*})?.*\]\([^\/]*\/?img\/(.*)\.(.*)\)/, matches)

        #print "testing for label match: " (1 in matches)
        #print "testing for path match: " (2 in matches)
        #print "testing for basename match: " (3 in matches)
        #print "testing for extension match: " (4 in matches)
        #print "testing for sizing match: " (5 in matches)

        label = ""
        if (1 in matches) {
            label = gensub(/[^\\]*(\\[^}]*\})/, " \\1", "g", matches[1])
        }

        #print "label: " label
        path = matches[2]
        #print "path: " path
        basename = matches[3]
        #print "basename: " basename
        extension = matches[4]
        #print "extension: " extension
        sizing = matches[5]
        #print "sizing: " sizing

        # change hyphens to spaces
        altText = matches[3]
        gsub(/[-.]/, " ", altText)
        #print "altText: " altText
        
        # print everything on its own line
        #print "\n" "![" altText label "](" path basename "." extension ")" sizing "\n"
        print "\n" "![" altText label "](" path basename "." extension "){ height=50% width=70% }" "\n"
    } else if (substr(trigger[1], 1, 1) == "#") { # else, if starts with #
        print "\n" $0 "\n"
    } else { # otherwise
        print $0
    }
}
