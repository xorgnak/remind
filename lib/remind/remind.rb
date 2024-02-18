
class E 
  def initialize k
    @id = k
    @rem = []
    @r = Hash.new { |h,k| h[k] = R.new(k) }
  end
  def id; @id; end
  
  def [] k
    @rem << k
    @r[k]
  end

  def agenda
    `remind -t1 rem/#{@id}.rem`.split("\n\n")
  end

  def to_rem
    a = [];
    @rem.each { |e| a << @r[e].to_rem }
    return a.join("\n")
  end
  
  def to_rem!
    if !Dir.exist? "rem"
      Dir.mkdir("rem")
    end
    File.open("rem/#{@id}.rem",'w') { |f| f.write(to_rem); }
  end
end


class R

  attr_accessor :attr
  
  def initialize k
    @id = k
    @attr = {}
  end
  
  def id; @id; end
  
  def to_rem
    a, i = [], [ @id ]
    if @attr.has_key? :type
      i << %[#{@attr[:type]}]
    end
    if @attr.has_key? :date
      a << %[#{@attr[:date]}]
      if @attr.has_key? :lead
        a << %[++#{@attr[:lead]}]
      end
      if @attr.has_key? :repeat
        a << %[*#{@attr[:repeat]}]
      end
      if @attr.has_key? :until
        a << %[UNTIL #{@attr[:until]}]
      end
    end
    if @attr.has_key? :hour
      if @attr.has_key? :minute
        a << %[AT #{@attr[:hour]}:#{@attr[:minute]}]
      else
        a << %[AT #{@attr[:hour]}:00]
      end
    end
    if @attr.has_key? :duration
      i << %[for #{@attr[:duration]} hours]
    end
    if @attr.has_key? :at
      i << %[at #{@attr[:at]}]
    end
    return %[REM #{a.join(" ")} MSG %b %2 #{i.join(" ")}]
  end
end

module REM
  @@REM = Hash.new { |h,k| h[k] = E.new(k) }
  def self.[] k
    @@REM[k]
  end
  def self.keys
    @@REM.keys
  end
end

