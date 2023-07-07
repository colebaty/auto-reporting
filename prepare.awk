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
/^(```.*|---)/ {
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
        # extension of linked file
        match(trigger[1], /!\[.*(\\.*[^]])\]\(img\/(.*)\.(.*)\)/, matches)

        # change hyphens to spaces
        label = matches[1]
        basename = matches[2]
        extension = matches[3]

        altText = matches[2]
        gsub(/[-.]/, " ", altText)
        
        # print everything on its own line
        print "\n" "![" altText label "](img/" basename "." extension ")" "\n"
    } else if (substr(trigger[1], 1, 1) == "#") { # else, if starts with #
        print "\n" $0 "\n"
    } else { # otherwise
        print $0
    }
}
