class Cart
  attr_accessor :items, :tax_rate, :coupons

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

    if opts[:coupons]
      @coupons = opts[:coupons].map { |code| Coupon.find code }
    else
      @coupons = []
    end
  end

  def add item
    @items << item
  end

  def subtotal
    @items.map{ |item| item.price }.reduce(:+) || 0
  end

  def discount
    total_discount = 0
    @items.each do |item|
      if (@coupons & item.coupons).length == 1
        matching = @coupons & item.coupons
        total_discount += matching[0].discount.to_f * item.price / 100
      end
    end
    total_discount
  end

  def total
    ((subtotal - discount)* (1 + @tax_rate)).to_f.round(2)
  end

  def checkout!
    invoice = Invoice.new(user: @shopper, amount: self.total)
    invoice.save!
    invoice
  end

  def valid_coupon? coupon
    return false if taken_sellers.include?(coupon.user)
    @items.each do |item|
      return true if item.coupons.include? coupon
    end
    return false
  end

  def taken_sellers
    @coupons.map { |coupon| coupon.user }
  end

  def codes_applied
    @coupons.map do |coupon|
      coupon.code
    end
  end
end