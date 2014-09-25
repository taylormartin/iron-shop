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
    expect(page).to have_content 'You are not authorized to list items!'
  end

end
