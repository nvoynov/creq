$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pp'
require 'creq'
include Creq
include Creq::Helper

require 'minitest/autorun'

SANDBOX = "tmp"

def inside_sandbox
  Dir.mkdir(SANDBOX) unless Dir.exist?(SANDBOX)
  Dir.chdir(SANDBOX) do
    Project.folders.each do |fld|
      FileUtils.rm_rf(Dir.glob("#{fld}/*")) if Dir.exist?(fld)
      Dir.mkdir(fld) unless Dir.exist?(fld)
    end
    yield if block_given?
  end
end

def inside_tmp
  Dir.mkdir(SANDBOX) unless Dir.exist?(SANDBOX)
  Dir.chdir(SANDBOX){ yield if block_given? }
end
