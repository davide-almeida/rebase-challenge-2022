require 'pg'
require_relative '../config/connect_database'

class CreateDatabase
  def self.create_tables
    @conn = ConnectDatabase.connection
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

    @conn.exec('CREATE TABLE IF NOT EXISTS doctors (
      ID SERIAL PRIMARY KEY,
      crm varchar(100),
      crm_state varchar(100),
      name varchar(100),
      email varchar(100)
    )')

    @conn.exec('CREATE TABLE IF NOT EXISTS tests (
      ID SERIAL PRIMARY KEY,
      client_id int NOT NULL,
      doctor_id int NOT NULL,
      FOREIGN KEY (client_id) REFERENCES clients (id),
      FOREIGN KEY (doctor_id) REFERENCES doctors (id),
      result_date DATE,
      test_type varchar(100),
      limits varchar(100),
      result INT,
      result_token varchar(100)
    )')
  end
end
