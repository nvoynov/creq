# encoding: UTF-8
require_relative '../test_helper'

describe "creq doc" do
  let(:cmd) { "doc" }

  it 'must write bin/requirements.md' do
    inside_sandbox do
      doc = "#{Settings.bin}/#{Settings.output}.md"
      inside_src do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
      end
      proc { Cli.start [cmd] }.must_output /'#{doc}' created!/
      content = File.read(doc)
      content.must_match /# \[req.1\] req 1/
      content.must_match /# \[req.2\] req 2/
    end
  end

  it 'must replace bin/requirements.md' do
    inside_sandbox do
      doc = "#{Settings.bin}/#{Settings.output}.md"
      inside_src do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
      end
      proc { Cli.start [cmd] }
      inside_src { File.write('req.3.md', "# [req.3] req 3\n") }
      proc { Cli.start [cmd] }.must_output /'#{doc}' created!/
      content = File.read(doc)
      content.must_match /# \[req.1\] req 1/
      content.must_match /# \[req.2\] req 2/
      content.must_match /# \[req.3\] req 3/
    end
  end

end
