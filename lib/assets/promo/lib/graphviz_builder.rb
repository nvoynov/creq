# encoding: UTF-8

require 'creq'
require 'ruby-graphviz'

class GraphVizBuilder
  include Creq

  def self.build(id = '')
    builder = new
    builder.graph(id)
  end

  def self.build_clustered
    builder = new
    builder.clustered_graph
  end

  def graph(id = '')
    repo = requirements_repository
    node = id.empty? ? repo : repo.find(id)
    return nil unless node

    GraphViz.new(:G) do |g|
      node.each do |r|
        next if r.root?
        g.add_node(r.id)
        g.add_edge(r.id, r.parent.id) unless r.parent.root?
      end

      unless id.empty?
        r = node.parent
        while !r.parent.root? do
          g.add_node(r.id)
          g.add_edge(r.id, r.parent.id)
          r = r.parent
        end
      end
    end
  end

  def clustered_graph
    repo = requirements_repository
    GraphViz.new(:G) do |g|
      index = 0
      repo.select{|r| r[:cluster]}.each do |cls|
        g.public_send("cluster_#{index.to_s}")  do |c|
          index += 1;
          c[:rank => "same", style: :dashed, label: cls.title]
          c[:color => :white] if index.odd?
          cls.each do |n|
            next if n == cls || n.parent == cls
            c.add_node(n.id);
            c.add_edge(n.id, n.parent.id) # unless n == cls
          end
        end
      end
    end
  end

end
