# coding: utf-8

require "bundler"
Bundler.require

require_relative "db"

get "/" do
  slim :index
end
