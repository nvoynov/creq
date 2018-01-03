# encoding: UTF-8

require_relative 'requirement'

module Creq
  class Parser

    def self.call(text)
      text += "\n" unless text.end_with?("\n")
      regxp = /^(\#+)[ ]*(\[([^\[\]\s]*)\][ ]*)?([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m
      parts = regxp.match(text)
      level, id, title, body = parts[1], parts[3], parts[4], parts[7] || ""
      attrs = {id: id, title: title.strip, body: body.strip}
      attrs.merge!(parse_attributes(parts[6])) if parts[6]
      [Requirement.new(attrs), level.size]
    rescue StandardError
      puts "Requirement format error for:\n#{text}"
      [nil, nil]
    end

    def self.parse_attributes(text)
      text.strip.split(/[,\n]/).inject({}) do |h, i|
        pair = /\s?(\w*):\s*(.*)/.match(i)
        unless pair
          puts "Attribute format error:\n{{#{text}}}"
          next
        end
        h.merge({pair[1].to_sym => pair[2]})
      end || {}
    rescue StandardError => e
      puts "Attributes parsing error #{e.message}\n#{text}"
      {}
    end
  end
end
