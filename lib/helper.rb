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
      inside_req { Repository.load }
    end

    def create_req(params)
      id = params[:id]
      title = params[:title]
      template = params[:template]
      body = ''
      file_name = "#{REQ}/#{params[:id]}.md"
      return ["File '#{file_name}' already exists."] if File.exist?(file_name)

      if template
        tt = "#{TT}/#{template}"
        tt += '.md.tt' unless File.exist?(tt)
        return ["Template file '#{tt}' not found."] unless File.exist?(tt)

        todo = "TODO: The text below has been generated by the '#{tt}' template. Please correct the text and remove this line.\n"
        body = File.read(tt)
        body.gsub!('@@id', params[:id])
        body.gsub!('@@title', params[:title])
        body = todo + body
      end

      req = Requirement.new(id: id, title: title, body: body)
      open(file_name, 'w') {|f| Writer.write(req, f)}
      return []
    end

    def create_doc(file_name = 'requirements.md')
      req = inside_req { Repository.load }
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
      repo = inside_req { Repository.load }
      {}.tap do |err|
        repo.duplicate_ids.tap {|dup|
          err.merge!({duplicate_ids: dup}) unless dup.empty? }

        repo.wrong_parents.tap {|wrp|
          err.merge!({wrong_parents: wrp}) unless wrp.empty? }

        repo.wrong_links.tap {|wrl|
          err.merge!({wrong_links: wrl}) unless wrl.empty? }

        repo.wrong_child_order.tap {|wrc|
          err.merge!({wrong_childs: wrc}) unless wrc.empty? }
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
