require 'rails_helper'

RSpec.describe 'When visiting the post code index page', type: :feature do
  before(:each) do
    @cafe1 = StreetCafe.create!(name: 'All Bar One', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 20)
    @cafe2 = StreetCafe.create!(name: 'All Bar Most Chairs', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 5BN', number_of_chairs: 140)
    @cafe3 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 20)
    @cafe4 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 16)
    @cafe5 = StreetCafe.create!(name: 'Caffé Nero (MOST CHAIRS)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 22)
    @cafe6 = StreetCafe.create!(name: 'BHS', street_address: '49 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 6)
    @cafe7 = StreetCafe.create!(name: 'Hotel Chocolat', street_address: '55 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 12)

    total_chairs = StreetCafe.all.sum(:number_of_chairs)
    post_code_chairs = StreetCafe.group(:post_code).sum(:number_of_chairs)
    @ls15bn_percent = (((post_code_chairs["LS1 5BN"].to_f) / total_chairs ) * 100).round(2)
    visit '/post_codes'
  end

  it 'it displays the post code sql view data' do
    expect(page).to have_content('Caffé Nero (MOST CHAIRS)')
    expect(page).to have_content('All Bar Most Chairs')
    expect(page).to have_content('Hotel Chocolat')
    expect(page).to have_content('160')
    expect(page).to have_content(@ls15bn_percent)
  end
end
