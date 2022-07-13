require 'csv'
require 'pg'

def import_from_csv
  rows = CSV.read("./data.csv", col_sep: ';')
  columns = rows.shift

  conn = PG.connect(dbname: "postgres", host: '172.18.0.2', port: 5432, user: 'postgres', password: 'pass')
  rows.each do |row|
    conn.exec_params(
      "INSERT INTO client (cpf_code, name, email, birthdate, address, city, state, crm_code, crm_state, doctor_name, doctor_email, token_exame_result, exame_date, exame_type, exame_type_limit, exame_result)
      VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::date, $14::text, $15::text, $16::int );", row
    )
  end
end
