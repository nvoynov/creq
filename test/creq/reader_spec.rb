# encoding: UTF-8

require_relative '../test_helper'
include Reader

describe Reader do

  describe '#transform' do
    it 'must transform right hierarhy' do
      text_reqs = [
        "# [id] Title\n",
        "## [id.1] Title 1\n",
        "### [id.1.1] Title 1 1\n",
        "#### [id.1.1.1] Title 1 1 1\n",
        "### [id.1.2] Title 1 2\n",
        "## [id.2] Title 2\n"]
      reqs = transform(text_reqs)
      reqs.size.must_equal 1
      reqs.first.items.size.must_equal  2
      reqs.first.items.first.items.size.must_equal  2
    end

    it 'must produce error for deeper than 4th level' do
      ary = ["##### [deeper.than.4] title\n"]
      proc { transform(ary) }.must_output(/deeper than 4th/)
    end

    it 'must produce errors for wrong hierarhy' do
      ary = ["## [id] title\n"]
      proc { transform(ary) }.must_output(/cannot find parent for id/)

      ary = [
        "# [id] title\n",
        "## [id.1] title 1\n",
        "#### [id.1.1.1] title 1 1 1\n"]
      proc { transform(ary) }.must_output(/cannot find parent for id.1.1.1/)
    end

  end

  describe '#extract' do
    before do
      @text = %(# [id] Title
## [id.1] Title 1
{{a: b, c: d}}

Body 1

### [id.1.1] Title 1 1

Body 1 1

### [id.1.2] Title 1 2
{{
a: b
c: d
}}

Body 1 1
## [id.2] Title 2
)
    end

    it 'must return array of requirements text' do
      items = extract(@text.each_line)
      items.size.must_equal 5
      items[0].must_include "# [id] Title"
      items[1].must_include "## [id.1] Title 1"
      items[2].must_include "### [id.1.1] Title 1 1"
      items[3].must_include "### [id.1.2] Title 1 2"
      items[4].must_include "## [id.2] Title 2"
    end
  end

  describe '#parse_attrubutes' do
    it 'must return {} for text.empty?' do
      parse_attributes("").must_equal({})
    end

    it 'must split attributes by \n or ","' do
      text = "source: creq, parent: id\nstatus: approved"
      parse_attributes(text).must_equal(
        {source: "creq", parent: "id", status: "approved"})
    end

    it 'must strip spaces in attributes name and value' do
      text = "source:     creq,      parent:    id"
      parse_attributes(text).must_equal({source: "creq", parent: "id"})
    end

    it 'must strip forward \n' do
      text = "\nsource: creq, parent: id"
      parse_attributes(text).must_equal({source: "creq", parent: "id"})
    end

  end

  describe '#parse_requirement' do
    it 'must parse all parts' do
      s = "# [id] title\n{{source: creq}}\n\n There is a paragraph1.\n\nThere is a paragraph 2\n\n"
      r = parse_requirement(s)
      r.id.must_equal "id"
      r.title.must_equal "title"
      r.attributes.must_equal({source: "creq"})
      r.body.must_equal "There is a paragraph1.\n\nThere is a paragraph 2"
    end

    it 'must parse header only' do
      s = "# [id] title\n"
      r = parse_requirement(s)
      r.id.must_equal "id"
      r.title.must_equal "title"
      r.attributes.must_equal({})
      r.body.must_equal ""
    end

    it 'must parse without attributes' do
      s = "# [id] title\n\n\nThere is a requirement body"
      r = parse_requirement(s)
      r.id.must_equal "id"
      r.title.must_equal "title"
      r.attributes.must_equal({})
      r.body.must_equal "There is a requirement body"
    end

    it 'must parse without body' do
      s = "# [id] title\n{{source: creq}}"
      r = parse_requirement(s)
      r.id.must_equal "id"
      r.title.must_equal "title"
      r.attributes.must_equal({source: "creq"})
      r.body.must_equal ""
    end
  end

  describe 'other staff' do
    it '#md_header_level must return correct level' do
      md_header_level("# first").must_equal 1
      md_header_level("## second").must_equal 2
      md_header_level("### third").must_equal 3
      md_header_level("#### fourth").must_equal 4
    end
  end

end
