# encoding: UTF-8

require_relative 'parser'
require_relative 'requirement'

module Creq

  class Reader

    def self.call(file_name)
      reader = new(file_name)
      reader.read
    end

    # @return [Requirement] requirements from file
    def read(enumerator = File.foreach(@file_name))
      each_req_text(enumerator) do |txt|
        req, lev = Parser.(txt)
        next unless req
        put_according_to_level(req, lev)
      end
      @file_reqs
    end

    protected

    def initialize(file_name)
      @file_name = file_name
      @file_reqs = Requirement.new(id: file_name)
    end

    def put_according_to_level(req, lev)
      parent = @file_reqs
      parent = parent.last while parent.last && (parent.level < (lev))
      unless parent.level == lev
        puts "Wrong header level for [#{req.id}]"
        parent = @file_reqs
      end
      parent << req
    end

    def each_req_text(enumerator, &block)
      quote, body = false, ''
      enumerator.each do |line|
        if line.start_with?('#') && !quote && !body.empty?
          block.call(body)
          body = ''
        end
        body << line
        quote = !quote if line.start_with?('```')
      end
      block.call(body)
    end
  end
  
end
