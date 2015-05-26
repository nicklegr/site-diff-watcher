# coding: utf-8

require "bundler"
Bundler.require

require_relative "db"

helpers do
  def inner_text(str)
    ret = ""
    doc = Nokogiri::HTML(str)

    doc.traverse do |x|
      if x.text? and not x.text =~ /^\s*$/
        ret += x.text
      end
    end

    ret
  end
end

get "/" do
  @diffs = Diff.order([:created_at, :desc])

  slim :index
end
