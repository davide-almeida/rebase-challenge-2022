require 'rspec'

# Database tests
describe 'Connect to database' do
  it 'and import CSV file to DB' do
    # arrange
    require 'csv'
    require 'pg'
    require_relative './../services/import_from_csv'
    require_relative './../services/select_table'
    # act
    ImportFromCsv.csv_file('./data.csv')
    medic_data_rows = SelectTable.all('medic_data')

    # assert
    expect(medic_data_rows.count).to eq 3900
    expect(medic_data_rows.first['cpf_code']).to eq '048.973.170-88'
  end
end
