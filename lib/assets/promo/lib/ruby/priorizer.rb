# encoding: UTF-8

require 'creq'
require 'csv'

class Prioritizer
  extend Creq

  def self.call(file_name = STORAGE)
    repo = from_repo
    file = from_file(file_name)
    write(merge(repo, file), file_name)
  end

  def self.merge(repo, file)
    repo.each {|i|
      next unless file[i[:id]]
      i[:risk] = file[i[:id]][:risk]
      i[:effort] = file[i[:id]][:effort]
      i[:priority] = file[i[:id]][:priority]
    }
    repo
  end

  def self.from_repo
    requirements_repository
      .inject([], :<<)
      .tap{|a| a.delete_at(0)}
      .map{|r| {id: r.id, title: r.title}.merge(DEFAULT)}
  end

  def self.from_file(file_name)
    return {} unless File.exist?(file_name)
    {}.tap {|res|
      CSV.foreach(file_name, READOPT) { |row|
        row.to_h.tap {|h| res[h.shift[1]] = h}
      }
    }
  end

  def self.write(source, file_name)
    backup(file_name)
    CSV.open(file_name, "wb", WRITOPT){|csv|
      source.each{|i| csv << i.values}
    }
  end

  def self.backup(file_name)
    return unless File.exist?(file_name)
    bckp = File.basename(file_name, '.csv')
    bckp << ' '
    bckp << File.mtime(file_name).strftime('%Y-%b-%d %H-%M')
    bckp << '.csv'
    File.rename(file_name, bckp)
  end

  DEFAULT = {status: 'unknown', risk: 'unknown', effort: 'unknown',
             priority: 'unknown'}

  STORAGE = 'priorities.csv'.freeze

  HEADERS = %w(Id Title Status Risk Effort Priority).freeze

  READOPT = {headers: true, return_headers: false, converters: :all,
             header_converters: lambda {|h| h.downcase.to_sym} }

  WRITOPT = {headers: HEADERS, write_headers: true, return_headers: false}
end

if __FILE__== $0
  Prioritizer.()
end
