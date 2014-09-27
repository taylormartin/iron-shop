require 'rails_helper'

describe Coupon do
  %i{user code status discount}.each do |field|
    it "requires a #{field}" do
      coupon = build :coupon, field => nil
      expect(coupon).not_to be_valid
    end
  end

end