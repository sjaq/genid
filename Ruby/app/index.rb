
  require 'rubygems'
  require 'sinatra'
  require 'classes/db.rb'
  require 'net/http'

  helpers do
    def valid_url?(url)
      if(url.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix))
        true
      else
        false
      end
    end
  
    def die(msg)
      @msg = msg
      throw :halt, [:erb, :error]
    end
  end

  get '/' do
    erb :index
  end

  post '/' do
    unless(valid_url? params[:link])
      die 'Giving a right url'
    else
      db = DataBase.new
  
      if(params[:code] == "")
        db.add(params[:link])
      else
        db.add(params[:link], params[:code])
      end
    end
  end

  get '/check/:id' do
    db = DataBase.new
    'check=' + db.unique_id(params[:id].to_s).to_s
  end


  get '/*' do
    db = DataBase.new
    link = db.open_all(params['splat'].to_s)
    if(link != false)
      redirect link
    else
      die "link not found" + link.to_s
    end
  end