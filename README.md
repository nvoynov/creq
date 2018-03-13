
[![Join the chat at https://gitter.im/nvoynov-creq/Lobby](https://badges.gitter.im/nvoynov-creq/Lobby.svg)](https://gitter.im/nvoynov-creq/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/creq.svg)](https://badge.fury.io/rb/creq) [![Build Status](https://travis-ci.org/nvoynov/creq.svg?branch=master)](https://travis-ci.org/nvoynov/creq) [![Code Climate](https://codeclimate.com/github/nvoynov/creq/badges/gpa.svg)](https://codeclimate.com/github/nvoynov/creq)

![Promo](lib/assets/promo/doc/assets/promo.png)

* [What is CReq?](#what-is-creq)
* [Installation](#installation)
* [Format](#format)
  * [Project](#project)
  * [Repository](#repository)
  * [Requirement](#requirement)
    * [Identifies](#identifiers)
    * [Attributes](#attributes)
    * [Links](#links)
    * [Relative links](#relative-links)
* [Usage](#usage)
  * [Creating new project](#creating-new-project)
  * [Creating requirement](#creating-requirement)
  * [Using templates](#using-templates)
  * [Checking for errors](#checking-for-errors)
  * [Publishing](#publishing)
  * [Using Git](#using-git)
  * [Automating](#automating)
  * [Promo](#promo)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## What is CReq?

The CReq is a simple and customizable CLI for requirements management. It provides the ability of writing requirements in discrete markdown files and combining those files into a single and consistent requirements specification.

The CReq is simple enough in itself, but when you joint it with Ruby, a modern text editor, and Git, it gives you exceptional power and flexibility of requirements management process.

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

## Format

### Project

The CReq project has the following folders structure (that will be created by `creq new <project>`):

* `doc/` - for output documents;
   * `doc/assets` - for additional assets provided by the documents;
* `lib/` - for any helpful artifacts and other input sources;
* `req/` - requirements repository;
* `tt/` - templates;
* `<project>.thor` - `.thor` file with automated tasks;
* `README.md`.

### Repository

The `req` folder is the requirements repository. The repository is a set of files that contain requirements. To structure requirements you can create directory structure. The CReq will load all the files of `req` directory including all the child directories at any level of nesting.

### Requirement

Each requirement is a usual text written in markdown format with a few additional compliances that will be explained below. Each file can contain any number of requirements. Lets meet the following requirements files.

**content.md**

```markdown
# [o] Overview
# [f] Functional Requirements
# [i] Interfaces
# [n] Non-functional requirements
# [c] Design constraints
```

**feature.md**

```markdown
# [f1] Feature 1
{{parent: f}}

The system shall provide `Feature 1`.

## [f1.data] Data

The feature shall provide an entity for storing the feature data. The entity shall provide the following...

## [f1.cmd1] Command 1

When `Command 1` is received, the System shall ...

## [f1.cmd2] Command 2

When `Command 2` is received, the System shall ...
```

Every requirement starts with markdown header. All the text between headers is a requirement body. The body can contain an excerpt with requirements attributes.

#### Identifiers

Each requirement must have its own unique identifier so that you can refer to it in other requirements files. That's why a recommended way is to put id straight into the header like this `# [requirement_id] requirement title`.

Identifier can start with one dot like `[.suffix]`. When an identifier starts with dot, CReq will add parent requirement identifier before the dot. For the followed example, `[.f1]` will be translated to   `[req.1.f1]`.

```markdown
# [req.1] Req 1
## [.f1] Feature 1
```

When identifier is not provided, CReq will generate it automatically, and you can combine requirements that have id and requirements that does not. For the followed example, the `First feature` header will be translated to `[req.id.01] First feature` and `Second feature` will become `[req.id.02] Second feature`.

```markdown
# [req.id] Parent requirement
## First feature
## Second feature
```

#### Attributes

The excerpt, the text in brackets `{{ }}` that follows by header, contains requirement attributes. You can place here anything you need to provide additional information, like status, source, author, priority, etc.

The next attributes are **system attributes** and these influence to CReq behavior:

* `requirement: false` will suppress output table of requirement attributes (it might be helpful for headers or other parts of requirements document that are not requirements by their nature but must be included to requirement document);
* `suppress_id: true` will suppress output [id] in the header of the requirement;
* `child_order: feature1 feature2` will sort child requirements in provided order;
* `parent: f` will place the requirement to parent requirement collection with id `f`.requirement collection.

All other attributes (`status`, `source`, etc.) are **user attributes** and do not influence CReq behavior. These attributes are holding in requirement's attributes hash and can be used for publishing or automation purpose.

#### Links

You can place a link to another requirement in requirements body by writing macro `[[requirement.id]]`. This macro will produce full-fledged link in output document produced by publishing command. If requirement with `id` does not exist, CReq will inform you about wrong link.

> There is a "feature" in current release than CReq handle all the occurrences of `[[id]]` macro, even if the occurrence is in markdown quotes.

#### Relative links

Instead of writing full requirement id in links, you can user relative links. There are two different prefixes in relative macro can be used:

 * `*link.id` will climb up through requirements hierarchy and find a requirement whose id ends with `link.id`;
 * `.link.id` will find a child requirement whose id ends with `link.id`.

Suppose you have the following requirements structure:

```markdown
# [f] functional
## [.c1] component 1
component items:
* [[.f]];
* [[.e]].
### [.f] functions
{{child_order: .f2 .f1}}
component functions:
* [[.f1]];
* [[.f2]].
#### [.f1] func 1
According to [[\*f]]
* Create [[\*e1]].
* Call [[f2]].
#### [.f2] func 2
### [.e] entities
#### [.e1] entity 1
#### [.e2] entity 2
## [.c2] component 2
```

In the case CReq will replace relative links and change order of [f.c1.f] as following:

```markdown
# [f] functional
## [f.c1] component 1
component items:
* [[f.c1.f]];
* [[f.c1.e]].
### [f.c1.f] functions
component functions:
* [[f.c1.f.f1]];
* [[f.c1.f.f2]].
#### [f.c1.f.f2] func 2
#### [f.c1.f.f1] func 1
According to [[f]]
* Create [[f.c1.e.e1]].
* Call [[f.c1.f.f2]].
### [f.c1.e] entities
#### [f.c1.e.e1] entity 1
#### [f.c1.e.e2] entity 2
## [f.c2] component 2
```

## Usage

The CReq provides CLI interface for all the necessary basic tasks like project creation, error checking and publishing. In addition, if you have basic programming skills, you can easily automate other tasks through `.thor` file.

To see all the command provided by CReq:

    $ creq help

To see the information related to a command:

    $ creq help <command>

To see all the commands from `<project>.thor` file:

    $ thor <project>:help

To see the information related to a command from `<project>.thor`:

    $ thor <project>:help <command>

### Creating new project

To create a new project run `new` command:

    $ creq new <your-new-project>

### Creating requirements

You can create requirements by adding new files to the `req` directory. You can do it manually or by

    $ creq req REQ_ID


> **Assests** If you are using images or other assests, you shold palce it to `doc/assets` directory and write links like `![img](assets/img.png)`

### Using templates

Requirements language is structured, so that it will be more productive to write requirements by templates. All templates stored in `tt` folder. CReq provides some basic templates from the box and you can create your own.

If you have not seen help for `req` command, to create a requirement by template:

    $ creq req REQ_ID -t TEMPLATE

### Checking repo for errors

Because there is a lots of hand writing and all the files must meet structures compliances, the CReq provides `chk` command. The command will check the requirements repository for errors. The most usual ones are:

* non-unique requirements identifiers;
* wrong links to id that does not exist:
   * wrong links for `parent` attribute;
   * wrong links for `child_order`;
   * wrong links in requirement's `body`.

To check requirements repository for errors:

    $ creq chk

The CReq will check for errors before any publishing also.

To see the feature in action just duplicate requirements and see the result:

    $ cp req/feature.md req/feature2.md
    $ creq chk

### Publishing

One of the usual requirements author's task is publishing. And CReq provides two command for the task:

`creq doc` command creates `doc/requirements.md` well-formed markdown file that contains all the requirements from the repository. You can read plaint markdown files hosted on [GitHub](), [GitLab](), etc. and see changes through commits.

`creq pub` command creates `doc/requirements.html` file by default. Actually CReq use [pandoc](https://pandoc.org/) (and you need to have it installed) for the purpose and you can specify preferred output format through the command parameters.

For the two examples provided in [### Requirement] section, CReq will combine all the requirements from two files as following

```markdown
# [o] Overview
# [f] Functional Requirements
## [f1] Feature 1

The system shall provide `Feature 1`.

### [f1.data] Data

The feature shall provide an entity for storing the feature data. The entity shall provide the following...

### [f1.cmd1] Command 1

When `Command 1` is received, the System shall ...

### [f1.cmd2] Command 2

When `Command 2` is received, the System shall ...

# [i] Interfaces
# [n] Non-functional requirements
# [c] Design constraints
```

### Using Git

At the last step of new project creation, CReq tries to find `git`. It will create a new git repository and make the initial commit if `git` is found.

Git gives a good start point for simultaneous work on the same project by few requirements authors or reviewers.

### Automating

You can and should extend the standard CReq CLI by your own commands. See `<project>.thor` file as an example and call for action. It is all the Ruby code and the main point is to get requirements collection by `requirement_repository` function.

The first candidate for automation is the `creq pub` command. And I hope provide some more advanced examples in the future. Some kind of risk/effort/priority, FPA and PERT estimations based on requirement repository are considered.

### Promo

The CReq also provides the `Promo` project that contains requirements of the gem. You can copy it contents to the current directory by `creq promo` and play with it when it copied.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/creq.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
