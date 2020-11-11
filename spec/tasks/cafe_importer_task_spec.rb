require 'rails_helper'

RSpec.describe 'db:import:cafes', type: :rake do
  it 'imports records from csv file' do
    expect(StreetCafe.all.length).to eq(0)
    Rake::Task['db:import:cafes'].invoke
    expect(StreetCafe.all.length).to eq(73)
  end
end