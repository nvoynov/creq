# encoding: UTF-8

require_relative '../test_helper'

describe "creq doc" do
  let(:content) {
%q(# [u] user
## [us] us
### [us1] us1
### [us2] us2
## [uc] uc
### [uc1] uc1
### [uc2] uc2
# [f] func
## [cmp1] cmp1
### [cmp1.f1] f1
### [cmp1.f2] f2
## [cmp2] cmp2
) }

  it 'must print toc' do
    skip() # TODO how to check output of Thor Cli.start?
    inside_sandbox do
      inside_src { File.write('req.md', content) }
      Cli.start(["toc", "--skipid='cmp1'"])
    end
  end

end
