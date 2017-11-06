# Promo based Tracing

* functional requirements attribute `derived_by` and reference to user story;
* GraphViz of two subgraph - user stories and functional requirements with traces by `derived_by` attribute;
* think about other [trace types](lib/assets/other/taceability.md):
  * Creq source file *satisfy* functional requirement;
  * Creq spec file *validate* functional requirement.

# Creq

## Sources

* Handle headers without identifiers and auto-generated identifiers
* Introduced! Handle leading dots in identifiers, [.end.of.id]
* Provide custom DocWriter class for documents generation
* Adding `id-to-attributes` document generation options, when title will be generated without id and id will be added to attributes table.
* `creq serve` command
* Add graphviz macros for drawing?

# Promo

## Content

* Add readme section with few examples with adding requirements with errors (duplicate id, wrong links, wrong child order and wrong parents).

## Library

* Provide examples for EARS, User Story, Use Case, entity and REST/CRUD.

## promo.thor

* command `serve` as web site by Sinatra with Markdown / Kramdown options.
* traces, pert, fpa, graphviz
