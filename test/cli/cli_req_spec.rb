# encoding: UTF-8

require_relative '../test_helper'

describe "creq req" do
  let(:id) {'id'}
  let(:cmd) {'req'}
  let(:title) {'title'}
  let(:template) {'tt.id'}

  it 'must create file and notify about success' do
    inside_sandbox do
      file = "#{Settings.src}/id.md"
      success_msg = "File '#{file}' created successfully"
      proc { Cli.start([cmd, id]) }.must_output Regexp.new(success_msg)
      File.exist?(file).must_equal true
    end
  end

  it 'must abort if file already exists' do
    inside_sandbox do
      proc { Cli.start [cmd, id] }.must_output(/created/)
      proc { Cli.start([cmd, id])
      }.must_output(/already exists/)
    end
  end

  it 'must execute CREQ REQ ID' do
    inside_sandbox do
      file = "#{Settings.src}/id.md"
      proc { Cli.start [cmd, id] }.must_output(/created/)
      File.exists?(file).must_equal true
    end
  end

  it 'must execute CREQ REQ TITLE' do
    inside_sandbox do
      file = "#{Settings.src}/id.md"
      proc { Cli.start [cmd, id, title] }.must_output(/created/)
      File.exists?(file).must_equal true
    end
  end

  it 'must execute CREQ REQ -T' do
    inside_sandbox do
      File.write("#{Settings.tt}/tt.id.md.tt", "template_body")
      proc { Cli.start [cmd, id, title, '-t', template] }.must_output(/created/)
    end
  end

  it 'must execute CREQ REQ -T and fail if template was not found' do
    inside_sandbox do
      proc { Cli.start [cmd, id, title, '-t', "abc"] }.must_output(/not found/)
    end
  end

end
