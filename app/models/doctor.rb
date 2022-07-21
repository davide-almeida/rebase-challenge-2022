require 'pg'
require './config/connect_database'

class Doctor
  @conn = ConnectDatabase.connection

  def self.drop
    @conn.exec('DROP TABLE IF EXISTS doctors;')
  end

  def self.create
    @conn.exec('CREATE TABLE IF NOT EXISTS doctors (
      ID SERIAL PRIMARY KEY,
      crm varchar(100),
      crm_state varchar(100),
      name varchar(100),
      email varchar(100)
    )')
  end

  def self.all
    @conn.exec_params('select * from doctors')
  end

  def self.column_names
    @conn.query('SELECT * FROM doctors LIMIT 1').first.keys
  end

  def self.by_id(id)
    @conn.exec_params('SELECT * FROM doctors WHERE id = $1', id)
  end
end
