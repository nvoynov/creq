# [cli.new] new command
{{
parent: cli
}}

The System shall provide CLI command `new`. When `new` command received, the System shall create a new requirement project.

## [cli.new.param] Parameters

The System shall provide the following parameters for the `req` command.

Name       | Type   | M | Default | Description
:--------- | ------ | - | ------- | :------------------------------
project    | String | Y |         | a folder for create project

## [cli.new.dir.exist] Requirement file exists

When directory with name input parameter `project` exist, the command `new` shall indicate the error message `Directory <project> already exists. Operation aborted.` and abort the command execution.

## [cli.new.struct] Create structure

The command shall create new project directory named by input parameter `project` and structure according to [[f.repo.struct]].

## [cli.new.files] Create files

The command shall create two additional files in root project directory:
* `README.md`, file shall contain a general information about the System and project directories structure;
* `<project>.thor`, file shall contain a simple example of CLI interface customization.
