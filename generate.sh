#!/bin/bash

# colors
BLUE='\e[0;34m'
RED='\e[0;31m'
NONE='\e[0m'

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
# usage: log <string> [color = BLUE]
function log() {
    COLOR=${BLUE}
    [[ $# -eq 2 ]] && COLOR=$2
    [[ -v DEBUG ]] \
        && echo -e "$COLOR[+]$NONE $1" >&2
}


[[ $# -lt 2 ]] \
    && usage \
    && exit 1

# defaults
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
            # error checking for options
            if [[ ${OPTARG:0:1} == '-' ]]; then
                log "-f requires LIST" ${RED}
                usage && exit 1
            fi

            FILE_LIST+=(${OPTARG})
            log "added ${OPTARG} to \$FILE_LIST"
            ;;
        o)
            OUTPUT_FILE="${OPTARG}"
            ;;
        y)
            if [[ ${OPTARG:0:1} == '-' || ${OPTARG} != *.yml ]]; then
                log "frontmatter file extension must be .yml" ${RED}
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

INPUT_FILES+=("${FRONTMATTER}")
log "added ${FRONTMATTER} to INPUT_FILES"

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
log "remaining args: $*"

# unset IFS so spaces in files are preserved
IFS_BAK="${IFS}"
IFS= 
for file in ${@}; do
    INPUT_FILES+=("${file}")
    log "added ${file} to \$FILE_LIST"
done

# reset IFS
#IFS="${IFS_BAK}"

# subtract out the frontmatter.yml file
log "# input files: $((${#INPUT_FILES[@]} - 1))"

# get lines from input files
declare -a TEXT=()

# read in lines from input files
# in order

# test for pipe from STDIN
if [[ -p /dev/stdin ]]; then
    log "pipe detected from STDIN"
    PIPED_DATA=$(cat -)
fi

# read files
for file in ${INPUT_FILES[@]}; do
    # if piped data, add it to TEXT
    if [[ "${file}" == "-" ]]; then
        TEXT+=("${PIPED_DATA}")
    # else, continue reading files from input files
    else
        while IFS= read -r line; do
            TEXT+=("${line}\n")
        done < "${file/^-$/"${PIPED_DATA}"}" # sub piped data for -
    fi
done

# remove single leading space for indices >= 1
PROOF=$(echo -e "${TEXT[@]}" | sed 's/^ //g') 

# render the output
if [[ -v PREVIEW ]]; then
    awk -f ${WORKING_DIR}/prepare.awk <(echo -e "${PROOF}")
else
    awk -f ${WORKING_DIR}/prepare.awk <(echo -e "${PROOF}")\
        | pandoc - -o "${OUTPUT_FILE}" \
         --from markdown+yaml_metadata_block+raw_html \
         --template eisvogel \
         --table-of-contents \
         --toc-depth 6 \
         --number-sections \
         --top-level-division=chapter \
         --highlight-style breezedark
     
    log "file ${OUTPUT_FILE} created"
fi
