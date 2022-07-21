require 'spec_helper'
require 'sidekiq'
require 'sidekiq/testing'
# Sidekiq::Worker.clear_all
Sidekiq::Testing.fake!

describe 'POST /import' do
  let(:app) { Server.new }
  let(:file) { Rack::Test::UploadedFile.new('data.csv', 'text/csv') }

  context 'try post csv file' do
    it 'with success' do
      post '/import', :csv_file => file

      expect(last_response.status).to eq 200
      expect(last_response.body).to include 'O cadastro está sendo processado!'
    end

    it 'when csv_file input is wrong' do
      post '/import', :csv_file => Rack::Test::UploadedFile.new('data.csv', 'image/jpg')

      expect(last_response.status).to eq 404
      expect(last_response.body).to include 'Erro ao tentar cadastrar o arquivo .CSV'
    end

  end
end
