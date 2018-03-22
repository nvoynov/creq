require_relative '../test_helper'

describe Requirement do

  describe '#initialize' do

    it 'must accept #id, #title, #body as requirement attributes' do
      r = Requirement.new(id: :req, title: :requirement, body: "body")
      r.id.must_equal :req
      r.title.must_equal :requirement
      r.body.must_equal "body"
      r.items.size.must_equal 0
    end

    it 'must accept other parameters as attributes' do
      r = Requirement.new(id: :req, title: :requirement, body: "body", source: "nvoynov", parent: "f")
      r.attributes.size.must_equal 2
      r.attributes.key?(:id).must_equal false
      r.attributes.key?(:title).must_equal false
      r.attributes.key?(:body).must_equal false
      r.attributes[:source].must_equal "nvoynov"
      r.attributes[:parent].must_equal "f"
    end

  end

  describe '#id' do

    let(:requirement_tree) {
      r = Requirement.new(id: "r")
      r << Requirement.new(id: "r.1")
      r << Requirement.new(id: ".2")
      r
    }

    let(:first_with_dot) { Requirement.new(id: ".r") }

    it 'must ignore dot in root requirement' do
      first_with_dot.id.must_equal ".r"
    end

    it 'must return #id when it does not start wiht dot' do
      requirement_tree.items.first.id.must_equal 'r.1'
    end

    it 'must return #parent.id + #id when it starts from dot' do
      requirement_tree.items.last.id.must_equal 'r.2'
    end

  end

  describe '#attributes' do

    let(:req) {Requirement.new(
      source: "nvoynov", parent: "f", skip_meta: true, order_index: "1 2")}

    it 'must access to all attributes' do
      req.attributes.size.must_equal 4
      req[:source].must_equal "nvoynov"
      req[:parent].must_equal "f"
      req[:skip_meta].must_equal true
      req[:order_index].must_equal "1 2"
    end

    it 'must provide seprated #system_attributes' do
      req.system_attributes.size.must_equal 3
    end

    it 'must provide seprated #user_attributes' do
      req.user_attributes.size.must_equal 1
    end

  end

  def create_tree
    r = Requirement.new(id: "r")
    r << Requirement.new(id: "r.2")
    r << Requirement.new(id: "r.1")
    r << Requirement.new(id: "r.3")
    r
  end

  describe '#items' do

    before do
      @req = create_tree
    end

    it 'must return @items unless order_index is not defined' do
      r1, r2, r3 = @req.item("r.1"), @req.item("r.2"), @req.item("r.3")
      @req.items.must_equal [r2, r1, r3]
    end

    it 'must return ordered @item by :order_index attribute' do
      r1, r2, r3 = @req.item("r.1"), @req.item("r.2"), @req.item("r.3")
      @req[:order_index] = "r.1 r.2 r.3"
      @req.items.must_equal [r1, r2, r3]

      @req[:order_index] = "r.3 r.1 r.2"
      @req.items.must_equal [r3, r1, r2]
    end

    it 'must return partially ordered @item if order_index < @items' do
      r1, r2, r3 = @req.item("r.1"), @req.item("r.2"), @req.item("r.3")
      @req[:order_index] = "r.3"
      @req.items.must_equal [r3, r2, r1]
    end

    it 'must ingnore wrong order_index ids' do
      r1, r2, r3 = @req.item("r.1"), @req.item("r.2"), @req.item("r.3")
      @req[:order_index] = "r.3 wrong.1 wrong.2"
      @req.items.must_equal [r3, r2, r1]
    end

  end

  describe '#each' do
    before do
      @req = create_tree
    end

    it 'must traverse tree by orignial order unless :sort_order defined' do
      original = [@req, @req.items[0], @req.items[1], @req.items[2]]
      @req.inject([], :<<).must_equal original
    end

    it 'must traverse according to :sort_order' do
      ordered = [@req, @req.item("r.1"), @req.item("r.2"), @req.item("r.3")]
      @req[:order_index] = "r.1 r.2 r.3"
      @req.inject([], :<<).must_equal ordered
    end
  end

  describe '#links' do
    it 'must return all uniq links from body' do
      Requirement.new(id: 'id', body: '[[ur]] [[ur.1]]')
        .links.must_equal ['ur', 'ur.1']
      Requirement.new(id: 'id').links.must_equal []
    end
  end

end
