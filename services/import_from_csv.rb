require 'csv'
require 'pg'

# Services
require_relative 'connect_database'
require_relative 'create_database'

# Import CSV file and save on DB
class ImportFromCsv
  # Database and tables
  @conn = ConnectDatabase.connection
  @conn.exec(CreateDatabase.drop_table('medic_data'))
  @conn.exec(CreateDatabase.create_table('medic_data'))

  def self.csv_file(csv_file)
    csv_rows = CSV.read(csv_file, col_sep: ';')
    csv_rows.shift
    save_csv_file(csv_rows)
  end

  def self.save_csv_file(rows)
    rows.each do |row|
      @conn.exec_params(
        'INSERT INTO medic_data (cpf_code, name, email, birthdate, address, city, state, crm_code, crm_state, doctor_name, doctor_email, token_exame_result, exame_date, exame_type, exame_type_limit, exame_result)
        VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::date, $14::text, $15::text, $16::int );', row
      )
    end
  end
end
