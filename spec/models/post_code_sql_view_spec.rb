require 'rails_helper'

RSpec.describe PostCodeData do 
  before(:each) do
    @cafe1 = StreetCafe.create!(name: 'All Bar One', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 20)
    @cafe2 = StreetCafe.create!(name: 'All Bar Most Chairs', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 5BN', number_of_chairs: 140)
    @cafe3 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 20)
    @cafe4 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 16)
    @cafe5 = StreetCafe.create!(name: 'Caffé Nero (MOST CHAIRS)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 22)
    @cafe6 = StreetCafe.create!(name: 'BHS', street_address: '49 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 6)
    @cafe7 = StreetCafe.create!(name: 'Hotel Chocolat', street_address: '55 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 12)
  end

  it 'returns all required data' do
    total_chairs = StreetCafe.all.sum(:number_of_chairs)
    post_code_chairs = StreetCafe.group(:post_code).sum(:number_of_chairs)
    ls15bn_percent = (((post_code_chairs["LS1 5BN"].to_f) / total_chairs ) * 100).round(2)
    ls16js_percent = (((post_code_chairs["LS1 6JS"].to_f) / total_chairs ) * 100).round(2)
    ls15el_percent = (((post_code_chairs["LS1 5EL"].to_f) / total_chairs ) * 100).round(2)

    aggregated_data = PostCodeData.all
    expect(aggregated_data.length).to eq(3)

    expect(aggregated_data.first.post_code).to eq('LS1 5BN')
    expect(aggregated_data.first.total_places).to eq(2)
    expect(aggregated_data.first.total_chairs).to eq(160)
    expect(aggregated_data.first.chairs_pct.to_f).to eq(ls15bn_percent)
    expect(aggregated_data.first.place_with_max_chairs).to eq('All Bar Most Chairs')

    expect(aggregated_data[1].post_code).to eq('LS1 5EL')
    expect(aggregated_data[1].total_places).to eq(2)
    expect(aggregated_data[1].total_chairs).to eq(18)
    expect(aggregated_data[1].chairs_pct.to_f).to eq(ls15el_percent)
    expect(aggregated_data[1].place_with_max_chairs).to eq('Hotel Chocolat')

    expect(aggregated_data.last.post_code).to eq('LS1 6JS')
    expect(aggregated_data.last.total_places).to eq(3)
    expect(aggregated_data.last.total_chairs).to eq(58)
    expect(aggregated_data.last.chairs_pct.to_f).to eq(ls16js_percent)
    expect(aggregated_data.last.place_with_max_chairs).to eq('Caffé Nero (MOST CHAIRS)')

    result = aggregated_data.sum { |data| data.chairs_pct.to_f }.round(1)
    expect(result).to eq(100.0)
  end
end