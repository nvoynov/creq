# encoding: UTF-8
require_relative '../test_helper'

describe "creq doc" do
  let(:cmd) { "doc" }
  let(:doc) { "#{DOC}/requirements.md" }

  it 'must write doc/requirements.md' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
      end
      proc { Cli.start [cmd] }.must_output "'#{doc}' created!\n"
      content = File.read(doc)
      content.must_match /# \[req.1\] req 1/
      content.must_match /# \[req.2\] req 2/
    end
  end

  it 'must replace doc/requirements.md' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
      end
      proc { Cli.start [cmd] }
      inside_req { File.write('req.3.md', "# [req.3] req 3\n") }
      proc { Cli.start [cmd] }.must_output "'#{doc}' created!\n"
      content = File.read(doc)
      content.must_match /# \[req.1\] req 1/
      content.must_match /# \[req.2\] req 2/
      content.must_match /# \[req.3\] req 3/
    end
  end

end
