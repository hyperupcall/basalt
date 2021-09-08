# Basalt

Basalt is the ultimate Bash (and Zsh, Fish, etc.) Package Manager

STATUS: BETA (expect breaking changes until a post-beta release)

---

Basalt is a fork of [basher](https://github.com/basherpm/basher) that adds a _ton_ of new functionality. It makes it significantly easier to install Bash, Zsh, etc. projects to your computer. Often, these projects / scripts are _not_ available through official `apt`, `DNF`, `pacman` repositories, or even from unofficial sources like third party apt repositories or the [AUR](https://aur.archlinux.org)

Let's say you want to install [rupa/z](https://github.com/rupa/z), [tj/git-extras](https://github.com/tj/git-extras), [aristocratos/bashtop](https://github.com/aristocratos/bashtop), and [JosefZIla/bash2048](https://github.com/JosefZIla/bash2048). Simply run the following

```sh
$ bpm global add rupa/z tj/git-extras aristocratos/bashtop JosefZIla/bash2048
```

**NOTE**: This project is called `Basalt`, but the binary is called `bpm` and not `basalt` because that was the previous name of this repository. The name change is only reflected in the `wip` branch, which is essentially a near-complete rewrite of the package manager with reasoning explained in [ADR-1](./docs/architecture/ADR-1.md). It will be merged soon

This symlinks all executable scripts to a common directory. It does this for completion files and man pages as well

```sh
$ exa -l --no-permissions --no-filesize --no-user ~/.local/share/bpm/cellar/bin/
bash2048.sh -> /home/edwin/.local/share/bpm/cellar/packages/github.com/JosefZIla/bash2048/bash2048.sh
bashtop -> /home/edwin/.local/share/bpm/cellar/packages/github.com/aristocratos/bashtop/bashtop
git-alias -> /home/edwin/.local/share/bpm/cellar/packages/github.com/tj/git-extras/bin/git-alias
git-archive-file -> /home/edwin/.local/share/bpm/cellar/packages/github.com/tj/git-extras/bin/git-archive-file
...
```

To be able to access the binaries, completion files, and man pages in your shell, simply add a two-liner in your shell configuration

```sh
# ~/.bashrc
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin:$PATH"
eval "$(bpm init bash)" # zsh and fish are also supported
```

See [Installation](./docs/installation.md) and [Getting Started](./docs/getting-started.md) for more details


## Features

- Local and user-wide package installation
- Configure (optionally) exactly which directories are used for completions, binaries, or man pages
- Works with essentially all popular Bash projects out of the box
- 240+ Tests

## Alternatives Comparison

Why not use `bpkg` or `Basher`? Because `hyperupcall/basalt`...

- Can install multiple packages at once
- Install local dependencies for a particular project (bpkg and basher)
- Does not use a `package.json` that clobbers with NPM's `package.json` (bpkg)
- Does not automatically invoke `make` commands on your behalf (bpkg)
- Does not automatically source a `package.sh` for package configuration (basher)
- Is able to install more repositories out-of-the-box
- Respects the XDG Base Directory specification (bpkg)
- Is faster (bpm considers exec and subshell creation overhead)
- Has a _much_ improved help output (basher)
- Prints why a command failed, rather than just printing the help menu (basher)
- Better bpm completion scripts
- More flexibly parses command line arguments (basher)
- Install local directories as packages (bpkg)

I forked Basher because it had an excellent test suite and its behavior for installing packages made more sense to me, compared to `bpkg`

Prior art

| Software        | Deps | Versions | Locations          | Completions |
|---------------- |------|----------|--------------------| ----------- |
| hyperupcall/basalt | Yes  | Yes      | Global, User, Repo | Yes         |
| [basher]        | Yes  | No       | Global, User       | Yes         |
| [bpkg]          | Yes  | Yes      | Global, User, Repo | Yes         |
| [bpm-rocks/bpm] | Yes  | No       | Global, User, Repo | No          |
| [Themis]        | Yes  | Yes      | Global, User, Repo | No          |
| [xsh]           | ?    | ?        |                    |             |
| [shpkg]         |      |          |                    |             |
| [jean]          |      |          |                    |             |
| [sparrow]       |      |          |                    |             |
| [tarp]          |      |          |                    |             |
| [shundle]       |      |          |                    |             |

[basher]: https://github.com/basherpm/basher
[bpkg]: https://github.com/bpkg/bpkg
[bpm-rocks/bpm]: https://github.com/bpm-rocks/bpm/
[Themis]: https://github.com/ByCh4n-Group/themis
[xsh]: https://github.com/alexzhangs/xsh
[shpkg]: https://github.com/shpkg/shpkg
[jean]: https://github.com/ziyaddin/jean
[sparrow]: https://github.com/melezhik/sparrow
[tarp]: https://code.google.com/archive/p/tarp-package-manager/
[shundle]: https://github.com/javier-lopez/shundle
