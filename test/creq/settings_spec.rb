# encoding: UTF-8

require_relative '../test_helper'

describe 'Settings' do

  let(:settings) {
%(
bin: doc
)
  }

  it 'must read creq.yml' do
    skip
    inside_sandbox do
      File.write('creq.yml', settings)
      Settings.load
      Settings.bin.must_equal 'doc'
    end
  end

end
