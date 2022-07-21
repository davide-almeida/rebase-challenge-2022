require './config/connect_database'
require './app/models/client'
require './app/models/doctor'
require './app/models/test'

class ApplicationModels
  def self.create_all_tables
    Client.create
    Doctor.create
    Test.create
  end

  def self.drop_all_tables
    Test.drop
    Client.drop
    Doctor.drop
  end
end
