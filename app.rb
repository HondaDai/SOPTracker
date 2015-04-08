require 'sinatra'
require 'json'

class JSONDatabase
  def initialize
    @database_path = "database.json"
    @data = File.read(@database_path) if File.exists?(@database_path)
    @data = "{}" if @data.nil? || @data == ""
    @data = JSON.parse(@data)
  end

  def data
    @data
  end

  def save(json_data = @data)
    File.open(@database_path, "w"){|f| f.write(json_data.to_json)}
  end 

  def run
    yield data
    save
  end
end

class AccessPoint

  attr_accessor :ssid, :dbm, :active_user, :bandwidth, :backbone_bandwidth, :lat, :long

  def initialize
    @ssid = ""
    @dbm = 0
    @active_user = 0
    @bandwidth = 0
    @backbone_bandwidth = 0
    @lat = 0
    @long = 0
  end

  def to_dict
    d = {}
    d["ssid"] = @ssid
    d["dbm"] = @dbm
    d["active_user"] = @active_user
    d["bandwidth"] = @bandwidth
    d["backbone_bandwidth"] = @backbone_bandwidth
    d["lat"] = @lat
    d["long"] = @long
    d
  end

  def from_dict(d)
    @ssid = d["ssid"]
    @dbm = d["dbm"]
    @active_user = d["active_user"]
    @bandwidth = d["bandwidth"]
    @backbone_bandwidth = d["backbone_bandwidth"]
    @lat = d["lat"]
    @long = d["long"]
  end

end

require 'socket'
public_ip = '140.112.27.43'
if Socket.ip_address_list.map{|x| x.ip_address}.include?(public_ip)
  set :bind, public_ip
end

get '/register' do
  db = JSONDatabase.new
  db.run { |data|
    aps = data["AccessPoint"] || []
    ap = AccessPoint.new
    ap.ssid = "HYHome"
    aps << ap.to_dict
    data["AccessPoint"] = aps
  } if db.data["AccessPoint"].empty?
  
  "register"
end

get '/enroll' do
  db = JSONDatabase.new
  return db.data["AccessPoint"].first.to_json
end