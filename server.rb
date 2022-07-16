require 'sinatra'
require 'rack/handler/puma'
require 'sidekiq'
require 'csv'
require 'pg'
require './services/import_from_csv'
require './services/select_table'
require_relative './config/sidekiq'
require_relative './workers/csv_worker'

class Server < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 3000

  get '/tests' do
    rows = SelectTable.all('client')
    if rows.count.positive?
      column_names = SelectTable.column_names('client')

      rows.map do |row|
        row.each_with_object({}).with_index do |(cell, acc), idx|
          column = column_names[idx]
          acc[column] = cell[1]
        end
      end.to_json
    else
      { 'message': 'Não há cadastro.' }.to_json
    end
  end

  post '/import' do
    if params[:csv_file].nil? || params[:csv_file][:type] != 'text/csv'
      { 'message': 'Erro ao tentar cadastrar o arquivo .CSV' }.to_json
    else
      csv_file_rows = ImportFromCsv.csv_file(params[:csv_file][:tempfile])
      CsvWorker.perform_async(csv_file_rows)
      { 'message': 'O cadastro está sendo processado!' }.to_json
    end
  end

  run! if app_file == $PROGRAM_NAME
end
