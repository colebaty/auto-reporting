#!/bin/bash

function usage() {
    cat <<-EOF
$0 [-p] [-f LIST] [-o PDF] FILE1 [FILE2 FILE3 ...]

    Process and pass FILE(s) to pandoc for rendering into a report 
    with the Eisvogel LaTeX template. FILEs are processed in the 
    order in which they appear in the list.

    -p          preview: renders the markdown that will be passed
                to pandoc; opens in pager

    -f LIST     a file containing the list of files to process
                in the order in which they should appear in the
                report; see README

    -o PDF      specify output file name with extension
                default is report.pdf

EOF
}

usage
