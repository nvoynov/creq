# encoding: UTF-8

require_relative 'creq/reader'
require_relative 'creq/writer'
require_relative 'creq/requirement'
require_relative 'creq/repository'

module Creq
  module Helper

    def initialize_project(dir = Dir.pwd)
      Dir.chdir(dir){
        PROJECT_FOLDERS.each {|fld|
          Dir.mkdir(fld) unless Dir.exist?(fld)
        }
      }
    end

    def inside_req(&block)
      Dir.chdir(REQ, &block)
    end

    def inside_doc(&block)
      Dir.chdir(DOC, &block)
    end

    def requirements_repository
      inside_req { Repository.() }
    end

    def create_req(params)
      file_name = "#{REQ}/#{params[:id]}.md"
      if File.exist?(file_name)
        puts "File '#{file_name}' already exists. Command was aborted!"
        return
      end

      body = ''
      template = params.delete(:template)
      if template
        body = read_template_body(template)
        body = replace_macros(body, params)
      end
      params[:body] = body
      req = Requirement.new(id: params[:id], title: params[:title], body: body)
      File.open(file_name, 'w') { |f| Writer.write(req, f) }
      puts "File '#{file_name}' is created."
    end

    def read_template_body(template)
      template_file = "#{TT}/#{template}"
      template_file += '.md.tt' unless File.exist?(template_file)

      unless File.exist?(template_file)
        puts "Template file '#{template}' is not found"
        return ''
      end

      body = File.read(template_file)
      TT_WARNING % template_file + body
    end

    def replace_macros(body, params)
      new_body = String.new(body)
      new_body.gsub!('@@id', params[:id])
      new_body.gsub!('@@title', params[:title])
      new_body
    end

    TT_WARNING = "TODO: The contents of this file were generated automatically based on '%s'\n\n".freeze

    def create_doc(file_name = 'requirements.md')
      req = inside_req { Repository.() }
      inside_doc {
        open(file_name, 'w') {|f|
          FinalDocWriter.write(req, f)
        }
      }
    end

    def create_pandoc(format, options)
      # TODO check is pandoc available
      req = inside_req { Repository.load }
      inside_doc {
        open("pandoctmp.md", 'w') {|f| PandocWriter.write(req, f) }
        # pandoc -s --reference-doc template.docx --toc -o srs.docx srs.md
        `pandoc -s --toc #{options} -o requirements.#{format} pandoctmp.md`
      }
    end

    def check_repo
      {}.tap do |err|
        repo = inside_req { Repository.() }
        err[:duplicate_ids] = repo.duplicate_ids
        err[:wrong_parents] = repo.wrong_parents
        err[:wrong_links] = repo.wrong_links
        err[:wrong_childs] = repo.wrong_child_order
        err.delete_if {|k, v| v.empty?}
      end
    end

    DOC = 'doc'
    LIB = 'lib'
    REQ = 'req'
    TT = 'tt'
    DOC_ASSETS = 'doc/assets'

    PROJECT_FOLDERS = [DOC, LIB, REQ, TT, DOC_ASSETS]

  end
end
