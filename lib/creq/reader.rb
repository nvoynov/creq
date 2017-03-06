# encoding: UTF-8

require_relative 'parser'

module Creq

  class Reader

    def self.read(file_name)
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

    # @return [Array<Requirement>, Array<String>] array of requirements and array of errors
    def read(enumerator = File.foreach(@file_name))
      reqary, errors = [], []
      each_req_text(enumerator) do |txt|
        req, lev, err = Parser.parse(txt)
        errors << err unless err.empty?
        next unless req        

        if lev == 1
          reqary << req
          next
        end

        parent = reqary.last
        parent = parent.last while parent.last && (parent.level < (lev - 1))

        if parent.level == (lev - 1)
          parent << req
        else
          reqary << req
          errors << "Hierarhy error:\n#{req.id}"
        end
      end

      [reqary, errors]
    end

    protected

    def initialize(file_name)
      @file_name = file_name
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
