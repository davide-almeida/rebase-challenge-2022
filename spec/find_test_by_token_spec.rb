require 'spec_helper'

describe 'GET /tests/:token' do
  let(:app) { Server.new }

  context 'and try find test by token' do
    it 'with success' do
      @conn = ConnectDatabase.connection
      DropDatabase.dropall
      CreateDatabase.create_tables

      clients = [
        ['081.878.172-67', 'Emanuel Beltrão Neto', 'jennine@mosciski-swaniawski.co', '1989-10-28', '5538 Avenida Lívia', 'Pão de Açúcar', 'Roraima'],
        ['071.488.453-78', 'Antônio Rebouças', 'adalberto_grady@feil.org', '1999-04-11', '25228 Travessa Ladislau', 'Tefé', 'Sergipe']
      ]
      clients.each do |client|
        @conn.exec_params(
          'INSERT INTO clients ( cpf, name, email, birthday, address, city, state )
          VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text)
          RETURNING id;', client
        )
      end

      doctor = ['B0000DHDOF', 'MT', 'Luiz Felipe Raia Jr.', 'marshall@brekke-funk.name']
      @conn.exec_params(
        'INSERT INTO doctors ( crm, crm_state, name, email )
        VALUES ( $1::text, $2::text, $3::text, $4::text)
        RETURNING id;', doctor
      )

      tests = [
        [1, 1, 'GOQF7S', '1989-10-28', 'leucócitos', '45-52', 71],
        [1, 1, 'GOQF7S', '1989-10-28', 'leucócitos', '9-61', 87],
        [2, 1, 'QDU4KD', '2022-01-31', 'hemácias', '45-52', 30],
        [2, 1, 'QDU4KD', '2022-01-31', 'leucócitos', '9-61', 40]
      ]
      tests.each do |ts|
        @conn.exec_params(
          'INSERT INTO tests ( client_id, doctor_id, result_token, result_date, test_type, limits, result )
          VALUES ( $1::int, $2::int, $3::text, $4::date, $5::text, $6::text, $7::int);', ts
        )
      end

      response = get '/tests/GOQF7S'

      expect(response.body).to include 'GOQF7S'
      expect(response.body).to include '1989-10-28'
      expect(response.body).to include 'leucócitos'
      expect(response.body).to include '45-52'
      expect(response.body).to include '71'
      expect(response.body).to include '081.878.172-67'
      expect(response.body).to include 'B0000DHDOF'
      expect(response.status).to eq 200
    end

    it 'with wrong params' do
      @conn = ConnectDatabase.connection
      DropDatabase.dropall
      CreateDatabase.create_tables

      clients = [
        ['081.878.172-67', 'Emanuel Beltrão Neto', 'jennine@mosciski-swaniawski.co', '1989-10-28', '5538 Avenida Lívia', 'Pão de Açúcar', 'Roraima'],
        ['071.488.453-78', 'Antônio Rebouças', 'adalberto_grady@feil.org', '1999-04-11', '25228 Travessa Ladislau', 'Tefé', 'Sergipe']
      ]
      clients.each do |client|
        @conn.exec_params(
          'INSERT INTO clients ( cpf, name, email, birthday, address, city, state )
          VALUES ( $1::text, $2::text, $3::text, $4::date, $5::text, $6::text, $7::text)
          RETURNING id;', client
        )
      end

      doctor = ['B0000DHDOF', 'MT', 'Luiz Felipe Raia Jr.', 'marshall@brekke-funk.name']
      @conn.exec_params(
        'INSERT INTO doctors ( crm, crm_state, name, email )
        VALUES ( $1::text, $2::text, $3::text, $4::text)
        RETURNING id;', doctor
      )

      tests = [
        [1, 1, 'GOQF7S', '1989-10-28', 'leucócitos', '45-52', 71],
        [1, 1, 'GOQF7S', '1989-10-28', 'leucócitos', '9-61', 87],
        [2, 1, 'QDU4KD', '2022-01-31', 'hemácias', '45-52', 30],
        [2, 1, 'QDU4KD', '2022-01-31', 'leucócitos', '9-61', 40]
      ]
      tests.each do |ts|
        @conn.exec_params(
          'INSERT INTO tests ( client_id, doctor_id, result_token, result_date, test_type, limits, result )
          VALUES ( $1::int, $2::int, $3::text, $4::date, $5::text, $6::text, $7::int);', ts
        )
      end

      response = get '/tests/zzzzzzzzzzzz'

      expect(response.body).to include 'Este token é inválido.'
      expect(response.status).to eq 404
    end
  end
end
