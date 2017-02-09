require 'thor'
require 'creq'

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

end
