require 'pg'

class ConnectDatabase
  def self.connection
    PG.connect(
      dbname: 'postgres',
      host: '172.18.0.2',
      port: 5432,
      user: 'postgres',
      password: '54321'
    )
  end
end
