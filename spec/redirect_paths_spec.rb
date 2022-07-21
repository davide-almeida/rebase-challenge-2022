require 'spec_helper'
require 'sinatra'

describe 'Redirect paths' do
  let(:app) { Server.new }

  context 'when visit /' do
    it 'redirect to /tests' do
      get '/'

      expect(last_response).to be_redirect
    end
  end

  context 'when visit /tests/' do
    it 'redirect to /tests' do
      get '/tests/'

      expect(last_response).to be_redirect
    end
  end
end
