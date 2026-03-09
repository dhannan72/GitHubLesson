# Git & GitHub FAQ

Answers to the questions you're probably thinking but haven't asked yet.

---

**Q: I just write R scripts on my laptop. Why do I need Git?**

Because your laptop is not a backup strategy. Git keeps a complete history of every change you make, so you can undo mistakes, recover deleted work, and see exactly what you changed and when. It's the difference between "I think this worked last week" and being able to prove it.

**Q: Can't I just use Save As and make copies?**

You can, and you'll end up with `analysis_v2_final_FINAL_actuallyFinal.R`. Git replaces that mess with a clean timeline. Every save point (commit) has a description, a timestamp, and your name on it. You can jump back to any point without cluttering your folder.

**Q: What's the difference between Git and GitHub?**

Git is the tool that tracks changes on your computer. GitHub is a website that stores your Git projects online. Think of Git as a logbook and GitHub as the library where you keep it. You can use Git without GitHub, but GitHub makes sharing and collaboration much easier.

**Q: I don't collaborate with anyone. Why do I need GitHub?**

Three reasons:

1. **Backup.** If your laptop dies, your work is safe on GitHub.
2. **Portfolio.** A GitHub profile with well-organised projects shows employers and supervisors that you can write reproducible code. This matters increasingly in biology.
3. **Future you is a collaborator.** Coming back to your own code six months later is collaboration with someone who left no notes. Commit messages are those notes.

**Q: Is this actually used in biology?**

Yes. Bioinformatics, computational biology, ecology, epidemiology -- any field that involves data analysis increasingly expects version control. Journals like *Nature* and *PLOS* now encourage or require code to be shared in public repositories. Funders like UKRI expect reproducible workflows. Git is the standard tool for this.

**Q: Will this help me get a job?**

Yes. Whether you go into research, industry, or science-adjacent roles, Git and GitHub on your CV signal that you can work with code professionally. Most job adverts in data science, bioinformatics, and research software mention Git.

**Q: I'm not a programmer though. Is this really for me?**

If you write code -- even short R scripts for coursework -- you're doing programming. Git isn't only for software developers. It's for anyone who wants to keep track of their work, avoid losing files, and be able to say: "here is exactly how I produced these results."

**Q: What if I break something?**

It's genuinely hard to lose work with Git. Every commit is saved permanently. If you make a mess, you can go back to any previous version. Branches let you experiment without touching your working code. The safety net is the whole point.

**Q: Do I need to use the command line?**

No. You can do everything through the GitHub website (as we do in the session) or through RStudio's built-in Git tab. The command line gives you more control when you're ready, but it's entirely optional.

**Q: How is this different from Google Drive or OneDrive?**

Cloud storage syncs files. Git tracks *changes*. The difference matters:

- Git shows you exactly which lines changed between versions
- Git handles two people editing the same file (merge conflicts) instead of creating "conflicted copy" duplicates
- Git lets you work on experimental changes in a branch without affecting the main version
- Git commit messages explain *why* something changed, not just *that* it changed

**Q: I've heard merge conflicts are horrible.**

They're not. A merge conflict just means two people changed the same line, and Git wants you to decide which version to keep. You'll resolve one in the session -- it takes about two minutes. Professional developers deal with these routinely. They're a minor inconvenience, not a disaster.

**Q: How does this help with reproducibility?**

Reproducibility means someone else (or future you) can take your code and data and get the same results. Git helps because:

- Your full analysis history is preserved, not just the final version
- Anyone can clone your repo and run your code
- Commit messages document your decision-making process
- The `.gitignore` file makes clear what's generated output vs. source material

This is increasingly the minimum expectation for computational work in the biological sciences.

**Q: How much time does this actually take to learn?**

The core workflow -- commit, push, pull -- takes an afternoon to learn and a week of use to feel natural. You already know how to save a file. A commit is just a save with a label. The rest builds from there.

**Q: What should I put on GitHub?**

Start with your analysis projects: R scripts, small datasets, and a README explaining what the project does. Don't upload sensitive data, passwords, or very large files. A good `.gitignore` file handles most of this automatically.

**Q: Any tips for getting started?**

1. **Start with one project.** Pick a current piece of coursework or a small analysis.
2. **Commit often.** Small, frequent commits with clear messages are better than one massive commit at the end.
3. **Write a README.** Even a few sentences explaining what the project does makes a huge difference.
4. **Don't worry about making it perfect.** Your first few repos will be messy. That's completely fine. The point is to start.
