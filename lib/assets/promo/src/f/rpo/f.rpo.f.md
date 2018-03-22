# [.f] Functions
{{parent: f.rpo}}

The component shall provide the following functions:

* [[.load]];
* [[.query]];
* [[.check]].

## [.load] Load repository

The component shall provide `load repository` function.

__Inputs__:

* NO

__Outputs__:

* [[f.req.e.e]]

__Sequence__

* Load all the [[f.req.e.f]] from [[..s]].
* Build hierarchy according to `parent` and `order_index` metadata attributes (see [[f.req.e.f.met]] for details).
* Return [[f.req.e.e]].

## [.query] Query repository

The component shall provide `query repository` function.

__Inputs__:

* `query`, String, required, represents Ruby language expression for `eval` function

__Outputs__:

* `query_result`, Array[[[f.req.e.e]]], array of requirements that match to the `query` input parameter

__Sequence__

The functions finds all the requirements that match to the `query` input parameter, packs those to array and returns the array.

## [.check] Check for errors

The component shall provide `check repository` function.

__Inputs__:

* [[f.req.e.e]]

__Outputs__:

* `errors`, __TBD__

__Sequence__

* Create empty output `errors`.
* Call [[.dup]] and place the output to `errors`.
* Call [[.wrong.parent]] and place the output to `errors`.
* Call [[.wrong.order]] and place the output to `errors`.
* Call [[.wrong.links]] and place the output to `errors`.
* Return `errors`.

### [.dup] Find non-unique IDs
{{status: tbd}}

### [.wrong.parent] Find wrong parents
{{status: tbd}}

### [.wrong.order] Find wrong order
{{status: tbd}}

### [.wrong.links] Find wrong links
{{status: tbd}}
