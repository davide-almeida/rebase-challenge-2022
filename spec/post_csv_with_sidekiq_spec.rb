require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Worker.clear_all
Sidekiq::Testing.inline!

describe 'POST /import' do
  let(:app) { Server.new }
  let(:file) { Rack::Test::UploadedFile.new('data.csv', 'text/csv') }

  context 'try post csv file' do
    it 'with success' do
      post '/import', csv_file: file

      expect(last_response.status).to eq 200
      expect(last_response.body).to include 'O cadastro está sendo processado!'
    end

    it 'when csv_file input is wrong' do
      post '/import', csv_file: Rack::Test::UploadedFile.new('data.csv', 'image/jpg')
      all_clients = SelectTable.all('clients')
      all_doctors = SelectTable.all('doctors')
      all_tests = SelectTable.all('tests')

      expect(all_tests.count).to eq 3900
      expect(all_clients.count).to eq 50
      expect(all_doctors.count).to eq 10
      expect(last_response.status).to eq 404
      expect(last_response.body).to include 'Erro ao tentar cadastrar o arquivo .CSV'
    end
  end
end
