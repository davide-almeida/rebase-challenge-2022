require 'pg'
require './config/connect_database'

class Test
  @conn = ConnectDatabase.connection

  def self.drop
    @conn.exec('DROP TABLE IF EXISTS tests;')
  end

  def self.create
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

  def self.all
    @conn.exec_params('select * from tests')
  end

  def self.column_names
    @conn.query('SELECT * FROM tests LIMIT 1').first.keys
  end

  def self.by_id(id)
    @conn.exec_params('SELECT * FROM tests WHERE id = $1', id)
  end

  def self.by_token(token)
    @conn.exec_params(
      "SELECT *
      FROM public.tests tests
      WHERE tests.result_token = '#{token}';"
    )
  end

  def self.group_by(column)
    @conn.exec_params(
      "SELECT #{column}
      FROM public.tests
      GROUP BY #{column};"
    )
  end

  # Relationships
  def self.get_client(client_id)
    @conn.exec_params(
      "SELECT cpf, name, email, birthday
      FROM clients
      WHERE id = #{client_id};"
    ).first
  end

  def self.get_doctor(doctor_id)
    @conn.exec_params(
      "SELECT crm, crm_state, name
      FROM doctors
      WHERE id = #{doctor_id};"
    ).first
  end
end
