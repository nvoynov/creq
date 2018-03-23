# encoding: UTF-8

require 'creq'

# The module provides methods to publish requirements documents as releases and drafts.
# Publicator store settings in `publicator.creq` yml file
module Publicator
  include Creq::Helper
  extend Creq::ParamHolder
  extend self

  parameter :output,  default: 'CReq SRS'
  parameter :title,   default: 'CReq. Software Requirements Specification'
  parameter :author,  default: 'produced by [CReq](https://github.com/nvoynov/creq)'
  parameter :version, default: '0.1'
  parameter :format,  default: 'docx html'
  parameter :options, default: '-s --toc --highlight-style=pygments'
  parameter :docx_options, default: ''
  parameter :html_options, default: ''
  parameter :query, default: ''

  def release
    load
    up_verison!
    publish "#{output} v#{version}"
  end

  def draft
    load
    up_version
    publish "#{output} v#{version} draft #{Time.now.strftime('%Y-%b-%d')}"
  end

  protected

  def publish(release_title)
    repo = requirements_repository
    repo = repo.query(query) unless query.empty?
    source = "#{output}.md"
    inside_bin do
      open(source, 'w') {|f|
        f.write "% #{title}\n"
        f.write "  v#{version}\n"
        f.write "  (query: #{query})\n" unless query.empty?
        f.write "% #{author}\n" unless author.empty?
        f.write "% on #{Time.now.strftime('%B %e, %Y')}\n"
        Creq::PubWriter.(repo, f)
      }

      outputs.each {|fmt, opt|
        `pandoc #{options} #{opt} -o "#{release_title}.#{fmt}" "#{source}"`
        puts "'#{Creq::Settings.bin}/#{release_title}.#{fmt}' created."
      }
    end

  end

  def outputs
    {}.tap {|out|
      format.split(/ /).each {|fmt|
        out[fmt] = self.send("#{fmt}_options")
      }
    }
  end

  def up_version
    self.version = /(\d)\.(\d)/.match(version) do |v|
      major, minor = v[1], v[2]
      "#{major}.#{minor.to_i + 1}"
    end
  end

  def up_verison!
    up_version
    save
  end

end

if __FILE__== $0

end
