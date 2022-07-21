require 'pg'
require './config/connect_database'

class Client
  @conn = ConnectDatabase.connection

  def self.drop
    @conn.exec('DROP TABLE IF EXISTS clients;')
  end

  def self.create
    @conn.exec('CREATE TABLE IF NOT EXISTS clients (
      ID SERIAL PRIMARY KEY,
      cpf varchar(20),
      name varchar(450),
      email varchar(100),
      birthday DATE,
      address varchar(100),
      city varchar(100),
      state varchar(100)
    )')
  end

  def self.all
    @conn.exec_params('select * from clients')
  end

  def self.column_names
    @conn.query('SELECT * FROM clients LIMIT 1').first.keys
  end

  def self.by_id(id)
    @conn.exec_params('SELECT * FROM clients WHERE id = $1', id)
  end
end
