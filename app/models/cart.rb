class Cart
  attr_accessor :items, :tax_rate

  def initialize shopper, opts={}
    @shopper = shopper
    @tax_rate = 0.04
    # Take all the item ids and make them keys in a hash, then do a lookup for each of those keys as item_ids
    if opts[:item_ids]
      id_to_item = {}
      # array of of 3 unique items
      items = Item.find(opts[:item_ids])
      # hash for eadh of those item ids to the item objects
      # id_to_item = Hash[ items.map { |item| [item.id, item] } ]
      items.each { |item| id_to_item[item.id] = item }
      # each of the items in the deduplicated array and map it to an item
      @items = opts[:item_ids].map { |id| id_to_item[id] }
    else
      @items = []
    end
  end


  def add item
    @items << item
  end

  def subtotal
    @items.map{ |item| item.price }.reduce(:+) || 0
  end

  def total
    (subtotal * (1 + @tax_rate)).to_f.round(2)
  end

  def checkout!
    invoice = Invoice.new(user: @shopper, amount: self.total)
    invoice.save!
    invoice
  end

end