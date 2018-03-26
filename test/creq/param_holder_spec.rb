# encoding: UTF-8
require_relative '../test_helper'

module SpecParams
  extend ParamHolder
  extend self

  parameter :para1, default: 1
  parameter :para2, default: '2'
end

describe SpecParams do

  it 'must store parameters in specparams.yml' do
    inside_sandbox do
      SpecParams.storage.must_equal 'specparams.yml'
    end
  end

  it 'must #save parameters' do
    inside_sandbox do
      SpecParams.para1 = 2
      SpecParams.save
      File.exist?(SpecParams.storage).must_equal true
      content = File.read(SpecParams.storage)
      content.must_match "para1: 2"
      content.must_match "para2: '2'"
    end
  end

  it 'must #load parameters' do
    inside_sandbox do
      SpecParams.para1 = 2
      SpecParams.save
      SpecParams.load
      SpecParams.para1.must_equal 2
      SpecParams.para1 = 25
      SpecParams.load
      SpecParams.para1.must_equal 2
    end
  end
end


describe Settings do
  it 'must #load' do
    inside_sandbox do
      Settings.src = 'sss'
      Settings.save
      Settings.src = 'ddd'
      Settings.load
      Settings.src.must_equal 'sss'
    end
  end
end
