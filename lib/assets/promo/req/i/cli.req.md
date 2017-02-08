# [cli.req] req command
{{
parent: cli
}}

The System shall provide CLI command `req`. When `req` command received, the System shall create a well-formed Markdown file which represents `requirement entity` (see [[i.req.data]] and [[i.req.file]] for details).

## [cli.req.param] Parameters

The System shall provide the following parameters for the `req` command.

Name       | Type   | M | Default | Description
:--------- | ------ | - | ------- | :------------------------------
id         | String | Y |         | Unique requirement identifier
title      | String | N | = id    | Requirement tile
template   | String | N |         | Template for the requirement body

### [cli.req.param.tmpl] Template parameter provided

When `Template` parameter is provided for `req` command, the System shall place the text form template file to requirement body.

#### [cli.req.param.tmpl.mid] Template macro @@id

The System shall replace macro text `@@id` in template text by `id` parameter.

#### [cli.req.param.tmpl.mtt] Template macro @@title

The System shall replace macro text `@@title` in template text by `title` parameter.

Suppose, you have a template `action_template.md` with the following content.

```markdownn
The System shall provide action `@@title`.

## [@@id.para] Parameters
The System shall provide the following parameters for the `@@title` action.

## [@@id.flow] Flow
The System shall provide the following execution flow for the `@@title` action.
```

When the System executes `req` command with parameters `action.foo "Foo" -t=action_template.md` (a template `action_template.md` is provided as a parameter), the output file will have the following content.

```
# [action.foo] Foo
The System shall provide action `Foo`.

## [action.foo.para] Parameters
The System shall provide the following parameters for the `Foo` action.

## [action.foo.flow] Flow
The System shall provide the following execution flow for the `Foo` action.
```

## [cli.req.file.name] File name

The System shall name the output file as `<id>.md`.

## [cli.req.file.name.exist] Requirement file exists

When requirement file with the same name exists in file system, the command `req` shall indicate the error message `File <file_name> already exists. Operation aborted.` and abort the command execution.
