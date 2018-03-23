# encoding: UTF-8

require 'creq'
require 'csv'

module Prioritizer
  include Creq::Helper
  extend Creq::ParamHolder
  extend self

  parameter :output, default: 'priorities.csv'
  parameter :query,  default: "r.id == 'us'"

  def call
    load if File.exist?(output)
    repo = from_repo
    file = from_file
    inside_bin { write(merge(repo, file)) }
  end

  protected

  def merge(repo, file)
    # TODO user add columns to output?
    repo.each {|i|
      next unless file[i[:id]]
      i[:status] = file[i[:id]][:status]
      i[:risk] = file[i[:id]][:risk]
      i[:effort] = file[i[:id]][:effort]
      i[:priority] = file[i[:id]][:priority]
    }
    repo
  end

  def from_repo
    repo = requirements_repository
    repo = repo.query(query) unless query.empty?
    repo
      .inject([], :<<)
      .tap{|a| a.delete_at(0) unless repo.is_a? Array}
      .map{|r| {id: r.id, title: r.title}.merge(DEFAULT)}
  end

  def from_file
    return {} unless File.exist?(output)
    {}.tap {|res|
      CSV.foreach(output, READOPT) { |row|
        row.to_h.tap {|h| res[h.shift[1]] = h}
      }
    }
  end

  def write(source)
    backup
    CSV.open(output, "wb", WRITOPT){|csv|
      source.each{|i| csv << i.values}
    }
    puts "'#{Creq::Settings.bin}/#{output}' created."
  end

  def backup
    return unless File.exist?(output)
    bckp = File.basename(output, '.csv')
    bckp << ' '
    bckp << File.mtime(output).strftime('%Y-%b-%d %H-%M')
    bckp << '.csv'
    File.rename(output, bckp)
    puts "'#{Creq::Settings.bin}/#{output}' backup as '#{Creq::Settings.bin}/#{bckp}'."
  end

  DEFAULT = {status: 'unknown', risk: 'unknown', effort: 'unknown',
             priority: 'unknown'}

  HEADERS = %w(Id Title Status Risk Effort Priority).freeze

  READOPT = {headers: true, return_headers: false, converters: :all,
             header_converters: lambda {|h| h.downcase.to_sym} }

  WRITOPT = {headers: HEADERS, write_headers: true, return_headers: false}
end

if __FILE__== $0

end
