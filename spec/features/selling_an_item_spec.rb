require 'rails_helper'

feature 'Selling' do
  before :each do
    @shopper = create :user,:shopper
    @seller = create :user,:seller
  end

  it 'allows sellers to list items for sale' do
    login @seller
    visit new_item_path
    within('form') do
      fill_in "Title", with: 'guitar'
      fill_in 'Description', with: 'really cool'
      fill_in 'Price', with: 100
    end
    click_button 'Submit'
    expect(page).to have_content 'Listing successfully created'
    expect(page).to have_content 'guitar'
    expect(page).to have_content 'really cool'
    expect(page).to have_content '100'
  end

  it 'allows sellers to edit their listings', :js do
    login @seller
    visit new_item_path
    within('form') do
      fill_in "Title", with: 'guitar'
      fill_in 'Description', with: 'really cool'
      fill_in 'Price', with: 100
    end
    click_on 'Submit'
    visit item_path(id: Item.where(title: 'guitar')[0].id)
    click_on 'Edit Listing'
    within('form') do
      fill_in "Title", with: 'guitar (prs)'
      fill_in 'Description', with: 'really super cool'
      fill_in 'Price', with: 1750
    end
    click_on 'Submit'
    expect(page).to have_content 'Listing successfully updated'
    expect(page).to have_content 'guitar (prs)'
    expect(page).to have_content 'really super cool'
    expect(page).to have_content '1750'
  end

  it 'requires users to be sellers before listing an item' do
    login @shopper
    visit new_item_path
    expect( page ).to have_content 'not authorized'
  end

  describe "when using coupons", :js do
    before :each do
      login @seller
    end
    it "allows sellers to see their coupons" do
      @coupon = @seller.coupons.create! code: "abcde", discount: 10, status: true
      visit coupons_path
      expect(page).to have_content( @coupon.code )
      expect(page).to have_content( @coupon.discount )
    end

    it "allows sellers to add a coupon" do
      visit coupons_path
      click_on "New Coupon"
      fill_in "couponCode", with: "abcde"
      fill_in "discountPercentage", with: 10
      click_on "Create Coupon"
      expect(page).to have_text "abcde"
      expect(page).to have_text 10
      expect(page).to have_content "Set Inactive"
    end

    it "allows sellers to remove a coupon"

    it "allows sellers to toggle their coupon status" do
      @seller.coupons.create( code: "zzzzz", discount: 20, status: true )
      visit coupons_path
      expect(page).to have_content "Set Inactive"
      click_on "Set Inactive"
      expect(page).to have_content "Active"
      expect(page).to have_content "Set Active"
    end
  end

end
