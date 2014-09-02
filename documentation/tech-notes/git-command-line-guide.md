# Git Command Line Guide

This guide is a simplified git command list for working in a single remote configuration.  Full documentation is available:  http://git-scm.com/doc.

### Initialize a new project  

`git init`

From within project root directory


### Get (clone) a project from git 

`git clone <[https:// or git:]project-uri>`

### Update project from remote git repo

`git pull`

### Adding files to git  

`git add <file name or wildcard path>`

You cannot add blank directories.  Directories will automatically be added from the file path.  Use placeholder.txt in a directory you'd like to retain for the future.

*Examples:*

`git add readme.md`

`git add db/migrate/*`

### Check the status of changes

`git status`

Will give a list of added, modified and deleted files.  This will determine what will be checked-in during next commit.

### Commit one or more files

`git commit -m "Commit message" <filename(s)>`

`git commit -am` (Will commit all changes listed in `git status`)

### Creating a tag

Tags are lightweight and used for denoting a pointer to a specific commit.  Tags are good for milestones or version numbers to refer back to a meaningful time period.

`git tag <tag>`

`git tag -a <tag> -m "Tag annotation"` (annotated tag)

**Important:** Git tags are not pushed to remote server by default.  To do so, you must use `git push origin <tag>`

*Example:*

`git tag -a 1.2 -m "Release with logging infrastructure"`

`git push origin 1.2`

### Moving or Renaming Files

It is best to use git to rename or move a file so the action is intentionally known as such in SCM.  Otherwise, git will see one file as deleted and one file as added.

`git mv <source file or directory> <destination file or directory>`

### Showing the difference in a file

`git diff <filename>`

`git diff` (Show all the differences in all files)
  
  
  
#### To Do

* Stashing/Rolling back
* Branching
* How to handle a merge/conflicts

