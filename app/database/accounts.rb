# frozen_string_literal: true

require_relative 'connection'

# Class to manage the accounts
class Accounts
  IDS = [1, 2, 3, 4, 5].freeze

  def initialize(id:)
    @id = id.to_i
    @db = Connection.call.checkout
  end

  def show
    query = 'SELECT "limit", amount FROM accounts WHERE id = $1;'
    db.exec_params(query, [id]).first
  end

  def encrease_balance(amount, id)
    query = 'UPDATE accounts
      SET amount = accounts.amount + $1 WHERE id = $2;'

    db.exec_params(query, [amount, id])
  end

  def decrease_balance(amount, id)
    query = 'UPDATE accounts
      SET amount = accounts.amount - $1 WHERE id = $2;'

    db.exec_params(query, [amount, id])
  end

  def valid?
    IDS.include?(id) && Integer(id)
  rescue ArgumentError
    false
  end

  private

  attr_accessor :id, :db
end
