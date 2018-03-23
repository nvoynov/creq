require 'thor'
require 'creq'
require_relative 'lib/publicator'
require_relative 'lib/prioritizer'

class Promo < Thor
  include Thor::Actions
  include Creq

  no_commands {
    def git_commit(msg)
      `git add .`
      `git commit -m "#{msg}"`
    end
  }

  desc 'release', 'Release output document'
  def release
    Publicator.release
    git_commit "#{Publicator.version} released"
  end

  desc 'draft', 'Create draft'
  def draft
    Publicator.draft
    git_commit "#{Publicator.version} draft #{Time.now.strftime('%Y-%b-%d')}"
  end

  desc 'priorities', 'Create priorities.csv'
  def priorities
    Prioritizer.()
  end

end
