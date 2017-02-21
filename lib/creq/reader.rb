# encoding: UTF-8
require_relative 'requirement'

module Creq
  # TODO transform to class
  # TODO split to?:
  # * parsing requirement text,
  # * translating into requirements,
  # * buiding hierarhy.
  module Reader

    def read_directory
      items = {}
      Dir.glob('**/*.md') {|f| items[f] = read_file(f)}
      items
    end

    def read_file(file_name)
      transform(extract(File.foreach(file_name)))
    end

    # TODO: retrive Requirement instead of Array?
    def transform(text_items)
      reqs = []
      text_items.each do |text|
        r = nil
        l = 0
        begin
          r = parse_requirement(text)
          l = md_header_level(text)
        rescue StandardError => e
          puts "parse_requirement: parsing error for #{text}.\n" + e.message
          raise e
        end

        begin
          case l
          when 1 then reqs << r
          when 2 then reqs.last << r
          when 3 then reqs.last.items.last << r
          when 4 then reqs.last.items.last.items.last << r
          else puts "transform: cannot transform deeper than 4th level for #{r.id}."
          end
        rescue StandardError
          puts "transform: cannot find parent for #{r.id}; it placed to root."
          reqs << r
        end
      end
      reqs
    end

    def md_header_level(text)
      9.downto(1){|l| return l if text.start_with?('#' * l)}
      return 0
    end

    def parse_requirement(text)
      regxp = /^\#+ \[([^\[\]\s]*)\] ([\s\S]*?)\n({{([\s\S]*?)}})?(.*)$/m
      parts = regxp.match(text)
      id, title, body = parts[1], parts[2], parts[5]
      attrs = parse_attributes(parts[4]) if parts[4]
      attrs ||= {}
      Requirement.new(attrs.merge({id: id, title: title, body: body.strip}))
    end

    def parse_attributes(text)
      text.strip.split(/[,\n]/).inject({}) do |h, i|
        pair = /\s?(\w*):\s*(.*)/.match(i)
        h.merge({pair[1].to_sym => pair[2]})
      end
    rescue StandardError => e
      puts "parse_attributes error during parse attributes text(#{e.message}):\n#{text}"
    end

    def extract(enumerator)
      quote = false
      reqs = []
      body = ''
      enumerator.each do |line|
        if line.start_with?('#') && !quote
          unless body.empty?
            reqs << body
            body = ''
          end
        end
        body << line
        quote = !quote if line.start_with?('```')
      end
      reqs << body
      reqs
    end

  end
end
