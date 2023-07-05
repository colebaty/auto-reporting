---
title: "Offensive Security Certified Professional Exam Report"
author: ["student@youremailaddress.com", "OSID: XXXX"]
date: "2020-07-25"
subject: "Markdown"
keywords: [Markdown, Example]
subtitle: "OSCP Exam Report"
lang: "en"
titlepage: true
titlepage-color: "1E90FF"
titlepage-text-color: "FFFAFA"
titlepage-rule-color: "FFFAFA"
titlepage-rule-height: 2
book: true
book-class: false
classoption: oneside
code-block-font-size: \scriptsize
imageNameKey: replace-me
---
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
