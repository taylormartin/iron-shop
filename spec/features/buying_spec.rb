require 'rails_helper'

feature 'Buying' do
  before :each do
    @user = create :user
    login @user

    create :item
  end
 describe 'No Selenium' do
  it 'shows the user a list of all items by default' do
    item = create :item
    visit root_path
    expect( page ).to have_content item.title
  end

  it 'lets buyers search for items' do
    item_1 = create :item, title: "foo", description: "foo 1"
    item_2 = create :item, title: "bar", description: "bar 2"
    visit root_path
    within('form') do
      fill_in "search_input", with: item_1.title 
    end
    click_button "Search"
    #get search controller method via ajax for item_1.title
    expect( page ).to have_content item_1.title
    expect( page ).to_not have_content item_2.title
  end

  it 'lets buyers view more details about an item' do
    item_1 = create :item, title: "Show Test"
    visit root_path
    expect( page ).to have_content item_1.title
    click_link(item_1.title, match: :first)
    expect( page.current_path).to eq item_path(item_1)
    expect( page ).to have_content item_1.title
  end
  
 end

 describe 'Selenium', :js do
  it 'lets buyers add items to their cart' do
    visit cart_path
    expect(page).not_to have_css('.item')
    visit items_path
    click_link("Add to Cart", match: :first)
    expect(page).to have_css('.item')
  end

  it 'lets buyers view their cart' do
    visit items_path
    click_link("Add to Cart", match: :first)
    item = Item.first
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.description)
    expect(page).to have_content(item.price)
  end
  
  it 'lets buyers remove items from their cart' do
    visit items_path
    click_link("Add to Cart", match: :first)
    expect(page).to have_css('.item')
    find('.remove-button').click
    expect(page).not_to have_css('.item')
  end

  
  it 'lets buyers checkout' do
    visit items_path
    click_link("Add to Cart", match: :first)
    expect(page).to have_css('.item')
    find('.checkout').click
    expect(page).to have_text "Unpaid"
    expect(page).to have_content Item.first.title
    expect(page).to have_content Invoice.last.amount
  end
  describe "when using a coupon" do
    describe "with a valid coupon" do
      it 'discounts items from a seller based on a valid coupon'
      it 'does not discount items if the user has not items from that seller'
      it 'only discounts items from a seller when the cart has items from multiple sellers'
      it 'allows for multiple seller discounts from multiple sellers'
    end
    describe "when using an invalid coupon" do
      it 'allows users to remove a coupon code from checkout'
      it 'rejects the coupon if the coupon code never existed'
      it 'rejects the coupon for a code that has been marked as inactive'
    end
  end
 end
end
