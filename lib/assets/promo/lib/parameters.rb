require 'pp'
require 'yaml'

module Parameters
  extend self

  def parameter(name, options)
    @@para ||= {}
    @@para[name] = options[:default]

    define_method("#{name}") do
      @@para.send :[], name
    end

    define_method("#{name}=") do |value|
      @@para.send :[]=, name, value
    end
  end

  def load
    @@para = YAML.load(File.read(storage)) if File.exist?(storage)
  end

  def save
    File.write(storage, YAML.dump(@@para))
  end

  def storage
    "#{name.downcase}.creq"
  end

  parameter :title, default: 'SRS'
  parameter :version, default: '0.1'
end

module Publicator
  extend Parameters

  parameter :title, default: 'SRS'
  parameter :version, default: '0.1'
  parameter :format, default: 'docx pdf'
  parameter :pandoc, default: '-s --toc'
  parameter :query, default: ''

end

# Publicator.save
Publicator.load
pp Publicator.version
