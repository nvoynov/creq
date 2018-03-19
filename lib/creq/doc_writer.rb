# encoding: UTF-8

require_relative 'writer'

module Creq

  class DocWriter < Creq::Writer

    def self.call(req, stream = $stdout)
      writer = new(req.root)
      writer.write(req.inject([], :<<), stream)
    end

    def write(req, stream)
      req.delete_at(0)
      super(req, stream)
    end

    def text(r)
      [title(r), attributes(r), body(r)]
      .select{|i| !i.empty?}.join("\n\n")
    end

    protected

    def title(r)
      t = ['#' * r.level]
      t << "[#{r.id}]" unless r[:skip_meta]
      t << r.title
      t.join(' ')
    end

    def attributes(r)
      return "" if r.user_attributes.empty? || r[:skip_meta]
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
      return "[#{id}](#nowhere)" unless r
      "[[#{r.id}] #{r.title}](##{url(id)})"
    end

    def url(id)
      id.downcase
        .gsub(/[^A-Za-z0-9]/, '-')
        .gsub(/(-){2,}/, '-')
    end
  end

end
