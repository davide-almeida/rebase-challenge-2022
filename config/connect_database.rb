require 'pg'

class ConnectDatabase
  def self.connection
    PG.connect(
      dbname: 'postgres',
      host: 'davide_postgres',
      port: 5432,
      user: 'postgres',
      password: '54321'
    )
  end
end
