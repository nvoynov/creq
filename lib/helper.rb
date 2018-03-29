# encoding: UTF-8

require_relative 'creq/reader'
require_relative 'creq/writer'
require_relative 'creq/doc_writer'
require_relative 'creq/pub_writer'
require_relative 'creq/requirement'
require_relative 'creq/project'
require_relative 'creq/repository'
require_relative 'creq/settings'

module Creq
  module Helper

    def init_project
      Project.init
    end

    def inside_src(&block)
      Dir.chdir(Settings.src, &block)
    end

    def inside_bin(&block)
      Dir.chdir(Settings.bin, &block)
    end

    # @param cmd [String] a system command
    # @return [String] full path to the command or nil if command was not found
    def which(cmd)
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        tmp = File.join(path, cmd)
        tmp = tmp.gsub(File::ALT_SEPARATOR, File::SEPARATOR) if File::ALT_SEPARATOR
        return tmp if File.exists?(tmp) && File.executable?(tmp)
      end
      nil
    end

    def capture_stdout &block
      old_stdout = $stdout
      $stdout = StringIO.new
      block.call
      $stdout.string
    ensure
      $stdout = old_stdout
    end

    def check_pandoc_installed
      installed = which('pandoc') || which('pandoc.exe')
      raise CreqCmdError.new("Install Pandoc!") unless installed
    end

    def requirements_repository
      inside_src { Repository.() }
    end

    def check_repo
      {}.tap do |err|
        repo = requirements_repository
        err[:duplicate_ids] = repo.duplicate_ids
        err[:wrong_parents] = repo.wrong_parents
        err[:wrong_links] = repo.wrong_links
        err[:wrong_childs] = repo.wrong_order_index
        err.delete_if {|k, v| v.empty?}
      end
    end

    def query_repository(qry = '')
      repo = requirements_repository
      repo = repo.query(qry) unless qry.empty?
      puts 'Requirements not found!' if repo.nil? || repo.empty?
      repo
    end

    def create_toc(query_str = '')
      repo = query_repository(query_str)
      return if repo.nil? || repo.empty?

      slev = repo.is_a?(Array) ? repo.first.level : 0
      repo.inject([], :<<)
        .tap{|a| a.delete_at(0); puts "-= Table of contents =-"}
        .each{|r| puts "#{'  ' * (r.level - slev - 1)}[#{r.id}] #{r.title}"}
    end

    def output_doc_title
      res = "% #{Settings.title}\n"
      res << "% #{Settings.author}\n" unless Settings.author.empty?
      res << "% on #{Time.now.strftime('%B %e, %Y at %H:%M')}\n"
    end

    def create_doc(query_str)
      repo = query_repository(query_str)
      return if repo.nil? || repo.empty?

      output = Settings.output
      inside_bin {
        open("#{output}.md", 'w') {|f|
          f.write(output_doc_title)
          DocWriter.(repo, f)
        }
      }
      puts "'#{Settings.bin}/#{output}.md' created!"
    end

   def pandoc(query_str)
     check_pandoc_installed
     repo = query_repository(query_str)
     return if repo.nil? || repo.empty?

     tmp = '~tmp.md'
     doc = "#{Settings.output}.#{Settings.format}"
     inside_bin {
       open(tmp, 'w') {|f|
         f.write(output_doc_title)
         PubWriter.(repo, f)
       }
       `pandoc #{Settings.options} -o "#{doc}" #{tmp}`
       File.delete(tmp)
     }
     puts "File '#{Settings.bin}/#{doc}' created."
   end

  end
end
