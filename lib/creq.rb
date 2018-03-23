require_relative "creq/version"
require_relative "creq/param_holder"
require_relative "creq/settings"
require_relative "creq/tree_node"
require_relative "creq/requirement"
require_relative "creq/parser"
require_relative "creq/reader"
require_relative "creq/writer"
require_relative "creq/doc_writer"
require_relative "creq/pub_writer"
require_relative "creq/repository"
require_relative "creq/project"
require_relative "creq/req_cmd"
require_relative "helper"
require_relative "cli"

module Creq
  include Helper

  CreqCmdError = Class.new(StandardError)

  def self.root
    File.dirname __dir__
  end
end
