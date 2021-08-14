yaml-spec branches
==================

This branch called `_` is for checking out all the branches at once in the
yaml-spec repository.
It uses `git worktree add ...` to checkout the branch into a subdirectory.

To use it, run:
```
git worktree prune
git worktree add _
cd _
make all
```

## Makefile Usage

* `make list`

  List all the feature branches in the yaml-spec repository

* `make all`

  Make a worktree copy of each feature branch in this directory

* `make status`

  Get `git status` of each branch directory

* `make clean`

  Remove the feature branch directories with a clean `git status`
