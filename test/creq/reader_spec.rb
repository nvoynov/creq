# encoding: UTF-8

require_relative '../test_helper'

class SpecReader < Reader
  def self.read_enumerator(enum)
    reader = new("enumerator")
    reader.read(enum)
  end
end

describe Reader do

  it 'must read and return array of requirements' do
    content = StringIO.new %(# [id] title
{{valid: true}}
There is a requirement body
## [id.1] title 1
There is another requirement body
### [id.1.1] title 1 1
### [id.1.2] title 1 2
### [id.1.3] title 1 3
## [id.2] title 2)
    reqs, errs = SpecReader.read_enumerator(content.each_line)
    reqs.size.must_equal 1
    reqs.first.tap do |r|
      r.id.must_equal "id"
      r.title.must_equal "title"
      r.body.must_equal "There is a requirement body"
      r[:valid].must_equal "true"
      r.size.must_equal 2
      r.first.tap do |r1|
        r1.id.must_equal "id.1"
        r1.title.must_equal "title 1"
        r1.body.must_equal "There is another requirement body"
      end
    end
  end

  it 'must read and return array of requirements 1' do
    content = StringIO.new %(# [id] title
## [id.1] title 1
### [id.1.1] title 1 1
##### [id.wrong.5] title wrong 5
### [id.1.3] title 1 3)
    reqs, errs = SpecReader.read_enumerator(content.each_line)
    reqs.size.must_equal 3
    errs.must_include "Hierarhy error:\nid.wrong.5"
    errs.must_include "Hierarhy error:\nid.1.3"
  end

end
