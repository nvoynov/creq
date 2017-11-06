# v0.1.X
* Added auto-generated requirements ids if it missing by the author.
* Added handling of leading dots in requirement ids `[.subid] -> [parent_id.subid]`

# v0.1.5
* Added error checking for wrong child_order attribute for `chk` command.
* Added section about link macro to README.md.

# v0.1.4
* Fixed error when requirement file starts with wrong header level, like `##` instead of `#`.
* Fixed `chk` command output for non-unique identifiers.

# v0.1.3
* Fixed errors output during repository reading process.

# v0.1.2
* Improved errors handling during parsing requirements files.
