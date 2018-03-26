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

    # parameter to hold
    def parameter(name, options)
      define_method("#{name}") do
        @loaded ||= begin
          load
          true
        end
        self.instance_variable_get("@#{name.to_s}")
      end

      define_method("#{name}=") do |value|
        self.instance_variable_set("@#{name.to_s}", value)
      end

      self.instance_variable_set("@#{name.to_s}", options[:default])
    end

    def load
      return unless File.exist?(storage)
      prop = YAML.load(File.read(storage))
      prop.each{|k, v|
        self.instance_variable_set("@#{k}", v)
      }
    end

    def save
      {}.tap {|prop|
        self.instance_variables.each{|v| prop[v.to_s[1..-1]] = self.instance_variable_get("#{v}")}
        File.write(storage, YAML.dump(prop))
      }
    end

    def storage
      "#{name.downcase}.yml"
    end

  end

end
