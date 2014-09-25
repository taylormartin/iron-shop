class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :invoices
  has_many :items_for_sale, class: Item

  def shopper?
    self.role == nil || self.role.downcase == "shopper"
  end

  def seller?
    self.role.downcase == "seller"
  end
end
