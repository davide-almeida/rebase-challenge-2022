require 'pg'
require_relative '../config/connect_database'

class DropDatabase
  def self.dropall
    @conn = ConnectDatabase.connection
    @conn.exec('DROP TABLE IF EXISTS tests;')
    @conn.exec('DROP TABLE IF EXISTS clients;')
    @conn.exec('DROP TABLE IF EXISTS doctors;')
  end
end
