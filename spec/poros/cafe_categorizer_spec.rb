require 'rails_helper'

RSpec.describe CafeCategorizer do
  before(:each) do
    @cafe1 = StreetCafe.create!(name: 'All Bar Most Chairs', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 5BN', number_of_chairs: 140)
    @cafe2 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 16)
    @cafe3 = StreetCafe.create!(name: 'BHS', street_address: '49 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 6)
    @cafe4 = StreetCafe.create!(name: 'Hotel Chocolat', street_address: '55 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 12)
    @cafe5 = StreetCafe.create!(name: 'Cattle Grid', street_address: "Waterloo House, Assembly Street", post_code: 'LS2 7DB', number_of_chairs: 20)
    @cafe6 = StreetCafe.create!(name: 'Chilli White', street_address: 'Assembly Street', post_code: 'LS2 7DA', number_of_chairs: 51)
    @cafe7 = StreetCafe.create!(name: 'Safran', street_address: '81 Kirkgate', post_code: 'LS2 7DJ', number_of_chairs: 6)
    @cafe8 = StreetCafe.create!(name: 'Sandinista', street_address: '5 Cross Belgrave Street', post_code: 'LS2 8JP', number_of_chairs: 18)
    @cafe9 = StreetCafe.create!(name: 'Tiger Tiger', street_address: '117 Albion St', post_code: 'LS2 8DY', number_of_chairs: 118)
    @cafe10 = StreetCafe.create!(name: 'The Wrens Hotel', street_address: '61A New Briggate', post_code: 'LS2 8DY', number_of_chairs: 20)
    @cafe11 = StreetCafe.create!(name: 'The Adelphi', street_address: '3 - 5 Hunslet Road', post_code: 'LS10 1JQ', number_of_chairs: 35)
  end

  it 'can categorize cafes with LS1 prefix in small category' do
    CafeCategorizer.categorize(@cafe3)
    cafe = StreetCafe.find_by(name: 'BHS')
    expect(cafe.category).to eq('ls1 small')
  end

  it 'can categorize cafes with LS1 prefix in medium category' do
    CafeCategorizer.categorize(@cafe4)
    cafe = StreetCafe.find_by(name: 'Hotel Chocolat')
    expect(cafe.category).to eq('ls1 medium')
  end

  it 'can categorize cafes with LS1 prefix in large category' do
    CafeCategorizer.categorize(@cafe1)
    cafe = StreetCafe.find_by(name: 'All Bar Most Chairs')
    expect(cafe.category).to eq('ls1 large')
  end

  it 'can categorize cafes with LS2 prefix in small category' do
    CafeCategorizer.categorize(@cafe7)
    cafe = StreetCafe.find_by(name: 'Safran')
    expect(cafe.category).to eq('ls2 small')
  end
  
  it 'can categorize cafes with LS2 prefix in large category' do
    CafeCategorizer.categorize(@cafe9)
    cafe = StreetCafe.find_by(name: 'Tiger Tiger')
    expect(cafe.category).to eq('ls2 large')
  end

  it 'can categorize cafes in the other category' do
    CafeCategorizer.categorize(@cafe11)
    cafe = StreetCafe.find_by(name: 'The Adelphi')
    expect(cafe.category).to eq('other')
  end
end