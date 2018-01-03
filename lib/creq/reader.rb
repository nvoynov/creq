# encoding: UTF-8

require_relative 'parser'
require_relative 'requirement'

module Creq

  class Reader

    def self.call(file_name)
      reader = new(file_name)
      reader.read
    end

    # @return [Hash<file_name, Hash<Array<Req>, Array<Errors>>]
    def self.read_repo(repository = '**/*.md')
      reader = new('repo')
      {}.tap do |repo|
        Dir.glob(repository) do |f|
          print "Reading #{f}..."
          reqs, errs = reader.read(File.foreach(f))
          msg = errs.empty? ? "OK!" : "#{errs.size} errors found\n#{errs.join("\n")}"
          puts msg
          repo[f] = { reqary: reqs, errary: errs }
        end
      end
    end

    # @return [Requirement] requirements from file
    def read(enumerator = File.foreach(@file_name))
      each_req_text(enumerator) do |txt|
        req, lev = Parser.(txt)
        next unless req

        parent = @file_reqs
        parent = parent.last while parent.last && (parent.level < (lev))
        unless parent.level == lev
          puts "Wrong header level for [#{req.id}]"
          parent = @file_reqs
        end
        parent << req
      end
      @file_reqs
    end

    protected

    def initialize(file_name)
      @file_name = file_name
      @file_reqs = Requirement.new(id: file_name)
    end

    def latest
      r = @file_reqs
      r = r.last while r.last
      r
    end

    def each_req_text(enumerator, &block)
      quote = false
      body = ''
      enumerator.each do |line|
        if line.start_with?('#') && !quote
          unless body.empty?
            block.call(body)
            body = ''
          end
        end
        body << line
        quote = !quote if line.start_with?('```')
      end
      block.call(body)
    end

  end

end
