require 'bundler'
Bundler.require

get "/" do
  slim :index
end
