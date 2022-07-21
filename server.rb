require 'sinatra/base'
require 'rack/handler/puma'
require_relative 'app/controllers/tests_controller'
require_relative 'app/controllers/imports_controller'

class Server < Sinatra::Base
  configure :production, :development do
    enable :logging
  end
  set :bind, '0.0.0.0'
  set :port, 3000

  use TestsController
  use ImportsController

  run! if app_file == $0
end
