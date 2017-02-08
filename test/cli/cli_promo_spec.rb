# encoding: UTF-8
require_relative '../test_helper'

describe 'creq promo' do
  let(:command) { 'promo' }

  it 'must copy promo project to the current directory' do
    inside_sandbox do
      proc {
        Cli.start [command]
      }
    end
  end
end
