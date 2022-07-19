require 'pg'
require './config/connect_database'
require 'csv'

@conn = ConnectDatabase.connection

rows = CSV.read("./data.csv", col_sep: ';')
columns = rows.shift

namespace :database do
  task :db_drop do
    @conn.exec('DROP TABLE IF EXISTS tests;')
    @conn.exec('DROP TABLE IF EXISTS clients;')
    @conn.exec('DROP TABLE IF EXISTS doctors;')
  end

  task :db_client do
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

  task :db_doctor do
    @conn.exec('CREATE TABLE IF NOT EXISTS doctors (
      ID SERIAL PRIMARY KEY,
      crm varchar(100),
      crm_state varchar(100),
      name varchar(100),
      email varchar(100)
    )')
  end

  task :db_test do
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

@client_array = []
@doctor_array = []
client_last_id = nil
doctor_last_id = nil

namespace :seed_database do
  task :db_insert do
    rows.map do |row|
      values_client = [row[0], row[1], row[2], row[3], row[4], row[5], row[6]]
      unless @client_array.include?(values_client)
        @client_array << values_client
        client_res = @conn.exec_params(
          'INSERT INTO clients ( cpf, name, email, birthday, address, city, state )
          VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text)
          RETURNING id;', values_client
        )
        client_last_id = client_res.values
      end

      values_doctor = [row[7], row[8], row[9], row[10]]
      unless @doctor_array.include?(values_doctor)
        @doctor_array << values_doctor
        doctor_res = @conn.exec_params(
          'INSERT INTO doctors ( crm, crm_state, name, email )
          VALUES ( $1::text, $2::text, $3::text, $4::text)
          RETURNING id;', values_doctor
        )
        doctor_last_id = doctor_res.values
      end

      values_test = [client_last_id[0][0].to_i, doctor_last_id[0][0].to_i, row[11], row[12], row[13], row[14], row[15]]
      @conn.exec_params(
        'INSERT INTO tests ( client_id, doctor_id, result_token, result_date, test_type, limits, result )
        VALUES ( $1::int, $2::int, $3::text, $4::date, $5::text, $6::text, $7::int);', values_test
      )
    end
  end
end

desc 'perform all tasks'
task :all do
  puts 'RakeTask: Reset DB - start...'
  Rake::Task['database:db_drop'].execute
  Rake::Task['database:db_client'].execute
  Rake::Task['database:db_doctor'].execute
  Rake::Task['database:db_test'].execute
  puts 'RakeTask: Reset DB - end'
  puts 'RakeTask: Populating data - start...'
  Rake::Task['seed_database:db_insert'].execute
  puts 'RakeTask: Populating data - end'
end
