# Creq

[![Join the chat at https://gitter.im/nvoynov-creq/Lobby](https://badges.gitter.im/nvoynov-creq/Lobby.svg)](https://gitter.im/nvoynov-creq/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/creq.svg)](https://badge.fury.io/rb/creq) [![Build Status](https://travis-ci.org/nvoynov/creq.svg?branch=master)](https://travis-ci.org/nvoynov/creq) [![Code Climate](https://codeclimate.com/github/nvoynov/creq/badges/gpa.svg)](https://codeclimate.com/github/nvoynov/creq)

The CReq is a simple and customizable tool for requirements management. It provides the ability of writing requirements in discrete markdown files and combining those files into a single and consistent requirements specification.

The CReq is simple enough in itself, but when you joint it with Ruby, a modern text editor, and Git, it gives you exceptional power and flexibility of requirements management process.

![Promo](lib/assets/promo/doc/assets/promo.png)

## Purpose

The project was created for the purpose to find a simple and efficient approach to requirements management practice (gathering, eliciting, writing, approval, prioritizing, efforts estimation; tracing to other project artifacts) by exploring:

* a simple but sufficient format of requirements format that is easy to use by a project team;
* a consistent requirements repository format that will be easy to use for both human and machine;
* a minimum set of required tools with the possibility of rapid adjusting to needs of certain projects, that are free and ready to use.

## Installation

Install the creq gem:

    $ gem install creq

You can also choose another way through repository cloning and install the gem by hand (check if you have [Bundler](http://bundler.io/) installed):

    $ git clone https://github.com/nvoynov/creq.git
    $ cd creq    
    $ bundle install
    $ bundle exec rake install

## Promo

The CReq is supported by a promo project that is a CReq project that contains software requirements of the gem. And you can copy the promo content into the current directory by `creq promo` command. When the promo content is copied, you can create CReq Requirements by `creq doc` command.

## Usage

### Requirements file format

Requirements file is a usual Markdown file with a few additional compliances. Let's look at the next two example files `content.md` and `feature1.md`.

**content.md**
```markdown
# [f] Functional requirements
{{
suppress_id: true
child_order: feature1 feature2  
}}
# [i] Interfaces
# [n] Non-functional requirements
# [c] Design constraints
```

**feature1.md**
```markdown
# [f1] Feature 1
{{
parent: f
status: proposed
source: nvoynov  
}}
The System shall provide the Feature 1.

## [f1.data] Data
The System shall provide the next data for `Feature 1`

## [f1.cmd1] Command 1
The System shall provide `Command 1`. When `Command 1` is received, the System shall do something.

## [f2.cmd2] Command 2
The System shall provide `Command 2`. When `Command 2` is received, the System shall do something other than `Command 1` (see [[f2.cmd1]] for details).
```

Every requirement starts with markdown header. All the text between headers is a requirement body. The body can contain an excerpt with requirements attributes.

#### Identifiers

Each requirement must have its unique identifier so that you can refer to the requirement in any part of the requirements document or for further work related to the requirement. That's why a recommended way is to put requirement_id straight into requirements header like this `# [requirement_id] requirement title`.

Requirements identifier can start with one dot like `[.suffix]`. When an identifier starts with dot, CReq will add parent requirement identifier before the dot. For the followed example,  `[.featre1]` will be `[req.id.feature1]`.

```markdown
# [req.id] Parent requirement
## [.feature1] Feature requirement
```

When requirement identifier is not provided, CReq will generate it automatically. And you can also combine all these features together. For the followed example, `First feature` will be `[req.id.01] First feature` and `Second feature` will become `[req.id.02] Second feature`.

```markdown
# [req.id] Parent requirement
## First feature
## Second feature
```

#### Attributes

The excerpt, the text in brackets `{{ }}`, contains requirement attributes. You can place here anything you need, like requirement status, source, author, priority, etc.

The next three attributes are **system attributes** and these influence to Creq behavior:

* `requirement: false` will suppress output table of requirement attributes (it might be helpful for headers or other parts of requirements document that is not a requirement);
* `suppress_id: true` will suppress output [id] in the header of the requirement;
* `child_order: feature1 feature2` will sort child requirements in provided order;
* `parent: f` will place `[f1]` requirements subtree as a child of the `[f]` requirement.

All other attributes (`status`, `source`, etc.) are **user attributes** and do not influence CReq behavior. These attributes are holding in requirements attributes hash.

#### Link macro

You can place a link to another requirement in requirements body by writing macros `[[requirement.id]]`. This macro will produce full-fledged markdown link `[[<id>] <title>](#<id>)` in output document produced by `doc` command. If requirement with `id` does not exist, CReq will produce something like `[id](#unknown)`.

There is a "feature" in current release than CReq will make a replacement for all occurrences of macro `[[id]]`, even if the occurrence is in markdown quotes.

#### Requirements tree

The CReq will parse two files displayed above and build the next requirements tree:

```
[f] Functional requirements
    [f1] Feature 1
         [f1.data] Data
         [f1.cmd1] Command 1
         [f1.cmd2] Command 2
[i] Interfaces
[n] Non-functional requirements
[c] Design constraints
```

#### Check errors

CReq can check requirements repository for duplicate requirement ids; wrong links, errors in `parent` and `child_order` attributes. To see the feature in action, run the next commands (I hope you already have `content.md` and `feature.md` files) and see the output.

    $ cp req/feature1.md req/feature2.md
    $ creq chk

#### Create requirements document

Fix the errors by providing unique ids in `req/feature.2md`, then run `creq doc`...

### CLI

CReq provides the followed commands:

* `new` - creates new CReq project in the current directory;
* `req` - creates a new requirement file;
* `chk` - checks the project repository consistence;
* `toc` - outputs table of contents of requirement repository;
* `doc` - combines requirements into single document;
* `publish` - creates requirements document in any format supported by 'pandoc' ([pandoc](https://pandoc.org/) must be installed).
* `promo` - copies promo project content to the current CReq project directory;

You can see all available commands through `creq help` command, and you can get help for the command by `creq help <command>`.

To start using creq just create a new project:

    $ creq new myproject
    $ cd myproject

Try creq commands on Promo project:

    $ creq promo
    $ creq req
    $ creq chk
    $ creq doc
    $ creq publish

#### Extend it yourself!

You can and should extend standard CLI interface by your own commands. Just see example `<project>.thor` file in the created project and add the necessary tasks. It is all Ruby code.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/creq.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
