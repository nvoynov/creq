# [f.prj] Project repository
{{parent: f
order_index: .f .e}}

The system shall provide a `Project repository` component. The component shall provide the following items:

* [[.f]];
* [[.e]];

## [.e] Storage

The storage shall provide the following CReq project structure:

* `doc/` - output documents folder;
* `doc/assets/` - assets folder;
* `req/` - requirements repository;
* `knb/` - knowledge base;
* `lib/` - library folder;
* `tt/` - templates folder;
* `<project>.thor` - specific project tasks;
* `README.md`

## [.f] Functions

### [.new.prj] Create a new CReq project
{{status: tbd}}

__Inputs__

* `project_name`, String, required


### [.new.req] Create a new requirements file
{{status: tbd}}

__Inputs__

* `id`, String, required;
* `title`, String, optional;
* `template`, String, optional.

### [.doc] Create a output markdown document
{{status: tbd}}

__Inputs__

* `title`, String, optional;
* `query`, String, optional, see [[f.rpo.f.query]].

### [.pub] Create a output document
{{status: tbd}}

__Inputs__

* `title`, String, optional;
* `format`, String, optional, `html` by default;
* `query`, String, optional, see [[f.rpo.f.query]].
