module EVENT
  class E
    def initialize i
      @event = Nickel.parse i
      puts %[EVENT::E: #{@event}]
      if event?
        @message = @event.message
      else
        t = Time.now.utc
        @message = i
      end
    end
    def event?
      if %[#{@event.message}].length > 0 && @event.occurrences.length > 0
        return true
      else
        return false
      end
    end
    def each &b
      @event.occurrences.each { |e|
        h = {
          message: @message,
          date: e.start_date.to_date.strftime("%-d %b %Y"),
          hour: e.start_time.to_time.strftime("%k"),
          minute: e.start_time.to_time.strftime("%M") 
        }
        puts %[each message: #{h}]
        b.call(h, e)
      }
      return nil
    end
  end
  def self.[] k
    E.new(k)
  end
end
