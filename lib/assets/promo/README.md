# Promo

This project contains software requirements to Creq, and was created there by `creq promo` command to demonstrate Creq features.

The project repository has the following directories structure:
* doc/ - output documents folder;
* doc/assets/ - output documents assets folder;
* req/ - requirements folder;
* lib/ - library folder;
* tt/ - templates folder;
* creq.thor - file with custom Thor tasks for your special needs;
* README.md - this file.

# CLI

Play with this project through CLI. Just type few commands and see results.

    $ creq chk
    $ creq doc
    $ creq req

You can see all standard Creq commands list by `creq help`.

# Extend it yourself!

Creq CLI s based on the Thor library and you can extend it according to your project specific needs. For this purpose the project provide `creq.thor` file.

You can see all available thor commands by `thor list`; the specific to Promo Project commands by `thor list promo`; and help by specific command by `thor help promo:<command>`.
