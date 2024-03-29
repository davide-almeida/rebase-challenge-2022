require 'sidekiq'
require './config/sidekiq'
require './app/services/import_from_csv'

class CsvWorker
  include Sidekiq::Job

  def perform(csv_rows)
    ImportFromCsv.save_csv_file(csv_rows)
  end
end
