class Coupon < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :code, :discount
  validates_inclusion_of :status, :in => [true, false]
  validates_uniqueness_of :code
end
