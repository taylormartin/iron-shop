class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.shopper?
      can :create, Invoice, user_id: user.id
      can :show, Item
    elsif user.seller?
      can :crud, Coupon, user_id: user.id
      can :crud, Item, seller_id: user.id
      can :create, Invoice, user_id: user.id
    else
      raise "Can't check authorization info for unknown role (#{user.role})"
    end
  end
end
