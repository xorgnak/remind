# Event Processor
module EVENT

  # Event object.
  class E
    # Event +i+.
    def initialize i
      if @event = Nickel.parse(i)
#        puts %[EVENT event: #{@event}]
        @message = @event.message
      else
#        puts %[EVENT log]
        t = Time.now.utc
        @message = i
      end
    end
    # is event?
    def event?
      if %[#{@event.message}].length > 0 && @event.occurrences.length > 0
        return true
      else
        return false
      end
    end
    # each event occourence 
    def each &b
      @event.occurrences.each { |e|
        h = {
          message: @message,
          date: e.start_date.to_date.strftime("%-d %b %Y"),
        }
        if e.start_time
          h[:hour] = e.start_time.to_time.strftime("%k")
          h[:minute] = e.start_time.to_time.strftime("%M")
        else
          h[:hour] = "00"
          h[:minute] = "00"
        end
        puts %[each message: #{h}]
        b.call(h, e)
      }
      return nil
    end
  end
  # Process event.
  def self.[] k
    E.new(k)
  end
end
