require_relative '../test_helper'

describe TreeNode do

  it 'must initialize with empty items' do
    TreeNode.new.items.empty?.must_equal true
  end

  def create_tree
    root = TreeNode.new
    root << TreeNode.new
    root << TreeNode.new
    root
  end

  it 'must add child nodes by #<<' do
    root = create_tree
    root.items.size.must_equal 2
    root.items.first.parent.must_equal root
    root.items.last.parent.must_equal root
    root.parent.must_be_nil
  end

  it 'must respond to #root?' do
    root = create_tree
    root.root?.must_equal true
    root.items.first.root?.must_equal false
  end

  it 'must respond to #root' do
    root = create_tree
    root.root.must_equal root
    root.first.root.must_equal root
    n = root.items.last << TreeNode.new
    n.root.must_equal root
  end

  it 'must respond to #level' do
    root = create_tree
    root.level.must_equal 1
    root.items.first.level.must_equal 2
    root.items.last.level.must_equal 2
  end

  it 'must provide Enumerable#each' do
    root = create_tree
    tree_nodes = [root, root.items.first, root.items.last]
    visited = root.inject([]){|ary, n| ary << n}
    visited.must_equal tree_nodes
  end

end
