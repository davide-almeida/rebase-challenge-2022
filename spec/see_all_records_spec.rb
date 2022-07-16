require 'spec_helper'

describe 'GET /tests' do
  let(:app) { Server.new }

  context 'and try find some record' do
    it 'and find a record with success' do
      @conn = ConnectDatabase.connection
      @conn.exec(CreateDatabase.drop_table('client'))
      @conn.exec(CreateDatabase.create_table('client'))
      @conn.exec_params("INSERT INTO public.client(
      cpf_code, name, email, birthdate, address, city, state, crm_code, crm_state, doctor_name, doctor_email, token_exame_result, exame_date, exame_type, exame_type_limit, exame_result, id)
      VALUES ('048.973.170-88', 'Emilly Batista Neto', 'gerald.crona@ebert-quigley.com', '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'B000BJ20J4', 'PI', 'Maria Luiza Pires', 'denna@wisozk.biz', 'IQCZ17', '2021-08-05', 'hemácias', '45-52', '97', 1);")

      response = get '/tests'

      expect(response.body).to include '048.973.170-88'
      expect(response.body).to include 'gerald.crona@ebert-quigley.com'
      expect(response.body).to include 'Emilly Batista Neto'
    end

    it 'but there isnt records' do
      @conn = ConnectDatabase.connection
      @conn.exec(CreateDatabase.drop_table('client'))
      @conn.exec(CreateDatabase.create_table('client'))

      response = get '/tests'

      expect(response.body).to include 'Não há cadastro.'
    end
  end
end
