# frozen_string_literal: true

require 'faraday'

require 'icalendar'

require_relative "remind/version"

require_relative "remind/remind"

require_relative "remind/calendar"

module Remind
  class Error < StandardError; end
  @@REM = REM['reminders']
  def self.[]= x, u
    r = REM[x]
    r.clear!
    @@REM.clear!
    CAL.from_url(u).each do |e|
      h = {
        date: e.when[:begin].to_time.localtime.strftime("%-d %b %Y"),
        hour: e.when[:begin].to_time.localtime.strftime("%k"),
        minute: e.when[:begin].to_time.localtime.strftime("%M"),
        at: e.where,
        type: e.who
      }
      r[e.what].attr = h
      @@REM[e.what].attr = h
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
