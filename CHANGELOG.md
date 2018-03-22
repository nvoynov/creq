## v0.2.X (2018-03-18)
* Added new templates;
* Change `promo` project;
* Added `-q/--query QUERY` option for `toc/doc/pub` (instead of `REQ_ID --skipid`);
* Added `Repository#query` function, see README;
* Deleted `REQ_ID --skipid` options in `toc/doc/pub`;
* Added `skip_meta` system attribute that skip output `[[id]]` in headers and attributes table for `doc` and `pub` commands.
* Deleted `suppress_id` system attribute;
* Added specs for writers.
* `DocWriter` and `PubWriter` classes for `doc` and `pub` commands respectively.
* Started new promo content

## v0.2.0 (2018-03-16)
* Added [relative links](/README.md#relative-links).
* Fixed position of `id` attribute for publishing; now it always goes first.
* Improved README.md template for `new` CLI.

## v0.1.9 (2018-03-10)
* `toc`, `doc`, `pub` CLI provides ability to select a certain requirements subtree by specifying `REQ_ID` parameter. Those also have `--skipid` option that gives the ability to skip some requirements from publishing. Maybe some specifics of `thor` and to use this feature you need to specify the option as `creq toc/doc/pub --skipid "id1 id2"`.

## v0.1.8
* `doc` CLI command accepts the `req` parameter and now you can build a document from any requirement as the document root.
* `pandoc` CLI command replaced by `publish` command. It also provides `req` parameter and you can specify root requirement for the publishing.
* Added `toc` CLI command that outputs `Table of contents` to console
* Added templates for `Use Case` and `Meeting minutes`.

## v0.1.7
* Fixed `pandoc` CLI command with empty document body.
* Fixed appearance of `requirement` attribute in attributes table.

## v0.1.6
* Added auto-generated requirements ids if it missing by the author.
* Added handling of leading dots in requirement ids `[.subid] -> [parent_id.subid]`.
* Added `pandoc FORMAT [OPTIONS]` CLI command to export requirements document in any supported format. It exec pandoc as `pandoc -s --toc #{options} -o requirements.#{format} pandoctmp.md`. There are some differences in output that will be explained later.
* Added new system attribute `requirement: false` that will suppress attributes table output.

## v0.1.5
* Added error checking for wrong order_index attribute for `chk` command.
* Added section about link macro to README.md.

## v0.1.4
* Fixed error when requirement file starts with wrong header level, like `##` instead of `#`.
* Fixed `chk` command output for non-unique identifiers.

## v0.1.3
* Fixed errors output during repository reading process.

## v0.1.2
* Improved errors handling during parsing requirements files.
