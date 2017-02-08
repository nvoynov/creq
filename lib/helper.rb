# encoding: UTF-8

require_relative 'creq/reader'
require_relative 'creq/writer'
require_relative 'creq/requirement'

module Creq
  module Helper
    include Reader

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
      inside_req { Loader.load.root }
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
      req = inside_req { Loader.load.root }
      inside_doc {
        open(file_name, 'w') {|f|
          FinalDocWriter.write(req, f)
        }
      }
    end

    def check_repo
      errors = {}
      repo = inside_req { Loader.load }
      nonuniq_ids = repo.nonuniq_ids
      wrong_links = repo.wrong_links
      wrong_parents = repo.wrong_parents

      unless nonuniq_ids.empty?
        # id, [file]
        errors[:nonuniq_id] = []
        nonuniq_ids.each{|k, v|
          fa = v.map{|f| "'" + f + "'"}
          errors[:nonuniq_id] << "- [#{k}] in files #{fa.join(', ')}"
        }
      end

      unless wrong_links.empty?
        errors[:wrong_links] = []
        wrong_links.each {|k, v|
          reqs = v[:requirements].map{|i| "[#{i}]"}.join(", ")
          files = v[:files].map{|i| "'#{i}'"}.join(", ")
          errors[:wrong_links] << "- [[#{k}]] in requirements #{reqs} (in files: #{files})"
        }
      end

      unless wrong_parents.empty?
        # puts "Found 'parent' attribute values pointing to requirement that does not exist in repository:"
        errors[:wrong_parents] = []
        wrong_parents
          .inject({}){|h, r| h.merge!(r.id => r[:parent])}
          .each{|k, v| errors[:wrong_parents] << "- [#{k}] {{parent: #{v}}}"}
      end

      errors
    end

    DOC = 'doc'
    LIB = 'lib'
    REQ = 'req'
    TT = 'tt'
    DOC_ASSETS = 'doc/assets'

    PROJECT_FOLDERS = [DOC, LIB, REQ, TT, DOC_ASSETS]

  end
end
