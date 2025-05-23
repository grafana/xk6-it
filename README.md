# xk6-it

**Reusable xk6 integration tests**

This repository contains xk6 integration tests and the test k6 extensions required for them.

>[!CAUTION]
> **xk6 internal**
>
> The k6 extensions in this repository are used for xk6 integration testing. These extensions are not intended for end users.

## Usage

The preferred use of xk6-it is git cloning in a CI workflow. The integration tests can be run immediately after cloning the repository (see [Tasks](#tasks) section).

Another possible use is to embed this repository in the git repository that will use it. The most convenient way of embedding is to use [git-subrepo](https://github.com/ingydotnet/git-subrepo), but git subtree or git submodule can also be used.

### Prerequisites

The following must be installed to run integration tests:
- xk6
- go toolkit
- [Bats](https://bats-core.readthedocs.io/) (Bash Automated Testing System)
- [jq](https://github.com/jqlang/jq) (Command-line JSON processor)

### Run

All integration tests can be run with a single command:

```bash
bats test
```

The output will be something like:

```
test/build.bats
 ✓ ⚙ build.bats K6_VERSION=; XK6_K6_REPO=
 ✓ no args
 ✓ version arg
 ✓ --k6-version version
 ✓ K6_VERSION=version
 ✓ --k6-repo module
 ✓ XK6_K6_REPO=module
 ✓ --output dir
 ✓ -o dir
 ✓ --with module
 ✓ --with module=.
 ✓ --with module=local
 ✓ --with module=remote
 ✓ --replace module=local
 ✓ --replace module=remote
 ✓ --with module1=local1 --with module2=local2 --with module3=local3
test/lint.bats
 ✓ ⚙ lint.bats K6_VERSION=; XK6_K6_REPO=
 ✓ it
 ✓ base32
 ✓ ascii85
 ✓ base64-as-base32
 ✓ base64
 ✓ crc32
 ✓ sha1
 ✓ sha256
 ✓ sha512
test/run.bats
 ✓ ⚙ run.bats K6_VERSION=; XK6_K6_REPO=
 ✓ no arg
 ✓ subdirectory
 ✓ --with module=local
 ✓ --with module
test/special.bats
 ✓ ⚙ special.bats XK6_K6_REPO=
 ✓ latest
 ✓ master
 ✓ hash
```

### Configuration

The tests can be configured with the following environment variables:

Variable          | Description
------------------|------------
**`XK6`**         | The `xk6` tool to use. Default: `xk6` from the command search path.
**`K6_VERSION`**  | The k6 version to use. Default: the latest GitHub release.
**`XK6_K6_REPO`** | The git repository to use in case of a fork. Default: empty, the official k6 repository will be used.

### Filtering

Tests can be filtered by the following tags (using the bats `--filter-tags` flag):

Tag                  | Description
---------------------|------------
**`xk6:build`**      | Tests for the `xk6 build` command.
**`xk6:run`**        | Tests for the `xk6 run` command.
**`xk6:lint`**       | Tests for the `xk6 lint` command.
**`xk6:new`**        | Tests for the `xk6 new` command.
**`xk6:adjust`**     | Tests for the `xk6 adjust` command.
**`xk6:non-semver`** | Tests for special, non-semver compatible k6 versions.
**`xk6:smoke`**      | Tests for quick verification.

Detailed filtering can be achieved by combining the above tags. For example, selecting all smoke tests except smoke tests for the `xk6 run` command:

```bash
bats --filter-tags 'xk6:smoke,!xk6:run' test
```

## Tasks

The usual tasks can be performed using GNU make. The `Makefile` defines a target for each task. To execute a task, the name of the task must be specified as an argument to the make command.

```bash
make taskname
```

Help on the available targets and their descriptions can be obtained by issuing the `make` command without any arguments.

```bash
make
```

More detailed help can be obtained for individual tasks using the [cdo](https://github.com/szkiba/cdo) command:

```bash
cdo taskname --help
```

**Authoring the Makefile**

The `Makefile` is generated from the task list defined in the `README.md` file using the [cdo](https://github.com/szkiba/cdo) tool. If a contribution has been made to the task list, the `Makefile` must be regenerated using the [makefile] target.

```bash
make makefile
```

### it - Run the integration tests

The `bats` tool is used to run the integration tests.

```bash
bats test
```

[it]: <#test---run-the-integration-tests>

### test - Test the test extensions

Integration testing of extensions used for testing using the `bats` tool.

```bash
bats -r ext
```

[test]: <#test---test-the-test-extensions>

### security - Run security and vulnerability checks

The [gosec] tool is used for security checks. The [govulncheck] tool is used to check the vulnerability of dependencies.

```bash
gosec -quiet ./...
govulncheck ./...
```

[gosec]: https://github.com/securego/gosec
[govulncheck]: https://github.com/golang/vuln
[security]: <#security---run-security-and-vulnerability-checks>

### lint - Run the linter

The [golangci-lint] tool is used for static analysis of the source code. It is advisable to run it before committing the changes.

```bash
golangci-lint run ./...
```

[lint]: <#lint---run-the-linter>
[golangci-lint]: https://github.com/golangci/golangci-lint

### doc - Update documentation

Update the documentation files.

```bash
mdcode update
```

[doc]: <#doc---update-documentation>
[mdcode]: <https://github.com/szkiba/mdcode>

### makefile - Generate the Makefile

```bash
cdo --makefile Makefile
```
[makefile]: <#makefile---generate-the-makefile>

### all - Run all

Performs the most important tasks. It can be used to check whether the CI workflow will run successfully.

Requires
: [lint], [security], [test], [it], [doc], [makefile]

## Development Environment

We use [Development Containers](https://containers.dev/) to provide a reproducible development environment. We recommend that you do the same. In this way, it is guaranteed that the appropriate version of the tools required for development will be available.
