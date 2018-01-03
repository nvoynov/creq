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
    PROJECT_FOLDERS.each do |fld|
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

def pp_requirement(req)
  req.inject([], :<<)
    .each{|r| puts "#{'  ' * (r.level - 1)}[#{r.id}] #{r.title}"}
end

def capture_stdout &block
  old_stdout = $stdout
  $stdout = StringIO.new
  block.call
  $stdout.string
ensure
  $stdout = old_stdout
end

# def with_captured_stdout
#   old_stdout = $stdout
#   $stdout = StringIO.new
#   yield
#   $stdout.string
# ensure
#   $stdout = old_stdout
# end
