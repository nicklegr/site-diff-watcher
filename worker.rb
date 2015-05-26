# coding: utf-8

require "nokogiri"
require "open-uri"
require "yaml"
require "diffy"
require "nkf"
require "pry"

require_relative "db"

setting = YAML.load_file("setting.yaml")

loop do
  setting["sites"].each do |site|
    # @todo エラー処理
    html = open(site["url"]).read

    html = NKF.nkf('-w -Lu', html) # utf-8, LFに変換

    doc = Nokogiri::HTML(html)

    site["remove_by_css"].each do |css|
      doc.css(css).each do |e|
        e.remove()
      end
    end

    site_record = Site.where(:url => site["url"]).first_or_create
    latest_diff = site_record.diffs.order([ :created_at, :desc ]).first

    if latest_diff
      diff = Diffy::Diff.new(latest_diff.html, doc, :context => 0)
      unless diff.to_s.empty?
        diff_record = Diff.new
        diff_record.diff = diff.to_s(:text)
        diff_record.html = doc
        diff_record.site = site_record
        diff_record.save!
      end
    else
      diff_record = Diff.new
      diff_record.diff = doc
      diff_record.html = doc
      diff_record.site = site_record
      diff_record.save!
    end
  end

  sleep 180
end
