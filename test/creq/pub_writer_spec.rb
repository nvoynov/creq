# encoding: UTF-8
require_relative '../test_helper'

class SpecPubWriter < PubWriter
  def title(r); super(r); end
  def attributes(r); super(r); end
  def link(id); super(id); end
  def body(r); super(r); end
  def url(id); super(id); end
end

describe PubWriter do

  let(:req) {
    Requirement.new(id: 'ur', title: 'User reqs').tap {|r|
      r << Requirement.new(id: 'ur.a', title: 'User req A')
      r << Requirement.new(id: 'ur.b', title: 'User req B',
              body: 'link to replace [[ur.a]]', skip_meta: true)
    }
  }

  let(:writer) { SpecPubWriter.new(req) }

  it 'must build #link(id)' do
    writer.link('ur').must_equal '[User reqs](#ur)'
    writer.link('ur.a').must_equal '[User req A](#ur-a)'
    writer.link('ur.b').must_equal '[User req B](#ur-b)'
    writer.link('not.exists').must_equal '[not.exists](#nowhere)'
  end

  it 'must build #title(r)' do
    writer.title(req).must_equal '# User reqs {#ur}'
    writer.title(req.find('ur.a')).must_equal '## User req A {#ur-a}'
    writer.title(req.find('ur.b')).must_equal '## User req B {#ur-b}'
  end

  it 'must build #attributes' do
    writer.attributes(req).must_equal %(Attribute | Value
--------- | -----
id | ur)
    req.find('ur.a').tap {|r|
      r[:author] = 'nvoynov'
      r[:order_index] = 'nvoynov' # system_attribute must be ignored
      writer.attributes(r).must_equal %(Attribute | Value
--------- | -----
id | ur.a
author | nvoynov)
    }
    writer.attributes(req.find('ur.b')).must_equal "" # skip_meta
  end

end
