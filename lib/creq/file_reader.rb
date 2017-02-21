# encoding: UTF-8

require_relative 'parser'

module Creq

  class FileReader

    def self.read(file_name)
      reader = new(file_name)
      reader.read
    end

    def read(enumerator = File.foreach(@file_name))
      reqary, errors = [], []
      each_req_text(enumerator) do |txt|
        req, lev, err = Parser.parse(txt)
        unless req
          errors << err
          next
        end

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
