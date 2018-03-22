# encoding: UTF-8
require_relative '../test_helper'

class SpecDocWriter < DocWriter
  def title(r); super(r); end
  def attributes(r); super(r); end
  def body(r); super(r); end
  def link(id); super(id); end
  def url(id); super(id); end
end

describe DocWriter do

  let(:req) {
    Requirement.new(id: 'ur', title: 'User reqs').tap {|r|
      r << Requirement.new(id: 'ur.a', title: 'User req A')
      r << Requirement.new(id: 'ur.b', title: 'User req B',
              body: 'link to replace [[ur.a]]', skip_meta: true)
    }
  }

  let(:writer) { SpecDocWriter.new(req) }

  it 'must build #url(id)' do
    writer.url(req.id).must_equal "ur"
    writer.url(req.find('ur.a').id).must_equal "ur-a"
    writer.url(req.find('ur.b').id).must_equal "ur-b"

    long_id = 'f.a.b.c.d.02'
    req << Requirement.new(id: long_id)
    writer.url(long_id).must_equal "f-a-b-c-d-02"
  end

  it 'must build #link(id)' do
    writer.link('ur').must_equal '[[ur] User reqs](#ur)'
    writer.link('ur.a').must_equal '[[ur.a] User req A](#ur-a)'
    writer.link('ur.b').must_equal '[[ur.b] User req B](#ur-b)'
    writer.link('not.exists').must_equal '[not.exists](#nowhere)'
  end

  it 'must build #title(r)' do
    writer.title(req).must_equal "# [ur] User reqs"
    writer.title(req.find('ur.a')).must_equal "## [ur.a] User req A"
    writer.title(req.find('ur.b')).must_equal "## User req B"
  end

  it 'must build #attributes' do
    writer.attributes(req).must_equal ""
    req.find('ur.a').tap {|r|
      r[:author] = 'nvoynov'
      r[:order_index] = 'nvoynov' # system_attribute must be ignored
      writer.attributes(r).must_equal %(Attribute | Value
--------- | -----
author | nvoynov)
    }
    writer.attributes(req.find('ur.b')).must_equal "" # skip_meta
  end

  it 'must build #body(r)' do
    writer.body(req).must_equal ''
    writer.body(req.find('ur.a')).must_match ''
    writer.body(req.find('ur.b')).must_match 'link to replace [[ur.a] User req A](#ur-a)'
  end

  it 'must replace link macro [[id]]' do
    StringIO.open do |s| # must write according to order_index
      DocWriter.(req, s)
      s.string.index("[[ur]]").must_be_nil
      s.string.index("[[ur.a]]").must_be_nil
      s.string.must_match "[[ur.a] User req A](#ur-a)"
    end
  end

end
