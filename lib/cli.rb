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
        init_project
        config = {project: project}

        say "Creating README ..."
        template('new/README.md.tt', File.join(Dir.pwd, 'README.md'), config)

        say "Creating #{project}.thor ..."
        template('new/creq.thor.tt', File.join(Dir.pwd, "#{project}.thor"), config)

        say "Copying content ..."
        copy_file('new/contents.md', File.join(Dir.pwd, "#{Settings.src}/contents.md"))

        say "Copying templates ..."
        directory('tt', File.join(Dir.pwd, 'tt'))

        say "Project '#{project}' created!"
        git_init
      end

    end

    desc "promo", "Copy promo project to the current working directory"
    def promo
      say "Copying promo project..."
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

    desc "chk", "Check the repository for errors."
    def chk
      say "Checking repository for error..."

      result = check_repo
      if result.empty?
        puts "Everything is fine!"
        return
      end

      result.each { |k, v| puts "#{CHK_ERR_MSGS[k]}\n#{v.join("\n")}" }
    end

    desc "toc [OPTIONS]", "Print Table of contents"
    method_option :query, alias: "-q", type: :string, desc: "Query", default: ''
    def toc
      create_toc(options[:query])
    end


    desc "doc [OPTIONS]", "Create a requirements document"
    method_option :query, alias: "-q", type: :string, desc: "Query", default: ''
    def doc
      create_doc(options[:query])
    end

    desc "pub [OPTIONS]", "Publish the requirement document by Pandoc"
    method_option :query, alias: "-q", type: :string, desc: "Query", default: ''
    method_option :format, alias: "-f", type: :string, desc: "Pandoc output format", default: 'html'
    method_option :pandoc, alias: "-o", type: :string, desc: "Pandoc options", default: ''
    def pub(req = '')
      pandoc(options[:query], options[:format], options[:pandoc])
    end

    CHK_ERR_MSGS  = {
      duplicate_ids: "\nNon-unique requirements identifiers are found:",
      wrong_links:   "\nWrong requirements links are found:",
      wrong_parents: "\nWrong {{parent}} values are found:",
      wrong_childs:  "\nWrong {{order_index}} values are found:"
    }
  end

end
