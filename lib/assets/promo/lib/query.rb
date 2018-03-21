require 'forwardable'

class TreeNode
  include Enumerable
  extend Forwardable

  attr_reader :id
  attr_reader :parent
  attr_reader :items

  def_delegators :@items, :size, :first, :last, :empty?

  def initialize(id)
    @id = id
    @items = []
  end

  def <<(n)
    n.parent = self
    @items << n
    n
  end

  def each(&block)
    # return unless block_given?
    yield(self)
    @items.each { |n| n.each(&block) }
  end

  def to_s
    tmp = items.empty? ? '' : items.map(&:id).join(', ')
    tmp = ", items: [#{tmp}]" unless tmp.empty?
    "<node id: #{id}#{tmp}>"
    # "[#{id}]"
  end

  def inspect
    to_s
  end

  # @param [String] query String
  # @return [Array<TreeNode>] query result
  def query(query_str)
    bck = Proc.new {|r| eval(query_str)}
    res = select{|n| bck.call(n) }
    del = select{|n| !bck.call(n)}
          .inject([]){|ary, n| ary << n.inject([], :<<)}
          .flatten
    res.select{|n| !del.include?(n)}
  rescue => e
    puts "query error: #{e.message}"
    puts "valid query examples are:"
    puts "   r.id == 'req.id'"
    puts "   ['r1', 'r2'].include?(r.id)"
    puts "   ['r1', 'r2'].include?(r.id) && r[:author] == 'john doe'"
    return []
  end

  protected

  def parent=(node)
    @parent = parent
  end
end

require 'pp'
tree = TreeNode.new('root').tap do |r|
  r << TreeNode.new('r1')
  r << TreeNode.new('r2')
  r << TreeNode.new('r3')
  r.first << TreeNode.new('r1.1')
  r.first << TreeNode.new('r1.2')
  r.first << TreeNode.new('r1.3')
  r.last  << TreeNode.new('r3.1')
  r.last  << TreeNode.new('r3.2')
  r.last  << TreeNode.new('r3.3')
end

query = "['r1', 'r2'].include?(r.id) || !['r1.1', 'r3'].include?(r.id)"
pp query
pp tree.query(query).map(&:id)
