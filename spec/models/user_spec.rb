require 'rails_helper'

describe User do
  it "can be a shopper" do
    user = create :user, :shopper
    expect( user.shopper? ).to eq true
  end

  it "can be a seller" do
    user = create :user, :seller
    expect( user.seller? ).to eq true
  end
  
  it "is a shopper by default" do
    user = create :user, role=nil
    expect( user.shopper? ).to eq true
  end
end
