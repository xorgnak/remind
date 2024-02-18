# frozen_string_literal: true

require 'faraday'

require 'icalendar'

require_relative "remind/version"

require_relative "remind/remind"

require_relative "remind/calendar"

module Remind
  class Error < StandardError; end
  @@REM = REM['reminders']
  @@INIT = []
  @@URL = []
  def self.init h={}
    @@INIT << h
  end
  
  def self.url u
    @@URL << u
  end
  
  def self.rebuild!
    @@REM.clear!
    [@@INIT].flatten.each do |x|
      @@REM[x[:what]].attr = { date: x[:when] }
    end
    @@URL.each do |u|
      CAL.from_url(u).each do |e|
        d = e.when[:begin].to_time.localtime.strftime("%Y/%m/%d-%R")
        h = {
          date: e.when[:begin].to_time.localtime.strftime("%-d %b %Y"),
          hour: e.when[:begin].to_time.localtime.strftime("%k"),
          minute: e.when[:begin].to_time.localtime.strftime("%M"),
          at: e.where,
          type: e.who,
          lead: 1
        }
        k = %[#{e.what} #{h[:type]} #{d}]
        @@REM[k].attr = h
      end
    end
  end

  def self.remote x, u
    r = REM[x]
    r.clear!
    Remind.rebuild!
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
    @@REM.to_rem!
    @@REM.agenda[1..-1]
  end
end
