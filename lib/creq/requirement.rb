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

    # @param [String] requirement id; if the parameter contains the `.` prefix, it will search requirement.id.end_with?(id)
    # @return [Requirement] when id found or nil if did not
    def item(id)
      @items.each{|r| return r if r.id.end_with? id[1..-1]} if id.start_with? '.'
      @items.each{|r| return r if r.id.eql? id}
      nil
    end

    # @param [String] requirement id; if the parameter contains the `*` prefix, it will search requirement.id.end_with?(id)
    # @return [Requirement] when id found or nil if did not
    def find(id)
      each{|r| return r if r.id.end_with? id[1..-1]} if id.start_with? '*'
      each{|r| return r if r.id.eql? id}
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
