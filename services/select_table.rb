require 'pg'
require_relative '../config/connect_database'
require_relative 'create_database'

class SelectTable
  @conn = ConnectDatabase.connection
  @conn.exec(CreateDatabase.create_table('medic_data'))

  def self.all(table_name)
    @conn.exec_params("select * from #{table_name}")
  end

  def self.column_names(table_name)
    @conn.query("SELECT * FROM #{table_name} LIMIT 1").first.keys
  end
end
