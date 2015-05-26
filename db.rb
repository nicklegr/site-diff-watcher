# coding: utf-8

require "mongoid"

class Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String

  has_many :diffs
end

class Diff
  include Mongoid::Document
  include Mongoid::Timestamps

  field :diff, type: String
  field :html, type: String

  belongs_to :site
end

Mongoid.configure do |config|
  if ENV.key?("MONGODB_PORT_27017_TCP_ADDR")
    # for docker
    config.sessions = { default: { database: "app", hosts: [ "#{ENV['MONGODB_PORT_27017_TCP_ADDR']}:27017" ] }}
  else
    config.sessions = { default: { database: "app", hosts: [ "localhost:27017" ] }}
  end
end

# if development?
#   Mongoid.logger.level = Logger::DEBUG
#   Moped.logger.level = Logger::DEBUG
# end
