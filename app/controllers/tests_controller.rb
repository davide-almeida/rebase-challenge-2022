require './app/models/test'
require './app/services/import_from_csv'

class TestsController < Sinatra::Base
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
      result_tokens = Test.group_by('result_token')
      result_tokens.map do |token|
        tokens_list << token.values
      end

      tokens_list.each do |t|
        rows = Test.by_token(t[0])
        doctor = Test.get_doctor(rows[0]['doctor_id'])
        client = Test.get_client(rows[0]['client_id'])

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
      result.to_json

    rescue
      status 404
      { 'message': 'Não há testes cadastrados.' }.to_json
    end
  end

  get '/tests/:token' do
    begin
      rows = Test.by_token(params[:token])
      doctor = Test.get_doctor(rows[0]['doctor_id'])
      client = Test.get_client(rows[0]['client_id'])

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
      client.to_json
    rescue
      status 404
      { 'message': 'Este token é inválido.' }.to_json
    end
  end
end
