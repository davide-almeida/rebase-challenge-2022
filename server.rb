require 'sinatra'
require 'rack/handler/puma'
require 'sidekiq'
require 'csv'
require 'pg'
require './services/import_from_csv'
require './services/select_table'
require_relative './config/sidekiq'
require_relative './workers/csv_worker'
require 'json'

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

  get '/tests/:token' do
    rows = SelectTable.test_by_token(params[:token])
    doctor = SelectTable.get_doctor(rows[0]['doctor_id'])
    client = SelectTable.get_client(rows[0]['client_id'])

    client['doctor'] = doctor
    client['tests'] = []

    rows.map do |row|
      client['tests'] << {
        'test_type': row['test_type'],
        'test_limits': row['limits'],
        'result': row['result']
      }
    end

    JSON[client]
  end

  run! if app_file == $PROGRAM_NAME
end
