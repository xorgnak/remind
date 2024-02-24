# frozen_string_literal: true

require 'erb'

require 'faraday'

require 'icalendar'

require 'nickel'

require_relative "remind/version"

require_relative "remind/remind"

require_relative "remind/calendar"

require_relative "remind/event"

# The Remind wrapper.
module Remind
  # generic errors
  class Error < StandardError; end

  @@REM = REM['reminders']
  
  @@INIT = []
  # Add system event.
  # +h+ event hash
  #  Remind.reminder what: "Sports ball vs. the other team.", when: "15 March 2024 AT 19:00"
  def self.reminder h={}
    @@INIT << h
  end
  
  @@URL = []
  # Add system ics url.
  # +u+ the ics url
  #  Remind.url "https://your_domain.ics"
  def self.url u
    @@URL << u
  end

  # Set system reminders
  #  Remind.build!
  def self.build!
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

  # Set collection +k+ reminders.
  # +src+ one or more input string to be processed.
  #  Remind.set("collection", "Dinner tonight at 8.", ...)
  def self.set k, *src
    REM[k].clear!
    [src].flatten.each do |e|
      EVENT[e].each do |ee|
        REM[k][%[#{ee[:message]} #{ee[:date]}]].attr = { date: ee[:date], hour: ee[:hour], minute: ee[:minute], lead: 1 }
      end
    end
    REM[k].to_rem! append: true
  end

  # Get reminders container +k+                                                                                                                                                                                          
  # +h[:args]+ can be set to get other filters.
  #  Remind.get("collection")
  def self.get k, h={}
    REM[k].get(h[:args] || '-t1')[1..-1]
  end
  # Get system reminders
  # Gets one week's agenda by default. 
  # +h[:args]+ can be set to get other filters.
  #  Remind.get!
  def self.get! h={}
    @@REM.get(h[:args] || '-t1')[1..-1]
  end
end
