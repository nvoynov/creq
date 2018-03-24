# encoding: UTF-8

require_relative 'settings'

module Creq
  module Project
    extend self

    def init(directory = Dir.pwd)
      Dir.chdir(directory) {
        folders.each {|f| Dir.mkdir(f) unless Dir.exist?(f)}
      }
      Settings.save
    end

    def folders
      [Settings.bin,
       Settings.assets,
       Settings.src,
       Settings.lib,
       Settings.knb,
       Settings.tt]
    end
  end
end
