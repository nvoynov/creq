# encoding: UTF-8

require_relative 'creq/reader'
require_relative 'creq/writer'
require_relative 'creq/requirement'
require_relative 'creq/repository'
require_relative 'creq/settings'

module Creq
  module Helper

    def initialize_project(dir = Dir.pwd)
      Dir.chdir(dir){
        Settings::PROJECT_FOLDERS.each {|fld|
          Dir.mkdir(fld) unless Dir.exist?(fld)
        }
      }
    end

    def inside_req(&block)
      Dir.chdir(Settings::REQ, &block)
    end

    def inside_doc(&block)
      Dir.chdir(Settings::DOC, &block)
    end

    # @param repo [Requirement] - requirements repository
    # @param skip [String] - string of req ids delimited by space
    def remove_reqs(repo, skip)
      rmid = skip.split(/ /)
      todo = {}
      repo.each do |r|
        if rmid.include? r.id
          parent = r.root? ? 'root' : r.parent.id
          todo[parent].nil? ? todo[parent] = [r.id] : todo[parent] << r.id
        end
      end

      todo.each do |from, what|
        pp from
        pp what
        source = from == 'root' ? repo : repo.find(from)
        what.each do |r|
          item = source.find(r)
          source.items.delete(item)
        end
      end

      repo
    end

    # @param id [String] retrive requirements tree for id
    # @param skip [String] skip requirements with id delimited by space
    def requirements_repository(id = '', skip = '')
      repo = inside_req { Repository.() }
      repo = repo.find(req) unless id.empty?
      repo = remove_reqs(repo, skip) unless skip.empty?
      repo
    end

    def check_repo
      {}.tap do |err|
        repo = requirements_repository
        err[:duplicate_ids] = repo.duplicate_ids
        err[:wrong_parents] = repo.wrong_parents
        err[:wrong_links] = repo.wrong_links
        err[:wrong_childs] = repo.wrong_child_order
        err.delete_if {|k, v| v.empty?}
      end
    end

    # @param cmd [String] a system command
    # @return [String] full path to the command or nil if command was not found
    def which(cmd)
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        tmp = File.join(path, cmd).gsub(File::ALT_SEPARATOR, File::SEPARATOR)
        return tmp if File.exists?(tmp) && File.executable?(tmp)
      end
      nil
    end

    def create_toc(req = '', skipid = '')
      repo = requirements_repository(req, skipid)
      unless repo
        puts "Requirements for provided params not found!"
        return
      end

      slev = req != '' ? repo.level : 0
      repo.inject([], :<<)
        .tap{|a| a.delete_at(0); say "-= Table of contents =-"}
        .each{|r| puts "#{'  ' * (r.level - slev - 1)}[#{r.id}] #{r.title}"}
    end

    def write_doc_title(title, stream)
      stream.write "% #{title}\n"
      stream.write "% generated by [Creq](https://github.com/nvoynov/creq)\n"
      stream.write "  converted by [Pandoc](http://pandoc.org/)\n"
      stream.write "% on #{Time.now.strftime('%B %e, %Y at %H:%M')}\n"
    end

    def create_doc(req = '', skipid = '')
      repo = requirements_repository(req, skipid)
      unless repo
        puts "Requirements for provided params not found!"
        return
      end

      file = repo.title
      file = 'requirements' if file == ''
      inside_doc {
        open("#{file}.md", 'w') {|f|
          write_doc_title(file, f)
          FinalDocWriter.write(repo, f)
        }
      }
      puts "'doc/#{file}.md' created!"
    end

   def pandoc(req, skipid, format, options)
     unless which('pandoc') || which('pandoc.exe')
       puts "Please install 'pandoc' first."
       return
     end

     repo = requirements_repository(req, skipid)
     unless repo
       puts "Requirements for provided params not found!"
       return
     end

     title = repo.title
     title = 'requirements' if title == ''
     tmp = '~tmp.md'
     doc = "#{title}.#{format}"
     inside_doc {
       open(tmp, 'w') {|f|
         write_doc_title(title, f)
         PandocWriter.write(repo, f)
       }
       `pandoc -s --toc #{options} -o "#{doc}" #{tmp}`
       File.delete(tmp)
     }
     puts "File 'doc/#{doc}' created."
   end

  end
end
