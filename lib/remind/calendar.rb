
module CAL
  class C
    def initialize f
      @f = f
    end
    def each &b
      @f.events.each { |e| b.call(E.new(e)) }
      return nil
    end
    def map &b
      a = []
      @f.events.each { |e| a << b.call(E.new(e)) }
      return a
    end
  end
  
  class E
    def initialize f
      @f = f
    end
    def where
      @f.location
    end
    def who
      @f.summary
    end
    def what
      @f.description
    end
    def when
      { begin: @f.dtstart, end: @f.dtend }
    end
  end
  
  def self.from_file f
    x = File.read(f)
    C.new(Icalendar::Calendar.parse(x).first)
  end
  
  def self.from_url u
    x = Faraday.new().get(u).body
    C.new(Icalendar::Calendar.parse(x).first)
  end
end
