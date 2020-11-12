require 'rails_helper'

RSpec.describe CafeDataByCategory do
  before(:each) do
    cafe1 = StreetCafe.create!(name: 'All Bar Most Chairs', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 5BN', number_of_chairs: 140)
    cafe2 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 16)
    cafe3 = StreetCafe.create!(name: 'BHS', street_address: '49 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 6)
    cafe4 = StreetCafe.create!(name: 'Hotel Chocolat', street_address: '55 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 12)
    cafe5 = StreetCafe.create!(name: 'Cattle Grid', street_address: "Waterloo House, Assembly Street", post_code: 'LS2 7DB', number_of_chairs: 20)
    cafe6 = StreetCafe.create!(name: 'Chilli White', street_address: 'Assembly Street', post_code: 'LS2 7DA', number_of_chairs: 51)
    cafe7 = StreetCafe.create!(name: 'Safran', street_address: '81 Kirkgate', post_code: 'LS2 7DJ', number_of_chairs: 6)
    cafe8 = StreetCafe.create!(name: 'Sandinista', street_address: '5 Cross Belgrave Street', post_code: 'LS2 8JP', number_of_chairs: 18)
    cafe9 = StreetCafe.create!(name: 'Tiger Tiger', street_address: '117 Albion St', post_code: 'LS2 8DY', number_of_chairs: 118)
    cafe10 = StreetCafe.create!(name: 'The Wrens Hotel', street_address: '61A New Briggate', post_code: 'LS2 8DY', number_of_chairs: 20)
    cafe11 = StreetCafe.create!(name: 'The Adelphi', street_address: '3 - 5 Hunslet Road', post_code: 'LS10 1JQ', number_of_chairs: 35)
    cafes = StreetCafe.all

    cafes.each do |cafe|
      CafeCategorizer.categorize(cafe)
    end
  end

  it 'can aggregate cafe category data' do
    ls1_small_data = CafeDataByCategory.find_by(category: 'ls1 small')
    ls1_medium_data = CafeDataByCategory.find_by(category: 'ls1 medium')
    ls1_large_data = CafeDataByCategory.find_by(category: 'ls1 large')

    ls2_small_data = CafeDataByCategory.find_by(category: 'ls2 small')
    ls2_large_data = CafeDataByCategory.find_by(category: 'ls2 large')

    other_data = CafeDataByCategory.find_by(category: 'other')

    expect(ls1_small_data.total_places).to eq(1)
    expect(ls1_small_data.total_chairs).to eq(6)

    expect(ls1_medium_data.total_places).to eq(2)
    expect(ls1_medium_data.total_chairs).to eq(28)

    expect(ls1_large_data.total_places).to eq(1)
    expect(ls1_large_data.total_chairs).to eq(140)

    expect(ls2_small_data.total_places).to eq(2)
    expect(ls2_small_data.total_chairs).to eq(24)

    expect(ls2_large_data.total_places).to eq(4)
    expect(ls2_large_data.total_chairs).to eq(209)

    expect(other_data.total_places).to eq(1)
    expect(other_data.total_chairs).to eq(35)
  end
end