# encoding: UTF-8
require_relative '../test_helper'

describe "creq req" do
  let(:id) {'id'}
  let(:cmd) {'req'}
  let(:file) {"#{REQ}/id.md"}
  let(:title) {'title'}
  let(:template) {'tt.id'}

  it 'must create file and notify about success' do
    inside_sandbox do
      proc { Cli.start([cmd, id]) }.must_output(/File 'req\/id.md' is created/)
      File.exist?(file).must_equal true
    end
  end

  it 'must abort if file already exists' do
    inside_sandbox do
      proc { Cli.start [cmd, id] }.must_output(/created/)
      proc { Cli.start([cmd, id])
      }.must_output(/File 'req\/id\.md' already exists/)
    end
  end

  it 'must execute CREQ REQ ID' do
    inside_sandbox do
      proc { Cli.start [cmd, id] }.must_output(/created/)
      File.read(file).must_equal %(# [id] id\n)
    end
  end

  it 'must execute CREQ REQ TITLE' do
    inside_sandbox do
      proc { Cli.start [cmd, id, title] }.must_output(/created/)
      File.read(file).must_equal %(# [id] title\n)
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

  it 'must execute CREQ REQ -T' do
    inside_sandbox do
      File.write("#{TT}/tt.id.md.tt", template_body)
      proc { Cli.start [cmd, id, title, '-t', template] }.must_output(/created/)
      File.read(file).must_equal final_body
    end
  end

  it 'must report about wrong template but not fail' do
    inside_sandbox do
      proc { Cli.start [cmd, id, title, '-t', template]
      }.must_output(/Template file 'tt.id' is not found/)
      File.read(file).must_equal %(# [id] title\n)
    end
  end

end
