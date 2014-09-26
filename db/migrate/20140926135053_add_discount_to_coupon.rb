class AddDiscountToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :discount, :integer
  end
end
