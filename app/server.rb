# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative './database/accounts'
require_relative './database/transactions'

set :port, ENV['PORT'] || '9999'
set :bind, '0.0.0.0'

get '/clientes/:id/extrato' do
  content_type :json

  id = params['id'].to_i

  accounts ||= accounts(id)

  return status 404 unless accounts.valid?

  status 200

  JSON.generate(serialize_extract(accounts.show, transaction(id)))
rescue StandardError
  status 422
end

post '/clientes/:id/transacoes' do
  content_type :json

  body = JSON.parse(request.body.read)

  id = params['id'].to_i

  accounts ||= accounts(id)

  return status 404 unless accounts.valid?
  return status 422 if invalid_type?(body) || body['descricao'] == ''

  case body['tipo']
  when 'c'
    accounts.encrease_balance(body['valor'], id)
    create_transaction(body, id)
  when 'd'
    accounts.decrease_balance(body['valor'], id)
    create_transaction(body, id)
  else
    status 422
  end

  status 200
  JSON.generate(serialize_transaction_result(accounts.show))
rescue StandardError
  status 422
end

private

def serialize_extract(account, transaction)
  {
    'saldo' =>
    {
      'total' => Integer(account['amount']),
      'limite' => account['limit'],
      'data_extrato' => Time.now
    },
    'ultimas_transacoes' => transaction.index(10)
  }
end

def serialize_transaction_result(account)
  {
    'saldo' => account['amount'],
    'limite' => account['limit']
  }
end

def transaction(account_id)
  Transactions.new(account_id: account_id)
end

def create_transaction(params, account_id)
  transaction(account_id).create(
    params['tipo'],
    params['descricao'],
    params['valor']
  )
end

def invalid_type?(params)
  !%w[c d].include?(params['tipo'])
end

def accounts(id)
  Accounts.new(id: id)
end
