require 'pg'
require 'csv'
require_relative '../config/connect_database'
require_relative './drop_database'
require_relative './create_database'

class ImportFromCsv
  def self.csv_file(csv_file)
    csv_rows = CSV.read(csv_file, col_sep: ';')
    csv_rows.shift
    csv_rows
  end

  def self.save_csv_file(rows)
    @conn = ConnectDatabase.connection

    @client_array = []
    @doctor_array = []
    client_last_id = nil
    doctor_last_id = nil

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
