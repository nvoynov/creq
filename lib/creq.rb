require_relative "creq/version"
require_relative "creq/tree_node"
require_relative "creq/requirement"
require_relative "creq/loader"
require_relative "helper"
require_relative "cli"

module Creq
  include Helper

  def self.root
    File.dirname __dir__
  end
end
