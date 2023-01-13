# git-activity-exporter

🟩 Export commit activity (and nothing else) from a source repo to a new repo

## Usage

```
Usage: ./git-activity-exporter.sh [options]

Options:
--source=<source>            Required. The path to the source repository
--target=<target>            Required. The path to the target repository
--author=<author>            Optional. The author of the commits. Defaults to ""
--commit_message=<message>   Optional. The commit message. Defaults to ""
--branches=<branches>        Optional. The branches to copy commits from.
                                        Space separated list of branches.
                                        Defaults to the current branch and its parents
```

## Why

### Scenario 1

You work at company, which uses GitLab to host their git repositories. You are
about to leave the company. Before you leave, you'd like your commits to show on
your GitHub contributions graph. You'd rather not simply copy the company
repository to your personal GitHub account, because you don't own it.

Instead, with git-activity-exporter, you copy your commit dates from the company
repository to a new repository. These commits are blank and contain no
information. You can push this new repository to your personal GitHub account,
without worrying about any sensitive information being leaked.

### Scenario 2

You share a repo with a team. At one point as a team you (for some reaosn)
decide that instead of making new repositories that import the repo, you will
simply make branches, one for every user. Your work in your branch does not show
up on your contributions graph.

If you simply make a clone repo of your branch and set your branch as default in
that repo, your commits in the main branch get double-counted. If instead you
export only the commits from your branch with git-activity-exporter, you can
cleanly show your activity in your branch without double-counting your previous
contributions before branching.
