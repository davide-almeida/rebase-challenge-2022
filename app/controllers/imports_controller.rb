require './app/services/import_from_csv'
require './app/services/select_table'
require './workers/csv_worker'

class ImportsController < Sinatra::Base
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
end
