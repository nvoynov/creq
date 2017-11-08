# encoding: UTF-8
require_relative '../test_helper'

describe Parser do

  describe "parse_attributes" do
    it 'must return {} for text.empty?' do
      Parser.parse_attributes("").must_equal([{}, ""])
    end

    it 'must split attributes by \n or ","' do
      text = "source: creq, parent: id\nstatus: approved"
      Parser.parse_attributes(text).must_equal(
        [{source: "creq", parent: "id", status: "approved"}, ""])
    end

    it 'must strip spaces in attributes name and value' do
      text = "source:     creq,      parent:    id"
      Parser.parse_attributes(text).must_equal(
        [{source: "creq", parent: "id"}, ""])
    end

    it 'must strip forward \n' do
      text = "\nsource: creq, parent: id"
      Parser.parse_attributes(text).must_equal(
        [{source: "creq", parent: "id"}, ""])
    end

    it 'must return format error' do
      Parser.parse_attributes("a").must_equal(
        [{}, "attributes format error:\n{{a}}"])
    end
  end

  describe 'parse' do

    it 'must parse header only' do
      txt = "# [id] title\n"
      req, lev, err = Parser.parse(txt)
      req.must_be_kind_of Requirement
      lev.must_equal 1
      err.must_be_empty

      req.id.must_equal "id"
      req.title.must_equal "title"
      req.attributes.must_be_empty
      req.body.must_be_empty

      txt = "# [id] title"
      req, lev, err = Parser.parse(txt)
      err.must_be_empty
      req.wont_be_nil
    end

    it 'must parse full requirement' do
      txt = "### [id] title\n{{source: nvoynov}}\nbody\n"
      req, lev, err = Parser.parse(txt)
      req.must_be_kind_of Requirement
      lev.must_equal 3
      err.must_be_empty

      req.id.must_equal "id"
      req.title.must_equal "title"
      req.attributes.must_equal({source: 'nvoynov'})
      req.body.must_equal "body"
    end

    it 'must parse req withot title' do
      txt = "# [id]\n{{valid: true}}\ncorrect body"
      req, lev, err = Parser.parse(txt)
      lev.must_equal 1
      req.id.must_equal "id"
      req.title.must_equal ""
      err.must_equal ""
    end

    it 'must return format error if # does not exist' do
      txt = "wrong title\n{{valid: true}}\ncorrect body\n"
      req, lev, err = Parser.parse(txt)
      req.must_be_nil
      lev.must_be_nil
      err.must_equal "Requirement format error:\n" + txt
    end

    # empty IDs are allowed now 2017-06-11
    #
    # it 'must return format error if id does not exist' do
    #   txt = "# wrong title\n{{valid: true}}\ncorrect body\n"
    #   req, lev, err = Parser.parse(txt)
    #   req.must_be_nil
    #   lev.must_be_nil
    #   err.must_equal "Requirement format error:\n" + txt
    # end

    it 'must parse req and return attributes error' do
      txt = "# [id] wrong attrs\n{{valid}}\ncorrect body"
      req, lev, err = Parser.parse(txt)
      req.id.must_equal "id"
      req.title.must_equal "wrong attrs"
      req.attributes.must_equal({})
      lev.must_equal 1
      err.must_equal "[id] attributes format error:\n{{valid}}"
    end

  end

end
