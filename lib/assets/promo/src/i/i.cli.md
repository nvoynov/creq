# [i.cli] Command-line interface
{{parent: i}}

The system shall provide Command-line interface (CLI). The CLI shall provide the following command:

* [[.ver]];
* [[.hlp]];
* [[.hlp.cmd]];
* [[.new]];
* [[.req]];
* [[.chk]];
* [[.toc]];
* [[.doc]];
* [[.pub]].

## [.ver] Show version command

The CLI shall provide the `creq -v/--version` command. When user requests `creq -v/--version` command, the CLI prints CReq CLI version.

## [.hlp] Show commands

The CLI shall provide the `creq help` command. When user requests `creq help` command, CLI prints all the CReq CLI commands and short description of each command.

## [.hlp.cmd] Show help for a command

The CLI shall provide the `creq help <command>` command. When user requests the command, CLI prints help by the requested command.

## [.new] New project command

The CLI shall provide the `creq new <project>` command. When user requests the command, CLI calls the [[f.prj.f.new.prj]] function that creates new CReq project structure in the `<project>` directory.

## [.req] New requirement command

The CLI shall provide the `creq req <id> [<title>] [-t/--template TT]` command. When user requests the command, CLI calls [[f.prj.f.new.req]] function that creates new requirements file according to provided parameters.

## [.chk] Check repository command

The CLI shall provide the `creq chk [-q/--query <query>]` command. When user requests the command, CLI calls [[f.rpo.f.check]] function and prints the result.

## [.toc] Build TOC command

The CLI shall provide the `creq toc [-q/--query <query>]` command. When user requests the command, CLI calls [[f.rpo.f.load]] function and prints the requirements tree.

## [.doc] Create output document command

The CLI shall provide the `creq doc [-q/--query <query>]` command. When user requests the command, CLI calls [[f.prj.f.doc]] function and place the result to `doc` folder of [[f.prj.e]].

## [.pub] Create output document in format command

The CLI shall provide the `creq pub [-q/--query <query>]` command. When user requests the command, CLI calls [[f.prj.f.pub]] function and place the result to `doc` folder of [[f.prj.e]].
