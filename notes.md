good progress with this

# TODO
- [x] you have to set the obsidian environment up to
    - [x] use "markdown" links for pasted images, not "wiki" links

- [x] use a [plugin](https://forum.obsidian.md/t/paste-image-rename-plugin/35480) to help name files properly to eliminate the spaces
 this will make the awk script a lot easier, i suspect

- [x] writing/formatting - enforce with script
    - [x] all \# headers, and links to images should appear on their own lines, i.e. separated by newlines
    - [x]  for the future: batch convert old reports link styles to markdown, i.e. non-wiki

![links and headers example](links%20and%20headers%20example.md)
- [x] does resizing work with markdown tags?
    it does, but pandoc doesn't know what to do with them.

# code
## generate report - example
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

## replace date in frontmatter
```bash
today=$(date +%F)
sed -r "s/(date: \")([^\"])\"/\1${today}/" templates/frontmatter.yml
 
```
# auto reference images

```markdown

![some link \label{someUniqueLabel}](uri/to/resource.png)

See Figure \label{someUniqueLabel}
```

- [x] update `prepare.awk` matching regex
