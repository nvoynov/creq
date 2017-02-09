# encoding: UTF-8
require_relative 'requirement'
require_relative 'reader'

module Creq

  class Loader
    extend Creq::Reader

    attr_reader :root

    def self.load(repo = read_directory)
      loader = new(repo)
      loader
    end

    # @return [Hash<ID, Array<Files>] non-uniq requirements ids and corresponded files
    def nonuniq_ids
      ids = idents_array
      ids.select{|id| ids.count(id) > 1}.uniq
        .inject({}){|h, i| h.merge!(i => @reqs_repo[i])}
    end

    # @return [Hash<Link, Hash<Array<Ids>Array<Files>>] links and corresponded files
    # FIXME erros with deeper than 2 levels hierarhy
    def wrong_links
      @link_repo
        .select{|k, v| !@reqs_repo.keys.include?(k)}
        .inject({}){|h, (l, ids)|
           src = ids.inject([], :<<).flatten
             .map{|r| @reqs_repo[r]}.flatten
             .uniq
          h.merge!(l => {requirements: ids, files: src})
        }
    end

    # @return [Array<RequirementID>] of requirement with wrong parents
    def wrong_parents
      @root.inject([], :<<)
        .select{|r| r[:parent] && r.parent == @root}
    end

    protected

    def initialize(repo)
      @repo = repo
      @reqs_repo = build_reqs_repo
      @link_repo = build_link_repo
      @root = Requirement.new(id: 0)
      @repo.values.inject([], :<<).flatten.each{|r| @root << r}
      fix_subordination!
    end

    # @param repo[Hash<FileName, Array<Requirement>>]
    # @return [Hash<RequirementId, Array<FileName>>]
    def build_reqs_repo
      @repo.each_with_object({}) do |(k, v), h|
        v.inject([]){|a, r| a << r.inject([], :<<)}
          .flatten
          .map(&:id)
          .each do |id|
            if h[id]
              h[id] << k
            else
              h[id] = [k]
            end
          end
      end
    end

    # @param repo[Hash<FileName, Array<Requirement>>]
    # @return [Hash<Link, Array<RequirementId>>]
    def build_link_repo
      @repo.values.each_with_object({}) do |ra, h|
        ra.inject([]){|a, r| a << r.inject([], :<<)}
        .flatten
        .each do |r|
          r.links.each do |l|
            if h[l]
              h[l] << r.id
            else
              h[l] = [r.id]
            end
          end
        end
      end
    end

    # @param repo[Hash<FileName, Array<Requirement>>]
    # @return [Array<RequirementId>]
    def idents_array
      @repo.each_with_object([]) do |(k, v), h|
        v.inject([]){|a, r| a << r.inject([], :<<)}
          .flatten
          .map(&:id)
          .each{|id| h << id}
      end
    end

    def fix_subordination!
      @root.inject([], :<<)
        .select{|r| r[:parent] && r.parent == @root}
        .each{|r|
          parent = @root.find(r[:parent])
          next unless parent
          parent << r
          @root.items.delete(r)
        }
    end

  end

end
