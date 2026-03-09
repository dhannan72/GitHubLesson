# Managing R Packages with renv

A beginner's guide to making sure your R projects work on any computer, every time.

---

## The problem

You write an R script. It works perfectly on your laptop. You share it with a collaborator, or open it six months later on a different computer, and it breaks. The packages have updated, something changed, and your code no longer runs.

This happens because R packages change over time. A function that exists in one version might behave differently (or disappear) in the next. Your project depends on specific versions of packages, but R doesn't track that by default.

`renv` fixes this. It records exactly which package versions your project uses, so anyone can recreate the same environment and get the same results.

> **Console vs Terminal:** All `renv` commands are R functions, so they go in the **Console** (the `>` prompt where you run R code), not the Terminal. If you're unsure about the difference, see the [RStudio & Git tutorial](rstudio-git-tutorial.md) for a full explanation.

---

## How renv works (the short version)

```
Your project folder
├── renv.lock          ← A list of every package + exact version number
├── renv/              ← A private library of packages just for this project
├── .Rprofile          ← Tells R to use renv when you open this project
└── your scripts...
```

- Each project gets its **own** set of packages, separate from your system-wide R library
- The `renv.lock` file records every package and its version number
- When someone else clones your project, they run one command and get the exact same packages

Think of it like a recipe: `renv.lock` is the ingredient list with precise quantities, and `renv::restore()` is following the recipe.

---

## Getting started

### Install renv

You only need to do this once. In the R console:

```r
install.packages("renv")
```

### Set up renv in a project

Open your project in RStudio, then in the console:

```r
renv::init()
```

This does three things:
1. Scans your R scripts to find which packages you use
2. Creates a private package library for this project (the `renv/` folder)
3. Creates `renv.lock` with the exact versions

You'll see a message listing the packages it found. That's it -- renv is set up.

---

## The daily workflow

You don't need to think about renv much day to day. Just work normally. When something changes with your packages, there are three commands to know.

### Install a new package

Use `renv::install()` instead of `install.packages()`:

```r
renv::install("palmerpenguins")
```

This installs the package into your project's private library rather than your system-wide library.

> You can still use `install.packages()` -- it works fine. But `renv::install()` is better because it can install from GitHub as well as CRAN.

### Save your current packages to the lock file

After installing or updating packages, record what you have:

```r
renv::snapshot()
```

This updates `renv.lock` with whatever packages your project currently uses. **Commit the updated `renv.lock` to Git** so your collaborators get the changes.

### Restore packages from the lock file

When you clone someone else's project (or pull changes that updated `renv.lock`):

```r
renv::restore()
```

This installs exactly the packages listed in `renv.lock`. Everyone ends up with the same environment.

### The three commands, summarised

| Command | When to use it | What it does |
|---------|---------------|--------------|
| `renv::install("pkg")` | You need a new package | Installs it into the project library |
| `renv::snapshot()` | You've changed your packages | Updates `renv.lock` to match what's installed |
| `renv::restore()` | You've cloned a project or pulled changes | Installs packages to match `renv.lock` |

---

## Using renv with Git

These files **should** be committed to Git:

- `renv.lock` -- this is the whole point; it records your package versions
- `.Rprofile` -- tells R to activate renv for this project
- `renv/settings.json` -- renv configuration
- `renv/activate.R` -- the activation script

These files **should not** be committed (and renv's own `.gitignore` handles this automatically):

- `renv/library/` -- the actual installed packages (too large, platform-specific)

When renv initialises, it creates a `.gitignore` inside the `renv/` folder that handles this for you. You don't need to configure anything.

### The workflow with Git

1. You install or update a package
2. Run `renv::snapshot()` to update `renv.lock`
3. Commit `renv.lock` to Git and push
4. Your collaborator pulls and runs `renv::restore()`
5. They now have the same packages as you

---

## A complete example

Starting a new penguin analysis project from scratch:

```r
# 1. Open your project in RStudio, then initialise renv
renv::init()

# 2. Install the packages you need
renv::install("tidyverse")
renv::install("janitor")
renv::install("palmerpenguins")
renv::install("patchwork")

# 3. Write your analysis script and make sure it runs

# 4. Save the package state
renv::snapshot()

# 5. Commit renv.lock to Git (in the Git tab or terminal)
```

When a collaborator clones the project:

```r
# renv activates automatically when they open the .Rproj file
# They just need to run:
renv::restore()

# All four packages (plus dependencies) install at the exact versions you used
```

---

## Common questions

**Q: Do I need renv for coursework?**

For short scripts, probably not. But if you're working on a dissertation, a group project, or anything you want to be able to re-run in six months, it's worth the two minutes to set up. It's a good habit to build early.

**Q: Does renv slow anything down?**

No. Once packages are installed, everything runs at normal speed. The only time renv does extra work is during `init()`, `snapshot()`, and `restore()`.

**Q: What if I forget to snapshot?**

Nothing bad happens immediately. Your code still works. But `renv.lock` will be out of date, so a collaborator running `renv::restore()` won't get your latest packages. Run `renv::snapshot()` whenever you add or update a package.

**Q: Can I still install packages the normal way?**

Yes. `install.packages()` still works inside an renv project -- it installs into the project library. The difference is that `renv::install()` can also install from GitHub, and it gives you clearer messages about what it's doing.

**Q: renv::snapshot() says "no changes to the lockfile"**

This means your `renv.lock` already matches your installed packages. Nothing to do.

**Q: renv::restore() is taking ages**

The first restore on a new machine downloads every package from scratch, which can take a while if you have many packages (tidyverse alone has dozens of dependencies). Subsequent restores are faster because renv caches packages globally. 

**Q: I want to stop using renv in a project**

```r
renv::deactivate()
```

This switches the project back to using your system-wide R library. Your files aren't deleted, so you can reactivate later with `renv::activate()`.

**Q: What's the difference between renv and conda/venv?**

If you've used Python, renv fills the same role as virtual environments. It isolates packages per project. The concepts are the same, just the commands differ.

---

## Quick reference

```r
renv::init()              # Set up renv in a project (once)
renv::install("pkg")      # Install a package
renv::snapshot()          # Save current packages to renv.lock
renv::restore()           # Install packages from renv.lock
renv::status()            # Check if renv.lock is up to date
renv::deactivate()        # Turn off renv for this project
```
