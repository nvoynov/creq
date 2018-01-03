# encoding: UTF-8

require_relative 'requirement'

module Creq
  class Parser

    def self.call(text)
      text += "\n" unless text.end_with?("\n")
      regxp = /^(\#+)[ ]*(\[([^\[\]\s]*)\][ ]*)?([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m
      parts = regxp.match(text)
      return nil, nil, "Requirement format error:\n#{text}" unless parts
      level, id, title, body = parts[1], parts[3], parts[4], parts[7] || ""
      attrs = parse_attributes(parts[6]) if parts[6]
      attrs ||= {}
      attrs.merge!({id: id, title: title.strip, body: body.strip})
      [Requirement.new(attrs), level.size]
    end

    def self.parse_attributes(text)
      text.strip.split(/[,\n]/).inject({}) do |h, i|
        pair = /\s?(\w*):\s*(.*)/.match(i)
        if pair
          h.merge({pair[1].to_sym => pair[2]}) if pair
        else
          puts "Attribute format error:\n{{#{text}}}" unless pair
        end
      end || {}
    rescue StandardError => e
      puts "Attributes parsing error #{e.message}\n#{text}"
      {}
    end
  end
end
