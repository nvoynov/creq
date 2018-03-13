# encoding: UTF-8

require_relative '../test_helper'

class SpecReader < Reader
  def self.call(enum)
    r = new("SpecReader")
    r.read(enum)
  end
end

describe Repository do
  let(:contents) {
    StringIO.new %(# [ur] User
## [us] User Stories
## [uc] Use Cases
# [fr] Func
# [if] Interface
# [nf] Non-func
)
  }

  let(:stories) {
    StringIO.new %(# [us.actor] Actor
{{parent: us}}
## [us.actor.1] Actor User Storiy 1
## [us.actor.2] Actor User Storiy 2
)
  }

  let(:funcs) {
    StringIO.new %(# [fr.1] Func 1
{{parent: fr}}
## [fr.1.1] Func 1 1
## [fr.1.2] Func 1 2
)
  }

  def build_repo
    {}.tap do |repo|
      {contents: contents, stories: stories, funcs: funcs}.each do |k, v|
        req = SpecReader.(v.each_line)
        repo[k.to_s + '.md'] = req
      end
    end
  end

  def build_stringIO_repo(strings)
    req = SpecReader.(strings.each_line)
    { 'stringIO' => req }
  end

  def debug_print(repo)
    repo.each{|r| puts "#{' '*r.level} [#{r.id}] #{r.title}"}
  end

  describe '#generate_missing_ids' do
    let(:contents) {
      StringIO.new %(# [h1] first header
## [h1.1] first sub header
## [h1.2] second sub header
## third sub header
### third level header
# second header
)
    }

    it 'must aute generate ids when it not provided' do
      repo = Repository.(build_stringIO_repo(contents))
      repo.first.id.must_equal 'h1'
      repo.first.last.id.must_equal 'h1.01'
      repo.first.last.title.must_equal 'third sub header'
      repo.last.id.must_equal '01'
    end
  end

  describe 'self#load' do
    it 'must load all requirements in Repository' do
      repo = Repository.(build_repo)
      repo.must_be_kind_of Repository
      repo.size.must_equal 4
      repo.find('us.actor').size.must_equal 2
      repo.find('fr.1').size.must_equal 2
    end
  end

  describe '#duplicate_ids' do
    it 'must return [] if errors does not found' do
      repo = Repository.(build_repo)
      repo.duplicate_ids.must_equal []
    end

    it 'must return [errors] if errors are found' do
      payload = build_repo
      with_errors = StringIO.new %(# [fr.2] Func 2
{{parent: fr}}
## [fr.2.1] Func 2 1
## [fr.1.2] Func 2 2
)
      req = SpecReader.(with_errors.each_line)
      payload['errors.md'] = req
      repo = Repository.(payload)
      repo.duplicate_ids.must_equal  ["[fr.1.2] in funcs.md, errors.md"]
    end
  end

  describe '#expand_links' do
    content = StringIO.new %(# [f] functional
## [.c1] component 1

component items:

* [[.f]];
* [[.e]].

### [.f] functions

component functions:

* [[.f1]];
* [[.f2]].

#### [.f1] func 1

Accroding to [[*f]]

* Create [[*e1]].
* Call [[f2]].

#### [.f2] func 2
### [.e] entities
#### [.e1] entity 1
#### [.e2] entity 2
## [.c2] component 2
)
    repo = Repository.({'content.md' => SpecReader.(content.each_line)})

    repo.find('f.c1').body do |body|
      body.must_match Regexp.escape('Accroding to [[f]]')
      body.must_match Regexp.escape('* [[f.c1.f]]')
      body.must_match Regexp.escape('* [[f.c1.e]]')
    end

    repo.find('f.c1.f.f1').body do |body|
      body.must_match Regexp.escape('* Create [[f.c1.e.e1]]')
      body.must_match Regexp.escape('* Call [[f.c1.f.f2]]')
    end

  end

  describe '#wrong_parents' do

    it 'must return [] if errors does not found' do
      repo = Repository.(build_repo)
      repo.wrong_parents.must_equal []
    end

    it 'must return [errors] if errors are found' do
      payload = build_repo
      with_errors = StringIO.new %(# [fr.2] Func 2
{{parent: fr}}
## [fr.2.1] Func 2 1
## [fr.2.2] Func 2 2
# [f3] Func 3
{{parent: ff}}
# [f4] Func 4
{{parent: fm}}
)
      req = SpecReader.(with_errors.each_line)
      payload['errors.md'] = req
      repo = Repository.(payload)
      repo.wrong_parents.must_equal  [
        "[ff] for [f3] in errors.md",
        "[fm] for [f4] in errors.md"]
    end
  end

  describe '#wrong_links' do

    it 'must return [] if errors does not found' do
      repo = Repository.(build_repo)
      repo.wrong_links.must_equal []
    end

    it 'must return [errors] if errors are found' do
      payload = build_repo
      with_errors = StringIO.new %(# [fr.2] Func 2
{{parent: fr}}
I have a right link [[fr]]
## [fr.2.1] Func 2 1
I have a wrong link [[fm]]
## [fr.2.2] Func 2 2
I also have a [[fa]] - wrong link
## [fr.2.3] Func 2 3
[[fb]] is also wrong
)
      req = SpecReader.(with_errors.each_line)
      payload['errors.md'] = req
      repo = Repository.(payload)
      repo.wrong_links.must_equal  [
        "[[fm]] in [fr.2.1]",
        "[[fa]] in [fr.2.2]",
        "[[fb]] in [fr.2.3]"]
    end
  end

  # TODO refactor test by get_repo_from
  def get_repo_from(txt)
    req = SpecReader.(StringIO.new(txt).each_line)
    Repository.({ 'get_repo_from.md' => req })
  end

  describe '#wrong_child_order' do

    it 'must return [] if errors does not found' do
      content = %(# [w] Func W
{{child_order: w1 w2}}
I have right child_order
## [w1] w1
## [w2] w2
)
      repo = get_repo_from(content)
      repo.wrong_child_order.must_equal []
    end

    it 'must return [errors] if errors are found' do
      content = %(# [w] Func W
{{child_order: w1 w2}}
I have wrong child_order attribute with w1 and w2
)
      repo = get_repo_from(content)
      repo.wrong_child_order.must_equal ["[w1, w2] for [w]"]

      content = %(# [w] Func W
{{child_order: w1 w2}}
I have wrong child_order attribute with w1
## [w2] w2
)
      repo = get_repo_from(content)
      repo.wrong_child_order.must_equal ["[w1] for [w]"]
    end
  end

end
