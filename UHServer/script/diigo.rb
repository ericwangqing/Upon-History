require 'rubygems'
require 'rest_client'
require 'active_support'
#require 'json'
#require 'socksify'
#TCPSocket::socks_server = "127.0.0.1"
#TCPSocket::socks_port = 9050

RestClient.proxy = "http://127.0.0.1:8580"

response = RestClient.get 'http://ericwangqing:txwdjsw@api2.diigo.com/bookmarks?rows=1&sort=0&users=ericwangqing'
data = ActiveSupport::JSON.decode(response)
#data = JSON.parse(response)
puts response