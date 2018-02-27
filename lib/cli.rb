# encoding: UTF-8
require "thor"
require_relative "helper"
require_relative "creq"

module Creq

  class Cli < Thor
    include Thor::Actions
    include Creq::Helper

    def self.source_root
      File.join Creq.root, "lib/assets"
    end

    map %w[--version -v] => :version

    desc "--version, -v", "Print the version"
    def version
      puts "Creq v#{Creq::VERSION}"
    end

    desc "new PROJECT", "Create a new project skeleton"
    # long_desc File.read()
    def new(project)
      say "Creating a new project..."

      if Dir.exist?(project)
        error "Directory '#{project}' already exists. Operation aborted."
        return
      end

      Dir.mkdir(project)
      Dir.chdir(project) do
        initialize_project
        config = {project: project}

        say "Creating project files..."
        copy_file('new/contents.md', File.join(Dir.pwd, 'req/contents.md'))
        copy_file('new/ears.md.tt',  File.join(Dir.pwd, 'tt/ears.md.tt'))
        copy_file('new/story.md.tt', File.join(Dir.pwd, 'tt/story.md.tt'))
        copy_file('new/ucase.md.tt', File.join(Dir.pwd, 'tt/ucase.md.tt'))
        copy_file('new/minutes.md.tt', File.join(Dir.pwd, 'tt/minutes.md.tt'))
        template('new/README.md.tt', File.join(Dir.pwd, 'README.md'), config)
        template('new/creq.thor.tt', File.join(Dir.pwd, "#{project}.thor"), config)

        git_init
      end

      say "Project '#{project}' successfully created!"
    end

    no_commands {
      def git_init
        say "Initializing git repository..."
        `git init`
        `git add .`
        `git commit -m "Initial commit"`
      end
    }

    desc "promo", "Copy promo project to the current working directory"
    def promo
      say "Copying promo project..."
      # promo = File.join(Creq.root, 'lib/promo')
      directory('promo', Dir.pwd)
    end

    desc "req ID [TITLE] [OPTIONS]", "Create a new requirements file"
    method_option :template, aliases: "-t", type: :string, desc: "Template file"
    def req(id, title = '')
      result = ReqCommand.(id, title, options[:template])
      puts "File '#{result}' created successfully."
    rescue  CreqCmdError => e
      puts e.message
    rescue => e
      raise e
    end

    desc "chk", "Check the current requirments repository for errors."
    def chk
      say "Checking repository for error..."

      result = check_repo
      if result.empty?
        puts "Everything is fine!"
        return
      end

      result.each { |k, v| puts "#{CHK_ERR_MSGS[k]}\n#{v.join("\n")}" }
    end

    desc "toc [REQ]", "Output Table of contents"
    def toc(req = '')
      create_toc(req)
    end


    desc "doc [REQ]", "Create the requirements document."
    def doc(req='')
      create_doc(req)
    end

    desc "publish [REQ]", "Publish the requirement document by Pandoc"
    method_option :format, alias: "-f", type: :string, desc: "Pandoc output format", default: 'html'
    method_option :pandoc, alias: "-o", type: :string, desc: "Pandoc options", default: ''
    def publish(req = '')
      pandoc(req, options[:format], options[:pandoc] || '')
    end

    CHK_ERR_MSGS  = {
      duplicate_ids: "\nNon-unique requirements identifiers are found:",
      wrong_links:   "\nWrong requirements links are found:",
      wrong_parents: "\nWrong {{parent}} values are found:",
      wrong_childs:  "\nWrong {{child_order}} values are found:"
    }
  end

end
