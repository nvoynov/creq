# encoding: UTF-8

require 'yaml'

module Creq

  # Module for holding parameters in .yml file
  # Usage:
  #
  #     module Settings
  #       extend ParamHolder
  #       extend self
  #
  #       parameter :param1, default: 2
  #       parameter :param2, default: 2
  #     end
  #
  #     require_relative 'settings'
  #
  #     pp Settings.param1
  #     pp Settings.param2
  #
  module ParamHolder
    extend self

    # parameter to hold
    def parameter(name, options)
      @@para ||= {}
      @@para[name.to_s] = options[:default]

      define_method("#{name}") do
        @@loaded ||= begin
          load
          true
        end
        @@para.send :[], name.to_s
      end

      define_method("#{name}=") do |value|
        @@para.send :[]=, name.to_s, value
      end
    end

    def load
      @@para = YAML.load(File.read(storage)) if File.exist?(storage)
    end

    def save
      File.write(storage, YAML.dump(@@para))
    end

    def storage
      "#{name.downcase}.yml"
    end

  end

end
