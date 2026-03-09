# Using Git with RStudio

A step-by-step guide for getting Git working on your own laptop with RStudio. This picks up where the browser-based session left off.

**What this guide covers:**

1. [Install Git](#1-install-git)
2. [Install GitHub CLI and log in](#2-install-github-cli-and-log-in)
3. [Tell Git who you are](#3-tell-git-who-you-are)
4. [Clone your repo into RStudio](#4-clone-your-repo-into-rstudio)
5. [The daily workflow: pull, edit, commit, push](#5-the-daily-workflow)
6. [Branches in RStudio](#6-branches-in-rstudio)
7. [Common problems and how to fix them](#7-common-problems)

---

## First: Terminal vs Console -- they are not the same thing

RStudio has two places where you can type commands, and they do completely different things. This catches everyone out at first.

### The Console (bottom-left pane)

- This is where you **run R code**
- The prompt looks like `>`
- You use it for things like `library(tidyverse)`, `read.csv()`, `renv::init()`
- Anything that is an R command goes here

### The Terminal (a tab next to the Console)

- This is where you **talk to your computer's operating system**
- The prompt looks like `$` (Mac/Linux) or `>` (Windows PowerShell)
- You use it for things like `git --version`, `gh auth login`, `git config`
- Anything that is a Git or system command goes here

### How to tell them apart

```
Console (R)                          Terminal (system)
┌──────────────────────────┐         ┌──────────────────────────┐
│ > library(tidyverse)     │         │ $ git status             │
│ > read.csv("data.csv")   │         │ $ gh auth login          │
│ > renv::snapshot()       │         │ $ git config --global    │
│                          │         │   user.name "Ada"        │
│ Prompt: >                │         │ Prompt: $ or >           │
│ Language: R              │         │ Language: Bash/Zsh/PS    │
└──────────────────────────┘         └──────────────────────────┘
```

### How to open the Terminal in RStudio

**Tools → Terminal → New Terminal**

It appears as a tab right next to the Console in the bottom-left pane. Click **Console** or **Terminal** to switch between them.

### The golden rule

- If the command starts with `git`, `gh`, or looks like a system command → **Terminal**
- If the command starts with a function name, uses `<-`, or looks like R code → **Console**

Throughout this guide, we'll always say which one to use. If you type a `git` command into the Console, you'll get an error. If you type R code into the Terminal, you'll also get an error. Both are harmless -- just switch to the right tab and try again.

---

## 1. Install Git

Git is the version control software that runs on your computer. GitHub is the website that hosts your repos online. You need Git installed locally before RStudio can use it.

### Mac

Open **Terminal** (search for it in Spotlight) and type:

```
git --version
```

If Git is already installed, you'll see a version number. If not, macOS will prompt you to install the **Xcode Command Line Tools** -- click **Install** and wait. This can take a few minutes.

### Windows

Download Git from https://gitforwindows.org and run the installer. **Use all the default settings** -- just keep clicking Next. The defaults are fine.

When it's done, open **RStudio**, go to **Tools → Terminal → New Terminal**, and type:

```
git --version
```

You should see a version number.

### Check RStudio can find Git

In RStudio: **Tools → Global Options → Git/SVN**

You should see a path in the **Git executable** box:
- **Mac:** `/usr/bin/git`
- **Windows:** `C:/Program Files/Git/bin/git.exe`

If the box is empty, click **Browse** and find the Git executable. On Windows it's usually at `C:\Program Files\Git\bin\git.exe`.

**Restart RStudio after changing this setting.**

---

## 2. Install GitHub CLI and log in

The GitHub CLI (`gh`) is the easiest way to authenticate. It handles all the password/token complexity for you.

### Install

- **Mac:** Open Terminal and run: `brew install gh` (if you have Homebrew) or download from https://cli.github.com
- **Windows:** Download from https://cli.github.com and run the installer

### Log in

Open a terminal (RStudio's terminal works: **Tools → Terminal → New Terminal**) and run:

```
gh auth login
```

You'll see a series of prompts. Choose these options:

```
? What account do you want to log into?  →  GitHub.com
? What is your preferred protocol?       →  HTTPS
? Authenticate Git with your GitHub credentials?  →  Yes
? How would you like to authenticate?    →  Login with a web browser
```

Your browser opens. Log into GitHub and click **Authorise**. Done.

To check it worked:

```
gh auth status
```

You should see a green tick and your username.

---

## 3. Tell Git who you are

Git labels every commit with your name and email. Set these once and forget about them.

In the terminal (RStudio's terminal is fine):

```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Use the **same email** you used for your GitHub account.

To check:

```
git config --global user.name
git config --global user.email
```

---

## 4. Clone your repo into RStudio

"Cloning" downloads your GitHub repo to your laptop and connects it so you can push changes back.

### Step 1: Get the repo URL

Go to your fork on GitHub (e.g. `github.com/YOUR-USERNAME/penguin-analysis`). Click the green **Code** button, make sure **HTTPS** is selected, and copy the URL.

It will look like: `https://github.com/YOUR-USERNAME/penguin-analysis.git`

### Step 2: Create a new project in RStudio

1. **File → New Project → Version Control → Git**
2. Paste the URL into **Repository URL**
3. The **Project directory name** fills in automatically (`penguin-analysis`)
4. Choose where to save it under **Create project as subdirectory of** (e.g. your Documents folder)
5. Click **Create Project**

RStudio downloads the repo and opens it. You should see your files in the **Files** pane.

### What just happened

You now have a local copy of your repo. The folder on your laptop is connected to the repo on GitHub. RStudio knows this is a Git project and shows you a **Git** tab in the top-right pane.

---

## 5. The daily workflow

There are four steps you'll repeat every time you work on your project. Think of it as: **pull → edit → commit → push**.

### Step 1: Pull (get the latest changes)

Before you start working, pull any changes that might exist on GitHub (e.g. from a collaborator, or from edits you made in the browser).

Click the **Pull** button (blue downward arrow) in the **Git** tab.

> **Rule of thumb:** Always pull before you start working. This avoids conflicts.

### Step 2: Edit your files

Work normally in RStudio. Edit your R scripts, save files, run code -- everything as usual. Git doesn't do anything until you tell it to.

### Step 3: Commit (save a snapshot)

When you've made changes you want to keep:

1. Open the **Git** tab (top-right pane in RStudio)
2. You'll see your changed files listed with coloured status icons:
   - **M** (blue) = Modified
   - **A** (green) = New file (Added)
   - **D** (red) = Deleted
   - **?** (yellow) = Untracked (new file Git doesn't know about yet)
3. **Tick the boxes** next to the files you want to include in this commit (this is called "staging")
4. Click **Commit**
5. A new window opens showing your changes (green = added lines, red = removed lines)
6. Write a **commit message** in the box -- a short description of what you changed
7. Click **Commit**

> **Good commit messages:** "Add summary statistics for flipper length", "Fix axis labels on boxplot", "Clean missing values from body mass column"
>
> **Bad commit messages:** "update", "stuff", "fixed it", "asdfgh"

### Step 4: Push (upload to GitHub)

Your commit is saved locally but GitHub doesn't know about it yet. Click the **Push** button (green upward arrow) in the **Git** tab.

Go to your repo on GitHub and refresh -- you'll see your changes there.

### The whole cycle, visually

```
  GitHub (remote)                    Your laptop (local)
  ┌─────────────┐                   ┌─────────────────┐
  │             │  ── Pull ──────>  │                 │
  │  Your repo  │                   │  Your project   │
  │  on GitHub  │  <── Push ──────  │  in RStudio     │
  │             │                   │                 │
  └─────────────┘                   └─────────────────┘
                                         │
                                    Edit files normally,
                                    then Commit to save
                                    a snapshot locally
```

---

## 6. Branches in RStudio

### Switch branches

In the **Git** tab, you'll see a dropdown showing your current branch (probably `main`). Click it to see all branches and switch between them.

When you switch branches, your files change to match that branch -- just like on GitHub.

### Create a new branch

1. Click the branch dropdown in the **Git** tab
2. Click the **New Branch** button (or the purple branching icon, depending on your RStudio version)
3. Type a name for your branch
4. Make sure "Sync branch with remote" is ticked
5. Click **Create**

You're now on the new branch. Any commits you make will go to this branch, not main.

### Merge via Pull Request

The easiest way to merge branches is still through GitHub in your browser:

1. Push your branch (green arrow)
2. Go to your repo on GitHub
3. GitHub usually shows a banner: **"your-branch had recent pushes -- Compare & pull request"**
4. Create the pull request, review, merge -- exactly like you did in the session

---

## 7. Common problems

### "I don't see a Git tab in RStudio"

**Cause:** RStudio doesn't think this is a Git project, or it can't find Git.

**Fix:**
- Check **Tools → Global Options → Git/SVN** -- is the Git executable path filled in?
- Did you open the project via **File → New Project → Version Control → Git**? If you just opened a folder, RStudio won't know it's a Git repo.
- Restart RStudio after changing Git settings.

### "Push failed -- rejected"

**Cause:** GitHub has changes you don't have locally (someone else pushed, or you edited on the web).

**Fix:** Pull first (blue down arrow), then push again. If there's a conflict, see below.

### "Merge conflict" after pulling

**Cause:** You and someone else changed the same line.

**Fix:** Open the conflicted file. You'll see markers like this:

```
<<<<<<< HEAD
Your version of the line
=======
The other version of the line
>>>>>>> abc1234
```

Edit the file to keep what you want. Delete the `<<<<<<<`, `=======`, and `>>>>>>>` markers. Save. Stage the file (tick the box in the Git tab). Commit.

### "Authentication failed" or "could not read username"

**Cause:** Git doesn't have permission to talk to GitHub.

**Fix:** Run `gh auth login` again in the terminal (see [step 2](#2-install-github-cli-and-log-in)).

### "Fatal: not a git repository"

**Cause:** You're in the wrong folder, or the project wasn't cloned properly.

**Fix:** Make sure you opened the project in RStudio (File → Open Project, and select the `.Rproj` file in your cloned folder). Don't just open individual R files.

### "I accidentally committed something I shouldn't have"

**Cause:** You staged and committed a file by mistake (e.g. a large data file or a file with passwords).

**Fix (if you haven't pushed yet):** In the terminal:

```
git reset HEAD~1
```

This undoes the last commit but keeps your changes. You can then unstage the unwanted file and commit again.

**Fix (if you already pushed):** Don't panic. You can remove the file in a new commit. If it contains sensitive information (passwords, API keys), contact your instructor.

### "My .gitignore isn't working -- Git still tracks the file"

**Cause:** The file was already tracked before you added it to `.gitignore`. The `.gitignore` only applies to new, untracked files.

**Fix:** In the terminal:

```
git rm --cached filename
```

Then commit. The file stays on your laptop but Git stops tracking it.

### RStudio feels slow with Git / large files

**Cause:** Large CSV files or many output files being tracked.

**Fix:** Make sure your `.gitignore` includes output folders (`figures/`) and large generated files. Only track source code and raw data.

---

## Quick Reference Card

| Action | How |
|--------|-----|
| **Pull** (get latest) | Git tab → Blue down arrow |
| **Stage** (select files) | Git tab → Tick the boxes |
| **Commit** (save snapshot) | Git tab → Commit button → Write message → Commit |
| **Push** (upload) | Git tab → Green up arrow |
| **Switch branch** | Git tab → Branch dropdown |
| **Create branch** | Git tab → Branch dropdown → New Branch |
| **See what changed** | Git tab → Click a file to see the diff |
| **See history** | Git tab → Clock icon (History) |
| **Open terminal** | Tools → Terminal → New Terminal |

---

## Summary

The complete setup is three things:

1. **Install Git** (one time)
2. **Run `gh auth login`** (one time)
3. **Clone via File → New Project → Version Control → Git** (once per project)

After that, your daily workflow is: **Pull → Edit → Commit → Push**.

That's it. Everything else is details you'll pick up as you go.
