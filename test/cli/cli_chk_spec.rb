# encoding: UTF-8
require_relative '../test_helper'

describe "creq chk" do
  let(:cmd) { 'chk' }

  it 'must check repo for wrong links' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [req.1] req 1\n\n Wrong [[req.x]] link\n")
        File.write('req.2.md', "# [req.2] req 2\n\n [[req.x]] Wrong link\n")
        File.write('req.3.md', "# [req.3] req 3\n\n Wrong link [[req.x]]\n")
      end
      proc {
        Cli.start [cmd]
      }.tap{|o|
        o.must_output /\[\[req.x\]\]/
        o.must_output /in requirements \[req.1\], \[req.2\], \[req.3\]/
        o.must_output /in files: 'req.1.md', 'req.2.md', 'req.3.md'/
      }
    end
  end

  it 'must check repo for wrong parents' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
        File.write('req.3.md', "# [req.3] req 3\n{{parent: ur}}\n")
      end
      proc {
        Cli.start [cmd]
      }.tap{|o|
        o.must_output /\[req.3\] \{\{parent: ur\}\}/
      }
    end
  end

  it 'must check repo for non-uniq id' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [req.1] req 1\n")
        File.write('req.2.md', "# [req.2] req 2\n")
        File.write('req.3.md', "# [req.2] req 3\n")
      end
      proc {
        Cli.start [cmd]
      }.tap{|o|
        o.must_output /\[req.2\] in files 'req.2.md', 'req.3.md'/
      }
    end
  end

end
