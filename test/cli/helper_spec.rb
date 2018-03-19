# encoding: UTF-8

require_relative '../test_helper'

describe Helper do

  describe '#which' do

    let(:os) { RbConfig::CONFIG['host_os'] }
    let(:win) { os.match "mingw"}

    # win10 test, maybe UX
    it 'must return ruby.exe on win' do
      skip "skip not mingwXX" unless win
      which('ruby.exe').must_match "ruby"
    end

    it 'must return ruby on linux' do
      skip "skip not win" if win
      which('ruby').must_match "ruby"
    end

  end

end
