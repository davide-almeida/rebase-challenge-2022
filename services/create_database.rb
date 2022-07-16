class CreateDatabase
  def self.drop_table(table_name)
    "DROP TABLE IF EXISTS #{table_name};"
  end

  def self.create_table(table_name)
    "CREATE TABLE IF NOT EXISTS #{table_name} (
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
    )"
  end
end
