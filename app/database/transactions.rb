# frozen_string_literal: true

require_relative 'connection'

# Class to manage transactions
class Transactions
  def initialize(account_id:)
    @account_id = account_id.to_i
    @db = Connection.call.checkout
  end

  def create(type, description, amount)
    query = 'INSERT INTO transactions (
      account_id,
      type,
      description,
      value)
      VALUES ($1, $2, $3, $4);'

    db.exec_params(query, [account_id, type, description, amount])
  end

  def index(limit)
    query = 'SELECT type, value, inserted_at, description FROM transactions
      WHERE account_id = $1 ORDER BY inserted_at DESC LIMIT $2'

    result = db.exec_params(query, [account_id, limit])

    result.map do |t|
      {
        "valor": t['value'].to_i, "tipo": t['type'], "descricao": t['description'], "realizada_em": t['inserted_at']
      }
    end
  end

  private

  attr_accessor :account_id, :db
end
