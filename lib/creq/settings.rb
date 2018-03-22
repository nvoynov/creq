# encoding: UTF-8

require_relative 'param_holder'

module Creq
  module Settings
    extend ParamHolder
    extend self

    parameter :bin, default: 'bin'
    parameter :assets, default: 'bin/assets'
    parameter :src, default: 'src'
    parameter :lib, default: 'lib'
    parameter :kbd, default: 'kbd'
    parameter :tt, default: 'tt'
    parameter :title, default: 'Software Requirements Specification'
    parameter :output, default: 'requirements'
    parameter :author, default: '[CReq](https://github.com/nvoynov/creq)'

    def storage
      'creq.yml'
    end

  end
end

Creq::Settings.save unless File.exist?(Creq::Settings.storage)
Creq::Settings.load
