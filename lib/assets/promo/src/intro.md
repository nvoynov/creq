# [i1] 1.1 Purpose
{{parent: i0
skip_meta: true}}

The purpose of this document is to provide a detailed description of the CReq. The document explains the purpose, the project's target audience, features and interfaces of the system, specifies the software requirements, and the constraints under which it must operate.

This document is intended for all the parties which are writing requirements or using it as an input for other activities related to a requirements management process.

_**Note**: The real purpose of this document is to provide a demonstration project "Promo requirements" for all CReq users to introduce the system by example and provide a sandbox for experiments._

# [i2] 1.2 Scope
{{parent: i0
skip_meta: true}}

This software system will be a command-line interface (CLI) that provides a set of tools related to requirements management tasks. The system will also provide the requirements repository structure and the format of the requirements sources.

The system does not provide any graphical user interface in addition to the CLI. It is assumed that users create and write requirements through any available text editor application, and manage requirements repository structure through any available file manager application.

Any features related to restricting access to the requirements repository or to the functions of the system out of scope. It is assumed that each project repository is under control of a SCM tool (Git, Subversion, etc.) and the SCM is in charge of user's access to the SCM artifacts.

[//]: # (publishing is up to [pandoc](https://pandoc.org))

# [i3] 1.3 Definitions, acronyms, and abbreviations
{{parent: i0
skip_meta: true}}

CLI

:   Command-line interface

VCS

:   Version control system

SCM

:   Software configuration management

User story

:   User stories at [www.agilealliance.org](https://www.agilealliance.org/glossary/user-stories)

OS

:   Operations System

[//]: # (to use the extension `--from markdown+definition_lists`)

# [i4] 1.4 References
{{parent: i0
skip_meta: true}}

1. [Markdown Guide](https://www.markdownguide.org/)
2. [Pandoc User’s Guide](https://pandoc.org/MANUAL.html)
3. [Git Documentation](https://git-scm.com/doc)

# [i5] 1.5 Overview
{{parent: i0
skip_meta: true}}

The remaining sections of this document provides user and functional requirements of the system.

The next chapter, the User requirements section, of this document, gives an overview of the functionality of the system from the user's point of view.
It describes the informal requirements and is used to establish a context for the technical requirements specification in the next chapter. The chapter is organized by user's roles.

The third chapter, the Functional requirements section, describes the details of the functionality of the system and the interfaces that the system provides to users. The section is written primarily for the developers and quality assurance specialists; it is structured according to the system components.
