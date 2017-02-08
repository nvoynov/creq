# [cli.doc] doc command
{{
parent: cli
}}

The System shall provide CLI command `doc`. When command `doc` received, the System shall create requirements document `doc/requirements.md` (well-formed markdown file) from requirements files. All necessary information about document creation is pointed in [[f.doc]] section.

## [cli.doc.rewrite] Rewriting requirements.md

The System shall rewrite file `doc/requirements.md` if it exists.
