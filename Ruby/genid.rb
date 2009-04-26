#!/usr/bin/env ruby -wKU

class GenID
  
  @@instance = nil
  
  @id = 0
  @result = ''
  @@count = 0
  
  @@chars = [
   'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
   'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
   'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
   '0', '1', '2', '3', '4', '5', '6', '7', '8',
   '9', '_', '-', '.', '~', '/'
  ]
  
  @@regex = /([^a-z0-9\_\-\.\~\/])/
  
  @@reserved = []
  
  def self.get(id)
    if @@instance.class != self
      @@instance = self.new
      @@instance.init
    end
    return @@instance.run(id)
  end
  
  def init
    
    @@count = @@chars.length
    
  end 
  
  def run(id)
    @id = id
    if(@id.class == String)
      self.strtoid()
    elsif(@id.is_a? Integer)
      self.idtostr()
    else
      "Need String or Integer"
    end
  end
  
  def strtoid() 
    @id.gsub!(@@regex, '')
    return @@chars.index(@id) if @id.length == 1
    
    start = 0;
    @id.split(//).each do |id|
      start = (start * @@count) + @@chars.index(id)
    end

    return start
  end
  
  def idtostr() 
    @result = ''
    self.fixID!
    
    idtostr!(@id)
    
    @result.reverse!
  end
  
  def idtostr!(num)
    if num < @@count && num >= 0
      num = 0 if num == @@count
      @result << @@chars[num]
    else
      flr = (num/@@count).floor
      res = num - (flr * @@count)
      res = 0 if res == @@count
      
      @result << @@chars[res]
      if(flr < @@count && flr >= 0)
        @result << @@chars[flr]
      else
        idtostr!(flr)
      end
    end
    
  end
  
  def fixID!
    if(@@reserved.include?(@id))
      @id += 1
    end
  end
end