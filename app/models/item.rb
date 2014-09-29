class Item < ActiveRecord::Base
  belongs_to :seller, class: User
  has_many :coupons, through: :seller
  has_many :invoiceitems
  has_many :invoices, through: :invoiceitems

  validates_presence_of :price, :seller, :title
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  include PgSearch
  multisearchable :against => [:title, :description]

end
