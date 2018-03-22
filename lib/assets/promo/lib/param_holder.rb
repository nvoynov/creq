require 'pp'
require 'yaml'

module ParamHolder
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

end
