require 'rubygems'
require 'mysql'
require 'classes/genid.rb'

class String
  def numeric?
    false
  end
end

class DataBase
  
  @@sql = nil
  
  def initialize
    @@sql = Mysql.new('localhost', 'root', '', 'links')
  end
  
  def add(url, id = false)
    url = @@sql.escape_string(url)
    
    if(id == false)
      id = self.next_id.to_i
      table = 'links'
      
      res = @@sql.query('SELECT id FROM ' + table + ' WHERE url=\'' + url + '\' LIMIT 1')
      if(res.num_rows != 0)
        return to_id res.fetch_row[0].to_i
        res.free
      end
    else
      table = 'custom'
      id = unique_id(id)
      if(id == "ID Taken")
        return id
      end
    end
       
    res = @@sql.query('INSERT INTO ' + table + ' (id,url) VALUES (\'' + id.to_s + '\',\'' + url + '\')')
    # if(res.num_rows != 0)
    #   return false
    # else
    if(id.is_a? Integer)
      return to_id id.to_i
    else
      return id.to_s
    end
    # end
    res.free
  end
  
  def open_item(table, id)
    res = @@sql.query('SELECT url FROM ' + table + ' WHERE id=\'' + id.to_s + '\' LIMIT 1')
    if(res.num_rows != 0)
      return res.fetch_row[0]
    else
      return false
    end
  end
  
  def open_all(id) 
    url = open_item('custom', id)
    unless url
      return open_item('links', GenID.get(id.to_s) + 1)
    else 
      return url
    end
  end
  
  def unique_id(id)
    if(id.is_a? Integer)
      strid = GenID.get(id.to_i)
      res = @@sql.query('SELECT id FROM custom WHERE id=\'' + strid + '\' LIMIT 1')
    else
      idint = GenID.get(id.to_s)+1
      res = @@sql.query('SELECT id FROM links WHERE id=' + idint.to_s + ' LIMIT 1')
    end
    
    if(res.num_rows == 0)
      return id
    else
      if(id.is_a? Integer)
        return unique_id(id.to_i+1)
      else
        return "ID Taken"
      end
    end
    
    res.free
  end
  
  def next_id()
    res = @@sql.query('SHOW TABLE STATUS LIKE \'links\'')
    return unique_id(res.fetch_row[10])
    res.free
  end
  
  def close
    @@sql.close
  end
  
  def to_id(id)
    GenID.get(id-1)
  end
  
end