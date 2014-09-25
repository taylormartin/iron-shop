require 'rails_helper'

describe InvoicesController, :js do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create :user
    sign_in @user

    2.times do
      create :item
    end

  end
  it "creates an invoice on checkout" do
    session[:cart] = [1,2]
    post :create
    expect( Invoice.count ).to eq 1
    expect( session[:cart] ).to eq []
    expect( Invoice.first.items.to_a ).to include Item.find 1
    expect( Invoice.first.items.to_a ).to include Item.find 2
    expect( response ).to redirect_to invoice_path(Invoice.last)
    expect( flash[:notice]).to match(/^Successfully checked out/)
  end
  it "takes a valid payment to close an invoice"
  it "notifies on invalid payment"
end