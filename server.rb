require 'sinatra/base'
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
  configure :production, :development do
    enable :logging
  end
  set :bind, '0.0.0.0'
  set :port, 3000

  get '/' do
    redirect '/tests'
  end

  get '/tests/' do
    redirect '/tests'
  end

  get '/tests' do
    begin
      tokens_list = []
      result = []
      result_tokens = SelectTable.test_group_by('result_token')
      result_tokens.map do |token|
        tokens_list << token.values
      end

      tokens_list.each do |t|
        rows = SelectTable.test_by_token(t[0])
        doctor = SelectTable.get_doctor(rows[0]['doctor_id'])
        client = SelectTable.get_client(rows[0]['client_id'])

        result_date = { 'result_date': "#{rows[0]['result_date']}" }
        client = result_date.merge(client)
        result_token = {'result_token': "#{rows[0]['result_token']}"}
        client = result_token.merge(client)
        client['doctor'] = doctor
        client['tests'] = []
        rows.map do |row|
          client['tests'] << {
            'test_type': row['test_type'],
            'test_limits': row['limits'],
            'result': row['result']
          }
        end

        result << client
      end
      JSON[result]

    rescue
      status 404
      { 'message': 'Não há testes cadastrados.' }.to_json
    end
  end

  get '/tests/:token' do
    begin
      rows = SelectTable.test_by_token(params[:token])
      doctor = SelectTable.get_doctor(rows[0]['doctor_id'])
      client = SelectTable.get_client(rows[0]['client_id'])

      result_date = { 'result_date': "#{rows[0]['result_date']}" }
      client = result_date.merge(client)
      result_token = {'result_token': "#{rows[0]['result_token']}"}
      client = result_token.merge(client)
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
    rescue
      status 404
      { 'message': 'Este token é inválido.' }.to_json
    end
  end

  post '/import' do
    if params[:csv_file].nil? || params[:csv_file][:type] != 'text/csv'
      status 404
      { 'message': 'Erro ao tentar cadastrar o arquivo .CSV' }.to_json
    else
      csv_file_rows = ImportFromCsv.csv_file(params[:csv_file][:tempfile])
      CsvWorker.perform_async(csv_file_rows)
      status 200
      { 'message': 'O cadastro está sendo processado!' }.to_json
    end
  end

  run! if app_file == $0
end
