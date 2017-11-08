# v0.1.6
* Added auto-generated requirements ids if it missing by the author.
* Added handling of leading dots in requirement ids `[.subid] -> [parent_id.subid]`.
* Added `pandoc FORMAT [OPTIONS]` CLI command to export requirements document in any supported format. It exec pandoc as `pandoc -s --toc #{options} -o requirements.#{format} pandoctmp.md`. There are some differences in output that will be explained later.
* Added new system attribute `requirement: false` that will suppress attributes table output.

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
