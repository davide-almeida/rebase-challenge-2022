require 'csv'
require 'pg'
require_relative '../config/connect_database'
require_relative 'create_database'

class ImportFromCsv
  @conn = ConnectDatabase.connection
  @conn.exec(CreateDatabase.drop_table('client'))
  @conn.exec(CreateDatabase.create_table('client'))

  def self.csv_file(csv_file)
    csv_rows = CSV.read(csv_file, col_sep: ';')
    csv_rows.shift
    csv_rows
  end

  def self.save_csv_file(rows)
    rows.each do |row|
      @conn.exec_params(
        'INSERT INTO client (cpf_code, name, email, birthdate, address, city, state, crm_code, crm_state, doctor_name, doctor_email, token_exame_result, exame_date, exame_type, exame_type_limit, exame_result)
        VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::date, $14::text, $15::text, $16::int );', row
      )
    end
  end
end
