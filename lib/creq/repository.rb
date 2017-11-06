# encoding: UTF-8
require_relative 'requirement'
require_relative 'reader'

module Creq

  class Repository < Requirement

    def self.load(repo = Reader.read_repo)
      repository = new
      repository.load(repo)
      repository
    end

    def initialize
      super({id: 'root'})
      @reqfs = {} # requirements file map {req_id, [file_name]}
      @links = {} # link requirements map {link, [req_id]}
    end

    def load(repo)
      repo.each do |file, v|
        v[:reqary].tap do |reqs|
          @items.concat(reqs)
          flat = reqs.inject([]){|a, r| a << r.inject([], :<<)}.flatten
          store_files(flat, file)
          store_links(flat)
        end
      end
      subordinate!
      generate_missing_ids
    end

    def generate_missing_ids
      # if some requirements have no id they must be generated XX, XX.YY, XX.YY.ZZZ
      counter = {}
      select{|r| r.id.nil?}.each do |r|
        index = counter[r.parent_id] || 1
        counter[r.parent_id] = index + 1
        id = index.to_s.rjust(2, "0")
        id = '.' + id if r.parent
        r.id = id
      end
    end

    def subordinate!
      @items.select{|r| r[:parent] && r.parent == nil}.each{|r|
        parent = find(r[:parent])
        next unless parent # TODO or show a error?
        parent << r
        @items.delete(r)
      }
    end

    def store_files(reqary, file)
      reqary.map(&:id).each{|id|
        @reqfs[id]? @reqfs[id] << file : @reqfs[id] = [file]
      }
    end

    def store_links(reqary)
      reqary.each{|r|
        r.links.each{|lnk|
          @links[lnk]? @links[lnk] << r.id : @links[lnk] = [r.id]
        }
      }
    end

    def duplicate_ids
      dup = []
      inject([], :<<)
        .tap{|r| r.delete_at(0)}
        .map(&:id)
        .tap{|r| dup = r.select{|id| r.count(id) > 1}.uniq}

      dup.inject([]) do |err, id|
        err << "[#{id}] in #{@reqfs[id].join(', ')}"
      end
    end

    def wrong_links
      idents = inject([], :<<).tap{|r| r.delete_at(0)}.map(&:id).uniq
      @links.each_with_object([]) do |(lnk, req), err|
        next if idents.include?(lnk)
        err << "[[#{lnk}]] in #{req.map{|r| "[#{r}]"}.join(', ')}"
      end
    end

    def wrong_parents
      reqs = inject([], :<<).tap{|r| r.delete_at(0)}
          .select{|r| r[:parent] && r.parent == nil}

      reqs.inject([]) do |err, r|
        err << "[#{r[:parent]}] for [#{r.id}] in #{@reqfs[r.id].join(', ')}"
      end
    end

    # TODO separated Checker class?
    def wrong_child_order
      msg = "[%s] for [%s] don't exist"
      err = []
      @items.select{|r| r[:child_order] }.each do |r|
        childs = r[:child_order].split(/ /)
        wrongs = childs.select{|c| r.item(c).nil? }
        err << msg % [wrongs.join(', '), r.id] unless wrongs.empty?
      end
      err
    end

  end

end
