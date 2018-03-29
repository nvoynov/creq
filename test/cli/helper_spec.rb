# encoding: UTF-8

require_relative '../test_helper'

describe Helper do

  describe '#which' do

    let(:os) { RbConfig::CONFIG['host_os'] }
    let(:win) { os.match "mingw"}

    # win10 test, maybe UX
    it 'must return ruby.exe on win' do
      skip "skip not mingwXX" unless win
      which('ruby.exe').must_match "ruby"
    end

    it 'must return ruby on linux' do
      skip "skip not win" if win
      which('ruby').must_match "ruby"
    end

  end



  let(:content) {
%(# [ur] User
## [us] User Stories
## [uc] Use Cases
# [fr] Func
# [if] Interface
# [nf] Non-func
# [us.actor] Actor
## [us.actor.1] Actor User Storiy 1
## [us.actor.2] Actor User Storiy 2
# [fr.1] Func 1
## [fr.1.1] Func 1 1
## [fr.1.2] Func 1 2)
  }

  # TODO move the staff to helper
  let(:repo) {
    test_repo(content)
  }

  describe '#toc' do
    it 'must print toc' do
      inside_sandbox do
        inside_src { File.write('content.md', content) }

        proc { create_toc }.tap{|o|
          o.must_output /[ur] User/
          o.must_output /\[fr.1.2\] Func 1 2/
        }

        proc { create_toc("r.id == 'fr.1'") }.tap {|o|
          o.must_output /\[fr.1.1\] Func 1 1/
          o.must_output /\[fr.1.2\] Func 1 2/
        }

        proc { create_toc("r.id == 'not.exist'") }.tap {|o|
          o.must_output /Requirements not found!/
        }

      end

    end
  end
end
