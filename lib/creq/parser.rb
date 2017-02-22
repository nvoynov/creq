# encoding: UTF-8

require_relative 'requirement'

module Creq
  class Parser

    def self.parse(text)
      text += "\n" unless text.end_with?("\n")
      regxp = /^(\#+)[ ]*\[([^\[\]\s]*)\][ ]*([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m
      parts = regxp.match(text)
      return nil, nil, "Requirement format error:\n#{text}" unless parts
      level, id, title, body = parts[1], parts[2], parts[3], parts[6] || ""
      attrs, error = parse_attributes(parts[5]) if parts[5]
      attrs ||= {}
      attrs.merge!({id: id, title: title.strip, body: body.strip})
      [Requirement.new(attrs), level.size, error || ""]
    end

    def self.parse_attributes(text)
      attrs = text.strip.split(/[,\n]/).inject({}) do |h, i|
        pair = /\s?(\w*):\s*(.*)/.match(i)
        return [{}, "Attributes format error:\n{{#{text}}}"] unless pair
        h.merge({pair[1].to_sym => pair[2]})
      end
      [attrs, ""]
    rescue StandardError => e
      [{}, "Attributes parsing error #{e.message}\n#{text}"]
    end
  end
end
