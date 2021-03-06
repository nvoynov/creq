## CReq

[![Gem Version](https://badge.fury.io/rb/creq.svg)](https://badge.fury.io/rb/creq) [![Build Status](https://travis-ci.org/nvoynov/creq.svg?branch=master)](https://travis-ci.org/nvoynov/creq) [![Code Climate](https://codeclimate.com/github/nvoynov/creq/badges/gpa.svg)](https://codeclimate.com/github/nvoynov/creq) [![Join the chat at https://gitter.im/nvoynov-creq/Lobby](https://badges.gitter.im/nvoynov-creq/Lobby.svg)](https://gitter.im/nvoynov-creq/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![Promo](lib/assets/promo/bin/assets/promo_light.png)

* [What is CReq?](#what-is-creq)
* [Installation](#installation)
* [How to start](#how-to-start)
* [Format](#format)
  * [Project](#project)
  * [Repository](#repository)
  * [Requirement](#requirement)
    * [Identifies](#identifiers)
    * [Attributes](#attributes)
    * [Links](#links)
    * [Relative links](#relative-links)
    * [External assets](#external-assets)
    * [Comments](#comments)
* [Usage](#usage)
  * [Creating new project](#creating-new-project)
  * [Creating requirement](#creating-requirement)
  * [Using templates](#using-templates)
  * [Checking for errors](#checking-for-errors)
  * [Publishing](#publishing)
  * [Query option](#query-option)
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

## How to start

Actually the best way to start with CReq is to see it in action. Just start from copying [Promo](#promo) and few commands:

    $ creq new promo
    $ cd promo
    $ creq promo
    $ creq chk
    $ creq pub
    $ thor promo:release
    $ thor promo:priorities

## Format

### Project

The CReq project has the following folders structure by default (that will be created by `creq new <project>`):

* `bin/` - for output documents;
* `bin/assets` - for additional assets provided by the documents;
* `lib/` - place for Ruby extensions;
* `src/` - requirements repository;
* `knb/` - knowledge base;
* `tt/` - templates;
* `<project>.thor` - `.thor` file with automated tasks (see more in [Automating](#automating));
* `creq.yml` - project settings;
* `README.md`.

Project folders structure can be changes through `creq.yml` file.

### Repository

The `src` folder is the requirements repository. The repository is a set of files that contain requirements. To structure requirements you can create directory structure. The CReq will load all the files of `src` directory including all the child directories at any level of nesting.

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

The excerpt, the text in brackets `{{ }}` that follows by header, contains requirement attributes. You can place here anything you need to provide additional information, like status, source, author, priority, etc. All the following examples are correct.

```
# [r.1]
{{parent: r; skip_meta: true}}

# [r.2]
{{parent: r
skip_meta: true}}

# [r.3]
{{
parent: r
skip_meta: true
}}
```

The next attributes are **system attributes** and these influence to CReq behavior:

* `order_index: feature1 feature2` will sort child requirements in provided order;
* `parent: f` will place the requirement as a child of parent requirement `[f]`.
* `skip_meta: true` will skip output `[id]` in requirements' headers and attributes table (it might be helpful for some items of repository that are not requirements by their nature but must be included to requirements document);

All other attributes (`status`, `source`, etc.) are **user attributes** and do not influence CReq behavior. These attributes are holding in requirement's attributes and can be used for publishing or automation purpose.

#### Links

You can place a link to another requirement in requirements body by writing macro `[[requirement.id]]`. This macro will produce full-fledged link in output document produced by publishing command. If requirement with `id` does not exist, CReq will inform you about wrong link.

> There is a "feature" in current release than CReq handle all the occurrences of `[[id]]` macro, even if the occurrence is in markdown quotes.

#### Relative links

Instead of writing full requirement id in links, you can user relative links. There are two different prefixes in relative macro can be used:

1. `[[.link.id]]` finds a child requirement whose id ends with `link.id`. This kind of relatіve link can also be used in `{{order_index: .link.id}}`.
2. `[[..link.id]]` climbs up by requirements hierarchy and tries to finds `link.id` among all the descendants.
3. `[[link.id]]` looks like a regular link, but if `link.id` requirement not found, the CReq tries to find like `[[.link.id]]` in the parent requirement.

Suppose you have the following requirements structure:

```markdown
# [f] functional
## [.c1] component 1
component items:
* [[.f]];
* [[.e]].
### [.f] functions
{{order_index: .f2 .f1}}
component functions:
* [[.f1]];
* [[.f2]].
#### [.f1] func 1
According to [[..f]]
* Create [[..e1]].
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

#### External assets

If you need to add an image, or some other material into a requirements body, put it in the `bin/assets` folder and specify the link

```markdown
# [id] Title

... the following diagram illustrates something (see [the full specification](assets/i/something-api.pdf)

![Image](assets/image.png)
```

#### Comments

This subject is under consideration at the moment. If you need to comment requirements and you do not want the comment to appear in the published output, you can use the html comments `<!-- -->` or the following pandoc trick (it not for comments but side effect).

```markdown
# [id] Title
The system shall does something

[//] # (but I'm not sure actually)
```

`creq doc` command does nothing with those comments, it just combines all the requirements sources to single markdown file and replaces relative links to its full version.

`creq pub` command get the output from `creq doc` and uses the output as an input to `pandoc` which converts it to nothing.

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

You can create requirements by adding new files to the `src` directory. You can do it manually or by

    $ creq req REQ_ID


> **Assests** If you are using images or other assests, you shold palce it to `bin/assets` directory and write links like `![img](assets/img.png)`

### Using templates

Requirements language is structured, so that it will be more productive to write requirements by templates. All templates stored in `tt` folder. CReq provides some basic templates from the box and you can create your own.

If you have not seen help for `creq req` command, to create a requirement by template:

    $ creq req REQ_ID -t TEMPLATE

### Checking for errors

Because there is a lots of hand writing and all the files must meet structures compliances, the CReq provides `creq chk` command. The command will check the requirements repository for errors. The most usual ones are:

* non-unique requirements identifiers;
* wrong links to id that does not exist:
   * wrong links for `parent` attribute;
   * wrong links for `order_index`;
   * wrong links in requirement's `body`.

To check requirements repository for errors:

    $ creq chk

The CReq will check for errors before any publishing also.

To see the feature in action just duplicate requirements and see the result:

    $ cp req/feature.md req/feature2.md
    $ creq chk

### Publishing

One of the usual requirements author's task is publishing. And CReq provides two command for the task:

`creq doc` command creates output document in `bin/<output>.md` well-formed markdown file that contains all the requirements from the repository. You can read plaint markdown files hosted on [GitHub](), [GitLab](), etc. and see changes through commits. The default parameter value for `<output>` is `requirements` and it can be changed to any preferred value.

`creq pub` command creates `doc/<output>.html` file by default. Actually CReq use [pandoc](https://pandoc.org/) (and you need to have it installed) for the purpose and you can specify preferred output format through the command parameters.

> Looking ahead, it should be noted that these is not the best way to publish your work. See more preferred way in [Automating](#automating) section.

For the two examples provided in [Requirement](#requirement) section, CReq will combine all the requirements from two files as following

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

### Query option

Publishing the CLI (`toc`,` doc`, and `pub`) makes it possible to select subtree requirements for publication by specifying the QUERY parameter (this is some kind of" early unstable function ", so please, no claims.)

The following example will publish only `u` and `f` subtrees:

    $ creq doc --query "['u', 'f'].include?(r.id)"
    $ rem or creq doc --query "%w(u f).include?(r.id)"

`QUERY` can hold any valid Ruby code actually, and `r` just represents requirements object so that it can be more complex like `r.id == 'f' && r[:status] == 'approved'`.

### Using Git

At the last step of new project creation, CReq tries to find `git`. It will create a new git repository and make the initial commit if `git` is found.

Git gives a good start point for simultaneous work on the same project by few requirements authors or reviewers.

### Automating

You can and should extend the standard CReq CLI by your own commands. See `<project>.thor` file as an example and call for action. It is all the Ruby code and the main point is to get requirements collection by `requirement_repository` function.

The first candidate for automation is the `creq pub` command.

[Promo project](#promo) includes two demo automating commands that demonstrate standard way of extending CReq. `Publicator` module provides ability to publish output document in few different formats. `Prioritizer` module makes the simplest priority list based on `User stories` section of [Promo project](#promo).   

I hope to provide some more examples in the future based on FPA and PERT estimation technics.

### Promo

The CReq also provides the `Promo` project that contains requirements for the gem. You can copy it contents to the current directory by `creq promo` and play with it when it copied.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/creq.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
