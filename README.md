# xk6-it

**Reusable xk6 integration tests**

This repository contains xk6 integration tests and the test k6 extensions required for them.

## Usage

The integration tests can be run immediately after cloning the repository (see [Tasks](#tasks) section).

It is recommended to embed this repository in the git repository that will use it. The most convenient way of embedding is to use [git-subrepo](https://github.com/ingydotnet/git-subrepo), but git subtree or git submodule can also be used.

### Prerequisites

The following must be installed to run integration tests:
- xk6
- go toolkit
- [Bats](https://bats-core.readthedocs.io/) (Bash Automated Testing System)

### Configuration

The tests can be configured with the following environment variables:

Variable          | Description
------------------|------------
**`XK6`**         | The `xk6` tool to use. Default: `xk6` from the command search path.
**`K6_VERSION`**  | The k6 version to use. Default: the latest GitHub release.
**`K6_REPO`**     | The git repository to use in case of a fork. Default: empty, the official k6 repository will be used.

### Run

All integration tests can be run with a single command:

```bash
bats -r test
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
bats -r test
```

[it]: <#test---run-the-integration-tests>

### it-run - Run the integration tests of the run command

The `bats` tool is used to run the integration tests for `xk6 run` command only.

```bash
bats test/run.bats
```

[it-run]: <#it-run---run-the-integration-tests-of-the-run-command>

### it-build - Run the integration tests of the build command

The `bats` tool is used to run the integration tests for `xk6 build` command only.

```bash
bats test/build.bats
```

[it-build]: <#it-build---run-the-integration-tests-of-the-build-command>

### test - Test the test extensions

Integration testing of extensions used for testing using the `bats` tool.

```bash
bats -r ext
```

[test]: <#test---test-the-test-extensions>

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
: [lint], [test], [it], [doc], [makefile]

## Development Environment

We use [Development Containers](https://containers.dev/) to provide a reproducible development environment. We recommend that you do the same. In this way, it is guaranteed that the appropriate version of the tools required for development will be available.
