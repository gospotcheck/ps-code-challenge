require 'rails_helper'

RSpec.describe StreetCafe do
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
    cafes = StreetCafe.all

    cafes.each do |cafe|
      CafeCategorizer.categorize(cafe)
    end
  end

  describe "class methods" do
    it ".get_ls2_chair_list" do
      expected = [6, 18, 20, 20, 51, 118]
      expect(StreetCafe.get_ls2_cafes_chairs_list).to eq(expected)
    end

    it ".cafes_by_category" do
      # ONE SIZE SENT
      small_results = StreetCafe.cafes_by_category('%small')
      expect(small_results.length).to eq(3)
      expect(small_results).to include(@cafe3)
      expect(small_results).to include(@cafe7)
      expect(small_results).to include(@cafe8)

      medium_results = StreetCafe.cafes_by_category('%medium')
      expect(medium_results.length).to eq(2)
      expect(medium_results).to include(@cafe2)
      expect(medium_results).to include(@cafe4)

      large_results = StreetCafe.cafes_by_category('%large')
      expect(large_results.length).to eq(5)
      expect(large_results).to include(@cafe1)
      expect(large_results).to include(@cafe5)
      expect(large_results).to include(@cafe6)
      expect(large_results).to include(@cafe9)
      expect(large_results).to include(@cafe10)

      # TWO SIZES SENT
      med_large_results = StreetCafe.cafes_by_category('%medium', '%large')
      expect(med_large_results.length).to eq(7)
    end
  end
end
