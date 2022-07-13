require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/tests' do

  # test PG connect
  conn = PG.connect(dbname: "postgres", host: '172.18.0.2', port: 5432, user: 'postgres', password: '54321')
  # test SELECT
  # res = conn.exec_params('select * from users')
  # res.each do |row|
  #   puts row['id'] + ' | ' + row['name']
  # end

  # Test
  # new_count = 0
  # CSV.foreach('./data.csv') do |row|
  #   row.each do |single_row|
  #     data = single_row.split(';')
  #     conn.exec_params('INSERT TAB')
  #   end
  # end

  ### Example
  # [
  #   [cpf, name, date],
  #   [123, 'Leandro', 2022-01-01'],
  #   [456, 'Ana', 2022-01-02'],
  #   [789, 'Maria', 2022-01-03']
  # ]
  #
  rows = CSV.read("./data.csv", col_sep: ';')

  ### Example
  # [cpf, name, date]
  columns = rows.shift

  conn.exec("CREATE TABLE IF NOT EXISTS medic_data (
    cpf_code varchar(20),
    name varchar(450),
    email varchar(100),
    birthdate DATE,
    address varchar(100),
    city varchar(100),
    state varchar(100),
    crm_code varchar(100),
    crm_state varchar(100),
    doctor_name varchar(100),
    doctor_email varchar(100),
    token_exame_result varchar(100),
    exame_date DATE,
    exame_type varchar(100),
    exame_type_limit varchar(100),
    exame_result INT,
    ID SERIAL PRIMARY KEY
  )")

  # INSERT CSV IN DATATABLE
  rows.each do |row|
    conn.exec_params(
      "INSERT INTO medic_data (cpf_code, name, email, birthdate, address, city, state, crm_code, crm_state, doctor_name, doctor_email, token_exame_result, exame_date, exame_type, exame_type_limit, exame_result)
      VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::date, $14::text, $15::text, $16::int );", row
    )
  end

  ### Example
  # From:  [123, 'Leandro', 2022-01-01']
  # To: { cpf: 123, name: 'Leandro', date: '2022-01-01' }
  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
