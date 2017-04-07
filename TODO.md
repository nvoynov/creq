# Fixme

* Print duplicate requirement errors during `chk` and `doc` commands.

# Promo based Tracing

* functional requirements attribute `derived_by` and reference to user story;
* GraphViz of two subgraph - user stories and functional requirements with traces by `derived_by` attribute;
* think about other [trace types](lib/assets/other/taceability.md):
  * Creq source file *statisfy* functional requirement;
  * Creq spec file *validate* functional requirement.

# Creq

## Sources

* Add new check to `chk` command; check `child_order` attribute for wrong order (items that does not exist, items count more or less than `child_order` value).
* Fix errors with links macro in markdown quotes... or say about this "feature" in README.md
* Add graphviz macros for drawing

# Promo

## Content

* Add readme section with few examples with adding requirements with errors (duplicate id, wrong links, wrong sort order, wrong parents).

## Library

* Provide examples for EARS, User Story, Use Case, entity and REST/CRUD.

## promo.thor

* command `serve` as web site by Sinatra with Markdown / Kramdown options.
* traces, pert, fpa, graphviz
