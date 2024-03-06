# The Reminder wrapper.
module REM
  # The Reminder collection object.
  class E
    # Reminder collection +k+.
    def initialize k
      @id = k
      @r = Hash.new { |h,k| h[k] = R.new(k) }
      clear!
    end
    # Reminder collection id.
    def id; @id; end

    # get Reminder from collection.
    def [] k
      @rem << k
      @rem.uniq
      @r[k]
    end

    # get Reminder collection with arguments +a+.
    def get a
      if !File.exist?("rem/#{@id}.rem")
        File.open("rem/#{@id}.rem",'w') { |f| f.write(""); }
      end
      `remind #{a} rem/#{@id}.rem`.split("\n\n")
    end

    # Clear Reminder collection.
    def clear!
      @rem = []
    end

    # Reminder collection to string.
    def to_rem
      a = [];
      @rem.each { |e| a << @r[e].to_rem }
      return a.join("\n")
    end
    
    # Write Reminder collection to file.
    # +h[:append]+ append. (default: write)
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
  
  # The Reminder object.
  class R
    # high level event hash
    attr_accessor :attr
    # Reminder +k+
    def initialize k
      @id = k
      @attr = {}
    end
    # Reminder event id.
    def id; @id; end
    # Reminder event hash to reminder string.
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
  # Get Reminder collection +k+.
  def self.[] k
    @@REM[k]
  end
  # All Reminder collections
  def self.keys
    @@REM.keys
  end
end
