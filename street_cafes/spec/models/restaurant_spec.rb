require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "class methods" do
    before(:each) do
      @restaurant_1 = Restaurant.create(name: "A Restaurant",
                                        post_code: "LS1 5BN",
                                        number_of_chairs: 15)
      @restaurant_2 = Restaurant.create(name: "B Restaurant",
                                        post_code: "LS1 6RT",
                                        number_of_chairs: 7)
      @restaurant_3 = Restaurant.create(name: "C Restaurant",
                                        post_code: "LS1 43P",
                                        number_of_chairs: 115)
      @restaurant_4 = Restaurant.create(name: "D Restaurant",
                                        post_code: "LS1 LP9",
                                        number_of_chairs: 72)
      @restaurant_5 = Restaurant.create(name: "E Restaurant",
                                        post_code: "LS2 7TR",
                                        number_of_chairs: 20)
      @restaurant_6 = Restaurant.create(name: "F Restaurant",
                                        post_code: "LS2 R74",
                                        number_of_chairs: 40)
      @restaurant_7 = Restaurant.create(name: "G Restaurant",
                                        post_code: "LS2 5BN",
                                        number_of_chairs: 10)
      @restaurant_8 = Restaurant.create(name: "H Restaurant",
                                        post_code: "LS2 PSN",
                                        number_of_chairs: 30)
      @restaurant_9 = Restaurant.create(name: "I Restaurant",
                                        post_code: "LS4 5BN",
                                        number_of_chairs: 20)
    end

    it '.categorize_restaurants' do
      Restaurant.categorize_restaurants

      #tests that restaurants sum correctly by category
      expect(Restaurant.where("category = 'ls1 medium'")).to eq([@restaurant_1, @restaurant_4])
      expect(Restaurant.where("category = 'ls1 small'")).to eq([@restaurant_2])
      expect(Restaurant.where("category = 'ls1 large'")).to eq([@restaurant_3])
      expect(Restaurant.where("category = 'ls2 small'")).to eq([@restaurant_5, @restaurant_7])
      expect(Restaurant.where("category = 'ls2 large'")).to eq([@restaurant_6, @restaurant_8])
      expect(Restaurant.where("category = 'other'")).to eq([@restaurant_9])

      #tests that total chairs sum correctly by category
      expect(Restaurant.where("category = 'ls1 medium'").sum("number_of_chairs")).to eq(87)
      expect(Restaurant.where("category = 'ls1 small'").sum("number_of_chairs")).to eq(7)
      expect(Restaurant.where("category = 'ls1 large'").sum("number_of_chairs")).to eq(115)
      expect(Restaurant.where("category = 'ls2 small'").sum("number_of_chairs")).to eq(30)
      expect(Restaurant.where("category = 'ls2 large'").sum("number_of_chairs")).to eq(70)
      expect(Restaurant.where("category = 'other'").sum("number_of_chairs")).to eq(20)
    end

    it '.find_small_restaurants' do
      Restaurant.categorize_restaurants
      expect(Restaurant.find_small_restaurants).to eq([@restaurant_2, @restaurant_5, @restaurant_7])
    end

    it 'manage_medium_large_restaurants' do
      skip
      Restaurant.manage_small_restaurants
      expect(@restaurant_1.name).to eq('ls1 medium A Restaurant')
      expect(@restaurant_6.name).to eq('ls2 large F Restaurant')
    end
  end
end
