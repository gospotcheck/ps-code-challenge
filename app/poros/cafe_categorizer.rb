class CafeCategorizer
  class << self
    def categorize(cafe)
      case cafe.post_code[0..3]
      when "LS1 "
        categorize_ls1(cafe)
      when "LS2 "
        categorize_ls2(cafe)
      else
        cafe.category = 'other'
      end
      cafe.save
    end

    private

    def categorize_ls1(cafe)
      if cafe.number_of_chairs < 10
        cafe.category = 'ls1 small'
      elsif cafe.number_of_chairs < 100
        cafe.category = 'ls1 medium'
      elsif cafe.number_of_chairs >= 100
        cafe.category = 'ls1 large'
      end
    end

    def categorize_ls2(cafe)
      if over_50_percentile?(cafe)
        cafe.category = 'ls2 large'
      else
        cafe.category = 'ls2 small'
      end
    end

    def over_50_percentile?(cafe)
      cafe.number_of_chairs >= percentile_50
    end

    def percentile_50
      @@percentile_50 ||= set_50_percentile
    end

    def set_50_percentile
      chair_totals_list = StreetCafe.get_ls2_cafes_chairs_list
      total_number_of_chairs = chair_totals_list.length
      PercentileCalculator.calculate_percentile(
        50.0,
        total_number_of_chairs,
        chair_totals_list
      )
    end
  end
end
