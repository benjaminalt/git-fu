# git-fu

Collection of utilities for working with large codebases with many git repositories in nested directory structures.

- **git-list-all**: Recursively traverses a directory and prints the branch and HEAD commit hash of every git repository in the hierarchy.
Example usage:
```
$ git-list-all.sh path/to/root/dir | tee branch_list.txt
dir_b/repo_b                        master                            bd81091           
repo_a                              master                            0012519           
repo_c                              master                            2cca20c 
```

- **git-checkout-all**: Takes the output of git-list-all on standard input and checks out all matching repos (relative to a given root directory) to the given branches or commits.
Example usage:
```
$ cat branch_list.txt | git-checkout-all.sh path/to/other/root --branch
``` 
```
$ git-list-all.sh . | git-checkout-all.sh path/to/other/root --commit
```

This is useful e.g. for resetting the codebase to a precisely defined state.

- **git-run-all**: Recursively traverses a directory and runs a given git command in every git repository.
Example usage:
```
$ git-run-all.sh /path/to/root/dir status --porcelain

===== /home/bal/Projects/example/dir_b/repo_b
 M file_b.txt

===== /home/bal/Projects/example/repo_a
 M file_a.txt

===== /home/bal/Projects/example/repo_c
 M file_c.txt
 M file_d.txt
```