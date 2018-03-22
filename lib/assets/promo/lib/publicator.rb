# encoding: UTF-8

require 'creq'
require_relative 'param_holder'

# The module provides methods to publish requirements documents as releases and drafts.
# Publicator store settings in `publicator.creq` yml file
module Publicator
  extend ParamHolder
  extend self
  include Creq::Helper

  parameter :title, default: 'SRS'
  parameter :author, default: 'produced by [CReq](https://github.com/nvoynov/creq)'
  parameter :version, default: '0.1'
  parameter :format, default: 'docx pdf'
  parameter :options, default: '-s --toc'
  parameter :docx_options, default: '-s --toc'
  parameter :html_options, default: '-s --toc'
  parameter :pdf_options, default: '-s --toc'
  parameter :query, default: ''

  def release
    load
    up_verison!
    publish "#{title} v#{version}"
  end

  def draft
    load
    publish "#{title} v#{version} draft #{Time.now.strftime('%Y-%b-%d')}"
  end

  protected

  def publish(release_title)
    repo = requirements_repository
    repo = repo.query(query) unless query.empty?
    source = "#{title}.md"
    inside_bin do
      open(source, 'w') {|f|
        f.write "% #{release_title}\n"
        f.write "  (query: #{query})\n" unless query.empty?
        f.write "% #{author}\n" unless author.empty?
        f.write "% on #{Time.now.strftime('%B %e, %Y')}\n"
        PubWriter.(repo, f)
      }

      outputs.each {|fmt, opt|
        `pandoc #{options} #{opt} -o "#{release_title}.#{fmt}" #{source}`
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
    self.version
  end

  def up_verison!
    up_version
    save
  end

end

if __FILE__== $0

end
