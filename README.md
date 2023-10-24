# Loki

[![Static Badge](https://img.shields.io/badge/managed_with-loki-blue)](https://pub.dev/packages/loki) [![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

Loki is a command-line interface (CLI) tool designed for managing Dart and Flutter projects featuring multiple packages.

The inspiration for Loki was drawn from `melos`. However, `melos` lacked support for running applications with distinct flavors and encountered issues with hot reloading/restarting due to detached stdin. Hence, this package was conceived.

## Features

- Running apps ☑️
  - Running apps in (debug, release, profile) ☑️
  - Running apps in flavors ☑️
- Clean workspace ☑️
- Fetching dependencies in workspace ☑️
- List packages/apps in workspace ☑️
- Run custom scripts with or without standard input ☑️
- Validating config file ☑️

## Installation

To install the package from the command line after cloning the repository:

```sh
git clone https://github.com/cybertronbaka/loki.git
```
```sh
dart pub global activate --source path <path to cloned directory>
```
Alternatively, you can install the package directly using the following command:

```sh
dart pub global activate loki
```

## Setup

Loki is specifically engineered to function in tandem with a workspace. A workspace constitutes a directory encompassing all packages slated for simultaneous development. Its root directory should house a loki.yaml file.

### Configuring the Workspace

Consider the following file structure for our example workspace:

```
workspace/
  loki.yaml
  apps/
    app1/
      ...
      pubspec.yaml
    app2/
      ...
      pubspec.yaml
  
```

Subsequently, create a loki.yaml file at the root of the repository. Within this file, specify the name and packages fields:

```yaml
name: <project>
description: <description>
packages:
  - apps
```
## Usage
### Adding Scripts to the Workspace

Loki extends its functionality to include valuable features such as executing scripts across all packages. For example, to perform `flutter run` in an app, append a new script item to your loki.yaml:

```yaml
name: <project>
description: <description>
packages:
  - apps
scripts:
  run:p1:
    name: Run App1 # Optional
    description: <Description> # Optional
    exec: flutter run # Required
    working_dir: apps/app1 # Optional (Default is . )
    stdin: true # Optional
```

In this context,
- `name` denotes the script's name and is optional.
- `working_dir` determines where `exec` will be executed.
- `stdin: true` facilitates the script's capacity to receive input directly from users via the terminal. This proves valuable for scripts like flutter run to enable hot reload and hot restart.

#### To obtain a list of scripts, execute:

```sh
loki help run
```

#### To execute the run:p1 script, employ the following command:

```sh
loki run run:p1
```

#### To run an app

To run app app1 in flavor `dev` in `release`
```sh
loki app app1 --flavor dev -e release
```
or
```sh
loki app app1 -f dev -e release
```

#### To get assistance with running an app

```sh
loki app <app_name> -h
```
## Commands

Full commands list and args can be viewed by running `loki help`.

```shell
> loki help

 _     ____  _  __ _ 
/ \   /  _ \/ |/ // \
| |   | / \||   / | |
| |_/\| \_/||   \ | |
\____/\____/\_|\_\\_/
                 v0.0.1

A CLI tool for managing Dart & Flutter projects with multiple packages.

Made only because running flutter apps with melos was had an issue with stdin.

Made with ❤️  by Dorji Gyeltshen ( @cybertronbaka )

Usage: loki <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  app        Runs a flutter app in the workspace
  clean      Runs `flutter clean` in all packages and apps
  fetch      Install dependencies in packages and apps
  list       List all local packages in apps.
  run        Run a script by name defined in the workspace loki.yaml config file.
  validate   Validate loki.yaml config file.
  version    Print version information

Run "loki help <command>" for more information about a command.
```

## Readme badge
Using loki? Add a README badge to show it off:

[![Static Badge](https://img.shields.io/badge/managed_with-loki-blue)](https://pub.dev/packages/loki)

```markdown
[![Static Badge](https://img.shields.io/badge/managed_with-loki-blue)](https://pub.dev/packages/loki)
```

## Contributing

Contributions are always welcome!