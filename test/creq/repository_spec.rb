# encoding: UTF-8

require_relative '../test_helper'

class SpecFileReader < Reader
  def self.read_enumerator(enum)
    reader = new("enumerator")
    reader.read(enum)
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
        reqs, errs = SpecFileReader.read_enumerator(v.each_line)
        repo[k.to_s + '.md'] = {reqary: reqs, errary: errs}
      end
    end
  end

  def debug_print(repo)
    repo.each{|r| puts "#{' '*r.level} [#{r.id}] #{r.title}"}
  end

  describe 'self#load' do
    it 'must load all requirements in Repository' do
      repo = Repository.load(build_repo)
      repo.must_be_kind_of Repository
      repo.size.must_equal 4
      repo.find('us.actor').size.must_equal 2
      repo.find('fr.1').size.must_equal 2
    end
  end

  describe '#duplicate_ids' do
    it 'must return [] if errors does not found' do
      repo = Repository.load(build_repo)
      repo.duplicate_ids.must_equal []
    end

    it 'must return [errors] if errors are found' do
      payload = build_repo
      with_errors = StringIO.new %(# [fr.2] Func 2
{{parent: fr}}
## [fr.2.1] Func 2 1
## [fr.1.2] Func 2 2
)
      reqs, errs = SpecFileReader.read_enumerator(with_errors.each_line)
      payload['errors.md'] = {reqary: reqs, errary: errs}
      repo = Repository.load(payload)
      repo.duplicate_ids.must_equal  ["[fr.1.2] in funcs.md, errors.md"]
    end
  end

  describe '#wrong_parents' do

    it 'must return [] if errors does not found' do
      repo = Repository.load(build_repo)
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
      reqs, errs = SpecFileReader.read_enumerator(with_errors.each_line)
      payload['errors.md'] = {reqary: reqs, errary: errs}
      repo = Repository.load(payload)
      repo.wrong_parents.must_equal  [
        "[ff] for [f3] in errors.md",
        "[fm] for [f4] in errors.md"]
    end
  end

  describe '#wrong_links' do

    it 'must return [] if errors does not found' do
      repo = Repository.load(build_repo)
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
      reqs, errs = SpecFileReader.read_enumerator(with_errors.each_line)
      payload['errors.md'] = {reqary: reqs, errary: errs}
      repo = Repository.load(payload)
      repo.wrong_links.must_equal  [
        "[[fm]] in [fr.2.1]",
        "[[fa]] in [fr.2.2]",
        "[[fb]] in [fr.2.3]"]
    end
  end

  # TODO refactor test by get_repo_from
  def get_repo_from(txt)
    reqs, errs = SpecFileReader.read_enumerator(StringIO.new(txt).each_line)
    Repository.load({ 'get_repo_from.md' => {reqary: reqs, errary: errs}})
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
      repo.wrong_child_order.must_equal ["[w1, w2] for [w] don't exist"]

      content = %(# [w] Func W
{{child_order: w1 w2}}
I have wrong child_order attribute with w1
## [w2] w2
)
      repo = get_repo_from(content)
      repo.wrong_child_order.must_equal ["[w1] for [w] don't exist"]
    end
  end

end
