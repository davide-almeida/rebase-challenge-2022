require 'pg'
# Services
require_relative 'connect_database'
require_relative 'create_database'

# Select all data from medic_data table
class SelectTable
  # Database and tables
  @conn = ConnectDatabase.connection
  @conn.exec(CreateDatabase.drop_table('medic_data'))
  @conn.exec(CreateDatabase.create_table('medic_data'))

  def self.all(table_name)
    @conn.exec_params("select * from #{table_name}")
  end

  def self.column_names(table_name)
    @conn.query("SELECT * FROM #{table_name} LIMIT 1").first.keys
  end
end
