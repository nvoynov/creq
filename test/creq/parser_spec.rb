# encoding: UTF-8
require_relative '../test_helper'

describe Parser do

  describe "parse_attributes" do
    it 'must return {} for text.empty?' do
      Parser.parse_attributes("").must_equal({})
    end

    it 'must split attributes by \n or ","' do
      text = "source: creq, parent: id\nstatus: approved"
      Parser.parse_attributes(text).must_equal(
        {source: "creq", parent: "id", status: "approved"})
    end

    it 'must strip spaces in attributes name and value' do
      text = "source:     creq,      parent:    id"
      Parser.parse_attributes(text).must_equal(
        {source: "creq", parent: "id"})
    end

    it 'must strip forward \n' do
      text = "\nsource: creq, parent: id"
      Parser.parse_attributes(text).must_equal(
        {source: "creq", parent: "id"})
    end

    it 'must return format error' do
      proc {
        a = Parser.parse_attributes("a")
        a.must_equal({})
      }.must_output /Attributes format error for:\n{{a}}\n/
    end
  end

  describe 'parse' do

    it 'must parse header only' do
      txt = "# [id] title\n"

      proc {
        req, lev = Parser.(txt)
        lev.must_equal 1
        req.must_be_kind_of Requirement
        req.id.must_equal "id"
        req.title.must_equal "title"
        req.attributes.must_be_empty
        req.body.must_be_empty
      }.must_be_silent

      txt = "# [id] title"
      proc {
        req, _ = Parser.(txt)
        req.wont_be_nil
      }.must_be_silent

    end

    it 'must parse full requirement' do
      txt = "### [id] title\n{{source: nvoynov}}\nbody\n"
      proc {
        req, lev = Parser.(txt)
        lev.must_equal 3
        req.must_be_kind_of Requirement
        req.id.must_equal "id"
        req.title.must_equal "title"
        req.attributes.must_equal({source: 'nvoynov'})
        req.body.must_equal "body"
      }.must_be_silent
    end

    it 'must parse req without title' do
      txt = "# [id]\n{{valid: true}}\ncorrect body"
      proc {
        req, lev = Parser.(txt)
        lev.must_equal 1
        req.id.must_equal "id"
        req.title.must_equal ""
      }.must_be_silent

    end

    it 'must return format error if # does not exist' do
      txt = "wrong title\n{{valid: true}}\ncorrect body\n"
      proc {
        req, lev = Parser.(txt)
        req.must_be_nil
        lev.must_be_nil
      }.must_output /Requirement format error for:\n#{txt}/
    end

    it 'must parse req and return attributes error' do
      txt = "# [id] wrong attrs\n{{valid}}\ncorrect body"
      proc {
        req, lev = Parser.(txt)
        lev.must_equal 1
        req.id.must_equal "id"
        req.title.must_equal "wrong attrs"
        req.attributes.must_equal({})
      }.must_output /Attributes format error for:\n{{valid}}\n/
    end

  end

end
