# Overview
This is a fork of [noraj/OSCP-Exam-Report-Template-Markdown](https://github.com/noraj/OSCP-Exam-Report-Template-Markdown). 

The goal is to help streamline report writing during labs/pentesting.

I've done _so many_ labs and written the report that follows this process:

1. do the lab, take notes, grab screenshots
2. do the lab again to get prettier screenshots as needed
3. synthesize all of this in some sort of word processor

There's nothing terribly wrong with this process, but it is very inefficient and time-consuming.  I was spending four to five hours (sometimes more!) just writing reports. A lot of that time was spent on formatting, especially if the report included code samples.

The aim with this is to help streamline the process, taking notes and screenshots as I progress through the lab or test, so that by the time it's over almost all of the content of the report is collected and assembled.

Uses Eisvogel LaTeX template.

## Intent
The intent for this repo is for it to be used as a "starter" for reporting on tests, labs, etc.  This was designed for the Obsidian Markdown editor in order to take advantage of some of the native features as well as community plugins.

For example, by using the Paste Image Rename plugin, we can quickly add descriptive filenames to images as we add them to the project.  This filename is processed in such a way that Pandoc automatically renders it as the figure descriptions in the resulting report.

# Requirements
## Software
- Obsidian Markdown Editor
- noraj requirements
    - pandoc
    - Eisvogel
    - etc.
- etc.

## Plugins
- paste image rename
- Obsidian link converter: easily and instantly convert between !\[\[Wiki\]\] and !\[CommonMark\]\(url\) style transclusion/embed links. 

# Installation
Ensure you have all the required software and plugins listed above.

Clone this repo.

In Obsidian, open this repo as a vault.

## Optional - version control

After cloning, remove the `.git` directory from the root of the repo.  Then, to create a new git instance, run the commands below:

```bash
# initializes a new git session in the current directory
# with the default branch 'main'
git init -b main
```

Now you have version history, and you can back up your personal fork of this repo to any of the popular Git hosting services, e.g. GitLab, GitHub, your own private git server, etc.

# Configuration
MTF
- "markdown" links, not "wiki" links


# Suggested Usage
## Take notes
Take your notes in markdown, however you like.

## Organize the flow of the report
In this part, we're taking advantage of Obsidian's native ability to quickly split files up.

Maybe I'll make a video to better demonstrate what I mean here.  Need to think on this.


# To Do
- [ ] incorporate automatic references to images?
- [ ] scripts
    - [ ] generate report
        - [ ] gather files: frontmatter, md
    - [ ] render/preview markdown document
- [ ] frontmatter
    - [ ] automatically include frontmatter in new notes (for image rename)
    - [ ] determine what maps to where from frontmatter -> report
        - [ ] make frontmatter template