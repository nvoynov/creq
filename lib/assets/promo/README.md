# CReq Promo

The purpose of this project is the CReq promotion by the example of writing the `CReq requirements specification` using the CReq. The project also plays as the testing laboratory of new features.

* [Repository](#repository)
* [CLI](#cli)
* [Promo CLI](#promo-cli)

## Repository

The project has the following folders structure:

* `bin/` - for output documents;
* `bin/assets` - for any assets provided by the documents;
* `knb/` - knowledge base for any helpful information;
* `lib/` - place for Ruby extensions;
* `src/` - requirements repository;
* `tt/` - templates;
* `promo.thor` - the project automating tasks;
* `README.md` - this file.

## CLI

You can see list of all the CReq commands by `creq help` and get help of a certain command by `creq help <commmand>`.

Play with CLI, type some commands and see results.

    $ creq help
    $ creq help chk
    $ creq chk
    $ creq toc
    $ creq doc
    $ creq pub

## Promo CLI

CReq CLI s based on the `Thor` gem and you can extend it according to your project specific needs. For this purpose `promo.thor` is used. To see all the Promo automating tasks type `thor list promo` or `thor help promo`.

## Extensions

When you want to make some specific project automated task, place your Ruby sources to the `lib` folder and use it from `promo.thor` file.
