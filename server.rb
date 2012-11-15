#!/usr/bin/ruby
 
require 'sinatra'
require 'base64'
require 'uri'
require 'yaml'
require 'haml'

CONFIG = YAML.load_file( File.join( File.dirname(__FILE__), "config.yml" ) )

set :port, 80

get '/' do
  puts "Redirect to #{CONFIG['redirect_url']}"
  redirect CONFIG['redirect_url']
end
 
get '/accept' do
  puts "Accpet #{request.ip}"

  arp_result = `arp -a #{request.ip}`

  if mac = arp_result[/(([0-9a-f]{2}[:]){5}[0-9a-f]{2})/]
    puts "Allow #{request.ip} / #{mac}"
    `sudo iptables -t mangle -D internet -m mac --mac-source #{mac} -j RETURN`
    `sudo iptables -I internet 1 -t mangle -m mac --mac-source #{mac} -j RETURN`
    `sudo /usr/sbin/rmtrack #{request.ip}`

    #sleep(3)

    puts "Redirect to #{CONFIG['redirect_url']}"
    redirect CONFIG['redirect_url']

  end
end


not_found do
  puts "Render not_found:  #{request.ip}"
  haml :not_found
end
