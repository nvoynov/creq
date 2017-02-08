# [f.repo] Repository
{{
parent: f
}}

The System shall provide the next functions for requirements repository:
* [[f.repo.load]];
* [[f.repo.chk]].

## [f.repo.struct] Repository structure

The System shall provide the `project repository` as directory with followed structure:
```
* doc/ - output documents folder;
* doc/asstes/ - output documetns assets folder;
* req/ - requirements folder;
* lib/ - library folder;
* tt/ - templates folder;
```

## [f.repo.load] Load requirements into single requirement entity

The System shall provide the ability to load all requirements files that placed inside `req` directory and its sub-directories into a single requirement entity.

### [f.repo.load.hrch] Hierarchy building

When all files are loaded, the System shall build the right requirements hierarchy through the `parent` attribute (see [[f.req.file.attr.sys]] and [[f.req.file.struct]]).

### [f.repo.load.sort] Sort child requirements

When all files are loaded, if any requirement has a `child_order` system attribute, the System shall sort its child requirements according to the attribute value.

## [f.repo.chk] Check requirements

The System shall provide the ability to check loaded requirements for the following errors:
* duplicates of requirement ids among requirement files;
* wrong links to other requirements in requirement body;
* wrong parent references through `parent` attribute;
* wrong child requirement order for `child_order` attribute.

### [f.repo.chk.dup] Duplicate id
TBD: provide description

### [f.repo.chk.lnk] Wrong links
TBD: provide description

### [f.repo.chk.parent] Wrong parent references
TBD: provide description

### [f.repo.chk.order] Wrong child requirements order
TBD: provide description
