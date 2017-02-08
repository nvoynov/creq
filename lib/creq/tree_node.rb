# encoding: UTF-8

module Creq

  class TreeNode
    include Enumerable

    attr_reader :items
    attr_reader :parent

    def initialize
      @items = []
      @parent = nil
    end

    def <<(node)
      node.parent = self
      @items << node
      node
    end

    def each(&block)
      return unless block_given?
      yield(self)
      @items.each { |node| node.each(&block) }
    end

    def level
      return 1 if @parent.nil?
      @parent.level + 1
    end

    def root?
      @parent.nil?
    end

    def root
      pa = self
      pa = pa.parent while pa.parent
      pa
    end

    protected

      def parent=(node)
        @parent = node
      end
  end
end
