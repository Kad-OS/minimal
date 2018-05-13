## KadOS

Based on Minimal Linux Live.

## How to build

The section below is for Ubuntu and other Debian based distros.

```
# Resove build dependencies
sudo apt install wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev

# Build everything and produce ISO image.
./build.sh
```

```
# Get latest commits from original repository
git remote add upstream https://github.com/ivandavidov/minimal.git
git fetch upstream
git checkout master
git rebase upstream/master
```

Thank you!
