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
        o.must_output /Wrong requirements links are found/
        o.must_output /\[\[req.x\]\]/
        o.must_output /in \[req.1\], \[req.2\], \[req.3\]/
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
        o.must_output /Wrong {{parent}} values are found:/
        o.must_output /\[ur\] for \[req.3\] in req.3.md/
      }
    end
  end

  it 'must check wrong first file header level' do
    inside_sandbox do
      inside_req { File.write('req.1.md', "## [req.1] req 1\n") }
      proc {
        Cli.start [cmd]
      }.tap{|o|
        o.must_output /Wrong header level for \[req.1\]/
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
        o.must_output /Non-unique requirements identifiers are found:/
        o.must_output /\[req.2\] in req.2.md, req.3.md/
      }
    end
  end

  it 'must check repo for wrong child_order attribute' do
    inside_sandbox do
      inside_req do
        File.write('req.1.md', "# [r] r\n{{child_order: r1 r2}}")
      end
      proc {
        Cli.start [cmd]
      }.tap{|o|
        o.must_output /Wrong {{child_order}} values are found/
        o.must_output /\[r1, r2\] for \[r\]/
      }
    end
  end

end
