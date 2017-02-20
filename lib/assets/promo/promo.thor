require 'thor'
require 'creq'
require_relative 'lib\ruby\graphviz_builder'

class Trace_promo < Thor
  include Thor::Actions
  include Creq

  desc "toc", "Table of contents"
  def toc
    say "-= #{Dir.pwd}: Contents =-"
    requirements_repository
      .inject([], :<<)
      .tap {|a| a.delete_at(0)}
      .each{|r| puts "#{'  ' * (r.level - 2)}[#{r.id}] #{r.title}"}
  end

  desc "graph [ID]", "Draw a requirements graph"
  def graph(id = '')
    g = GraphVizBuilder.build(id)
    unless g
      say "Nothing to draw!"
      say "Requirement [#{id}] not found." unless id.empty?
      return
    end
    g.output(png: id.empty? ? 'graph.png' : "#{id}.graph.png")
  end

  desc "graphc", "Draw a clustered graph"
  def graphc
    g = GraphVizBuilder.build_clustered
    g.output(png: 'graph_clustered.png')
  end

end
