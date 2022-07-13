require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

# Services
require './services/import_from_csv'
require './services/select_table'

# Endpoints
get '/tests' do
  # Get csv_file
  ImportFromCsv.csv_file('./data.csv')

  # Select table on database
  column_names = SelectTable.column_names('medic_data')
  rows = SelectTable.all('medic_data')

  # Show table selected
  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = column_names[idx]
      acc[column] = cell[1]
    end
  end.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
