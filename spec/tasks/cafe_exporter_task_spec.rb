require 'rails_helper'

RSpec.describe 'db:export_and_delete:small_cafes' do
  before(:each) do
    StreetCafe.destroy_all
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
    @cafes = StreetCafe.all

    @cafes.each do |cafe|
      CafeCategorizer.categorize(cafe)
    end
  end

  it 'exports and deletes small cafes' do
    expect(StreetCafe.cafes_by_category('%small').length).to eq(3)
    ENV['EXPORT_PATH'] = './spec/fixtures/small_cafes_rake_export_test'
    
    Rake::Task['db:export_and_delete:small_cafes'].invoke
    expect(StreetCafe.cafes_by_category('%small').length).to eq(0)

    file = "./spec/fixtures/small_cafes_rake_export_test #{Date.today}.csv"
    CSV.foreach(file, headers: true) do |actual_row|
      hashed_data = actual_row.to_h
      cafe = @cafes.find { |cafe| cafe.name == hashed_data.values.first }
      expected_data = [
            cafe.name,
            cafe.street_address,
            cafe.post_code,
            cafe.category,
            cafe.number_of_chairs.to_s
          ]
      actual_row.to_h.values.each do |actual_data|
        next if actual_data == nil
        expect(expected_data).to include(actual_data)
      end
    end
  end
end