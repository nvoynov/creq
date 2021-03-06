## v0.2.11, 2018-03-29

* Fixed errors of `toc/doc/pub --query` when query returns `[]`.
* Added tests for `toc`.

## v0.2.10, 2018-03-24

* Fixed knowledge base folder `kbd` -> `knb`.
* Fixed settings, now it read `creq.yml` once before return any parameter value.
* Deleted creation of git repository from `creq new`.

## v0.2.9, 2018-03-23

* Updated content of [README](README.md) and [CReq Promo](lib/assets/promo) according to the all new features.
* Updated  of  according to new features.
* Provided ability to change CReq project directories structure through `creq.yml`.
* Changed CReq project directories structure to a set of `bin`, `src`, `lib`, `tt`, and `kbd`.
* Provided ability of [queries to repository](README.md#query-option).
* Established `parent`, `skip_meta`, and `order_index` [system attributes](README.md#attributes).
* Provided [Publicator](lib/assets/promo/lib/publicator.rb) and [Prioritizer](lib/assets/promo/lib/prioritizer.rb) examples of an automated task.
* Provided [ParamHolder](lib/creq/param_holer.rb) class for settings management.
* Provided ability to use [relative links](/README.md#relative-links) in requirements body and metadata.
