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
        template('new/README.md.tt', File.join(Dir.pwd, 'README.md'), config)
        template('new/creq.thor.tt', File.join(Dir.pwd, "#{project}.thor"), config)

        say "Initializing git repository..."
        `git init`
        `git add .`
        `git commit -m "Initial commit"`
      end

      say "Project '#{project}' successfully created!"
    end

    desc "promo", "Copy promo project to the current working directory"
    def promo
      say "Copying promo project..."
      # promo = File.join(Creq.root, 'lib/promo')
      directory('promo', Dir.pwd)
    end

    desc "req ID [TITLE] [PARAMS]", "Create a new requirements file"
    method_option :template, aliases: "-t", type: :string,
      desc: "Template file"
    def req(id, title = '')
      title = id if title.empty?
      result = create_req(options.merge({id: id, title: title}))
      unless result.empty?
        puts "#{result.join('\n')}\nOperation aborted."
      else
        puts "File '#{REQ}/#{id}.md' created."
      end
    end

    desc "doc", "Create a new requirements document."
    def doc
      create_doc
      puts "'#{DOC}/requirements.md' created!"
    end

    desc "chk", "Check the current requirments repository for errors."
    def chk
      say "Checking repository for error..."
      result = check_repo
      if result.empty?
        puts "Everything is fine!"
        return
      end
      result.each do |k, v|
        case k
        when :duplicate_id
          puts "\nFound non-unique requirements identifiers:"
        when :wrong_links
          puts "\nFound requirements links that does not exist in repository:"
        when :wrong_parents
          puts "\nFound 'parent' attribute values pointing to requirement that does not exist in repository:"
        end
        puts v.join("\n")
      end
    end

  end

end
