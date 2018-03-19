# encoding: UTF-8

module Creq

  class Writer

    def self.call(req, stream = $stdout)
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
      "#{'#' * r.level} [#{r.id}] #{r.title}"
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

end
