# encoding: UTF-8

require_relative '../test_helper'

describe ReqCommand do
  let(:id) {'id'}
  let(:title) {'title'}
  let(:content_id) {"# [id] id\n"}
  let(:content_id_title) {"# [id] title\n"}
  let(:file_name) { "#{Settings::REQ}/#{id}.md"}

  it 'must create file by id' do
    inside_sandbox do
      ReqCommand.(id).must_equal file_name
      File.exists?(file_name).must_equal true
      File.read(file_name).must_equal content_id
    end
  end

  it 'must create file by id, title' do
    inside_sandbox do
      ReqCommand.(id, title).must_equal file_name
      File.exists?(file_name).must_equal true
      File.read(file_name).must_equal content_id_title
    end
  end

  it 'must abort if file already exists' do
    inside_sandbox do
      ReqCommand.(id).must_equal file_name
      ex = -> { ReqCommand.(id) }.must_raise CreqCmdError
      ex.message.must_match(/already exists/)
    end
  end

  let(:template_body) {%(System shall provide the next functions:
* select
* create
* update
* delete

## [@@id.select] Select

## [@@id.create] Create

## [@@id.update] Update

## [@@id.delete] Delete

)}

  let(:final_body) {%(# [id] title

TODO: The contents of this file were generated automatically based on 'tt/tt.id.md.tt'\n
System shall provide the next functions:
* select
* create
* update
* delete

## [id.select] Select

## [id.create] Create

## [id.update] Update

## [id.delete] Delete

)}

  it 'must create file by template' do
    inside_sandbox do
      File.write("#{Settings::TT}/tt.id.md.tt", template_body)
      ReqCommand.(id, title, 'tt.id').must_equal file_name
      File.read(file_name).must_equal final_body
    end
  end

  it 'must raise CreqCmdError if temlate is not found' do
    inside_sandbox do
      ex = -> { ReqCommand.(id, title, 'abc') }.must_raise CreqCmdError
      ex.message.must_match(/not found/)
    end
  end

end
