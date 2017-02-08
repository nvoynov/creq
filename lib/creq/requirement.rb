# encoding: UTF-8
require 'forwardable'
require_relative 'tree_node'

module Creq

  class Requirement < TreeNode
    extend Forwardable

    attr_reader :id
    attr_reader :title
    attr_reader :body
    attr_reader :attributes

    def_delegators :@attributes, :[]=, :[]

    # TODO move this delegators to TreeNode?
    def_delegators :@items, :size, :first, :last

    def initialize(options = {})
      super()
      @id = options[:id]
      @title = options[:title] || ''
      @body  = options[:body]  || ''
      @attributes = options
        .select{|k, v| ![:id, :title, :body].include?(k)}
    end

    def system_attributes
      @attributes.select{|k, v| SYSTEM_ATTRS.include?(k)}
    end

    def user_attributes
      @attributes.select{|k, v| !SYSTEM_ATTRS.include?(k)}
    end

    def parent_id
      return @parent.id if @parent
      @attributes[:parent]
    end

    def item(item_id)
      @items.each{|i| return i if i.id.eql? item_id}
      nil
    end

    def find(node_id)
      each{|n| return n if n.id.eql? node_id}
      nil
    end

    # @return requirements links from body
    def links
      return [] if @body.empty?
      @body.scan(/\[\[([\w\.]*)\]\]/).flatten.uniq
    end

    # @return @items according to child_order attribute
    def items
      return @items if (@items.empty? || @attributes[:child_order].nil?)

      result = @attributes[:child_order].split(/ /)
        .inject([]){ |ary, id| ary << item(id) }
        .delete_if{ |i| i.nil? }

      if result.size != @items.size
        @items.each{|i| result << i unless result.include?(i)}
      end

      result
    end

    def each(&block)
      return unless block_given?
      yield(self)
      items.each { |node| node.each(&block) }
    end

    protected

      SYSTEM_ATTRS = [:parent, :suppress_id, :child_order]

  end

end
