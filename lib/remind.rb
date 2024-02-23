# frozen_string_literal: true

require 'erb'

require 'faraday'

require 'icalendar'

require 'nickel'

require_relative "remind/version"

require_relative "remind/remind"

require_relative "remind/calendar"

require_relative "remind/event"

module Remind
  class Error < StandardError; end

  @@REM = REM['reminders']
  
  @@INIT = []
  def self.init h={}
    @@INIT << h
  end
  
  @@URL = []
  def self.url u
    @@URL << u
  end
  
  @@SRC = []
  def self.src k
    @@SRC << k
  end
  
  def self.rebuild!
    @@REM.clear!
    
    [@@INIT].flatten.each do |x|
      puts %[rebuild! x: #{x}]
      @@REM[x[:what]].attr = { date: x[:when] }
    end
    
    @@URL.each do |u|
      puts %[rebuild! u: #{u}]
      CAL.from_url(u).each do |e|
        d = e.when[:begin].to_time.localtime.strftime("%Y/%m/%d-%R")
        h = { date: e.when[:begin].to_time.localtime.strftime("%-d %b %Y"), hour: e.when[:begin].to_time.localtime.strftime("%k"), minute: e.when[:begin].to_time.localtime.strftime("%M"), lead: 1 }
        k = %[#{e.what} #{h[:type]} #{d}]
        @@REM[k].attr = h
      end
    end
    
    @@REM.to_rem!
  end  
  
  def self.remind k, *src
    REM[k].clear!
    [src].flatten.each do |e|
      EVENT[e].each do |ee|
        REM[k][%[#{ee[:message]} #{ee[:date]}]].attr = { date: ee[:date], hour: ee[:hour], minute: ee[:minute], lead: 1 }
      end
    end
    REM[k].to_rem! append: true
  end

  def self.get a, k
    REM[k].get(a)[1..-1]
  end
  
  def self.get! a
    @@REM.get(a)[1..-1]
  end
end
