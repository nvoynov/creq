# Creq

* Provide tests for `--skipid` option of `doc`, `doc`, and `pub` commands.
* Provide `publish: false` system attribute that will suppress the requirements output.
* Provide extensions to build_repo process like LinkExpander.
* The `derived_by` system attribute and CLI command for tracing.
* Default order for attributes table, `id->status->derived_by`.
* Make markdown links working in `GitLab`.
* Add tests for `doc` and `publish`.
* Add version of `creq` and `pandoc` to published documents.
* To think about `release` command with `git tag`.
* To think about `ERB` templates.
* To think about `req package` command that creates requirement and folder with the same name, sth. like recommended gem structure.

# Promo

* Add tracing by `derived_by` attribute to promo.thor.
* To think about GraphViz, PERT, FPA.
* To think about diagrams like https://mermaidjs.github.io/
* Add few examples with adding requirements with errors (duplicate id, wrong links, wrong child order and wrong parents).
