require 'rails_helper'
RSpec.describe StreetCafe, type: :model do
  before :each do
    StreetCafe.destroy_all
    @pur_pour = StreetCafe.create(post_code: 'LS98', chairs: 15)
    @tea_time = StreetCafe.create(post_code: 'LS99', chairs: 25)
    @york_tea = StreetCafe.create(post_code: 'LS13', chairs: 20)
    @york_and_humber = StreetCafe.create(post_code: 'LS2', chairs: 5)
    @prim_and_proper = StreetCafe.create(post_code: 'LS88', chairs: 10)
    @fountains_of_tea = StreetCafe.create(post_code: 'LS3', chairs: 30)
  end

  describe 'validations' do
    it { should validate_presence_of :post_code }
    it { should validate_presence_of :category }
  end

  describe 'class methods' do
    describe '.total_chairs' do
      it 'calculates total number of seats' do
        expect(StreetCafes.total_chairs).to eq(15)
      end
    end
    describe '.total_places' do
      it 'calculates total number of places' do
        expect(StreetCafes.total_places).to eq(15)
      end
    end
    describe '.chairs_pct' do
      it 'calculates total percentage of chairs by post code' do
        expect(StreetCafes.chairs_pct).to eq(15)
      end
    end
    describe '.max_chairs' do
      it 'finds the place with the most chairs' do
        expect(StreetCafes.max_chairs).to eq(15)
      end
    end
  end
end
