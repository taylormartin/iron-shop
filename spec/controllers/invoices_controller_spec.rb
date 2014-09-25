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
  describe "when paying" do
    before :each do
      @invoice = create :invoice
      sign_in @invoice.user
    end
    it "takes a valid payment to close an invoice" do
      post :close, id: @invoice.id, stripeToken: CardProcessor.valid_token
      @invoice.reload

      expect( flash[:success] ).to eq "Your purchase went through"
      expect( @invoice.paid? ).to be true
    end
    it "notifies on invalid payment" do
      post :close, id: @invoice.id, stripeToken: CardProcessor.declined_token
      @invoice.reload

      expect( flash[:error] ).to eq "Couldn't process card"
      expect( @invoice.paid? ).to be false
    end
  end

end