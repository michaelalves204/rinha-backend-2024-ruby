# frozen_string_literal: true

require 'pg'
require 'connection_pool'

# Class to manage the database connection
class Connection
  def self.call
    @call ||= ConnectionPool.new(size: 15, timeout: 300) do
      PG.connect(
        {
          host: 'postgres_rinha',
          dbname: 'rinha_database',
          user: 'rinha',
          password: 'postgres'
        }
      )
    end
  end
end
