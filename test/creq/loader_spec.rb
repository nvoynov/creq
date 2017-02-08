# encoding: UTF-8
require_relative '../test_helper'

describe Loader do

  describe 'self#load' do
    before do
      @repo = {
        'file_1.md' => [
            {id: 'ur'},
            {id: 'fr'},
            {id: 'ur.1', parent: 'ur'},
            {id: 'ur.2', parent: 'ur'},
            {id: 'fr.1', parent: 'fr'},
            {id: 'fr.2', parent: 'fr'}
          ].map{|r| Requirement.new(r)},
        'file_2.md' => [
            {id: 'ir'},
            {id: 'ir.1', parent: 'ir'},
            {id: 'ir.2', parent: 'ir'}
          ].map{|r| Requirement.new(r)}
      }
    end

    it 'must load repository' do
      loader = Loader.load(@repo)
      loader.root.tap do |d|
        d.items.size.must_equal 3
        d.item('ur').size.must_equal 2
        d.item('fr').size.must_equal 2
        d.item('ir').size.must_equal 2
      end
    end
  end

  describe '#nonuniq_ids' do
    before do
      # Hash<String, Array<Requirement>
      @repo = {
        file1: [:r1, :r2, :r3],
        file2: [:r3, :r4, :r5],
        file3: [:r5, :r6, :r7]
      }.inject({}) do |repo, (k, v)|
        repo.merge( {k => v.map{|r| Requirement.new(id: r)}.inject([], :<<) })
      end
    end

    it 'must return empty hash for empty repo' do
      Loader.load({}).nonuniq_ids.must_equal({})
    end

    it 'must return empty hash if errors not found' do
      @repo[:file1].delete(@repo[:file1].last)
      @repo[:file2].delete(@repo[:file2].last)
      loader = Loader.load(@repo)
      loader.nonuniq_ids.must_equal({})
    end

    it 'must return hash duplicate_id => [files]' do
      loader = Loader.load(@repo)
      loader.nonuniq_ids.must_equal({
        :r3 => [:file1, :file2],
        :r5 => [:file2, :file3]
      })
    end
  end

  describe '#wrong_parents' do
    before do
      @repo = {
        'file_1.md' => [
            {id: 'ur'},
            {id: 'ur.1', parent: 'ur'},
            {id: 'ur.2', parent: 'ur'}
          ].map{|r| Requirement.new(r)}
      }
    end

    it 'must place wrong_parents requirements to root' do
      Loader.load(@repo).tap do |l|
        l.root.size.must_equal 1
        l.root.item('ur').size.must_equal 2
      end

      @repo['file_2.md'] = [Requirement.new(id: 'nf.1', parent: 'nf')]
      Loader.load(@repo).tap do |l|
        l.root.size.must_equal 2
        l.root.item('nf.1').wont_be_nil
        l.wrong_parents.tap do |w|
          w.size.must_equal 1
          w.first.must_equal @repo['file_2.md'].first
        end
      end
    end
  end

  describe '#wrong_links' do
    before do
      @repo = {
        file1: [
          {id: 'ur'  },
          {id: 'ur.1'}
        ],
        file2: [
          {id: 'fr'  },
          {id: 'fr.1', body: '[[ur.1]]'}
        ]
      }.inject({}) do |repo, (k, v)|
        repo.merge({k => v.map{|i| Requirement.new(i)}})
      end
    end

    it 'must return empty hash for empty repo' do
      Loader.load({}).nonuniq_ids.must_equal({})
    end

    it 'must return empty hash when wrong links not found' do
      Loader.load(@repo).wrong_links.must_equal({})
    end

    it 'must return hash of wrong_links' do
      @repo[:file1] << Requirement.new({id: 'ur.2', body: '[[fr.9]]'})
      @repo[:file2].first << Requirement.new({id: 'fr.2', body: '[[ur.9]]'})

      Loader.load(@repo).tap do |l|
        l.wrong_links.must_equal({
          'fr.9' => {:requirements=>["ur.2"], :files=>[:file1]},
          'ur.9' => {:requirements=>["fr.2"], :files=>[:file2]}
        })
      end
    end
  end
end
