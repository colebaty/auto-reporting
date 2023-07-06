good progress with this

# TODO
- [x] you have to set the obsidian environment up to
    - [x] use "markdown" links for pasted images, not "wiki" links

- [x] use a [plugin](https://forum.obsidian.md/t/paste-image-rename-plugin/35480) to help name files properly to eliminate the spaces
 this will make the awk script a lot easier, i suspect

- [x] writing/formatting - enforce with script
    - [x] all \# headers, and links to images should appear on their own lines, i.e. separated by newlines
    - [x]  for the future: batch convert old reports link styles to markdown, i.e. non-wiki

```markdown
##### BAD #####

# some header
![ link to some file]( link to some file)

##### GOOD #####

# some header <- on its own line

![ link to some file]( link to some file) <- on its own line
```

- [x] does resizing work with markdown tags?
    it does, but pandoc doesn't know what to do with them.

# code
```bash
files=(templates/frontmatter.yml Executive\ Summary.md {00..10}*.md)
cat ${files} \
    | awk -f prepare.awk - \
    | pandoc - -o ./test.pdf \
         --from markdown+yaml_metadata_block+raw_html \
         --template eisvogel \
         --table-of-contents \
         --toc-depth 6 \
         --number-sections \
         --top-level-division=chapter \
         --highlight-style breezedark
```
texlive-base texlive-binaries texlive-fonts-extra texlive-fonts-extra-links texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures texlive-plain-generic
