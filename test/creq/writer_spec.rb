# encoding: UTF-8
require_relative '../test_helper'

describe Writer do

  before do
    @req = Requirement.new(id: 'ur', title: 'User reqs')
    @req << Requirement.new(id: 'ur.1', title: 'User req 1',
      source: 'user 1', author: 'nvoynov',
      body: "The System shall do something useful.")
    @req << Requirement.new(id: 'ur.2', title: 'User req 2',
      source: 'user 2',
      body: "The System shall do something also useful.")
  end

  # describe 'self#write' do
  it 'must write all tree' do
    StringIO.open do |s|
      Writer.write(@req, s)
      s.string.must_equal %(# [ur] User reqs

## [ur.1] User req 1
{{
source: user 1
author: nvoynov
}}

The System shall do something useful.

## [ur.2] User req 2
{{
source: user 2
}}

The System shall do something also useful.
)
   end
  end

  it 'must write according to :child_order attribute' do
    req = Requirement.new(id: 'ur', title: 'User reqs')
    req << Requirement.new(id: 'ur.b', title: 'User req B')
    req << Requirement.new(id: 'ur.c', title: 'User req C')
    req << Requirement.new(id: 'ur.a', title: 'User req A')
    req[:child_order] = 'ur.a ur.b ur.c'

    StringIO.open do |s| # must write according to child_order
      FinalWriter.write(req, s)
      s.string.index('ur.a').must_be :<, s.string.index('ur.b')
      s.string.index('ur.b').must_be :<, s.string.index('ur.c')
    end

    StringIO.open do |s| # must write according to child_order
      FinalDocWriter.write(req, s)
      s.string.index('ur.a').must_be :<, s.string.index('ur.b')
      s.string.index('ur.b').must_be :<, s.string.index('ur.c')
      s.string.index('[ur]').must_be_nil
    end
  end

  describe 'FinalDocWriter' do
    let(:req) {
      Requirement.new(id: 'ur', title: 'User reqs').tap {|r|
        r << Requirement.new(id: 'ur.a', title: 'User req A')
        r << Requirement.new(id: 'ur.b', title: 'User req B',
                body: 'link to replace [[ur.a]]')
      }
    }

    it 'must replace link macro [[id]]' do
      StringIO.open do |s| # must write according to child_order
        FinalDocWriter.write(req, s)
        s.string.index("[[ur]]").must_be_nil
        s.string.index("[[ur.a]]").must_be_nil
        s.string.index("[[ur.a] User req A](#ur-a)").must_be :>, 0
      end
    end
  end

end
