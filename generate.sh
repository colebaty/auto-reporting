#!/bin/bash

function usage() {
    cat <<-EOF
$0 [-d] [-p] [-f LIST [-f LIST ...]] [-o PDF] [-y FRONTMATTER] FILE1 [FILE2 FILE3 ...]

    Process and pass FILE(s) to pandoc for rendering into a report 
    with the Eisvogel LaTeX template. FILEs are processed in the 
    order in which they appear in the list. If FILE is missing 
    or - will read from STDIN.

    -d              log debug info to STDERR

    -p              preview: renders the markdown that will 
                    be passed to pandoc

    -f LIST         a file containing the list of files to process
                    in the order in which they should appear in the
                    report. multiple files are processed in the order 
                    in which they appear in the invocation. contents of
                    files in LIST(s) will appear in the report before the contents 
                    of FILE(s)

    -o PDF          specify output file name with extension, e.g. path/to/report.pdf
                    default is report.pdf

    -y FRONTMATTER  specify a custom .yml frontmatter metadata file

EOF
}

# prints only if invoked with -d
function log() {
    [[ -v DEBUG ]] \
        && echo -e "\e[34m[+]\e[0m $1" >&2
}


[[ $# -lt 2 ]] \
    && usage \
    && exit 1

WORKING_DIR=${PWD}
TEMPLATES_DIR=${WORKING_DIR}/templates
OUTPUT_FILE="${WORKING_DIR}/report.pdf"
FRONTMATTER="${TEMPLATES_DIR}/frontmatter.yml"

declare -a FILE_LIST=() # empty list


while getopts ':dpf:o:y:' OPTION; do
    case "${OPTION}" in
        d)
            DEBUG=""
            log "debug enabled"
            ;;
        p)
            PREVIEW="" 
            log "setting preview flag"
            ;;
        f)
            if [[ ${OPTARG:0:1} == '-' ]]; then
                usage && exit 1
            fi

            FILE_LIST+=(${OPTARG})
            log "added ${OPTARG} to \$FILE_LIST"
            ;;
        o)
            OUTPUT_FILE="${OPTARG}"
            ;;
        y)
            if [[ ${OPTARG:0:1} == '-' ]]; then
                usage && exit 1
            fi

            FRONTMATTER="${OPTARG}"
            ;;
        \?)
            usage
            exit 1
            ;;
    esac
done

log "num list files: ${#FILE_LIST[@]}"
log "output file: ${OUTPUT_FILE}"
log "frontmatter file: ${FRONTMATTER}"

declare -a INPUT_FILES=()

# get file lists if supplied
if [[ ${#FILE_LIST[@]} -gt 0 ]]; then
    for file in ${FILE_LIST[@]}; do
        while IFS= read line; do
            INPUT_FILES+=("${line}") # quotes preserve newlines
        done < ${file}
    done
fi

# parse remaining args
# should just be regular-ass files
shift $((OPTIND - 1))
for file in ${@}; do
    INPUT_FILES+=(${file})
    log "added ${file} to \$FILE_LIST"
done

log "# input files: ${#INPUT_FILES[@]}"

# get lines from input files
declare -a LINES=()

# read in lines from input files
# in order
for file in ${INPUT_FILES[@]}; do
    while IFS= read line; do
        LINES+=("$line")
    done < ${file}
done
