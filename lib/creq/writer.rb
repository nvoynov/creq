# encoding: UTF-8
require_relative 'requirement'

module Creq

  # TODO
  # 1. print root requirement as document title which presents document
  #    VS. printing requirement source
  # 2. print array.join(\n)

  class Writer

    def self.write(req, stream = $stdout)
      writer = new(req.root)
      writer.write(req, stream)
    end

    def write(req, stream)
      stream.puts req.map{|r| text(r)}.join("\n\n")
    end

    def text(r)
      [title(r), attributes(r), body(r)]
        .select{|i| !i.empty?}.join("\n")
    end

    protected

    def initialize(root)
      @root = root
    end

    def title(r)
      t = []
      t << '#' * r.level
      t << "[#{r.id}]" unless r[:suppress_id]
      t << r.title
      t.join(' ')
    end

    def attributes(r)
      return "" if r.user_attributes.empty?
      t = ["{{"]
      r.user_attributes.inject(t){|s, (k, v)| s << "#{k}: #{v}"}
      t << "}}"
      t.join("\n")
    end

    def body(r)
      return "\n" << r.body unless r.body.empty?
      r.body
    end
  end

  # TODO write in order according to attributes[:child_order]
  class FinalWriter < Writer

    def self.write(req, stream = $stdout)
      writer = new(req.root)
      writer.write(req.inject([], :<<), stream)
    end

    def text(r)
      [title(r), attributes(r), body(r)]
        .select{|i| !i.empty?}.join("\n\n")
    end

    protected

    def attributes(r)
      return "" if r.user_attributes.empty?
      t = ["Attribute | Value", "--------- | -----"]
      r.user_attributes.inject(t){|s, (k, v)| s << "#{k} | #{v}"}
      t.join("\n")
    end

    def body(r)
      bodycp = String.new(r.body)
      return "" if bodycp.empty?
      r.links.each{|l| bodycp.gsub!("[[#{l}]]", link(l))}
      bodycp
    end

    def link(id)
      r = @root.find(id)
      return "[#{id}](unknown)" unless r
      "[[#{r.id}] #{r.title}](##{url(id)})"
    end

    def url(id)
      id.downcase
        .gsub(/[^A-Za-z0-9\s]/, ' ')
        .strip
        .gsub(/(\s){2,}/, ' ')
        .gsub(/\s/, '-')
    end
  end

  class FinalDocWriter < FinalWriter

    def write(req, stream)
      req.delete_at(0)
      super(req, stream)
    end

    protected

      def title(r)
        t = []
        t << '#' * r.level
        t << "[#{r.id}]" unless r[:suppress_id]
        t << r.title
        t.join(' ')
      end
  end

end
