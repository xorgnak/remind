# Icalendar wrapper.
module CAL

  # Calendar object.
  class C
    # Calendar +f+
    def initialize f
      @f = f
    end
    # each calendar event
    def each &b
      @f.events.each { |e| b.call(E.new(e)) }
      return nil
    end
    # map each calendar event
    def map &b
      a = []
      @f.events.each { |e| a << b.call(E.new(e)) }
      return a
    end
  end

  # Calendar Event object
  class E
    # Calendar Event +f+.
    def initialize f
      @f = f
    end
    # Calendar Event location
    def where
      @f.location
    end
    # Calendar Event focus
    def who
      @f.summary
    end
    # Calendar Event details
    def what
      @f.description
    end
    # Calendar Event scheduling
    def when
      { begin: @f.dtstart, end: @f.dtend }
    end
  end
  # Load Calendar Event Collection from file +f+.
  def self.from_file f
    x = File.read(f)
    C.new(Icalendar::Calendar.parse(x).first)
  end
  # Load Calendar Event Collection from url +u+.
  def self.from_url u
    x = Faraday.new().get(u).body
    C.new(Icalendar::Calendar.parse(x).first)
  end
end
