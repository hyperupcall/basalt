# `basalt.toml`

This is a complete reference to the `basalt.toml` file, found in Bash packages. There are currently two top-level objects: `package` and `run`

Note that none of these options have any defaults, and arrays _**must**_ only span single lines

## `[package]`

Metadata that describes the package and its purpose

### `type`

Not yet used

### `name`

Not yet used

## `slug`

Not yet used

### `version`

Not yet used

### `authors`

Not yet used

### `description`

Not yet used

## `[run]`

Metadata that affects how the package is ran (either as a library or executable)

### `dependencies`

Array of both development and production dependencies

```toml
dependencies = ['bats-core/bats-support@v0.3.0', 'github.com/bats-core/bats-assert@v0.3.0']
```

### `binDirs`

Array of directories that contain executable files. These files will be symlinked under a `bin` directory in `.basalt`. If the package is installed globally or locally, executables in this directory are made available via the `PATH` variable

```toml
binDirs = ['bin']
```

### `sourceDirs`

Array of directories that contain shell files which are sourced during the initialization process. In other words, after a package calls `basalt.package-init`, `basher` will source _all_ files indirectly specified by `sourceDirs` for each of its dependencies. This field is not used when installing a package globally

```toml
sourceDirs = ['pkg/src', 'pkg/src/source', 'pkg/src/util']
```

### `builtinDirs`

Array of directories that contain C source code for custom dynamic builtins. These files will automatically be loaded, somewhat analogous to `sourceDirs`

```toml
builtinDirs = ['pkg/builtins']
```

### `completionDirs`

Array of directories that contain completion scripts. These files will be symlinked under a `completion` directory in `.basalt`. If the package is installed globally, these files will automatically be made available to the shell after `basalt global init <shell>`

```toml
completionDirs = ['pkg/completions']
```

### `manDirs`

Array of directories that contain man pages. It does not traverse subdirectories, including `man1`, `man3`, etc. These files will be symlinked under a `man` directory in `.basalt`. Currently, the `MANPATH` is not modified for global installations; the manpages should be detected automatically

```toml
manDirs = ['pkg/share/man']
```

### `[run.shellEnvironment]`

Not yet used

Key value pairs of what environment variables to inject into your application

```toml
[run.shellEnvironment]
LANG = 'C'
LC_ALL = 'C'
```

### `[run.setOptions]`

Key value pairs of what shell options to enable or disable

```toml
[run.setOptions]
errexit = 'on'
pipefail = 'on'
```

### `[run.shoptOptions]`

Key value pairs of what shell options to enable or disable

```toml
[run.shoptOptions]
extglob = 'on'
nullglob = 'on'
```
