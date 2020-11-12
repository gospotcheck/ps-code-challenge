require 'rails_helper'

RSpec.describe 'db:import:cafes', type: :rake do
  it 'imports records from csv file' do
    StreetCafe.destroy_all

    ENV['IMPORT_PATH'] = './spec/fixtures/dummy_cafe_import.csv'
    expect(StreetCafe.all.length).to eq(0)
    Rake::Task['db:import:cafes'].invoke
    expect(StreetCafe.all.length).to eq(21)
  end
end