
Just subversion client executable from container where `svn` command can not be installed.

## Usage
As `svn` script
```bash
#!/bin/bash
exec docker run --rm \
    -e UID="$(id -u)" -e GID="$(id -g)" -e SVN_USERNAME -e SVN_PASSWORD \
    -v "$(pwd):/workspace" -v "$HOME/.subversion:/home/user/.subversion" \
    profiprog/svn svn $@
```
or just as an alias
```bash
alias svn='docker run --rm -e UID="$(id -u)" -e GID="$(id -g)" -e SVN_USERNAME -e SVN_PASSWORD -v "$(pwd):/workspace" -v "$HOME/.subversion:/home/user/.subversion" profiprog/svn svn'
```

Whe `SVN_USERNAME` and `SVN_PASSWORD` environment variables are deffined subversion client automaticaly use them.
