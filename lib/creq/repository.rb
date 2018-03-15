# encoding: UTF-8
require_relative 'requirement'
require_relative 'reader'

def capture_stdout &block
  old_stdout = $stdout
  $stdout = StringIO.new
  block.call
  $stdout.string
ensure
  $stdout = old_stdout
end

module Creq

  class Repository < Requirement

    def self.call(repo = read_repo)
      r = new
      r.load(repo)
      r
    end

    def self.read_repo(repository = '**/*.md')
      {}.tap do |repo|
        Dir.glob(repository) do |f|
          print "Read file '#{f}' ... "
          reqs = nil
          output = capture_stdout { reqs = Reader.(f) }
          puts output.empty? ? "OK!" : "with errors\n#{output}"
          repo[f] = reqs
        end
      end
    end

    def initialize
      super({id: 'root'})
      @reqfs = {} # requirements file map {req_id, [file_name]}
      @links = {} # link requirements map {link, [req_id]}
    end

    def load(repo)
      repo.each do |file, req|
        req.items.each{|r| self << r}
        flat = req.inject([], :<<).tap{|r| r.delete_at(0)}.flatten
        store_files(flat, file)
        store_links(flat)
      end
      subordinate!
      expand_links!
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
      # clear parent for root.items, BUT WHY?
      @items.each{|r| r.parent = nil}

      @items.select{|r| r[:parent] && r.parent.nil?}.each{|r|
        parent = find(r[:parent])
        next unless parent # TODO or show a error?
        parent << r
        @items.delete(r)
      }
    end

    # TODO: separate out an extension like a LinkExtender, Subordinator, Checker, etc. provide an extension order setting?
    def expand_links!
      reqa = map(&:id).inject([], :<<)
      each do |req|
        req.links.each do |lnk|
          next if reqa.include?(lnk)

          if lnk.start_with?('..') # find in hierarchy
            par = req.parent
            exp = nil
            until exp || par.nil?
              exp = par.find(lnk)
              req.body.gsub!("[[#{lnk}]]", "[[#{exp.id}]]") if exp
              par = par.parent unless exp
            end
            # parent of root.items is nil, see #subordinate!, PUBLISHING?
            # that is why it needs search in root
            exp = find(lnk) unless exp
            req.body.gsub!("[[#{lnk}]]", "[[#{exp.id}]]") if exp
          end

          # Requirement item(id) vs find(id) .. add .
          exp = req.item(lnk) if lnk.start_with? '.'
          req.body.gsub!("[[#{lnk}]]", "[[#{exp.id}]]") if exp

          # find at the same level of hierarhy
          exp = req.parent.item('.' + lnk) if req.parent
          req.body.gsub!("[[#{lnk}]]", "[[#{exp.id}]]") if exp
        end
      end
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
          .select{|r| r[:parent] && r.parent.nil?}

      reqs.inject([]) do |err, r|
        err << "[#{r[:parent]}] for [#{r.id}] in #{@reqfs[r.id].join(', ')}"
      end
    end

    # TODO separated Checker class?
    def wrong_child_order
      msg = "[%s] for [%s]"
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
