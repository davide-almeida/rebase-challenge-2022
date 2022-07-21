require 'spec_helper'

describe 'Trying extract data from default file' do
  let(:app) { Server.new }

  it 'and importing to database with success' do
    csv_rows = ImportFromCsv.csv_file('data.csv')
    ImportFromCsv.save_csv_file(csv_rows)

    all_clients = Client.all
    all_doctors = Doctor.all
    all_tests = Test.all

    expect(all_tests.count).to eq 3900
    expect(all_tests[0]['result_token']).to eq 'IQCZ17'
    expect(all_clients[0]['cpf']).to eq '048.973.170-88'
    expect(all_doctors[0]['crm']).to eq 'B000BJ20J4'
  end
end
