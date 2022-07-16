require 'spec_helper'
require 'csv'

describe 'Trying extract data from default file' do
  let(:app) { Server.new }

  it 'and importing to database with success' do
    csv_rows = ImportFromCsv.csv_file('data.csv')
    ImportFromCsv.save_csv_file(csv_rows)
    medic_data_rows = SelectTable.all('medic_data')

    expect(medic_data_rows.count).to eq 3900
    expect(medic_data_rows.first['cpf_code']).to eq '048.973.170-88'
  end
end
