#!/bin/env python
import subprocess


def local_branches_not_on_remote():
    # Get a list of all local branches
    local_branches: list[str] = (
        subprocess.check_output(["git", "branch", "--format=%(refname:short)"])
        .decode()
        .split("\n")
    ) or []

    # Get a list of all remote branches
    remote_branches: list[str] = (
        subprocess.check_output(["git", "branch", "-r", "--format=%(refname:short)"])
        .decode()
        .split("\n")
    ) or []

    # Strip whitespace and remove empty strings
    local_branches: list[str] = [
        branch.strip() for branch in local_branches if branch.strip()
    ]
    remote_branches: list[str] = [
        branch.strip() for branch in remote_branches if branch.strip()
    ]

    # Extract remote branch names from remote branches
    remote_branches: list[str] = [
        branch.split("/", 1)[1] for branch in remote_branches if "/" in branch
    ]

    # Find branches that are local but not on the remote
    local_not_on_remote: list[str] = [
        branch for branch in local_branches if branch not in remote_branches
    ]

    return local_not_on_remote


if __name__ == "__main__":
    branches = local_branches_not_on_remote()
    for branch in branches:
        print(branch)
