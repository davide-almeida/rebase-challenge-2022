require 'pg'
require './config/connect_database'
require_relative './create_database'
require_relative './drop_database'
require_relative './import_from_csv'

class SelectTable
  @conn = ConnectDatabase.connection

  def self.all(table_name)
    @conn.exec_params("select * from #{table_name}")
  end

  def self.column_names(table_name)
    @conn.query("SELECT * FROM #{table_name} LIMIT 1").first.keys
  end

  def self.by_id(table_name, id)
    @conn.exec_params("SELECT * FROM #{table_name} WHERE id = $1", id)
  end

  def self.alltables
    @conn.exec_params(
      'SELECT *
      FROM public.tests tests
      JOIN public.clients as clients ON tests.client_id = clients.id
      JOIN public.doctors as doctors ON tests.doctor_id = doctors.id;'
    )
  end

  def self.allcolumnsnames
    @conn.exec_params(
      'SELECT *
      FROM public.tests tests
      JOIN public.clients as clients ON tests.client_id = clients.id
      JOIN public.doctors as doctors ON tests.doctor_id = doctors.id
      LIMIT 1;'
    ).first.keys
  end

  # get test
  def self.test_by_token(token)
    @conn.exec_params(
      "SELECT *
      FROM public.tests tests
      WHERE tests.result_token = '#{token}';"
    )
  end

  def self.test_group_by(column)
    @conn.exec_params(
      "SELECT #{column}
      FROM public.tests
      GROUP BY result_token;"
    )
  end

  # get client
  def self.get_client(client_id)
    @conn.exec_params(
      "SELECT cpf, name, email, birthday
      FROM clients
      WHERE id = #{client_id};"
    ).first
  end

  # get doctor
  def self.get_doctor(doctor_id)
    @conn.exec_params(
      "SELECT crm, crm_state, name
      FROM doctors
      WHERE id = #{doctor_id};"
    ).first
  end
end
