require 'rails_helper'

describe CouponsController do
  before :each do
    @request.env["devise-mapping"] = Devise.mappings[:user]
  end

  shared_examples_for "another user's coupon" do
    before :each do
      @user_other = create :user, :seller
      @coupon = create_coupon(@user_other)
    end
    it "does not let the user update the coupon" do
      put :update, id: @coupon.id, code: "aaaaa", discount: 20, status: false
      @coupon.reload
      expect( @coupon.code ).not_to eq "aaaaa"
      expect( @coupon.discount ).not_to eq 20
      expect( @coupon.status ).not_to eq false
    end
    it "does not let you destroy someone else's coupon" do
      delete :destroy, id: @coupon.id
      expect( @coupon.reload ).to eq @coupon
    end
  end

  describe "as a non-seller" do
    before :each do
      @user = create :user
      sign_in @user
    end
    it "does not allow you to create a coupon" do
      post :create, code: "abcde", discount: 10, status: true
      expect( @user.coupons.count ).to eq 0
    end
    it_behaves_like "another user's coupon"
  end

  describe "as a seller" do
    before :each do
      @user = create :user, :seller
      sign_in @user
    end
    it "lets you create a coupon" do
      post :create, code: "abcde", discount: 10
      expect( @user.coupons.count ).to eq 1
      expect( @user.coupons.first.code ).to eq "abcde"
      expect( @user.coupons.first.discount ).to eq 10
      expect( @user.coupons.first.status ).to eq true
    end

    describe "with an existing coupon" do
      before :each do
        @coupon = create_coupon
      end

      it "lets you edit a coupon" do
        put :update, id: @coupon.id, code: "aaaaa", discount: 20, status: false
        @coupon.reload
        expect( @coupon.code ).to eq "aaaaa"
        expect( @coupon.discount ).to eq 20
        expect( @coupon.status ).to eq false
      end

      it "lets you delete your coupon" do
        delete :destroy, id: @coupon.id
        expect { @coupon.reload }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
    it_behaves_like "another user's coupon"
  end

  def create_coupon(user = nil)
    user ||= @user
    user.coupons.create!(code: "abcde", discount: 10, status: true)
  end
end