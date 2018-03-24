# [.e] Requirements storage
{{parent: f.req}}

The component shall provide a file storage for the requirements. Requirements inside the storage shall be presented by plain text files. Files can be arranged using the folder structure.

The component storage shall provide the following items that both represent `Requirement`:

* [[.e]];
* [[.f]].

## [.e] Requirement entity

The entity is the presentation of a requirement for processing inside the system.

Field      | Type       | M | Description                      
:--------- | ---------- | - | :--------------------------------
Id         | String     | Y | The entity unique identifier
Parent     | String     |   | Reference to parent requirement  
Items      | Collection |   | Array of child requirements      
Title      | String     |   |                                  
Attributes | Hash       |   |                                  
Body       | Text       |   |                                  

## [.f] Requirement file

The system shall use the following requirements file format:

```markdown
# [<id>] <title>
{{
<attribute1>: value1
<attribute2>: value2  
}}
<body>

## [<id>] <title>
<body>
```
### [.hdr] Header

Each file must begin with a header line. The header line consists of the header sign `#`, an identifier, and a title. Identifier and title optional parameters.

### [.met] Metadata

Each header can be followed (optional section) by metadata block `{{}}`. The block can contain one or more parameters, separated semicolons or a new string.

Each parameter represented as `key: value`, where the `key` is a sequence of  `[a-z,A-Z,._]` characters finished by a colon `:` and followed by a space. The remainder of the is determined as attribute value.

### [.sys] System attributes

The following metadata parameters considered as system attributes and influence to the system behavior. __TBD__ reference to writer

Attribute   | Value | Description
:---------- | :---- | --------------------------------------------------
parent      | id    | Reference to parent requirement
order_index | text  | Child requirements order
skip_meta   | true  | Skip output of `id` and `metadata` table in publishing

### [.bdy] Body

All the following text until the end of the file or next header is the requirement body.

### [.hhy] Headers structure

The requirement file can contain more than one requirement. There are possible to hold several requirement at the same level or requirements hierarchies. The child requirement must begin with a header level that is one less than the parent. Requirements at the same level have the same header level (same number of #).
