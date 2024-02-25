# frozen_string_literal: true

require_relative './app/server'
require 'rack/handler/puma'

Rack::Handler::Puma.run(Sinatra::Application, threads: 5, Port: ENV['PORT'] || '9999')
