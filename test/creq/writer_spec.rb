# encoding: UTF-8
require_relative '../test_helper'

class SpecWriter < Creq::Writer
  def title(r); super(r); end
  def attributes(r); super(r); end
  def body(r); super(r); end
end

describe Writer do
  let(:req) {
    req = Requirement.new(id: 'ur', title: 'User reqs')
    req << Requirement.new(id: 'ur.1', title: 'User req 1',
      source: 'user 1', author: 'nvoynov',
      body: "The System shall do something useful.")
    req << Requirement.new(id: 'ur.2', title: 'User req 2',
      source: 'user 2',
      body: "The System shall do something also useful.")
    req
  }

  let(:writer) { SpecWriter.new(req) }

  it 'must build #title' do
    writer.title(req).must_equal '# [ur] User reqs'
    writer.title(req.find('ur.1')).must_equal '## [ur.1] User req 1'
    writer.title(req.find('ur.2')).must_equal '## [ur.2] User req 2'
  end

  it 'must build #attributes' do
    writer.attributes(req).must_equal ''
    writer.attributes(req.find('ur.1')).must_equal %({{
source: user 1
author: nvoynov
}})
    writer.attributes(req.find('ur.2')).must_equal %({{
source: user 2
}})
  end

  it 'must build #body' do
    writer.body(req).must_equal ''
    writer.body(req.find('ur.1')).must_equal "\nThe System shall do something useful."
    writer.body(req.find('ur.2')).must_equal "\nThe System shall do something also useful."
  end

  # describe 'self#write' do
  it 'must write all tree' do
    StringIO.open do |s|
      Writer.(req, s)
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

end
