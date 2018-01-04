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
    def_delegators :@items, :size, :first, :last, :empty?

    def initialize(options = {})
      super()
      @id = options[:id]
      @title = options[:title] || ''
      @body  = options[:body]  || ''
      @attributes = options
        .select{|k, _| ![:id, :title, :body].include?(k)}
    end

    def system_attributes
      @attributes.select{|k, _| SYSTEM_ATTRS.include?(k)}
    end

    def user_attributes
      @attributes.select{|k, _| !SYSTEM_ATTRS.include?(k)}
    end

    def id
      @id.to_s.start_with?('.') && @parent ? @parent.id + @id : @id
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

    # @return @items according to order in child_order attribute
    def items
      return @items if @items.empty? || @attributes[:child_order].nil?

      source = Array.new(@items)
      order = @attributes[:child_order]
      [].tap do |ordered|
        order.split(/ /).each do |o|
          e = source.delete(item(o))
          ordered << e if e
        end
        ordered.concat(source)
      end
    end

    def each(&block)
      return unless block_given?
      yield(self)
      items.each { |node| node.each(&block) }
    end

    SYSTEM_ATTRS = [:parent, :requirement, :suppress_id, :child_order]

    protected

      # protected to prevent assigning outside of Requirement
      def id=(id)
        @id = id
      end

  end

end
