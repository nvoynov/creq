require 'thor'
require 'creq'
require 'ruby-graphviz'

class Promo < Thor
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

  desc "viz", "Draw a graph"
  def viz
    say "Draw requirements graph..."
    repo = requirements_repository
    GraphViz.new(:G) do |g|
      repo.each do |r|
        next if r.root?
        g.add_node(r.id)
        g.add_edge(r.id, r.parent.id) unless r.parent.root?
      end
    end.output(png: 'graph.png')
  end

  desc "cviz", "Draw a clustered attribute `clustered` "
  def cviz
    repo = requirements_repository
    GraphViz.new( :G ) { |g|
      index = 0
      repo.select{|r| r[:cluster]}.each{|cls|
        g.public_send("cluster_#{index.to_s}") {|c|
          index += 1;
          c[:rank => "same", style: :dashed, label: cls.title]
          c[:color => :white] if index.odd?
          cls.each{|n|
            c.add_node(n.id);
            c.add_edge(n.id, n.parent.id) unless n == cls
          }
        }
      }
    }.output(png: "graph_cluster.png")
  end

end
