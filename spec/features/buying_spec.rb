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

  xit 'lets buyers search for items' do
    item_1 = create :item
    item_2 = create :item
    visit root_path
    #get search controller method via ajax for item_1.title
    expect( page ).to have_content item_1.title
    expect( page ).to_not have_content item_2.title
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
 end
end
