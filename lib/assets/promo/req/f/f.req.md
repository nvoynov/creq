# [f.req] Requirement
{{
parent: f
}}
The System shall provide the `Requirement` entity.

## [f.req.data] Requirement data

The System shall provide the following data attributes for `Requirement` entity:

Name       | Type               | M | Description
:--------- | ------------------ | - | :-------------------------------------
id         | String             | Y | Unique requirement identifier
title      | String             | Y | Requirement title
attributes | Hash               | N | Requirement attributes
body       | Text               | Y | Requirement body
parent     | Reference          | N | Reference to parent requirement object
items      | Array[Requirement] | N | Array of child requirement entities

## [f.req.file] Reading requirement from a file

The System shall provide the ability to read Requirement from the formatted Markdown file. An example of this formatted Markdown file is provided below.

```
# [<requirement id>] <requirement title>
{{
<attribute1>: value1
<attribute2>: value2  
}}
<body>

## [<child requirement id>] <child requirement title>
<child requirement body>
```

### [f.req.file.attr] Attributes excerpt

The System shall parse section `{{ }}` as the hash of requirement attributes. Attributes section might follow (the section is optional) the header section. The header section might be separated from attributes section by an empty line or a line of spaces.

### [f.req.file.attr.key] Key and Value

The System shall support attribute keys written as a sequence of `[a-z,A-Z,._]` characters finished by a colon `:` and followed by a space. The remainder of the line must be determined as attribute value.

### [f.req.file.attr.sys] System attributes

The System shall support the following list of system attributes. This attributes must be interpreted in a special way.

Attribute   | Value | Description
:---------- | :---- | --------------------------------------------------
parent      | [id]  | Reference to parent requirement
suppress_id | true  | Suppress output of the requirement id in header while creating a document.
child_order | text  | Order of child requirements while creating a document.

### [f.req.file.struct] Headers structure

The System shall parse at least four levels of markdown headers structure. Headers with low level and its paragraphs must be parsed as child requirements and placed into the appropriate `items` array of its parent requirement.

### [f.req.file.links] Link macro

The System shall provide ability to write references in requirement body to another requirements in short macro way `[[referenced.requirement.id]]`.
