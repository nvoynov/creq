# encoding: UTF-8

require_relative 'doc_writer'

module Creq

  class PubWriter < DocWriter

    protected

      def attributes(r)
        return "" if r[:skip_meta]
        attributes = {id: r.id}.merge(r.attributes)
        r.attributes.clear
        attributes.each{|k, v| r[k] = v}
        super(r)
      end

      def link(id)
        r = @root.find(id)
        return "[#{id}](#nowhere)" unless r
        "[#{r.title}](##{url(id)})"
      end

      def title(r)
        "#{'#' * r.level} #{r.title} {##{url(r.id)}}"
      end

  end

end
