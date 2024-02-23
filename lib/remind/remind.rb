module REM
  class E 
    def initialize k
      @id = k
      @r = Hash.new { |h,k| h[k] = R.new(k) }
      clear!
    end
    def id; @id; end
    
    def [] k
      @rem << k
      @rem.uniq
      @r[k]
    end
    
    def get a 
      `remind #{a} rem/#{@id}.rem`.split("\n\n")
    end
    
    def clear!
      @rem = []
    end
    
    def to_rem
      a = [];
      @rem.each { |e| a << @r[e].to_rem }
      return a.join("\n")
    end
    
    def to_rem! h={}
      if !Dir.exist? "rem"
        Dir.mkdir("rem")
      end
      if h[:append] == true
        File.open("rem/#{@id}.rem",'a') { |f| f.write(to_rem); }
      else
        File.open("rem/#{@id}.rem",'w') { |f| f.write(to_rem); }
      end
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
      puts %[R[#{@id}] #{@attr}]
      a, i = [], [ @id ]
      if @attr.has_key? :date
        a << %[#{@attr[:date]}]
        if @attr.has_key? :lead
          a << %[++#{@attr[:lead]}]
        end
      end
      if @attr.has_key? :hour
        if @attr.has_key? :minute
          a << %[AT #{@attr[:hour]}:#{@attr[:minute]}]
        else
          a << %[AT #{@attr[:hour]}:00]
        end
      end
      return %[REM #{a.join(" ")} MSG #{i.join(" ")}\n]
    end
  end
  
  @@REM = Hash.new { |h,k| h[k] = E.new(k) }
  def self.[] k
    @@REM[k]
  end
  def self.keys
    @@REM.keys
  end
end
