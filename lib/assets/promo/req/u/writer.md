# [writer] As a requirements writer
{{parent: us}}

As a requirement writer

## [create.new.project] Create a new project

As a requirement writer, at any time, through CLI, I want to start a new requirements project, because I need to write requirements to a new software project.

## [write.separated.file] Write requirements in isolated markdown files

As a requirement writer, at any time, through text editor or CLI, I want to write requirements in isolated Markdown structured files in requirements repository folder, because that way many requirements authors can work with his own files separately (git history, e.t.c).

### [manage.requirement.attributes] Manage requirements attributes

As a requirement writer, at any time of editing requirement file, through text editor, I want to manage different requirements attributes (like requirement source, author, priority, dependencies, etc), because I want to use these attributes for different requirements selection.

### [manage.output.order] Manage requirements output order

As a requirement writer, at any time of editing requirement file, through text editor, I want to point a certain output requirements order for child requirements, because of requirements are written in separated files.

### [write.requirement.link] Write links to another requirements

As a requirement writer, at any time of editing requirement file, through text editor, I want to write short links to another requirements, because requirements often depends on each another and I need write references in efficient way.

## [use.requirement.template] Use requirement templates

As a requirement writer, at any time, through CLI, I want to use requirements templates, because it will improve my productivity as a requirement writer.

## [combine.separated.files] Combine isolated requirements into single document

As a requirement writer, at any time, through CLI, I want to combine isolated requirements files in repository into single consistent requirements document, because this document is standard output of requirements specification activity.

### [check.repo.consistency] Check repository consistency

As a requirement writer, at any time, through CLI, I want to check a requirements repository for consistency, because of its separated files nature, repository might have different errors that will produce wrong output document. It might be duplicate requirements ids, links to requirement that not exist, wrong sort order for children requirements.
