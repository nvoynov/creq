# [f.doc] Create requirements document
{{
parent: f
}}

The System shall provide the ability to create a requirements document file. This file must contain all requirements loaded by [[f.repo.load]] function. This file must be a well-formed Markdown file.

## [f.doc.header] Writing headers

The System shall write requirement header as a standard Markdown header `# [id] title\n`. The level of header must be calculated through the requirement depth in requirement hierarchy.

### [f.doc.header.skipid] 'suppress_id' system attribute

When requirement contains a special attribute `{{suppress_id: true}}`, the System shall suppress the `[id]` output part of header.

## [f.doc.attr] Attributes section

When requirement contains any attributes except special attributes (see [[f.req.file.attr.sys]]), the System shall write a table of attributes after requirement header in the following way.

Attribute   | Value
:---------- | :------
attribute 1 | value 1
attribute 2 | value 2

## [f.doc.links] Replace links macro

When requirement body contains links macros with other requirements `[[reference.requirement.id]]`, the System shall replace these links macros with the right link to requirement in the target document by right markdown link `[requirement header](requirement-reference)`.
