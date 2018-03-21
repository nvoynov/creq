# [f.rpo] Repository manager
{{
parent: f
order_index: .f .e .p .m
}}

The system shall provide a `Repository manager` component. The component shall provide the following items:

* [[.f]];
* [[.e]];
* [[.p]];
* [[.m]].

## [.e] Storage

The component shall provide storage for the [[f.req.e.e]]. The storage shall be a directory in the file system and placed at path provided by `repository.path` parameter.

## [.p] Parameters

The component shall provide the following parameters:

* `repository.path` specifies the directory in the file system where [[f.req.e.e]] are stored.

## [.m] Messages
