# frozen_string_literal: true

require 'faraday'

require 'icalendar'

require_relative "remind/version"

require_relative "remind/remind"

require_relative "remind/calendar"

module Remind
  class Error < StandardError; end
  @@REM = REM['reminders']
  def self.make x, u, *i
    r = REM[x]
    r.clear!
    @@REM.clear!
    [i].flatten.each do |x|
      r[x[:what]].attr = { date: x[:when] }
      @@REM[x[:what]].attr = { date: x[:when] }
    end
    if ENV.has_key? 'ICS'
      CAL.from_url(ENV['ICS']).each do |e|
        h = {
          date: e.when[:begin].to_time.localtime.strftime("%-d %b %Y"),
          hour: e.when[:begin].to_time.localtime.strftime("%k"),
          minute: e.when[:begin].to_time.localtime.strftime("%M"),
          at: e.where,
          type: e.who,
          lead: 30
        }
        r[e.what].attr = h
        @@REM[e.what].attr = h
      end
    end
    CAL.from_url(u).each do |e|
      d = e.when[:begin].to_time.localtime.strftime("%Y/%m/%d-%R")
      h = {
        date: e.when[:begin].to_time.localtime.strftime("%-d %b %Y"),
        hour: e.when[:begin].to_time.localtime.strftime("%k"),
        minute: e.when[:begin].to_time.localtime.strftime("%M"),
        at: e.where,
        type: e.who
      }
      
      k = %[#{e.what} #{h[:type]} #{d}]
      puts "#{k}: #{h}"
      r[k].attr = h
      @@REM[k].attr = h
    end
    r.to_rem!
    @@REM.to_rem!
    return nil
  end
  def self.[] k
    REM[k].agenda[1..-1]
  end
  def self.all
    @@REM.agenda[1..-1]
  end
end
